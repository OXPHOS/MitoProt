keys = ['A', 'T', 'C', 'G']
threshold = 0.00

file_motif = open('motif.txt', 'r')
motif = []
#prob_motif = 1
for line in file_motif.readlines():
    prob = line.split()
    prob_base = dict()
    prob_motif_base = 0
    for i in range(4):
        prob_base[keys[i]] = float(prob[i])
        #prob_motif_base += 0.25 * float(prob[i])
    motif.append(prob_base)
    #prob_motif *= prob_motif_base
        
print motif

file_sequence = open('sequence.txt', 'r')
#seq = 'AAACTACGCGTAGCAACGTTTGGTG'
for line in file_sequence:
    sequence = line
    
results = []
for start in range(0, len(sequence) - len(motif) + 1):
    probability = 1
    for pos in range(0, len(motif)):
        probability *= motif[pos][sequence[start + pos]]
    probability /= (0.25 ** len(motif)) 
    results.append((probability, start))

results.sort(key = lambda x : x[0], reverse = True)

for i in range(0, len(results)):
    if results[i][0] < threshold:
        break
    print results[i][0], sequence[results[i][1] : results[i][1] + len(motif)]



    