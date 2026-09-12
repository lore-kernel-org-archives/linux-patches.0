Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133D62D7380;
	Sat, 12 Sep 2026 10:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208350; cv=none; b=DC6GaAi9m74pYi2iQMfLJfN0+JkyVVpbY/XSIgzq8Y52fd3QW2ifwpbhCv1yoLehtH25ShheS6WUZ32E4rIPoa4I3qioOpEmE0V59Okl0xLvluWdlbeNjr4MRo6x9HDA3Nm2gz6aOl+Mkc8ZzGQnctRHV8tPWOdkLIspI3gP3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208350; c=relaxed/simple;
	bh=u76ipuOUZomELg4D83r2UfbXa7ivv4G9bNO9lZRiTco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTodU2KQGDfR8WD8kjY/qCTiWMkVZb5BeUeXpjnSpICj5kVJajwGFxO3j2y+UfFL0OqvZwzwhfLef82qWMjkYKlhso36GLCvsZfURUahUX9w8P7kyWEQ4m87avlQKTYUSZB2gqMoOxIT8r3XqWCGYUdwXUGM8C87zQgzzNr9LFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rr/67byB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rr/67byB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA181F000FF;
	Sat, 12 Sep 2026 10:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208348;
	bh=QQOyVeqTYDTWKGX9dWbpve0ueOYECj/PDlX5BqlVN7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr/67byBnZBoaKrbgQFCpp5FDZNRpo8QDU6BwRJ0qt0HdbnrVGDaSqjHNUsTwMeNY
	 ZOIMz/PjIfcjHilaiHpYotFtZjzWzkGnwn+TOmgaV7ybABfuM6YoAQuMhta19n2Sm+
	 nDkpk57T8bque+AbXbRpnYBDXTblIG1Ju7blw06Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0555/1518] riscv: dts: spacemit: k1: Split gmac_clk_ref into independent pinctrl groups
Date: Sat, 12 Sep 2026 08:45:24 +0200
Message-ID: <20260912065635.992862647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 8270311d70fdf36bc8aab1e52b554e654a8839ff ]

The gmac_clk_ref signal is optional for the GMAC controller and is not
strictly required for all hardware designs. The pins for gmac0_clk_ref
(GPIO 45) and gmac1_clk_ref (GPIO 46) may also be used as GPIOs for
other functions even when the Ethernet controller is active.

Split the refclk pins into independent pinctrl groups so boards can
request them only when the reference clock path is actually needed.

Among the already mainlined boards, BPI-F3, Jupiter and MusePi Pro have
optional hardware paths for the GMAC refclk pins. BPI-F3 and Jupiter
route both GMAC refclk pins to the PHYs through NC/0R option resistors,
while MusePi Pro only does so for GMAC0. Keep referencing the new
clk-ref pinctrl groups on these boards so the optional hardware paths
remain usable if the option resistors are populated.

OrangePi R2S has no publicly available schematic, so also keep the
clk-ref groups there to preserve the previous pinmux behavior.

Fixes: 60775f28cfb7 ("riscv: dts: spacemit: Add Ethernet support for K1")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260712-bpi-cm6-v3-2-8d1e2045179d@pigmoral.tech
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/spacemit/k1-bananapi-f3.dts      |  4 ++--
 .../boot/dts/spacemit/k1-milkv-jupiter.dts    |  4 ++--
 .../riscv/boot/dts/spacemit/k1-musepi-pro.dts |  2 +-
 .../boot/dts/spacemit/k1-orangepi-r2s.dts     |  4 ++--
 arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi  | 24 +++++++++++++++----
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
index a58192ba67b2c..b2c40bae60945 100644
--- a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
@@ -46,7 +46,7 @@ &eth0 {
 	phy-handle = <&rgmii0>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac0_cfg>;
+	pinctrl-0 = <&gmac0_cfg>, <&gmac0_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <0>;
 	status = "okay";
@@ -69,7 +69,7 @@ &eth1 {
 	phy-handle = <&rgmii1>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac1_cfg>;
+	pinctrl-0 = <&gmac1_cfg>, <&gmac1_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <250>;
 	status = "okay";
diff --git a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
index a01f69f202e37..695af4919b94a 100644
--- a/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dts
@@ -26,7 +26,7 @@ &eth0 {
 	phy-handle = <&rgmii0>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac0_cfg>;
+	pinctrl-0 = <&gmac0_cfg>, <&gmac0_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <0>;
 	status = "okay";
@@ -49,7 +49,7 @@ &eth1 {
 	phy-handle = <&rgmii1>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac1_cfg>;
+	pinctrl-0 = <&gmac1_cfg>, <&gmac1_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <250>;
 	status = "okay";
diff --git a/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
index 29e333b670cf0..42efc8c1a5818 100644
--- a/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-musepi-pro.dts
@@ -48,7 +48,7 @@ &emmc {
 &eth0 {
 	phy-handle = <&rgmii0>;
 	phy-mode = "rgmii-id";
-	pinctrl-0 = <&gmac0_cfg>;
+	pinctrl-0 = <&gmac0_cfg>, <&gmac0_clk_ref_cfg>;
 	pinctrl-names = "default";
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <0>;
diff --git a/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts b/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
index 58098c4a2aabd..312d5bc860722 100644
--- a/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
@@ -37,7 +37,7 @@ &eth0 {
 	phy-handle = <&rgmii0>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac0_cfg>;
+	pinctrl-0 = <&gmac0_cfg>, <&gmac0_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <0>;
 	status = "okay";
@@ -60,7 +60,7 @@ &eth1 {
 	phy-handle = <&rgmii1>;
 	phy-mode = "rgmii-id";
 	pinctrl-names = "default";
-	pinctrl-0 = <&gmac1_cfg>;
+	pinctrl-0 = <&gmac1_cfg>, <&gmac1_clk_ref_cfg>;
 	rx-internal-delay-ps = <0>;
 	tx-internal-delay-ps = <250>;
 	status = "okay";
diff --git a/arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi b/arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi
index aff19c86d5ff3..48c4b41311646 100644
--- a/arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k1-pinctrl.dtsi
@@ -27,8 +27,16 @@ gmac0-pins {
 				 <K1_PADCONF(11, 1)>,	/* gmac0_tx_en */
 				 <K1_PADCONF(12, 1)>,	/* gmac0_mdc */
 				 <K1_PADCONF(13, 1)>,	/* gmac0_mdio */
-				 <K1_PADCONF(14, 1)>,	/* gmac0_int_n */
-				 <K1_PADCONF(45, 1)>;	/* gmac0_clk_ref */
+				 <K1_PADCONF(14, 1)>;	/* gmac0_int_n */
+
+			bias-pull-up = <0>;
+			drive-strength = <21>;
+		};
+	};
+
+	gmac0_clk_ref_cfg: gmac0-clk-ref-cfg {
+		gmac0-clk-ref-pins {
+			pinmux = <K1_PADCONF(45, 1)>;	/* gmac0_clk_ref */
 
 			bias-pull-up = <0>;
 			drive-strength = <21>;
@@ -51,8 +59,16 @@ gmac1-pins {
 				 <K1_PADCONF(40, 1)>,	/* gmac1_tx_en */
 				 <K1_PADCONF(41, 1)>,	/* gmac1_mdc */
 				 <K1_PADCONF(42, 1)>,	/* gmac1_mdio */
-				 <K1_PADCONF(43, 1)>,	/* gmac1_int_n */
-				 <K1_PADCONF(46, 1)>;	/* gmac1_clk_ref */
+				 <K1_PADCONF(43, 1)>;	/* gmac1_int_n */
+
+			bias-pull-up = <0>;
+			drive-strength = <21>;
+		};
+	};
+
+	gmac1_clk_ref_cfg: gmac1-clk-ref-cfg {
+		gmac1-clk-ref-pins {
+			pinmux = <K1_PADCONF(46, 1)>;	/* gmac1_clk_ref */
 
 			bias-pull-up = <0>;
 			drive-strength = <21>;
-- 
2.53.0



