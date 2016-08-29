open Core.Std
open Tar_gzip.Reader

let extract ?dest file_name  =
    let gzip_chan = Gzip.open_in file_name in

    let l = Archive.list ~level:Header.Posix gzip_chan in

    List.iter ~f:(fun h -> print_string Header.(h.file_name ^ " " ^  (Int64.to_string h.file_size) ^ " " ^ (Link.to_string h.link_indicator)); print_newline ()) l

let () = extract "NetworkInput.unitypackage"