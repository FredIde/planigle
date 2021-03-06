package org.planigle.planigle.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.events.Event;
	
	public class StoryChangedEvent extends CairngormEvent
	{
		public static const STORY_CHANGED:String = "StoryChanged";
		
		public function StoryChangedEvent()
		{
			// Call Caignorm constructor.
			super(STORY_CHANGED);
		}
		
		// Must override the Cairgnorm clone funtion.
		override public function clone():Event
		{
			return new StoryChangedEvent();
		}

	}
}