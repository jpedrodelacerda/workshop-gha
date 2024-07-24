{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    systems,
  }:
    flake-utils.lib.eachSystem (import systems)
    (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = flake-utils.lib.flattenTree rec {
        serve = pkgs.writeShellApplication {
          name = "serve-book";
          runtimeInputs = [ pkgs.mdbook ];
          text = ''
            mdbook serve
          '';
        };
        build = pkgs.stdenv.mkDerivation {
          name = "book";
          src = ./.;
          nativeBuildInputs = [ pkgs.mdbook ];

          buildPhase = ''
            mdbook build -d $out
            '';
        };

        default = build;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          mdbook
        ];
      };
    });
}
