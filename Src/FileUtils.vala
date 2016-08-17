[Compact]
internal class FileUtils {
    /*
    *   Creates all dirs if need
    */
    public static void PreparePath (string path) throws Error {
        var file = File.new_for_path (path);
        if (!file.query_exists ()) {
            file.make_directory_with_parents ();
        }
    }
}