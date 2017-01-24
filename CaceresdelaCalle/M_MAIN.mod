 MODULE M_MAIN


    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    PERS tooldata pinzalapiz:=[TRUE,[[10.1132,12.4958,365.032],[1,0,0,0]],[0.7,[0,0,50],[1,0,0,0],0,0,0]];
    
    PERS wobjdata mblanca:=[FALSE,TRUE,"",[[376.425,56.4876,78.8893],[0.460043,0.0562816,-0.107564,-0.879558]],[[0,0,-8.3819E-06],[1,-6.55322E-09,3.42759E-09,-4.1933E-10]]];
    PERS wobjdata mrotuladores:=[FALSE,TRUE,"",[[66.2272,384.377,208.936],[0.00359982,-0.00288414,-0.0066725,0.999967]],[[0,0,-4.47035E-05],[1,0,0,0]]];
   
    !CONST robtarget oblanca:=[[22.23,27.29,0.09],[0.111052,0.961088,-0.251426,0.0275827],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];           ! Easier to check   - far away from table
    CONST robtarget oblanca:=[[22.23,27.29,-57.09],[0.111052,0.961088,-0.251426,0.0275827],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];          ! Real pos          - next to table
    !CONST robtarget oblanca:=[[22.23,27.29,-47.09],[0.111052,0.961088,-0.251426,0.0275827],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];          ! Real pos          - next to table
    CONST robtarget orotuladores:=[[-11.11,-0.57,14.58],[0.010101,-0.973646,-0.227838,0.00145648],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget Punto_Base:=[[0,0,0,0,90,-30],[1e9,1e9,1e9,1e9,1e9,1e9]];
    
    ! Global, numeric VAR's
    VAR string  chosen_characters;              ! 
    VAR num     ongoing_cube:=1;
    VAR bool    pen_change_needed:= FALSE;
       
    VAR num     n_digits;
    VAR num     n_letters;
    VAR num     n_pen_changes;
   
    VAR num x;
    VAR num y;
    VAR num z;
    VAR num space;
    
    ! #Define's
    CONST speeddata MinVel:=    v100;
    CONST speeddata AvgVel:=    v2500;
    CONST speeddata MaxVel:=    v3000;
    
    CONST num x_big:=       60;
    CONST num y_big:=       80;
    CONST num z_big:=       30;             ! Height of pinzalapiz when NOT writing
    CONST num space_big:=   10;             ! Inter-character space
    
    CONST num x_small:=     0.5*x_big;
    CONST num y_small:=     0.5*y_big;
    CONST num z_small:=     z_big;          !Height of pinzalapiz when NOT writing
    CONST num space_small:= 0.5*space_big;  ! Inter-character space

    
    VAR clock exec_time;        ! Clock
    VAR intnum color_pen;       ! Interrupt color_pen, not int num color_pen :)

    
    PROC main()
        
        VAR string  read_text;
        VAR string  text_to_write;
        VAR num     size;
        VAR num     writing_mode;

        ClkReset exec_time;                     ! Clocks
        ClkStart exec_time;
            
        CONNECT color_pen WITH change_pen;      ! Interrupcion
        ISignalDI di1, 1, color_pen;            ! Interruption
        Bookerrno ERR_PEN;                      ! New Error
        
        n_pen_changes:=0;                       ! Initialization
        
        create_chosencharacters;                ! Creates a file with the dictionary of characters.     Comment if not needed
        create_texto1;                          ! Creates a file with the desired content.              Comment if not needed
       
        read_text:=     read_text1();           ! Reads the content of the file
        read_chosencharacters;
        
        main_Grab_Pen 1;                        ! Takes pen #1
        
        ! Height test
        ! MoveL Offs(oblanca, -100, +100, +0), v80, fine, pinzalapiz \WObj:= mblanca;
        
        size:=          ask_size();             ! User selects size
        writing_mode:=  ask_mode();             ! User selects writing mode
        
        text_to_write:= select_text(read_text); ! Recognizes the text to be written
        
        main_write_text text_to_write, size, writing_mode;  ! Writes the text on the table
        
        final_analysis read_text, text_to_write;            ! Creates texto2.txt with an analysis of the process
 
        IDelete color_pen;                      ! Cancels interruption, so that it can be connected again in cae of cycle-execution
        ext_LeaveCube;                          ! Laves whichever pen it has in its place
        
        WaitTime 3; 
        
    ENDPROC

    TRAP change_pen                     ! Interruption handle
        IF n_pen_changes > 2 THEN
            IDelete color_pen;
            RETURN;
        ELSE
            n_pen_changes:= n_pen_changes+1;
        ENDIF
        
        pen_change_needed:= TRUE;       ! Will be checked as soon as the current character being written is finished
        
        TPWrite "Peticion de cambio de color detectada " \Num:= n_pen_changes;
        !Isleep color_pen;
        
    ENDTRAP
    

ENDMODULE