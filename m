Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3907012C48F;
	Tue, 30 Apr 2024 10:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473981; cv=none; b=t1fxTTtIZwdETZlxd8qM6bsP/iB/eXgxCUQYmrwkn4odymjfFVe7v6EBqDuasHsgOIWcKKpqas6x8cwW3uqLsBJrW8p7oAOuL4JVjtjJZHu/y2PyK7fbNdSxT8/rzGms9ywZBfiTEsawij0hQVfvRr1mUR2T0AQWo0AMabii7sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473981; c=relaxed/simple;
	bh=QwM+se/v08qPZEG7CymAiTHA1YKmQwhYYFrJwXEc8EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYlhBF64BbkZUMgsFw4LjYgwa5sU7FJiuIATDR06EKh4aBKdqjTCktPQZvjjE2WFl1F1xnqzMrK7+kHeXxGv0fH5xiC3QE3fxI4Yc8X7OQVqkN2JaOmD06rWl6z9TLQb+aoBYgJA2xo5vCPFNTaJo9wf3Yvgj+wZVXfqaPWajWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzpX8Tgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzpX8Tgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE54EC2BBFC;
	Tue, 30 Apr 2024 10:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473981;
	bh=QwM+se/v08qPZEG7CymAiTHA1YKmQwhYYFrJwXEc8EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzpX8TglCxFsZ5ITjoj/UCd760U9zbKDu1vvG9ZwZ2n5OpQw/LqWMSnWT+WW5Y4dF
	 436k3Do2mBZF8KdCgQj4Ba48xW7hoFahLd6Zs6iZS3avR4lV3rWvagrqH3u/rQUpwl
	 jHJpgm4wXdRwXE1colSamb9pyvlyVWUjaph9Q7GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 025/228] arm64: dts: mediatek: mt7986: reorder properties
Date: Tue, 30 Apr 2024 12:36:43 +0200
Message-ID: <20240430103104.540694936@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 7eb133c99fbebc6adb1cbd22c926d42d2bbca648 ]

Use order described as preferred in DTS Coding Style. Mostly just move
"compatible", "reg" and "ranges" properties. In two nodes also move
vendor-prefixed props down.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20240212121620.15035-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Stable-dep-of: 3b449bfd2ff6 ("arm64: dts: mediatek: mt7986: drop invalid properties from ethsys")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 67 ++++++++++++-----------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index d974739eae1c9..eba5e27a1bbea 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -27,34 +27,34 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		cpu0: cpu@0 {
-			device_type = "cpu";
 			compatible = "arm,cortex-a53";
-			enable-method = "psci";
 			reg = <0x0>;
+			device_type = "cpu";
+			enable-method = "psci";
 			#cooling-cells = <2>;
 		};
 
 		cpu1: cpu@1 {
-			device_type = "cpu";
 			compatible = "arm,cortex-a53";
-			enable-method = "psci";
 			reg = <0x1>;
+			device_type = "cpu";
+			enable-method = "psci";
 			#cooling-cells = <2>;
 		};
 
 		cpu2: cpu@2 {
-			device_type = "cpu";
 			compatible = "arm,cortex-a53";
-			enable-method = "psci";
 			reg = <0x2>;
+			device_type = "cpu";
+			enable-method = "psci";
 			#cooling-cells = <2>;
 		};
 
 		cpu3: cpu@3 {
-			device_type = "cpu";
-			enable-method = "psci";
 			compatible = "arm,cortex-a53";
 			reg = <0x3>;
+			device_type = "cpu";
+			enable-method = "psci";
 			#cooling-cells = <2>;
 		};
 	};
@@ -131,22 +131,22 @@
 	};
 
 	soc {
-		#address-cells = <2>;
-		#size-cells = <2>;
 		compatible = "simple-bus";
 		ranges;
+		#address-cells = <2>;
+		#size-cells = <2>;
 
 		gic: interrupt-controller@c000000 {
 			compatible = "arm,gic-v3";
-			#interrupt-cells = <3>;
-			interrupt-parent = <&gic>;
-			interrupt-controller;
 			reg = <0 0x0c000000 0 0x10000>,  /* GICD */
 			      <0 0x0c080000 0 0x80000>,  /* GICR */
 			      <0 0x0c400000 0 0x2000>,   /* GICC */
 			      <0 0x0c410000 0 0x1000>,   /* GICH */
 			      <0 0x0c420000 0 0x2000>;   /* GICV */
+			interrupt-parent = <&gic>;
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-controller;
+			#interrupt-cells = <3>;
 		};
 
 		infracfg: infracfg@10001000 {
@@ -310,9 +310,9 @@
 
 		spi0: spi@1100a000 {
 			compatible = "mediatek,mt7986-spi-ipm", "mediatek,spi-ipm";
+			reg = <0 0x1100a000 0 0x100>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			reg = <0 0x1100a000 0 0x100>;
 			interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&topckgen CLK_TOP_MPLL_D2>,
 				 <&topckgen CLK_TOP_SPI_SEL>,
@@ -324,9 +324,9 @@
 
 		spi1: spi@1100b000 {
 			compatible = "mediatek,mt7986-spi-ipm", "mediatek,spi-ipm";
+			reg = <0 0x1100b000 0 0x100>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			reg = <0 0x1100b000 0 0x100>;
 			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&topckgen CLK_TOP_MPLL_D2>,
 				 <&topckgen CLK_TOP_SPIM_MST_SEL>,
@@ -388,7 +388,6 @@
 		};
 
 		thermal: thermal@1100c800 {
-			#thermal-sensor-cells = <1>;
 			compatible = "mediatek,mt7986-thermal";
 			reg = <0 0x1100c800 0 0x800>;
 			interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
@@ -396,30 +395,30 @@
 				 <&infracfg CLK_INFRA_ADC_26M_CK>,
 				 <&infracfg CLK_INFRA_ADC_FRC_CK>;
 			clock-names = "therm", "auxadc", "adc_32k";
-			mediatek,auxadc = <&auxadc>;
-			mediatek,apmixedsys = <&apmixedsys>;
 			nvmem-cells = <&thermal_calibration>;
 			nvmem-cell-names = "calibration-data";
+			#thermal-sensor-cells = <1>;
+			mediatek,auxadc = <&auxadc>;
+			mediatek,apmixedsys = <&apmixedsys>;
 		};
 
 		pcie: pcie@11280000 {
 			compatible = "mediatek,mt7986-pcie",
 				     "mediatek,mt8192-pcie";
+			reg = <0x00 0x11280000 0x00 0x4000>;
+			reg-names = "pcie-mac";
+			ranges = <0x82000000 0x00 0x20000000 0x00
+				  0x20000000 0x00 0x10000000>;
 			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			reg = <0x00 0x11280000 0x00 0x4000>;
-			reg-names = "pcie-mac";
 			interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
 			bus-range = <0x00 0xff>;
-			ranges = <0x82000000 0x00 0x20000000 0x00
-				  0x20000000 0x00 0x10000000>;
 			clocks = <&infracfg CLK_INFRA_IPCIE_PIPE_CK>,
 				 <&infracfg CLK_INFRA_IPCIE_CK>,
 				 <&infracfg CLK_INFRA_IPCIER_CK>,
 				 <&infracfg CLK_INFRA_IPCIEB_CK>;
 			clock-names = "pl_250m", "tl_26m", "peri_26m", "top_133m";
-			status = "disabled";
 
 			phys = <&pcie_port PHY_TYPE_PCIE>;
 			phy-names = "pcie-phy";
@@ -430,6 +429,8 @@
 					<0 0 0 2 &pcie_intc 1>,
 					<0 0 0 3 &pcie_intc 2>,
 					<0 0 0 4 &pcie_intc 3>;
+			status = "disabled";
+
 			pcie_intc: interrupt-controller {
 				#address-cells = <0>;
 				#interrupt-cells = <1>;
@@ -440,9 +441,9 @@
 		pcie_phy: t-phy {
 			compatible = "mediatek,mt7986-tphy",
 				     "mediatek,generic-tphy-v2";
+			ranges;
 			#address-cells = <2>;
 			#size-cells = <2>;
-			ranges;
 			status = "disabled";
 
 			pcie_port: pcie-phy@11c00000 {
@@ -467,9 +468,9 @@
 		usb_phy: t-phy@11e10000 {
 			compatible = "mediatek,mt7986-tphy",
 				     "mediatek,generic-tphy-v2";
+			ranges = <0 0 0x11e10000 0x1700>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-			ranges = <0 0 0x11e10000 0x1700>;
 			status = "disabled";
 
 			u2port0: usb-phy@0 {
@@ -497,11 +498,11 @@
 		};
 
 		ethsys: syscon@15000000 {
-			 #address-cells = <1>;
-			 #size-cells = <1>;
 			 compatible = "mediatek,mt7986-ethsys",
 				      "syscon";
 			 reg = <0 0x15000000 0 0x1000>;
+			 #address-cells = <1>;
+			 #size-cells = <1>;
 			 #clock-cells = <1>;
 			 #reset-cells = <1>;
 		};
@@ -578,26 +579,26 @@
 					  <&topckgen CLK_TOP_SGM_325M_SEL>;
 			assigned-clock-parents = <&apmixedsys CLK_APMIXED_NET2PLL>,
 						 <&apmixedsys CLK_APMIXED_SGMPLL>;
+			#reset-cells = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
 			mediatek,ethsys = <&ethsys>;
 			mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
 			mediatek,wed-pcie = <&wed_pcie>;
 			mediatek,wed = <&wed0>, <&wed1>;
-			#reset-cells = <1>;
-			#address-cells = <1>;
-			#size-cells = <0>;
 			status = "disabled";
 		};
 
 		wifi: wifi@18000000 {
 			compatible = "mediatek,mt7986-wmac";
+			reg = <0 0x18000000 0 0x1000000>,
+			      <0 0x10003000 0 0x1000>,
+			      <0 0x11d10000 0 0x1000>;
 			resets = <&watchdog MT7986_TOPRGU_CONSYS_SW_RST>;
 			reset-names = "consys";
 			clocks = <&topckgen CLK_TOP_CONN_MCUSYS_SEL>,
 				 <&topckgen CLK_TOP_AP2CNN_HOST_SEL>;
 			clock-names = "mcu", "ap2conn";
-			reg = <0 0x18000000 0 0x1000000>,
-			      <0 0x10003000 0 0x1000>,
-			      <0 0x11d10000 0 0x1000>;
 			interrupts = <GIC_SPI 213 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 214 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



