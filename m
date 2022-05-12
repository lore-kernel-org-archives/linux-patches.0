Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8EB15AB
	for <patches@lists.linux.dev>; Thu, 12 May 2022 01:39:26 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id e24so3820686pjt.2
        for <patches@lists.linux.dev>; Wed, 11 May 2022 18:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OKsiMTO05pP2YFIGQs4jSS3mDepImUu3DLLTqj1JC+E=;
        b=YsayhIWOka75EoI2fzwHCCftn/Bb9jwmP/Rkx1xwXG9vjaIK2W0w0dUR3AAOr6r2Oe
         XonHI7AKz/OGZFdSX/xhBM/WsB3QQR9homjoWpklpdW2aQ3t2N0JI7Qm44zoJcYE3r0d
         TLEHZusT57YAmYqkJuMTvRpsLVn6DR2UuXZlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OKsiMTO05pP2YFIGQs4jSS3mDepImUu3DLLTqj1JC+E=;
        b=COPtGtZ8qbpyOqFw4H7j0KTnbx7XJ5MAqrvCHXQ1ei6i25ljv9XL3OACMe3S3gyd3y
         XEitFQRS+O+X5DLCM5cvY7CCNuJRmP27oqqNV2AYWEM0WDVLpUVvOZ2WSaedNGkyPhjy
         3G0IzR4QbnxUoeUIiPOVWstGLuY1BaERWSW7/0+ERnrImzyGFlhzb5Eyg5tRj3RQV6Pn
         coHQLs7HofEpy2mXY53m301pMx0/p3jVfRK+OQs4kwGviff4f6oBbatwejnxxKJ6iHOU
         akO+8uzkVVonO/sU1AEjoTaK2zvMsRvA1xJ9FsPdY2KnfMLUCD0w8zsp8sstQ6iv1Pqz
         /JlA==
X-Gm-Message-State: AOAM533dTtu+HtSeLvoOTMSDgr6XSk57FPfDbhulGc/J6P/Fm1MxDWI+
	qpA62YNu7eyJBoIdB0LEQxOYZA==
X-Google-Smtp-Source: ABdhPJz5juvszW0WlRxr8OLPLsBo/MwprcIaMIxuhi+YYdwUVFMtA53XzJ8ap+j44qKXzkn75exLhQ==
X-Received: by 2002:a17:902:e94e:b0:158:91e6:501 with SMTP id b14-20020a170902e94e00b0015891e60501mr28053817pll.29.1652319566414;
        Wed, 11 May 2022 18:39:26 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:193f:f17a:ab0d:1f83])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902d50700b0015e8d4eb2cfsm2614766plg.281.2022.05.11.18.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 18:39:26 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	chrome-platform@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Craig Hesling <hesling@chromium.org>,
	Tom Hughes <tomhughes@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v5 3/3] dt-bindings: cros-ec: Add ChromeOS fingerprint binding
Date: Wed, 11 May 2022 18:39:21 -0700
Message-Id: <20220512013921.164637-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220512013921.164637-1-swboyd@chromium.org>
References: <20220512013921.164637-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a binding to describe the fingerprint processor found on Chromebooks
with a fingerprint sensor. Previously we've been describing this with
the google,cros-ec-spi binding but it lacks gpio and regulator control
used during firmware flashing.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Craig Hesling <hesling@chromium.org>
Cc: Tom Hughes <tomhughes@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/mfd/google,cros-ec.yaml          | 80 ++++++++++++++++---
 1 file changed, 71 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index 409ecef967ce..e5fe60beb9fe 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -19,15 +19,19 @@ description:
 properties:
   compatible:
     oneOf:
-      - description:
-          For implementations of the EC is connected through I2C.
-        const: google,cros-ec-i2c
-      - description:
-          For implementations of the EC is connected through SPI.
-        const: google,cros-ec-spi
-      - description:
-          For implementations of the EC is connected through RPMSG.
-        const: google,cros-ec-rpmsg
+      # For implementations of the EC is connected through I2C.
+      - items:
+          - const: google,cros-ec-i2c
+      # For implementations of the FPMCU connected through SPI.
+      - items:
+          - const: google,cros-ec-fp
+          - const: google,cros-ec-spi
+      # For implementations of the EC is connected through SPI.
+      - items:
+          - const: google,cros-ec-spi
+      # For implementations of the EC is connected through RPMSG.
+      - items:
+          - const: google,cros-ec-rpmsg
 
   controller-data:
     description:
@@ -132,6 +136,15 @@ properties:
 
     additionalProperties: false
 
+  reset-gpios:
+    maxItems: 1
+
+  boot0-gpios:
+    maxItems: 1
+    description: Assert for bootloader mode.
+
+  vdd-supply: true
+
 patternProperties:
   "^i2c-tunnel[0-9]*$":
     type: object
@@ -176,6 +189,37 @@ allOf:
         - reg
         - interrupts
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: google,cros-ec-fp
+    then:
+      properties:
+        '#address-cells': false
+        '#size-cells': false
+        typec: false
+        ec-pwm: false
+        keyboard-controller: false
+        proximity: false
+        codecs: false
+        cbas: false
+
+      patternProperties:
+        "^i2c-tunnel[0-9]*$": false
+        "^regulator@[0-9]+$": false
+        "^extcon[0-9]*$": false
+
+      required:
+        - reset-gpios
+        - boot0-gpios
+        - vdd-supply
+    else:
+      properties:
+        reset-gpios: false
+        boot0-gpios: false
+        vdd-supply: false
+
 additionalProperties: false
 
 examples:
@@ -231,4 +275,22 @@ examples:
             compatible = "google,cros-ec-rpmsg";
         };
     };
+
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi {
+      #address-cells = <0x1>;
+      #size-cells = <0x0>;
+      ec@0 {
+        compatible = "google,cros-ec-fp", "google,cros-ec-spi";
+        reg = <0>;
+        interrupt-parent = <&gpio_controller>;
+        interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
+        spi-max-frequency = <3000000>;
+        reset-gpios = <&gpio_controller 5 GPIO_ACTIVE_LOW>;
+        boot0-gpios = <&gpio_controller 10 GPIO_ACTIVE_HIGH>;
+        vdd-supply = <&pp3300_fp_mcu>;
+      };
+    };
 ...
-- 
https://chromeos.dev

