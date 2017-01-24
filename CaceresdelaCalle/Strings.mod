MODULE Strings              ! Interprets strings and modifies them
    

    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    FUNC string select_text(string str)
        
        VAR string checked_str;
        n_digits:=0;
        n_letters:=0;
        
        str:= strmap(str, str_lower, str_upper);        ! Optional, if no distinction between lower and upper is desired (ie. wants lower to be written as upper)
        
        FOR i FROM 1 TO StrLen(str) DO
            
            IF (strmemb(str,i,chosen_characters) AND StrMemb(str, i, checked_str)=FALSE ) THEN     ! Among selected characters and not repeated
                IF (StrMemb(str, i, STR_DIGIT) AND n_digits<3 ) THEN    ! Not max. digits (3)
                    checked_str:= checked_str + strpart(str,i,1);
                    n_digits:= n_digits+1;
                ENDIF
                
                IF (Strmemb(str, i, STR_UPPER) AND n_letters<3) THEN    ! Not max. letters (3)
                    checked_str:= checked_str + strpart(str,i,1);
                    n_letters:= n_letters+1;
                ENDIF
            ENDIF
        ENDFOR
        
        TPWrite str;
        TPWrite checked_str;
            
        RETURN checked_str;
        
    ENDFUNC
    
    
    PROC final_analysis(string read_text, string written_text)
        
        VAR num n_read_char;
        VAR string written_letters;
        VAR string written_digits;
        
        n_read_char:= StrLen(read_text);
        
        FOR i FROM 1 TO StrLen(written_text) DO
            IF StrMemb(written_text, i, STR_DIGIT) THEN
                written_digits:= written_digits + StrPart(written_text, i, 1);  
            ELSEIF StrMemb(written_text, i, chosen_characters) THEN
                written_letters:= written_letters + StrPart(written_text, i, 1); 
            ENDIF             
        ENDFOR
        
        write_text2 n_read_char, written_letters, written_digits;
        
    ENDPROC
    
ENDMODULE