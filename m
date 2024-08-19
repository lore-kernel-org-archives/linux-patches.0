Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE9200101
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 22:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107143; cv=none; b=csERSZ9UXHgz1yPBdVOJQ9WARx8LQUq13viWeW7C8sYA1g7GXbOJ/bA+6Jud54v6EmoSzM+VYH7R54pWhtgelQk9yuRUQF+H/cOW0CisARhh7pMIgbmhv3DiwqI5Efm/pgshMVx4o78L1LnsJCQRQ5CY3U4wvFfXJ4PAhnQXrfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107143; c=relaxed/simple;
	bh=8tqmUj+sdPUk4dj2c30W8lWQ9x5+wvhFnf8zSNBC8MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvnMG/PvAVOdfgJ18/sRcurloYVEzQqScIzY8qqiQwd9B2chm7W74slze76WPyKbhwaN/0zmMiCw9DY8DSGB6GHz55hizoY+MoU0wZX6LBt0aR4c4j05V9pqXaq1scaDqDKIvwKg+03iqPo1eenqkGCEvLaJsMk7D6BPZrKwZ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CEI3RWe6; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CEI3RWe6"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fec34f94abso42165005ad.2
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724107141; x=1724711941; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEGuE2jPeE6QbHnwj3cv7uloVpjVvE++iKPlChg2NtM=;
        b=CEI3RWe6D2p3WqtccZ4dGHTe1oWnQM+3CNNHA1wtMmJLzZ5S8s6totq01mt3xHzuH7
         cFPaL0u4kEx8AE8gKe2PjCobtWGATImwXMRuOUbnIu1Hlw5Vq+SEoD6fFzh0tMVMN3az
         GbkNrUYVtTYLRABM+ez26OV/atZJWl+pVnxnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107141; x=1724711941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEGuE2jPeE6QbHnwj3cv7uloVpjVvE++iKPlChg2NtM=;
        b=qvO2WyiATo66hG8o2rZp9C7FaQ5NpLt7RV3pmUz1/Mwj3dPDkq564gLp0khEcZP0ui
         AQz3IudlzSZmgyrL5OigUPDEvnG1Ix7TzPZxzsaMgVHrekBm5njWkBvs3HPwYz522FlW
         7CyzaTbZd/vljZZvZ0Fwoe+e84vJlkaSVaGUE2wp/bAW9E1xK3J9Q/3ALF0hwJN1imUD
         9zxywhnwselpBQJyR6Io5yYHCiMTAyBDOIIbCxqLFNSw5CLuSnldPflz3rEPg2vmLHoP
         G0GiCQy3WBZ2KG83o5OD4tADRT2PMtB/CSNSTSDxQfNiCPTxK5Oa1+1W+QmLXo3XH5jz
         p0Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXG0fI8gPM/0XnZXYuiw95NOPQB9kOW1/vmaV/2dpeQt5D2KFCaIFfeZ9QMTPnVVOouSFFuYCNL@lists.linux.dev
X-Gm-Message-State: AOJu0YxLu+prD5iYdvH/YW6EBh988P8T2R7sLLTaw0Fan7/q7Fyls7qM
	5vvDNW+cOXhJbUiVDwchbZBONqZMLQFyitX9mACrMiMi6S/EYk1NY2ZU36ymPQ==
X-Google-Smtp-Source: AGHT+IE9StWMBY/V2J5PvOnUgBdk52braBes3M3nIXsSIZjwGAz5lGGOgioaoZfLakp02OBmpgHzZg==
X-Received: by 2002:a17:902:e74b:b0:202:348d:4e85 with SMTP id d9443c01a7336-202348d51eemr70659895ad.39.1724107141155;
        Mon, 19 Aug 2024 15:39:01 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f03a3607sm67131795ad.250.2024.08.19.15.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 15:39:00 -0700 (PDT)
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
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH v3 11/17] dt-bindings: usb-switch: Extract endpoints to defs
Date: Mon, 19 Aug 2024 15:38:25 -0700
Message-ID: <20240819223834.2049862-12-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819223834.2049862-1-swboyd@chromium.org>
References: <20240819223834.2049862-1-swboyd@chromium.org>
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

Cc: Rob Herring <robh+dt@kernel.org>
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
 .../devicetree/bindings/usb/usb-switch.yaml   | 74 ++++++++++++++++---
 1 file changed, 62 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-switch.yaml b/Documentation/devicetree/bindings/usb/usb-switch.yaml
index da76118e73a5..5fc031b56fad 100644
--- a/Documentation/devicetree/bindings/usb/usb-switch.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-switch.yaml
@@ -35,9 +35,13 @@ properties:
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
+            unevaluatedProperties: false
 
       port@1:
         $ref: /schemas/graph.yaml#/$defs/port-base
@@ -47,16 +51,8 @@ properties:
 
         properties:
           endpoint:
-            $ref: /schemas/graph.yaml#/$defs/endpoint-base
+            $ref: '#/$defs/usbc-in-endpoint'
             unevaluatedProperties: false
-            properties:
-              data-lanes:
-                $ref: /schemas/types.yaml#/definitions/uint32-array
-                minItems: 1
-                maxItems: 8
-                uniqueItems: true
-                items:
-                  maximum: 8
 
 oneOf:
   - required:
@@ -65,3 +61,57 @@ oneOf:
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

