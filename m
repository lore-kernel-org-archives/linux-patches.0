Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A07E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215D4C433D2;
	Sun, 22 Jan 2023 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400240;
	bh=8O5LWC1VRYzNH75i6GxRY3NbcghFQobmTehkULr/oyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOAZSw1qvKIYODyBKoo944De+CvyYBzhddkhhun4QzMXWZt+Rq+qRBz6kgpO8KSix
	 pBhP3zeYQ0Fw5uthIdhfrYb6/ryWoPTj6V/GHOC8uFgAFKXIWKfcnKXqDIBrRplHie
	 cmfp/JJUaccDTW5guMCeALEcRU6A3Q6tjdmnYNJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 42/55] dt-bindings: phy: g12a-usb3-pcie-phy: fix compatible string documentation
Date: Sun, 22 Jan 2023 16:04:29 +0100
Message-Id: <20230122150223.914201566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
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

commit e181119046a0ec16126b682163040e8e33f310c1 upstream.

The compatible string in the driver doesn't have the meson prefix.
Fix this in the documentation and rename the file accordingly.

Fixes: 87a55485f2fc ("dt-bindings: phy: meson-g12a-usb3-pcie-phy: convert to yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/0a82be92-ce85-da34-9d6f-4b33034473e5@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml       |   57 ++++++++++
 Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |   57 ----------
 2 files changed, 57 insertions(+), 57 deletions(-)
 rename Documentation/devicetree/bindings/phy/{amlogic,meson-g12a-usb3-pcie-phy.yaml => amlogic,g12a-usb3-pcie-phy.yaml} (82%)

--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/amlogic,g12a-usb3-pcie-phy.yaml
@@ -0,0 +1,57 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/phy/amlogic,g12a-usb3-pcie-phy.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic G12A USB3 + PCIE Combo PHY
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - amlogic,g12a-usb3-pcie-phy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: ref_clk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    items:
+      - const: phy
+
+  "#phy-cells":
+    const: 1
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
+examples:
+  - |
+    phy@46000 {
+          compatible = "amlogic,g12a-usb3-pcie-phy";
+          reg = <0x46000 0x2000>;
+          clocks = <&ref_clk>;
+          clock-names = "ref_clk";
+          resets = <&phy_reset>;
+          reset-names = "phy";
+          #phy-cells = <1>;
+    };
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
+++ /dev/null
@@ -1,57 +0,0 @@
-# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
-# Copyright 2019 BayLibre, SAS
-%YAML 1.2
----
-$id: "http://devicetree.org/schemas/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml#"
-$schema: "http://devicetree.org/meta-schemas/core.yaml#"
-
-title: Amlogic G12A USB3 + PCIE Combo PHY
-
-maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
-
-properties:
-  compatible:
-    enum:
-      - amlogic,meson-g12a-usb3-pcie-phy
-
-  reg:
-    maxItems: 1
-
-  clocks:
-    maxItems: 1
-
-  clock-names:
-    items:
-      - const: ref_clk
-
-  resets:
-    maxItems: 1
-
-  reset-names:
-    items:
-      - const: phy
-
-  "#phy-cells":
-    const: 1
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
-examples:
-  - |
-    phy@46000 {
-          compatible = "amlogic,meson-g12a-usb3-pcie-phy";
-          reg = <0x46000 0x2000>;
-          clocks = <&ref_clk>;
-          clock-names = "ref_clk";
-          resets = <&phy_reset>;
-          reset-names = "phy";
-          #phy-cells = <1>;
-    };


