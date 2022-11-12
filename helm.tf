# Synth helm release secret

locals {
	// Will need to do something extremely sketchy to make any of this metadata
	// legit. Likely a script to query all the other releases and reproduce them
	// with a for_each below.
	release_version  = 0
	release_first_deployed = timestamp()
}

resource "kustomization_resource" "helm_release" {
	content = jsonencode({
		metadata = {
			namespace = var.release_namespace
			name      = "sh.helm.release.v1.${var.release_name}.v${local.release_version}"
		}
		type = "helm.sh/release.v1" # using v1 since I don't have a v2 example to hand.
		data = base64encode(base64gzip(jsonencode({
			name      = var.release_name
			namespace = var.release_namespace
			version   = local.release_version
			info      = {
				first_deployed = local.release_first_deployed
				last_deployed  = timestamp()
				deleted        = ""
				description    = "Install complete" # status description, last status?
				status         = "installed" # status
				notes          = var.chart_notes
			}
			chart     = {
				metadata  = var.chart_metadata
				lock      = var.chart_lock
				values    = yamlencode(var.chart_values)
				templates = [
					for name in var.chart_templates : {
						name = trimprefix(name, path.root)
						data = filebase64(name)
					}
				]
				files     = [
					for name in var.chart_files : {
						name = trimprefix(name, path.root)
						data = filebase64(name)
					}
				]
			}
			config    = yamlencode(var.release_values)
			manifest  = join("\n---\n", values(data.kustomization_build.release.manifests))
		})))
	})
}
