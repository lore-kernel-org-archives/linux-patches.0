Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F41E89C;
	Tue, 27 May 2025 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366151; cv=none; b=P3W0h/Xroh2C+s9Ak4Wk+LH2Bnrzm26vjKg4IGzpWzFoQPxdL0koP7cT0/oeGe2eLh9avrfpy8zkSopUVa8P+ZAf9kvvvIBo9ipcK6Ewd8VMKZT6310YFFmfxmrOAHGNAa+fXFZEUuQ+eDocSTrqqg1UAH+WXIWy+5I2ZXNfwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366151; c=relaxed/simple;
	bh=kPlehD9WECxDw4R9kSM5dVey+lavUajjmZa5tMxLf3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrLdsE8PyloxGpaN0Xdszx64tr4ukHilXiMiwOQuWasH6GpU+Zc+UO1fA8akBZsEYaQ+5SFAyNabMygS1YQAKgsf+m4bRKFzE+P42cIYpAZJ/ITH1C9FF/tB4HtJ7fjn58BdkApJ57E/C9tI5lWxQ/idJBePUyq+mgw2KZaYo+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMp3Sk5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMp3Sk5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9060BC4CEE9;
	Tue, 27 May 2025 17:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366151;
	bh=kPlehD9WECxDw4R9kSM5dVey+lavUajjmZa5tMxLf3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMp3Sk5Oy2h1WFN3YB/d1CA69Ftzi1rhnXFUFNdtGGZCegBPFgGp2O2JBnR6t/K1W
	 SG9JlV3XEIucbY8sT2hrEX/gXgKhFo6MOzqy8vRYJ1OvilBhoRANvBl1H8jzL2duAn
	 SboSX1Dx250ghODYcl+6/yiv9RNpIb9p7KeZCWJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 606/626] Revert "arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection"
Date: Tue, 27 May 2025 18:28:19 +0200
Message-ID: <20250527162509.617443012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 573f99c7585f597630f14596550c79e73ffaeef4 ]

This reverts commit 531fdbeedeb89bd32018a35c6e137765c9cc9e97.

Hardware that uses I2C wasn't designed with high speeds in mind, so
communication with PMIC via RSB can intermittently fail. Go back to I2C
as higher speed and efficiency isn't worth the trouble.

Fixes: 531fdbeedeb8 ("arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection")
Link: https://github.com/LibreELEC/LibreELEC.tv/issues/7731
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250413135848.67283-1-jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/allwinner/sun50i-h6-beelink-gs1.dts   | 38 +++++++++----------
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 14 +++----
 .../dts/allwinner/sun50i-h6-orangepi.dtsi     | 22 +++++------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
index 3be1e8c2fdb9c..1012103df25f7 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
@@ -151,28 +151,12 @@
 	vcc-pg-supply = <&reg_aldo1>;
 };
 
-&r_ir {
-	linux,rc-map-name = "rc-beelink-gs1";
-	status = "okay";
-};
-
-&r_pio {
-	/*
-	 * FIXME: We can't add that supply for now since it would
-	 * create a circular dependency between pinctrl, the regulator
-	 * and the RSB Bus.
-	 *
-	 * vcc-pl-supply = <&reg_aldo1>;
-	 */
-	vcc-pm-supply = <&reg_aldo1>;
-};
-
-&r_rsb {
+&r_i2c {
 	status = "okay";
 
-	axp805: pmic@745 {
+	axp805: pmic@36 {
 		compatible = "x-powers,axp805", "x-powers,axp806";
-		reg = <0x745>;
+		reg = <0x36>;
 		interrupt-parent = <&r_intc>;
 		interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-controller;
@@ -290,6 +274,22 @@
 	};
 };
 
+&r_ir {
+	linux,rc-map-name = "rc-beelink-gs1";
+	status = "okay";
+};
+
+&r_pio {
+	/*
+	 * PL0 and PL1 are used for PMIC I2C
+	 * don't enable the pl-supply else
+	 * it will fail at boot
+	 *
+	 * vcc-pl-supply = <&reg_aldo1>;
+	 */
+	vcc-pm-supply = <&reg_aldo1>;
+};
+
 &spdif {
 	pinctrl-names = "default";
 	pinctrl-0 = <&spdif_tx_pin>;
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index 6c3bfe3d09d9a..14cc99b216224 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -175,16 +175,12 @@
 	vcc-pg-supply = <&reg_vcc_wifi_io>;
 };
 
-&r_ir {
-	status = "okay";
-};
-
-&r_rsb {
+&r_i2c {
 	status = "okay";
 
-	axp805: pmic@745 {
+	axp805: pmic@36 {
 		compatible = "x-powers,axp805", "x-powers,axp806";
-		reg = <0x745>;
+		reg = <0x36>;
 		interrupt-parent = <&r_intc>;
 		interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-controller;
@@ -295,6 +291,10 @@
 	};
 };
 
+&r_ir {
+	status = "okay";
+};
+
 &rtc {
 	clocks = <&ext_osc32k>;
 };
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi
index 13b07141c3344..bab0f63dcc5be 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi.dtsi
@@ -112,20 +112,12 @@
 	vcc-pg-supply = <&reg_aldo1>;
 };
 
-&r_ir {
-	status = "okay";
-};
-
-&r_pio {
-	vcc-pm-supply = <&reg_bldo3>;
-};
-
-&r_rsb {
+&r_i2c {
 	status = "okay";
 
-	axp805: pmic@745 {
+	axp805: pmic@36 {
 		compatible = "x-powers,axp805", "x-powers,axp806";
-		reg = <0x745>;
+		reg = <0x36>;
 		interrupt-parent = <&r_intc>;
 		interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_LOW>;
 		interrupt-controller;
@@ -240,6 +232,14 @@
 	};
 };
 
+&r_ir {
+	status = "okay";
+};
+
+&r_pio {
+	vcc-pm-supply = <&reg_bldo3>;
+};
+
 &rtc {
 	clocks = <&ext_osc32k>;
 };
-- 
2.39.5



