;
;  Convert h m s to decimal 
;
;
;
;====================================================
function jsexatodeg, ra_h, ra_m, ra_s, de_h, de_m, de_s  

  rad = (ra_h + ra_m / 60.0d + ra_s / 3600.0d) * 15.0d
  if de_h lt 0 then begin  
    decd = (de_h - de_m / 60.0d - de_s / 3600.0d)   ;Negative dec
  endif else begin 
    decd = (de_h + de_m / 60.0d + de_s / 3600.0d)   ;Positive dec
  endelse 

  return, [rad,decd]

END
