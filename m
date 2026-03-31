Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C54423A9A;
	Tue, 31 Mar 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976078; cv=none; b=b7/tnsLxKb2grC2za6asU5r5Vt6smnxANkanZVEPNw40ZluU1nw1PIGmqpHf3HqS9GNMuV4jJWBvvipGzBiEPqolqUE6g1vLA4ud8IO/RmNCzhm2xjGeMtyCSTRDjc1GMHywvgEobnT9yeyaCaWivOk2P0ts7arpQ8JjTiQWPds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976078; c=relaxed/simple;
	bh=U5/uwpCb48VVSVTx2YMsFtAPRYkcJ4siQsCDXQ3K1jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SESiR8GoM0bhtxICDzm7m1XNb+96+rCumbuFR8ookfT9PkqgdltEb25bnHi15DxiSID684+pvd4f2Jxaj/4YgMSfc/1q4qZbUvkHQJuSbe6jyQeVe1c6rpgbPtUHil4+GSn6nYlH+08BJmLULcRZpiYoM4xmBePwlr3vjU1e6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gORyNLfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gORyNLfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E54C19423;
	Tue, 31 Mar 2026 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976078;
	bh=U5/uwpCb48VVSVTx2YMsFtAPRYkcJ4siQsCDXQ3K1jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gORyNLfBVFh2OsTAslpf0VHmMpEwydKqkVEyxe8XcY/QPGnKgklyrxYrIEF9lqye6
	 v3qErQxNGWZZtHfFU9oCJwFOEcMY3yT8nE9hS1cJ3QnMedNIwqTgnrM01PL93GDW2M
	 RbLfbErfAYn8UtabcNxnH7WudT8CV9zszUmtOGPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 198/244] arm64: dts: imx8mn-tqma8mqnl: fix LDO5 power off
Date: Tue, 31 Mar 2026 18:22:28 +0200
Message-ID: <20260331161749.061687306@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

commit 8adc841d43ebceabec996c9dcff6e82d3e585268 upstream.

Fix SD card removal caused by automatic LDO5 power off after boot

To prevent this, add vqmmc regulator for USDHC, using a GPIO-controlled
regulator that is supplied by LDO5. Since this is implemented on SoM but
used on baseboards with SD-card interface, implement the functionality
on SoM part and optionally enable it on baseboards if needed.

Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts |   13 ++++----
 arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi       |   22 ++++++++++++++
 2 files changed, 29 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts
@@ -64,6 +64,10 @@
 	};
 };
 
+&reg_usdhc2_vqmmc {
+	status = "okay";
+};
+
 &sai3 {
 	assigned-clocks = <&clk IMX8MN_CLK_SAI3>;
 	assigned-clock-parents = <&clk IMX8MN_AUDIO_PLL1_OUT>;
@@ -207,8 +211,7 @@
 			   <MX8MN_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4>,
-			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>,
-			   <MX8MN_IOMUXC_GPIO1_IO04_USDHC2_VSELECT	0x84>;
+			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>;
 	};
 
 	pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
@@ -217,8 +220,7 @@
 			   <MX8MN_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4>,
-			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>,
-			   <MX8MN_IOMUXC_GPIO1_IO04_USDHC2_VSELECT	0x84>;
+			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>;
 	};
 
 	pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
@@ -227,8 +229,7 @@
 			   <MX8MN_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA1_USDHC2_DATA1		0x1d4>,
 			   <MX8MN_IOMUXC_SD2_DATA2_USDHC2_DATA2		0x1d4>,
-			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>,
-			   <MX8MN_IOMUXC_GPIO1_IO04_USDHC2_VSELECT	0x84>;
+			   <MX8MN_IOMUXC_SD2_DATA3_USDHC2_DATA3		0x1d4>;
 	};
 
 	pinctrl_usdhc2_gpio: usdhc2-gpiogrp {
--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
@@ -30,6 +30,20 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
+	reg_usdhc2_vqmmc: regulator-usdhc2-vqmmc {
+		compatible = "regulator-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_usdhc2_vqmmc>;
+		regulator-name = "V_SD2";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <3300000>;
+		gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
+		vin-supply = <&ldo5_reg>;
+		status = "disabled";
+	};
+
 	reserved-memory {
 		#address-cells = <2>;
 		#size-cells = <2>;
@@ -228,6 +242,10 @@
 	vddio-supply = <&ldo3_reg>;
 };
 
+&usdhc2 {
+	vqmmc-supply = <&reg_usdhc2_vqmmc>;
+};
+
 &usdhc3 {
 	pinctrl-names = "default", "state_100mhz", "state_200mhz";
 	pinctrl-0 = <&pinctrl_usdhc3>;
@@ -282,6 +300,10 @@
 		fsl,pins = <MX8MN_IOMUXC_SD2_RESET_B_GPIO2_IO19		0x84>;
 	};
 
+	pinctrl_reg_usdhc2_vqmmc: regusdhc2vqmmcgrp {
+		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO04_GPIO1_IO4		0xc0>;
+	};
+
 	pinctrl_usdhc3: usdhc3grp {
 		fsl,pins = <MX8MN_IOMUXC_NAND_WE_B_USDHC3_CLK		0x1d4>,
 			   <MX8MN_IOMUXC_NAND_WP_B_USDHC3_CMD		0x1d2>,


