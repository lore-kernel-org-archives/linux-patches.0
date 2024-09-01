Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0B6145B0D
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163650; cv=none; b=PBzxS2csB3wr1qqE97iBHUeIPfUiDIukQonttUThCImOBKqVTbEG/QNbU7Zhu6us5zY2Z1RwGfnzh6V6V9UCF77Jghk48gfBD2WJ5jrd4DJ82pkQFobjqL6Vza4dcm3O8U57XVrDWWprEcZsmY0ZUm5LsgIp2CYNjz1V0p40OJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163650; c=relaxed/simple;
	bh=aHxbXooyxcUO5JwBCTNyqni3GmuKJP5ay9S/7oeiMaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUKcQsVzmgAr3mjdp5lLEfOQCfquqyOa0RqE05QMS18CQ+FtBkP3M4cXJLgnOYpTnNSnH5PZJoluUgNRyqrHK0TrbMTMVPBPJxmqA28Km66WBbYC9LzcYcDUmafizqVgIkYvjoDuKau09AJfMlFUzGBZpfrgzBQUmyhYEpVAwNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CZmAv6vH; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CZmAv6vH"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39f4f62a303so3554685ab.1
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163648; x=1725768448; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVAbaFTBXgnW+fAYVEBW9D2cgqLAHsvQgjfJBzfAY3s=;
        b=CZmAv6vHlaepzKshLLEuOdr2tBUhjq/M8JnRY8pxnXEZIz+VD49TjY493IouYm1fxJ
         7XsPYktd0M/IQGeiHann51TaYPvDYEU1FVT+BZrhab7SC8sQN5UfMWSMib0BSLaOtaGP
         0+3G4z2tD7X6tvVCg2Tld0lIB3Y7eaURQq09s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163648; x=1725768448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVAbaFTBXgnW+fAYVEBW9D2cgqLAHsvQgjfJBzfAY3s=;
        b=TYOJ4uaoczrCxjzAz/O2eHMSIyrE1qpuNZPx63K0G9EiSL6a3Nh3GfTMtRwcnz76yZ
         T9axx0gYa1Us7GtHgBf3dArylPxIdPvPLmRhra1Lvj98agquLV5muKhkYKXcJHFJmuJW
         7yyoq9gy9+HXUFcfrxCw/EBopqxlh8N6ULyzQ9ua+NCjqwVUlR5dUrUMnxcpn92b7ChD
         S6slpktiuoM3srGladJeEZBWvwZcN4edsCtNCL83trUTmkC+5k5fpK88XBuypcoDUwmB
         AVpcJSdFtSpOmJa38b/a6tg93xgD3sz5Fjxykh9dYXpXao/hgx85UiQvKpY4W1rJeYff
         gLfg==
X-Forwarded-Encrypted: i=1; AJvYcCVxMeJ/dWQ2MvRlVY3/ZsdVRfrO5B20yde3hOW/jKLXzrymCozUgtzKgvJZOFd951TCbsGBC9a3@lists.linux.dev
X-Gm-Message-State: AOJu0Yy48XclMkaGyS8ygF6ERQyrCaRIDR57w/jd0pCFDv3NSBeK0C8k
	sPlB0IFXCDGUoNevbP4sRfK4S/tMaE+lW7PpztrCmI2OSQ0J0hJ1q1ZN1gkRIQ==
X-Google-Smtp-Source: AGHT+IFsOTewMNJ0BJt0tAvMG/AJBfDBb9as9o8BHiOu5PQfrktxWGnHk+Ahlp9K/S8f1Bq4n28w/g==
X-Received: by 2002:a05:6e02:1c42:b0:39f:5646:97da with SMTP id e9e14a558f8ab-39f56469978mr14867835ab.20.1725163647832;
        Sat, 31 Aug 2024 21:07:27 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7d22e9d77f2sm5333884a12.89.2024.08.31.21.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:27 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Benson Leung <bleung@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Guenter Roeck <groeck@chromium.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	linux-acpi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v4 12/18] dt-bindings: usb-switch: Extract endpoints to defs
Date: Sat, 31 Aug 2024 21:06:50 -0700
Message-ID: <20240901040658.157425-13-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
In-Reply-To: <20240901040658.157425-1-swboyd@chromium.org>
References: <20240901040658.157425-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the usb-switch endpoint bindings to defs so that they can be reused
by other bindings. Future users of this binding will have more than one
type-c output node when they're muxing a single DP signal to more than
one usb-c-connector. Add an example to show how this binding can be used
and accelerate binding checks.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../devicetree/bindings/usb/usb-switch.yaml   | 74 +++++++++++++++----
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-switch.yaml b/Documentation/devicetree/bindings/usb/usb-switch.yaml
index da76118e73a5..f5dc7e23b134 100644
--- a/Documentation/devicetree/bindings/usb/usb-switch.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-switch.yaml
@@ -35,9 +35,12 @@ properties:
     $ref: /schemas/graph.yaml#/properties/ports
     properties:
       port@0:
-        $ref: /schemas/graph.yaml#/properties/port
-        description:
-          Super Speed (SS) Output endpoint to the Type-C connector
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        unevaluatedProperties: false
+
+        properties:
+          endpoint:
+            $ref: '#/$defs/usbc-out-endpoint'
 
       port@1:
         $ref: /schemas/graph.yaml#/$defs/port-base
@@ -47,16 +50,7 @@ properties:
 
         properties:
           endpoint:
-            $ref: /schemas/graph.yaml#/$defs/endpoint-base
-            unevaluatedProperties: false
-            properties:
-              data-lanes:
-                $ref: /schemas/types.yaml#/definitions/uint32-array
-                minItems: 1
-                maxItems: 8
-                uniqueItems: true
-                items:
-                  maximum: 8
+            $ref: '#/$defs/usbc-in-endpoint'
 
 oneOf:
   - required:
@@ -65,3 +59,57 @@ oneOf:
       - ports
 
 additionalProperties: true
+
+$defs:
+  usbc-out-endpoint:
+    $ref: /schemas/graph.yaml#/$defs/endpoint-base
+    description: Super Speed (SS) output endpoint to a type-c connector
+    unevaluatedProperties: false
+
+  usbc-in-endpoint:
+    $ref: /schemas/graph.yaml#/$defs/endpoint-base
+    description: Super Speed (SS) input endpoint from the Super Speed PHY
+    unevaluatedProperties: false
+    properties:
+      data-lanes:
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        minItems: 1
+        maxItems: 8
+        uniqueItems: true
+        items:
+          maximum: 8
+
+examples:
+  # A USB orientation switch which flips the pin orientation
+  # for a usb-c-connector node.
+  - |
+    device {
+      orientation-switch;
+
+      ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port@0 {
+          reg = <0>;
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          endpoint {
+            remote-endpoint = <&usb_c_connector>;
+          };
+        };
+
+        port@1 {
+          reg = <1>;
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          endpoint {
+            remote-endpoint = <&usb_ss_phy>;
+          };
+        };
+      };
+    };
+
+...
-- 
https://chromeos.dev

