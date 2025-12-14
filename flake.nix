{
  description = "FHS env for building LineageOS (x86_64-linux, /theloop/lineage)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      fhsBase = pkgs.buildFHSEnv {
        name = "lineageos-fhs-env";
        targetPkgs =
          p: with p; [
            git
            git-repo
            bc
            bison
            flex
            gperf
            ncurses
            python3
            unzip
            zip
            rsync
            wget
            xz
            zlib
            ccache
            openjdk11
            which
          ];
        runScript = "env";
      };
    in
    {
      apps.${system}.lineageos-fhs = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "lineageos-fhs" ''
            set -e

            LINEAGE_ROOT="/theloop/lineage"

            if [ ! -d "$LINEAGE_ROOT" ]; then
              echo "Error: $LINEAGE_ROOT not found!" >&2
              exit 1
            fi

            # Use the env wrapper to run bash with init-file
            exec ${fhsBase}/bin/lineageos-fhs-env bash --init-file <(echo "
              cd '$LINEAGE_ROOT'
              export USE_CCACHE=1
              export CCACHE_COMPRESS=1
              export CCACHE_DIR="$LINEAGE_ROOT/.ccache"
              export JAVA_HOME=${pkgs.openjdk11}
              export ANDROID_JAVA_HOME=${pkgs.openjdk11}
              source build/envsetup.sh
              croot
            ")
          ''
        );
      };
    };
}
