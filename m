Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7662A2940D;
	Tue, 30 Apr 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473990; cv=none; b=jAHZGq4CYpmddF8Y7hzgYICl5iAxayjyGpnCiXIBMKSnLVGi+oc4UlGnGWoVZxHtMEPtxO8qP/jlcQFIWMnWZwYxYpy9878EKThjHMknzMzVbyD/dDqfTvuYDzG5hzTkuCRfkHw9ZcKt/4oTHVA6hRHsJO+StAoGQcFlJ5Fg7Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473990; c=relaxed/simple;
	bh=qtREh92M47BeChGUVky6ZEE/vt8bHxZsGM6dpJjIrqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHcntpXFJdknk5Hpu+bjFiKT7fmkT2xSNA0vH0X7gfVgxck0mfxiZ6fqfIKTqBbWn89AVNRIg7gOcjMvYHojJun5mPRUim05HmQ0FWVYo2GOzZJ62sUPYHXv9DuoxamE/XSGHI9Ka76uEHQkjBfgia3yWMpNVVm66K1cLXVuDPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpV9+5nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpV9+5nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFD9C2BBFC;
	Tue, 30 Apr 2024 10:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473990;
	bh=qtREh92M47BeChGUVky6ZEE/vt8bHxZsGM6dpJjIrqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpV9+5nf2grWJXZWRPrxSko2CnYhvqOrQKtGbKzR8qVtSIadtzCr+1qWbjAtnHRBP
	 yZRIShAOAM0PMFl8Q1zk1OdAG/XcAei6P3M/Sb77giNnY1PDxKsZwfP3OW6l/4Huj7
	 +hz2cmhGfeXf23e5MtXHmUqJTJZpUneUBkKF3rTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 028/228] arm64: dts: mediatek: mt7986: reorder nodes
Date: Tue, 30 Apr 2024 12:36:46 +0200
Message-ID: <20240430103104.626333344@linuxfoundation.org>
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

[ Upstream commit 3f79e8f3364499750d7442767b101b7bc5864ddf ]

Use order described as preferred in DTS Coding Style:
1. Sort bus nodes by unit address
2. Use alpha-numerical order for the rest

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20240212121620.15035-2-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Stable-dep-of: 970f8b01bd77 ("arm64: dts: mediatek: mt7986: drop invalid thermal block clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 116 +++++++++++-----------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 5c2fe2f43a142..f3a2a89fada41 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -16,13 +16,6 @@
 	#address-cells = <2>;
 	#size-cells = <2>;
 
-	clk40m: oscillator-40m {
-		compatible = "fixed-clock";
-		clock-frequency = <40000000>;
-		#clock-cells = <0>;
-		clock-output-names = "clkxtal";
-	};
-
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -59,6 +52,13 @@
 		};
 	};
 
+	clk40m: oscillator-40m {
+		compatible = "fixed-clock";
+		clock-frequency = <40000000>;
+		#clock-cells = <0>;
+		clock-output-names = "clkxtal";
+	};
+
 	psci {
 		compatible = "arm,psci-0.2";
 		method = "smc";
@@ -121,15 +121,6 @@
 
 	};
 
-	timer {
-		compatible = "arm,armv8-timer";
-		interrupt-parent = <&gic>;
-		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
-	};
-
 	soc {
 		compatible = "simple-bus";
 		ranges;
@@ -203,6 +194,19 @@
 			#interrupt-cells = <2>;
 		};
 
+		pwm: pwm@10048000 {
+			compatible = "mediatek,mt7986-pwm";
+			reg = <0 0x10048000 0 0x1000>;
+			#pwm-cells = <2>;
+			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&topckgen CLK_TOP_PWM_SEL>,
+				 <&infracfg CLK_INFRA_PWM_STA>,
+				 <&infracfg CLK_INFRA_PWM1_CK>,
+				 <&infracfg CLK_INFRA_PWM2_CK>;
+			clock-names = "top", "main", "pwm1", "pwm2";
+			status = "disabled";
+		};
+
 		sgmiisys0: syscon@10060000 {
 			compatible = "mediatek,mt7986-sgmiisys_0",
 				     "syscon";
@@ -240,19 +244,6 @@
 			status = "disabled";
 		};
 
-		pwm: pwm@10048000 {
-			compatible = "mediatek,mt7986-pwm";
-			reg = <0 0x10048000 0 0x1000>;
-			#pwm-cells = <2>;
-			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&topckgen CLK_TOP_PWM_SEL>,
-				 <&infracfg CLK_INFRA_PWM_STA>,
-				 <&infracfg CLK_INFRA_PWM1_CK>,
-				 <&infracfg CLK_INFRA_PWM2_CK>;
-			clock-names = "top", "main", "pwm1", "pwm2";
-			status = "disabled";
-		};
-
 		uart0: serial@11002000 {
 			compatible = "mediatek,mt7986-uart",
 				     "mediatek,mt6577-uart";
@@ -336,6 +327,21 @@
 			status = "disabled";
 		};
 
+		thermal: thermal@1100c800 {
+			compatible = "mediatek,mt7986-thermal";
+			reg = <0 0x1100c800 0 0x800>;
+			interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&infracfg CLK_INFRA_THERM_CK>,
+				 <&infracfg CLK_INFRA_ADC_26M_CK>,
+				 <&infracfg CLK_INFRA_ADC_FRC_CK>;
+			clock-names = "therm", "auxadc", "adc_32k";
+			nvmem-cells = <&thermal_calibration>;
+			nvmem-cell-names = "calibration-data";
+			#thermal-sensor-cells = <1>;
+			mediatek,auxadc = <&auxadc>;
+			mediatek,apmixedsys = <&apmixedsys>;
+		};
+
 		auxadc: adc@1100d000 {
 			compatible = "mediatek,mt7986-auxadc";
 			reg = <0 0x1100d000 0 0x1000>;
@@ -387,21 +393,6 @@
 			status = "disabled";
 		};
 
-		thermal: thermal@1100c800 {
-			compatible = "mediatek,mt7986-thermal";
-			reg = <0 0x1100c800 0 0x800>;
-			interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&infracfg CLK_INFRA_THERM_CK>,
-				 <&infracfg CLK_INFRA_ADC_26M_CK>,
-				 <&infracfg CLK_INFRA_ADC_FRC_CK>;
-			clock-names = "therm", "auxadc", "adc_32k";
-			nvmem-cells = <&thermal_calibration>;
-			nvmem-cell-names = "calibration-data";
-			#thermal-sensor-cells = <1>;
-			mediatek,auxadc = <&auxadc>;
-			mediatek,apmixedsys = <&apmixedsys>;
-		};
-
 		pcie: pcie@11280000 {
 			compatible = "mediatek,mt7986-pcie",
 				     "mediatek,mt8192-pcie";
@@ -531,20 +522,6 @@
 			mediatek,wo-ccif = <&wo_ccif1>;
 		};
 
-		wo_ccif0: syscon@151a5000 {
-			compatible = "mediatek,mt7986-wo-ccif", "syscon";
-			reg = <0 0x151a5000 0 0x1000>;
-			interrupt-parent = <&gic>;
-			interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
-		};
-
-		wo_ccif1: syscon@151ad000 {
-			compatible = "mediatek,mt7986-wo-ccif", "syscon";
-			reg = <0 0x151ad000 0 0x1000>;
-			interrupt-parent = <&gic>;
-			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
-		};
-
 		eth: ethernet@15100000 {
 			compatible = "mediatek,mt7986-eth";
 			reg = <0 0x15100000 0 0x80000>;
@@ -586,6 +563,20 @@
 			status = "disabled";
 		};
 
+		wo_ccif0: syscon@151a5000 {
+			compatible = "mediatek,mt7986-wo-ccif", "syscon";
+			reg = <0 0x151a5000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		wo_ccif1: syscon@151ad000 {
+			compatible = "mediatek,mt7986-wo-ccif", "syscon";
+			reg = <0 0x151ad000 0 0x1000>;
+			interrupt-parent = <&gic>;
+			interrupts = <GIC_SPI 212 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		wifi: wifi@18000000 {
 			compatible = "mediatek,mt7986-wmac";
 			reg = <0 0x18000000 0 0x1000000>,
@@ -643,4 +634,13 @@
 			};
 		};
 	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
+			     <GIC_PPI 10 IRQ_TYPE_LEVEL_LOW>;
+	};
 };
-- 
2.43.0



