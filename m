Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD414E2FA
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163657; cv=none; b=jKAbzTbpj1FOgKCjsD1siVs6kGjh1fF/to43NB+UBn/k/zAWlD9f/rxUjL7awoQmblTt1MQC0gsh+1IbN3DEOWYMPUr1sL/iKdRas1AdbdBb8uuDXETJLfiDh1wYfui8+rffWdFiJCFBZX+68Oe/saohi2OlyC3X98lOyV+AKJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163657; c=relaxed/simple;
	bh=WOQQCDCTDzH1gapFAgaMeUAT0zwZNlWAdNWqIr5X/+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMyA+vYTPMF4af+qqX3OSE+HMzWFawI3edPacVWzXD62GDFomh7zOX0ZA6DXc/iP7fjdnOXL5Phlc1tN7jft93uBvDnErP8CDve3+3OQxa8TYmgWoUjy+5M1IKfDKLNSjAc1cMcvI/F33b48DuEC4w8Q4vd87I860e1oBRJfMPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dQS+r4aC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dQS+r4aC"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2021c08b95cso30953605ad.0
        for <patches@lists.linux.dev>; Sat, 31 Aug 2024 21:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725163654; x=1725768454; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbprL3O5uRtoBez6xE8gNyhklG4JEaVa8fjN58vGWmo=;
        b=dQS+r4aCP0y8/Ny+DhHF+VgTAp1Gm3FMZLg2+vGPFYHNtwPBGVHRb6PIFQAijIhRxD
         PRZ4mZgp9xbuAKkButM4YQstrKeDQcZCLP0KC00L8UzGAMHUsZYtSouVIv7XnjuEVpd/
         tQZxWYUvukblgTOg2p87FeiQFJho3Jq1Wy/Ms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725163654; x=1725768454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PbprL3O5uRtoBez6xE8gNyhklG4JEaVa8fjN58vGWmo=;
        b=V4ojXPsYil6QlFSI8WECsY82tZMFV+LPsRKLLUbZ1P2fZq0DBfN1azcZoW9IGWllHN
         ePfkM4KBVHIaC7IuP3dukhsHlWNmbgUrpDgKeEJsF3t3wI7vXOgWzYcJ41k2XXJIBlhY
         SXeF2K0FuGmu6iQ++8LFbgmXfby/LS7z71UJ5dl9A1/vEYDq7eQxGZsuZIxvKMMH6j/v
         Lf8aD3kDmRqUbnyfAthlvODDg764yAqzKO+8UqSBPpGbnGhRzfI2z8DMMFE2dRenRY1T
         rlEGff39IsN4yNoH3wjuUiRo0UmsFona4p5pBPTuokxlUUKHJgEtNPFMywf/cdwj1WSR
         DhAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmJvt4DbgnG7UQgToOkQsqcMqL8TBNs00pEBrP6H04TKJX9F1Eh9W3YK0Cc/RRR78BXhOwWbYR@lists.linux.dev
X-Gm-Message-State: AOJu0YwAQg4IQCxV1qxw3zXQJo2lh4K8YQ1j1dn06EB6JFYz+D1OcvNT
	YtKu/N6gQzYG7SrBfD4hnaTZotUakiU6W+gQ2P+cGCk3/HKXtf/in2zNGecSQA==
X-Google-Smtp-Source: AGHT+IHMnQiUjN9f1YWEGM0JdOjALu7X8K8AbH1Oilpa9S51nEUs+XXgha5QPmoQddesTYlXreZjQQ==
X-Received: by 2002:a17:902:ce01:b0:203:a10a:9887 with SMTP id d9443c01a7336-205276c2e26mr115311825ad.3.1725163654329;
        Sat, 31 Aug 2024 21:07:34 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-20568d21dd4sm2338785ad.155.2024.08.31.21.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Aug 2024 21:07:34 -0700 (PDT)
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
Subject: [PATCH v4 15/18] dt-bindings: usb: Add ports to google,cros-ec-typec for DP altmode
Date: Sat, 31 Aug 2024 21:06:53 -0700
Message-ID: <20240901040658.157425-16-swboyd@chromium.org>
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

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Acked-by: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/mfd/google,cros-ec.yaml          |   7 +-
 .../bindings/usb/google,cros-ec-typec.yaml    | 229 ++++++++++++++++++
 2 files changed, 233 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index c991626dc22b..bbe28047d0c0 100644
--- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
+++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
@@ -98,9 +98,6 @@ properties:
 
   gpio-controller: true
 
-  typec:
-    $ref: /schemas/usb/google,cros-ec-typec.yaml#
-
   ec-pwm:
     $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
     deprecated: true
@@ -166,6 +163,10 @@ patternProperties:
     type: object
     $ref: /schemas/extcon/extcon-usbc-cros-ec.yaml#
 
+  "^typec(-[0-9])*$":
+    type: object
+    $ref: /schemas/usb/google,cros-ec-typec.yaml#
+
 required:
   - compatible
 
diff --git a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
index 365523a63179..235b86da3cdd 100644
--- a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
@@ -26,6 +26,106 @@ properties:
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
+  mode-switch:
+    $ref: usb-switch.yaml#properties/mode-switch
+
+  orientation-switch:
+    $ref: usb-switch.yaml#properties/orientation-switch
+
+  ports:
+    $ref: /schemas/graph.yaml#/properties/ports
+
+    properties:
+      port@0:
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        unevaluatedProperties: false
+        description: Output ports for combined DP and USB SS data
+        patternProperties:
+          "^endpoint@([0-8])$":
+            $ref: usb-switch.yaml#/$defs/usbc-out-endpoint
+            unevaluatedProperties: false
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
+      port@1:
+        $ref: /schemas/graph.yaml#/$defs/port-base
+        unevaluatedProperties: false
+        description:
+          Input port to receive USB SuperSpeed (SS) data
+        patternProperties:
+          "^endpoint@([0-8])$":
+            $ref: usb-switch.yaml#/$defs/usbc-in-endpoint
+            unevaluatedProperties: false
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
+        description:
+          Input port to receive DisplayPort (DP) data
+        unevaluatedProperties: false
+
+        properties:
+          endpoint:
+            $ref: usb-switch.yaml#/$defs/dp-endpoint
+            unevaluatedProperties: false
+
+        required:
+          - endpoint
+
+    required:
+      - port@0
+
+    anyOf:
+      - required:
+          - port@1
+      - required:
+          - port@2
+
 patternProperties:
   '^connector@[0-9a-f]+$':
     $ref: /schemas/connector/usb-connector.yaml#
@@ -35,6 +135,40 @@ patternProperties:
 required:
   - compatible
 
+allOf:
+  - if:
+      required:
+        - no-hpd
+    then:
+      properties:
+        ports:
+          required:
+            - port@2
+  - if:
+      required:
+        - mux-gpios
+    then:
+      properties:
+        ports:
+          required:
+            - port@2
+  - if:
+      required:
+        - orientation-switch
+    then:
+      properties:
+        ports:
+          required:
+            - port@2
+  - if:
+      required:
+        - mode-switch
+    then:
+      properties:
+        ports:
+          required:
+            - port@2
+
 additionalProperties: false
 
 examples:
@@ -50,6 +184,8 @@ examples:
 
         typec {
           compatible = "google,cros-ec-typec";
+          orientation-switch;
+          mode-switch;
 
           #address-cells = <1>;
           #size-cells = <0>;
@@ -60,6 +196,99 @@ examples:
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
+              dp_in: endpoint {
+                remote-endpoint = <&dp_phy>;
+                data-lanes = <0 1>;
+              };
+            };
           };
         };
       };
-- 
https://chromeos.dev

