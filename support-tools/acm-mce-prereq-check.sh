#!/bin/bash
#
# Performs some install/upgrade pre-checks to look for/point out some common problems
# related to ACM's newly-introduced need for MCE as an underlying dependency.
#
# Relevant when installing ACM 2.5 or beyond, or when  upgrading from ACM 2.4 to
# ACM 2.5 or later.
#
# Primarily intended for use when installing or upgrading in a disconnected envionrment
# since that environment has some potential gotya's where a connected environment does
# not really require any special setup in the normal use case.
#
# Tested on RHEL 8.
#
# Requires (to be found in $PATH):
# - Bash version 4 (uses associative arrays)
# - oc
# - jq
# - standard utils: rm, mktemp, basename, etc.
#
# Blame: joeg-pro

needed="oc jq mktemp rm basename"

acm_olm_package="advanced-cluster-management"
acm_display_name="Advanced Cluster Management"
acm_short_name="ACM"
mce_olm_package="multicluster-engine"
mce_display_name="multicluster engine"
mce_short_name="MCE"
mce_standard_cat_src_name="redhat-operators"

# mce_standard_cat_src_name="abc-def"  # @XXX FOR TESTING


#===============
# Preliminaries
#===============

prereq_not_satisfied=0
# Check for Bash version >= 4 (for associative arrays)
if  [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
   >&2 echo "Error: This script requires Bash V4."
   prereq_not_satisfied=1
fi

# Check for the external tools we need.

for n in $needed; do
   where=$(command -v $n)
   if [[ $? -ne 0 ]]; then
      >&2 echo "Error: Required command \"$n\" not found."
      prereq_not_satisfied=1
   fi
done

if [[ $prereq_not_satisfied -eq 1 ]]; then
   exit 5
fi

jq="jq"
oc="oc"

# See if we can can do oc commands against the cluster.

$oc status > /dev/null
if [[ $? -ne 0 ]]; then
   >&2 echo "Error: Cannot do oc commands against the target cluster."
   exit 5
fi

# Clean up when we exit.
function cleanup_on_exit {
   if [[ -n "$tmp_dir" ]]; then
      rm -rf "$tmp_dir"
   fi
}
trap cleanup_on_exit EXIT

# Create a temp spot

me=$(basename "$0")
tmp_dir=$(mktemp -td "$me.XXXXXXXX")


#========================================
# Utility functions
# (Some copy-pasted from other tooling.)
#========================================

emit_dbg=${PRECHECK_DEBUG:-0}
function dbg() {
   if [[ $emit_dbg -ne 0 ]]; then
      >&2 echo -e "Dbg: $@"
   fi
}

function imsg() {
   echo -e "$@"
}

function wmsg() {
   >&2 echo -e "Warning: $@"
}

function emsg() {
   >&2 echo -e "Error: $@"
}

function parse_release_nr() {

   local release_nr="$1"

   # SSets the following variables as side effects:
   # - rel_x rel_y rel_z rel_xy

   local oldIFS=$IFS
   IFS=.
   local rel_xyz=(${release_nr%-*})
   rel_x=${rel_xyz[0]}
   rel_y=${rel_xyz[1]}
   rel_z=${rel_xyz[2]}
   IFS=$oldIFS

   rel_xy="$rel_x.$rel_y"
}

acm_op_is_installed=0
there_is_an_mch=0

#===============
# Global Arrays
#===============
# (NB: Using declare -gA requires Base 4.2 or better, but we'd rather just have a Bash
# V4 prereq without getting more specific.)

declare -A channels

#=====================================
# Info gathering and lookup functions
#=====================================

function get_pkg_manifests_for_pkg() {

   # This function retrieves all of the package manifest resources that provide a particular
   # package that are provided by Red Hat.  These resources can be used to find the catalog
   # sources that have the package and to learn other things about the packages.
   #
   # Fiiltering down from the complete list of PackageManifests is necessary because:
   # - The resource's name is the package which means multiple same-named resources
   #   exist if provided by multiple catalog sources, and in such a case which one
   #   you get from a "oc get packagemanifest <name>" is unpredicable.
   #
   # - The PackageManfiest does not have a label specifying the package name so
   #   selection by label is not possible.
   #
   # There is no naming authorty/claim proccess that globally reserves a package name.
   # So it could be that some other entitive publishes an MCE package (into some other
   # catalog) that has no relationship to "our" MCE.  So we limit our analysis to the
   # things we, as Red Hat, publish.
   #
   # We only pay attention to the PackageManifests in the openshift-marketplace namespace
   # because having them elsewhere doesn't realy work (exact symptoms/issues forgotten).

   local pkg_name="$1"

   local provider_rh="Red Hat"
   local pkg_manifest_cache="$tmp_dir/all-rhh-pkg-manifests.json"
   if [[ ! -f "$pkg_manifest_cache" ]]; then
      $oc -n openshift-config get packagemanifest \
         -l"catalog-namespace=openshift-marketplace" -o json \
         | $jq "[ .items[] | select(.status.provider.name==\"$provider_rh\") ]" \
         > "$pkg_manifest_cache"
   fi

   # if [[ $pkg_name == "multicluster-engine" ]]; then # @XXX FOR TESTING
   #   echo "[]"                                       # @XXX
   #   return                                          # @XXX
   # fi                                                # @XXX

   $jq "[ .[]      | select(.metadata.name==\"$pkg_name\") | . ]" $pkg_manifest_cache
   # This emits a JSON list of objects
}

function get_pkg_info() {

   # Determines, and "returns" as sife-effect vars, info about the default and other
   # channels found in a package.
   #
   # Side effect:
   # - Leaves pkg manifests in $tmp_dir/pkg-manifests.json but this will
   #   be overwritten by another invocation of this function.

   # @TODO: Rename to something more scoped than just the generic "get_pkg_info".

   local pkg="$1"

   # Output side effect vars:
   # default_channel
   # channels (associative array)

   local i k how_many c_name c_latest_vers

   channels=()

   get_pkg_manifests_for_pkg $pkg > "$tmp_dir/pkg-manifests.json"
   how_many=$($jq -r ". | length" "$tmp_dir/pkg-manifests.json")
   if [[ $how_many -eq 1 ]]; then
      dbg "Found exactly one PackageManifest for $pkg!"
      $jq  ".[0]" "$tmp_dir/pkg-manifests.json" > "$tmp_dir/the-pkg-manifest.json"
      default_channel=$($jq -r ".status.defaultChannel" "$tmp_dir/the-pkg-manifest.json")
      dbg "Default channel: $default_channel"
      $jq ".status.channels" "$tmp_dir/the-pkg-manifest.json" \
         | $jq "[ .[] | { name: .name, latestVersion: .currentCSVDesc.version } ]" \
         > "$tmp_dir/pkg-channels.json"
      how_many=$($jq -r ". | length" "$tmp_dir/pkg-channels.json")
      dbg "The package provides $how_many channels."
      for i in $(seq 0 $(( how_many - 1 )) ); do
         c_name=$($jq -r ".[$i].name" "$tmp_dir/pkg-channels.json")
         c_latest_vers=$($jq -r ".[$i].latestVersion" "$tmp_dir/pkg-channels.json")
         channels["$c_name"]="$c_latest_vers"
      done

      for k in "${!channels[@]}"; do
         dbg "Channel $k: ${channels[$k]}"
      done

   elif [[ $how_many -eq 0 ]]; then
      emsg "No PackageManifest found for $pkg."
      sug_ensure_pkg_in_mirror_catalog "$pkg"
      return 1
   else
      emsg "Multiple PackageManifests found for $pkg."
      sug_explain_multiple_pkg_ambiguity "$pkg"
      return 2
   fi
}

function determine_mce_rel_for_acm_rel() {

   # Determines the MCE release required by a given ACM release.
   #
   # @TODO: This will probably need updates for Stoloston.

   local acm_rel_xy="$1"
   local mce_rel_xy

   local mce_for_acm_25="2.0"
   # local mce_for_acm_25="9.9"  # @XXX FOR TESTING ONLY

   if [[ "$acm_rel_xy" == "2.5" ]]; then
      mce_rel_xy="$mce_for_acm_25"
   elif [[ "$acm_rel_xy" == "2.6" ]]; then
      mce_rel_xy="2.1"
   elif [[ "$acm_rel_xy" == "2.7" ]]; then
      mce_rel_xy="2.2"
   else
      emsg "This tool has not been updated to support pre-checks for $acm_display_name release $acm_rel_xy."
      exit 4
  fi
  echo "$mce_rel_xy"
}

function determine_channel_for_rel() {

   # Determine the OLM channel that provides bundles for the given x.y release.

   # TODO: This will have to change for Stolostron Engine.

   local pkg="$1"
   local rel_xy="$2"

   if [[ "$pkg" == "$acm_olm_package" ]]; then
      echo "release-$rel_xy"
   else
      echo "stable-$rel_xy"
   fi
}

function find_channel_for_release() {

   # Search the global channels array to find a channel that provides the specified
   # x.y. release. WWe search for it this way to try to minimize/avoid dependencies on
   # channel naming in the bulk of the logic.  (We do end up depending on channel
   # naming when providing problem-resolution suggestions, though).
   #
   # We assume at most one channel will supply bundles for a given x.y release, as that
   # is the current channel-management practice for ACM and MCE.

   local want_rel_xy="$1"
   local k latest_rel_on_chan
   local rel_x rel_y rel_z rel_xy

   for k in "${!channels[@]}"; do
      latest_rel_on_chan="${channels[$k]}"
      parse_release_nr "$latest_rel_on_chan"
      if [[ "$want_rel_xy" == "$rel_xy" ]]; then
        echo "$k"
        return
      fi
   done
   # Null stdout if we didn't find a channel that provides $want_rel_xy.
}

function checkk_for_mce_pkg_and_release() {

   # Determine the cooresponding MCE release that is required required by the specified
   # ACm release nr and verify that we have a package that provides it.

   local acm_rel_xy="$1"

   # (1) What MCE release are we looking for?

   local mce_rel_xy=$(determine_mce_rel_for_acm_rel $acm_rel_xy)
   imsg "The required release of the $mce_display_name operator package is release $mce_rel_xy."

   # (2) Is there an MCE package available?

   get_pkg_info $mce_olm_package
   if [[ $? -ne 0 ]]; then
      # Error msg and advise already blurted eg. re no or too-many MCE packages found.
      exit 4
   fi
   imsg "Ok: The $mce_display_name OLM operator package is available on the cluster."

   # (3) There is an MCE package, but does it have a channel that provides the needed x.y release?

   local mce_pkg_channel=$(find_channel_for_release "$mce_rel_xy")
   if [[ -z "$mce_pkg_channel" ]]; then
      emsg "The available $mce_short_name package doesn't have a channel that provides release $mce_rel_xy."
      sug_pkg_doesnt_have_right_release_channel "$mce_olm_package" "$mce_rel_xy"
      exit 4
   fi
   imsg "Ok: The available package has Channel $mce_pkg_channel as will be expected by $acm_short_name."
}

function get_mch_mce_sub_spec_annot() {

   # Gets the mce-subscription-spec annotation from the MCH, if one exists.

   # Uses $tmp_dir/mchs.json (assumed to be left around by earlier logic)

   annotations=$($jq ".items[0].metadata.annotations" "$tmp_dir/mchs.json")
   if [[ "$annotations" == "null" ]]; then
      dbg "The MCH has no metadata.annotations at all."
      return 1
   fi

   annot_name="installer.open-cluster-management.io/mce-subscription-spec"
   annot_val=$(echo "$annotations" | $jq -r ".[\"$annot_name\"]")
   if [[ "$annot_val" == "null" ]]; then
      dbg "The MCH does not have an mce-subscription-spec annotation."
      return 1
   fi

   echo "$annot_val"
}

function extract_mce_sub_spec_cat_src() {

   # Extracts the catalog source from an mce-subscription-spec annotation.

   local annot_val="$1"

   annot_cat_src=$(echo "$annot_val" | $jq -r ".source")
   if [[ "$annot_cat_src" == "null" ]]; then
      dbg "The mce-subscription-spec in the MCH does not specify a catalog source."
      return 1
   fi

   dbg "Catalog source specified by MCH annotation: $annot_cat_src"
   echo "$annot_cat_src"
}

#======================================================
# Functions that blurt problem-resolution suggestions.
#======================================================

function sug_ensure_pkg_in_mirror_catalog() {
   local pkg="$1"
   imsg ""
   imsg "Problem resolution suggestions:"
   imsg ""
   imsg "Problems like this most commonly occur when installing in a disconnected environment."
   imsg ""
   imsg "If you are installing in a disconnected environment:"
   imsg ""
   imsg "(1) Ensure that you include the package \"$pkg\" in your mirror catalog."
   imsg ""
   imsg "(2) Ensure that you have defined a CatalogSource resource in the openshift-marketplace"
   imsg "    namespace of your OCP cluster to make your mirror catalog available for OLM to use"
   imsg "    to find and install the packages."
}

function sug_explain_multiple_pkg_ambiguity() {
   local pkg="$1"
   imsg ""
   imsg "This error indicates that the $pkg package, marked as being provided by"
   imsg "Red Hat, can be found in multiple catalog sources on the cluster. This is unusal,"
   imsg "and the resulting ambiguity means this tool is not able to do any further pre-checks."
}

function sug_pkg_doesnt_have_right_release_channel() {
   local pkg="$1"
   local needed_rel="$2"

   local needed_channel_name=$(determine_channel_for_rel "$pkg" "$needed_rel")

   imsg ""
   imsg "Problem resolution suggestions:"
   imsg ""
   imsg "This error indicates that while the $pkg OLM package can be found in an OLM"
   imsg "catalog on the cluster, that package does not have an update channel that provides operator"
   imsg "bundles at the release $needed_rel level."
   imsg ""
   imsg "Problems like this most commonly occur when installing in a disconnected environment."
   imsg ""
   imsg "If you are installing in a disconnected environment and your mirror catalog is a partial"
   imsg "(sometimes called filtered or pruned) catalog rather than a mirror of the full catalog,"
   imsg "ensure that you filtering configuration includes the $needed_channel_name update channel"
   imsg "in the mirror catalog you are creating."
}

function sug_ensure_mch_has_mce_sub_annotation() {
   local cat_src="$1"
   local mch_ns="${2:-open-cluster-management}"
   local mch_name="${3:-hub}"
   imsg ""
   imsg "Note: The $mce_short_name package is not available in the standard Red Hat provided OLM"
   imsg "catalog, but rather is provided in a custom catalog."
   imsg ""
   imsg "Because of this, please ensure that you include the mce-scription-spec annotation"
   imsg "in your MulticlusterHub resource when you create it, as shown by the following example:"
   imsg
   cat <<EOF
   apiVersion: operator.open-cluster-management.io/v1
   kind: MultiClusterHub
   metadata:
      namespace: $mch_ns
      name: $mch_name
      annotations:
         installer.open-cluster-management.io/mce-subscription-spec: '{"source": "$cat_src"}'
   spec: {}

EOF
}

function sug_no_need_for_mce_sub_annotation() {
   local cat_src="$1"
   local mch_ns="${2:-open-cluster-management}"
   local mch_name="${3:-hub}"
   imsg ""
   imsg "Because the $mce_short_name package is available in the standard Red Hat provided OLM"
   imsg "catalog, no special configuration is required in your MulticlusterHub resource."
}

function sug_incorrect_mce_sub_annotation() {

   local mce_namespace="$1"
   local mce_name="$2"
   local mch_annot_cat_src="$3"
   local actual_cat_src="$4"
   local cat_src_not_needed="${5:-0}"

   imsg ""
   imsg "Problem resolution suggestions:"
   imsg ""
   imsg "This error indicates that the existing MCH resource has an mce-subscription-spec annotation"
   imsg "that is wrong. An install or upgrade will fail (stall) because the annotation will direct the"
   imsg "$acm_short_name operator to look for the needed $mce_short_name operator package in the $mch_annot_cat_src"
   imsg "catalog source but the package is not available from that catalog source."
   imsg "Rather is available from the $actual_cat_src catalog source."
   imsg ""
   imsg "The existing MCH resource is $mce_namespace:$mce_name."

   if [[ $cat_src_not_needed != "0" ]]; then
      imsg ""
      imsg "Moreover, since the package is available from a standard Red Hat provided catalog source,"
      imsg "there is no need to specify the annotation.  The $acm_short_name operator use that cata;pg spirce"
      imsg "by default."
      imsg ""
      imsg "To resolve this problem, before triggering the $acm_short_name upgrade, edit the existing MCH"
      imsg "resource and remove the source property from that annotation's value.  If the annotation"
      imsg "value consists of only the source property (typical), then delete the entire annotation."

   else

      imsg ""
      imsg "To resolve this problem, before triggering the $acm_short_name upgrade, edit the existing MCH"
      imsg "resource and update the source property in that annotation's value to specify the correct"
      imsg "catalog source name of \"$actual_cat_src\"."

   fi
}

function sug_imissing_mce_sub_annotation() {

   local mce_namespace="$1"
   local mce_name="$2"
   local cat_src="$3"

   imsg ""
   imsg "Problem resolution suggestions:"
   imsg ""
   imsg "This error indicates that the $mce_short_name package is available from a custom OLM catalog"
   imsg "but the existing MCH resource does not have a mce-subscription-spec annotation to identify"
   imsg "that catalog source. Without the annotation, an upgrade will fail (stall) because the"
   imsg "$acm_short_name operator will attempt to use a standard catalog rather than the custom catalog."
   imsg ""
   imsg "The existing MCH resource is $mce_namespace:$mce_name."
   imsg ""
   imsg "To resolve the problem, before triggering an upgrade, edit the existing MCH resource and"
   imsg "add an mce-subscription-spec annotation as shown in the following example:"
   imsg ""
   cat <<EOF
   metadata:
      annotations:
         installer.open-cluster-management.io/mce-subscription-spec: '{"source": "$cat_src"}'

EOF
}

function sug_unnnecessary_mce_sub_annotation() {

   local mce_namespace="$1"
   local mce_name="$2"
   imsg ""

   imsg "Additional information:"
   imsg ""
   imsg "This warning indicates that the existing MCH resource has an mce-subscription-spec annotation"
   imsg "but that annotation is not needed. An install or upgrade would succeed, but we recommend that"
   imsg "you remove the unnecessary annotation to simplify the configuration of your MCH resource."
   imsg ""
   imsg "The existing MCH resource is $mce_namespace:$mce_name."
   imsg ""
   imsg "To eliminate this warning, edit the existing MCH resource and remove the source property in that"
   imsg "annotation's value since it's not necessary. If the annotation's value consists of species only"
   imsg "the source property (typical), then delete the entire annotation."

}


#===========
# Main Flow
#===========

#------------------------------------------------------------------
# Determine starting point: is this a fresh install or an upgrade?
#------------------------------------------------------------------

# See if the ACM operator is installed.  THere are a couple of reasonable ways to skin
# this cat, but we'll do it by looking for a CSV that identifies itself as being from
# our operatorpackage.  Alas, the CSV doesn't have a label that makes this easy.

# So we get all of the CSVs and then filter down to those that match our operator's
# CSV-naming convention.  This is easier to do (and safe since the dependency on naming
# is under our eng-team control) than trying to use the operatorframework.io/properties
# annotation to filter by package name.
#
# If we find more than one, give up as that would indicate eg. an upgrade is in progress
# and we don't know how to handle such a situation.

$oc get ClusterServiceVersion --all-namespaces -o json \
   | $jq  "[ .items[] | select(.metadata.name | startswith(\"$acm_olm_package.\")) | . ]" \
   > "$tmp_dir/acm-csvs.json"

how_many=$($jq -r ". | length" "$tmp_dir/acm-csvs.json")
if [[ $how_many -eq 0 ]]; then
   imsg "The $acm_display_name operator is not installed."
   acm_op_is_installed=0
elif [[ $how_many -eq 1 ]]; then
   acm_op_is_installed=1
else
   emsg "Multiple instances of the $our_dipslay_name operator CSV were found."
   exit 3
fi

if [[ $acm_op_is_installed -eq 1 ]]; then
   imsg "The $acm_display_name operator is installed."
   acm_op_namespace=$($jq -r ".[0].metadata.namespace" "$tmp_dir/acm-csvs.json")
   acm_op_version=$($jq -r ".[0].spec.version" "$tmp_dir/acm-csvs.json")
   dbg "The operator ins installed in namespace: $acm_op_namespace"
   dbg "The version of the IInstalled operator: $acm_op_version"
fi

# If the aCM operator is already installed, check if its version is at or higher that
# ACM 2.4 at which point MCE considerations apply in upgrading.  (I suppose we could
# do this checking within the MCH resource once we determine if one is there, but its
# probably equivalent for our purposes to check the version of the operator.)

if [[ $acm_op_is_installed -eq 1 ]]; then
   parse_release_nr $acm_op_version
   if [[ $rel_x -ne 2 ]] || [[ $rel_y -lt 4 ]]; then
      imsg ""
      imsg "The installed operator is earlier than release 2.4."
      imsg "No $mce_short_name-related considerations apply yet."
      exit 0
   fi
fi

# If here, there are three possiblities now that affect further checking we do:
#
# (1) AThe CM operator is not installed at all, which by definition means tthat there is
#     no existing MCH resource either.  This is a completely greenfield install.
#
# (2) The ACM operator is installed, but no MCH resource was created, or if it was created
#     it has been since deleted.  (Unusual, but possible)
#
# (3) The ACM operator is installed and we have an MCH.

# Figoure out what case we have on our hands.

if [[ $acm_op_is_installed -eq 0 ]]; then
   # No ACM operator => no MCE, by definition.
   there_is_an_mch=0
else

   # The ACM operator was installed in $acm_op_namespace, so if there is an MCH
   # resource we will find it in that namespace.  Lets look.

   $oc -n "$acm_op_namespace" get MultiClusterHub -o json > "$tmp_dir/mchs.json"
   how_many=$($jq -r ".items | length" "$tmp_dir/mchs.json")
   if [[ $how_many -eq 0 ]]; then
      imsg "There is no MulticlusterHub (MCH) resource."
      there_is_an_mch=0
   elif [[ $how_many -eq 1 ]]; then
      mch_namespace="$acm_op_namespace"
      mch_name=$($jq -r ".items[0].metadata.name" "$tmp_dir/mchs.json")
      imsg "There is a MulticlusterHub (MCH) resource: $mch_namespace:$mch_name"
      there_is_an_mch=1
   else
      emsg "Multiple MultiClusterHub instances were found."
      exit 3
   fi
fi


# The following code handle the isntall vs. upgrade scenario separately. This approach was chosen
# to make the code easier to develop incrementally and maybe easier to read/follow.  While
# most code duplication has been avoided by breaking things into functions above, this appraoch
# does still result in some duplicated code sequences.  Maybe more factoring is warranted.

if [[ $there_is_an_mch -eq 0 ]]; then

   #------------------------
   # Install scenario
   #------------------------

   if [[ $acm_op_is_installed -eq 0 ]]; then

      dbg "Fresh install scenario."

      get_pkg_info $acm_olm_package
      if [[ $? -ne 0 ]]; then
         # Error msg and advise already blurted.
         exit 4
      fi
      imsg "Ok: The $acm_display_name OLM operator package is available on the cluster."

      # Since this will be a fresh install, we assume we're installing the latest release
      # off the default channel.  (If customization is wanted, we'll have to add optionis
      # to allow a different release to be specified.)

      acm_rel_to_install="${channels[$default_channel]}"
      parse_release_nr $acm_rel_to_install
      acm_rel_xy="$rel_xy"
      imsg "Assuming release $acm_rel_xy of $acm_short_name is to be installed."

   else

      dbg "Complete the install scanrio (operator installed already, but no MCH)."

      parse_release_nr "$acm_op_version"
      if [[ $rel_x -eq 2 ]] && [[ $rel_y -le 4 ]]; then
         imsg ""
         imsg "It appears that an $acm_short_name release $rel_xy installation is in progress."
         imsg "No $mce_short_name-related considerations apply yet."
         exit 0
      fi

      acm_rel_xy="$rel_xy"
      imsg "Assuming the install of release $acm_rel_xy of $acm_short_name is being completed."
   fi

   # Check that we can find the MCE release required by the ACM release.

   checkk_for_mce_pkg_and_release "$acm_rel_xy"

   # If we're here, its good news!  We have an ACM package available, we have an MCE package
   # available, and the MCE package has teh channnel that the ACM installer will expect when
   # subscribing to/installing MCE under the covers.
   #
   # All that's left to do is some advisce. If the available MCE package is coming from some non-
   # stnadard catalog source, let's point out the need for the mce-subscription annotation in the
   # MCH to point ACM to that catalog source.

   get_pkg_manifests_for_pkg "$mce_olm_package" > "$tmp_dir/mce-pkg-manifests.json"
   mce_cat_src=$($jq -r ".[0].status.catalogSource" "$tmp_dir/mce-pkg-manifests.json")
   # mce_cat_src="my-catsrc" # @XXX FOR TESTING
   dbg "MCE CatalogSource is $mce_cat_src."

   if [[ "$mce_cat_src" != "$mce_standard_cat_src_name" ]]; then
      sug_ensure_mch_has_mce_sub_annotation "$mce_cat_src"
   else
      imsg "Ok: The $mce_short_name package is available in the standard Red Hat provided OLM catalog."
      sug_no_need_for_mce_sub_annotation
   fi

else

   #-------------------
   # Upgrade scenario
   #-------------------

   dbg "Upgrade scenario."

   # NB: acm_op_version and acm_op_namespace were determined above.

   # Since ACM is already installed, this will be an upgrade from the installed x.y
   # release to the x.(y+1) release.  Verify that the ACM package is available and
   # that it provides th x.(y+1) release.

   parse_release_nr "$acm_op_version"
   installed_acm_rel_xy="$rel_x.$rel_y"
   next_rel_y=$((rel_y + 1))
   acm_rel_xy="$rel_x.$next_rel_y"

   imsg "Assuming this is an upgrade of $acm_short_name from release $installed_acm_rel_xy to release $acm_rel_xy."

   get_pkg_info $acm_olm_package
   if [[ $? -ne 0 ]]; then
      # Error msg and advise already blurted.
      exit 4
   fi
   imsg "Ok: The $acm_display_name OLM operator package is available on the cluster."

   # Check that the available ACM package provides the upgrade-to release.

   acm_pkg_channel=$(find_channel_for_release "$acm_rel_xy")
   if [[ -z "$acm_pkg_channel" ]]; then
      emsg "The available $acm_short_name package doesn't have a channel that provides release $acm_rel_xy."
      sug_pkg_doesnt_have_right_release_channel "$acm_olm_package" "$acm_rel_xy"
      exit 4
   fi
   imsg "Ok: The available package has Channel $acm_pkg_channel."

   # Check that we can find the MCE release required by the ACM release.

   checkk_for_mce_pkg_and_release "$acm_rel_xy"

   # So far, so good.  Now we take a look at the existing MCH resource in light of the
   # catalog source required to get MCE and provide advice on any changes needed in
   # the MCH and its mce-subscription-spec annotation.

   get_pkg_manifests_for_pkg "$mce_olm_package" > "$tmp_dir/mce-pkg-manifests.json"
   mce_cat_src=$($jq -r ".[0].status.catalogSource" "$tmp_dir/mce-pkg-manifests.json")
   # mce_cat_src="my-catsrc" # @XXX FOR TESTING
   dbg "MCE CatalogSource is $mce_cat_src."

   if [[ "$mce_cat_src" != "$mce_standard_cat_src_name" ]]; then
      imsg "The $mce_short_name package is available from a custom catalog source ($mce_cat_src)."
      annot_is_needed=1
   else
      imsg "The $mce_short_name package is available from the standard catalog source."
      annot_is_needed=0
   fi

   # Determine if annotation is present and if so what catalog source it currentlly specifies.
   # Note: At present, we're going to merge some subcases and define "annotation_is_present"
   # as the more particular "there is an anootation, and it spefies a catalog source".  We
   # might have to unmerge those cases for more precise guidance?

   annot_is_present=0
   annot_val=$(get_mch_mce_sub_spec_annot)
   if [[ -n "$annot_val" ]]; then
      annot_cat_src=$(extract_mce_sub_spec_cat_src "$annot_val")
      if [[ -n "$annot_cat_src" ]]; then
         dbg "Catalog source in MCH mce-subscription-spec annotation: $annot_cat_src"
         annot_is_present=1
      else
         dbg "MCH has a mce-subscription-spec annotation but it doesn't specify a catalog source."
      fi
   else
      dbg "No mce-subscription-spec annotation was found in the MCH."
   fi

   # We know if the annotation is required or not, if its there (and specifies a catalog source)
   # or not, and if there what catalog source it specifies.  Provide suggests for each of the
   # possible cases.

   if [[ $annot_is_needed -eq 0 ]]; then
      if [[ $annot_is_present -eq 0 ]]; then
         imsg "Ok: There is no mce-subscription-spec annotation in the MCH as it's not needed."
         imsg ""
         imsg "All pre-checks are completed successfully."
      else
         if [[ "$annot_cat_src" == "$mce_cat_src" ]]; then
            wmsg "An unnecessary mce-subscriont-spec annotation is present in the MCE resource."
            sug_unnnecessary_mce_sub_annotation "$mch_namespace" "$mch_name"
         else
            emsg "An incorrect (and unnecessary) mce-subscriont-spec annotation is present in the MCH resource."
            sug_incorrect_mce_sub_annotation "$mch_namespace" "$mch_name" \
               "$annot_cat_src" "$mce_cat_src" "1"
         fi
      fi
   else
      if [[ $annot_is_present -eq 1 ]]; then
         if [[ "$annot_cat_src" == "$mce_cat_src" ]]; then
            imsg "Ok: A correct mce-subscription-spec annotation is present in the MCH resource."
            imsg ""
            imsg "All pre-checks are completed successfully."
         else
            emsg "The mce-subscriont-spec annotation is the MCH resource is incorrect."
            sug_incorrect_mce_sub_annotation "$mch_namespace" "$mch_name" \
               "$annot_cat_src" "$mce_cat_src" "0"
         fi
      else
         emsg "The MCH resource is missing a required mce-subscriont-spec annotation."
         sug_imissing_mce_sub_annotation "$mch_namespace" "$mch_name" "$mce_cat_src"
      fi
   fi
fi

exit 0

