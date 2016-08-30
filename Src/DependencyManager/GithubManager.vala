/*
*   Dependency manager for github
*/
internal class GithubManager : Object, IDependencyManager { 
    /*
    *   Url for github project
    */
    private string _url;

    /*
    *   Parent project
    */
    private Project _project;

    /*
    *   Return dependency name from url
    */
    private string GetDependencyPath () {
        var items = _url.split ("/");
        var name = items[items.length - 1];
        var path = Path.build_path (Global.DIR_SEPARATOR, Project.DEP_CACHE_NAME, name);
        return path;
    }

    /*
    *   Set path for dependency
    */
    public void SetPath (string path) throws Errors.Common {
        _url = path;
    }

    /*
    *   Set parent project
    */
    public void SetProject (Project project) throws Errors.Common {
        _project = project;
    }

    /*
    *   Check dependency exists.
    *   If not exists update it
    */
    public void CheckDependency () throws Errors.Common {
        try {
            var path = GetDependencyPath ();
            var file = File.new_for_path (path);
            if (!file.query_exists ()) UpdateDependency ();
        } catch (Errors.Common e) {
            throw e;
        } 
    }

    /*
    *   Update dependency recursive
    */
    public void UpdateDependency () throws Errors.Common {
        try {
            FileUtils.PreparePath (Project.DEP_CACHE_NAME);
            var path = GetDependencyPath ();
            var file = File.new_for_path (path);
            if (!file.query_exists ()) {
                GLib.Process.spawn_sync (@"./$(Project.DEP_CACHE_NAME)", { "git", "clone", _url }, Environ.get (), SpawnFlags.SEARCH_PATH, null);
            } else {
                GLib.Process.spawn_sync (path, { "git", "pull" }, Environ.get (), SpawnFlags.SEARCH_PATH, null);
            }

            var project = new Project (path);
            foreach (var depName in project.Dependency) {
                var depManager = DependencyFactory.GetManager (depName, project);
                depManager.CheckDependency ();
            }
        } catch (Errors.Common e) {
            throw e;
        }  
        catch {
            throw new Errors.Common ("Cant update dependency");
        }
    }

    /*
    *   Return cloned project
    */
    public Project GetProject () {
        var path = GetDependencyPath ();
        return new Project (path);
    }
}