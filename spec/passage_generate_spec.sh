passage_generate_show() {
    passage generate "$1" && passage show "$1" && passage rm -r "${1%/*}"
}

Describe "passage-generate"
    It "generates a random, encrypted password, writing it to the password file given"
        When call passage_generate_show tmp/generated
        The status should equal 0
        The length of stdout should equal 24
    End
End

