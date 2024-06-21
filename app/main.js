Bare
  .on('suspend', () => console.log('suspended'))
  .on('resume', () => console.log('resumed'))

Bare.IPC
  .on('data', (data) => console.log(data))
  .write('Hello from Bare')
