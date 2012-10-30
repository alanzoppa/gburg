String::toWordList = ->
    return this.split(/\s+/).filter((p)-> return p if p.length > 0)

String::truncatedAt = (maxLength)->
    "#{this[0..(maxLength-2)]}-"

String::remainderAfter = (maxLength)->
    this[(maxLength-1)..-1]



class exports.Document
    constructor: (@text, @maxLength)->
        throw "Text should be a string" unless @text.constructor == String
        @lines = new Array
        @makeParagraphs()
        @makeLines()

    makeParagraphs: ()->
        lines = @text.split(/\n/)
        @paragraphs = (paragraph.toWordList() for paragraph in lines)

    makeLines: ()->
        for paragraph in @paragraphs
            @currentLine = new Array
            while paragraph.length
                nextWord = paragraph.shift()
                @addNextWordToLines(nextWord)
                @addLine(@currentLine.join(' ')) unless paragraph.length 

    addNextWordToLines: (nextWord)->
        while nextWord.length > @maxLength
            nextWord = @chopUpLengthyWord(nextWord)
        if @cantFit(nextWord)
            @addLine(@currentLine)
            @currentLine = new Array
        @currentLine.push(nextWord)

    addLine: (line)->
        line = line.join(' ') if line.constructor == Array
        @lines.push(line)

    chopUpLengthyWord: (nextWord)->
        @addLine(@currentLine)
        @currentLine = [nextWord.truncatedAt(@maxLength)]
        return nextWord.remainderAfter(@maxLength)

    cantFit: (nextWord)->
        @currentLine.join(' ').length + nextWord.length > @maxLength

