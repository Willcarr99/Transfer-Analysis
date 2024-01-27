import numpy as np
import pylab as py
import matplotlib.pyplot as plt

############################################################
# Inputs

file_name = 'fort.201'

############################################################
# Note: If thmax in the fresco input file is positive, the cross section is given 
# as the ratio of the absolute cross section to the rutherford scattering cross section.
# If negative, it is the absolute cross section [mb/sr].
############################################################
# Read from file

f = open(file_name, 'r')
lines = f.read().splitlines()
theta = []
sigma = []

for line in lines:
    if not (line[0] == '#' or line[0] == '@' or line == ' END'):
        x_vals = line[:14]
        y_vals = line[14:24]
        x_no_space = float(x_vals.strip())
        y_no_space = float(y_vals.strip())
        theta.append(x_no_space)
        sigma.append(y_no_space)

title = lines[1][9:].strip()
title = title.replace("\"", "")

f.close()

#print(x)
#print(y)
#print(title)

############################################################
# Plotting

deg = u'\N{DEGREE SIGN}'

ax = py.subplot(111)
ax.scatter(theta, sigma, c = 'k')
ax.set_xlabel(r'$\theta \, [$' + deg + ']', size = 15)
ax.set_ylabel(r'$\frac{d \sigma}{d \Omega} / {\frac{d \sigma}{d \Omega}}_{Ruth}$', size = 15)
ax.set_title(title, size = 20)
ax.semilogy()
plt.grid(True, which = 'both')
plt.show()

