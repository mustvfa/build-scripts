#!/bin/sh

PATCH_FILE=idk.patch

cat > "$PATCH_FILE" <<'EOF'
From c084f876d0fe35ee8fde64282d7639fc87d4249f Mon Sep 17 00:00:00 2001
From: tejas101k <tejassingh649@rediffmail.com>
Date: Wed, 6 May 2026 05:42:59 +0530
Subject: [PATCH] SystemUI: Fix custom clock scale clipping

---
 .../android/systemui/clocks/ClockStyle.java   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/packages/SystemUI/src/com/android/systemui/clocks/ClockStyle.java b/packages/SystemUI/src/com/android/systemui/clocks/ClockStyle.java
index 58d1c78583b7..79f4df59019e 100644
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

# Apply the patch as a commit
git -C frameworks/base am "$PATCH_FILE"
