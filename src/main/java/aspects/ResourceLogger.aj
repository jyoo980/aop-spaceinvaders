package aspects;

import util.Logger;
import game.ResourceLoader;
import java.applet.AudioClip;
import java.awt.image.BufferedImage;


public aspect ResourceLogger {
	
	private final Logger Log = Logger.getInstance();
	
	pointcut getSound(String name): execution(AudioClip ResourceLoader.getSound(..)) && args(name);
	pointcut getSprite(String name): call(BufferedImage ResourceLoader.getSprite(..)) && args(name);
	
	after(String name): getSound(name) {
		Log.trace("Loading sound file: " + name);
	}

	after(String name): getSprite(name) {
		// TODO: This generates an ungodly amount of output, need to figure out why, 
		// probably something to do with the buffer
		// Log.trace("Loading sound file: " + name);
	}

}
