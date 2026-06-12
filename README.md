# Personal Nix-based ROS devenv

Based on nix-ros-overlay, this is a personal devenv used for ROS2 Kilted development. Includes `rqt`, `gz` (ignition), `nav2`, `amend-cmake`, `turtle`, `slam`, `rviz2` and `ros` packages from the ros flake, among some other prerequisites for building packages.

### Structure

```
.
├── flake.nix                  # Main flake
├── justfile                   # (WIP) Convenience commands
├── profiles/
│   ├── dev                    # Dev profile directory to prevent gc
├── ros-playground/            # Sandbox as a submodule
│   ├── src/                   
│       ├── <package-name>/    # Packages
└── <submodule-name>/          # For any future projects
```

### Improvements

There are a couple of improvements that could probably be made:
 - Building submodule packages directly from the root devenv
 - Directly entering a devshell with ROS2 underlay & the local overlay from submodules
 - Storing the submodules/projects in a seperate dir (`projects/` or something)
