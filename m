Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58D01E505;
	Mon, 12 May 2025 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072703; cv=none; b=UYcQD0YhYlVJq8MyMmkAixIH6dCVVJqTgfGjih1w3V3fS684HuLcGnh+CWLC3Do87k3W55/csl7Youk+cf2GpMcfLSJZTIKUTssjL2AVsxG4pJdE6OJtH+p/hpMY6aeBVhXiKztAYCCoiRMFOL3oELnlfVZclXpNB8eeY1Bc4j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072703; c=relaxed/simple;
	bh=Y16ovfWY4uhGelarfiIJAL6zJ7t2xX2c38EGoA34eQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Chd6bCb1E/so5OEstL8+mBHKjC4gDshDaaYIK6phWz2Bf9KppiaMD1kgqFm55hvabCz9aw6xdLl1GADb7A5VKXhEE29+iqmotCq+DZTZKbNYFNv87uiIGXfFi0e0rmKZZAQKsMxakUeOSwgPuTQzHJtWO4fMpYoZQByDEq03D5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGkQ2gb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGkQ2gb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF2C4CEE7;
	Mon, 12 May 2025 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072702;
	bh=Y16ovfWY4uhGelarfiIJAL6zJ7t2xX2c38EGoA34eQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGkQ2gb5L5Tf+OFXHs7f/DKVDG2LHWN419brISGiFv1DvKutzmdfyaJgzukaWcgLR
	 ImfbjISCKCeEP1Q3ol5Y4MaRyNgrU9BYc3QdIC7ZHcutQFkXto8Fy7DCQLXg29/tme
	 1T6wCGotz8Djc0AK+FjyGKoEQGEpVg2CQfVTtIDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Traut <manuel.traut@mt.com>,
	Philippe Schenker <philippe.schenker@impulsing.ch>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Wojciech Dubowik <Wojciech.Dubowik@mt.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 004/184] arm64: dts: imx8mm-verdin: Link reg_usdhc2_vqmmc to usdhc2
Date: Mon, 12 May 2025 19:43:25 +0200
Message-ID: <20250512172041.825221314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wojciech Dubowik <Wojciech.Dubowik@mt.com>

commit 5591ce0069ddda97cdbbea596bed53e698f399c2 upstream.

Define vqmmc regulator-gpio for usdhc2 with vin-supply
coming from LDO5.

Without this definition LDO5 will be powered down, disabling
SD card after bootup. This has been introduced in commit
f5aab0438ef1 ("regulator: pca9450: Fix enable register for LDO5").

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Fixes: f5aab0438ef1 ("regulator: pca9450: Fix enable register for LDO5")
Tested-by: Manuel Traut <manuel.traut@mt.com>
Reviewed-by: Philippe Schenker <philippe.schenker@impulsing.ch>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@mt.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |   25 ++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -165,6 +165,19 @@
 		startup-delay-us = <20000>;
 	};
 
+	reg_usdhc2_vqmmc: regulator-usdhc2-vqmmc {
+		compatible = "regulator-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usdhc2_vsel>;
+		gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
+		regulator-max-microvolt = <3300000>;
+		regulator-min-microvolt = <1800000>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
+		regulator-name = "PMIC_USDHC_VSELECT";
+		vin-supply = <&reg_nvcc_sd>;
+	};
+
 	reserved-memory {
 		#address-cells = <2>;
 		#size-cells = <2>;
@@ -290,7 +303,7 @@
 			  "SODIMM_19",
 			  "",
 			  "",
-			  "",
+			  "PMIC_USDHC_VSELECT",
 			  "",
 			  "",
 			  "",
@@ -801,6 +814,7 @@
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_cd>;
 	pinctrl-3 = <&pinctrl_usdhc2_sleep>, <&pinctrl_usdhc2_cd_sleep>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&reg_usdhc2_vqmmc>;
 };
 
 &wdog1 {
@@ -1222,13 +1236,17 @@
 			<MX8MM_IOMUXC_NAND_CLE_GPIO3_IO5		0x6>;	/* SODIMM 76 */
 	};
 
+	pinctrl_usdhc2_vsel: usdhc2vselgrp {
+		fsl,pins =
+			<MX8MM_IOMUXC_GPIO1_IO04_GPIO1_IO4	0x10>; /* PMIC_USDHC_VSELECT */
+	};
+
 	/*
 	 * Note: Due to ERR050080 we use discrete external on-module resistors pulling-up to the
 	 * on-module +V3.3_1.8_SD (LDO5) rail and explicitly disable the internal pull-ups here.
 	 */
 	pinctrl_usdhc2: usdhc2grp {
 		fsl,pins =
-			<MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x10>,
 			<MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x90>,	/* SODIMM 78 */
 			<MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x90>,	/* SODIMM 74 */
 			<MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x90>,	/* SODIMM 80 */
@@ -1239,7 +1257,6 @@
 
 	pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x10>,
 			<MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x94>,
 			<MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x94>,
 			<MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x94>,
@@ -1250,7 +1267,6 @@
 
 	pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x10>,
 			<MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x96>,
 			<MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x96>,
 			<MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x96>,
@@ -1262,7 +1278,6 @@
 	/* Avoid backfeeding with removed card power */
 	pinctrl_usdhc2_sleep: usdhc2slpgrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT		0x0>,
 			<MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x0>,
 			<MX8MM_IOMUXC_SD2_CMD_USDHC2_CMD		0x0>,
 			<MX8MM_IOMUXC_SD2_DATA0_USDHC2_DATA0		0x0>,


