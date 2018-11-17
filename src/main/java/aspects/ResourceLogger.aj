package aspects;

import util.Logger;
import game.ResourceLoader;
import java.applet.AudioClip;
import java.awt.image.BufferedImage;


public aspect ResourceLogger {
	
	private final Logger Log = Logger.getInstance();
	
	pointcut getSound(String name): execution(AudioClip ResourceLoader.getSound(..)) && args(name);
	pointcut getSprite(String name): execution(BufferedImage ResourceLoader.getSprite(..)) && args(name);
	
	after(String name): getSound(name) {
		Log.trace("Loading sound file: " + name);
	}

	// TODO: Find out why this is repeating logging so much
//	after(String name): getSprite(name) {
//		Log.trace("Loading image file: " + name);
//	}

}
