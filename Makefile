#!/usr/bin/env make

.ONESHELL:
.DELETE_ON_ERROR:
.ALWAYS:
.PHONY: \
	init \
	validate \
	

.terraform/:
	mkdir -p ${@}

init: .terraform.lock.hcl
.terraform.lock.hcl: \
		main.tf
	terraform init \
		--no-backend

validate: .terraform/validate.done
.terraform/validate.done: \
		.terraform.lock.hcl \
		$(wildcard *.tf)
	terraform validate && \
	touch ${@}

plan: terraform.tfplan
terraform.tfplan: \
		.terraform/validate.done
	terraform plan \
		--out=${@}

.build/:
	mkdir -p ${@}

render: .build/**/*.yaml
.build/**/*.yaml: \
		kustomization.yaml \
		$(wildcard charts/**/*) \
		| .build/
	rm -f .build/* && \
	kustomize build \
		--enable-helm \
		--output .build/

