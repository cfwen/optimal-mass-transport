Optimal Mass Transport
---------------------------
Implement 2D optimal mass transport map based on theory in [Gu]. Domain can be unit circle or disk. Source measure is continuous, target measure is discrete. 

## Example:
Initial power digram is generated from random points, target area is set to 1/num_of_cells on all cells. Left is initial power diagram, right is final power diagram.
![alt text][initial.pd] ![alt text][final.pd]

See demo.m for more examples.

## Dependency:
* [geometry-processing-package][GPP]
* [export_fig][export_fig] (optional, use to generate fig)

   [Gu]: <http://arxiv.org/pdf/1302.5472v1>
   [GPP]: <https://bitbucket.org/group-gu/geometry-processing-package.git> 
   [export_fig]: <https://github.com/altmany/export_fig.git>
   [initial.pd]: result/initial_pd.png "initial power diagram"
   [final.pd]: resutl/final_pd.png "final power diagram"