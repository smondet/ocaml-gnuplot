# Gnuplot-OCaml - Simple interface to Gnuplot

---------------------------------------------------------------------------

Gnuplot-OCaml provides a simple interface to [Gnuplot](http://www.gnuplot.info)
from [OCaml](http://www.ocaml.org).  The API supports only 2D graphs and was
inspired by [FnuPlot](https://github.com/fsprojects/FnuPlot).

## Installation

From [OPAM](http://opam.ocaml.org)

    $ opam install gnuplot

From Source

    $ make
    $ make install

**NOTE**: For a persistent X11 terminal add  `set term x11 persist` to your
`.gnuplot` file in your home directory.

## Usage

### Documentation

The API-documentation of this distribution can be built with `make doc`.
It can also be found [online](http://ogu.bitbucket.io/gnuplot-ocaml/api/).

### Examples

This simple example

```ocaml
module Gp = Gnuplot

let () =
  let gp = Gp.create () in
  Gp.plot_many gp ~range:(Gp.Range.XY (-10., 10., -1.5, 1.5))
   [ Gp.Series.lines_func  "sin(x)" ~title:"Plot a line" ~color:`Blue
   ; Gp.Series.points_func "cos(x)" ~title:"Plot points" ~color:`Green ];
  Gp.close gp
```

generates the following plot:

![Simple Plot](./assets/simple_plot.png)

For more examples please refer to the `examples`-directory of this
distribution.  You can build the examples with jbuilder, e.g.

```
$ dune build examples/gbm_paths.exe
```

Running

```
$ dune exec examples/gbm_paths.exe
```

displays 10 simulated paths of geometric Brownian motion:

![GBM Paths](./assets/gbm_paths.png)


