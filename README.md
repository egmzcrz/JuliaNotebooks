**All notebooks were tested on Julia v1.0.**

Plotting is done with gnuplot and its epslatex terminal. A minimal LaTeX installation with **epstopdf** package will do. If this package is missing and you're in a linux environment then just do the following.
```bash
sudo tlmgr update --self
sudo tlmgr install epstopdf
```

Also, to display the images directly on the notebook we are converting the tex output from the gnuplot terminal to a png image. We are using the common unix tools: **dvips** and **ghostscript**.

# Table of Contents

- **Ising.ipynb**: Ising 2D model on a rectangular, hexagonal and triangular lattice.
- **HardDisks.ipynb**: Measuring phase transition in a hard-disk fluid.
