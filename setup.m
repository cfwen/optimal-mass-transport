%% add path for necessary package
addpath('library/polybool_clipper/')
if isempty(dir('library/polybool_clipper/*.mex*'))
    cd('library/polybool_clipper')
    makemex
    cd('../../')
end
addpath('library/matGeom/matGeom/geom2d/')
addpath('library/matGeom/matGeom/polygons2d/')
addpath(genpath('../geometry-processing-package/'))
