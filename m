Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46EB8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AC1C433EF;
	Tue, 28 Mar 2023 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014716;
	bh=WronW1Tb3XmeLrzWIkcd+D52besNtQNhxc14fYJFvPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvt2cKNesZ6yWp3hCLjwP8/PX91+PohNvvGTmEbmLkgAndHPJLQnLkYamo74E2A6R
	 1LkyQe1B7PmttWEwT8RF29zkAQOdFwQcXB9TDVigqsL01XRo6CCU//sUX4DHus68+I
	 V84VyP6W1PyyeaPl7s4KFuv/FoBJZJIzIIELQXvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 026/240] arm64: dts: imx93: add missing #address-cells and #size-cells to i2c nodes
Date: Tue, 28 Mar 2023 16:39:49 +0200
Message-Id: <20230328142620.722136815@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit b3cdf730486b048ca0bf23bef050550d9fd40422 ]

Add them to the SoC .dtsi, so that not every board has to specify them.

Fixes: 1225396fefea ("arm64: dts: imx93: add lpi2c nodes")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 5d79663b3b84c..d1b34d9db9daf 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -164,6 +164,8 @@ tpm2: pwm@44320000 {
 			lpi2c1: i2c@44340000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44340000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C1_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -174,6 +176,8 @@ lpi2c1: i2c@44340000 {
 			lpi2c2: i2c@44350000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x44350000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C2_GATE>,
 					 <&clk IMX93_CLK_BUS_AON>;
@@ -316,6 +320,8 @@ tpm6: pwm@42510000 {
 			lpi2c3: i2c@42530000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42530000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 62 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C3_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -326,6 +332,8 @@ lpi2c3: i2c@42530000 {
 			lpi2c4: i2c@42540000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x42540000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 63 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C4_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -414,6 +422,8 @@ lpuart8: serial@426a0000 {
 			lpi2c5: i2c@426b0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426b0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 195 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C5_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -424,6 +434,8 @@ lpi2c5: i2c@426b0000 {
 			lpi2c6: i2c@426c0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426c0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C6_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -434,6 +446,8 @@ lpi2c6: i2c@426c0000 {
 			lpi2c7: i2c@426d0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426d0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C7_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
@@ -444,6 +458,8 @@ lpi2c7: i2c@426d0000 {
 			lpi2c8: i2c@426e0000 {
 				compatible = "fsl,imx93-lpi2c", "fsl,imx7ulp-lpi2c";
 				reg = <0x426e0000 0x10000>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX93_CLK_LPI2C8_GATE>,
 					 <&clk IMX93_CLK_BUS_WAKEUP>;
-- 
2.39.2



