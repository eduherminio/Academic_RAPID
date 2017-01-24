MODULE User_Interaction         ! Enquires the user
    

    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    FUNC num ask_size()
        
        VAR num read_size;
        
        !TPReadnum read_size, "1 for extra size, other for std size";
        TPReadFK read_size, "Select size", "EXTRA", "STD", stEmpty, stEmpty, stEmpty;
        
        RETURN read_size;
        
    ENDFUNC
    
    
    FUNC num ask_mode()
        
        VAR num writing_mode;
        
        WHILE TRUE DO
            !TPReadnum writing_mode, "Writing mode: 1H, 2V, 3I";
            TPReadFK writing_mode, "Select writing mode", "Horizontal", "Vertical", "Inclined", stempty, stEmpty;
            IF writing_mode=1 OR writing_mode=2 OR writing_mode=3 THEN
                RETURN writing_mode;
            ENDIF
        ENDWHILE

    ENDFUNC
    
ENDMODULE