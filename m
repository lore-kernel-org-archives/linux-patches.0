Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A42960252;
	Tue, 23 Jan 2024 00:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970884; cv=none; b=mAvfwxlMEa3G9Ddf3n5S+fHvFK+NX00wBJ3jNMLwzM+kL0T0Rx2tG4KuxKBvzOUc+Xf9P4p8BQVr1usVoZ5bDDqNUCt1uKsMJCYD7q5g2imt4sSGRNbREb2rLxYewnlORty591c0jDVSpXiSsmFXH2nngDiUAKcIqgYfBdNxwII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970884; c=relaxed/simple;
	bh=8NIJ5lbDWAYdiNJhVTN3RBDUKv7pv9nEvJiTbqoyCyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deK+x8JoDJZmHthYMoWfPyKMA4OFNzAqg1T1V/NPjrhlcCV9mvKsQ/PCGq41ppKRbQ6Hpp3bcUOvS62dHgNZ4rzYdswd5iHJvNYT3fyGNGc6TIw1CYrmgjWP9I9TwlWQ0lzGwUdNnpGfW5aoBBOy0lmXtw5Hg8wN8q3u9yg1VQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9ebpWWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9ebpWWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB13CC43394;
	Tue, 23 Jan 2024 00:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970883;
	bh=8NIJ5lbDWAYdiNJhVTN3RBDUKv7pv9nEvJiTbqoyCyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9ebpWWVwLmnIH2OxnfouhlMMwfzG3FUPmbzap59peudTdbPGV5IRYeN1wEysGG1x
	 cv06MYBj0YjE2yqAtBef+8THbeVkBWSEylQKXDk0GlqlucZw6Wttt8RT5Ek849GXZT
	 UU11J3WA2DCdkFyCz25O4tdwP5rMeWXLH3qLhwD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/417] arm64: dts: qcom: ipq6018: Fix up indentation
Date: Mon, 22 Jan 2024 15:55:00 -0800
Message-ID: <20240122235756.394875172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit c2596b717e9d96ae57c45481acfbafe9d3d54e56 ]

The dwc3 subnode was indented using spaces for some reason and other
properties were not exactly properly indented. Fix it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230102094642.74254-3-konrad.dybcio@linaro.org
Stable-dep-of: 5c0dbe8b0584 ("arm64: dts: qcom: ipq6018: fix clock rates for GCC_USB0_MOCK_UTMI_CLK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 44 +++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 43a948b64007..1533c61cb106 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -201,8 +201,8 @@ crypto: crypto@73a000 {
 			compatible = "qcom,crypto-v5.1";
 			reg = <0x0 0x0073a000 0x0 0x6000>;
 			clocks = <&gcc GCC_CRYPTO_AHB_CLK>,
-				<&gcc GCC_CRYPTO_AXI_CLK>,
-				<&gcc GCC_CRYPTO_CLK>;
+				 <&gcc GCC_CRYPTO_AXI_CLK>,
+				 <&gcc GCC_CRYPTO_CLK>;
 			clock-names = "iface", "bus", "core";
 			dmas = <&cryptobam 2>, <&cryptobam 3>;
 			dma-names = "rx", "tx";
@@ -272,7 +272,7 @@ blsp1_uart3: serial@78b1000 {
 			reg = <0x0 0x078b1000 0x0 0x200>;
 			interrupts = <GIC_SPI 306 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&gcc GCC_BLSP1_UART3_APPS_CLK>,
-				<&gcc GCC_BLSP1_AHB_CLK>;
+				 <&gcc GCC_BLSP1_AHB_CLK>;
 			clock-names = "core", "iface";
 			status = "disabled";
 		};
@@ -285,7 +285,7 @@ blsp1_spi1: spi@78b5000 {
 			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
 			spi-max-frequency = <50000000>;
 			clocks = <&gcc GCC_BLSP1_QUP1_SPI_APPS_CLK>,
-				<&gcc GCC_BLSP1_AHB_CLK>;
+				 <&gcc GCC_BLSP1_AHB_CLK>;
 			clock-names = "core", "iface";
 			dmas = <&blsp_dma 12>, <&blsp_dma 13>;
 			dma-names = "tx", "rx";
@@ -300,7 +300,7 @@ blsp1_spi2: spi@78b6000 {
 			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 			spi-max-frequency = <50000000>;
 			clocks = <&gcc GCC_BLSP1_QUP2_SPI_APPS_CLK>,
-				<&gcc GCC_BLSP1_AHB_CLK>;
+				 <&gcc GCC_BLSP1_AHB_CLK>;
 			clock-names = "core", "iface";
 			dmas = <&blsp_dma 14>, <&blsp_dma 15>;
 			dma-names = "tx", "rx";
@@ -358,8 +358,8 @@ qpic_nand: nand@79b0000 {
 			clock-names = "core", "aon";
 
 			dmas = <&qpic_bam 0>,
-				<&qpic_bam 1>,
-				<&qpic_bam 2>;
+			       <&qpic_bam 1>,
+			       <&qpic_bam 2>;
 			dma-names = "tx", "rx", "cmd";
 			pinctrl-0 = <&qpic_pins>;
 			pinctrl-names = "default";
@@ -372,10 +372,10 @@ intc: interrupt-controller@b000000 {
 			#size-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <0x3>;
-			reg =   <0x0 0x0b000000 0x0 0x1000>,  /*GICD*/
-				<0x0 0x0b002000 0x0 0x1000>,  /*GICC*/
-				<0x0 0x0b001000 0x0 0x1000>,  /*GICH*/
-				<0x0 0x0b004000 0x0 0x1000>;  /*GICV*/
+			reg = <0x0 0x0b000000 0x0 0x1000>,  /*GICD*/
+			      <0x0 0x0b002000 0x0 0x1000>,  /*GICC*/
+			      <0x0 0x0b001000 0x0 0x1000>,  /*GICH*/
+			      <0x0 0x0b004000 0x0 0x1000>;  /*GICV*/
 			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 			ranges = <0 0 0 0xb00a000 0 0xffd>;
 
@@ -669,17 +669,17 @@ usb2: usb@70f8800 {
 			status = "disabled";
 
 			dwc_1: usb@7000000 {
-			       compatible = "snps,dwc3";
-			       reg = <0x0 0x07000000 0x0 0xcd00>;
-			       interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
-			       phys = <&qusb_phy_1>;
-			       phy-names = "usb2-phy";
-			       tx-fifo-resize;
-			       snps,is-utmi-l1-suspend;
-			       snps,hird-threshold = /bits/ 8 <0x0>;
-			       snps,dis_u2_susphy_quirk;
-			       snps,dis_u3_susphy_quirk;
-			       dr_mode = "host";
+				compatible = "snps,dwc3";
+				reg = <0x0 0x07000000 0x0 0xcd00>;
+				interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
+				phys = <&qusb_phy_1>;
+				phy-names = "usb2-phy";
+				tx-fifo-resize;
+				snps,is-utmi-l1-suspend;
+				snps,hird-threshold = /bits/ 8 <0x0>;
+				snps,dis_u2_susphy_quirk;
+				snps,dis_u3_susphy_quirk;
+				dr_mode = "host";
 			};
 		};
 
-- 
2.43.0



