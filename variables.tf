
variable "release_name" {
	description = "The name of the overlay release. Used in metadata."
	type        = string
}
variable "release_namespace" {
	description = "Which namespace the release will call home. Used in metadata."
	type        = string
}

variable "chart_data" {
	description = "Metadata for the fake chart being recorded."
	type        = object({
		metadata = object({
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
			apiVersion  = optional(string, "v2")
			appVersion  = optional(string)
			kubeVersion = optional(string)
		})
		lock = string
		templates = set(object({ # basically source files.
			name = string # template filename
			data = string # base64 encoded template content
		}))
		values = map(any) # default rendering context.
		files = set(object({ # source files that aren't templates.
			name = string # filename
			data = string # base64 encoded
		}))
	})
}
