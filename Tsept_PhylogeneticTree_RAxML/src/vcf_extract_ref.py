## INSTRUCTIONS ARE RIGHT BEFORE THE FIRST IF STATEMENT AFTER CLASS SET-UP
import csv

class VCF_DataLine:
    def __init__(self):
        self.chrom = ''
        self.pos = ''
        self.id = ''
        self.ref = ''
        self.alt = ''
        self.qual = ''
        self.filter = ''
        self.info = {}

    def parse2dict(self, str):
        dict = {}
        for entry in str.split(';'):
            key, value = entry.split('=')
            dict[key] = value
        return dict

    def insert(self, chrom, pos, id, ref, alt, qual, filter, info):
        self.chrom = chrom
        self.pos = pos
        self.id = id
        self.ref = ref
        self.alt = alt
        self.qual = qual
        self.filter = filter
        self.info = self.parse2dict(info)

    def __str__(self):
        return "{0},{1},{2},{3},{4},{5},{6},{7}".format(self.chrom, self.pos, self.id, self.ref, self.alt, self.qual,
                                                        self.filter, self.info)

    ## put the name of your taxa here; it will be added as a header in your output file
    FASTA_header = 'Trachymyrmex septentrionalis'

if __name__ == '__main__':
    ## the infile name goes here, as a string in open()
    infile = open('JSTs.vcf', 'r')

    reader = csv.reader(infile, delimiter='\t')

    ## Set the condition to true
    # condition = True

    ## WHILE it is true that the condition is true
    # while condition == True:
    ## if the next line of the csv reader starts with ##
    # if next(reader).startswith('##'):
    ## skip it
    # pass
    ## otherwise
    # else:
    ## set the condition to false
    # condition = False

    # while the next line in the csv starts with '##'
    while next(reader)[0].startswith('##'):
        # skip it
        pass

    AllDataLines = []

    for line_list in reader:
        # print(line_list[3])
        DataLine = VCF_DataLine()
        DataLine.insert(*line_list[0:8])
        AllDataLines.append(DataLine)
        # print(foot)
        # exit()

    infile.close()

    char_count = 0
    ## ref_output.txt is the output file; this can be named whatever you want but must retain .txt
    with open('ref_output.txt', 'w') as outputfile:

        outputfile.write(">"'FASTA_header\n')
        for DataLine in AllDataLines:
            if DataLine.info['TYP'] == 'SUB':
                outputfile.write(DataLine.ref)
                char_count = char_count + 1

    print('Total characters output:', char_count)
    print('Total characters omitted:', len(AllDataLines) - char_count)
    print('Total characters:', len(AllDataLines))


    # nextline = next(reader)
    # while nextline.startswith('##'):
    #    nextline = next(reader)

    # vcf = VCF_Cat()
    # vcf.insert('contig_1', '72', '.', 'C', 'T', '41.41', 'PASS', 'stuff;otherstuff')

    # vcf2 = VCF_Cat()
    # vcf2.insert('contig_1', '72', '.', 'C', 'T', '41.41', 'PASS', 'stuff;otherstuff')