open Core

type t

val create : string -> int -> bool -> t
val update_priority : int -> t -> t
val complete : t -> t
val compare : t -> t -> int
val string_of_t : t -> string

val sexp_of_t : t -> Sexp.t
val t_of_sexp : Sexp.t -> t


