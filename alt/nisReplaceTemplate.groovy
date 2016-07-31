import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.lang.GroovyShell
scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
evaluate(new File(scriptDir + "importReplaceTextUtils.groovy"))

String[] xqDir = ["D:\\dropbox\\Dropbox\\nis\\siebel_objects_into_db\\SiebelObjectsIntoDB\\Persist\\XQ"]
String[] templateConfigPaths = ["D:\\dropbox\\Dropbox\\nis\\persister\\templates"]

def xqs = replaceTextUtils.matchFiles(xqDir, ["\\.xq\$"])
////println xsls
def templateConfigFiles = replaceTextUtils.matchFiles(templateConfigPaths)
def templateConfigs = replaceTextUtils.getTemplateConfigs(templateConfigFiles)
////println templateConfigs
replaceTextUtils.replaceTemplates(templateConfigs, xqs)

