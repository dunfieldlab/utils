#! /bin/sh -
''''exec python "$0" "$@" # '''

__author__ = "Andriy Sheremet"

import argparse
import glob
import re
import shutil
import os

class Renamer:
    def __init__(self):
        self.totalFiles = 0
        self.toCut = 0
        self.toAppend = 0
        self.toProcess = 0
        self.toFrom = {}
        self.inputDir = ""
        self.outputDir = ""
        self.mode = "Renam"
        self.modified = 0

    def parse_args(self, argv=None):
        parser = argparse.ArgumentParser()
        parser.add_argument("mask", default="*.fastq.gz", nargs="?",
                            help="The mask to select files. Default *.fastq.gz: all fastq files in a current folder. Use \"*mask*\" to select all flies of interest")
        parser.add_argument("--dry-run", action="store_true", help="Display renaming logs, keep the files intact")
        parser.add_argument("--prefix", "-p", help="Add the supplied prefix to the beginning of each file")
        parser.add_argument("--cut", "-c", help="Cut the specified string from a filename")
        parser.add_argument("--output", "-o", help="Copy renamed files to output folder. Default: rename existing files")


        args = parser.parse_args()

        self.mask = args.mask
        self.dry = args.dry_run
        self.prefix = args.prefix or ""
        self.cut = args.cut or ""
        self.outputDir = args.output or ""

    def rename_file_name(self, pathname):

        filename = os.path.basename(pathname)
        self.inputDir = os.path.dirname(pathname)
        if not self.outputDir:
            self.outputDir = os.path.dirname(pathname)
        new_filename = ""

        if self.cut:
            new_filename = "".join(re.split(re.compile(self.cut), filename))
            if new_filename != filename:
                self.toCut += 1
        else:
            new_filename = filename

        if self.prefix:
            new_filename = self.prefix + new_filename
            self.toAppend += 1

        if not new_filename:
            new_filename = filename

        new_pathname = os.path.join(self.outputDir, new_filename)
        if pathname != new_pathname:
            self.toProcess += 1
        return new_pathname

    def rename_files(self):
        self.write_log()
        if (not self.toFrom) or (self.toProcess == 0):
            print("Nothing to process. Exiting...")
            return
        assert len(self.toFrom) == self.totalFiles, "inconsisten file number"
        print(f"From the total of {self.totalFiles} files {self.toProcess} will be affected")
        print(f".............to append: {self.toAppend} File(s)")
        print(f"................to cut: {self.toCut} File(s)")
        answer = input("Are you sure you'd like to continue?[Y/N]: ").lower()
        while True:
            if answer in ["y", "n", "yes", "no"]:
                break
            else:
                print("Incorrect input. Please enter Y or N to continue...")
            answer = input("[Y/N]: ")
        if answer in ["n", "no"]:
            print("Skipping...")
            return 1
        else:
            if self.outputDir and (not os.path.exists(self.outputDir)):
                os.makedirs(self.outputDir)
            for source, dest in self.toFrom.items():
                if source == dest:
                    continue
                if not self.outputDir == self.inputDir:
                    self.mode = "Copi"
                    shutil.copy(source, dest)
                else:
                    shutil.move(source, dest)

                self.modified += 1

            print(f"{self.mode}ed {self.modified} File(s)")




    def write_log(self):


        input_paths = glob.glob(self.mask)
        self.totalFiles = len(input_paths)
        if not self.totalFiles:
            print("No files specified")
            return
        if self.toFrom:
            print("Files to rename:")
        for path in input_paths:
            self.toFrom[path] = self.rename_file_name(path)
            print("   ",path,"->", self.toFrom[path])





if __name__ == "__main__":
    r = Renamer()
    r.parse_args()
    #r.write_log()
    if r.dry:
        r.write_log()
    else:
        r.rename_files()
