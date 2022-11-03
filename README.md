# Terraform Kustomization Release

Allows easy deployment of kustomizations that also pretend to be helm
releases. With kustomize helm features, this may actually still contain helm
releases.

https://registry.terraform.io/providers/kbst/kustomization/latest/docs

# Goals

* kustomization overlay with sane defaults.
* Deployment of rendered manifests (submodule?)
* Render manifests to filesystem.
* Synth helm release manifest secret.

