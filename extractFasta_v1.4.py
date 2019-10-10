#! /bin/sh -
''''exec python "$0" "$@" # '''

__author__ = "Andriy Sheremet"


import getopt
import sys
from Bio import  SeqIO
from Bio.SeqUtils import GC
import operator

pars ={}

pars["infile"] = ""
pars["outfile"] = ""
pars["Name"] = ""
pars["test"] = ">="

def usage():
    print "\nThis is the usage function:\n"
    print "\tScript performs filtering on the sequence length in a multiple fasta file.\n"
    print "\tDefaults: length: 100 characters, test: \">=\", output: terminal window"
    print '\tUsage: '+sys.argv[0]+' -i <input_file> [-o <output>] [-l <length>] [-t <test>]'
    print '\tExample1. Default parameters: Script performs (more or equal) test using length of 100'
    print '\t>'+sys.argv[0]+' -i input.fasta'
    print '\tExample2. Custom parameters provided: Script performs (less than) test using the length of 50 and writes the output in output.fasta'
    print '\t>'+sys.argv[0]+' -i input.fasta -o output.fasta -l 50 -t \"<\"'
    
def supported_operations():
    
    print "\nSupported operations:\n"
    print "\tMore than: \">\", more"
    print "\tMore or equal [DEFAULT OPTION]: \">=\", moreEq"
    print "\tLess than: \"<\", less"
    print "\tLess or equal: \"<=\", lessEq"
    print "\tEqual: \"=\", \"==\", equal, eq"
    print "\tNot equal: \"!=\", notEq, not"
    
    print "\n\tOmmit -t flag to run the default option"
def main(argv):
    
    #default parameters
    global pars
             
    try:                                
        opts, args = getopt.getopt(argv, "i:o:l:t:h", ["input=", "output=", "length=","test=", "help"])
    except getopt.GetoptError:          
        usage()                         
        sys.exit(2)                     
    for opt, arg in opts:                
        if opt in ("-h", "--help"):      
            usage()
            supported_operations()
            sys.exit()                  
        elif opt in ("-i", "--input"):
            if arg:
                pars["infile"] = arg
            #print "Input file", arg                  
        elif opt in ("-o", "--output"):
            if arg.strip():              
                pars["outfile"] = arg
            #print "Output file", arg  
        elif opt in ("-t", "--test"):
            if arg.strip():              
                pars["test"] = arg
            #print "Output file", arg  
        elif opt in ("-l", "--length"):
            try:
                pars["Name"] = str(arg)
            except:
                print "ERROR: Please enter an integer value as -l parameter (using default 100)"
                usage()
                sys.exit(1)
            #print "pars["length"]", arg
    filter_fasta(pars)

    
def filter_fasta(params):
    if params["infile"]:
        try:
            #
            handle = open(params["infile"], "rU")
        except:
            print "\nERROR: Input file doesn't exist"
            usage()
            sys.exit(1)
    else:
        try:
            #
            handle = sys.stdin
        except:
            print "\nERROR: Input file doesn't exist"
            usage()
            sys.exit(1)

    operations ={
        '>' : operator.gt,
        'more': operator.gt,
        '>=' : operator.ge,
        'moreEq' : operator.ge,
        '=' : operator.eq,
        '==' : operator.eq,
        'equal' : operator.eq,
        'eq' : operator.eq,
        '<' : operator.lt,
        'less' : operator.lt,
        '<=' : operator.le,
        'lessEq' : operator.le,
        '!=' : operator.ne,
        'notEq' : operator.ne,
        'not' : operator.ne,
		'r':'rg',
		'range':'rg'
        } 
    if params["test"] not in operations:
        print "ERROR: unsuported comparison test: ", params["test"]
        supported_operations()
        sys.exit(1)
    
    print "\n"
    print "Extracting Multiple Fasta file"
    print "Input file: ", params["infile"]
#    if params["outfile"]:
#        print "Output file: ", params["outfile"]
#    else:
#        print "Output file: ", "terminal window"
#    print "Limit: ", params["Name"]
    print "\n"

    
    parsed = SeqIO.parse(handle, "fasta")

    records = list()


    total = 0
    processed = 0
    for record in parsed:
        total += 1
        
        try:
            output_handle = open(record.name+".fasta", "w")
            SeqIO.write(record, output_handle, "fasta")
            output_handle.close()
            processed += 1
        except:
            print "ERROR: Illegal output filename"
            sys.exit(1) 
        
        #print(record.id), len(record.seq)
        #print record.description
#        if (operations[params["test"]] == operator.eq):
#            if ((operations[params["test"]](record.name, params["Name"]) or operations[params["test"]](record.description, params["Name"]))):

#                
#                records.append(record)
#        if (operations[params["test"]] == operator.ne):
#            if ((operations[params["test"]](record.name, params["Name"]) and operations[params["test"]](record.description, params["Name"]))):
#                processed += 1
#                records.append(record)
    handle.close()   
    
    if total== 1:
        print "\n%d sequence found"%(total)
    else:
        print "\n%d sequences found"%(total)  
    if processed==1:
        print "%d file written\n"%(processed)  
    else:
        print "%d files written\n"%(processed)    
    
    
    



    
if __name__ == "__main__":
    main(sys.argv[1:]) 
    
