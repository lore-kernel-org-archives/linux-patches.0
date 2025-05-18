Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0231F4CA2;
	Sun, 18 May 2025 03:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747538613; cv=none; b=Vp4yz18eyMWJef3WKoahWOy2w8U6iDmT954y5Xs97B2d8bo6UwpI97xmptk8zJo+r1VECu1+/R/husT1QAfDFKC2/giHVXSR878r0q64641kGUEKpdMrwmIUo9Dv+7Wb19niYyntFxXlKmAO02KSH3GcRJX//EcVtIikF+uC01w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747538613; c=relaxed/simple;
	bh=y4qZ5PgPqfrqLauHxeiDUnntRxq6bNaPzr7H+iuk3FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9YmIFY0K0bSvAnZwys2xG827EA3fTiUXUIFRtAqFG5Fy0R0nRVXBf7PeHbEq4SM92nHfqezadvY8xELlfSRBcF0pvPPpt2KeEnfNs2ODQc1gkEHI9YvCE6dIJ9DEUORGdHWUi5GkLXgfwLoomrA1uyOL+9l1eSnlAZXz+sRfY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMjq/M+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMjq/M+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA13C4CEED;
	Sun, 18 May 2025 03:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747538612;
	bh=y4qZ5PgPqfrqLauHxeiDUnntRxq6bNaPzr7H+iuk3FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMjq/M+zgjJh0u4ldT2Iv6c3hjeuGG4+lfwwSBd8kfKNEK00sBnbZv/u6/zsnM6Mj
	 EDmitq03HDbf32b3c/Y17AVMyi1OK8jPn06YZjyQcf+hhsmMhfQDnGye8IzZJ1PyiJ
	 UWLPt/wlL1mi2CgLQDKSGDKWI4dPcbO2Iq5oKkawEc/Z/h4lqzczuCBB1fLtJTzEa+
	 axx2t09eHFZDhVnXuvHBF+V1NA0GPibIa9twgAhNnxeVRA2jdrvgoxsNwcBouIMIjC
	 smuyWOiXApBJm3ypt8zboTmkhTZ0ooJeUCzbpK2CIXkRKHswoPI0lsi30ifi0Tb9Hm
	 onLbIrBhWbbMA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Finkelstein <fnkl.kernel@gmail.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sven Peter <sven@svenpeter.dev>,
	Neal Gompa <neal@gompa.dev>
Subject: [PATCH 2/4] dt-bindings: spmi: Add Apple SPMI controller
Date: Sat, 17 May 2025 20:23:27 -0700
Message-ID: <20250518032330.2959766-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
In-Reply-To: <20250518032330.2959766-1-sboyd@kernel.org>
References: <20250518032330.2959766-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sasha Finkelstein <fnkl.kernel@gmail.com>

Add bindings for the SPMI controller present on most Apple SoCs

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Link: https://lore.kernel.org/r/20250409-spmi-v4-1-eb81ecfd1f64@gmail.com
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../devicetree/bindings/spmi/apple,spmi.yaml  | 49 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/apple,spmi.yaml

diff --git a/Documentation/devicetree/bindings/spmi/apple,spmi.yaml b/Documentation/devicetree/bindings/spmi/apple,spmi.yaml
new file mode 100644
index 000000000000..16bd7eb2b7af
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/apple,spmi.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/spmi/apple,spmi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Apple SPMI controller
+
+maintainers:
+  - Sasha Finkelstein <fnkl.kernel@gmail.com>
+
+description: A SPMI controller present on most Apple SoCs
+
+allOf:
+  - $ref: spmi.yaml#
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - apple,t8103-spmi
+          - apple,t6000-spmi
+          - apple,t8112-spmi
+      - const: apple,spmi
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/spmi/spmi.h>
+
+    spmi@920a1300 {
+        compatible = "apple,t6000-spmi", "apple,spmi";
+        reg = <0x920a1300 0x100>;
+        #address-cells = <2>;
+        #size-cells = <0>;
+
+        pmic@f {
+            reg = <0xf SPMI_USID>;
+            /* PMIC-specific properties */
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 96b827049501..5f348736ea0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2282,6 +2282,7 @@ F:	Documentation/devicetree/bindings/pinctrl/apple,pinctrl.yaml
 F:	Documentation/devicetree/bindings/power/apple*
 F:	Documentation/devicetree/bindings/pwm/apple,s5l-fpwm.yaml
 F:	Documentation/devicetree/bindings/spi/apple,spi.yaml
+F:	Documentation/devicetree/bindings/spmi/apple,spmi.yaml
 F:	Documentation/devicetree/bindings/watchdog/apple,wdt.yaml
 F:	arch/arm64/boot/dts/apple/
 F:	drivers/bluetooth/hci_bcm4377.c
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

