open Core

type t

val create : string -> int -> bool -> t
val update_priority : int -> t -> t
val complete : t -> t
val compare : t -> t -> int
val string_of_t : t -> string
val is_complete : t -> bool

val sexp_of_t : t -> Sexp.t
val t_of_sexp : Sexp.t -> t

val save : string -> t -> Unit.t
val load : string -> t list
val get_highest_priority : t list -> t
val show_tasks : t list -> Unit.t
val save_and_overwrite : string -> t list -> Unit.t

