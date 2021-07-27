(* Auto-generated from "tmp_biniou.atd" *)


type rc_name = Tmp_biniou_t.rc_name

type rc_entry = Tmp_biniou_t.rc_entry = { commands: (string * int) }

type tmp_file = Tmp_biniou_t.tmp_file = {
  rc: (rc_name * (rc_entry list)) list;
  daemon: int
}

val validate_rc_name :
  Atdgen_runtime.Util.Validation.path -> rc_name -> Atdgen_runtime.Util.Validation.error option
  (** Validate a value of type {!rc_name}. *)

val create_rc_entry :
  commands: (string * int) ->
  unit -> rc_entry
  (** Create a record of type {!rc_entry}. *)

val validate_rc_entry :
  Atdgen_runtime.Util.Validation.path -> rc_entry -> Atdgen_runtime.Util.Validation.error option
  (** Validate a value of type {!rc_entry}. *)

val create_tmp_file :
  rc: (rc_name * (rc_entry list)) list ->
  daemon: int ->
  unit -> tmp_file
  (** Create a record of type {!tmp_file}. *)

val validate_tmp_file :
  Atdgen_runtime.Util.Validation.path -> tmp_file -> Atdgen_runtime.Util.Validation.error option
  (** Validate a value of type {!tmp_file}. *)

