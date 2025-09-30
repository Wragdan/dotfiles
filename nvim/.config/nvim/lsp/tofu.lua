return {
	cmd = { "tofu-ls", "serve" },
  filetypes = { "terraform" },
  get_language_id = function(_, _)
      return 'opentofu'
  end,
  root_markers = { '.terraform', '.git' },
}
