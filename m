Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6815B4315A;
	Sun,  7 Sep 2025 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277587; cv=none; b=LPf/+4BqGpSyBM3S7nru9InduTgFKvYH1QKYRpGPmmJq9YHSsgRm0dPoG2O9oWZORXM9EYNHzJhwx0R4EvcjkNiIOdfgG3HBPQ8KeTqCYNzF6yYF6rEYdMO6me1/TeThJ8I+opa/3J64/+H8PpzP2x6BLTbMguSSQtA9HQx6g/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277587; c=relaxed/simple;
	bh=BJ5hUQbkYuaIcTrBaF80ijq6u2bemiWERAg/phIfjZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfIyDTBfW8J7mqbSTaQOwzU/P/i1NmN+IoFO/V0iW/Z+HDgTzN8e9N5NXE2PSsu9a9JoI2XKwuVLxb+N2RTMClkGR2kfY7Lj9EBvq0VyXYeo8SEI6V/4E1XC68rHOsqt4i+aDp7lSPLYQ2EH1NrM5xpRWPBDBjCPeIA+Oq9GMVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMTSxXqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMTSxXqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED93C4CEF0;
	Sun,  7 Sep 2025 20:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277587;
	bh=BJ5hUQbkYuaIcTrBaF80ijq6u2bemiWERAg/phIfjZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMTSxXqzUOAdt2BPafm7wICezzfJXsDyozYTdugyFKnEu9Bi73H4FppkgoqIaQ8f2
	 x2/Rr3P+cR36q7ME2CvYnSXXzrNB+De+/wUkJ+UnLFPKVyJ0Y80yQSBMd/R/5CIV+q
	 8ywFaPKtyRelcLSJVdZ3ynT9NqGQSckBdKGfxCQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 024/183] arm64: dts: imx8mp-tqma8mpql: fix LDO5 power off
Date: Sun,  7 Sep 2025 21:57:31 +0200
Message-ID: <20250907195616.353803731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 5245dc5ff9b1f6c02ef948f623432805ea148fca ]

Fix SD card removal caused by automatic LDO5 power off after boot:

LDO5: disabling
mmc1: card 59b4 removed
EXT4-fs (mmcblk1p2): shut down requested (2)
Aborting journal on device mmcblk1p2-8.
JBD2: I/O error when updating journal superblock for mmcblk1p2-8.

To prevent this, add vqmmc regulator for USDHC, using a GPIO-controlled
regulator that is supplied by LDO5. Since this is implemented on SoM but
used on baseboards with SD-card interface, implement the functionality
on SoM part and optionally enable it on baseboards if needed.

Fixes: 418d1d840e42 ("arm64: dts: freescale: add initial device tree for TQMa8MPQL with i.MX8MP")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../imx8mp-tqma8mpql-mba8mp-ras314.dts        | 13 ++++++-----
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   | 13 ++++++-----
 .../boot/dts/freescale/imx8mp-tqma8mpql.dtsi  | 22 +++++++++++++++++++
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
index d7fd9d36f8240..f7346b3d35fe5 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
@@ -467,6 +467,10 @@ &pwm4 {
 	status = "okay";
 };
 
+&reg_usdhc2_vqmmc {
+	status = "okay";
+};
+
 &sai5 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sai5>;
@@ -876,8 +880,7 @@ pinctrl_usdhc2: usdhc2grp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d2>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d2>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d2>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d2>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d2>;
 	};
 
 	pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
@@ -886,8 +889,7 @@ pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>;
 	};
 
 	pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
@@ -896,8 +898,7 @@ pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>;
 	};
 
 	pinctrl_usdhc2_gpio: usdhc2-gpiogrp {
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 23c612e80dd38..092b1b65a88c0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -603,6 +603,10 @@ &pwm3 {
 	status = "okay";
 };
 
+&reg_usdhc2_vqmmc {
+	status = "okay";
+};
+
 &sai3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sai3>;
@@ -982,8 +986,7 @@ pinctrl_usdhc2: usdhc2grp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d2>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d2>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d2>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d2>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d2>;
 	};
 
 	pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
@@ -992,8 +995,7 @@ pinctrl_usdhc2_100mhz: usdhc2-100mhzgrp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>;
 	};
 
 	pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
@@ -1002,8 +1004,7 @@ pinctrl_usdhc2_200mhz: usdhc2-200mhzgrp {
 			   <MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4>,
 			   <MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4>,
-			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>,
-			   <MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0>;
+			   <MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4>;
 	};
 
 	pinctrl_usdhc2_gpio: usdhc2-gpiogrp {
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
index 6067ca3be814e..0a592fa2d8bc7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi
@@ -24,6 +24,20 @@ reg_vcc3v3: regulator-vcc3v3 {
 		regulator-max-microvolt = <3300000>;
 		regulator-always-on;
 	};
+
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
 };
 
 &A53_0 {
@@ -180,6 +194,10 @@ m24c64: eeprom@57 {
 	};
 };
 
+&usdhc2 {
+	vqmmc-supply = <&reg_usdhc2_vqmmc>;
+};
+
 &usdhc3 {
 	pinctrl-names = "default", "state_100mhz", "state_200mhz";
 	pinctrl-0 = <&pinctrl_usdhc3>;
@@ -229,6 +247,10 @@ pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
 		fsl,pins = <MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x10>;
 	};
 
+	pinctrl_reg_usdhc2_vqmmc: regusdhc2vqmmcgrp {
+		fsl,pins = <MX8MP_IOMUXC_GPIO1_IO04__GPIO1_IO04		0xc0>;
+	};
+
 	pinctrl_usdhc3: usdhc3grp {
 		fsl,pins = <MX8MP_IOMUXC_NAND_WE_B__USDHC3_CLK		0x194>,
 			   <MX8MP_IOMUXC_NAND_WP_B__USDHC3_CMD		0x1d4>,
-- 
2.50.1



