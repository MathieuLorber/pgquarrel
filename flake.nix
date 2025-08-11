{
  description = "pgquarrel - PostgreSQL database schema comparison tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devbox.url = "github:jetify-com/devbox";
  };

  outputs = { self, nixpkgs, devbox }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.packages.${system}.pgquarrel;
          
          pgquarrel = pkgs.stdenv.mkDerivation rec {
            pname = "pgquarrel";
            version = "0.7.0";
            
            src = ./.;
            
            nativeBuildInputs = with pkgs; [
              cmake
              pkg-config
            ];
            
            buildInputs = with pkgs; [
              postgresql_16
              gettext
            ];
            
            cmakeFlags = [
              "-DCMAKE_PREFIX_PATH=${pkgs.postgresql_16}"
            ];
            
            meta = with pkgs.lib; {
              description = "A program that compares PostgreSQL database schemas (DDL)";
              homepage = "https://github.com/eulerto/pgquarrel";
              license = licenses.bsd3;
              maintainers = [];
              platforms = platforms.unix;
            };
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devbox.lib.${system}.mkShell {
            config = ./devbox.json;
            
            # Additional packages for development
            packages = with pkgs; [
              postgresql_16
              gcc
              gnumake
            ];
            
            shellHook = ''
              echo "pgquarrel development environment"
              echo "Build with: cmake -DCMAKE_PREFIX_PATH=${pkgs.postgresql_16} . && make"
            '';
          };
        });
    };
}