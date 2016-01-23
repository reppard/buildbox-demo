import jenkins.model.*

def jobName = "SeedJob"
def git_url = ""

if (System.getenv("SEED_JOBS_URL")){
  git_url = System.getenv("SEED_JOBS_URL")
}else{
  git_url = "https://github.com/reppard/buildbox-demo.git"
}

def scm = '''<scm class="hudson.scm.NullSCM"/>'''

scm = """\
  <scm class="hudson.plugins.git.GitSCM">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url><![CDATA[${git_url}]]></url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>**</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
"""

def configXml = """\
  <?xml version='1.0' encoding='UTF-8'?>
  <project>
    <actions/>
    <description>Create Jenkins jobs from DSL groovy files</description>
    <keepDependencies>false</keepDependencies>
    <properties>
    </properties>
    ${scm}
    <canRoam>true</canRoam>
    <disabled>false</disabled>
    <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
    <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
    <triggers/>
    <concurrentBuild>false</concurrentBuild>
    <builders>
      <javaposse.jobdsl.plugin.ExecuteDslScripts>
        <targets>seed_jobs/*.groovy</targets>
        <usingScriptText>false</usingScriptText>
        <ignoreExisting>false</ignoreExisting>
        <removedJobAction>IGNORE</removedJobAction>
        <removedViewAction>IGNORE</removedViewAction>
        <lookupStrategy>JENKINS_ROOT</lookupStrategy>
        <additionalClasspath></additionalClasspath>
      </javaposse.jobdsl.plugin.ExecuteDslScripts>
    </builders>
    <publishers/>
    <buildWrappers/>
  </project>
""".stripIndent()


if (!Jenkins.instance.getItem(jobName)) {
  def xmlStream = new ByteArrayInputStream( configXml.getBytes() )
  try {
    def seedJob = Jenkins.instance.createProjectFromXML(jobName, xmlStream)
    seedJob.scheduleBuild(0, null)
  } catch (ex) {
    println "ERROR: ${ex}"
    println configXml.stripIndent()
  }
}
