return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "Cargo.lock" },
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				enable = true,
				typeHints = true,
				parameterHints = true,
			},
			check = {
				command = "clippy",
				extraArgs = { "--target-dir=./target/check" },
				allFeatures = true,
			},
      checkOnSave = true,
			diagnostics = {
				enable = true,
			},
			cargo = {
				allFeatures = true,
				buildScripts = {
					enable = true,
				},
			},
			--check = {
			--  overrideCommand = {
			--    "cargo",
			--    "clippy",
			--    "--workspace",
			--    "--message-format=json",
			--    "--all-targets",
			--    "--all-features",
			--  },
			--},
		},
	},
}
