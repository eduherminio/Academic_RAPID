MODULE File             ! Creates, reads and modifies files


    ! Author:      Eduardo Cáceres de la Calle
    ! Subject:     Sistemas Robotizados
    ! Degree:      Industrial Electronics and Automatic Control Engineering
    ! University:  Universidad de Valladolid (UVa) - EII
    !
    ! Code written in 2016, during my first contact with RAPID.
    ! Uploaded for educational purposes only, don't be too hard on me :)



    PROC create_texto1()
    
        VAR iodev outfile;

        Open "texto1.txt", outfile \WRITE;
        Write outfile, "Y Eeduardo 000234";
        Close outfile;

    ENDPROC
    
    
    PROC create_chosencharacters()
        
        VAR iodev outfile;

        Open "chosencharacters.txt", outfile \WRITE;
        Write outfile, "0123456789AEIOURSTDM";
        Close outfile;       
    
    ENDPROC
    
    
    FUNC string read_text1()
        
        VAR string str;  
        VAR iodev infile;
        
        Open "texto1.txt", infile \READ;
        str:= Readstr(infile); 
        Close infile;
 
        RETURN str; 
        
    ENDFUNC
    
    PROC read_chosencharacters()
        
        VAR iodev charfile;
        
        Open "chosencharacters.txt", charfile \READ;
        chosen_characters:= ReadStr(charfile);
        Close charfile;
        
        TPWrite ("Chosen characters:");
        TPWrite chosen_characters;
    
    ENDPROC
    
    PROC write_text2(num n_read_characters, string written_leters, string written_digits)
        
        VAR iodev outfile;
        
        Open "texto2.txt", outfile \WRITE;
        
        Write outfile, "Numero de caracteres leidos: " \Num:= n_read_characters;
        Write outfile, "Letras escritas: " \NoNewLine;
        Write outfile, written_leters;
        Write outfile, "Digitos escritos: " \NoNewLine;
        Write outfile, written_digits;
        Write outfile, "Fecha: " \NoNewLine;
        Write outfile, CDate();
        Write outfile, "Hora: " \NoNewLine;
        Write outfile, CTime();
        Write outfile, "Tiempo de ejecucion (s): " \NoNewLine;
        Write outfile, ""\Num:= ClkRead(exec_time);
        
        ClkStop exec_time;  ! Why not?
        
    ENDPROC 
    
ENDMODULE