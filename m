Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FBC13B78E;
	Tue, 27 Feb 2024 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043039; cv=none; b=sh0Nb46Gb/m+07/+rx97DugIIJ8gpjGinAAOTdZnDQjEWxBs9HadlgnhJsyVEfIGadxs1TXjjcacl2ESBnro1qfo53lqocgq3qRILO2oAk2Ap1Yyjs3kr45Dsj7FV7QnANCcMMNfQsIJ7Zmr712KfL4+5obadt1KgnRFGH01iC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043039; c=relaxed/simple;
	bh=7C7KZ9ed40VG8V4ERg/Qp93OC00c6TE/1Ms62MK5MJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+//w8HytQ+oJoeiR0wv8Xqucj7828A50DCaMeY8WP4gKtpdgd4HWEgV177h+ctRL2sv+vY8h6DdTQ21S7zjpZYh3cWlDrrGxgWGJzcK9yl40sbppsavLAKj2YeYZKurP1qL9aKcZJdyKmFDiLrBryedPUvVE6pkKkQHo+gd0Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEYgadJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEYgadJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650B8C433F1;
	Tue, 27 Feb 2024 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043038;
	bh=7C7KZ9ed40VG8V4ERg/Qp93OC00c6TE/1Ms62MK5MJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEYgadJzRxZU8vjRRSED69bMIc5ESV5tfABtqCXqXqPHTli+CQwqFq/STkixT3b26
	 B2NchD8LUh5xaG8XzDCEkqIuakw6Rt/3GnfUVyyqPlFR4O/8InXXDhl48LawNauzJH
	 iTdhxK4Rk5vVzq+BzCM/sN8rA3eGEwkLeid7fUCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/245] arm64: dts: rockchip: fix regulator name on rk3399-rock-4
Date: Tue, 27 Feb 2024 14:26:12 +0100
Message-ID: <20240227131621.185586788@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 69448624b770aa88a71536a16900dd3cc6002919 ]

fix regulator name

ref:
 https://dl.radxa.com/rockpi4/docs/hw/rockpi4/rockpi4_v13_sch_20181112.pdf

Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20220909195006.127957-4-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3399-rock-pi-4.dtsi   | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 8b70e831aff23..203460d46f182 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -98,24 +98,25 @@ vcc5v0_host: vcc5v0-host-regulator {
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
@@ -162,7 +163,7 @@ &gmac {
 	assigned-clocks = <&cru SCLK_RMII_SRC>;
 	assigned-clock-parents = <&clkin_gmac>;
 	clock_in_out = "input";
-	phy-supply = <&vcc_lan>;
+	phy-supply = <&vcc3v3_lan>;
 	phy-mode = "rgmii";
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
@@ -267,8 +268,8 @@ regulator-state-mem {
 				};
 			};
 
-			vcc1v8_codec: LDO_REG1 {
-				regulator-name = "vcc1v8_codec";
+			vcca1v8_codec: LDO_REG1 {
+				regulator-name = "vcca1v8_codec";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
@@ -278,8 +279,8 @@ regulator-state-mem {
 				};
 			};
 
-			vcc1v8_hdmi: LDO_REG2 {
-				regulator-name = "vcc1v8_hdmi";
+			vcca1v8_hdmi: LDO_REG2 {
+				regulator-name = "vcca1v8_hdmi";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
@@ -336,8 +337,8 @@ regulator-state-mem {
 				};
 			};
 
-			vcc0v9_hdmi: LDO_REG7 {
-				regulator-name = "vcc0v9_hdmi";
+			vcca0v9_hdmi: LDO_REG7 {
+				regulator-name = "vcca0v9_hdmi";
 				regulator-always-on;
 				regulator-boot-on;
 				regulator-min-microvolt = <900000>;
@@ -456,7 +457,7 @@ &io_domains {
 	status = "okay";
 
 	bt656-supply = <&vcc_3v0>;
-	audio-supply = <&vcc1v8_codec>;
+	audio-supply = <&vcca1v8_codec>;
 	sdmmc-supply = <&vcc_sdio>;
 	gpio1830-supply = <&vcc_3v0>;
 };
-- 
2.43.0



