{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixgl.url = "github:nix-community/nixGL";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
  };
  outputs =
    {
      self,
      nix-ros-overlay,
      nixgl,
      nixpkgs,
    }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nix-ros-overlay.overlays.default
            nixgl.overlays.default
          ];
        };
        inputPackages = [
          pkgs.nixgl.nixGLIntel
          pkgs.colcon
          (
            with pkgs.rosPackages.kilted;
            buildEnv {
              paths = [
                ros-core
                rviz2
                rqt
                rqt-gui
                rqt-gui-py
                rqt-common-plugins
                rqt-graph
                rqt-plot
                slam-toolbox
                turtlebot3-description
                turtlebot3-navigation2
                navigation2
                nav2-bringup
                nav2-amcl
                nav2-controller
                nav2-planner
                nav2-lifecycle-manager
              ];
            }
          )
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Personal ROS devenv";
          packages = inputPackages;
          env = {
            LD_LIBRARY_PATH =
              pkgs.lib.makeLibraryPath inputPackages + ":/run/opengl-driver/lib:/run/opengl-driver-32/lib";
            QT_PLUGIN_PATH = ""; # Fix qt library mismatch error
          };
          shellHook = ''
            alias rviz2="nixGLIntel rviz2"
          '';
        };
      }
    );
  nixConfig = {
    extra-substituters = [
      "https://ros.cachix.org"
      "https://attic.iid.ciirc.cvut.cz/ros"
    ];
    extra-trusted-public-keys = [
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      "ros:JR95vUYsShSqfA1VTYoFt1Nz6uXasm5QrcOsGry9f6Q="
    ];
  };
}
