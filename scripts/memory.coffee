# Description:
#   Use hubots redis brain to store useful information
#
# Author:
#   locks
#
# Commands:
#   hubot learn "<key name>" means <value> - Get Hubot to memorize something new
#   hubot relearn "<key name>" means <value> - Overwrite something that Hubot learned before
#   hubot learned - Check all the things Hubot as learned so far
#   hubot remember "<key name>" - Retrieves a specific fact
#   hubot <key name>? - Retrieves a specific fact

admins = { 'lala': 'lala' }

module.exports = (robot) ->

  actuallyLearnMethod = (res, key, value) ->
    robot.brain.set key, value
    robot.brain.save
    res.reply "gotcha :+1:, *'#{key}'* means '#{value}'"

  learnMethod = (res) ->
    [_, key, value] = res.match
    thought = robot.brain.get key
    if thought
      res.reply "I've already learnt that :sunglasses: \" #{key} \" means #{thought}"
    else
      actuallyLearnMethod(res, key, value)

  relearnMethod = (res) ->
    [_, key, value] = res.match
    actuallyLearnMethod(res, key, value)

  robot.respond /learn "([^"]+)" (.+)$/i, (res)-> learnMethod(res)

  robot.respond /relearn "([^"]+)" (.+)$/i, (res)-> relearnMethod(res)

  rememberMethod = (res) ->
    console.log(res.match)
    [_, match] = res.match
    thought = robot.brain.get match
    if thought
      res.send thought
    else
      res.send "sorry, I don't know this :("

  robot.respond /.*remember "([^"]+)".*/, rememberMethod
  robot.respond /([^?]+)\?/, rememberMethod

  robot.respond /learned/, (res) ->
    res.reply ("My friends have taught me about," + "\n" + Object.keys(robot.brain.data._private).join("\n"))

  robot.respond /forget "([^"]+)"/i, (res) ->
    [_, match] = res.match
    username = message.envelope.user.name

    unless username of admins
      res.reply "sorry, you don't have permissions :stuck_out_tongue_winking_eye:"
      return

    thought = robot.brain.get match
    if match
      robot.brain.remove match
      robot.brain.save
      res.reply "#{match}? never heard about it. :wink:"
    else
      res.reply "I never learned about #{match}"


# DM: robot.send {room: message.envelope.user.name}, message
