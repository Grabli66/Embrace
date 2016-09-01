/*
*   Type of project
*/
internal enum ProjectTypeEnum {
    APP,
    LIBRARY,
    TESTS;

    public const string APP_NAME = "app";
    public const string LIBRARY_NAME = "library";
    public const string TESTS_NAME = "tests";

    /*
    *   Get project type from string
    */
    public static ProjectTypeEnum FromString (string s) throws Errors.Common {
        if (s == APP_NAME) return APP;
        if (s == LIBRARY_NAME) return LIBRARY;
        if (s == TESTS_NAME) return TESTS;
        throw new Errors.Common (@"Unknown project type $s");
    }
}


/*
*   Project info
*/
internal class Project : Object { 
    public const string DEP_CACHE_NAME = "Deps";
    public const string PROJECT_NAME = "project.vprj";
    public const string DEPENDENCY_NAME = "Dependency";
    public const string PROJECT_TYPE_NAME = "ProjectType";
    public const string NAME_NAME = "Name";
    public const string SOURCE_NAME = "Source";
    public const string TEST_SOURCE_NAME = "Tests";
    public const string TESTS_OUT_NAME = "tests";
    public const string TESTS_MAIN_NAME = "Main.vala";
    public const string OUT_NAME = "OutPath";

    /*
    *   New project content
    */
    public const string PROJECT_CONTENT = 
    "{
    \"Name\" : \"ProjectName\",
    \"Description\" : \"Project description\",
    \"Version\" : \"0.1\",
    \"ProjectType\" : \"app\",
    \"Source\" : [\"./Source\"],
    \"Tests\" : \"./Tests\",
    \"OutPath\" : \"./Bin\",
    \"Dependency\" : [
    ]
}";

    /*
    *   New project content
    */
    public const string TEST_PROJECT_CONTENT = 
    "{
    \"Name\" : \"Tests\",        
    \"ProjectType\" : \"tests\",
    \"Source\" : [\".\"],    
    \"OutPath\" : \"../Bin\",
    \"Dependency\" : [
        \"path://..\"
    ]
}";

    /*
    *   Main.vala content for tests
    */
    public const string TEST_MAIN_CONTENT = """public void main () {
    stderr.printf ("TEST DONE\n");
}
    """;

    /*
    *   Project path
    */
    public string ProjectPath { get; private set; }

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
    *   Path to tests
    */
    public string Tests { get; private set; }

    /*
    *   Dependency: libs, github, local
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
        } catch (Error e) {
            InfoLn (e.message);
            throw new Errors.Common ("Cant get source files");
        }
    }

    /*
    *   Check project file exists
    */
    public static void CheckExists (string path) throws Errors.Common {
        var file = File.new_for_path (path);
        if (!file.query_exists ()) throw new Errors.Common ("Project not exists");
    }

    /*
    *   Project constructor
    */
    public Project (string path) throws Errors.Common {
        try {
            ProjectPath = FileUtils.GetAbsPath (path);            
            var parser = new Json.Parser ();
            var filePath = FileUtils.JoinPath (ProjectPath, PROJECT_NAME);
            parser.load_from_file (filePath);
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
            
            // Tests
            if (root.has_member (TEST_SOURCE_NAME)) {
                Tests = root.get_string_member (TEST_SOURCE_NAME);
            }

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
                var npath = FileUtils.JoinPath (ProjectPath, path);
                var shortName = FileUtils.GetShortPath (npath);
                var files = EnumerateFiles (shortName, Global.VALA_NAME);
                foreach (var fl in files) {
                    sources.add (fl);
                }
            }

            // Get dependency sources
            foreach (var depName in Dependency) {
                var depManager = DependencyFactory.GetManager (depName, this);
                var depProject = depManager.GetProject ();
                if (depProject == null) continue;
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

            // Get dependency libs
            foreach (var depName in Dependency) {
                var depManager = DependencyFactory.GetManager (depName, this);
                if (depManager is LibManager) {
                    var libManager = (LibManager) depManager;
                    libArr.add (libManager.LibName);
                } else {
                    var depProject = depManager.GetProject ();
                    if (depProject == null) continue;
                    var depLibs = depProject.GetAllLibs ();
                    foreach (var depLib in depLibs) {
                        libArr.add (depLib);
                    }
                }
            }

            return libArr.to_array ();
        } catch (Errors.Common e) {
            throw e;
        } 
    }
}