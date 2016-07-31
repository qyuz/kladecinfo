import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.*;
import java.util.concurrent.*;
 
// requires JDK 1.7.0+
int deferBuild = 2
Path tmpPath = Paths.get( args[0] )
String basePath = tmpPath.toAbsolutePath().toString()
WatchService watchService = FileSystems.getDefault().newWatchService()

def runBat = { bat ->
	def command = "cmd /c " + bat// Create the String
	def proc = command.execute()                 // Call *execute* on the string
	proc.waitFor()                               // Wait for the command to finish

	// Obtain status and output
	println "${new Date()}			return code: ${ proc.exitValue()}"
	println "${new Date()}			stderr: ${proc.err.text}"
	//println "${new Date()}			stdout: ${proc.in.text}" // *out* from the external program is *in* for groovy
}	

ScheduledExecutorService worker = Executors.newSingleThreadScheduledExecutor();


ArrayList fileBatchList = [[	root:"lib", 
						files: ["lib/templates.js"],
						action: { runBat("C:\\java\\svn\\alt\\ptitemplates.bat") },
						name: "templates"
						],
					[	root:"lib",
						files: ["lib/SiteHandlers.js", 
							"lib/parse.js"],
						action: { runBat("C:\\java\\svn\\alt\\ptiparse.bat") },
						name: "parse"
					]
					]

HashMap fileModified = new HashMap<String, String>()					
					
			
					
def upsertCheckLastModified = { file ->
	String fileLastModified = new File(basePath, file).lastModified().toString()
	def lastModified = fileModified.get(file)
	if (fileLastModified != "0") {
		fileModified[file] = fileLastModified
		if(lastModified != fileLastModified) {
			//println "lastModified ${lastModified} fileLastModified ${fileLastModified}"
			return true
		} else {
			return false
		}	
	}
} 				

def processBatch = { batch, modifiedName ->
	if(batch.root == modifiedName) {
		for(int i = 0; i < batch.files.size; i++ ) {
			if(upsertCheckLastModified(batch.files[i])) {
				println("${new Date()} 		BatchName: ${batch.name} initiated")
				batch.action()
				break
			}	
		}

		batch.files.each { file ->
			upsertCheckLastModified(file)
		}
	}
}

def processBatchList = { batchList, modifiedName ->
	fileBatchList.each { batch ->
		processBatch(batch, modifiedName)
	}
}
					
 //Watching the /tmp/nio/ directory
 //for MODIFY and DELETE operations
tmpPath.register(
        watchService,
        StandardWatchEventKinds.ENTRY_MODIFY,
        StandardWatchEventKinds.ENTRY_DELETE);

def modified = { modified ->
	if(modified != null) {
		String modifiedName = modified.toString()
		processBatchList(fileBatchList, modifiedName)
	}
}	

def throttle = { action, defer ->
	def localAction = action;
	long lastRan = 0L;
	return { modifiedContext ->
		if(System.currentTimeMillis() > lastRan + defer * 1000) {
			lastRan = System.currentTimeMillis()
			localAction(modifiedContext)
			println "${new Date()}		Running now"
		} else {
			println "${new Date()} 		Deferred"
		}	
	}
}	


def scheduleTask = { modifiedContext ->
	Runnable task = new Runnable() {
		public void run() {
			modified(modifiedContext)
		}
	};
	worker.schedule(task, deferBuild, TimeUnit.SECONDS);
}	
def deferScheduleTask = throttle(scheduleTask, deferBuild)

def runTask = { modifiedContext -> 
	deferScheduleTask(modifiedContext)
}

processBatchList(fileBatchList)
		
		
for ( ; ; ) {
    WatchKey key = watchService.take()

    //Poll all the events queued for the key
    for ( WatchEvent<?> event: key.pollEvents()){
        WatchEvent.Kind kind = event.kind()
        switch (kind.name()){
            case "ENTRY_MODIFY":
				System.out.println("${new Date()} Modified: "+event.context())
				runTask(event.context())
				break
            case "ENTRY_DELETE":
                System.out.println("Delete: "+event.context())
                break
        }
    }
    //reset is invoked to put the key back to ready state
    boolean valid = key.reset()
    //If the key is invalid, just exit.
    if ( !valid ) {
        break
    }
}