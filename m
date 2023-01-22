Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989A2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F410FC433EF;
	Sun, 22 Jan 2023 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400723;
	bh=1gPbY/mnjbiEWaDYrFB2NlAa80InPf/V3rowh74uoe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcLWGs9dH8hZyGRG5VBT/SWdKwoby8D9mLGPZml/Q3YPMT36lR7NtNSbXPzNVja+v
	 gDLcOm21GjZbzfT6GXxPHq1pmxfS0bs1XNZt0KDCb5Oa9Hrt7zXiWG2+jcH4HlIguG
	 iAEIJte3yuSPMDgFgnRbGV7/No0oZStU06MjjT9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 084/117] dt-bindings: phy: g12a-usb2-phy: fix compatible string documentation
Date: Sun, 22 Jan 2023 16:04:34 +0100
Message-Id: <20230122150236.272134031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

commit c63835bf1c750c9b3aec1d5c23d811d6375fc23d upstream.

The compatible strings in the driver don't have the meson prefix.
Fix this in the documentation and rename the file accordingly.

Fixes: da86d286cce8 ("dt-bindings: phy: meson-g12a-usb2-phy: convert to yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/8d960029-e94d-224b-911f-03e5deb47ebc@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml       |   78 ++++++++++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml |   78 ----------
 2 files changed, 78 insertions(+), 78 deletions(-)
 rename Documentation/devicetree/bindings/phy/{amlogic,meson-g12a-usb2-phy.yaml => amlogic,g12a-usb2-phy.yaml} (85%)

--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb2-phy.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb2-phy.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic G12A USB2 PHY
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,g12a-usb2-phy
+      - amlogic,a1-usb2-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: xtal
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 0
+
+  phy-supply:
+    description:
+      Phandle to a regulator that provides power to the PHY. This
+      regulator will be managed during the PHY power on/off sequence.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - "#phy-cells"
+
+if:
+  properties:
+    compatible:
+      enum:
+        - amlogic,meson-a1-usb-ctrl
+
+then:
+  properties:
+    power-domains:
+      maxItems: 1
+  required:
+    - power-domains
+
+additionalProperties: false
+
+examples:
+  - |
+    phy@36000 {
+          compatible = "amlogic,g12a-usb2-phy";
+          reg = <0x36000 0x2000>;
+          clocks = <&xtal>;
+          clock-names = "xtal";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <0>;
+    };
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ /dev/null
@@ -1,78 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-# Copyright 2019 BayLibre, SAS
-%YAML 1.2
----
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb2-phy.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
-
-title: Amlogic G12A USB2 PHY
-
-maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
-
-properties:
-  compatible:
-    enum:
-      - amlogic,meson-g12a-usb2-phy
-      - amlogic,meson-a1-usb2-phy
-
-  reg:
-    maxItems: 1
-
-  clocks:
-    maxItems: 1
-
-  clock-names:
-    items:
-      - const: xtal
-
-  resets:
-    maxItems: 1
-
-  reset-names:
-    items:
-      - const: phy
-
-  "#phy-cells":
-    const: 0
-
-  phy-supply:
-    description:
-      Phandle to a regulator that provides power to the PHY. This
-      regulator will be managed during the PHY power on/off sequence.
-
-required:
-  - compatible
-  - reg
-  - clocks
-  - clock-names
-  - resets
-  - reset-names
-  - "#phy-cells"
-
-if:
-  properties:
-    compatible:
-      enum:
-        - amlogic,meson-a1-usb-ctrl
-
-then:
-  properties:
-    power-domains:
-      maxItems: 1
-  required:
-    - power-domains
-
-additionalProperties: false
-
-examples:
-  - |
-    phy@36000 {
-          compatible = "amlogic,meson-g12a-usb2-phy";
-          reg = <0x36000 0x2000>;
-          clocks = <&xtal>;
-          clock-names = "xtal";
-          resets = <&phy_reset>;
-          reset-names = "phy";
-          #phy-cells = <0>;
-    };


