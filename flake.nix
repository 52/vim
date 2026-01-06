{
  description = "A modern, minimal(ish) Vim distribution";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      inherit (builtins) attrValues;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        ## The Vim version.
        ##
        #@ String
        version = "9.1.2050";

        ## The Vim source.
        ##
        #@ Derivation
        src = pkgs.fetchFromGitHub {
          owner = "vim";
          repo = "vim";
          rev = "v${version}";
          hash = "sha256-d/fiDTvC1pAIvzs8kdO4tC7gQJz13feLPXFiUxXdoG0=";
        };

        ## The Vim package.
        ##
        #@ Package
        package = pkgs.vim-full.overrideAttrs (_: {
          inherit version src;
        });

        ## The Vim derivation.
        ##
        #@ Package
        vim = package.customize {
          vimrcConfig.customRC = ''
            set runtimepath^=${self}
          '';
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = attrValues { inherit vim; };
          shellHook = ''
            echo "Entering the 'github:52/vim' development environment"
            echo "Execute 'vim' or 'gvim' to open the build"
          '';
        };
      }
    );
}
