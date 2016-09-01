/*
*   Dependency manager for local projects
*/
internal class LocalManager : Object, IDependencyManager { 
    /*
    *   Path to local project
    */
    public string LocalPath;

    /*
    *   Parent project
    */
    private Project _project;

    /*
    *   Set path for dependency
    */
    public void SetPath (string path) throws Errors.Common {
        try {
            LocalPath = path.split (DependencyFactory.LOCAL_DEP)[1];
        } catch {
            throw new Errors.Common ("Cant set path to dependency");
        }
    }

    /*
    *   Set parent project
    */
    public void SetProject (Project project) throws Errors.Common {
        _project = project;
    }

    /*
    *   Check if local project exists
    */

    public void CheckDependency () throws Errors.Common {
        // TODO: check project
    }

    /*
    *   Do nothing
    */
    public void UpdateDependency () throws Errors.Common {
    }

    /*
    *   Return cloned project
    */
    public Project GetProject () {
        var path = FileUtils.JoinPath (_project.ProjectPath, LocalPath);
        return new Project (path);
    }
}