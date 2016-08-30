open Core.Std
open Unix

let list_dir dir_name = 
    let d = opendir dir_name in
    let rec loop () =
        try 
            let f = readdir d in
            f::loop ()
        with 
            End_of_file -> [] 
        in
    List.filter ~f:(fun f -> not (phys_equal (String.get f 0) '.')) (loop ())
let join_path = Filename.concat

let file_exists fn = match Sys.file_exists fn with `Yes -> true | _ -> false

let split_filename = Filename.split

let remove_file = unlink

let remove_directory = rmdir

let mkdir_p d = mkdir_p d

let rename oldname newname = rename oldname newname

let is_directory dn = (stat dn).st_kind = S_DIR

let rec rm_recursive fn =
    if is_directory fn then begin
        List.iter ~f:(fun x -> rm_recursive (join_path fn x)) (list_dir fn);
        remove_directory fn
    end
    else
        remove_file fn