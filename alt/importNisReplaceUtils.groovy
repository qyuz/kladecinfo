import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.transform.Field

scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
GroovyShell shell = new GroovyShell()
nisReplaceUtils = shell.parse(new File(scriptDir + "nisReplaceUtils.groovy"))
evaluate(new File(scriptDir + "importReplaceTextUtils.groovy"))
evaluate(new File("D:\\dropbox\\Dropbox\\nis\\persister\\" + "configCore.txt"))
nisReplaceUtils.replaceTextUtils = replaceTextUtils
nisReplaceUtils.corePath = corePath
nisReplaceUtils.targetPath = targetPath
