# Synth helm release secret

locals {
	helm_release = {
		name      = var.name
		namespace = var.namespace
		version   = var.version # the release count.
		info      = {
			first_deployed = "yyyy-MM-dd'T'hh:mm:ss.n'Z'"
			last_deployed  = "yyyy-MM-dd'T'hh:mm:ss.n'Z'"
			deleted        = ""
			description    = "Install complete" # status description, last status?
			status         = "superceded" # status
			notes          = "" # readme content.
		}
		chart     = var.chart   # chart.yaml
		config    = var.context # rendering input config (values.yaml).
		manifest  = "" # All deployed yaml. join all the manifests together?
	}
}

resource "kustomization_resource" "helm_release" {
	content = jsonencode({
		metadata = {
			name = "sh.helm.release.v1.${var.release_name}.v${var.release_version}"
		}
		# using v1 since I don't have a v2 example to hand.
		type = "helm.sh/release.v1"
		data = base64encode(base64gzip(jsonencode({

		})))
	})
}
