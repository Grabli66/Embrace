/*
*   Interface to dependency manager
*/
internal interface IDependencyManager : Object {
    /*
    *   Set path for dependency
    */
    public abstract void SetPath (string path) throws Errors.Common;

    /*
    *   Check dependency exists
    */
    public abstract void CheckDependency () throws Errors.Common;

    /*
    *   Update dependency
    */
    public abstract void UpdateDependency () throws Errors.Common;

    /*
    *   Get local project for dependency
    */
    public abstract Project GetProject ();
}