void InfoLn (string s) {
    stderr.printf (@"$s\n");
}

void ErrorLn (string s) {
    stderr.printf (@"\x1b[31m$s\x1b[0m\n");
}