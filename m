Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D523F424;
	Fri, 23 Jan 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192441; cv=none; b=bqJIInXv20RJSRbssQ6W5tk9/4GtYf6QzJHBybw88nnnLC8Fa10muwOYu0AhkynlttfF17weZF6JPwshCC867VAjaQ+o6186cEKqdOhYKRdkQ0n5F+SpzQNtpo/n8YOaG+gzB6F+Z9VBppmG1v3n1Pco3UjoDtwjSMHD/YxPgns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192441; c=relaxed/simple;
	bh=ZYSm2/Keq/xZr342ARVhDfVvUCWn7TDSKJ0l+IFJlxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2JwXMZlApHZxWY8ayOX45JL8xr/oN5xYVweiLlRcy4Ca0GYlR/t1pDMLDmFCIbsTOMJhEMFtObSmNc5HlHhEEHx942mYIGlegbWhtmWEpLF/0udVICM/pdIkZw0pOTT+iNighps3lTThyn5NLBpNGQFIE7CtmoARdrVUltozOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiWZF/ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiWZF/ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E62C116D0;
	Fri, 23 Jan 2026 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769192441;
	bh=ZYSm2/Keq/xZr342ARVhDfVvUCWn7TDSKJ0l+IFJlxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiWZF/hoAFSTUeRcQSo8r0NDoownP9t5QQflffB+tlDLAAtx/YrxNDyiXY4/Lhxi/
	 8GhGtOfULS7QgRQbHUv0U3rhR04l9/sZeUBJeduLiSudCwplg8CVTtKTyW7cAWLqrt
	 htUO/nIkmM2vZq8qvTFUWg5dHJy9Q+wGr5CrrworTsYBFwyri5ecihuB5V8vGwyTmE
	 qdw+2OhBoTuiYmjIP/JAYb7aw8mehnSLitldEPsaUt2LYiOwk3B+SD30ldRpP9PGhp
	 DRBXFRHKhquIMkgXZQeMcvaGj5CNhKAO8x2xXCokY2an0GFWO5kABEYMP1s12ksjHM
	 WBbZHz0vPlyqw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	=?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>
Subject: [PATCH 01/10] dt-bindings: spmi: Add MediaTek MT8196 SPMI 2 Arbiter/Controllers
Date: Fri, 23 Jan 2026 10:20:29 -0800
Message-ID: <20260123182039.224314-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260123182039.224314-1-sboyd@kernel.org>
References: <20260123182039.224314-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Document the MT8196 SPMI 2.0 Controller with a new schema.
This is a MIPI SPMI 2.0 compliant IP, composed of a main arbiter
and two SPMI master controllers with Request Capable Slave (RCS)
support.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../bindings/spmi/mediatek,mt8196-spmi.yaml   | 138 ++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/mediatek,mt8196-spmi.yaml

diff --git a/Documentation/devicetree/bindings/spmi/mediatek,mt8196-spmi.yaml b/Documentation/devicetree/bindings/spmi/mediatek,mt8196-spmi.yaml
new file mode 100644
index 000000000000..7a534f0a1d87
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/mediatek,mt8196-spmi.yaml
@@ -0,0 +1,138 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/spmi/mediatek,mt8196-spmi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek MT8196 SPMI 2.0 Controller
+
+maintainers:
+  - Hsin-Hsiung Wang <hsin-hsiung.wang@mediatek.com>
+  - AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
+
+description:
+  The MediaTek MT8196 SoC features a SPMI version 2.0 compliant controller,
+  with internal wrapping arbitration logic to allow for multiple on-chip
+  devices to control up to two SPMI buses.
+  The main arbiter also acts as an interrupt controller, arbitering also
+  the interrupts coming from SPMI-connected devices into each of the nested
+  interrupt controllers from any of the present SPMI buses.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - mediatek,mt8196-spmi
+      - items:
+          - enum:
+              - mediatek,mt6991-spmi
+          - const: mediatek,mt8196-spmi
+
+  ranges: true
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 1
+
+patternProperties:
+  "^spmi@[a-f0-9]+$":
+    type: object
+    $ref: /schemas/spmi/spmi.yaml
+    unevaluatedProperties: false
+
+    properties:
+      reg:
+        items:
+          - description: controller interface registers
+          - description: spmi master controller registers
+
+      reg-names:
+        items:
+          - const: pmif
+          - const: spmimst
+
+      clocks:
+        items:
+          - description: controller interface system clock
+          - description: controller interface timer clock
+          - description: spmi controller master clock
+
+      clock-names:
+        items:
+          - const: pmif_sys_ck
+          - const: pmif_tmr_ck
+          - const: spmimst_clk_mux
+
+      interrupts:
+        maxItems: 1
+
+      interrupt-names:
+        const: rcs
+
+      interrupt-controller: true
+
+      "#interrupt-cells":
+        const: 3
+        description: |
+          cell 1: slave ID for the requested interrupt (0-15)
+          cell 2: the requested peripheral interrupt (0-7)
+          cell 3: interrupt flags indicating level-sense information,
+                  as defined in dt-bindings/interrupt-controller/irq.h
+    required:
+      - reg
+      - reg-names
+      - clocks
+      - clock-names
+      - interrupts
+      - interrupt-names
+      - interrupt-controller
+      - "#interrupt-cells"
+
+required:
+  - compatible
+  - ranges
+  - '#address-cells'
+  - '#size-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      spmi-arbiter@1c018000 {
+        compatible = "mediatek,mt8196-spmi";
+        ranges = <0 0 0x1c018000 0x4900>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        spmi@0 {
+          reg = <0 0x900>, <0x4800 0x100>;
+          reg-names = "pmif", "spmimst";
+          interrupts-extended = <&pio 292 IRQ_TYPE_LEVEL_HIGH>;
+          interrupt-names = "rcs";
+          interrupt-controller;
+          #interrupt-cells = <3>;
+          clocks = <&pmif_sys>, <&pmif_tmr>, <&spmi_mst>;
+          clock-names = "pmif_sys_ck", "pmif_tmr_ck", "spmimst_clk_mux";
+        };
+
+        spmi@2000 {
+          reg = <0x2000 0x900>, <0x4000 0x100>;
+          reg-names = "pmif", "spmimst";
+          interrupts-extended = <&pio 291 IRQ_TYPE_LEVEL_HIGH>;
+          interrupt-names = "rcs";
+          interrupt-controller;
+          #interrupt-cells = <3>;
+          clocks = <&pmif_sys>, <&pmif_tmr>, <&spmi_mst>;
+          clock-names = "pmif_sys_ck", "pmif_tmr_ck", "spmimst_clk_mux";
+        };
+      };
+    };
+...
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

