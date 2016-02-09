import math
import Classes
from Classes import *


GES = {'A': 1.60,'B': -7.00,'C': 2.00,'D': -9.20,'E': -8.20, 'F': 3.70,'G': 1.00,'H': -3.00,'I': 3.10,'K': -8.80,'L': 2.80,'M': 3.40,'N': -4.80,'P': -0.20,'Q': -4.10,'R': -12.30,'S': 0.60,'T': 1.20,'V': 2.60,'W': 1.90,'X': 0.00, 'Y': -0.70, 'Z': -6.15, '*': 0.00}
EKD = {'A': 1.80,'B': -3.50,'C': 2.50,'D': -3.50,'E': -3.50,'F': 2.80,'G':  -0.40,'H': -3.20,'I': 4.50,'K': -3.90,'L': 3.80,'M': 1.90,'N': -3.50,'P': -1.60,'Q': -3.50,'R': -4.50,'S': -0.80,'T': -0.70,'V': 4.20,'W': -0.90,'X': -0.49,'Y': -1.30,'Z': -3.50,'*': -0.49}
GVH = {'A': 0.267,'B': -2.145,'C': 1.806,'D': -2.303,'E': -2.442,'F': 0.427,'G': 0.160,'H': -2.189,'I': 0.971,'K': -2.996,'L': 0.623,'M': 0.136,'N': -1.988,'P': -0.451,'Q': -1.814,'R': -2.749,'S': -0.119,'T': -0.083,'V': 0.721,'W': -0.875,'X': -0.664,'Y': -0.386,'Z': -2.128,'*': -0.49}
AAH = {'A': 0.620,'B': -0.840,'C': 0.290,'D': -0.900,'E': -0.740,'F': 1.200,'G': 0.480,'H': -0.400,'I': 1.400,'K': -1.500,'L': 1.100,'M': 0.640,'N': -0.780,'P': 0.120,'Q': -0.850,'R': -2.500,'S': -0.180,'T': -0.050,'V': 1.100,'W': 0.810,'X': 0.000,'Y': 0.260,'Z': -0.795,'*': 0.000}

def Coef20(seq):
    Nb_R = Nb_D = Nb_P = Nb_E = Nb_G = Nb_Q = Nb_K = Nb_H = Nb_N = Nb_Y = 0.0
    for _ in range(0, min(20, len(seq))):
        curr = seq[_]
        if curr == 'R':
            Nb_R += 1;
        elif curr == 'D':
            Nb_D += 1;
        elif curr == 'P':
            Nb_P += 1;
        elif curr == 'E':
            Nb_E += 1;
        elif curr == 'G':
            Nb_G += 1;
        elif curr == 'Q':
            Nb_Q += 1;
        elif curr == 'K':
            Nb_K += 1;
        elif curr == 'H':
            Nb_H += 1;
        elif curr == 'N':
            Nb_N += 1;
        elif curr == 'Y':
            Nb_Y += 1;
    return Nb_R * 0.116 - Nb_D * 0.238 - Nb_P * 0.253 - Nb_E * 0.233 - \
            Nb_G * 0.250 - Nb_Q * 0.155 - Nb_K * 0.113 - Nb_H * 0.239 - \
            Nb_N * 0.134 - Nb_Y * 0.157 + 5.227 
            
def Charge_Diff(seq):
    Nb_K = Nb_R = Nb_D = Nb_E = 0
    for aa in seq:
        if aa == 'R':
            Nb_R += 1;
        elif aa == 'D':
            Nb_D += 1;
        elif aa == 'E':
            Nb_E += 1;
        elif aa == 'K':
            Nb_K += 1;
    return Nb_K + Nb_R - Nb_D - Nb_E

def Define_Addressing_Zone(sequence):
    # Sequence always start with M. 
    for idx in range(0, len(sequence) - 14):  
        if sequence[idx] in 'DE':
            for _ in range(1, 14):
                if sequence[idx + _] in 'DE':
                    return [0, idx - 1]
    return [0, len(sequence) - 4] 


def Coef_Total(seq, FromTo):
    Nb_R = Nb_A = Nb_S = Nb_L = Nb_D = Nb_P = Nb_E = Nb_G = Nb_Q = Nb_K = Nb_H = Nb_N = Nb_Y = 0
    for _ in range(FromTo[0], FromTo[1] + 1):
        curr = seq[_]
        if curr == 'R':
            Nb_R += 1;
        elif curr == 'A':
            Nb_A += 1;
        elif curr == 'S':
            Nb_S += 1;
        elif curr == 'L':
            Nb_L += 1;
        elif curr == 'D':
            Nb_D += 1;
        elif curr == 'P':
            Nb_P += 1;
        elif curr == 'E':
            Nb_E += 1;
        elif curr == 'G':
            Nb_G += 1;
        elif curr == 'Q':
            Nb_Q += 1;
        elif curr == 'K':
            Nb_K += 1;
        elif curr == 'H':
            Nb_H += 1;
        elif curr == 'N':
            Nb_N += 1;
        elif curr == 'Y':
            Nb_Y += 1;
    return Nb_R * 0.135 + Nb_A * 0.141 + Nb_S * 0.112 + Nb_L * 0.122 -\
        Nb_D * 0.238 - Nb_P * 0.253 - Nb_E * 0.233 - Nb_G * 0.250 -\
        Nb_Q * 0.155 - Nb_K * 0.113 - Nb_H * 0.239 - Nb_N * 0.134 - Nb_Y * 0.157;
        
        
def Cleavage(seq, FromTo):
    # spg-7. Cpt = 36 online. 35 here. Beacuse I start from 0?
    site = -1
    last = len(seq) - 1
    for i in range(FromTo[0], FromTo[1] + 1):
        if seq[i] == 'R':
            curr = seq[i + 2]
            if curr == 'Y':
                if (i + 3 <= last) and (seq[i + 3] in 'AS') and (site < i + 3):
                    site = i + 3;
            elif curr in 'FIL':
                if (((i + 3 <= last) and (seq[i + 3] == 'S')) or\
                     ((i + 5 <= last) and (seq[i + 5] == 'S'))) and (site < i + 10):
                    site = i + 10;
                elif (i + 3 <= last) and (seq[i + 3]  in 'AGPTV') and (site < i + 10):
                    site = i + 10; 
            else:
                if (i + 3 <= last) and (seq[i + 3] in 'AGPTSV') and (site < i + 2):
                    site = i + 2;
    # There must be a front end of sequences?
    if site < 11:
        site = -1;
    return site

def Hydrophobicite_Average(seq, echelle = 0):
    somme = 0.0
    for _ in range(0, len(seq)):
        if (echelle == 0):
            somme += GES[seq[_]]
        elif echelle == 1:
            somme += EKD[seq[_]]
        elif echelle == 2:
            somme += GVH[seq[_]]
        elif echelle == 3:
            somme += AAH[seq[_]]
    return somme/len(seq)

  
def Hydrophobicite_Max(seq, length = 17, echelle = 0):
    Hmmax = -10000.0
    for _ in range(0, len(seq) - length + 1):
        Hm = Hydrophobicite_Average(seq[_ : _ + length], echelle)
        if Hmmax < Hm:
            Hmmax = Hm
    return Hmmax

def Mesohydrophobicite(seq, min_len = 60, max_len = 80, echelle = 0): # min_len and max_len need minus 1 from the origin codes
    debut = 0
    somme_msh = 0.0
    aux_h = 0.0
    uaa = debut + min_len - 2
    acum_meso_h = 0.0
    small_wdw = min_len - 1 
    steps = 0
    
    if len(seq) < min_len:
        return Hydrophobicite_Average(seq)
    for _ in range(debut, uaa + 1):
        if (echelle == 0):
            aux_h += GES[seq[_]]
        elif echelle == 1:
            aux_h += EKD[seq[_]]
        elif echelle == 2:
            aux_h += GVH[seq[_]]
        elif echelle == 3:
            aux_h += AAH[seq[_]]
    while True:
        if (echelle == 0):
            aux_h += GES[seq[small_wdw]]  
        elif echelle == 1:
            aux_h += EKD[seq[small_wdw]]
        elif echelle == 2:
            aux_h += GVH[seq[small_wdw]]
        elif echelle == 3:
            aux_h += AAH[seq[small_wdw]]
        meso_h = -1000.0
        l_aux_h = aux_h
        uaa = small_wdw + 1
        while uaa < len(seq):
            if (echelle == 0):
                l_aux_h = l_aux_h - GES[seq[uaa - small_wdw - 1]] + GES[seq[uaa]]
            elif echelle == 1:
                l_aux_h = l_aux_h - EKD[seq[uaa - small_wdw - 1]] + EKD[seq[uaa]]
            elif echelle == 2:
                l_aux_h = l_aux_h - GVH[seq[uaa - small_wdw - 1]] + GVH[seq[uaa]]
            elif echelle == 3:
                l_aux_h = l_aux_h - AAH[seq[uaa - small_wdw - 1]] + AAH[seq[uaa]]
            if meso_h < l_aux_h:
                meso_h = l_aux_h
            uaa += 1
        acum_meso_h += meso_h / (small_wdw + 1)
        small_wdw += 1
        steps += 1
        if small_wdw + 1 > max_len or small_wdw + 1 >= len(seq):
            break
    return acum_meso_h / steps


def Moment_hydrophobicite_maximum(seq, first, last, angle = 95, echelle = 0, longwin = 18):
    #type Mhm_Type
    #   Muh : Real;
    #   Pos : Integer;
    Mhm_type = [0.0, 0]
    xi = yi = 0.0
    angrad = angle * 3.1415926 / 180.0
    
    if len(seq) < first + longwin: #Should I minus 1 here?
        return Mhm_type
    for _ in range(first, first + longwin):
        if (echelle == 0):
            pw = GES[seq[_]]
        elif echelle == 1:
            pw = EKD[seq[_]]
        elif echelle == 2:
            pw = GVH[seq[_]]
        elif echelle == 3:
            pw = AAH[seq[_]]
        a = (_ + 1) * angrad # Should I add 1?
        xi = xi + pw * math.cos(a) # return radian of cos(i)
        yi = yi + pw * math.sin(a)
    Mhm_type[0] = math.hypot(xi, yi) # return sqrt of (xi * xi + yi * yi)
    Mhm_type[1] = first
    for _ in range(first + 1, last - longwin + 2):
        if (_ + longwin - 1) >= len(seq):
            return Mhm_type
        else:
            if (echelle == 0):
                pw = GES[seq[_ - 1]]
                qw = GES[seq[_ + longwin - 1]]
            elif echelle == 1:
                pw = EKD[seq[_ - 1]]
                qw = EKD[seq[_ + longwin - 1]]
            elif echelle == 2:
                pw = GVH[seq[_ - 1]]
                qw = GVH[seq[_ + longwin - 1]]
            elif echelle == 3:
                pw = AAH[seq[_ - 1]]
                qw = AAH[seq[_ + longwin - 1]]
            xa = _ * angrad
            ya = (_ + longwin) * angrad
            xi = xi - pw * math.cos(xa) + qw * math.cos(ya)
            yi = yi - pw * math.sin(xa) + qw * math.sin(ya)
            uh = math.hypot(xi, yi)
            if Mhm_type[0] < uh:
                Mhm_type[0] = uh
                Mhm_type[1] = _
    return Mhm_type


def Hmx(seq, first, weight = Weight_75, echelle = 0, longwin = 18):
    mh = 0.0
    posit = first
    counter = 0
    ary_aa_turn = []
    maxwin = first + longwin - 1
    if first == -1: # Should I use -1
        return 0.0
    if maxwin > len(seq) - 1:
        maxwin = len(seq) - 1
    for _ in range(0, weight.complete_turn):
        ary_aa_turn.append(weight.values[_])
    for _ in range(0, weight.aa_to_hmax):
        aux = ary_aa_turn[_] + posit
        if aux <= maxwin: #aux >= first
            if echelle == 0:
                mh += GES[seq[aux]]
            elif echelle == 1:
                mh += EKD[seq[aux]]
            elif echelle == 2:
                mh += GVH[seq[aux]]
            elif echelle == 3:
                mh += AAH[seq[aux]]
            counter += 1
    hmax = 7.0 * mh / counter
    acycle = weight.complete_turn
    num_of_resid = 1
    while True:
        j = 0
        k = 0 + weight.aa_to_hmax
        while num_of_resid <= longwin and j < acycle: 
            aux = ary_aa_turn[j] + posit
            if aux <= maxwin:
                if echelle == 0:
                    mh -= GES[seq[aux]]
                elif echelle == 1:
                    mh -= EKD[seq[aux]]
                elif echelle == 2:
                    mh -= GVH[seq[aux]]
                elif echelle == 3:
                    mh -= AAH[seq[aux]]
                counter -= 1
            j += 1
            if k > weight.complete_turn - 1:
                k = 0
            aux = ary_aa_turn[k] + posit
            if aux <= maxwin: #aux >= first
                if echelle == 0:
                    mh += GES[seq[aux]]
                elif echelle == 1:
                    mh += EKD[seq[aux]]
                elif echelle == 2:
                    mh += GVH[seq[aux]]
                elif echelle == 3:
                    mh += AAH[seq[aux]]
                counter += 1
            k += 1
            aux_mh = 7.0 * mh / counter
            if aux_mh > hmax:
                hmax = aux_mh
            num_of_resid += 1
            
        if acycle < longwin:
            acycle = acycle + weight.complete_turn
            posit = posit + weight.complete_turn
        if num_of_resid > longwin:
            break
    return hmax

def frequence(seq, nu, first = -1, last = -1):
    nb = 0
    start = 0
    stop = len(seq) - 1
    if first > start:
        start = first
    if last < 0 and last < stop:
        stop = last
    for _ in range(start, stop + 1):
        if seq[_] == nu:
            nb += 1
    return nb / (stop - start + 1.0)


