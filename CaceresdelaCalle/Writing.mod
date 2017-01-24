MODULE Writing          ! Draws characters on the tilt table


    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    LOCAL VAR string character_to_write;
    LOCAL VAR num coef;         ! Reduces size in V & I writing modes
    
    LOCAL VAR pose desplz:= [ [x_small+space_small, 0, 0], [1, 0, 0, 0] ];
    
    PROC main_write_text(string text_to_write, num size, num writing_mode)
        
        TEST writing_mode
            CASE 1:     ! H
                coef:=1;
            CASE 2:     ! V
                PDispOn \ExeP:= Offs(oblanca, 200, -10, 0), oblanca, pinzalapiz \WObj:=mblanca;
                coef:=0.3;
            CASE 3:     ! 30º
                desplz.rot:= orientzyx(30,0,0);
                pdispset desplz;
                coef:= 0.75;
            DEFAULT:    ! This won't happen
                TPWrite "Incorrect writing mode chosen";
        ENDTEST
        
        IF size=1 THEN
            x:=     x_big * coef;
            y:=     y_big * coef;
            z:=     z_big * coef;
            space:= space_big * coef;
        ELSE
            x:=     x_small * coef;
            y:=     y_small * coef;
            z:=     z_small * coef;
            space:= space_small * coef;
        ENDIF
           
        FOR i FROM 1 TO StrLen(text_to_write) DO
            
            character_to_write:= strpart(text_to_write, i, 1);
            
            TEST character_to_write
                CASE "0":
                    digit_0;
                CASE "1":
                    digit_1;
                CASE "2":
                    digit_2;
                CASE "3":
                    digit_3;
                CASE "4":
                    digit_4;
                CASE "5":
                    digit_5:
                CASE "6":
                    digit_6;
                CASE "7":
                    digit_7;
                CASE "8":
                    digit_8;
                CASE "9":
                    digit_9;
                CASE "A":
                    letter_A;
                CASE "E":
                    letter_E;
                CASE "I":
                    letter_I;
                CASE "O":
                    letter_O;
                CASE "U":
                    letter_U;
                CASE "R":
                    letter_R;
                CASE "S":
                    letter_S;
                CASE "T":
                    letter_T;
                CASE "N":
                    letter_N;
                CASE "M":
                    letter_M;
                CASE "D":
                    letter_D;
                ! ...
                    
                DEFAULT:
                    TPWRITE "El robot no sabe dibujar la letra"+ character_to_write;
            
                TEST writing_mode
                    CASE 1:     ! H
                        PDispOn \ExeP:= Offs(oblanca, -x-space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;
                    CASE 2:     ! V
                        PDispOn \ExeP:= Offs(oblanca, 0, -y-space, 0), oblanca, pinzalapiz \WObj:=mblanca;
                    CASE 3:     ! 30º
                        PDispOn \ExeP:= Offs(oblanca, -x-space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;
                    DEFAULT:
                ENDTEST

            ENDTEST
            
            TEST writing_mode
                CASE 1:     ! H
                    PDispOn \ExeP:= Offs(oblanca, x+space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;
                CASE 2:     ! V
                    PDispOn \ExeP:= Offs(oblanca, 0, y+space, 0), oblanca, pinzalapiz \WObj:=mblanca;
                CASE 3:     ! 30º
                        PDispOn \ExeP:= Offs(oblanca, x+space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;
                DEFAULT:    ! This won't ever happen
                    TPWrite "Incorrect writing mode chosen";
            ENDTEST
            
            IF pen_change_needed THEN
               
                pen_change_needed:= FALSE;
                PDispOff;
                
                main_Grab_Pen ongoing_cube+1 \taken_cube:=ongoing_cube;
                
                MoveL oblanca, AvgVel,fine,pinzalapiz \WObj:= mblanca;
                
                TEST writing_mode
                    CASE 1:     ! H
                        PDispOn \ExeP:= Offs(oblanca, i*x+i*space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;   ! Not the most orthodox, but undoubtely the easiest way
                    CASE 2:     ! V
                        PDispOn \ExeP:= Offs(oblanca, 200, -10 + i*y+i*space, 0), oblanca, pinzalapiz \WObj:=mblanca;   ! Not the most orthodox, but undoubtely the easiest way
                    CASE 3:     ! 30º
                        pdispset desplz;
                        desplz.rot:= orientzyx(30,0,0);
                        PDispOn \ExeP:= Offs(oblanca, i*x+i*space, 0, 0), oblanca, pinzalapiz \WObj:=mblanca;   ! Not the most orthodox, but undoubtely the easiest way
                    DEFAULT:    ! This won't ever happen
                        TPWrite "Incorrect writing mode chosen";
                ENDTEST

                
                IWatch color_pen;   ! Start detecting this interruption again
                
            ENDIF
            
        ENDFOR
        
        PDispOff;
        MoveL oblanca, v300, fine, pinzalapiz\WObj:=mblanca;
    
    ENDPROC
    
    PROC digit_0()
        MoveL Offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC digit_1()
        MoveL Offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0.5*x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0.5*x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0.5*x, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_2()
        MoveL Offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_3()
        MoveL Offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;        
        MoveL Offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_4()
        MoveL Offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_5()
        MoveL Offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_6()
        MoveL Offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_7()
        MoveL Offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL Offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
    ENDPROC
    
    PROC digit_8()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC digit_9()
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_A()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_E()
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_I()
        MoveL offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_O()
        MoveL Offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz, \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, z10, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_U()
        MoveL offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_R()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_S()
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_T()
        MoveL offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
        
    PROC letter_N()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_M()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0.5*x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_J()
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, z30, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;        
    ENDPROC
    
    PROC letter_D()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, z30, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, z30, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_H()
        MoveL offs(oblanca, 0, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    PROC letter_P()
        MoveL offs(oblanca, 0, 0, z), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, y, 0), AvgVel, fine, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, x, 0.5*y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, 0), AvgVel, z10, pinzalapiz \WObj:=mblanca;
        MoveL offs(oblanca, 0, 0.5*y, z), AvgVel, z10, pinzalapiz \WObj:=mblanca;
    ENDPROC
    
    ! ...
    
ENDMODULE