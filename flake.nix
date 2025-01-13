{
  description = "Dash to panel with win 11 alike theme.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "gnome-shell-extension-dash-to-panel-win11";
          extensionUuid = "dash-to-panel@makindotcc.github.com";
          src = ./.;
          meta = with pkgs.lib; {
            description = "A fork of dash-to-panel with a theme similar to win 11.";
            license = licenses.gpl2;
          };
          nativeBuildInputs = with pkgs; [ buildPackages.glib ];
          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/gnome-shell/extensions/
            cp -r -T . $out/share/gnome-shell/extensions/dash-to-panel@makindotcc.github.com
            runHook postInstall
          '';
        };
        defaultPackage = self.packages.${system}.default;
      }
    );
}
