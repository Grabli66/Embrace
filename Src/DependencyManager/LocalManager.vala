/*
*   Dependency manager for local projects
*/
internal class LocalManager : Object, IDependencyManager { 
    /*
    *   Path to local project
    */
    public string LocalPath;

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
        return new Project (LocalPath);
    }
}