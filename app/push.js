console.log('Hello iOS notifications!')

BareKit.on('push', (payload, reply) => {
  const {
    aps: { alert }
  } = JSON.parse(payload)

  console.log('Notification received:', alert)

  switch (alert.type) {
    // Push notification
    case 'notification':
      return reply(
        null,
        JSON.stringify({
          type: 'notification',
          title: alert.title,
          body: alert.body
        })
      )

    // VoIP notification
    case 'call':
      return reply(
        null,
        JSON.stringify({
          type: 'call',
          caller: alert.caller
        })
      )

    default:
      return reply(null, null)
  }
})
