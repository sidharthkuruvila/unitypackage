open Core.Std
open Unix_util
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