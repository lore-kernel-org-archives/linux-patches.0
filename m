Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9867EEA6
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744761742; cv=none; b=IuxZxkNteaY29XLaouwgduccg707rGUHZDdWpNAUo3fxFuUJZiARB7k0s0s9nCzmsB/sZ0T3T2Ay0ZQBm/cx1EH3y8IAgmJBjeKMsFsHWV0CAWp4GxQ/hJpOzFdT54q9AtJrPwWTmyoSzz4tRKdALQUDONqcU3f8cvsOljqpAZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744761742; c=relaxed/simple;
	bh=tZfWDcOQ8bgRqRi+NW+GjNxPj8wZOgOCyGs7+vqornI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSDbuKdkgqqC/jzue15A8AY4L5PS0ubu6/bufjekukXFBY7tloZOgUAoHcGQOMWgzCbLaS2yY25bUf8PbGbcDVnJrcEUyCe4vWjkOdwXrprOga1XymSzCRFZ9iif6lnwYyNxEzKqjBYmxX/BGyGvZV5kmuMX5k4pq+Bd1h3W3r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=isYcI8Vf; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="isYcI8Vf"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22435603572so58977275ad.1
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1744761740; x=1745366540; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nrlq2rYfgBLmHuWsTGNtsJ7KxYne7Xpu0dSG8i28Zdk=;
        b=isYcI8VfUzsFQX7V2I17NsI2r6oFWxMJCT1/EAG6tZTB4PnqnbUn7dAOxlds6+atuR
         oYBwrpd8HFOE2cuJk9UNLGewdnJpPu70z6S7jRBqY2jAWc5zKJfVazlj1pMVp7lRegjG
         jYqRqHDcAr+jAriYCFwLg4Ta1AsZxkHXW5ahQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744761740; x=1745366540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nrlq2rYfgBLmHuWsTGNtsJ7KxYne7Xpu0dSG8i28Zdk=;
        b=KlX4e2ABktsqq8QjAKtME2g0T8PdFIPPRA0ZzNBedS6XOBm52Llt1hg0shw+T8RYLu
         Z+w7zEzF0BmPvhZdLSFgUlMiEaxWZ7MQ3gZPldIYTavoruwOnilbjBo3tmXKk0ZPSCO0
         Qbux9xcwH5t3ihXHuKbdDH3Klwmm9yS3QUJ8dvEb4yRchywnavANn7Vz/YWF6fM3kqss
         ODB276WSIQwAFXZN5J+WMYaBWBA64h/7akTVGTIBzqZCbHJBeY5LIO+EhNABfBXh8W5t
         f8JM9c41wyFxlRuPBkdepR2LvGTsQU23BYPv4KNQ56QKjlmikLJQ899EKh0rEBed0rqi
         LBNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVncN5AwHuwlOmklAT3q3kgBAsMJz52tzcTYmYem+KoUF0Wpc9zIGEY+DiC2n+8NB0DmmyBd9v0@lists.linux.dev
X-Gm-Message-State: AOJu0YyfqqhNz0yYjGZwSz4vULyhdLRvxl1K1fkVcLfJknbZ21zmWUtH
	IC3SttJdp2lLjHMbqE9TUsKPosoeLJYQ7SnvsUgMiuzhsdkL18ASqfFpXV4Uhg==
X-Gm-Gg: ASbGncsrfxK3zM9H2HVbEdm2wfRh9FZ79XOlv853nYxT5dXbN99Lh/uCXUH9XS2HQqp
	zZBZbJzdJr/k/Mams6siWF9PvLUcS89Zx/khD6vwby7XDG++mrK03cKb90BMIdMyDqcxIT8dkwq
	/QtzE7sGlX7r5OraFUWBBKFajMkBeHCQYi9BSZiT4jj1v7uV7NqJ/MFuQzBJuLf91oDGATI36ZF
	HKTPPm8t6DMTdxZLUx2nZtFAHYRwn48aascfPbFkylwR5IE85w9QsQR8Z1QIYMd1/IIoW6d029R
	kPYdmd9d0SCuMNyRoTIo3+jeqVNDEHLpJyRZS9YCGvoW4+z58kasqG2ne+R6pIpr8W7veXBl8c1
	cLglYA2St/3dt
X-Google-Smtp-Source: AGHT+IF1TOXiHYmZ5Jg3EXQSDRIROqzmWiXyNsBmBpcbZ0pKroNPtY+R3VjCmcQUVeHmUyzQagE5Vg==
X-Received: by 2002:a17:902:e545:b0:224:e33:8896 with SMTP id d9443c01a7336-22c31a0aca5mr15114425ad.11.1744761740162;
        Tue, 15 Apr 2025 17:02:20 -0700 (PDT)
Received: from localhost (199.24.125.34.bc.googleusercontent.com. [34.125.24.199])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22c33f1d392sm1327015ad.99.2025.04.15.17.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 17:02:19 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>
Subject: [PATCH 5/7] dt-bindings: usb: google,cros-ec-typec: Add ports for DP altmode
Date: Tue, 15 Apr 2025 17:02:05 -0700
Message-ID: <20250416000208.3568635-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
In-Reply-To: <20250416000208.3568635-1-swboyd@chromium.org>
References: <20250416000208.3568635-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a DT graph binding to google,cros-ec-typec so that it can combine
DisplayPort (DP) and USB SuperSpeed (SS) data into a USB type-c endpoint
that is connected to the usb-c-connector node's SS endpoint. Allow there
to be multiple 'typec' nodes underneath the EC node so that one DT graph
exists per DP bridge. The EC is actually controlling TCPCs and redrivers
that combine the DP and USB signals together so this more accurately
reflects the hardware design without introducing yet another DT node
underneath the EC for USB type-c "stuff".

If the type-c ports are being shared between a single DP controller then
the ports need to know about each other and determine a policy to drive
DP to one type-c port or the other. If the type-c ports each have their
own dedicated DP controller then they're able to operate independently
and enter/exit DP altmode independently as well. We can't connect the DP
controller's endpoint to one usb-c-connector port@1 endpoint and the USB
controller's endpoint to another usb-c-connector port@1 endpoint either
because the DP muxing case would have DP connected to two
usb-c-connector endpoints which the graph binding doesn't support.

Therefore, one typec node is required per the capabilities of the type-c
port(s) being managed. Add a port to the DisplayPort altmode as well, so
that we can show the connection between the DP controller and the DP
altmode. This lets us indicate which type-c ports the DP controller is
wired to. For example, if DP was connected to ports 0 and 2, while port
1 was connected to another DP controller we wouldn't be able to
implement that without having some other DT property to indicate which
output ports are connected to the DP endpoint.

Furthermore, this supports ChromeOS designs like Corsola where a DP
controller/PHY is split with two lanes going to one connector and the
other two lanes going to another connector. In this case, we wouldn't
have the graph binding under the cros-ec-typec node, but we would have
the graph binding in the DP altmode directly connected to the DP
controller's two output endpoints.

Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Acked-by: Lee Jones <lee@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc: Łukasz Bartosik <ukaszb@chromium.org>
Cc: Jameson Thies <jthies@google.com>
Cc: Andrei Kuchynski <akuchynski@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../bindings/connector/usb-connector.yaml     |   6 +
 .../bindings/mfd/google,cros-ec.yaml          |   7 +-
 .../bindings/usb/google,cros-ec-typec.yaml    | 165 ++++++++++++++++++
 3 files changed, 175 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
index 11e40d225b9f..e3d60997c03e 100644
--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -179,6 +179,12 @@ properties:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: VDO returned by Discover Modes USB PD command.
 
+          port:
+            $ref: /schemas/graph.yaml#/properties/port
+            description: OF graph bindings modeling a data bus to the
+              DisplayPort altmode from the DisplayPort controller. Used when
+              the altmode switch is part of the port manager.
+
   port:
     $ref: /schemas/graph.yaml#/properties/port
     description: OF graph bindings modeling a data bus to the connector, e.g.
diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
index ac89696fa649..63d506e88abb 100644
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
@@ -163,6 +160,10 @@ patternProperties:
     type: object
     $ref: /schemas/extcon/extcon-usbc-cros-ec.yaml#
 
+  "^typec(-[0-9])*$":
+    type: object
+    $ref: /schemas/usb/google,cros-ec-typec.yaml#
+
 required:
   - compatible
 
diff --git a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
index 3272d0e01f7e..611345bbe884 100644
--- a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
+++ b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
@@ -26,6 +26,55 @@ properties:
   '#size-cells':
     const: 0
 
+  mux-gpios:
+    description: GPIOs indicating which way the DisplayPort mux is steered
+    minItems: 1
+    maxItems: 3
+
+  no-hpd:
+    description: Indicates this device doesn't signal HPD for DisplayPort
+    type: boolean
+
+  ports:
+    $ref: /schemas/graph.yaml#/properties/ports
+
+    properties:
+      port@0:
+        $ref: /schemas/graph.yaml#/properties/port
+        description:
+          Port for DisplayPort (DP) data
+
+        properties:
+          endpoint@0:
+            $ref: /schemas/graph.yaml#/properties/endpoint
+            description: Input DP port
+
+        patternProperties:
+          '^endpoint@[1-8]$':
+            $ref: /schemas/graph.yaml#/properties/endpoint
+            description: Output to the usb-c connector's DP altmode
+
+        required:
+          - endpoint@0
+
+        anyOf:
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
 patternProperties:
   '^connector@[0-9a-f]+$':
     $ref: /schemas/connector/usb-connector.yaml#
@@ -35,10 +84,30 @@ patternProperties:
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
+            - port@0
+  - if:
+      required:
+        - mux-gpios
+    then:
+      properties:
+        ports:
+          required:
+            - port@0
+
 additionalProperties: false
 
 examples:
   - |+
+    #include <dt-bindings/gpio/gpio.h>
+
     spi {
       #address-cells = <1>;
       #size-cells = <0>;
@@ -47,6 +116,8 @@ examples:
         compatible = "google,cros-ec-spi";
         reg = <0>;
         interrupts = <35 0>;
+        #gpio-cells = <2>;
+        gpio-controller;
 
         typec {
           compatible = "google,cros-ec-typec";
@@ -54,12 +125,106 @@ examples:
           #address-cells = <1>;
           #size-cells = <0>;
 
+          mux-gpios = <&cros_ec 42 GPIO_ACTIVE_HIGH>, <&cros_ec 3 GPIO_ACTIVE_HIGH>;
+
           connector@0 {
             compatible = "usb-c-connector";
             reg = <0>;
             power-role = "dual";
             data-role = "dual";
             try-power-role = "source";
+
+            altmodes {
+              displayport {
+                port {
+                  usbc0_dp: endpoint {
+                    remote-endpoint = <&dp_out0>;
+                  };
+                };
+              };
+            };
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
+                  remote-endpoint = <&usb_hub_dfp3_ss>;
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
+            altmodes {
+              displayport {
+                port {
+                  usbc1_dp: endpoint {
+                    remote-endpoint = <&dp_out1>;
+                  };
+                };
+              };
+            };
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
+                  remote-endpoint = <&usb_hub_dfp2_ss>;
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
+              };
+
+              dp_out0: endpoint@1 {
+                reg = <1>;
+                remote-endpoint = <&usbc0_dp>;
+              };
+
+              dp_out1: endpoint@2 {
+                reg = <2>;
+                remote-endpoint = <&usbc1_dp>;
+              };
+            };
           };
         };
       };
-- 
https://chromeos.dev

