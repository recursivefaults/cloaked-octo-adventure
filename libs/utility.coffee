diceRoller = (expression) ->
    parsed = /(\d+)d(\d+)([+-]\d+){0,1}/.exec expression
    numDice = parsed[1]
    diceSize = parsed[2]
    mod = 0
    if parsed[3]?
        mod = parseInt(parsed[3])
    total = 0
    for i in [0...numDice]
        total += Math.floor(Math.random() * (diceSize - 1) + 1)
    total += mod
    return total
exports.diceRoller = diceRoller
