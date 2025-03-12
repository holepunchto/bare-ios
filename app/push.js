console.log('Hello iOS notifcations!')

BareKit.on('push', (payload, reply) => {
  console.log('Notification received:', JSON.parse(payload))

  // VoIP notifications

  reply(
    null,
    JSON.stringify({
      caller: 'John Bare',
      type: 'call'
    })
  )

  // Push notifications

  // reply(
  //   null,
  //   JSON.stringify({
  //     title: 'Hello Bare',
  //     body: 'This is a test',
  //     type: 'notif'
  //   })
  // )
})
