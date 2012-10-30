require('should')
lib = require("./lib")

assert = require("assert")

describe "Document", ->
    document = undefined

    expectedArrayOutput = [ 'When', 'shall we', 'three', 'meet', 'again? In',
    'thunder,', 'lightni-', 'ng or in', 'rain?', 'When the', 'Hurlybu-',
    'rly\'s', 'done.', 'When the', 'battle\'s', 'lost and', 'won.', 'That',
    'shall be', '\'ere the', 'set of', 'the sun.' ]

    beforeEach(->
        testString = "
            When shall we three meet again? In thunder, lightning
            or in rain?\n
            When the Hurlyburly's done. When the battle's lost and won.\n
            That shall be 'ere the set of the sun.
            "
        document = new lib.Document(testString, 8)
    )

    it "should split paragraphs into arrays of words", ->
        document.paragraphs.every( (p)-> p.constructor.should.equal Array )

    it "should not contain any empty words", ->
        document.paragraphs.every(
            (p)-> p.every(
                (w)-> w.should.not.equal('')
            )
        )

    it "should create lines no longer than 8 characters", ->
        document.lines.length.should.not.equal 0
        document.lines.every(
            (line)-> line.length.should.not > document.maxLength
        )

    it "should flatten the text into n-character lines", ->
        for i in [0..document.lines.length-1]
            document.lines[i].should.equal(expectedArrayOutput[i])

    it "should be able to truncate words", ->
        word = new lib.Word("abcdefghijklmnop")
        word.truncatedAt(10).should.equal("abcdefghi-")
        word.truncatedAt(9).should.equal("abcdefgh-")

    it "should be able to get the remainder of a word", ->
        word = new lib.Word("abcdefghijklmnop")
        word.remainderAfter(10).should.equal("jklmnop")
        word.remainderAfter(3).should.equal("cdefghijklmnop")

    it "should split the entire word", ->
        for string in ["abcdefghijklmnop", "herpaderp", "foobarfoobarfoobar", "anyrandomstring"]
            word = new lib.Word(string)
            a = word.truncatedAt(5)
            b = word.remainderAfter(5)
            [a.replace(/-$/, ''),b].join('').should.equal(string)
