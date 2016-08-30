open Core.Std
open Tar_gzip.Reader




let list_files file_name  =
    let gzip_chan = Gzip.open_in file_name in
    let l = Archive.list ~level:Header.Posix gzip_chan in

    List.iter ~f:(fun h -> print_string Header.(h.file_name ^ " " ^  (Int64.to_string h.file_size) ^ " " ^ (Link.to_string h.link_indicator)); print_newline ()) l
    

exception UnsupportedLinkType

let extract ?desto file_name = 
    let open Header in
    let dest = Option.value ~default:"." desto in
    let read_header h =
        match h.link_indicator with
            Link.Normal -> h.file_name |> Filename.concat dest |> Pervasives.open_out |> Option.some
          | Link.Directory -> Unix.mkdir (Filename.concat dest h.file_name); None 
          | _ -> raise UnsupportedLinkType in
    let gzip_chan = Gzip.open_in file_name in
    Archive.extract_gen read_header gzip_chan

let () = 
    Tar.Header.compatibility_level := Tar.Header.Posix;
    extract ~desto:"dump" "NetworkInput.unitypackage"