# Generate and apply Kustomize output

data "kustomization_build" "release" {
	path = path.module
	kustomize_options {
		enable_helm = true
		helm_path   = "helm"
	}
}
locals {
	priorities = range(3)
	# Collect manifest ids and determine if the output needs to be sensitive.
	manifest_ids = [
		for priority in local.priorities: {
			for id in data.kustomization_build.release.ids_prio[priority]:
			id => regex("(?P<group>.*)/(?P<kind>.*)/.*/.*", id)
		}
	]
	manifests   = [
		for priority in local.priorities: {
			for id, addr in local.manifest_ids[priority]: id => (
				endswith(addr["kind"], "Secret")
				? sensitive(data.kustomization_build.release.manifests[id])
				: data.kustomization_build.release.manifests[id] )
		}
	]
}

# first loop through resources in ids_prio[0]
resource "kustomization_resource" "stage_0" {
	for_each = local.manifests[0]

	manifest = each.value
}

# then loop through resources in ids_prio[1]
# and set an explicit depends_on on kustomization_resource.stage_0
resource "kustomization_resource" "stage_1" {
	for_each   = local.manifests[1]
	depends_on = [ kustomization_resource.stage_0 ]

	manifest = each.value
}

# finally, loop through resources in ids_prio[2]
# and set an explicit depends_on on kustomization_resource.stage_1
resource "kustomization_resource" "stage_2" {
	for_each   = local.manifests[2]
	depends_on = [ kustomization_resource.stage_1 ]

	manifest = each.value
}

