{ inputs, ... }:

{
  imports = [ inputs.nixvim.nixosModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    colorschemes.catppuccin.enable = true;

    opts = {
      # line numbers & width
      number = true;
      relativenumber = true;
      shiftwidth = 2;


    };

    globals.mapleader = " ";

    
    plugins = {
      lualine.enable = true;
      treesitter.enable = true;
      fzf-lua = {
        enable = true;
	settings = {
	  fzf_colors = true;
	};
      };
      mini-completion.enable = true;
      quicker.enable = true;
      lspconfig.enable = true;
      
      gitsigns = {
        enable = true;
	settings = {
          signs = {
            add          = { text = "┃"; };
            change       = { text = "┃"; };
            delete       = { text = "_"; };
            topdelete    = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked    = { text = "┆"; };
          };
          signs_staged = {
            add          = { text = "┃"; };
            change       = { text = "┃"; };
            delete       = { text = "_"; };
            topdelete    = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked    = { text = "┆"; };
          };
          signs_staged_enable = true;
          signcolumn = true;
            numhl      = false;
            linehl     = false;
            word_diff  = false;
            watch_gitdir = {
            follow_files = true;
          };
          auto_attach = true;
          attach_to_untracked = false;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
            ignore_whitespace = false;
            virt_text_priority = 100;
            use_focus = true;
          };
          current_line_blame_formatter = "<author>, <author_time>:%R - <summary>";
          sign_priority = 6;
          update_debounce = 100;
          max_file_length = 40000;
          preview_config = {
            style = "minimal";
            relative = "cursor";
            row = 0;
            col = 1;
          };
        };
      };
    };
  };
}
