Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5014A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8393C433C8;
	Thu, 24 Aug 2023 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897604;
	bh=tn9KAem1j+KV06ecKFgauacRh1/RVKo/msUcMjdmcXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuclTSDJ3eOpvOk28L4k0WLJSSxH7B6C0HwAAzfVEI2t614P15jLTaaGC6tjjx+pY
	 61RDemUgu5qhEg3vx8tzSIREgUOB6rYdIwrEg0maTULSK4bztebjR2SVOaUwpNUUJk
	 G7PLlGbgt6WblwkkPfBeOQHVs5FHBlSuyp+/Mpxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/135] arm64: dts: rockchip: fix regulator name on rk3399-rock-4
Date: Thu, 24 Aug 2023 19:09:31 +0200
Message-ID: <20230824170621.564917037@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 69448624b770aa88a71536a16900dd3cc6002919 ]

fix regulator name

ref:
 https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi4_v13_sch_20181112.pdf

Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20220909195006.127957-4-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: cee572756aa2 ("arm64: dts: rockchip: Disable HS400 for eMMC on ROCK Pi 4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3399-rock-pi-4.dtsi   | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index fcd8eeabf53b6..4e1c1f970aba1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -116,24 +116,25 @@
 		vin-supply = <&vcc5v0_sys>;
 	};
 
-	vcc5v0_typec: vcc5v0-typec-regulator {
+	vbus_typec: vbus-typec-regulator {
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio1 RK_PA3 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_typec_en>;
-		regulator-name = "vcc5v0_typec";
+		regulator-name = "vbus_typec";
 		regulator-always-on;
 		vin-supply = <&vcc5v0_sys>;
 	};
 
-	vcc_lan: vcc3v3-phy-regulator {
+	vcc3v3_lan: vcc3v3-lan-regulator {
 		compatible = "regulator-fixed";
-		regulator-name = "vcc_lan";
+		regulator-name = "vcc3v3_lan";
 		regulator-always-on;
 		regulator-boot-on;
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
+		vin-supply = <&vcc3v3_sys>;
 	};
 
 	vdd_log: vdd-log {
@@ -180,7 +181,7 @@
 	assigned-clocks = <&cru SCLK_RMII_SRC>;
 	assigned-clock-parents = <&clkin_gmac>;
 	clock_in_out = "input";
-	phy-supply = <&vcc_lan>;
+	phy-supply = <&vcc3v3_lan>;
 	phy-mode = "rgmii";
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
@@ -285,8 +286,8 @@
 				};
 			};
 
-			vcc1v8_codec: LDO_REG1 {
-				regulator-name = "vcc1v8_codec";
+			vcca1v8_codec: LDO_REG1 {
+				regulator-name = "vcca1v8_codec";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
@@ -296,8 +297,8 @@
 				};
 			};
 
-			vcc1v8_hdmi: LDO_REG2 {
-				regulator-name = "vcc1v8_hdmi";
+			vcca1v8_hdmi: LDO_REG2 {
+				regulator-name = "vcca1v8_hdmi";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
@@ -354,8 +355,8 @@
 				};
 			};
 
-			vcc0v9_hdmi: LDO_REG7 {
-				regulator-name = "vcc0v9_hdmi";
+			vcca0v9_hdmi: LDO_REG7 {
+				regulator-name = "vcca0v9_hdmi";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <900000>;
@@ -495,7 +496,7 @@
 	status = "okay";
 
 	bt656-supply = <&vcc_3v0>;
-	audio-supply = <&vcc1v8_codec>;
+	audio-supply = <&vcca1v8_codec>;
 	sdmmc-supply = <&vcc_sdio>;
 	gpio1830-supply = <&vcc_3v0>;
 };
-- 
2.40.1



