generateLoadJob = job {}

generateLoadJob.with {
  name 'Generate Load'

  description '''
    This job writes /dev/urandom to /dev/null to generate CPU and disk load
  '''
  
  label 'dev'

  steps {
    shell('''
      dd if=/dev/urandom of=/dev/null bs=1M count=256
    ''')
  }
}
