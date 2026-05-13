#!/bin/sh

dir=/tmp/patches
file=$dir/idk.patch

mkdir -p "$dir"

cat > "$file" <<'EOF'
--- a/packages/SystemUI/src/com/android/systemui/clocks/ClockStyle.java
+++ b/packages/SystemUI/src/com/android/systemui/clocks/ClockStyle.java
@@ -29,6 +29,7 @@
 import android.view.Gravity;
 import android.view.View;
 import android.view.ViewGroup;
+import android.view.ViewParent;
 import android.view.ViewStub;
 import android.widget.ImageView;
 import android.widget.LinearLayout;
@@ -325,6 +326,22 @@ private float getScaleFactor() {
         return clamped / 100f;
     }
 
+    private void disableClippingOnParents(View view) {
+        setClipChildren(false);
+        setClipToPadding(false);
+
+        View current = view;
+        while (current != null && current != ClockStyle.this) {
+            if (current instanceof ViewGroup) {
+                ((ViewGroup) current).setClipChildren(false);
+                ((ViewGroup) current).setClipToPadding(false);
+            }
+            ViewParent parent = current.getParent();
+            if (!(parent instanceof View)) break;
+            current = (View) parent;
+        }
+    }
+
     private void applyClockScale() {
         if (currentClockView == null) return;
         float scale = getScaleFactor();
@@ -332,6 +349,7 @@ private void applyClockScale() {
         currentClockView.setScaleY(scale);
         currentClockView.setPivotX(currentClockView.getWidth() / 2f);
         currentClockView.setPivotY(0f);
+        disableClippingOnParents(currentClockView);
     }
 
     private void applyClockAlpha() {
@@ -396,6 +414,7 @@ private void updateClockView() {
             if (stub != null) {
                 stub.setLayoutResource(CLOCK_LAYOUTS[mClockStyle]);
                 currentClockView = stub.inflate();
+                disableClippingOnParents(currentClockView);
                 
                 ImageView userProfileIcon = currentClockView.findViewById(R.id.user_profile_icon);
                 if (userProfileIcon != null) {
EOF

git -C frameworks/base apply "$file"
