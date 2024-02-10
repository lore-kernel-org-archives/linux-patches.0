Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427EC33CFC
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707548987; cv=none; b=e6tR7V0HVmp695OYJcly0rfbgTnKjEKOAyoRPonZa1AbHYTI+apHLribs2BkSbYZLsG2X/69Nhwj/iZA3nrRLnfzyt7r+oj3JI7sX9+GY0UqUoDopYpcG4wBZ8B5jGVMcU2hlI/ZlSrHjVY0m2rTqjKUDfg0EJEUwdTx0CE7dHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707548987; c=relaxed/simple;
	bh=PeDZQIpv2F0nTTHxmAelufZ+9YaQdvo2eTiG/pHOI/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSe9Sz4nE+fk8FGGcvqkw0GRSDBfdLrNbYs2nOSP8QRYLUsHZRp7Nyrjzz1MH/Er+FjLsHFr6Dk0YHRPpRmXE8qY2qhZtWW7NSEfXXfATAiMP0Vl9zNjdVqVKG65eQVCnsMxNx/y3Ev5AesAuAWtM7Is4gjSOqUnkWavHWJh8NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TKUMLqOa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TKUMLqOa"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d8ef977f1eso14406545ad.0
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707548985; x=1708153785; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UENrcY9RF89XEYAUM3UR0Kbw3cAWGOtKrrlH+rPz1Os=;
        b=TKUMLqOaPIXZB2jBBALeKYYlN14P1/xcOanFExuR2k9pOubJzk42YZ66PQelQNsJvv
         5YLmgDFC9q+3ZY7odHof6s71HgGKMwEMMRL7WYel/XBkS+uWJK2fvkhl1NpdP0zil4QA
         S78kp9tNUiVerAVYVV1Z7MkpYfLV9awvJQV6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707548985; x=1708153785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UENrcY9RF89XEYAUM3UR0Kbw3cAWGOtKrrlH+rPz1Os=;
        b=QzS8nDmcvwl6nrEgwhFUsHFU4UCjfY2ZmxevxiZ9iAuAUiGrgbgoMY8tsuLYb9WehE
         ukDtj6qnE8qWSbk2NerenfYzzOik8cFmI6AA9+jrTde36MWT0ve2J/FvLOfKRWHYP/8Z
         wD5wU0gzo3WIHMpppLLxaaQE57hRRB4AtwZZE6VCgl7wZTW4RJI5qJNwSmuIuRHF0mLg
         yMWsMTo4vwPlcx0WhdTlBpSSWJlFJXdqgg2BbIw9nGV1Ad3+Qjn+h4WNXTnmMTAp20ab
         y+QgSWHYq6zduOASEtRvPAB1IreSCcLfVyJBojq3SMrKwLdAmJ0O0yuTtFZEXvZtTZ9U
         x6kg==
X-Gm-Message-State: AOJu0YxDs0YSqFz3ulTDPmilhIjfHkwfLoHxu3f6ylQSrv5ad7E4HAx+
	GMWNojWuSy/VKygplNLU00latwz6e92n/6AAhOixjy7u5g1JoBBrc9qOm109Kw==
X-Google-Smtp-Source: AGHT+IGeYAK8ekxYXXY78qIHAecfdEKLr4g2+PQLKllAtw8+dhESn/vcq+039wpruZ/mWbRUYcdc5Q==
X-Received: by 2002:a17:903:58b:b0:1d9:b789:b1bd with SMTP id jv11-20020a170903058b00b001d9b789b1bdmr1490617plb.9.1707548984724;
        Fri, 09 Feb 2024 23:09:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW8sDzfMYBYjxyemsK+fiduXCKeElhlPm2IA15iWaQTyosgIv3SXegARx/7gWwIoNMf/OYJ1E5L5O5Yb2b2cIysWnO1oBD1SfE/Xesyq0bvl9Qttr51I2bt9ClXYAhX3IXr8h4Hu9CW6OoRfdlMa2TibWpE7LcBN1K8yo7rWf7F8oEzsK7wzzFq8ZitQ252uzLEjAaf+53MhwjFdA1ZyhuS8wLGDgnSyuia6hk1G3N/eEipCDs89DaebviqoHKBjDRZHKPc3zKsHGXtXUZUiqWOIKZLxWz89I6rUigdeA3U8/KzF/uxgWGJgOMP5mj52kafxMePldEjGbWkyKShGLNqo7W47/Z/OE8vsmZt8/drrEqhpc97BRAuzJ0UEJ+6JdgF89TFwnsdyCGgr29sP1qQcsFwW9SU6tKWO36qSqLHbn5pCKLzla/cJafZwaHTtTm2gWe9W6TnaLjptpvJDvFXaSttVVWHj7K67Uou9dL/lbB0Q+WtVQK/o8teLN2FjNT7QQlI
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id d4-20020a170903230400b001d90a67e10bsm2489560plh.109.2024.02.09.23.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:09:44 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	linux-usb@vger.kernel.org,
	maciek swiech <drmasquatch@google.com>
Subject: [PATCH 03/22] dt-bindings: usb: Add downstream facing ports to realtek binding
Date: Fri,  9 Feb 2024 23:09:14 -0800
Message-ID: <20240210070934.2549994-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
In-Reply-To: <20240210070934.2549994-1-swboyd@chromium.org>
References: <20240210070934.2549994-1-swboyd@chromium.org>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
 .../bindings/usb/realtek,rts5411.yaml         | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
index f0784d2e86da..5480a31698be 100644
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
+  "^.*@[1-4]$":
+    description: The hard wired USB devices
+    type: object
+    $ref: /schemas/usb/usb-device.yaml
+
 required:
   - peer-hub
   - compatible
@@ -50,6 +86,11 @@ examples:
             reg = <1>;
             vdd-supply = <&pp3300_hub>;
             peer-hub = <&hub_3_0>;
+            /* USB 2.0 device on port 2 */
+            device@2 {
+                compatible = "usb123,4567";
+                reg = <2>;
+            };
         };
 
         /* 3.0 hub on port 2 */
@@ -58,5 +99,14 @@ examples:
             reg = <2>;
             vdd-supply = <&pp3300_hub>;
             peer-hub = <&hub_2_0>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@0 {
+                    reg = <0>;
+                    remote-endpoint = <&usb_a0_ss>;
+                };
+            };
         };
     };
-- 
https://chromeos.dev

