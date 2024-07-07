
data.scm - reads s expression 
data.txt - actual s expression represents start grid ( Grid Type )
grid.scm - 2d grid implementation

hello.scm

((state #t)
 (hole (13 24))
 (gold (36 1))
 (grid (grid ((type grid) (width 36) (height 25) (data #(0 #(0 (used 67 size 94) (used 65 size 88) (used 73 size 92) (used 69 size 87) (used 70 size 87) (used 68 size 91) (used 70 size 87) (used 72 size 86) (used 73 size 88) (used 69 size 89) (used 70 size 86) (used 73 size 91) (used 72 size 93) (used 66 size 90) (used 66 size 94) (u .....

grid itself is a vector of vectors ... a 2d grid as it were

as long as (state #t) appears first in list then program assumes it is a well formed state
this means that errors crop up if try to pass data from a much larger drive onto empty drive
cannot do , so state becomes invalid
in which case the move is not carried through , global state is unchanged
although state is a true copy of state passed in
this helps debug as no side effects

control the hole - empty drive where copy data to drive ,
then hole moves where data came from

up ()
down ()
left ()
right ()

data copied to empty drive needs to fit onto empty drive 

each slot in grid has two values - used and size of drive

constraints being need to stay on grid 1,1 to 36,1 to 36,25
36 * 25 => 900 slots

*********************
*                     
*
*
@#####################
@*********_***********
**********************
**********************

puzzle really like this above
wall ####### of high values 


