{ pkgs ? import <nixpkgs> {} }:

let
  pythonPackages = pkgs.python312Packages;
in

pkgs.mkShell {
  buildInputs = with pythonPackages; [
    # Core Python and development tools
    pip
    virtualenv
    
    # Data analysis and visualization
    pandas
    matplotlib
    numpy
    pygal  # Used in data visualization chapters
    
    # Game development (Alien Invasion project)
    pygame
    
    # Web development (Learning Log project)
    django
    
    # Data visualization
    plotly  # Used in some examples
    
    # Web APIs (Hacker News API project)
    requests
    
    # Testing
    pytest
    
    # For working with JSON data
    python-json-logger
    
    # Jupyter notebooks (used in some chapters)
    jupyter
    ipython
    ipykernel
    
    # Additional utilities
    pillow  # Image processing (used with matplotlib)
    seaborn  # Statistical data visualization
    
    # For 3D visualization (if needed)
    pyopengl
  ];

  # Optional: For better matplotlib compatibility in some environments
  nativeBuildInputs = with pkgs; [
    pkg-config
    freetype
    libpng
  ];

  shellHook = ''
    # Set up matplotlib to use the Agg backend by default (useful in headless environments)
    export MPLBACKEND=Agg
    
    # Optional: Create a virtual environment if desired
    if [ ! -d "venv" ]; then
      echo "Creating virtual environment..."
      python -m venv venv
    fi
    
    # Optional: Activate virtual environment
    # source venv/bin/activate
    
    echo "Python Crash Course environment loaded!"
    echo "Available projects and their requirements:"
    echo "  - Alien Invasion (pygame)"
    echo "  - Data Visualization (matplotlib, plotly, pygal)"
    echo "  - Web Applications (Django)"
    echo "  - Data Analysis (pandas, numpy)"
    echo "  - APIs (requests)"
  '';
}
