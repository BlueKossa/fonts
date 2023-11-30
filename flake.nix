{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.monaspace = pkgs.stdenvNoCC.mkDerivation {
          name = "monaspace-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Monaspace.zip";
            sha256 = "sha256-tvlXseoScqB6rlzWaqArLd7n1i1+uElywmMoxZTIdoI=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/opentype/
          '';
          meta = { description = "Monaspace NF"; };
        };
      });
}
