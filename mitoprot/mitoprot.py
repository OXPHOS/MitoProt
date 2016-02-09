import math
import urllib2
import random
import functions
import Classes
from Classes import *

info = []
sequence = ''
proteome = urllib2.urlopen("file:///Users/zora/Google%20Drive/MitoProt/PA/Proteome_PA14.faa")
#proteome = urllib2.urlopen("file:///Users/dengp/Google%20Drive/MitoProt/Mitoprot/sequence_CE.txt")


for protein in proteome:
    if protein[0] == '>':
        info.append([])
        gi = protein.split('|')[1]
        name = protein.split('|')[-1]
        name = name.lstrip(' ')
        name = name.split('[')[0]
        #name = name.split(',')[0]
        #name = name.split(' ')[0]
        sequence = ''
    else:
        sequence += protein.strip('\n')
        
    info[-1] = [gi, name, sequence]


results_type = []
for no in range(0, len(info)):
    sequence = info[no][2]
    if len(sequence) < 17:
        continue
    print no
#    print info[no][1], len(sequence)
    coef20 = functions.Coef20(sequence)
    charge_diff = functions.Charge_Diff(sequence)
#    charge_diff = sequence.count('K') + sequence.count('R') - sequence.count('D') - sequence.count('E')
    FromTo = functions.Define_Addressing_Zone(sequence)
#    print coef20, charge_diff, FromTo
    KR = sequence[FromTo[0] : FromTo[1] + 1].count('K') + sequence[FromTo[0] : FromTo[1] + 1].count('R')
    DE = sequence[FromTo[0] : FromTo[1] + 1].count('D') + sequence[FromTo[0] : FromTo[1] + 1].count('E')
    coef_tot = functions.Coef_Total(sequence, FromTo)
    site_cleavage = functions.Cleavage(sequence, FromTo)
#    print KR, DE, coef_tot, site_cleavage
        
    hydrophob_scale_list = [hydrophob_scale(0.0, 0.0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0) for _ in range(0, 4)]
    # Eges = Eekd = Egvh = Eaah = hydrophob_scale(0.0, 0.0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0)
    try:
        for _ in range(0, 4):
            hydrophob_scale_list[_].Hydromax = functions.Hydrophobicite_Max(sequence,17,_);
            hydrophob_scale_list[_].Mesohydro = functions.Mesohydrophobicite(sequence,60,80,_);
            hydrophob_scale_list[_].Mhm_75 = functions.Moment_hydrophobicite_maximum(sequence, FromTo[0], FromTo[1],75,_);
            hydrophob_scale_list[_].Mhm_95 = functions.Moment_hydrophobicite_maximum(sequence, FromTo[0], FromTo[1],95,_);
            hydrophob_scale_list[_].Mhm_100 = functions.Moment_hydrophobicite_maximum(sequence, FromTo[0], FromTo[1],100,_);
            hydrophob_scale_list[_].Mhm_105 = functions.Moment_hydrophobicite_maximum(sequence, FromTo[0], FromTo[1],105,_);
            hydrophob_scale_list[_].Hmx_75 = functions.Hmx(sequence,hydrophob_scale_list[_].Mhm_75[1],Weight_75,_);
            hydrophob_scale_list[_].Hmx_95 = functions.Hmx(sequence,hydrophob_scale_list[_].Mhm_95[1],Weight_95,_);
            hydrophob_scale_list[_].Hmx_100 = functions.Hmx(sequence,hydrophob_scale_list[_].Mhm_100[1],Weight_100,_);
            hydrophob_scale_list[_].Hmx_105 = functions.Hmx(sequence,hydrophob_scale_list[_].Mhm_105[1],Weight_105,_);
#            print _, hydrophob_scale_list[_]
    #    print
    except:
        continue
    results = [0, 0]
    for choice in range(0, 1):
        if choice == 0:
            param = Param_2
        else:
            param = Param_6
        
        # Calculate the value of the coefficients
        for i in range(0, len(param)):
            count = 0
            results[i] = param[i][count] + param[i][count + 1] * coef20 + param[i][count + 2] * charge_diff +\
                param[i][count + 3] * (FromTo[1] + 1) + param[i][count + 4] * KR + param[i][count + 5] * DE +\
                    param[i][count + 6] * coef_tot + param[i][count + 7] * (site_cleavage + 1);
            count += 8
            for j in range(0, 4):
                results[i] = results[i] + param[i][count] * hydrophob_scale_list[j].Hydromax + \
                    param[i][count + 1] * hydrophob_scale_list[j].Mesohydro + \
                    param[i][count + 2] * hydrophob_scale_list[j].Mhm_75[0] + \
                    param[i][count + 3] * hydrophob_scale_list[j].Mhm_95[0] + \
                    param[i][count + 4] * hydrophob_scale_list[j].Mhm_100[0] + \
                    param[i][count + 5] * hydrophob_scale_list[j].Mhm_105[0] + \
                    param[i][count + 6] * hydrophob_scale_list[j].Hmx_75 + \
                    param[i][count + 7] * hydrophob_scale_list[j].Hmx_95 + \
                    param[i][count + 8] * hydrophob_scale_list[j].Hmx_100 + \
                    param[i][count + 9] * hydrophob_scale_list[j].Hmx_105
                count += 10
        # Calculate associated probabilities
        sum = 0.0
        for i in range(0, len(results)):
            results[i] = math.exp(results[i])
            sum += results[i]
        if choice == 0:
            pass
            #print 'DFM:',
        else:
            pass
            #print 'DFMC:',
        for i in range(0, len(results)):
            results[i] /= sum
            # print results[i]
        results_type.append([info[no][0], info[no][1], results[1], info[no][2]])

#output = open('/Users/zora/Google%20Drive/MitoProt/PA/mitoprot_results_PA14.txt', 'w')
#with open('/Users/zora/Google%20Drive/MitoProt/PA/Mitoprot_results_PA14.txt', 'w') as output:
with open('/Users/zora/desktop/Mitoprot_results_PA14.txt', 'w') as output:
    for _ in range(0, len(results_type)):
        string = str(results_type[_][0]) + ' ' + str(results_type[_][1]) + ' ' + str(results_type[_][2]) 
        output.write(string + '\n')
        
with open('/Users/zora/desktop/Mitoprot_PA14_fasta.txt', 'w') as output:
    for _ in range(0, len(results_type)):
        string = str('>' + str(results_type[_][0]) + ' ' + str(results_type[_][1]) + '\n' + str(results_type[_][3]))
        output.write(string + '\n' + '\n')
#output.close()



        