pipelineSeedJob = job {}

pipelineSeedJob.with {
  name 'CommonPipelineSeedJob'
  description '''
    This is the Common job that spawns pipelines.
    It takes the following arguments and generates a pipeline and the jobs that make up each stage of the pipeline.

    Arguments:
    APP_NAME         The name of the application being delivered through the pipeline
    APP_REPO         The github url for the application
    PATH_TO_DSL      The path (from the root of the application) to the pipeline config script
    APP_REPO_BRANCH  The specfic branch to build
  '''
  parameters {
    stringParam('APP_NAME', '',
      '''
       This is the name of your application.
       It will be used to label the pipeline seed job so that we can
       identify who a failure might belong to.'''
    )
    stringParam('APP_REPO', 'git@github.com:REPO', 'The repository url for your application.')
    stringParam('PATH_TO_DSL', 'config/pipeline.groovy', "The path (from the root of the application) to the pipeline config script.")
    stringParam('APP_REPO_BRANCH', 'master', 'Repo Branch')
  }

  multiscm {
    git {
      remote {
        url('${APP_REPO}')
        branch('{$APP_REPO_BRANCH}')
      }
    }
  }

  steps {
    dsl {
      external('${PATH_TO_DSL}')
    }
  }

  wrappers {
    buildName('${APP_NAME} Pipeline Seed')
  }
}
