Describe "passage-show"
    It "recursively lists the contents of a password store when not given arguments"
        list() {
            %text
            #|directory1/
            #|directory1/file1
            #|directory1/file2
            #|directory1/file3
            #|directory2/
            #|directory2/file1
            #|directory2/file2
            #|emptydir/
        }
        When call passage show
        The status should equal 0
        The stdout should equal "$(list)"
    End

    It "prints the decrypted contents of a password file when given one as an argument"
        When call passage show directory1/file1
        The status should equal 0
        The stdout should equal ")hUDX(P_tG0=DV/Lg5.gs.&("
    End

    It "copies the X11 clipboard when you pass it a file, and the -c switch"
        Pending "TODO: how would this test be done without trashing the Xorg session?"
        #When call passage show -c directory1/file1
        #The status should equal 0
        #The stderr lines should equal 1
    End
End

