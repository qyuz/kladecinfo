import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.transform.Field

scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
GroovyShell shell = new GroovyShell()
replaceTextUtils = shell.parse(new File(scriptDir + "replaceTextUtils.groovy"))
