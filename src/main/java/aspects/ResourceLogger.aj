package aspects;

import util.Logger;
import game.ResourceLoader;
import java.applet.AudioClip;
import java.awt.image.BufferedImage;


privileged aspect ResourceLogger {
	
	private final Logger Log = Logger.getInstance();
	
	pointcut getSoundBuffered(String name, ResourceLoader rl): 
		execution(AudioClip ResourceLoader.getSound(..)) && args(name) && target(rl);
	pointcut getSpriteBuffered(String name, ResourceLoader rl):
		execution(BufferedImage ResourceLoader.getSprite(..)) && args(name) && target(rl);
	
	before(String name, ResourceLoader rl): getSoundBuffered(name, rl) {
		if (rl.sounds.get(name) == null) {
			Log.trace("Loading sound file: " + name);
		}
	}

	before(String name, ResourceLoader rl): getSpriteBuffered(name, rl) {
		if (rl.images.get(name) == null) {
			Log.trace("Loaded image file: " + name );	
		}
	}

}
