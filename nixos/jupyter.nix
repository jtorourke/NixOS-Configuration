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
      numpy
      matplotlib
      scikitimage
      scikit-learn
      requests
      pandas
      scipy
    ]))

    (rWrapper.override {
      packages = with rPackages; [
        tidyverse
        tidyr
        tidyquant
        tidytable
        ggplot2
        dplyr
        IRkernel
        shiny
        caret
        plotly
        e1071
        knitr
        XML
        xgboost
        randomForest
      ];
    })

    julia
  ];

  # Automatically run jupyter when entering the shell.
  shellHook = ''
    R --vanilla -e 'IRkernel::installspec(user = TRUE)'
    julia -e 'import Pkg; Pkg.add("IJulia")'
    julia -e 'using IJulia; IJulia.installkernel("Julia")'
    jupyter lab
  '';
}
