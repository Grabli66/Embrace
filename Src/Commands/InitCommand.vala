/*
*   Process init command
*/
[Compact]
internal class InitCommand {
    /*
    *   Process command
    */
    public static void Process () {
        InfoLn ("Init new project");
        try {
            var file = File.new_for_path (Project.PROJECT_NAME);
            if (file.query_exists ()) throw new Errors.Common ("Project already exists");

            // Create dir for source
            FileUtils.PreparePath (Project.SOURCE_NAME);

            // Create dir for tests            
            FileUtils.PreparePath (Project.TEST_SOURCE_NAME);
            var testPath = Path.build_path (Global.DIR_SEPARATOR, Project.TEST_SOURCE_NAME, Project.PROJECT_NAME);            
            var testProject = File.new_for_path (testPath);
            var fstr = testProject.append_to (FileCreateFlags.NONE);
            var data_stream = new DataOutputStream (fstr);
            data_stream.put_string (Project.TEST_PROJECT_CONTENT);

            var testMainPath = Path.build_path (Global.DIR_SEPARATOR, Project.TEST_SOURCE_NAME, Project.TESTS_MAIN_NAME);
            var testMain = File.new_for_path (testMainPath);
            fstr = testMain.append_to (FileCreateFlags.NONE);
            data_stream = new DataOutputStream (fstr);
            data_stream.put_string (Project.TEST_MAIN_CONTENT);

            fstr = file.append_to (FileCreateFlags.NONE);
            data_stream = new DataOutputStream (fstr);
            data_stream.put_string (Project.PROJECT_CONTENT);
            InfoLn ("Done");
        } catch (Error e) {
            ErrorLn (e.message);
        }
    }
}