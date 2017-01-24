 MODULE Pen_Interaction     ! Controls interaction with pen/cubes


    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    ! Nota: en el robot, di8 es la fotocélula y (en principio) no existe sensor de presión.
    ! Programa como si di8 fuera sensor de presión (configuración antigua).
    
    LOCAL PERS tooldata pinza:=[TRUE,[[0,0,206],[0.965926,0,0,0.258819]],[1.8,[2.7,0,84.4],[1,0,0,0],0.033,0.034,0.007]];
    LOCAL CONST speeddata MinVel:=v200;
    LOCAL CONST speeddata MaxVel:=v600;

    LOCAL CONST robtarget cube{5}:=[[[24.83,308.61,161.01],[0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[-51.17,308.79,159.01],[0,0,-1,0],[1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[-126.15,308.16,159.00],[0,0,-1,0],[1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[-199.14,308.15,158.98],[0,0,-1,0],[1,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[-272.13,308.14,158.97],[0,0,-1,0],[1,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]];
    LOCAL const bool MANUAL:=false;

    VAR num errorid:= 4800;                         ! Error if pen isn't in its position
    VAR errstr error_title:= "No pen detected";
    VAR errstr error_sol:= "The pen must be placed in its correct place";
    VAR num aux_var;
    VAR errnum ERR_PEN:=-1;
    
    PROC main_Grab_Pen(num n \num taken_cube)
        
        IF Present(taken_cube) THEN
            IF taken_cube <5 THEN
                LeaveCube cube{taken_cube};
            ELSE
                LeaveCube cube{5};
                n:=1;
            ENDIF
        ENDIF

        GrabCube cube{n};
        ongoing_cube:=n;
    ENDPROC

    PROC ext_LeaveCube()      ! To call externally Dejarcube (at the end of the program)
        MoveAbsJ [[0,0,0,0,90,-30],[9E9,9E9,9E9,9E9,9E9,9E9]],MaxVel,fine,pinza;
        LeaveCube cube{ongoing_cube};
        MoveAbsJ [[0,0,0,0,90,-30],[9E9,9E9,9E9,9E9,9E9,9E9]],MaxVel,fine,pinza;
    ENDPROC
    
    LOCAL PROC OpenGripper()     ! Opens the robot gripper
        SetDO do5,1;
        WaitTime 0.5;
        SetDO do5,0;
        WaitTime 0.5;
    ENDPROC

    LOCAL PROC CloseGripper()    ! Closes the robot gripper
        SetDO do6,1;
        WaitTime 0.2;
        SetDO do6,0;
        WaitTime 1.3;
    ENDPROC

    LOCAL PROC LeaveCube(robtarget cube)
        VAR num opt;
        VAR num z:=40;
        
        MoveAbsJ [[0,0,0,0,90,-30],[9E9,9E9,9E9,9E9,9E9,9E9]],MaxVel,fine,pinza; 
        cube.trans.z:=cube.trans.z+4*z;     ! +4*z
        MoveJ cube,MaxVel,fine,pinza;    
        cube.trans.z:=cube.trans.z-4*z;     ! -4*z
        MoveL cube,MinVel,fine,pinza;
        OpenGripper;
        cube.trans.z:=cube.trans.z+4*z;
        MoveL cube, MaxVel, fine, pinza;
    ENDPROC
    
    LOCAL PROC GrabCube(robtarget cube)
        VAR num opt;
        VAR num z:=40;

        OpenGripper;
        cube.trans.z:=cube.trans.z+4*z;     ! +2*z
        MoveJ cube, MinVel, fine, pinza;

        cube.trans.z:= cube.trans.z-4*z;    ! -2*z
        MoveL cube,MinVel,fine,pinza;
        CloseGripper;
        WaitTime 3;
        
        IF DInput(di8)=0 THEN
            ErrRaise "ERR_PEN", errorid, error_title, ERRSTR_TASK, error_sol, ERRSTR_CONTEXT, ERRSTR_EMPTY;
        ENDIF
        
        cube.trans.z:=cube.trans.z+4*z;
        MoveL cube,MinVel,fine,pinza;
        MoveAbsJ [[0,0,0,0,90,-30],[9E9,9E9,9E9,9E9,9E9,9E9]],MaxVel,fine,pinza;
        
        ERROR
            IF ERRNO= ERR_PEN THEN
                TPWrite "Place the pen in its correct place, pls";
                OpenGripper;
                cube.trans.z:=cube.trans.z+2*z;     ! +2*z
                MoveJ cube, MinVel, fine, pinza;
                WaitTime 5;
                
                TPReadFK aux_var, "Press when pen is ready", "Here", "Or here", "Or here", "Or here", "Or even here";
                
                cube.trans.z:= cube.trans.z-2*z;    ! -2*z
                MoveL cube,MinVel,fine,pinza;
                CloseGripper;
                WaitTime 3;
                
                IF DInput(di8)=0 THEN
                    RETRY;
                ELSE
                    TRYNEXT;
                ENDIF
            ENDIF
        ENDPROC

ENDMODULE