with import <nixpkgs> {};

mkShell {
  buildInputs = [
    # Defines a python + set of packages.
    (python3.withPackages (ps: with ps; with python3Packages; [
      jupyter
      jupyterlab
      jupyterhub
      jupyterlab-widgets
      ipython
      ipython-genutils
      calysto
      nbformat

      # Uncomment the following lines to make them available in the shell.
      numpy
      matplotlib
      scikitimage
      scikit-learn
      requests
      pandas
      scipy
    ]))
  ];

  # Automatically run jupyter when entering the shell.
  shellHook = "jupyter lab";
}
