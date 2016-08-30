open Core.Std

let list_dir dir_name = 
    let d = Unix.opendir dir_name in
    let rec loop () =
        try 
            let f = Unix.readdir d in
            f::loop ()
        with 
            End_of_file -> [] 
        in
    List.filter ~f:(fun f -> not (phys_equal (String.get f 0) '.')) (loop ())
let join_path = Filename.concat

let file_exists fn = match Sys.file_exists fn with `Yes -> true | _ -> false

let split_filename = Filename.split

let remove_file = Unix.unlink

let remove_directory = Unix.rmdir

let mkdir_p = Unix.mkdir_p

let rename = Unix.rename


let is_directory dn = 
    let open Unix in
    (stat dn).st_kind = S_DIR

let rec rm_recursive fn =
    if is_directory fn then begin
        List.iter ~f:(fun x -> rm_recursive (join_path fn x)) (list_dir fn);
        remove_directory fn
    end
    else
        remove_file fn

let arrange src dest =
    let fds =  list_dir src in
    let process_asset_directory d =
        let base = join_path src d in
        let pathname = "pathname" |> join_path base |> In_channel.read_all |> String.strip in
        let dest_filename = join_path dest pathname in
        let asset_filename = join_path base "asset" in
        if file_exists asset_filename then
            let (dn, fn) = split_filename dest_filename in
            mkdir_p dn;
            rename asset_filename dest_filename
        else
            mkdir_p dest_filename in

    Unix.mkdir dest;
    List.iter ~f:process_asset_directory fds

let extract src_file dest_directory = 
    Tar_gzip.extract src_file ".dump";
    arrange ".dump" dest_directory;
    rm_recursive ".dump"

let () = 
    Tar.Header.compatibility_level := Tar.Header.Posix;
    extract "NetworkInput.unitypackage" "dump3" 