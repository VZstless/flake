{ config, inputs, ... }:

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

      # backup related
      backup = false;
      writebackup = false;
      updatetime = 300;

      # char format & ignoring
      wildignore = [ "*.a" "*.o" "*.jar" ".so" "pycache" ];
      list = true;
      listchars = { space = "_"; tab = ">~"; };
      formatoptions = { n = true; j = true; t = true; };

      cursorline = true;
      expandtab = true;
    };

    globals.mapleader = " ";

    # define a command to print git blame for each line
    extraConfigLua = ''
      vim.api.nvim_create_user_command('GitBlameLine', function()
        local line_number = vim.fn.line('.')
        local filename = vim.api.nvim_buf_get_name(0)
        print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
      end, { desc = 'Print the git blame for the current line' })
    '';

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

      lsp = {
        servers.nixd = {
          enable = true;
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }";
              };
              formatting = {
                command = [ "nixfmt" ];
              };
              options = {
                nixos = {
                  expr = ''(builtins.getFlake (toString ./.)).nixosConfigurations.${config.networking.hostName}.options'';
                };
              };
            };
          };
        };
      };
      
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
