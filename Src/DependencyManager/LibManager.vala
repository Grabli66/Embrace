/*
*   Dependency manager for libs
*/
internal class LibManager : Object, IDependencyManager {
    /*
    *   Name of lib
    */
    public string LibName;

    /*
    *   Set path for dependency
    */
    public void SetPath (string path) throws Errors.Common {
        try {
            LibName = path.split (DependencyFactory.LIB_DEP)[1];
        } catch {
            throw new Errors.Common ("Cant set path to dependency");
        }
    }

    /*
    *   Check dependency exists.
    *   If not exists install it
    */

    public void CheckDependency () throws Errors.Common {
        // TODO: install lib
    }

    /*
    *   Update dependency recursive
    */
    public void UpdateDependency () throws Errors.Common {
        // TODO: update lib
    }

    /*
    *   Return cloned project
    */
    public Project GetProject () {
        return null;
    }
}