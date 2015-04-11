(*
   Gnuplot-OCaml - Simple interface to Gnuplot

   Copyright (C) 2014-  Oliver Gu
   email: gu.oliver@yahoo.com

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

(** Simple interface to Gnuplot *)

open Core.Std

module Color : sig
  (* Possible colors of a plot. *)
  type t = [
  | `Black
  | `Red
  | `Green
  | `Yellow
  | `Blue
  | `Magenta
  | `Cyan
  | `White
  | `Rgb of int * int * int
  ]
end

module Range : sig
  (** Used for constructing ranges for the X axis, Y axis or both. *)
  type t =
  | X  of float * float
  | Y  of float * float
  | XY of float * float * float * float
end

module Filling : sig
  (** Represents possible fillings of a plot. *)
  type t = [
  | `Solid           (* Fill the plot with a solid fill. *)
  | `Pattern of int  (* Fill the plot with a pre-defined Gnuplot pattern. *)
  ]
end

module Output : sig
  (** Specifies the output type for Gnuplot. *)
  type t

  (** [create ?font output] creates an output type with optional [font]
      parameter. *)
  val create
    :  ?font:string
    -> [ `Wxt  (* Wxt terminal device generates output in a separate window. *)
       | `X11  (* X11 terminal device for use with X servers. *)
       | `Qt   (* Qt  terminal device generates output in a separate window. *)
       | `Png of string  (* For saving charts to a PNG file. *)
       | `Eps of string  (* For saving charts to an EPS file. *)
       ]
    -> t
end

module Labels : sig
  (* Specifies labels for the X and Y axes. *)
  type t

  val create
    :  ?x:string
    -> ?y:string
    -> unit
    -> t
end

module Titles : sig
  (** Specifies titles for the X and Y axes. *)
  type t

  val create
    :  ?x:string list
    -> ?xrotate:int
    -> ?y:string list
    -> ?yrotate:int
    -> unit
    -> t
end

module Series : sig
  (** Represents a series of data for the plot functions in the [Gp] module. *)
  type t

  (** [lines data] creates a data series for a line plot of Y values. *)
  val lines
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> float list
    -> t

  (** [lines_xy data] creates a data series for a line plot of X and Y
      values. *)
  val lines_xy
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (float * float) list
    -> t

  (** [lines_xy data] creates a data series for a line plot of time and Y
      values. *)
  val lines_timey
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (Time.t * float) list
    -> t

  (** [lines_func f] creates a data series for a line plot of the values given
      by a function [f] specified in the Gnuplot format, eg `sin(x)`.  The X
      values come from the range object that was supplied to one of the
      plot functions in the [Gp] module. *)
  val lines_func
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> string
    -> t

  (** [points data] creates a data series for a point plot of Y values. *)
  val points
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> float list
    -> t

  (** [points_xy data] creates a data series for a point plot of X and Y
      values. *)
  val points_xy
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (float * float) list
    -> t

  (** [points_xy data] creates a data series for a point plot of time and Y
      values. *)
  val points_timey
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (Time.t * float) list
    -> t

  (** [points_func f] creates a data series for a point plot of the values given
      by a function [f] specified in the Gnuplot format, eg `sin(x)`.  The X
      values come from the range object that was supplied to one of the plot
      functions in the [Gp] module below. *)
  val points_func
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> string
    -> t

  (** [steps data] creates a data series for a step function of Y values. *)
  val steps
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> float list
    -> t

  (** [steps data] creates a data series for a step function of X and Y
      values. *)
  val steps_xy
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (float * float) list
    -> t

  (** [steps data] creates a data series for a step function of time and Y
      values. *)
  val steps_timey
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> (Time.t * float) list
    -> t

  (** [histogram data] creates a data series for a histogram of Y values. *)
  val histogram
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> ?fill:Filling.t
    -> float list
    -> t

  (** [candlesticks data] creates a data series for a candlestick chart. *)
  val candlesticks
    :  ?title:string
    -> ?color:Color.t
    -> ?weight:int
    -> ?fill:Filling.t
    -> (Time.t * (float * float * float * float)) list
    -> t
end

module Gp : sig
  (** A wrapper for calling Gnuplot from OCaml. *)
  type t

  (** [create ?verbose ?path ()] creates a channel to a Gnuplot process with the
      executable given by [path].  If [verbose] is true then plotting commands
      print debug information on standard output. *)
  val create
    :  ?verbose:bool (* defaults to false  *)
    -> ?path:string  (* defaults to `gnuplot` *)
    -> unit
    -> t

  (** [close t] closes the channel to the Gnuplot process. *)
  val close : t -> unit

  (** [set ?output ?title ?fill ?range ?titles t] sets parameters of the Gnuplot
      session. *)
  val set
    :  ?output:Output.t  (* Wxt is default terminal *)
    -> ?title:string
    -> ?use_grid:bool    (* Defaults to false *)
    -> ?fill:Filling.t
    -> ?range:Range.t
    -> ?labels:Labels.t
    -> ?titles:Titles.t
    -> t
    -> unit

  (** [unset ?fill ?range ?titles t] resets parameters of the Gnuplot
      session. *)
  val unset
    :  ?fill:Filling.t
    -> ?range:Range.t
    -> ?labels:Labels.t
    -> ?titles:Titles.t
    -> t
    -> unit

  (** [plot t series] plots a single data [series].  The parameters for filling,
      range, etc are optional. *)
  val plot
    :  ?output:Output.t  (* Wxt is default terminal if not set otherwise *)
    -> ?title:string
    -> ?use_grid:bool    (* Defaults to false *)
    -> ?fill:Filling.t
    -> ?range:Range.t
    -> ?labels:Labels.t
    -> ?titles:Titles.t
    -> t
    -> Series.t
    -> unit

  (** [plot_many t series] creates a plot of multiple data [series].  The
      parameters for filling, range, etc are optional. *)
  val plot_many
    :  ?output:Output.t  (* Wxt is default terminal if not set otherwise *)
    -> ?title:string
    -> ?use_grid:bool    (* Defaults to false *)
    -> ?fill:Filling.t
    -> ?range:Range.t
    -> ?labels:Labels.t
    -> ?titles:Titles.t
    -> t
    -> Series.t list
    -> unit

  (** [plot_many t f] draws a graph of the function [f] given as a string.
      The function [f] has to be specified in the Gnuplot format, eg `sin(x)`.
      The parameters for the filling, range, etc are optional. *)
  val plot_func
    :  ?output:Output.t  (* Wxt is default terminal if not set otherwise *)
    -> ?title:string
    -> ?use_grid:bool    (* Defaults to false *)
    -> ?fill:Filling.t
    -> ?range:Range.t
    -> ?labels:Labels.t
    -> ?titles:Titles.t
    -> t
    -> string
    -> unit
end
