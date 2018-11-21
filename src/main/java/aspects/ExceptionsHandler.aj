package aspects;

import util.Logger;
import game.ResourceLoader;
import game.Invaders;
import java.applet.AudioClip;
import java.awt.image.BufferedImage;

import java.io.IOException;

privileged aspect ExceptionsHandler {
	
	private final Logger Log = Logger.getInstance();
	
	
	pointcut soundLoadingException(String name, ResourceLoader rl): 
		call(AudioClip ResourceLoader.getSound(..)) && args(name) && target(rl);
	pointcut spriteLoadingException(String name, ResourceLoader rl):
		execution(BufferedImage ResourceLoader.getSprite(..)) && args(name) && target(rl);
	pointcut game(): within(Invaders) && handler(InterruptedException);
	pointcut threadCall(): call(void Thread.sleep(..)) && within(Invaders);
	
	declare soft : IOException : execution(BufferedImage ResourceLoader.getSprite(..));
	declare soft : Exception : threadCall();
	
	after(String name, ResourceLoader rl) throwing(Exception e): soundLoadingException(name, rl) {
		Log.error("Cound not locate sound " + name + ": " + e.getMessage());
	}
	
	BufferedImage around(String name, ResourceLoader rl): spriteLoadingException(name, rl) {
		try {
			proceed(name, rl);
		} catch(Exception e) {
			Log.error("Cound not locate image " + name + ": " + e.getMessage());
		}
		return rl.images.get(name);
	}
	
	before(): game() {
		Log.error("Could not put thread to sleep");
	}
	
	after() throwing(InterruptedException exn): threadCall() {
		Log.error(exn.getMessage());
		exn.printStackTrace();		
	}
}
