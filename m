Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625231;
	b=LD7ShxDOF3QFCNTdkeGEhKLPTDeaEHY6bOxFead9zSoZdjlKqAYkL7mYgPMGX3smjQ1N
	 g+rtm4MX9Pjmb4dxMv7sx68Qrpg0aZifh9CJhT6Fp2WgaoGhADZeDy2/XJ8H/m1FWUzk1
	 +52P6tYFkgHE5hx+Zs9NpaRQafNBG1LJ3OP/aMQ+9EL3kPJtEso+bMcrNieqyRuKOovWL
	 p3Cvcwnf0qshecUzfD9xzUEi1VkgQgb614jWA9TPlG6cL/c2LT5LkDPyv33fWFLCpOJLt
	 3XIj2ihxYDE9Hq6d1IkCfzNL+dsUTzNbwWcemyJw7wnHj5PmISIJ4yZ/BYl7Hb1lPRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pTt5T0lYz9upVyhl/Zk9C50Qim1y/i+TQxvLJOU80Gk=;
	b=DNItASbXxS6iuzIBRfy5AlgNkpi3fwZs1RVgiIa9qsOhp0xcE2x5rDLVNM7igDCfa0Fb
	 qI5OHBgDS/P0iC7f01Q5swh8fKBfW5chCLM1+tenC69w+uHUJ3dFrGCG01XINeIGxcO4X
	 g1ByKcNu8KxEdPnxCKkwoIrsLlhQVKS3k8fJGQvU74aOgRDoi03kgN7iJ1WddMJZcdPVb
	 JSS7jveaXHjTPhjRB19kTsiPe/MQFEZOai7Bkm/7cu6z+oczGKFpIaz1OdB9qH3pGYVwB
	 VxqMl+6RzK+KTRRMswbkWcSh1aWIbCq+IPp0jvU9Rihc3+6wCHwjSRgaswyK6Lanw1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HXrInS/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8416E606A32A;
	Wed, 25 Nov 2026 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HXrInS/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CFB1F000C0;
	Wed, 25 Nov 2026 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625231;
	bh=pTt5T0lYz9upVyhl/Zk9C50Qim1y/i+TQxvLJOU80Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXrInS/E6t+Dt5jDJtEFYpZtMmnFQ/EsYJN/ZQXMcMXMb/x025nATdA7kjK5nS1lv
	 MkkoEWNMnXyfe79mySBtcAGDFmHklJmLu2AlOp/CCHvgvyLSs8aJtBFrPbwx6l+H09
	 sIrB9rbFN6Yy/f2RSzl4M2iAJ7aZuJS3pu/gIWpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@riscstar.com>,
	Guodong Xu <guodong@riscstar.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/816] riscv: dts: starfive: jh7110-common: revised device node
Date: Wed, 25 Nov 2026 15:33:16 +0100
Message-ID: <20261125143859.559720122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guodong Xu <guodong@riscstar.com>

[ Upstream commit 5a5001d27065126d815eb54e12744b08322e3d31 ]

Earlier this year a new DTSI file was created to define common
properties for the StarFive VisionFive 2 and Milk-V Mars boards,
both of which use the StarFive JH7110 SoC.  The Pine64 Star64
board has also been added since that time.

Some of the nodes defined in "jh7110-common.dtsi" are enabled in
that file because all of the boards including it "want" them
enabled.

An upcoming patch enables another JH7110 board, but for that
board not all of these common nodes should be enabled.  Prepare
for supporting the new board by avoiding enabling these nodes in
"jh7110-common.dtsi", and enable them instead in these files:
   jh7110-milkv-mars.dts
   jh7110-pine64-star64.dts
   jh7110-starfive-visionfive-2.dtsi

Signed-off-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Guodong Xu <guodong@riscstar.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Stable-dep-of: 2186ec5f59c2 ("riscv: dts: starfive: Correct pwm nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/starfive/jh7110-common.dtsi      |  5 -----
 .../boot/dts/starfive/jh7110-milkv-mars.dts   | 17 ++++++++++++++++
 .../dts/starfive/jh7110-pine64-star64.dts     | 17 ++++++++++++++++
 .../jh7110-starfive-visionfive-2.dtsi         | 20 +++++++++++++++++++
 4 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
index d6c55f1cc96a9..82edf8134d93f 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
@@ -174,7 +174,6 @@ csi2rx_to_camss: endpoint {
 &gmac0 {
 	phy-handle = <&phy0>;
 	phy-mode = "rgmii-id";
-	status = "okay";
 
 	mdio {
 		#address-cells = <1>;
@@ -194,7 +193,6 @@ &i2c0 {
 	i2c-scl-falling-time-ns = <510>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins>;
-	status = "okay";
 };
 
 &i2c2 {
@@ -309,7 +307,6 @@ &pcie1 {
 &pwmdac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pwmdac_pins>;
-	status = "okay";
 };
 
 &qspi {
@@ -348,13 +345,11 @@ uboot@100000 {
 &pwm {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pwm_pins>;
-	status = "okay";
 };
 
 &spi0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&spi0_pins>;
-	status = "okay";
 
 	spi_dev0: spi@0 {
 		compatible = "rohm,dh2228fv";
diff --git a/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts b/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
index 5cb9e99e1dacd..66ad3eb2fd665 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
@@ -15,6 +15,11 @@ &gmac0 {
 	starfive,tx-use-rgmii-clk;
 	assigned-clocks = <&aoncrg JH7110_AONCLK_GMAC0_TX>;
 	assigned-clock-parents = <&aoncrg JH7110_AONCLK_GMAC0_RMII_RTX>;
+	status = "okay";
+};
+
+&i2c0 {
+	status = "okay";
 };
 
 &pcie0 {
@@ -35,3 +40,15 @@ &phy0 {
 	rx-internal-delay-ps = <1500>;
 	tx-internal-delay-ps = <1500>;
 };
+
+&pwm {
+	status = "okay";
+};
+
+&pwmdac {
+	status = "okay";
+};
+
+&spi0 {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
index 8e39fdc73ecb8..25cf14b33518e 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
@@ -18,6 +18,7 @@ &gmac0 {
 	starfive,tx-use-rgmii-clk;
 	assigned-clocks = <&aoncrg JH7110_AONCLK_GMAC0_TX>;
 	assigned-clock-parents = <&aoncrg JH7110_AONCLK_GMAC0_RMII_RTX>;
+	status = "okay";
 };
 
 &gmac1 {
@@ -39,6 +40,10 @@ phy1: ethernet-phy@1 {
 	};
 };
 
+&i2c0 {
+	status = "okay";
+};
+
 &pcie1 {
 	status = "okay";
 };
@@ -62,3 +67,15 @@ &phy1 {
 	motorcomm,tx-clk-10-inverted;
 	motorcomm,tx-clk-100-inverted;
 };
+
+&pwm {
+	status = "okay";
+};
+
+&pwmdac {
+	status = "okay";
+};
+
+&spi0 {
+	status = "okay";
+};
diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
index 18f38fc790a4d..ef93a394bb2f1 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -13,6 +13,10 @@ aliases {
 	};
 };
 
+&gmac0 {
+	status = "okay";
+};
+
 &gmac1 {
 	phy-handle = <&phy1>;
 	phy-mode = "rgmii-id";
@@ -29,6 +33,10 @@ phy1: ethernet-phy@1 {
 	};
 };
 
+&i2c0 {
+	status = "okay";
+};
+
 &mmc0 {
 	non-removable;
 };
@@ -40,3 +48,15 @@ &pcie0 {
 &pcie1 {
 	status = "okay";
 };
+
+&pwm {
+	status = "okay";
+};
+
+&pwmdac {
+	status = "okay";
+};
+
+&spi0 {
+	status = "okay";
+};
-- 
2.53.0



