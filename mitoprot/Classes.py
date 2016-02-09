class hydrophob_scale:
    def __init__(self, Hydromax, Mesohydro, Mhm_75, Mhm_95, Mhm_100, Mhm_105, Hmx_75, Hmx_95, Hmx_100, Hmx_105):
        self.Hydromax = Hydromax 
        self.Mesohydro = Mesohydro
        self.Mhm_75 = Mhm_75
        self.Mhm_95 = Mhm_95
        self.Mhm_100 = Mhm_100
        self.Mhm_105 = Mhm_105
        self.Hmx_75 = Hmx_75
        self.Hmx_95 = Hmx_95
        self.Hmx_100 = Hmx_100
        self.Hmx_105 = Hmx_105
        
    def __str__(self):
        return str(self.Hydromax) + ' ' + str(self.Mesohydro) + ' ' + str(self.Mhm_75) +\
             ' ' + str(self.Mhm_95) + ' ' + str(self.Mhm_100) + ' ' + str(self.Mhm_105) +\
                  ' ' + str(self.Hmx_75) + ' ' + str(self.Hmx_95) + ' ' + str(self.Hmx_100) + ' ' + str(self.Hmx_105)
        
Eges = Eekd = Egvh = Eaah = hydrophob_scale(0.0, 0.0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0)


class Weight:
    def __init__(self, aa_to_hmax, complete_turn, values):
        self.aa_to_hmax = aa_to_hmax
        self.complete_turn = complete_turn
        self.values = values
        

Weight_75 = Weight(9, 24, [0,5,10,15,20,1,6,11,16,21,2,7,12,17,22,3,8,13,18,23,4,9,14,19])
Weight_95 = Weight(8, 19, [0,4,8,12,16,1,5,9,13,17,2,6,10,14,18,3,7,11,15])
Weight_100 = Weight(7, 18, [0,11,4,15,8,1,12,5,16,9,2,13,6,17,10,3,14,7])
Weight_105 = Weight(9, 24, [0,7,14,21,4,11,18,1,8,15,22,5,12,19,2,9,16,23,6,13,20,3,10,17])

Param_2 =     [[-73.69888, 20.86752,  0.02389, -0.11403, -0.32858, -0.07230, -1.62884,
      0.01063, -5.77033,  3.97155,  0.33495,  0.36786, -0.14372,  0.45354,
      -0.21127, -0.29360, -0.28662, -0.25556,-13.15266,  4.00750,  0.43010,
      0.42838,  0.34401,  0.04840, -0.41635, -0.69331, -0.41858, -0.42693,
      6.93752,-66.10239,  0.66065,  1.28801, -0.84230,  0.62314, -0.64103,
      -0.38797,  0.23765,  0.24277, 70.12612, 53.32846, -2.75695, -2.71579,
      -0.67257, -1.76077,  2.80495,  2.53503,  2.52518,  1.96901],
     [-84.83749, 22.02985, 0.03617, -0.11407, -0.12308, -1.36920,
      -1.41757, 0.02416, -6.05997, 4.51905, 0.33657, 0.43619, -0.18110,
      0.49205, -0.17395, -0.27610, -0.31709, -0.23148, -16.62201, 5.79386,
      0.48397, 0.52823, 0.28395, 0.09246, -0.43463, -0.72477, -0.38540,
      -0.46126, 9.11772, -72.09837, 0.63266, 1.14993, -1.02931, 0.70274,
      -0.73638, -0.33848, 0.26099, 0.36197, 76.47937, 56.73466, -2.58674,
      -2.41762, -0.83992, -1.62481, 2.79939, 2.49332, 2.62547, 1.74741]]

Param_6 = [[-73.49948, 20.75408, 0.02116, -0.10027, -0.33676, -0.21949, -1.52262,
      0.01129, -5.38999, 3.77926, 0.33534, 0.35335, -0.11192, 0.43049,
      -0.20566, -0.30599, -0.26909, -0.26477, -13.05739, 4.15928,
      0.41340, 0.44525, 0.31813, 0.04539, -0.39384, -0.67579, -0.41996,
      -0.41872, 6.32710, -66.18914, 0.64010, 1.27413, -0.84564, 0.66197,
      -0.65456, -0.36641, 0.23717, 0.20063, 69.17358, 53.43979, -2.70349,
      -2.75892, -0.64315, -1.73711, 2.75404, 2.49777, 2.45900, 1.96976],
     [-82.16539, 21.67161, 0.02608, -0.07039, -0.13183, -1.59344, -1.07160,
      0.02173, -4.33466, 4.01941, 0.36726, 0.39032, -0.14791, 0.46238,
      -0.19115, -0.28357, -0.23556, -0.25565, -16.27936, 6.40734, 0.44052,
      0.50412, 0.24475, 0.09000, -0.38153, -0.72280, -0.38391, -0.44034,
      6.05251, -71.01338, 0.62657, 1.21997, -0.97372, 0.78048, -0.69713,
      -0.31812, 0.23087, 0.22847, 72.05766, 55.59925, -2.66356, -2.56988,
      -0.62953, -1.73102, 2.72573, 2.41190, 2.38928, 1.77936]]

