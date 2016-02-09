import math
import urllib2
import random

name_list = []
target_list = []
sequence = ''
#proteome = urllib2.urlopen("file:///Users/dengp/Google%20Drive/MitoProt/Mitoprot/test.txt")
#proteome = urllib2.urlopen("file:///Users/dengp/Google%20Drive/MitoProt/Mitoprot/sequence_CE.txt")
proteome = urllib2.urlopen("file:///Users/zora/Desktop/coding/Find_Cys/Caenorhabditis_elegans.WBcel235.pep.all.fa")
mttarget_proteins = urllib2.urlopen("file:///Users/zora/Desktop/coding/Find_Cys/Final_results_CE.txt")

for protein in mttarget_proteins:
    target_list.append(protein.split(' ')[0])
target_list.append(' ')
    
for protein in proteome:    
    if protein[0] == '>':
        name = protein.split(' ')[0]
        name = name.lstrip('>')
        if name in target_list:
            idx = target_list.index(name)
        else:
            idx = -1
        sequence = ''
    else:
        sequence += protein.strip('\n')
        
    target_list[idx] = [name, sequence]
    
with open('Mitochondrial_target_genes_fasta.txt', 'w') as output:
    for row in target_list[ : -1]:
        string = row[0] + ' ' + row[1] + '\n'
        output.write(string)
        

    





        