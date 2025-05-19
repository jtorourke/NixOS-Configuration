{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs.python311Packages; [
    pandas
    scipy
    matplotlib
    numpy
    scikit-learn
    requests
    calysto
  ];

  shellHook = ''
    echo "This is a test!"
  '';
}
