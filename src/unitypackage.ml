open Core.Std

let extract_spec =
  Command.Spec.(empty 
    +> anon ("src_filename" %: string)
    +> anon ("dest_directory" %: string))

let extract_command =
  Command.basic
    ~summary:"Extract the contents of a unitypackage file"
    ~readme:(fun () -> "")
    extract_spec
    (fun src_file dest_directory () -> Extract.extract src_file dest_directory)


let command_group =
  Command.group ~summary:"Tool to extract and package unitypackage files"
    ["extract", extract_command]

let () =
  Tar.Header.compatibility_level := Tar.Header.Posix;
  Command.run command_group

