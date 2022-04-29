Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C84B1FB1
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 23:31:15 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so8532574pjf.3
        for <patches@lists.linux.dev>; Fri, 29 Apr 2022 16:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUEQR9O8H+8oiHtgEVn7Ig/wUneKMih0Bx8ImUVBxBc=;
        b=Vh4E1cv9OunyuoisT11pRvmxs46iSzdYkmWT3ac1s2WpS8JBE4ecvsT0MQOF/bdkii
         aBVyAtrTmi96qZznM6ha3lwdHqEL3h7EI05n5qVBpEPV+8WBBrlkJ4//KnF9Gmov7kiz
         jaC/4iRkkYra/ed3fUcSxd+ISJ7+TjEC2aDgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUEQR9O8H+8oiHtgEVn7Ig/wUneKMih0Bx8ImUVBxBc=;
        b=F5I6rdhV9jhYFm3ocrbkbu8VxcBhFU+lT4ULTdx43ahM2ELRdhFIR12yymSx17+pBi
         vqu5Edw+QKByT8OyM8Xht2F7BeYIkWjUalmV/3SfjZPSHit+xv7WnPxeuhP/SJ/Sd80U
         A5GX6GYoKofJO2+v9PMatpN8egAf+v8bvmSOadcMHQGmGRgxbL6aGKAKZhqg4hONJi8y
         scyRNI2WG7ovM1cupc/1QCOcBVCOwFfumTTFNoR/Qn8hD5e78kPQ9ulJmzhM+xpsVvEQ
         DOpact2sT7GcF3+eaESlchbr6GtESF+OOXugvqDT7y892rq1Qzf92NG9TOrwA3dj0vKG
         Y8Rw==
X-Gm-Message-State: AOAM532/3QcjBa0kcH7mtaXQF7JFKrCSAW93QnWKIJon08E/NC6sF9dT
	xKL+ffZDJoreZXLDphrmUROl+w==
X-Google-Smtp-Source: ABdhPJwSMP4RP2g8T5tULOQ96nBkdJwyXyDbE1C2P4bZNXY/k6AfOVEQyaKWh/BeX2OKIr+67wz67w==
X-Received: by 2002:a17:903:2091:b0:15c:b49b:664d with SMTP id d17-20020a170903209100b0015cb49b664dmr1608696plc.151.1651275075510;
        Fri, 29 Apr 2022 16:31:15 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5172:14b3:3687:1fb0])
        by smtp.gmail.com with ESMTPSA id i24-20020aa78b58000000b0050dc762818esm223037pfd.104.2022.04.29.16.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:31:15 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches only compatible
Date: Fri, 29 Apr 2022 16:31:11 -0700
Message-Id: <20220429233112.2851665-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220429233112.2851665-1-swboyd@chromium.org>
References: <20220429233112.2851665-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the device is a detachable, this device won't have a matrix keyboard
but it may have some button switches, e.g. volume buttons and power
buttons. Let's add a more specific compatible for this type of device
that indicates to the OS that there are only switches and no matrix
keyboard present. If only the switches compatible is present, then the
matrix keyboard properties are denied. This lets us gracefully migrate
devices that only have switches over to the new compatible string.

Similarly, start enforcing that the keypad rows/cols and keymap
properties exist if the google,cros-ec-keyb compatible is present. This
more clearly describes what the driver is expecting, i.e. that the
kernel driver will fail to probe if the row or column or keymap
properties are missing and only the google,cros-ec-keyb compatible is
present.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/input/google,cros-ec-keyb.yaml   | 95 +++++++++++++++++--
 1 file changed, 89 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
index e8f137abb03c..c1b079449cf3 100644
--- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
+++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
@@ -15,14 +15,19 @@ description: |
   Google's ChromeOS EC Keyboard is a simple matrix keyboard
   implemented on a separate EC (Embedded Controller) device. It provides
   a message for reading key scans from the EC. These are then converted
-  into keycodes for processing by the kernel.
-
-allOf:
-  - $ref: "/schemas/input/matrix-keymap.yaml#"
+  into keycodes for processing by the kernel. This device also supports
+  switches/buttons like power and volume buttons.
 
 properties:
   compatible:
-    const: google,cros-ec-keyb
+    oneOf:
+      - items:
+          - const: google,cros-ec-keyb-switches
+      - items:
+          - const: google,cros-ec-keyb-switches
+          - const: google,cros-ec-keyb
+      - items:
+          - const: google,cros-ec-keyb
 
   google,needs-ghost-filter:
     description:
@@ -41,15 +46,40 @@ properties:
       where the lower 16 bits are reserved. This property is specified only
       when the keyboard has a custom design for the top row keys.
 
+dependencies:
+  function-row-phsymap: [ 'linux,keymap' ]
+  google,needs-ghost-filter: [ 'linux,keymap' ]
+
 required:
   - compatible
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: google,cros-ec-keyb
+    then:
+      allOf:
+        - $ref: "/schemas/input/matrix-keymap.yaml#"
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: google,cros-ec-keyb-switches
+    then:
+      required:
+        - keypad,num-rows
+        - keypad,num-columns
+        - linux,keymap
+
 unevaluatedProperties: false
 
 examples:
   - |
     #include <dt-bindings/input/input.h>
-    cros-ec-keyb {
+    keyboard-controller {
         compatible = "google,cros-ec-keyb";
         keypad,num-rows = <8>;
         keypad,num-columns = <13>;
@@ -113,3 +143,56 @@ examples:
             /* UP      LEFT    */
             0x070b0067 0x070c0069>;
     };
+
+  - |
+    keyboard-controller {
+        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
+        /* Matrix keymap properties are allowed but ignored */
+        keypad,num-rows = <8>;
+        keypad,num-columns = <13>;
+        linux,keymap = <
+            /* CAPSLCK F1         B          F10     */
+            0x0001003a 0x0002003b 0x00030030 0x00040044
+            /* N       =          R_ALT      ESC     */
+            0x00060031 0x0008000d 0x000a0064 0x01010001
+            /* F4      G          F7         H       */
+            0x0102003e 0x01030022 0x01040041 0x01060023
+            /* '       F9         BKSPACE    L_CTRL  */
+            0x01080028 0x01090043 0x010b000e 0x0200001d
+            /* TAB     F3         T          F6      */
+            0x0201000f 0x0202003d 0x02030014 0x02040040
+            /* ]       Y          102ND      [       */
+            0x0205001b 0x02060015 0x02070056 0x0208001a
+            /* F8      GRAVE      F2         5       */
+            0x02090042 0x03010029 0x0302003c 0x03030006
+            /* F5      6          -          \       */
+            0x0304003f 0x03060007 0x0308000c 0x030b002b
+            /* R_CTRL  A          D          F       */
+            0x04000061 0x0401001e 0x04020020 0x04030021
+            /* S       K          J          ;       */
+            0x0404001f 0x04050025 0x04060024 0x04080027
+            /* L       ENTER      Z          C       */
+            0x04090026 0x040b001c 0x0501002c 0x0502002e
+            /* V       X          ,          M       */
+            0x0503002f 0x0504002d 0x05050033 0x05060032
+            /* L_SHIFT /          .          SPACE   */
+            0x0507002a 0x05080035 0x05090034 0x050B0039
+            /* 1       3          4          2       */
+            0x06010002 0x06020004 0x06030005 0x06040003
+            /* 8       7          0          9       */
+            0x06050009 0x06060008 0x0608000b 0x0609000a
+            /* L_ALT   DOWN       RIGHT      Q       */
+            0x060a0038 0x060b006c 0x060c006a 0x07010010
+            /* E       R          W          I       */
+            0x07020012 0x07030013 0x07040011 0x07050017
+            /* U       R_SHIFT    P          O       */
+            0x07060016 0x07070036 0x07080019 0x07090018
+            /* UP      LEFT    */
+            0x070b0067 0x070c0069>;
+    };
+  - |
+    /* No matrix keyboard, just buttons/switches */
+    switches {
+        compatible = "google,cros-ec-keyb-switches";
+    };
+...
-- 
https://chromeos.dev

