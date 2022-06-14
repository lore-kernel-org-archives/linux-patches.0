Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAC1FCF
	for <patches@lists.linux.dev>; Tue, 14 Jun 2022 19:51:48 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id g8so3408223plt.8
        for <patches@lists.linux.dev>; Tue, 14 Jun 2022 12:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Ecx08SwSkVkIJVWaln62nBgxH1hkKlL33dPGnZJP9s=;
        b=fGN/HzmfpmvlZzkPBNUh8eD8hJkMU2DLPWEkt4XPSmX0TNH7VBT0p+jv9eHqBmUaQe
         qJ8DzAz2S77m1OfnPLyDKfRQwcwFEJaMm6brFwjLIFrleLYj/+ZDHakP2j8Lqv3djP48
         ++RkD1QDKG7H2sAtJAFTDBEKzekz6aKqlxLWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Ecx08SwSkVkIJVWaln62nBgxH1hkKlL33dPGnZJP9s=;
        b=bQy9TaXO0WKPt0JWt2hBRa3FShi51zbT6LGdrVFjrdfuPh+W00VnDprm/0LdHZUJIX
         c1U+sODNRLBw1dfxn1nbT4i+5ATaETYagLw10oR1XYsNTW5qCdU8KsYktrq/qKfBKqaC
         qHzcV/dTKMDcY4zhDlJFwHyzC4IAsc+TsqVIykMSo9iDL4q6yMfaDOo82AZPUB/qrQHU
         HbrRtkCgV37iZkI224UFMjF+w1J35W4uUwq4chbRGbVpAspvBr/zKHQGO//0HcP9iqj/
         Z0qtnteatWjQ1FDmhLj9iXREc+olVfaGnZeHGPqJ4Kz+snt5F8k1y4vDgYH68KhkNLIO
         GTow==
X-Gm-Message-State: AJIora9jUqViV7sUDgD6LBEpgh7hyuzNj+wFh2ogIUkHNv6zSwEuGaZb
	KVLhzF4Vfv4lcw2KI54VS125Rw==
X-Google-Smtp-Source: AGRyM1s7JWSIE6WZKxGTi/o5Ek/zUhL6bbR2KfTSGXVfOwo0GmL8v90QzFlnUqLDn1YrPQMfqWk6JQ==
X-Received: by 2002:a17:902:d484:b0:167:770b:666 with SMTP id c4-20020a170902d48400b00167770b0666mr5652568plg.148.1655236307622;
        Tue, 14 Jun 2022 12:51:47 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:82ae:1136:b202:95da])
        by smtp.gmail.com with ESMTPSA id s21-20020a170902b19500b0015e8d4eb29csm7625484plr.230.2022.06.14.12.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 12:51:47 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Craig Hesling <hesling@chromium.org>,
	Tom Hughes <tomhughes@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 1/2] dt-bindings: cros-ec: Reorganize property availability
Date: Tue, 14 Jun 2022 12:51:43 -0700
Message-Id: <20220614195144.2794796-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220614195144.2794796-1-swboyd@chromium.org>
References: <20220614195144.2794796-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various properties in the cros-ec binding only apply to different
compatible strings. For example, the interrupts and reg property are
required for all cros-ec devices except for the rpmsg version. Add some
conditions to update the availability of properties so that they can't
be used with compatibles that don't support them.

Cc: Rob Herring <robh@kernel.org>
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
 .../bindings/chrome/google,cros-ec-typec.yaml |  1 +
 .../bindings/extcon/extcon-usbc-cros-ec.yaml  |  1 +
 .../i2c/google,cros-ec-i2c-tunnel.yaml        |  1 +
 .../bindings/mfd/google,cros-ec.yaml          | 29 +++++++++++++------
 .../bindings/pwm/google,cros-ec-pwm.yaml      |  1 +
 .../regulator/google,cros-ec-regulator.yaml   |  1 +
 .../bindings/sound/google,cros-ec-codec.yaml  |  1 +
 7 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
index 2d98f7c4d3bc..adde8c44372b 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
@@ -37,6 +37,7 @@ examples:
       cros_ec: ec@0 {
         compatible = "google,cros-ec-spi";
         reg = <0>;
+        interrupts = <35 0>;
 
         typec {
           compatible = "google,cros-ec-typec";
diff --git a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
index 2d82b44268db..2e5b39881449 100644
--- a/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
+++ b/Documentation/devicetree/bindings/extcon/extcon-usbc-cros-ec.yaml
@@ -40,6 +40,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <44 0>;
 
             usbc_extcon0: extcon0 {
                 compatible = "google,extcon-usbc-cros-ec";
diff --git a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
index 6e1c70e9275e..cf523615f5e3 100644
--- a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
+++ b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
@@ -47,6 +47,7 @@ examples:
             compatible = "google,cros-ec-spi";
             reg = <0>;
             spi-max-frequency = <5000000>;
+            interrupts = <99 0>;
 
             i2c-tunnel {
                 compatible = "google,cros-ec-i2c-tunnel";
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index e25caf8ef9f4..178e26ab115c 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -20,19 +20,16 @@ properties:
   compatible:
     oneOf:
       - description:
-          For implementations of the EC is connected through I2C.
+          For implementations of the EC connected through I2C.
         const: google,cros-ec-i2c
       - description:
-          For implementations of the EC is connected through SPI.
+          For implementations of the EC connected through SPI.
         const: google,cros-ec-spi
       - description:
-          For implementations of the EC is connected through RPMSG.
+          For implementations of the EC connected through RPMSG.
         const: google,cros-ec-rpmsg
 
-  controller-data:
-    description:
-      SPI controller data, see bindings/spi/samsung,spi-peripheral-props.yaml
-    type: object
+  controller-data: true
 
   google,cros-ec-spi-pre-delay:
     description:
@@ -62,8 +59,7 @@ properties:
       the SCP.
     $ref: "/schemas/types.yaml#/definitions/string"
 
-  spi-max-frequency:
-    description: Maximum SPI frequency of the device in Hz.
+  spi-max-frequency: true
 
   reg:
     maxItems: 1
@@ -158,12 +154,27 @@ allOf:
               - google,cros-ec-rpmsg
     then:
       properties:
+        controller-data: false
         google,cros-ec-spi-pre-delay: false
         google,cros-ec-spi-msg-delay: false
         spi-max-frequency: false
     else:
       $ref: /schemas/spi/spi-peripheral-props.yaml
 
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              const: google,cros-ec-rpmsg
+    then:
+      properties:
+        mediatek,rpmsg-name: false
+
+      required:
+        - reg
+        - interrupts
+
 additionalProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml b/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
index c8577bdf6c94..3afe1480df52 100644
--- a/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/google,cros-ec-pwm.yaml
@@ -48,6 +48,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <101 0>;
 
             cros_ec_pwm: pwm {
                 compatible = "google,cros-ec-pwm";
diff --git a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
index 69e5402da761..0921f012c901 100644
--- a/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/google,cros-ec-regulator.yaml
@@ -41,6 +41,7 @@ examples:
             reg = <0>;
             #address-cells = <1>;
             #size-cells = <0>;
+            interrupts = <99 0>;
 
             regulator@0 {
                 compatible = "google,cros-ec-regulator";
diff --git a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
index c3e9f3485449..67134e06765a 100644
--- a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
+++ b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
@@ -57,6 +57,7 @@ examples:
         cros-ec@0 {
             compatible = "google,cros-ec-spi";
             reg = <0>;
+            interrupts = <93 0>;
 
             codecs {
                 #address-cells = <2>;
-- 
https://chromeos.dev

