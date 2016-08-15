/*
*   Project info
*/
internal class Project : Object { 
    private const string DEPENDENCY_NAME = "Dependency";
    private const string SOURCE_NAME = "Source";

    /*
    *   Project name
    */
    public string Name { get; private set; }

    /*
    *   Project description
    */
    public string Description { get; private set; }

    /*
    *   Project version
    */
    public string Version { get; private set; }

    /*
    *   Paths to sources
    */
    public string[] Sources { get; private set; }

    /*
    *   Dependency
    */
    public string[] Dependency { get; private set; }

    /*
    *   Enumerate files with extension
    */
    private string[] EnumerateFiles (string path, string ext) throws Errors.Common {
        try {
            var directory = File.new_for_path (path);
            var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);

            FileInfo fileInfo;
            var files = new Gee.ArrayList<string> ();
            while ((fileInfo = enumerator.next_file ()) != null) {
                var name = fileInfo.get_name ();
                var filePath = Path.build_path (Global.DIR_SEPARATOR, path, name);

                if (fileInfo.get_file_type () == FileType.DIRECTORY) {
                    var fls = EnumerateFiles (filePath, Global.VALA_NAME);
                    foreach (var item in fls) {
                        files.add (item);
                    }
                } else {
                    var fileItems = name.split (".");
                    if (fileItems.length < 2) continue;
                    if (fileItems[1] != ext) continue;
                    files.add (filePath);
                }
            }
            return files.to_array ();
        } catch {
            throw new Errors.Common ("Cant get source files");
        }
    }

    public Project (string path) throws Errors.Common {
        try {
            var parser = new Json.Parser ();
            var filepath = @"$path/$(Global.PROJECT_NAME)";
            parser.load_from_file (filepath);
            var root = parser.get_root ().get_object ();

            // Sources
            var sourceArr = root.get_array_member (SOURCE_NAME);
            var sourceList = new Gee.ArrayList<string> ();
            sourceArr.foreach_element ((arr, ind, nod) => {
                var sourceName = nod.get_string ();
                sourceList.add (sourceName);
            });
            Sources = sourceList.to_array ();

            // Dependency
            var dependencyArr = root.get_array_member (DEPENDENCY_NAME);
            var depList = new Gee.ArrayList<string> ();
            dependencyArr.foreach_element ((arr, ind, nod) => {
                var depName = nod.get_string ();
                depList.add (depName);
            });
            Dependency = depList.to_array ();
        } catch {
            throw new Errors.Common ("Cant open project");
        }
    }

    /*
    *   Return all sources with all dependency
    */
    public string[] GetAllSources () throws Errors.Common {
        try {
            foreach (var path in Sources) {
                return EnumerateFiles (path, Global.VALA_NAME);
            }

            throw new Errors.Common ("No source files");
        } catch (Errors.Common e) {
            throw e;
        } 
    }
}