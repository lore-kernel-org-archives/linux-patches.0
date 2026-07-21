Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839843ED3B2;
	Tue, 21 Jul 2026 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649364; cv=none; b=n6iq7tPgxjmLDouODso1leQAgwFSZWUMvyMa5JFXRRDj9yJI5s3vxq2EujYfC1dil2qb8DmFRfwl0Dy+SwJwwsI74udVIhrDASCq8/cnhU/AotcfAtoVXjz3e7RHqSYSsnb0htXv/ko3dAU0wfX2dJDuC/A+pYC6I+ZFMRjiQQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649364; c=relaxed/simple;
	bh=ZyIT8tB1C166gmuOh0ei/fttDVDsg0FeIjWQpynckko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK3fp41V6m3F/jbUc1oYBAwKXJjR/CBZnf9iMBe0y78QbtlUtgd5TNXPk99cd6VD871eAsiVbcgyJJGsndwM4OcyZRyuUZ+DSaywIJj41TFw/6hOQL7d1751f6nlTFzpUx/3Kp/mWJ2eHjTbNGqsY+bOTv9vGQEACsods90OqN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcGvHJlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcGvHJlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96831F00A3A;
	Tue, 21 Jul 2026 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649363;
	bh=jciHPkiElPtoIE7KyaMubgX8X8/exhHd8QXrfAiCRug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcGvHJlFEyys4c/GabewP0rIx/3hdOA/4FOiu4I1LTs6MqFlL9tC+DdqQg6cv6jgu
	 Csur3Y+G7cj+qUFAkReQVF3k0Tl0hEB4zzGE5gyGntpI9qT00UoYgoBHZfG5+iLO3P
	 3a1WNlNY8N7cO8MA2OGRl3ybJuljE4O2X9dsjHS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0507/2077] arm64: dts: imx8mp-kontron: Fix GPIO for display power switch
Date: Tue, 21 Jul 2026 17:03:00 +0200
Message-ID: <20260721152604.772833196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 5b19ca527471903920d713bc48518a036a95bf6b ]

The GPIO that controls the power supply for the LVDS display
connector has changed between early prototypes and the current
production design of the hardware. Reflect this change in the
devicetree to properly switch on the panel supply.

This was working before even with the wrong GPIO due to the
bidirectional level shifter used on the board which drives the EN
signal high even when the input has a (weak) pull down configured as
reset condition of the SoC pad. As a result the display was working
but the supply was always on.

Tested on BL i.MX8MP to show the correct voltage level on the level
shifter input.

Fixes: 946ab10e3f40 ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts   | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
index 75ae4664278214..29ce863403b882 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
@@ -49,7 +49,9 @@ pwm-beeper {
 
 	reg_vcc_panel: regulator-vcc-panel {
 		compatible = "regulator-fixed";
-		gpio = <&gpio4 3 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_vcc_panel>;
+		gpio = <&gpio5 3 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
@@ -172,7 +174,7 @@ &gpio4 {
 &gpio5 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_gpio5>;
-	gpio-line-names = "I2S_BITCLK", "I2S_A_DATA_OUT", "I2S_MCLK", "PWM_2",
+	gpio-line-names = "I2S_BITCLK", "I2S_A_DATA_OUT", "I2S_MCLK", "VCC_PANEL_EN",
 			  "PWM_1", "PWM_0", "SPI_A_SCK", "CAN_ADDR1",
 			  "CAN_ADDR0", "SPI_A_CS0", "SPI_B_SCK", "SPI_B_SDO",
 			  "SPI_B_SDI", "SPI_B_CS0", "I2C_A_SCL", "I2C_A_SDA",
@@ -329,4 +331,10 @@ MX8MP_IOMUXC_ECSPI1_MOSI__GPIO5_IO07		0x46 /* CAN_ADR0 */
 			MX8MP_IOMUXC_ECSPI1_MISO__GPIO5_IO08		0x46 /* CAN_ADR1 */
 		>;
 	};
+
+	pinctrl_reg_vcc_panel: regvccpanelgrp {
+		fsl,pins = <
+			MX8MP_IOMUXC_SPDIF_TX__GPIO5_IO03		0x46
+		>;
+	};
 };
-- 
2.53.0



