Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F46F17592;
	Tue, 30 Apr 2024 11:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476175; cv=none; b=XSsq2RfFAdPO6qUHhEPNG6zhLuuhT37LN+sQhbzZzZ7VFGxSOvTsA4ucFdDvtNlG50ji4B1UHSp5TOSKtEYIUc/tcrWAXL2+NLpTvN4DQ/1ftWawJXXnjxJeYCbupV9wM2Qkhw4zVs2ExyKhLBbwRDMz7ebB8VylaQTiIm2wh9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476175; c=relaxed/simple;
	bh=EJl3l/cbxQ+sqSjILYwKAajzAWlsQcmC6/FYBXvmJeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkj43Ww1ANaiXHilT3JfCzpj6i/3TT2JV5EZ9i5shB7RoXc1aQ9HBePwFwALH8WmDiEWwEu8XF3+vwB3LACB+ecbIeNqfw9fJ7zC8ut8VF/tp92NGRIpB+DgyeLwjuPuEixXrmx0BdjnTpzcQfZULtplczlsW5s5hvkLGNnA8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Io22eqkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Io22eqkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0F5C2BBFC;
	Tue, 30 Apr 2024 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476174;
	bh=EJl3l/cbxQ+sqSjILYwKAajzAWlsQcmC6/FYBXvmJeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Io22eqkAbgg2o/QtdmiNZ0eJLEz/VjD2fnMJpR7E6YG+yh1MoPqfpJy8nhUXCU73Y
	 aFTD4KNyWe9K6miV00HF5a8ntLn+5eXN0+4hr/+SnR5Nf08VMav5Sml9di6ku8GcKZ
	 loFHp7rQZ3g5xVSBgeubw9nfvWRKWgb0hox7Zs6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biao Huang <biao.huang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/107] arm64: dts: mt2712: add ethernet device node
Date: Tue, 30 Apr 2024 12:40:18 +0200
Message-ID: <20240430103046.369402676@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biao Huang <biao.huang@mediatek.com>

[ Upstream commit e9cabfd046d55d05f11d05fccc4019aa4bad29c6 ]

This patch add device node for mt2712 ethernet.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: 3baac7291eff ("arm64: dts: mediatek: mt2712: fix validation errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts | 74 +++++++++++++++++++++
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi   | 65 ++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index 45e37aa67ce73..9d20cabf4f699 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -105,7 +105,81 @@
 	proc-supply = <&cpus_fixed_vproc1>;
 };
 
+&eth {
+	phy-mode ="rgmii-rxid";
+	phy-handle = <&ethernet_phy0>;
+	mediatek,tx-delay-ps = <1530>;
+	snps,reset-gpio = <&pio 87 GPIO_ACTIVE_LOW>;
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&eth_default>;
+	pinctrl-1 = <&eth_sleep>;
+	status = "okay";
+
+	mdio {
+		compatible = "snps,dwmac-mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ethernet_phy0: ethernet-phy@5 {
+			compatible = "ethernet-phy-id0243.0d90";
+			reg = <0x5>;
+		};
+	};
+};
+
 &pio {
+	eth_default: eth_default {
+		tx_pins {
+			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GBE_TXD3>,
+				 <MT2712_PIN_72_GBE_TXD2__FUNC_GBE_TXD2>,
+				 <MT2712_PIN_73_GBE_TXD1__FUNC_GBE_TXD1>,
+				 <MT2712_PIN_74_GBE_TXD0__FUNC_GBE_TXD0>,
+				 <MT2712_PIN_75_GBE_TXC__FUNC_GBE_TXC>,
+				 <MT2712_PIN_76_GBE_TXEN__FUNC_GBE_TXEN>;
+			drive-strength = <MTK_DRIVE_8mA>;
+		};
+		rx_pins {
+			pinmux = <MT2712_PIN_78_GBE_RXD3__FUNC_GBE_RXD3>,
+				 <MT2712_PIN_79_GBE_RXD2__FUNC_GBE_RXD2>,
+				 <MT2712_PIN_80_GBE_RXD1__FUNC_GBE_RXD1>,
+				 <MT2712_PIN_81_GBE_RXD0__FUNC_GBE_RXD0>,
+				 <MT2712_PIN_82_GBE_RXDV__FUNC_GBE_RXDV>,
+				 <MT2712_PIN_84_GBE_RXC__FUNC_GBE_RXC>;
+			input-enable;
+		};
+		mdio_pins {
+			pinmux = <MT2712_PIN_85_GBE_MDC__FUNC_GBE_MDC>,
+				 <MT2712_PIN_86_GBE_MDIO__FUNC_GBE_MDIO>;
+			drive-strength = <MTK_DRIVE_8mA>;
+			input-enable;
+		};
+	};
+
+	eth_sleep: eth_sleep {
+		tx_pins {
+			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GPIO71>,
+				 <MT2712_PIN_72_GBE_TXD2__FUNC_GPIO72>,
+				 <MT2712_PIN_73_GBE_TXD1__FUNC_GPIO73>,
+				 <MT2712_PIN_74_GBE_TXD0__FUNC_GPIO74>,
+				 <MT2712_PIN_75_GBE_TXC__FUNC_GPIO75>,
+				 <MT2712_PIN_76_GBE_TXEN__FUNC_GPIO76>;
+		};
+		rx_pins {
+			pinmux = <MT2712_PIN_78_GBE_RXD3__FUNC_GPIO78>,
+				 <MT2712_PIN_79_GBE_RXD2__FUNC_GPIO79>,
+				 <MT2712_PIN_80_GBE_RXD1__FUNC_GPIO80>,
+				 <MT2712_PIN_81_GBE_RXD0__FUNC_GPIO81>,
+				 <MT2712_PIN_82_GBE_RXDV__FUNC_GPIO82>,
+				 <MT2712_PIN_84_GBE_RXC__FUNC_GPIO84>;
+			input-disable;
+		};
+		mdio_pins {
+			pinmux = <MT2712_PIN_85_GBE_MDC__FUNC_GPIO85>,
+				 <MT2712_PIN_86_GBE_MDIO__FUNC_GPIO86>;
+			input-disable;
+			bias-disable;
+		};
+	};
+
 	usb0_id_pins_float: usb0_iddig {
 		pins_iddig {
 			pinmux = <MT2712_PIN_12_IDDIG_P0__FUNC_IDDIG_A>;
diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index 3b12bb313dcdf..4de82e91649f9 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -632,6 +632,71 @@
 		status = "disabled";
 	};
 
+	stmmac_axi_setup: stmmac-axi-config {
+		snps,wr_osr_lmt = <0x7>;
+		snps,rd_osr_lmt = <0x7>;
+		snps,blen = <0 0 0 0 16 8 4>;
+	};
+
+	mtl_rx_setup: rx-queues-config {
+		snps,rx-queues-to-use = <1>;
+		snps,rx-sched-sp;
+		queue0 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x0>;
+			snps,priority = <0x0>;
+		};
+	};
+
+	mtl_tx_setup: tx-queues-config {
+		snps,tx-queues-to-use = <3>;
+		snps,tx-sched-wrr;
+		queue0 {
+			snps,weight = <0x10>;
+			snps,dcb-algorithm;
+			snps,priority = <0x0>;
+		};
+		queue1 {
+			snps,weight = <0x11>;
+			snps,dcb-algorithm;
+			snps,priority = <0x1>;
+		};
+		queue2 {
+			snps,weight = <0x12>;
+			snps,dcb-algorithm;
+			snps,priority = <0x2>;
+		};
+	};
+
+	eth: ethernet@1101c000 {
+		compatible = "mediatek,mt2712-gmac";
+		reg = <0 0x1101c000 0 0x1300>;
+		interrupts = <GIC_SPI 237 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "macirq";
+		mac-address = [00 55 7b b5 7d f7];
+		clock-names = "axi",
+			      "apb",
+			      "mac_main",
+			      "ptp_ref";
+		clocks = <&pericfg CLK_PERI_GMAC>,
+			 <&pericfg CLK_PERI_GMAC_PCLK>,
+			 <&topckgen CLK_TOP_ETHER_125M_SEL>,
+			 <&topckgen CLK_TOP_ETHER_50M_SEL>;
+		assigned-clocks = <&topckgen CLK_TOP_ETHER_125M_SEL>,
+				  <&topckgen CLK_TOP_ETHER_50M_SEL>;
+		assigned-clock-parents = <&topckgen CLK_TOP_ETHERPLL_125M>,
+					 <&topckgen CLK_TOP_APLL1_D3>;
+		power-domains = <&scpsys MT2712_POWER_DOMAIN_AUDIO>;
+		mediatek,pericfg = <&pericfg>;
+		snps,axi-config = <&stmmac_axi_setup>;
+		snps,mtl-rx-config = <&mtl_rx_setup>;
+		snps,mtl-tx-config = <&mtl_tx_setup>;
+		snps,txpbl = <1>;
+		snps,rxpbl = <1>;
+		clk_csr = <0>;
+		status = "disabled";
+	};
+
 	mmc0: mmc@11230000 {
 		compatible = "mediatek,mt2712-mmc";
 		reg = <0 0x11230000 0 0x1000>;
-- 
2.43.0



