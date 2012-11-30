--TEST--
xdiff_string_diff()
--SKIPIF--
<?php if (!extension_loaded("xdiff")) print "skip"; ?>
--POST--
--GET--
--INI--
--FILE--
<?php 
$a = file_get_contents('tests/file.1');
$b = file_get_contents('tests/file.2');
echo xdiff_string_diff($a, $b, 1);
?>
--EXPECT--
@@ -3,3 +3,3 @@
 echo $a;
-$b = 320;
+$b = 420;
 echo $b;

