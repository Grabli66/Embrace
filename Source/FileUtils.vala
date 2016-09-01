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

    /*
    *   Return absolute path to file
    */
    public static string GetAbsPath (string path) {
        if (Path.is_absolute (path)) return path;
        return Posix.realpath (path);
    }

    /*
    *   Join paths
    */
    public static string JoinPath (string path1, string path2) {
        if (Path.is_absolute (path2)) return path2;
        var path = path1;
        if (!Path.is_absolute (path)) path = GetAbsPath (path);

        var path1p = path.split (Global.DIR_SEPARATOR);
        var len = path1p.length;
        var path2p = path2.split (Global.DIR_SEPARATOR);
        string[] np2 = {};
        foreach (var p2i in path2p) {
            if (p2i == ".") continue;
            if (p2i == "..") {
                len--;
                continue;
            }
            np2 += p2i;
        }

        var np1 = path1p[0:len];
        foreach (var p2i in np2) {
            np1 += p2i;
        }

        return string.joinv (Global.DIR_SEPARATOR, np1);
    }

    /*
    *   Return shortest path
    */
    public static string GetShortPath (string path) {
        var curDir = GLib.Environment.get_current_dir ();

        var curp = curDir.split (Global.DIR_SEPARATOR);
        var absPath = GetAbsPath (path);
        var pathp = absPath.split (Global.DIR_SEPARATOR);
        if (pathp[0] != curp[0]) return absPath;

        string[] np = {};
        string[] np2 = {};
        for (int i = 0; i < curp.length; i++) {
            if (i > pathp.length - 1) {
                np += "..";
                continue;
            }

            var cpi = curp[i];
            var ppi = pathp[i];
            if (cpi != ppi) {
                np += "..";
            }
        }

        if (np.length > 0) {
            if (np[0] != "..") np += ".";
        } else {
            np += ".";
        }

        bool notMatch = false;
        for (int i = 0; i < pathp.length; i++) {
            var ppi = pathp[i];
            if (i > curp.length - 1) {
                np2 += ppi;
            } else {
                var cpi = curp[i];
                if (cpi != ppi) notMatch = true;
                if (notMatch) {
                    np2 += ppi;
                }
            }
        }

        var res = string.joinv (Global.DIR_SEPARATOR, np) + Global.DIR_SEPARATOR + string.joinv (Global.DIR_SEPARATOR, np2);
        return res;
    }
}