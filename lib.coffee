class exports.Document
    constructor: (@text, @maxLength)->
        throw "Text should be a string" unless @text.constructor == String
        @lines = new Array
        @makeParagraphs()
        @makeLines()

    makeParagraphs: ()->
        lines = @text.split(/\n/)
        @paragraphs = (new exports.Paragraph(paragraph).toWordList() for paragraph in lines)

    makeLines: ()->
        for paragraph in @paragraphs
            @currentLine = new Array
            while paragraph.length
                nextWord = new exports.Word(paragraph.shift())
                @addNextWordToLines(nextWord)
                @addLine(@currentLine.join(' ')) unless paragraph.length 

    addNextWordToLines: (nextWord)->
        while nextWord.length > @maxLength
            nextWord = new exports.Word(@chopUpLengthyWord(nextWord))
        unless nextWord.canFitOn(@currentLine, @maxLength)
            @addLine(@currentLine)
            @currentLine = new Array
        @currentLine.push(nextWord)

    addLine: (line)->
        line = line.join(' ') if line.constructor == Array
        @lines.push(line)

    chopUpLengthyWord: (nextWord)->
        @addLine(@currentLine)
        @currentLine = [nextWord.truncateAt(@maxLength)]
        return nextWord.remainderAfter(@maxLength)

class exports.Paragraph extends String
    constructor: (__value__) ->
        @length = (@__value__ = __value__ or "").length

    toString: -> @__value__
    valueOf: -> @__value__

    toWordList: ->
        this.split(/\s+/).filter((p)-> return p if p.length > 0)


class exports.Word extends String
    constructor: (__value__) ->
        @length = (@__value__ = __value__ or "").length

    toString: -> @__value__
    valueOf: -> @__value__

    truncateAt: (maxLength)->
        "#{@[0..(maxLength-2)]}-"

    remainderAfter: (maxLength)->
        @[(maxLength-1)..-1] 

    canFitOn: (line, maxLength)->
        lengthOfNewLineAsString = "#{line.join(' ')} #{this}".length
        #subtract one if the line is empty
        lengthOfNewLineAsString -= 1 if line.length == 0
        not (lengthOfNewLineAsString > maxLength) 
