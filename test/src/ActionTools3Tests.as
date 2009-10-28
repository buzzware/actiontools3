package {
	
	import au.com.buzzware.actiontools3.code.MiscUtils;
	import au.com.buzzware.actiontools3.code.XmlUtils;
	
	import mx.controls.Button;
	
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.IsNullMatcher;
	import org.hamcrest.object.equalTo;
	
	public class ActionTools3Tests {  

//	[BeforeClass]
//	public static function runBeforeClass():void {
//	    // run for one time before all test cases
//	}
//
//	[AfterClass]
//	public static function runAfterClass():void {
//	    // run for one time after all test cases
//	}
//
//	[Before(order=1)]
//	public function runBeforeEveryTest():void {
//	    simpleMath = new SimpleMath();
//	}
//
//	[Before(order=2)]
//	public function alsoRunBeforeEveryTest():void {
//	    simpleMath1 = new SimpleMath();
//	}
//
//	[After]
//	public function runAfterEveryTest():void {
//	}

//	[Test(expects="TypeError")]
//	public function divisionWithException():void {
//	    simpleMath.divide( 11, 0 );
//	}
//
//	[Ignore("Not Ready to Run")]
//	[Test]
//	public function multiplication():void {
//	    Assert.assertEquals(15, simpleMath.multiply(3, 5));
//	}



/* 
		// using hamcrest
		[Test]
		public function testGreaterThan():void {  
			assertThat( 11, greaterThan(3) );
		}
		[Test]
		public function isItInHere():void {  
			var someArray:Array = [ 'a', 'b', 'c', 'd', 'e', 'f' ];
			assertThat( someArray, hasItems("b", "c") );
		}
 */
 
 		
 
		[Test]
		public function testGetRoot(): void {
			var sXml: String = '<?xml version="1.0" encoding="utf-8"?><top><sub></sub><sub></sub></top>';	
			var root: XML = XmlUtils.GetRoot(sXml);
			assertThat( root, isA(XML) )
			assertThat( root.name(), equalTo('top') )
			root = XmlUtils.GetRoot(XML(sXml));
			assertThat( root, isA(XML) )
			assertThat( root.name(), equalTo('top') )
			root = XmlUtils.GetRoot(XML(''));
			assertThat( root, IsNullMatcher )
			root = XmlUtils.GetRoot(XML('<?xml version="1.0" encoding="utf-8"?><html><head></head></html>'));
			assertThat( root, IsNullMatcher )
			root = XmlUtils.GetRoot(XML('<?xml version="1.0" encoding="utf-8"?><XHTML><head></head></XHTML>'));
			assertThat( root, IsNullMatcher )
			root = XmlUtils.GetRoot(XML('<xhtml><head></head></xhtml>'));
			assertThat( root, IsNullMatcher )
			root = XmlUtils.GetRoot(XML('<HTML><head></head></HTML>'));
			assertThat( root, IsNullMatcher )
		}

		[Test]
		public function testGetSuperclasses(): void {
			var ancestors: Array = MiscUtils.getSuperclasses(A)
			assertThat( ancestors, equalTo([A, B, Object]) )
			var sAncestors: String = MiscUtils.superclassesAsString(A);
			assertThat( sAncestors, equalTo('A > B > Object') );
			assertThat( MiscUtils.superclassesAsString(Button), equalTo('mx.controls::Button > mx.core::UIComponent > mx.core::FlexSprite > flash.display::Sprite > flash.display::DisplayObjectContainer > flash.display::InteractiveObject > flash.display::DisplayObject > flash.events::EventDispatcher > Object') );
			assertThat( MiscUtils.superclassesAsString(Button,true), equalTo('Button > UIComponent > FlexSprite > Sprite > DisplayObjectContainer > InteractiveObject > DisplayObject > EventDispatcher > Object') );		
		}
		
		[Test]
		public function testXmlUtilsAddFromString(): void {
			var str: String = '<?xml version="1.0" encoding="utf-8"?><top><sub></sub><sub></sub></top>';
			var xml: XML = XmlUtils.GetRoot(str);
			assertThat( xml.children().length() == 2 )
			var xnod: XML = XmlUtils.addFromString(xml,'');	
			assertThat( xnod == null )
			assertThat( xml.children().length() == 2 )
			
			xml = XmlUtils.GetRoot(str);
			assertThat( xml.sub.length() == 2 )
			xnod = XmlUtils.addFromString(xml,'<fruit taste="yummy">apple</fruit>');
			assertThat( xnod.name() == 'fruit' )
			assertThat( xnod.@taste == 'yummy' )
			assertThat( xml.sub.length() == 2 )
			assertThat( xml.fruit.@taste == 'yummy' )
			assertThat( xml.fruit == 'apple' )
			xnod = XmlUtils.addFromString(xml,'<fruit taste="sour">lemon</fruit><fruit taste="sweet">orange</fruit>');
			assertThat( xnod.name() == 'fruit' )
			assertThat( xnod.@taste == 'sour' )
			assertThat( xml.fruit.length() == 3 )
		}

		[Test]
		public function testXmlUtilsNextSibling(): void {
			var str: String = '<?xml version="1.0" encoding="utf-8"?><top><one></one><two></two><three></three></top>';
			var xml: XML = XmlUtils.GetRoot(str);
			var one: XML = xml.one;
			var two: XML = xml.two;
			var three: XML = xml.three;
			assertThat( XmlUtils.nextSibling(one) == two )
			assertThat( XmlUtils.nextSibling(two) == three )
			assertThat( XmlUtils.nextSibling(three) == null )
			
		}
				
	}
}