#import urllib2
#complete_data = urllib2.urlopen("file:///Users/zora/Desktop/TargetP/Mitopro_in_TargetP/complete_result_TargetP_CE.txt")

complete_data = open('complete_results_TargetP_CE.txt', 'r')

mito_data = []
for row in complete_data:
    curr = row.split()
    #print curr
    if curr[5] == 'M':
        mito_data.append(curr)

mito_data_file = open('TargetP_results_CE.txt', 'w')
for i in range(0, len(mito_data)):
    string = str(mito_data[i][0]) + ' ' + str(mito_data[i][2]) + ' ' + str(mito_data[i][6])
    mito_data_file.write(string + '\n')
mito_data_file.close()
