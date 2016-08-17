/*
*   Type of project
*/
internal enum ProjectTypeEnum {
    APP,
    LIBRARY;

    public const string APP_NAME = "app";
    public const string LIBRARY_NAME = "library";

    /*
    *   Get project type from string
    */
    public static ProjectTypeEnum FromString (string s) throws Errors.Common {
        if (s == APP_NAME) return APP;
        if (s == LIBRARY_NAME) return LIBRARY;
        throw new Errors.Common (@"Unknown project type $s");
    }
}


/*
*   Project info
*/
internal class Project : Object { 
    private const string DEPENDENCY_NAME = "Dependency";
    private const string PROJECT_TYPE_NAME = "ProjectType";
    private const string NAME_NAME = "Name";
    private const string SOURCE_NAME = "Source";
    private const string LIBS_NAME = "Libs";
    private const string OUT_NAME = "OutPath";

    /*
    *   New project content
    */
    public const string PROJECT_CONTENT = 
    "
    {
        \"Name\" : \"ProjectName\",
        \"Description\" : \"\",
        \"Version\" : \"0.1\",
        \"ProjectType\" : \"app\",
        \"Source\" : [\"./Src\"],
        \"OutPath\" : \"./Bin\",
        \"Libs\" : [
        ],
        \"Dependency\" : [
        ]
    }
    ";

    /*
    *   Project name
    */
    public string Name { get; private set; }

    /*
    *   Project description
    */
    public string Description { get; private set; }

    /*
    *   Project type
    */
    public ProjectTypeEnum ProjectType { get; private set; }

    /*
    *   Project version
    */
    public string Version { get; private set; }

    /*
    *   Out path
    */
    public string OutPath { get; private set; }

    /*
    *   Paths to sources
    */
    public string[] Sources { get; private set; }

    /*
    *   Libs name. Example: gio-2.0, json-glib-1.0
    */
    public string[] Libs { get; private set; }

    /*
    *   Dependency
    */
    public string[] Dependency { get; private set; }

    /*
    *   Enumerate files with extension recursive
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

    /*
    *   Project constructor
    */
    public Project (string path) throws Errors.Common {
        try {
            var parser = new Json.Parser ();
            var filepath = @"$path/$(Global.PROJECT_NAME)";
            parser.load_from_file (filepath);
            var root = parser.get_root ().get_object ();

            Name = root.get_string_member (NAME_NAME);
            OutPath = root.get_string_member (OUT_NAME);
            ProjectType = ProjectTypeEnum.FromString (root.get_string_member (PROJECT_TYPE_NAME));

            // Sources
            var sourceArr = root.get_array_member (SOURCE_NAME);
            var sourceList = new Gee.ArrayList<string> ();
            sourceArr.foreach_element ((arr, ind, nod) => {
                var sourceName = nod.get_string ();
                sourceList.add (sourceName);
            });
            Sources = sourceList.to_array ();

            // Libs
            var libArr = root.get_array_member (LIBS_NAME);
            var libList = new Gee.ArrayList<string> ();
            libArr.foreach_element ((arr, ind, nod) => {
                var libName = nod.get_string ();
                libList.add (libName);
            });
            Libs = libList.to_array ();

            // Dependency
            var dependencyArr = root.get_array_member (DEPENDENCY_NAME);
            var depList = new Gee.ArrayList<string> ();
            dependencyArr.foreach_element ((arr, ind, nod) => {
                var depName = nod.get_string ();
                depList.add (depName);
            });
            Dependency = depList.to_array ();
        } catch (Errors.Common e) {
            throw e;
        }
        catch {
            throw new Errors.Common ("Cant open project");
        }
    }

    /*
    *   Return all sources with all dependency
    */
    public string[] GetAllSources () throws Errors.Common {
        try {
            var sources = new Gee.ArrayList<string> ();
            // Get self sources
            foreach (var path in Sources) {
                var files = EnumerateFiles (path, Global.VALA_NAME);
                foreach (var fl in files) {
                    sources.add (fl);
                }
            }

            // Get dependency sources
            foreach (var dep in Dependency) {
                var path = DependencyManager.GetDependencyPath (dep);
                var depProject = new Project (path);
                var depSources = depProject.GetAllSources ();
                foreach (var depSource in depSources) {
                    sources.add (depSource);
                }
            }

            if (sources.size < 1) throw new Errors.Common ("No source files");
            return sources.to_array ();
        } catch (Errors.Common e) {
            throw e;
        } 
    }

    /*
    *   Return all sources with all dependency
    */
    public string[] GetAllLibs () throws Errors.Common {
        try {
            var libArr = new Gee.ArrayList <string> ();

            // Get self libs
            foreach (var lib in Libs) {
                libArr.add (lib);
            }

            // Get dependency libs
            foreach (var dep in Dependency) {
                var path = DependencyManager.GetDependencyPath (dep);
                var depProject = new Project (path);
                var depLibs = depProject.GetAllLibs ();
                foreach (var depLib in depLibs) {
                    libArr.add (depLib);
                }
            }

            return libArr.to_array ();
        } catch (Errors.Common e) {
            throw e;
        } 
    }
}