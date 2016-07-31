import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.lang.GroovyShell
scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
evaluate(new File(scriptDir + "importReplaceTextUtils.groovy"))

def renPrepareTemplate = { templateConfig, replaceFilePath ->
    String replaceText = new File(replaceFilePath).getText("UTF-8")
    def nsMapping = templateConfig.config
    def nsKey
    def replacedNs = nsMapping.inject(templateConfig.text) { init, k, v ->
        def i
        nsKey = k
        def nsObject = [prefix: "", ns: ""]
        for (i = 0; i < v.size; i++) {
            Matcher matcher = replaceText =~ v[i]
//                println matcher
            if (matcher.find()) {
                nsObject.prefix = matcher[0][1]
                nsObject.ns = matcher[0][0]
                break;
            }
        }
        assert nsObject.prefix != "", String.format("ns definition for [template prefix: %s] [regex: %s] is missing in [file: %s]", nsKey, v[i - 1], replaceFilePath)
        println String.format("\t[prefix: %s] from [namespace: %s] \r\n\t\twith [regex: %s]", nsObject.prefix, nsObject.ns, v[i - 1])
        def replaceNs = init.replaceAll(k, nsObject.prefix)
//            println replaceNs
        return replaceNs
    }
} //as Object


String[] xslDirs = ["C:\\p\\project\\RNS\\svn\\Renins_Oracle\\IClaimsApplication\\trunk\\IClaimsApplication", "C:\\p\\project\\RNS\\svn\\Renins_Oracle\\IClaimsInterface\\trunk\\IClaimsInterface"]
String[] templateConfigPaths = ["C:\\p\\project\\RNS\\alt\\Templates"]

def xsls = replaceTextUtils.matchFiles(xslDirs, ["\\.xsl\$"])
////println xsls
def templateConfigFiles = replaceTextUtils.matchFiles(templateConfigPaths)
def templateConfigs = replaceTextUtils.getTemplateConfigs(templateConfigFiles)
////println templateConfigs
replaceTextUtils.replaceTemplates(templateConfigs, xsls, renPrepareTemplate)

