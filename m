Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66F239855
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 00:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723682078; cv=none; b=CjqK6cNnTxsJQM8Yaa4SRF833dsyYWCC9IbFC307v3xbkgOFBM/DgfLqh3CfcMB8g5hDrnMdpNOS2RAYa3KqRfh75LfwUJPbIGtv1G2ZKNIjt1ZL4U62ARzVYNOgiPEqE0J5dMPYIsmL5unnZHvwqgqk5SctGnsxIVjdhJukLoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723682078; c=relaxed/simple;
	bh=TumcHWw87aylU9A2iL70884Gdnzc7x4bQe8WzgEWOQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXl7O3qTLcblJGwLWjawNi3+YRx61ompGLftIqwlAwjjXUg9IhOIgur5p03Ooo8n1XqUGhyfCe0QySaiNLJkw1impK2Dpb2H/eFspWHFnoLWAGyzAQpTw17Sntsr7otnd5PhyyEVm4at/Mni9zdbiZFZ3XRvQQDjT37NS7jSwFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=lbGTClEo; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lbGTClEo"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fc569440e1so4243695ad.3
        for <patches@lists.linux.dev>; Wed, 14 Aug 2024 17:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723682076; x=1724286876; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1sRgulPJ1+mkqgVa6mf/3UC8LhJzrRLUVCX/M4EQ0c4=;
        b=lbGTClEofy+bIriVhE3zIDM3KVV+Fj7fVcjHw4F8sFqN7xJKQJd3lT0xHK5Ce2VThK
         f2K10qb8u+oz3QQ6q9mkI6qm3KIjqVf8BNP3yzZjhGQAAe2ZRJIsxftYUJm8Wne+CD7I
         EaUErK75mkep63kUcckJBYg0IL68Bxb+3UoG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723682076; x=1724286876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1sRgulPJ1+mkqgVa6mf/3UC8LhJzrRLUVCX/M4EQ0c4=;
        b=nIcl60CsSBPdODL3jiu4SI/4m9f63g5dQmkGZs/AAYNhvqs2Vw77OJnUNttZ8HliMU
         16trxQEliSCWEX0U1pgqB50gJv8pWJc6McMgjhaEkaY1nfnAYwo7S00+NdSqrr4YEyEm
         TTCclCG+xb1E2szrnPIQ8rUF2xO83vhN0yFIVHrOUyuKdnG3sDwZNFQSnW9D6EWo8FT7
         qsuWYkO/9i6tVrS1m32dDhP/jNcWg9BxeyZd+c1xo2TJFlaMHsxcKHys4/jKBq5R1PXI
         uphgvaY+4gn55/2brHaNALKtHN909QpjuHFjC3eMTBP5FmwoOAr6Xq8kivQZlwoQqyAR
         J31Q==
X-Forwarded-Encrypted: i=1; AJvYcCXd6qWVk4oVCiJMjNuCOk+OFOEpkUzftuo7y/Wkj7QST2jJ8iJaAGIO4b0KxKWj62ixEciNuxUaydpxzEsax64DnhfOGjTGXw==
X-Gm-Message-State: AOJu0YxOwMfr0VROTIsHKtMX8AcL3BQRcA0efR19OpSiY2/wN7tecCk6
	Eoj5FKglLAHCRpY34Psfj/Q/OqeedUm6w3RcM8VTsDY1v5XDxLFzOrp5U1wSaA==
X-Google-Smtp-Source: AGHT+IHbVzloJcEMHTMRWtdVRBjc1XqfslsElu4LQA8xI/W2vRG5qbpPTju2PgzgyOJIJKY/OqqVPg==
X-Received: by 2002:a17:902:ced0:b0:1fd:91b1:7897 with SMTP id d9443c01a7336-201d64d0e79mr53482475ad.65.1723682075829;
        Wed, 14 Aug 2024 17:34:35 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f02faa5dsm2033485ad.2.2024.08.14.17.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 17:34:34 -0700 (PDT)
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
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH v2 07/11] dt-bindings: chrome: Add ports to google,cros-ec-typec for DP altmode
Date: Wed, 14 Aug 2024 17:34:12 -0700
Message-ID: <20240815003417.1175506-8-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815003417.1175506-1-swboyd@chromium.org>
References: <20240815003417.1175506-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a DT graph binding to google,cros-ec-typec so that it can combine
DisplayPort (DP) and USB SuperSpeed (SS) data into a USB type-c endpoint
that is connected to the usb-c-connector node's SS endpoint. This also
allows us to connect the DP and USB nodes in the graph to the USB type-c
connectors, providing the full picture of the USB type-c data flows in
the system.

Allow there to be multiple typec nodes underneath the EC node so that
one DT graph exists per DP bridge. The EC is actually controlling TCPCs
and redrivers that combine the DP and USB signals together so this more
accurately reflects the hardware design without introducing yet another
DT node underneath the EC for USB type-c.

If the type-c ports are being shared between a single DP controller then
the ports need to know about each other and determine a policy to drive
DP to one type-c port. If the type-c ports each have their own dedicated
DP controller then they're able to operate independently and enter/exit
DP altmode independently as well. We can't connect the DP controller's
endpoint to one usb-c-connector port@1 endpoint and the USB controller's
endpoint to another usb-c-connector port@1 endpoint either because the
DP muxing case would have DP connected to two usb-c-connector endpoints
which the graph binding doesn't support.

Therefore, one typec node is required per the capabilities of the type-c
port(s) being managed. This also lets us indicate which type-c ports the
DP controller is wired to. For example, if DP was connected to ports 0
and 2, while port 1 was connected to another DP controller we wouldn't
be able to implement that without having some other DT property to
indicate which output ports are connected to the DP endpoint.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/chrome/google,cros-ec-typec.yaml | 260 ++++++++++++++++++
 .../bindings/mfd/google,cros-ec.yaml          |   7 +-
 2 files changed, 264 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
index 9f9816fbecbc..1238adfbea21 100644
--- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
@@ -26,6 +26,137 @@ properties:
   '#size-cells':
     const: 0
 
+  mux-gpios:
+    description: GPIOs indicating which way the DP mux is steered
+    maxItems: 1
+
+  no-hpd:
+    description: Indicates this endpoint doesn't signal HPD for DisplayPort
+    type: boolean
+
+  orientation:
+    description:
+      Indicates this endpoint assigns lanes based on altmode and
+      type-c port orientation
+    type: boolean
+
+  ports:
+    $ref: /schemas/graph.yaml#/properties/ports
+
+    properties:
+      port@0:
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        description:
+          Input port to receive DisplayPort (DP) data
+        unevaluatedProperties: false
+
+        properties:
+          endpoint@0:
+            $ref: /schemas/graph.yaml#/$defs/endpoint-base
+            description: DisplayPort data for the type-c port(s)
+            unevaluatedProperties: false
+            properties:
+              data-lanes:
+                $ref: /schemas/types.yaml#/definitions/uint32-array
+                description: |
+                  An array of physical DP data lane indexes
+                  - 0 is DP ML0 lane
+                  - 1 is DP ML1 lane
+                  - 2 is DP ML2 lane
+                  - 3 is DP ML3 lane
+                oneOf:
+                  - items:
+                      - const: 0
+                      - const: 1
+                  - items:
+                      - const: 0
+                      - const: 1
+                      - const: 2
+                      - const: 3
+
+        required:
+          - endpoint@0
+
+      port@1:
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        unevaluatedProperties: false
+        description:
+          Input port to receive USB SuperSpeed (SS) data
+        patternProperties:
+          "^endpoint@([0-8])$":
+            $ref: /schemas/graph.yaml#/properties/endpoint
+
+        anyOf:
+          - required:
+              - endpoint@0
+          - required:
+              - endpoint@1
+          - required:
+              - endpoint@2
+          - required:
+              - endpoint@3
+          - required:
+              - endpoint@4
+          - required:
+              - endpoint@5
+          - required:
+              - endpoint@6
+          - required:
+              - endpoint@7
+          - required:
+              - endpoint@8
+
+      port@2:
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        unevaluatedProperties: false
+        description: Output ports for combined DP and USB SS data
+        patternProperties:
+          "^endpoint@([0-8])$":
+            $ref: /schemas/graph.yaml#/$defs/endpoint-base
+            unevaluatedProperties: false
+
+            properties:
+              data-lanes:
+                $ref: /schemas/types.yaml#/definitions/uint32-array
+                description: |
+                  An array of physical USB Type-C data lane indexes.
+                  - 0 is SSRX1 lane
+                  - 1 is SSTX1 lane
+                  - 2 is SSTX2 lane
+                  - 3 is SSRX2 lane
+                minItems: 4
+                maxItems: 4
+                items:
+                  maximum: 3
+
+        anyOf:
+          - required:
+              - endpoint@0
+          - required:
+              - endpoint@1
+          - required:
+              - endpoint@2
+          - required:
+              - endpoint@3
+          - required:
+              - endpoint@4
+          - required:
+              - endpoint@5
+          - required:
+              - endpoint@6
+          - required:
+              - endpoint@7
+          - required:
+              - endpoint@8
+
+    required:
+      - port@2
+    anyOf:
+      - required:
+          - port@0
+      - required:
+          - port@1
+
 patternProperties:
   '^connector@[0-9a-f]+$':
     $ref: /schemas/connector/usb-connector.yaml#
@@ -35,6 +166,38 @@ patternProperties:
 required:
   - compatible
 
+allOf:
+  - if:
+      properties:
+        no-hpd: true
+      required:
+        - no-hpd
+    then:
+      properties:
+        ports:
+          required:
+            - port@0
+  - if:
+      properties:
+        mux-gpios: true
+      required:
+        - mux-gpios
+    then:
+      properties:
+        ports:
+          required:
+            - port@0
+  - if:
+      properties:
+        orientation: true
+      required:
+        - orientation
+    then:
+      properties:
+        ports:
+          required:
+            - port@0
+
 additionalProperties: false
 
 examples:
@@ -60,6 +223,103 @@ examples:
             power-role = "dual";
             data-role = "dual";
             try-power-role = "source";
+
+            ports {
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              port@0 {
+                reg = <0>;
+                usb_c0_hs: endpoint {
+                  remote-endpoint = <&usb_hub_dfp3_hs>;
+                };
+              };
+
+              port@1 {
+                reg = <1>;
+                usb_c0_ss: endpoint {
+                  remote-endpoint = <&cros_typec_c0_ss>;
+                };
+              };
+            };
+          };
+
+          connector@1 {
+            compatible = "usb-c-connector";
+            reg = <1>;
+            power-role = "dual";
+            data-role = "dual";
+            try-power-role = "source";
+
+            ports {
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              port@0 {
+                reg = <0>;
+                usb_c1_hs: endpoint {
+                  remote-endpoint = <&usb_hub_dfp2_hs>;
+                };
+              };
+
+              port@1 {
+                reg = <1>;
+                usb_c1_ss: endpoint {
+                  remote-endpoint = <&cros_typec_c1_ss>;
+                };
+              };
+            };
+          };
+
+          ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+              reg = <0>;
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              dp_in: endpoint@0 {
+                reg = <0>;
+                remote-endpoint = <&dp_phy>;
+                data-lanes = <0 1>;
+              };
+            };
+
+            port@1 {
+              reg = <1>;
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              usb_in_0: endpoint@0 {
+                reg = <0>;
+                remote-endpoint = <&usb_ss_0_out>;
+              };
+
+              usb_in_1: endpoint@1 {
+                reg = <1>;
+                remote-endpoint = <&usb_ss_1_out>;
+              };
+            };
+
+            port@2 {
+              reg = <2>;
+              #address-cells = <1>;
+              #size-cells = <0>;
+
+              cros_typec_c0_ss: endpoint@0 {
+                reg = <0>;
+                remote-endpoint = <&usb_c0_ss>;
+                data-lanes = <0 1 2 3>;
+              };
+
+              cros_typec_c1_ss: endpoint@1 {
+                reg = <1>;
+                remote-endpoint = <&usb_c1_ss>;
+                data-lanes = <2 3 0 1>;
+              };
+            };
           };
         };
       };
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index aac8819bd00b..c860eb7ed3f5 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -98,9 +98,6 @@ properties:
 
   gpio-controller: true
 
-  typec:
-    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
-
   ec-pwm:
     $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
     deprecated: true
@@ -166,6 +163,10 @@ patternProperties:
     type: object
     $ref: /schemas/extcon/extcon-usbc-cros-ec.yaml#
 
+  "^typec(-[0-9])*$":
+    type: object
+    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
+
 required:
   - compatible
 
-- 
https://chromeos.dev

