(cond-expand
  (chicken-4 (use (prefix sdl2 "sdl2:")
                  (prefix sdl2-ttf "ttf:")))
  (chicken-5 (import (prefix sdl2 "sdl2:")
                     (prefix sdl2-ttf "ttf:"))))

(sdl2:set-main-ready!)
(sdl2:init!)
(ttf:init!)

;; works better if write exact location of font 
(define font (ttf:open-font "/usr/local/share/fonts/comic-neue/ComicNeue-Regular.ttf" 20))
(define text "Hello, World!")
(define-values (w h) (ttf:size-utf8 font text))

(define window (sdl2:create-window! "Hello, World!" 0 0 1920 1080))
(sdl2:fill-rect! (sdl2:window-surface window)
                 #f
                 (sdl2:make-color 0 128 255))

(sdl2:fill-rect! (sdl2:window-surface window)
		 (sdl2:make-rect 200 200 400 600)
                 ;;#f
                 (sdl2:make-color 255 128 255))

(let ((text-surf (ttf:render-utf8-shaded
                  font text
                  (sdl2:make-color 0   0   0)
                  (sdl2:make-color 255 255 255))))
  (sdl2:blit-surface! text-surf
		      #f
                      (sdl2:window-surface window) #f)
  ;; place text at 300 300
  (sdl2:blit-surface! text-surf
		      #f
                      (sdl2:window-surface window)
		      (sdl2:make-rect 300 300 w h)))

(sdl2:update-window-surface! window)
(sdl2:delay! 5000)
(sdl2:quit!)


