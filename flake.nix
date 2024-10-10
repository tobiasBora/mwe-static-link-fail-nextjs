{
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = let pkgs = import nixpkgs { inherit system; }; in {
        mwe = pkgs.buildNpmPackage rec {
          pname = "mwe";
          version = "1.0";
          src = ./.;
          npmDepsHash = "sha256-T7Dka5MsjOiTOMdlU5ZhP3mdgNnKnwZhqODWujqyPZ4=";
          npmPackFlags = [ "--ignore-scripts" ];
          buildPhase = ''
            npm run build
          '';
          installPhase = ''
            mkdir -p $out/share/mwe
            cp -r out/* $out/share/mwe
            mkdir -p $out/bin
            cat << EOF > $out/bin/mwe
            #!/usr/bin/env bash
            ${pkgs.http-server}/bin/http-server -i -c-1 $out/share/mwe
            EOF
            chmod +x $out/bin/mwe
          '';
        };
      };
    }) ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"] );
  };
}
