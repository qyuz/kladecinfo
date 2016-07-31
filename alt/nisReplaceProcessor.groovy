import java.util.regex.Matcher
import java.lang.reflect.Array
import groovy.lang.GroovyShell
scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
evaluate(new File(scriptDir + "importNisReplaceUtils.groovy"))
evaluate(new File("D:\\dropbox\\Dropbox\\nis\\persister\\" + "nisReplaceProcessor.txt"))

String matchFiles = "(Processor\\.proxy)"
String matchContent = "([>\\\"/]|LESiebel|LE Siebel |ListOfLeSiebel|Persist)"
String matchOthers = "([>\$])"



//nisCopyAndRename(initialName + matchFiles, replaceName + '$1')
//nisReplaceText(replaceName + matchFiles, matchContent + initialName, '$1' + replaceName)
//replaceNames = ["AccountContact", "Address", "Asset", "Contact", "Premise", "ServicePoint"]
nisReplaceUtils.nisCopyAndRenameAndReplace(initialName, matchFiles, replaceNames, matchContent)
nisReplaceUtils.nisReplaceText(replaceNames[0] + matchFiles, matchOthers + initialName.toLowerCase(), '$1' + replaceNames[0].toLowerCase())

//nisReplaceUtils.cng()

//println replaceTextUtils.safeReplaceAll('aa', 'a', 'b')
//println nisReplaceUtils.nisCopyAndRenameAndReplace()

