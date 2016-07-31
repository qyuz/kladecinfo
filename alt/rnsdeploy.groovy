import java.io.IOException;
import java.nio.file.*;
import java.text.SimpleDateFormat;

scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent + "\\"
GroovyShell shell = new GroovyShell()
evaluate(new File(scriptDir + "importReplaceTextUtils.groovy"))


String taskFolder = new SimpleDateFormat("yyyy-MM\\\\MM-dd").format(new Date()) + "_IClaims\\"
String tasks = "C:\\p\\project\\RNS\\tasks\\"

//String taskFolder = "2013 10\\18 09 IClaims\\"

String svnFolder = "C:\\p\\project\\RNS\\svn\\Renins_Oracle\\"

String deployFolder = "deploy\\"
def files = [
        [   sourceRoot: "IClaimsInterface\\trunk\\IClaimsInterface\\IClaimsInterface\\",
                targetRoot: "IClaims"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsAgent",
                targetRoot: "IClaimsImpl\\Agent"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsAssistant",
                targetRoot: "IClaimsImpl\\Assistant"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsCreateAccount",
                targetRoot: "IClaimsImpl\\Client"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsFlot",
                targetRoot: "IClaimsImpl\\Flot"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsGeneric",
                targetRoot: "IClaimsImpl\\Generic"
        ],
        [   sourceRoot: "IClaimsApplication\\trunk\\IClaimsApplication\\IClaimsPartner",
                targetRoot: "IClaimsImpl\\Partner"
        ]
]

def copyFiles = { sourceFolder, targetFolder ->
    plans = replaceTextUtils.matchFiles([svnFolder + sourceFolder], [".*(sca_.*_rev.*jar)|(((STG)|(PRD))_cfgplan.xml)\$"])
    plans.each { plan ->
        new File(targetFolder).mkdirs()
        println tasks + taskFolder + targetFolder
        Path sourcePath = Paths.get(plan)
        Path targetPath = Paths.get(targetFolder, sourcePath.fileName.toString())
        Files.copy(sourcePath, targetPath, StandardCopyOption.REPLACE_EXISTING);
    }
}

files.each { file ->
    copyFiles(file.sourceRoot, tasks + taskFolder + file.targetRoot)
}