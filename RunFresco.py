import re
import os
from fnmatch import fnmatch

root_folder = '/home/wcfox/Software/fresco-3.4/3He-Transfer/Input_Global3He/'

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
