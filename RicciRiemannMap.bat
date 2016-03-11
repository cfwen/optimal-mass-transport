set mesh=%1
..\bin\RiemannMapper.exe -puncture %mesh%.remesh.m %mesh%.m
..\bin\RiemannMapper.exe -cut %mesh%.m %mesh%
..\bin\RiemannMapper.exe -slice %mesh%_0.cut.m %mesh%.open.m


..\bin\RiemannMapper.exe -idrf_riemann_map %mesh%.m %mesh%.open.m %mesh%.idrf.uv.m
..\bin\RiemannMapper.exe -fill_hole %mesh%.idrf.uv.m %mesh%.idrf.uv.m
