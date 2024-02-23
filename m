Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94578AD22
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 00:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708649910; cv=none; b=Bfmvyi/0ALFuJR2GGNrtx6K1Cmv+06VLBXiBlJGfWheSPew+zbHV6vvgUq9HTPzKiydk6R5C3UFPMTyBX93bhk4xrmsoMUGVXGKQnpwg2idAUTitep91JGe4WmbKKEinfAdyv5kyZDZDyS+i6FThrqETT36ZPRHsHjCxQnAHApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708649910; c=relaxed/simple;
	bh=O1sCSpMrQuVP4Z+oTQDMovl4p0LxmLa8st/+UmNeCw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBDKnSFL9e1MYdg52KNbf+QCgfk1Re9Ctt0GWi/1HXpQTrLMfRKF2em3SHRaGeIs4hoYyiLU0UOanveW1WD1SscrDChJ/ptWWIPxStXExkUsma4LQj6VWgl5G7GWHkC4DU9S3KLfLFoUbzDNB28Vi42rb6t2g0GJHt3PZk8wfCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=EbPIOUNn; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EbPIOUNn"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dc23bf7e5aaso353018276.0
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 16:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708649907; x=1709254707; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zUukn0iRYfq5PWEhEP7nadIeFb7HXOkHlZH9C2/kzss=;
        b=EbPIOUNnRDa32dBGhy1dXRy4Tx8Iaw3DKYzwRb/FtEVuH9ldmau0JoU5ofhCFKhZ/J
         yOLsmbZ7RXt8FPyPrngmzhOMIfFV00s0HbJKzNBXUXPAT+BzyvqBxqbtWbqd+WVklHK4
         /bLm0AvP1T1C9WkQDYXI6uZQsXpYRZInUwNzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708649907; x=1709254707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zUukn0iRYfq5PWEhEP7nadIeFb7HXOkHlZH9C2/kzss=;
        b=rjFuT9Hz2OZyU/vEkCQEAB+msPV0eeyxaYpbP/ZMFdkyEZNsQ4j7Q0llCeb/Nq9pZN
         7+zhmf1Kwx0GnFy6R8E5p25K0bdrc91YBAokXORzcCCYU5zSLtMJd+GNb/tHL28319do
         WcpQfzSWyaxdMKHBUtHDlT7rX47s15xSb6PxsUSqdKgWDGU4S81MoEpb4AEc1esG0SUn
         hyBZ+JDAMYzQLoCd1G1l+Iuu3SXCzyuC/mEG+Cz+qBoVct3TaOzeA6GJ8IW7LTDq0+WY
         TgI/rl2T7Wc+McZP66phRj95pbOL8T5jOZZdNodkh7lj6RqklKdmBXZW0UnK3l8F5HFZ
         NxaA==
X-Forwarded-Encrypted: i=1; AJvYcCWt4YUxe15+OVXvog5h6zgMpLFKV8uCKyPMRKG4Hdy6Fi5sXyBmomoOTvT3OA6bVVBoWWI11+kBqexCtU8+4MeyjNKz4wrd2A==
X-Gm-Message-State: AOJu0YzeNlf92YiEk5JZvnQp+4M8Ay6aYZw5e+AGPa91Zhcp1YsmBn+p
	TfdJDCi63N1fiYkpF/sM6kVD6ADjWN2pZGGzV8q+nZkvb9uT889B9LsjW15JAg==
X-Google-Smtp-Source: AGHT+IG7cIldAux1KCpcOyUTRGVAfY4OuwFGQoFyysr4Ky17iN4jW+0w6szCAWKEExF3w960f89FHg==
X-Received: by 2002:a25:c244:0:b0:dc6:a8c6:c9e5 with SMTP id s65-20020a25c244000000b00dc6a8c6c9e5mr877740ybf.26.1708649907539;
        Thu, 22 Feb 2024 16:58:27 -0800 (PST)
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id p14-20020a056a0026ce00b006e4887b13ffsm4820031pfw.1.2024.02.22.16.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 16:58:27 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Herve Codina <herve.codina@bootlin.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Roy Luo <royluo@google.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	linux-usb@vger.kernel.org,
	maciek swiech <drmasquatch@google.com>
Subject: [PATCH v2 1/2] dt-bindings: usb: Add downstream facing ports to realtek binding
Date: Thu, 22 Feb 2024 16:58:20 -0800
Message-ID: <20240223005823.3074029-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240223005823.3074029-1-swboyd@chromium.org>
References: <20240223005823.3074029-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a graph with 4 output endpoints to this hub binding to support the
scenario where a downstream facing port is connected to a device that
isn't a connector or a USB device with a VID:PID. This will be used to
connect downstream facing ports to USB type-c switches so the USB
superspeed and high speed lanes can be put onto USB connectors.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: <linux-usb@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: maciek swiech <drmasquatch@google.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/usb/realtek,rts5411.yaml         | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
index f0784d2e86da..0874fc21f66f 100644
--- a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
+++ b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
@@ -21,6 +21,12 @@ properties:
 
   reg: true
 
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
   vdd-supply:
     description:
       phandle to the regulator that provides power to the hub.
@@ -30,6 +36,36 @@ properties:
     description:
       phandle to the peer hub on the controller.
 
+  ports:
+    $ref: /schemas/graph.yaml#/properties/ports
+
+    properties:
+      port@1:
+        $ref: /schemas/graph.yaml#/properties/port
+        description:
+          1st downstream facing USB port
+
+      port@2:
+        $ref: /schemas/graph.yaml#/properties/port
+        description:
+          2nd downstream facing USB port
+
+      port@3:
+        $ref: /schemas/graph.yaml#/properties/port
+        description:
+          3rd downstream facing USB port
+
+      port@4:
+        $ref: /schemas/graph.yaml#/properties/port
+        description:
+          4th downstream facing USB port
+
+patternProperties:
+  '^.*@[1-4]$':
+    description: The hard wired USB devices
+    type: object
+    $ref: /schemas/usb/usb-device.yaml
+
 required:
   - peer-hub
   - compatible
@@ -50,6 +86,13 @@ examples:
             reg = <1>;
             vdd-supply = <&pp3300_hub>;
             peer-hub = <&hub_3_0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+            /* USB 2.0 device on port 2 */
+            device@2 {
+                compatible = "usb123,4567";
+                reg = <2>;
+            };
         };
 
         /* 3.0 hub on port 2 */
@@ -58,5 +101,17 @@ examples:
             reg = <2>;
             vdd-supply = <&pp3300_hub>;
             peer-hub = <&hub_2_0>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                /* Type-A connector on port 4 */
+                port@4 {
+                    reg = <4>;
+                    endpoint {
+                      remote-endpoint = <&usb_a0_ss>;
+                    };
+                };
+            };
         };
     };
-- 
https://chromeos.dev

