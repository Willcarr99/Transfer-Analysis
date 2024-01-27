import re
import os
from fnmatch import fnmatch

##### REMEMBER TO MAKE A BACKUP FOLDER FOR root_folder BEFORE RUNNING THIS SCRIPT IN CASE SOMETHING GOES WRONG! #####

root_folder = '../Data/Input_Global3He/'

filepaths = []
for path, subdirs, files in os.walk(root_folder):
    for name in files:
        if fnmatch(name, '*Global3He.in'):
            filepaths.append(os.path.join(path, name))

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

# Remove the first filepath since it is 0 keV and has only 1 character for the energy (and we aren't changing it).
filepaths = filepaths[1:]

for path in filepaths:
    energy = int(path[61:65])
    if energy > 8360:
        new_path = path[:-3] + '_temp.in'
        f_input = open(path, 'r')
        f_output = open(new_path, 'w')
        lines = f_input.read().splitlines()
        k = 0
        for line in lines:
            if k == 45:
                line_list = line.split()
                be_index = re.search('be', line).start() + 3
                be_end_index = be_index + 4
                new_line = line[:be_index] + '0.001' + line[be_end_index:]
                f_output.write(new_line + '\n')
            else:
                f_output.write(line + '\n')
            k+=1
        f_input.close()
        f_output.close()
        
        os.remove(path)
        os.rename(new_path, path)
