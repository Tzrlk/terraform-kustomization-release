terraform {
	required_version = ">= 0.12"
	required_providers {

		kustomization = {
			source  = "kbst/kustomization"
			version = "~> 0.9.0"
		}

	}
}

