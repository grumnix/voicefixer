{
  # https://github.com/haoheliu/voicefixer
  description = "General Speech Restoration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonPackages = pkgs.python3Packages;

        voicefixer = pythonPackages.buildPythonPackage rec {
            pname = "voicefixer";
            version = "0.1.3";

            src = pkgs.fetchPypi {
              inherit pname version;
              sha256 = "sha256-QJAtHY/OKm+NI93uToYDhFDo+P1Bx+cd7rbaLNDa4hg=";
            };

            doCheck = false;

            propagatedBuildInputs = with pythonPackages; [
              librosa
              matplotlib
              scipy
              soundfile
              torch
              torchlibrosa
            ];
        };
      in
      {
        packages = {
          default = voicefixer;
          voicefixer = voicefixer;
        };
      });
}

