set mesh=%1
..\bin\RiemannMapper.exe -puncture %mesh%.origin.m %mesh%.m
..\bin\RiemannMapper.exe -cut %mesh%.m %mesh%
..\bin\RiemannMapper.exe -slice %mesh%.cut.m %mesh%.open.m

REM..\bin\RiemannMapper.exe -idrf_riemann_map %mesh%.m %mesh%.open.m %mesh%_idrf.uv.m
REM..\bin\RiemannMapper.exe -fill_hole %mesh%_idrf.uv.m %mesh%_idrf.uv.m
REM..\bin\Mobius.exe %mesh%_idrf.uv.m 

REM..\bin\RiemannMapper.exe -yamabe_riemann_map %mesh%.m %mesh%.open.m %mesh%_yamabe.uv.m
REM..\bin\RiemannMapper.exe -fill_hole %mesh%_yamabe.uv.m %mesh%_yamabe.uv.m
REM..\bin\ViewerConverter.exe %mesh%_yamabe.uv.m ..\..\textures\checker_1k.bmp
REM..\bin\Mobius.exe %mesh%_yamabe.uv.m 


..\bin\RiemannMapper.exe -exact_form %mesh%.m %mesh%

..\bin\RiemannMapper.exe -cohomology_one_form_domain %mesh%.m %mesh%.open.m %mesh%_0.dv.m %mesh%_0.dv_uv.m 
..\bin\RiemannMapper.exe -diffuse %mesh%_0.dv.m %mesh%_0.dv_uv.m %mesh%_0.dv.m %mesh%_0.dv_uv.m

..\bin\RiemannMapper.exe -holomorphic_form %mesh%_0.du.m %mesh%_0.dv.m  
..\bin\RiemannMapper.exe -slit_map holomorphic_form_0.m 0 1 holomorphic.m 
..\bin\RiemannMapper.exe -integration holomorphic.m %mesh%.open.m %mesh%.uv.m 
..\bin\RiemannMapper.exe -polar_map %mesh%.m %mesh%.uv.m %mesh%.circ_uv.m
..\bin\RiemannMapper.exe -fill_hole %mesh%.circ_uv.m %mesh%.final_uv.m 
REM..\bin\Mobius %mesh%.final_uv.m