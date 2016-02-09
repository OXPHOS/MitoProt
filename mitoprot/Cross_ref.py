mitoprot_file = open('mitoprot_results_CE.txt', 'r')
targetp_file = open('TargetP_results_CE.txt', 'r')
final_file = open('Final_results_CE.txt', 'w')

mitoprot = []
for row in mitoprot_file:
    mitoprot.append(row.split())

targetp = []
for row in targetp_file:
    targetp.append(row.split())

cross_ref = list(targetp)
final_list = []
for i in range(0, len(targetp)):
    j = 0
    try:
        while mitoprot[j][0] != targetp[i][0]:
            j += 1
        #cross_ref[i].extend(mitoprot[j][1])
        #mitoprot.remove(mitoprot[j])
        if float(mitoprot[j][1]) > 0.6:
            final_list.append([targetp[i][0], mitoprot[j][1], targetp[i][1], targetp[i][2]])
            final_list[-1].append(float(mitoprot[j][1]) * float(targetp[i][1]))
    except IndexError:
        final_list.append([targetp[i][0], 'N/A', targetp[i][1], targetp[i][2]])
        final_list[-1].append(float(targetp[i][1]))
        
for i in range(0, len(final_list)):
    string = ''
    for j in range(0, len(final_list[i])):
        string = string + str(final_list[i][j]) + ' '
    final_file.write(string + '\n')
final_file.close()
        

    
