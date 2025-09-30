return {
	cmd = { "tofu-ls", "serve" },
	filetypes = { "terraform" },
	get_language_id = function(_, filetype)
		if filetype == "terraform" then
			return "opentofu"
		end
		if filetype == "terraform-vars" then
			return "opentofu-vars"
		end
		return filetype
	end,
	root_markers = { ".terraform", ".git" },
}
