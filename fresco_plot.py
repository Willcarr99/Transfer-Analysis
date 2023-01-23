import numpy as np
import pylab as py
import matplotlib.pyplot as plt

############################################################
# Inputs

file_name_ES = 'fort.201'
file_name_Transfer = 'fort.202'

############################################################
# Note: If thmax in the fresco input file is positive, the cross section is given 
# as the ratio of the absolute cross section to the rutherford scattering cross section.
# If negative, it is the absolute cross section [mb/sr].
############################################################
# Read cross sections from fort.201 or fort.202

f_ES = open(file_name_ES, 'r')
lines = f_ES.read().splitlines()
theta_ES = []
sigma_ES = []

for line in lines:
    if not (line[0] == '#' or line[0] == '@' or line == ' END'):
        x_vals = line[:14]
        y_vals = line[14:24]
        x_no_space = float(x_vals.strip())
        y_no_space = float(y_vals.strip())
        theta_ES.append(x_no_space)
        sigma_ES.append(y_no_space)

f_ES.close()

f_Transfer = open(file_name_Transfer, 'r')
lines = f_Transfer.read().splitlines()
theta_Transfer = []
sigma_Transfer = []

for line in lines:
    if not (line[0] == '#' or line[0] == '@' or line == ' END'):
        x_vals = line[:14]
        y_vals = line[14:24]
        x_no_space = float(x_vals.strip())
        y_no_space = float(y_vals.strip())
        theta_Transfer.append(x_no_space)
        sigma_Transfer.append(y_no_space)

title = lines[1][9:].strip()
title = title.replace("\"", "")

f_Transfer.close()

############################################################
# Read settings from fort.3

settings_file = 'fort.3'
settings = open(settings_file, 'r')
lines = settings.read().splitlines()

par_hcm = 0
par_rmatch = 0
par_jtmax = 0

for line in lines:
    if line[1:4] == 'HCM':
        str_hcm = line[5:].replace(",", "")
        par_hcm = float(str_hcm.strip())
    elif line[1:7] == 'RMATCH':
        str_rmatch = line[8:].replace(",", "")
        par_rmatch = float(str_rmatch.strip())
    elif line[1:6] == 'JTMAX':
        str_jtmax = line[7:].replace(",", "")
        par_jtmax = float(str_jtmax.strip())

settings.close()

############################################################
# Plotting

deg = u'\N{DEGREE SIGN}'

## fort.201
ax = py.subplot(111)
plt.plot(theta_ES, sigma_ES, c = 'k', label = 'hcm = ' + str(par_hcm) + ', rmatch = ' + str(par_rmatch) + ', jtmax = ' + str(par_jtmax))
plt.legend(loc="upper right")
ax.set_xlabel(r'$\theta_{cm} \, [$' + deg + ']', size = 15)
ax.set_ylabel(r'$\frac{d \sigma}{d \Omega} / {\frac{d \sigma}{d \Omega}}_{Ruth}$', size = 15)
ax.set_title(title + ' (' + file_name_ES + ')', size = 20)
ax.semilogy()
plt.grid(True, which = 'both')
plt.show()

## fort.202
ax = py.subplot(111)
plt.plot(theta_Transfer, sigma_Transfer, c = 'k', label = 'hcm = ' + str(par_hcm) + ', rmatch = ' + str(par_rmatch) + ', jtmax = ' + str(par_jtmax))
plt.legend(loc="upper right")
ax.set_xlabel(r'$\theta_{cm} \, [$' + deg + ']', size = 15)
ax.set_ylabel(r'$d \sigma / d \Omega \, [mb/sr]$', size = 15)
ax.set_title(title + ' (' + file_name_Transfer + ')', size = 20)
ax.semilogy()
plt.grid(True, which = 'both')
plt.show()


