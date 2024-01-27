import re
import os
from fnmatch import fnmatch

## Run Fresco for all .in files in the directory root_folder
## Directory structure: root_folder/<E>keV/Jpi<J><pi>/l<l>/n<n>/j<j>
## <E> = ENSDF energy of excited state in keV (rounded to nearest integer)
## <J> = Total spin of exicted state
## <pi> = Parity of excited state (+ or -)
## <l> = Relative orbital angular momentum of target + transfer particle
## <n> = Node of single-particle state
## <j> = Total angular momentum of single-particle state (spin + orbital): Assuming half-integer. Use hyphen, as in "3-2", to represent three halves.

## e.g. 39K(3He,d)40Ca proton-transfer: 4491 keV state:
## root_folder/4491keV/Jpi5-/l3/n1/j5-2
## root_folder/4491keV/Jpi5-/l3/n1/j7-2
## root_folder/4491keV/Jpi5-/l3/n2/j5-2
## root_folder/4491keV/Jpi5-/l3/n2/j7-2
## root_folder/4491keV/Jpi5-/l5/n1/j9-2
## root_folder/4491keV/Jpi5-/l5/n1/j11-2
## root_folder/4491keV/Jpi5-/l7/n1/j13-2
## root_folder/4491keV/Jpi5-/l7/n1/j15-2

root_folder = '../Data/Input_Global3He/'

root_folder_len = len(root_folder)
filepaths = []
for path, subdirs, files in os.walk(root_folder):
    for name in files:
        if fnmatch(name, '*Global3He.in'):
            filepaths.append(os.path.join(path, name))
        elif fnmatch(name, 'fort*'):
            os.remove(os.path.join(path, name))
        elif fnmatch(name, '*.out'):
            os.remove(os.path.join(path, name))

############################################################
# Sort the file_pathnames by ascending Jpi values, then ascending l values, then ascending n values, then ascending j values
# sorted() uses ASCII order, so e.g. j11-2 is before j9-2, but Jpi, l and n order is ascending properly (+ before - for Jpi values). 
filepaths = sorted(filepaths)

# Filter out the l(number)/n(number)/j(number(s))-2 segments of the file_pathnames
j_indices = []
j_val_lengths = []
for path in filepaths:
    match = re.search(r'l\d/n\d/j\d\d-2', path) # segment of path with l(number)/n(number)/j(two numbers)-2 --> e.g. 'l5/n1/j11-2'
    if (match == None):
        match = re.search(r'l\d/n\d/j\d-2', path) # segment of path with l(number)/n(number)/j(number)-2 --> e.g. 'l5/n1/j9-2'
    j_index = match.start() + 6 # index of the j in l(number)/n(number)/j(number(s))-2
    j_indices.append(j_index)
    j_val_lengths.append(len(match.group()) - 9) # 1 if j has single digit, and 2 if j has double digit e.g. 11 in 11-2 or 9 in 9-2

# Use natural sorting for the j values (e.g. j9-2 before j11-2) - naive way:
for p1 in range(len(filepaths)):
    for p2 in range(p1+1, len(filepaths)):
        # if the l(number)/n(number)/j part is the same between pairs, naturally sort the j values
        if (filepaths[p1][:j_indices[p1]+1] == filepaths[p2][:j_indices[p2]+1]):
            len_j1 = j_val_lengths[p1]
            len_j2 = j_val_lengths[p2]
            # Put the pair of j values in a list as integers e.g. [11, 9] for 'j11-2' and 'j9-2'
            j_val_pair = [int(filepaths[p1][j_indices[p1]+1:j_indices[p1]+1+len_j1]), int(filepaths[p2][j_indices[p2]+1:j_indices[p2]+1+len_j2])]
            # Only change the order of the file_pathname list if the first j value in the pair is greater than the second (sorted() already sorted them correctly if not)
            if j_val_pair[0] > j_val_pair[1]:
                larger_j_path = filepaths[p1]
                smaller_j_path = filepaths[p2]
                filepaths[p1] = smaller_j_path
                filepaths[p2] = larger_j_path
    
k = 0
for path in filepaths:
    dir_index = path.rfind('/') + 1
    directory_path = path[:dir_index]
    directory_path_len = len(directory_path)
    os.chdir(directory_path)
    command = 'fresco' + ' < ' + path[directory_path_len:] + ' > ' + path[directory_path_len:-2] + 'out'
    os.system(command)
    print('Fresco Run Complete: ' + str(k) + '/' + str(len(filepaths)))
    k+=1
