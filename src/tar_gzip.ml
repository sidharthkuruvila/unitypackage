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
