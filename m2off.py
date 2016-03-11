import locale
import sys

m_name = sys.argv[1]
off_name = sys.argv[2]
m_file = open(m_name,'r')
vertex = []
face = []
lines  = m_file.readlines()

for line in lines:
    v = line.split()
    if v[0] == 'Vertex':
        x = float(v[2])
        y = float(v[3])
        z = float(v[4])
        vertex.append((x,y,z))
    elif v[0] == 'Face':
        vi = locale.atoi(v[2])
        vj = locale.atoi(v[3])
        vk = locale.atoi(v[4])
        face.append((3,vi-1,vj-1,vk-1))

m_file.close();
off_file = open(off_name,'w')
off_file.write('OFF\n')
off_file.write('%d %d 0\n' % (len(vertex), len(face)))
for v in vertex:
    off_file.write('%.12f %.12f %.12f\n' % v)
for f in face:
    off_file.write('%d %d %d %d\n' % f)

off_file.close()