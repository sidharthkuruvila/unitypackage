
val list_dir: string -> string list

val join_path: string -> string -> string

val file_exists: string -> bool

val split_filename: string -> (string * string)

val mkdir_p: string -> unit

val rename: string -> string -> unit

val rm_recursive: string -> unit