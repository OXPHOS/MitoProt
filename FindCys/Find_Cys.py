import math
import urllib2
import random

def Define_Addressing_Zone(sequence):
# Sequence always start with M. 
    for idx in range(0, len(sequence) - 14):  
        if sequence[idx] in 'DE':
            for _ in range(1, 14):
                if sequence[idx + _] in 'DE':
                    return idx
    return len(sequence) - 3 


cys_list = []
total_cys_contain_genes = 0
total_genes = 0
mttarget_proteins = urllib2.urlopen("file:///Users/zora/Desktop/coding/Find_Cys/Mitochondrial_target_genes_fasta.txt")
final_file = open("/Users/zora/desktop/mitoprot_results_CE.txt", "w") 

for protein in mttarget_proteins:
    total_genes += 1
    name = protein.split()[0]
    sequence = protein.split()[1]
    FromTo = Define_Addressing_Zone(sequence)
    cys_cal = []
    cys_count = 0
    for idx in range(0, 35): #FromTo):
#        print idx
        if sequence[idx] == 'C':
            cys_cal.append(idx + 1)
            cys_count += 1
    if cys_count:
        total_cys_contain_genes += 1
        cys_list.append([name, FromTo, cys_count, cys_cal])
    
print total_cys_contain_genes, total_genes
            
with open('Mitochondrial_target_genes_with_Cys_35.txt', 'w') as output:
    for row in cys_list:
        substring = ''
        for pos in row[3]:
            substring = substring + str(pos) + ','
        string = row[0] + ' ' +str(row[1]) + ' ' + str(row[2]) + '         ' + substring + '\n'
        output.write(string)
        

        