# chicken-sdl

# chicken scheme setup

```
chicken-install -s sdl2
chicken-install -s sdl2-ttf
```

fonts may need to be installed if look at source code , change font location 
to get examples to work 



# 001-hello 

```
(load "001-hello/hello.scm") ;; draw a blue background
```

# 002-rect

```
(load "002-rect/hello.scm") ;; draws a pink rectangle on blue background
```

# 003-text

```
(load "003-text/hello.scm") 
```

requires /usr/local/share/fonts/comic-neue/ComicNeue-Regular.ttf
how do we install this font ? 

fc-cache -f -v 
shows hello world in a window

# 004-rect-text

```
(load "004-rect-text/hello.scm") 
```

# 005-event-loop

```
(load "005-event-loop/basics.scm")
```

# 006-data-on

requires simple-loops egg

```
chicken-install -s simple-loops
```

we also need to be in 006-data-on directory 

```
(import chicken process-context)
(change-directory "006-data-on")
```

```
(load "viz.scm")
```

we should see a grid of values on the screen 
we can move left and right , if we attempt to go up the program crashes ?
example of a simple event loop and arrow key interactions




** advent of code 2016 day 22

Screenshot_2024-07-07_01-07-11.png

exploring chicken scheme modules
resulting exploration of puzzle is not entirely robust

can see visually there is a wall where cannot cross so need to go far left
through gap and then straight to coordinate 35 , 1

move right
down left left up right
and rinse and repeat until *GOLD* data is moved all the way across to coordinate 1,1
then done

using program found STEPS = 244

![solution image](https://github.com/terryc321/chicken-sdl/blob/main/Screenshot_2024-07-07_01-07-11.png?raw=true)

