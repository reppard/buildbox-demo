import jenkins.model.*

def rootUrl = System.getenv("ROOT_URL")
jlc         = JenkinsLocationConfiguration.get()

jlc.setUrl(rootUrl)
jlc.save()
