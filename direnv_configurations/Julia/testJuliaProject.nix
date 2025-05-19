{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.julia_19-bin ];

  shellHook = ''
    # Configure isolated Julia environment
    export JULIA_DEPOT_PATH="$PWD/.julia_depot"
    export JULIA_PROJECT="$PWD"

    # List of required packages (including stdlib for completeness)
    packages=(
      "DataFrames"
      "DataFramesMeta"
      "Statistics"
      "Plots"
      "CSV"
      "Random"
      "Test"
    )

    # Initialize project if none exists
    if [ ! -f Project.toml ]; then
      julia -e 'using Pkg; Pkg.activate("."); Pkg.initialize()'
    fi

    # Install packages sequentially
    for pkg in "''${packages[@]}"; do
      echo "Adding package: $pkg"
      julia -e "using Pkg; Pkg.activate(\".\"); Pkg.add(\"$pkg\")"
    done

    # Explicitly instantiate environment
    julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
  '';
}
