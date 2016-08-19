/*
*   Check/update dependency
*/
[Compact]
internal class DependencyFactory {
    public const string GITHUB_DEP = "http://github.com";
    public const string LOCAL_DEP = "path://";
    public const string LIB_DEP = "lib://";

    /*
    *   Return dependency manager for path
    */
    public static IDependencyManager GetManager (string path) {
        IDependencyManager depManager = null;
        if (path.index_of (GITHUB_DEP) == 0) depManager = new GithubManager ();
        if (path.index_of (LIB_DEP) == 0) depManager = new LibManager ();
        if (path.index_of (LOCAL_DEP) == 0) depManager = new LocalManager ();
        if (depManager == null) throw new Errors.Common ("Unknown dependency type");
        depManager.SetPath (path);
        return depManager;
    }
}