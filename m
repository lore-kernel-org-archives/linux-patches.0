Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C077306480;
	Mon, 13 Oct 2025 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369121; cv=none; b=JAeVuf6ve0j3ngs8TcirEJkVEsbyS0TlQN5OzHYlpyuBOpvKdx6MyMHwMeyXSz+OFSElO9Vqh0vVZo9pOC5mBcuVUVHaA+3hnqXlI87R+G7V5OKxMlmVKPJuZQNTe63RSB0pCAEVt9u/aAu2+bNhzHIsKCLElz5rK166Ku+OMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369121; c=relaxed/simple;
	bh=ZuE9c0wSVU1MfODwS+Eogv7hfaBBuhlPDX/sc3dUZe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWxuXjbSCVOhzVf8YfKZHBuHFeRK2iKYXAYg3worJR8onMWR6jyzGeds8JhhuZP/3CF6ubWsITrimPsW+mnFpxZ/ci1mybebjW6EZBW/xCEqBtqvXWlXnbBfyrHLWJhVTwTk1k2O+fKU0az5SF6JLcc4a8E8ZmFR3N/2L0q40Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fha45uJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fha45uJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024A9C4CEE7;
	Mon, 13 Oct 2025 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369121;
	bh=ZuE9c0wSVU1MfODwS+Eogv7hfaBBuhlPDX/sc3dUZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fha45uJ8HJtbAFtPc1tghq9NgdpytnJme02zEiz6HZQLP93fUGNN8BtAUC4SnR6n8
	 QKq0hwyBx+18K8SLKH1C0BsqXzL5SvmrPlrKuaKclfsJQPht0cacImPObbuKwqlSvs
	 t9JYeA+EkklC2bqpHjG0Ov+DU1e+HHaKasFojI18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 136/563] arm64: dts: rockchip: Fix network on rk3576 evb1 board
Date: Mon, 13 Oct 2025 16:39:57 +0200
Message-ID: <20251013144416.218088103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 843367c7ed196bd0806c8776cba108aaf6923b82 ]

The RK3576 EVB1 has a RTL8211F PHY for each GMAC interface with
a dedicated reset line and the 25MHz clock provided by the SoC.
The current description results in non-working Ethernet as the
clocks are only enabled by the PHY driver, but probing the right
PHY driver currently requires that the PHY ID register can be read
for automatic identification.

This fixes up the network description to get the network functionality
working reliably and cleans up usage of deprecated DT properties while
at it.

Fixes: f135a1a07352 ("arm64: dts: rockchip: Add rk3576 evb1 board")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250910-rk3576-evb-network-v1-1-68ed4df272a2@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3576-evb1-v10.dts     | 38 ++++++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
index 3007e0179611b..012c21b58a5a1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
@@ -275,9 +275,6 @@ &eth0m0_rx_bus2
 		     &eth0m0_rgmii_clk
 		     &eth0m0_rgmii_bus
 		     &ethm0_clk0_25m_out>;
-	snps,reset-gpio = <&gpio2 RK_PB5 GPIO_ACTIVE_LOW>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 20000 100000>;
 	tx_delay = <0x21>;
 	status = "okay";
 };
@@ -293,9 +290,6 @@ &eth1m0_rx_bus2
 		     &eth1m0_rgmii_clk
 		     &eth1m0_rgmii_bus
 		     &ethm0_clk1_25m_out>;
-	snps,reset-gpio = <&gpio3 RK_PA3 GPIO_ACTIVE_LOW>;
-	snps,reset-active-low;
-	snps,reset-delays-us = <0 20000 100000>;
 	tx_delay = <0x20>;
 	status = "okay";
 };
@@ -715,18 +709,32 @@ hym8563: rtc@51 {
 };
 
 &mdio0 {
-	rgmii_phy0: phy@1 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+	rgmii_phy0: ethernet-phy@1 {
+		compatible = "ethernet-phy-id001c.c916";
 		reg = <0x1>;
 		clocks = <&cru REFCLKO25M_GMAC0_OUT>;
+		assigned-clocks = <&cru REFCLKO25M_GMAC0_OUT>;
+		assigned-clock-rates = <25000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&rgmii_phy0_rst>;
+		reset-assert-us = <20000>;
+		reset-deassert-us = <100000>;
+		reset-gpios = <&gpio2 RK_PB5 GPIO_ACTIVE_LOW>;
 	};
 };
 
 &mdio1 {
-	rgmii_phy1: phy@1 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+	rgmii_phy1: ethernet-phy@1 {
+		compatible = "ethernet-phy-id001c.c916";
 		reg = <0x1>;
 		clocks = <&cru REFCLKO25M_GMAC1_OUT>;
+		assigned-clocks = <&cru REFCLKO25M_GMAC1_OUT>;
+		assigned-clock-rates = <25000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&rgmii_phy1_rst>;
+		reset-assert-us = <20000>;
+		reset-deassert-us = <100000>;
+		reset-gpios = <&gpio3 RK_PA3 GPIO_ACTIVE_LOW>;
 	};
 };
 
@@ -772,6 +780,16 @@ rtc_int: rtc-int {
 		};
 	};
 
+	network {
+		rgmii_phy0_rst: rgmii-phy0-rst {
+			rockchip,pins = <2 RK_PB5 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		rgmii_phy1_rst: rgmii-phy1-rst {
+			rockchip,pins = <3 RK_PA3 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	pcie0 {
 		pcie0_rst: pcie0-rst {
 			rockchip,pins = <2 RK_PB4 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.51.0



