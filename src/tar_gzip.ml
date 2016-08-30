open Core.Std

module Read_Gzip_Write_File = struct
  type in_channel = Gzip.in_channel
  type out_channel = Pervasives.out_channel option

  let really_input = Gzip.really_input
  let input = Gzip.input
  let output c = c |> Option.map ~f:Pervasives.output |> Option.value ~default:(fun s i j -> ())
  let close_out = Option.iter ~f:Pervasives.close_out
end


module Reader = Tar.Make(Read_Gzip_Write_File)

exception UnsupportedLinkType

let extract file_name dest = 
	let open Reader in
    let open Header in
    let read_header h =
        match h.link_indicator with
            Link.Normal -> h.file_name |> Filename.concat dest |> Pervasives.open_out |> Option.some
          | Link.Directory -> Unix.mkdir (Filename.concat dest h.file_name); None 
          | _ -> raise UnsupportedLinkType in
    let gzip_chan = Gzip.open_in file_name in
    Archive.extract_gen read_header gzip_chan