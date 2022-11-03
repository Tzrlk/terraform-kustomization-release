# Generate and apply Kustomize output

data "kustomization_build" "Release" {
	path = path.module
	kustomize_options {
		enable_helm = true
		helm_path   = "helm"
	}
}
locals {
	Priorities = range(3)
	# Collect manifest ids and determine if the output needs to be sensitive.
	ManifestIds = [
		for priority in local.Priorities: {
			for id in data.kustomization_build.Release.ids_prio[priority]:
			id => regex("(?P<group>.*)/(?P<kind>.*)/.*/.*", id)
		}
	]
	Manifests   = [
		for priority in local.Priorities: {
			for id, addr in local.ManifestIds[priority]: id => (
				endswith(addr["kind"], "Secret")
				? sensitive(data.kustomization_build.Release.manifests[id])
				: data.kustomization_build.Release.manifests[id] )
		}
	]
}

# first loop through resources in ids_prio[0]
resource "kustomization_resource" "stage_0" {
	for_each = local.Manifests[0]

	manifest = each.value
}

# then loop through resources in ids_prio[1]
# and set an explicit depends_on on kustomization_resource.stage_0
resource "kustomization_resource" "stage_1" {
	for_each   = local.Manifests[1]
	depends_on = [ kustomization_resource.stage_0 ]

	manifest = each.value
}

# finally, loop through resources in ids_prio[2]
# and set an explicit depends_on on kustomization_resource.stage_1
resource "kustomization_resource" "stage_2" {
	for_each   = local.Manifests[2]
	depends_on = [ kustomization_resource.stage_1 ]

	manifest = each.value
}

