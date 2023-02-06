process
  .on('beforeExit', () => {
    process.suspend()
  })
  .on('suspend', () => {
    console.log('suspended')
  })
