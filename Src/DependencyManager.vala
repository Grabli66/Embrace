/*
*   Check/update dependency
*/
[Compact]
internal class DependencyManager {
    /*
    *   Return dependency name from url
    */
    public static string GetDependencyPath (string url) {
        var items = url.split ("/");
        var name = items[items.length - 1];
        var path = Path.build_path (Global.DIR_SEPARATOR, Global.DEP_CACHE_NAME, name);
        return path;
    }

    /*
    *   Check dependency exists.
    *   If not exists update it
    */
    public static void CheckDependency (string url) throws Errors.Common {
        try {
            var path = GetDependencyPath (url);
            var file = File.new_for_path (path);
            if (!file.query_exists ()) UpdateDependency (url);
        } catch (Errors.Common e) {
            throw e;
        } 
    }

    /*
    *   Update dependency recursive
    */
    public static void UpdateDependency (string url) throws Errors.Common {
        try {
            FileUtils.PreparePath (Global.DEP_CACHE_NAME);
            var path = GetDependencyPath (url);
            var file = File.new_for_path (path);
            if (!file.query_exists ()) {
                GLib.Process.spawn_sync (@"./$(Global.DEP_CACHE_NAME)", { "git", "clone", url }, Environ.get (), SpawnFlags.SEARCH_PATH, null);
            } else {
                GLib.Process.spawn_sync (path, { "git", "pull" }, Environ.get (), SpawnFlags.SEARCH_PATH, null);
            }

            var project = new Project (path);
            foreach (var depName in project.Dependency) {
                DependencyManager.CheckDependency (depName);
            }
        } catch (Errors.Common e) {
            throw e;
        }  
        catch {
            throw new Errors.Common ("Cant update dependency");
        }
    }
}