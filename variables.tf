
variable "release_name" {
	description = "The name of the overlay release. Used in metadata."
	type        = string
}
variable "release_namespace" {
	description = "Which namespace the release will call home. Used in metadata."
	type        = string
}
variable "release_values" {
	description = "Rendering context overrides for chart."
	type        = any
	default     = {}
}

variable "chart_notes" {
	description = "Rendered chart notes."
	type        = string
	default     = ""
}
variable "chart_metadata" {
	description = "Metadata for the fake chart being recorded."
	type        = object({
		name        = string
		home        = optional(string)
		sources     = optional(set(string))
		version     = string # semver
		description = string
		keywords    = optional(set(string))
		maintainers = optional(set(object({
			name = string
		})))
		icon        = optional(string)
		apiVersion  = optional(string, "v2") # TODO: Update this to v3.
		appVersion  = optional(string)
		kubeVersion = optional(string)
	})
}
variable "chart_lock" {
	description = "I have absolutely no idea what this is for."
	type        = string
	default     = ""
}
variable "chart_values" {
	description = "Default rendering context (values.yaml)."
	type        = any
	default     = {}
}
variable "chart_templates" {
	description = "The kustomization source files used for rendering."
	type        = set(string)
	default     = []
}
variable "chart_files" {
	description = "Source files for the chart that aren't templates."
	type        = set(string)
	default     = []
}

