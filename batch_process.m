data_dir = 'data\';

%% save as off
off_files = dir([data_dir '*.m']);
for i = 1:length(off_files)
    name = off_files(i).name;
    name_out = [name(1:end-2) '.off'];
	command = ['python m2off.py ' data_dir name ' ' data_dir name_out];
    system(command);
end
%% taubin smooth
off_files = dir([data_dir '*.off']);
for i = 1:length(off_files)
    name = off_files(i).name;
    name_out = [name(1:end-4) '.smooth.off'];
	command = ['"C:\Program Files\VCG\MeshLab\meshlabserver.exe" -i ' data_dir name ' -o ' data_dir name_out ' -s taubin_smooth.mlxs'];
    system(command);    
end

%% save as mfile
off_files = dir([data_dir '*.smooth.off']);
for i = 1:length(off_files)
    name = off_files(i).name;
    name_out = [name(1:end-4) '.smooth.m'];
	command = ['any2m.exe ' data_dir name ' ' data_dir name_out];
    system(command);
end

%% compute conformal map
off_files = dir([data_dir '*.remesh.m']);
for i = 1:1
    name = off_files(i).name;
    name = name(1:end-9);
	command = ['RicciRiemannMap.bat ' data_dir name];
    system(command);
end