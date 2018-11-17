package aspects;

import util.Logger;
import actors.Invader;

public aspect InvadersLogger {
	
	private int invaderNumSoFar = 0;
	private final Logger Log = Logger.getInstance();
	
	pointcut invaderConstructor(): call(Invader.new(..));
	
	after(): invaderConstructor() {
		this.invaderNumSoFar++;
		Log.info("Total invader instantiations: " + this.invaderNumSoFar);
	}
}
