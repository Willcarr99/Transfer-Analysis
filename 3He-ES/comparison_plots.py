import numpy as np
import pylab as py
import matplotlib.pyplot as plt

############################################################
# Comparison plots for adjusting Fresco parameters like hcm, rmatch, and jtmax.

# Created by Will Fox on April 2nd, 2021
############################################################

############################################################
# Inputs

control_data = 'control_201.txt'
control_settings = 'control_3.txt'

parameter_adjusted_data = 'fort.201'
parameter_adjusted_settings = 'fort.3'

############################################################
# Read data from files

f_control = open(control_data, 'r')
lines = f_control.read().splitlines()

theta_control = []
sigma_control = []

for line in lines:
    if not (line[0] == '#' or line[0] == '@' or line == ' END'):
        x_vals = line[:14]
        y_vals = line[14:24]
        x_no_space = float(x_vals.strip())
        y_no_space = float(y_vals.strip())
        theta_control.append(x_no_space)
        sigma_control.append(y_no_space)

title = lines[1][9:].strip()
title = title.replace("\"", "")

f_control.close()

f_adjusted = open(parameter_adjusted_data, 'r')
lines = f_adjusted.read().splitlines()

theta_adjusted = []
sigma_adjusted = []

for line in lines:
    if not (line[0] == '#' or line[0] == '@' or line == ' END'):
        x_vals = line[:14]
        y_vals = line[14:24]
        x_no_space = float(x_vals.strip())
        y_no_space = float(y_vals.strip())
        theta_adjusted.append(x_no_space)
        sigma_adjusted.append(y_no_space)

f_adjusted.close()
############################################################
# Read settings from files

f_control_settings = open(control_settings, 'r')
lines = f_control_settings.read().splitlines()

par_hcm_control = 0
par_rmatch_control = 0
par_jtmax_control = 0

for line in lines:
    if line[1:4] == 'HCM':
        str_hcm = line[5:].replace(",", "")
        par_hcm_control = float(str_hcm.strip())
    elif line[1:7] == 'RMATCH':
        str_rmatch = line[8:].replace(",", "")
        par_rmatch_control = float(str_rmatch.strip())
    elif line[1:6] == 'JTMAX':
        str_jtmax = line[7:].replace(",", "")
        par_jtmax_control = float(str_jtmax.strip())

f_control_settings.close()

f_adjusted_settings = open(parameter_adjusted_settings, 'r')
lines = f_adjusted_settings.read().splitlines()

par_hcm_adjusted = 0
par_rmatch_adjusted = 0
par_jtmax_adjusted = 0

for line in lines:
    if line[1:4] == 'HCM':
        str_hcm = line[5:].replace(",", "")
        par_hcm_adjusted = float(str_hcm.strip())
    elif line[1:7] == 'RMATCH':
        str_rmatch = line[8:].replace(",", "")
        par_rmatch_adjusted = float(str_rmatch.strip())
    elif line[1:6] == 'JTMAX':
        str_jtmax = line[7:].replace(",", "")
        par_jtmax_adjusted = float(str_jtmax.strip())

f_adjusted_settings.close()
############################################################

#print(x)
#print(y)
#print(title)

############################################################
# Plotting

deg = u'\N{DEGREE SIGN}'

'''
par_control = ''
par_adjusted = ''
if parameter == 'hcm':
    par_control = str(par_hcm_control)
    par_adjusted = str(par_hcm_adjusted)
elif parameter == 'rmatch':
    par_control = str(par_rmatch_control)
    par_adjusted = str(par_rmatch_adjusted)
elif parameter == 'jtmax':
    par_control = str(par_jtmax_control)
    par_adjusted = str(par_jtmax_adjusted)
'''
par_hcm_control = str(par_hcm_control)
par_hcm_adjusted = str(par_hcm_adjusted)
par_rmatch_control = str(par_rmatch_control)
par_rmatch_adjusted = str(par_rmatch_adjusted)
par_jtmax_control = str(par_jtmax_control)
par_jtmax_adjusted = str(par_jtmax_adjusted)

ax = py.subplot(111)
#ax.scatter(theta_control, sigma_control, c = 'k', label = 'Control: ' + parameter + ' = ' + par_control)
#ax.scatter(theta_adjusted, sigma_adjusted, c = 'r', label = 'Adjusted: ' + parameter + ' = ' + par_adjusted)
ax.scatter(theta_control, sigma_control, c = 'k', label = '  Control: ' + 'hcm = ' + par_hcm_control + ', rmatch = ' + par_rmatch_control + ', jtmax = ' + par_jtmax_control)
ax.scatter(theta_adjusted, sigma_adjusted, c = 'r', label = 'Adjusted: ' + 'hcm = ' + par_hcm_adjusted + ', rmatch = ' + par_rmatch_adjusted + ', jtmax = ' + par_jtmax_adjusted)
plt.legend(loc="upper right")
ax.set_xlabel(r'$\theta_{cm} \, [$' + deg + ']', size = 15)
ax.set_ylabel(r'$\frac{d \sigma}{d \Omega} / {\frac{d \sigma}{d \Omega}}_{Ruth}$', size = 15)
ax.set_title(title, size = 20)
ax.semilogy()
plt.grid(True, which = 'both')
plt.show()
