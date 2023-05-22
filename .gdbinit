python
# Reference: https://stackoverflow.com/a/62471062/11402768
# Note: Replace "readelf" with path to binary if it is not in your PATH.
READELF_BINARY = 'readelf'

class AddSymbolFileAuto (gdb.Command):
    """Load symbols from FILE, assuming FILE has been dynamically loaded (auto-address).
Usage: add-symbol-file-auto FILE [-readnow | -readnever]
The necessary starting address of the file's text is resolved by 'readelf'."""
    def __init__(self):
        super(AddSymbolFileAuto, self).__init__("add-symbol-file-auto", gdb.COMMAND_FILES)

    def invoke(self, solibpath, from_tty):
        from os import path
        import subprocess
        self.dont_repeat()
        if os.path.exists(solibpath) == False:
            print ("{0}: No such file or directory." .format(solibpath))
            return
        offset = self.get_text_offset(solibpath)
        pid = (gdb.selected_inferior().pid) 
        filename = subprocess.check_output(['basename', solibpath]).strip().decode()
        maps = subprocess.check_output(['grep', filename, f'/proc/{pid}/maps']).decode()
        base_addr = int((maps.split("\n")[0].split("-")[0]), 16)
        print(f"base: {hex(base_addr)}, offset: {hex(offset)}") 
        gdb_cmd = "add-symbol-file %s %s" % (solibpath, str(base_addr + offset))
        gdb.execute(gdb_cmd, from_tty)

    def get_text_offset(self, solibpath):
        import subprocess
        elfres = subprocess.check_output([READELF_BINARY, "-WS", solibpath])
        for line in elfres.splitlines():
            line = line.decode()
            if "] .text " in line:
                return int(line.split()[4], 16)
        return ""  # TODO: Raise error when offset is not found?

    def complete(self, text, word):
        return gdb.COMPLETE_FILENAME

AddSymbolFileAuto()
end
