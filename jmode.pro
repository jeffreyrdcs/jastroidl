; 
; Compute the mode of an array using two different methods
; 
; 1. Uses of Histogram
; 2. Array sort
;
; Copy from a IDL group comp.lang.idl-pvwave
;==========================================================
pro jmode, array, output

 void=max(histogram(array,OMIN=mn),mxpos)
 mode1=mn+mxpos

 array=array[sort(array)]
 wh=where(array ne shift(array,-1),cnt)
 if cnt eq 0 then mode2=array[0] else begin
   void=max(wh-[-1,wh],mxpos)
   mode2=array[wh[mxpos]]
 endelse
 output = [mode1, mode2]


END
