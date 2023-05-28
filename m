Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB028611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A890C433EF;
	Sun, 28 May 2023 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303268;
	bh=Hl1H2rFRCSg+hV/GRj5sIFexry/BrLLp28dRit4/m3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGiJ0f3lumDxcwFmrLM5CXLEHRHp3lqBeU3KtJ4+LhhI6XJocYPBwVkjCKkHHV2uf
	 Ia7lkRgqRbkFD3Fnv80cuBgFEN8uYDWrPsNc2+dxV04NsCFNEKO96KNrQjYH116Hp0
	 Udv73ZscptYSBGAOwtQJs/ccdKgh4MmqohzvDy34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piyush Mehta <piyush.mehta@xilinx.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/69] dt-bindings: ata: ahci-ceva: convert to yaml
Date: Sun, 28 May 2023 20:11:23 +0100
Message-Id: <20230528190828.468441436@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Piyush Mehta <piyush.mehta@xilinx.com>

[ Upstream commit f2fb1b50fbac4a0a462e1705ac913abf52aae906 ]

Convert the ahci-ceva doc to yaml.

Signed-off-by: Piyush Mehta <piyush.mehta@xilinx.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220620073717.3079-1-piyush.mehta@xilinx.com
Stable-dep-of: a78445287226 ("dt-bindings: ata: ahci-ceva: Cover all 4 iommus entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/ata/ahci-ceva.txt     |  63 ------
 .../bindings/ata/ceva,ahci-1v84.yaml          | 189 ++++++++++++++++++
 2 files changed, 189 insertions(+), 63 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ata/ahci-ceva.txt
 create mode 100644 Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml

diff --git a/Documentation/devicetree/bindings/ata/ahci-ceva.txt b/Documentation/devicetree/bindings/ata/ahci-ceva.txt
deleted file mode 100644
index bfb6da0281ecd..0000000000000
--- a/Documentation/devicetree/bindings/ata/ahci-ceva.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-Binding for CEVA AHCI SATA Controller
-
-Required properties:
-  - reg: Physical base address and size of the controller's register area.
-  - compatible: Compatibility string. Must be 'ceva,ahci-1v84'.
-  - clocks: Input clock specifier. Refer to common clock bindings.
-  - interrupts: Interrupt specifier. Refer to interrupt binding.
-  - ceva,p0-cominit-params: OOB timing value for COMINIT parameter for port 0.
-  - ceva,p1-cominit-params: OOB timing value for COMINIT parameter for port 1.
-			The fields for the above parameter must be as shown below:
-			ceva,pN-cominit-params = /bits/ 8 <CIBGMN CIBGMX CIBGN CINMP>;
-			CINMP : COMINIT Negate Minimum Period.
-			CIBGN : COMINIT Burst Gap Nominal.
-			CIBGMX: COMINIT Burst Gap Maximum.
-			CIBGMN: COMINIT Burst Gap Minimum.
-  - ceva,p0-comwake-params: OOB timing value for COMWAKE parameter for port 0.
-  - ceva,p1-comwake-params: OOB timing value for COMWAKE parameter for port 1.
-			The fields for the above parameter must be as shown below:
-			ceva,pN-comwake-params = /bits/ 8 <CWBGMN CWBGMX CWBGN CWNMP>;
-			CWBGMN: COMWAKE Burst Gap Minimum.
-			CWBGMX: COMWAKE Burst Gap Maximum.
-			CWBGN: COMWAKE Burst Gap Nominal.
-			CWNMP: COMWAKE Negate Minimum Period.
-  - ceva,p0-burst-params: Burst timing value for COM parameter for port 0.
-  - ceva,p1-burst-params: Burst timing value for COM parameter for port 1.
-			The fields for the above parameter must be as shown below:
-			ceva,pN-burst-params = /bits/ 8 <BMX BNM SFD PTST>;
-			BMX: COM Burst Maximum.
-			BNM: COM Burst Nominal.
-			SFD: Signal Failure Detection value.
-			PTST: Partial to Slumber timer value.
-  - ceva,p0-retry-params: Retry interval timing value for port 0.
-  - ceva,p1-retry-params: Retry interval timing value for port 1.
-			The fields for the above parameter must be as shown below:
-			ceva,pN-retry-params = /bits/ 16 <RIT RCT>;
-			RIT:  Retry Interval Timer.
-			RCT:  Rate Change Timer.
-
-Optional properties:
-  - ceva,broken-gen2: limit to gen1 speed instead of gen2.
-  - phys: phandle for the PHY device
-  - resets: phandle to the reset controller for the SATA IP
-
-Examples:
-	ahci@fd0c0000 {
-		compatible = "ceva,ahci-1v84";
-		reg = <0xfd0c0000 0x200>;
-		interrupt-parent = <&gic>;
-		interrupts = <0 133 4>;
-		clocks = <&clkc SATA_CLK_ID>;
-		ceva,p0-cominit-params = /bits/ 8 <0x0F 0x25 0x18 0x29>;
-		ceva,p0-comwake-params = /bits/ 8 <0x04 0x0B 0x08 0x0F>;
-		ceva,p0-burst-params = /bits/ 8 <0x0A 0x08 0x4A 0x06>;
-		ceva,p0-retry-params = /bits/ 16 <0x0216 0x7F06>;
-
-		ceva,p1-cominit-params = /bits/ 8 <0x0F 0x25 0x18 0x29>;
-		ceva,p1-comwake-params = /bits/ 8 <0x04 0x0B 0x08 0x0F>;
-		ceva,p1-burst-params = /bits/ 8 <0x0A 0x08 0x4A 0x06>;
-		ceva,p1-retry-params = /bits/ 16 <0x0216 0x7F06>;
-		ceva,broken-gen2;
-		phys = <&psgtr 1 PHY_TYPE_SATA 1 1>;
-		resets = <&zynqmp_reset ZYNQMP_RESET_SATA>;
-	};
diff --git a/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml b/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
new file mode 100644
index 0000000000000..9b31f864e071e
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
@@ -0,0 +1,189 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ata/ceva,ahci-1v84.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ceva AHCI SATA Controller
+
+maintainers:
+  - Piyush Mehta <piyush.mehta@xilinx.com>
+
+description: |
+  The Ceva SATA controller mostly conforms to the AHCI interface with some
+  special extensions to add functionality, is a high-performance dual-port
+  SATA host controller with an AHCI compliant command layer which supports
+  advanced features such as native command queuing and frame information
+  structure (FIS) based switching for systems employing port multipliers.
+
+properties:
+  compatible:
+    const: ceva,ahci-1v84
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  dma-coherent: true
+
+  interrupts:
+    maxItems: 1
+
+  iommus:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  ceva,p0-cominit-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      OOB timing value for COMINIT parameter for port 0.
+      The fields for the above parameter must be as shown below:-
+      ceva,p0-cominit-params = /bits/ 8 <CIBGMN CIBGMX CIBGN CINMP>;
+    items:
+      - description: CINMP - COMINIT Negate Minimum Period.
+      - description: CIBGN - COMINIT Burst Gap Nominal.
+      - description: CIBGMX - COMINIT Burst Gap Maximum.
+      - description: CIBGMN - COMINIT Burst Gap Minimum.
+
+  ceva,p0-comwake-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      OOB timing value for COMWAKE parameter for port 0.
+      The fields for the above parameter must be as shown below:-
+      ceva,p0-comwake-params = /bits/ 8 <CWBGMN CWBGMX CWBGN CWNMP>;
+    items:
+      - description: CWBGMN - COMWAKE Burst Gap Minimum.
+      - description: CWBGMX - COMWAKE Burst Gap Maximum.
+      - description: CWBGN - COMWAKE Burst Gap Nominal.
+      - description: CWNMP - COMWAKE Negate Minimum Period.
+
+  ceva,p0-burst-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      Burst timing value for COM parameter for port 0.
+      The fields for the above parameter must be as shown below:-
+      ceva,p0-burst-params = /bits/ 8 <BMX BNM SFD PTST>;
+    items:
+      - description: BMX - COM Burst Maximum.
+      - description: BNM - COM Burst Nominal.
+      - description: SFD - Signal Failure Detection value.
+      - description: PTST - Partial to Slumber timer value.
+
+  ceva,p0-retry-params:
+    $ref: /schemas/types.yaml#/definitions/uint16-array
+    description: |
+      Retry interval timing value for port 0.
+      The fields for the above parameter must be as shown below:-
+      ceva,p0-retry-params = /bits/ 16 <RIT RCT>;
+    items:
+      - description: RIT - Retry Interval Timer.
+      - description: RCT - Rate Change Timer.
+
+  ceva,p1-cominit-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      OOB timing value for COMINIT parameter for port 1.
+      The fields for the above parameter must be as shown below:-
+      ceva,p1-cominit-params = /bits/ 8 <CIBGMN CIBGMX CIBGN CINMP>;
+    items:
+      - description: CINMP - COMINIT Negate Minimum Period.
+      - description: CIBGN - COMINIT Burst Gap Nominal.
+      - description: CIBGMX - COMINIT Burst Gap Maximum.
+      - description: CIBGMN - COMINIT Burst Gap Minimum.
+
+  ceva,p1-comwake-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      OOB timing value for COMWAKE parameter for port 1.
+      The fields for the above parameter must be as shown below:-
+      ceva,p1-comwake-params = /bits/ 8 <CWBGMN CWBGMX CWBGN CWNMP>;
+    items:
+      - description: CWBGMN - COMWAKE Burst Gap Minimum.
+      - description: CWBGMX - COMWAKE Burst Gap Maximum.
+      - description: CWBGN - COMWAKE Burst Gap Nominal.
+      - description: CWNMP - COMWAKE Negate Minimum Period.
+
+  ceva,p1-burst-params:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: |
+      Burst timing value for COM parameter for port 1.
+      The fields for the above parameter must be as shown below:-
+      ceva,p1-burst-params = /bits/ 8 <BMX BNM SFD PTST>;
+    items:
+      - description: BMX - COM Burst Maximum.
+      - description: BNM - COM Burst Nominal.
+      - description: SFD - Signal Failure Detection value.
+      - description: PTST - Partial to Slumber timer value.
+
+  ceva,p1-retry-params:
+    $ref: /schemas/types.yaml#/definitions/uint16-array
+    description: |
+      Retry interval timing value for port 1.
+      The fields for the above parameter must be as shown below:-
+      ceva,pN-retry-params = /bits/ 16 <RIT RCT>;
+    items:
+      - description: RIT - Retry Interval Timer.
+      - description: RCT - Rate Change Timer.
+
+  ceva,broken-gen2:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description: |
+      limit to gen1 speed instead of gen2.
+
+  phys:
+    maxItems: 1
+
+  phy-names:
+    items:
+      - const: sata-phy
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+  - ceva,p0-cominit-params
+  - ceva,p0-comwake-params
+  - ceva,p0-burst-params
+  - ceva,p0-retry-params
+  - ceva,p1-cominit-params
+  - ceva,p1-comwake-params
+  - ceva,p1-burst-params
+  - ceva,p1-retry-params
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/power/xlnx-zynqmp-power.h>
+    #include <dt-bindings/reset/xlnx-zynqmp-resets.h>
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+    #include <dt-bindings/phy/phy.h>
+
+    sata: ahci@fd0c0000 {
+        compatible = "ceva,ahci-1v84";
+        reg = <0xfd0c0000 0x200>;
+        interrupt-parent = <&gic>;
+        interrupts = <0 133 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&zynqmp_clk SATA_REF>;
+        ceva,p0-cominit-params = /bits/ 8 <0x0F 0x25 0x18 0x29>;
+        ceva,p0-comwake-params = /bits/ 8 <0x04 0x0B 0x08 0x0F>;
+        ceva,p0-burst-params = /bits/ 8 <0x0A 0x08 0x4A 0x06>;
+        ceva,p0-retry-params = /bits/ 16 <0x0216 0x7F06>;
+        ceva,p1-cominit-params = /bits/ 8 <0x0F 0x25 0x18 0x29>;
+        ceva,p1-comwake-params = /bits/ 8 <0x04 0x0B 0x08 0x0F>;
+        ceva,p1-burst-params = /bits/ 8 <0x0A 0x08 0x4A 0x06>;
+        ceva,p1-retry-params = /bits/ 16 <0x0216 0x7F06>;
+        ceva,broken-gen2;
+        phys = <&psgtr 1 PHY_TYPE_SATA 1 1>;
+        resets = <&zynqmp_reset ZYNQMP_RESET_SATA>;
+    };
-- 
2.39.2



