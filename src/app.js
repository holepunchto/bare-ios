process.addon.dynamic = false

const { App } = require('fx-native')

const app = App.shared()

process
  .on('suspend', () => {
    console.log('suspend')
  })
  .on('resume', () => {
    console.log('resume')
  })

app
  .on('launch', () => {
    console.log('launch')
  })
  .on('suspend', () => {
    process.suspend()
  })
  .on('resume', () => {
    process.resume()
  })
  .run()
