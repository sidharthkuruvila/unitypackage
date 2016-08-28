module Read_Gzip_Write_File = struct
  type in_channel = Gzip.in_channel
  type out_channel = Pervasives.out_channel

  let really_input = Gzip.really_input
  let input = Gzip.input
  let output = Pervasives.output
  let close_out = Pervasives.close_out
end


module Reader = Tar.Make(Read_Gzip_Write_File)
