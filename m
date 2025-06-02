Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3B23C518;
	Mon,  2 Jun 2025 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874160; cv=none; b=ZOO8M9KeHpcFa94rL3Zqig5CQJvDVSaG9l4RpLsKmBGNcV2x0xLiasmLcsRi1WbWdy0Lkp8uJiSMdtDAKLfhWnyf+xlZ1rq8scIkvsSUDDWLsCPuISysEiZw17exfa2uSwGrXeClcTQQ5pH1NefjdHm5BwUxmkQiFVCo5+LYopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874160; c=relaxed/simple;
	bh=RYPVR28hMBlh3cnCeqxgABmamXke4NRtwz7/r8sSeuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEYbUGU7Rm0y8GKFt0L6s8Eh/ff5NfAqmxfv1DDQKWQBwLmM/7lUCKWTp9ouSRiy/DFZIgJRuaU36TxO299qW4inykbuYkmJnH6k0glIgAfkqJb1jJmaTgcFtSGqCb3MI9+ThXvdRf899lY3BCKXZcjJSZmJQ5M2gIEJNCIAAwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0xwWqJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0xwWqJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9E7C4CEEB;
	Mon,  2 Jun 2025 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874160;
	bh=RYPVR28hMBlh3cnCeqxgABmamXke4NRtwz7/r8sSeuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0xwWqJ7a3rUKLvhVFT9mbgMNdWbx1dC84rKSjblTF3RY2ixCGdkmPc6j7ltcWhkF
	 VbK6iVWHahhfulr76Gb6uSZwboiWyctB28Q5WrnZNLKgdR2nU2QObFnYPmrptWRV4m
	 S2YAceA3k2ler8jtHxEGa95esBOz1kKIhmhKH4HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/444] Revert "arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection"
Date: Mon,  2 Jun 2025 15:47:22 +0200
Message-ID: <20250602134356.255483007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 381d58cea092d..c854c7e310519 100644
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
index 6fc65e8db2206..8c476e089185b 100644
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
index 92745128fcfeb..4ec4996592bef 100644
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



