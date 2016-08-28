
let extract file_name =
    let gzip_chan = Gzip.open_in file_name in
    let l = Tar_gzip.Reader.Archive.list ~level:Tar_gzip.Reader.Header.Posix gzip_chan in
    List.iter (fun h -> print_string Tar_gzip.Reader.Header.(h.file_name ^ " " ^  (Int64.to_string h.file_size) ^ " " ^ (Link.to_string h.link_indicator)); print_newline ()) l

let () = extract "NetworkInput.unitypackage"