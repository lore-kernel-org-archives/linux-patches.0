Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8B12C52C;
	Tue, 30 Apr 2024 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473999; cv=none; b=gAHM6YpCziB7qnVyGoLbfy/lgw3MOV9SHzal23rLQ/Jp4KQ+lxQ+ID1QM1QTG8KKvvo7+D0ZtNMejazZfPM4eE83MqZzPQ7gUdgZfw9f0+5mPLcs/iHPtdj5CxpvxmvV3RNsn4O2lbcd72pWWdKxhfi80SqbQLOhpjhe03Hvd8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473999; c=relaxed/simple;
	bh=uEG18oQ3CidegakZFll4IWVGuivgo/LLPaZfaeVoIes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkPmUx8VVeaecvFHNjs1C3ISSjoKxJzVwmOH8aSemcLY6TH8MfNaeI7YzeotxaAQ8QC//vmU0QmawBEO4H4NeSH60lxSIexAvu04e1JZ6OuHyitL/PClH/Ge/LQzjk4pYi4BKo6aPFjWaP6knX+aX01wc/dyKadJ0azIUhAHW3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFx4eUYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFx4eUYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EF2C4AF14;
	Tue, 30 Apr 2024 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473999;
	bh=uEG18oQ3CidegakZFll4IWVGuivgo/LLPaZfaeVoIes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFx4eUYh9utUbYotsm8i4UOKfbNJUIfn3/9Q71yb/F1wUzb/70bCovFMAA30KpgPS
	 vGSicrYF1ECFC3ElqA5CtWX/aF6MxdX0gF1FUPOnf1XDxgayGfHQ0cNoW9ZbPRBONV
	 iy6vLxmM+mRDaSCGfGjIHCqEiZzSWJ3DniGDIg/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 031/228] arm64: dts: mediatek: mt2712: fix validation errors
Date: Tue, 30 Apr 2024 12:36:49 +0200
Message-ID: <20240430103104.715094620@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3baac7291effb501c4d52df7019ebf52011e5772 ]

1. Fixup infracfg clock controller binding
   It also acts as reset controller so #reset-cells is required.
2. Use -pins suffix for pinctrl

This fixes:
arch/arm64/boot/dts/mediatek/mt2712-evb.dtb: syscon@10001000: '#reset-cells' is a required property
        from schema $id: http://devicetree.org/schemas/arm/mediatek/mediatek,infracfg.yaml#
arch/arm64/boot/dts/mediatek/mt2712-evb.dtb: pinctrl@1000b000: 'eth_default', 'eth_sleep', 'usb0_iddig', 'usb1_iddig' do not match any of the regexes: 'pinctrl-[0-9]+', 'pins$'
        from schema $id: http://devicetree.org/schemas/pinctrl/mediatek,mt65xx-pinctrl.yaml#

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240301074741.8362-1-zajec5@gmail.com
[Angelo: Added Fixes tags]
Fixes: 5d4839709c8e ("arm64: dts: mt2712: Add clock controller device nodes")
Fixes: 1724f4cc5133 ("arm64: dts: Add USB3 related nodes for MT2712")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts | 8 ++++----
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi   | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index fffdb7bbf889e..2d0ef6f23b3a9 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -129,7 +129,7 @@
 };
 
 &pio {
-	eth_default: eth_default {
+	eth_default: eth-default-pins {
 		tx_pins {
 			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GBE_TXD3>,
 				 <MT2712_PIN_72_GBE_TXD2__FUNC_GBE_TXD2>,
@@ -156,7 +156,7 @@
 		};
 	};
 
-	eth_sleep: eth_sleep {
+	eth_sleep: eth-sleep-pins {
 		tx_pins {
 			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GPIO71>,
 				 <MT2712_PIN_72_GBE_TXD2__FUNC_GPIO72>,
@@ -182,14 +182,14 @@
 		};
 	};
 
-	usb0_id_pins_float: usb0_iddig {
+	usb0_id_pins_float: usb0-iddig-pins {
 		pins_iddig {
 			pinmux = <MT2712_PIN_12_IDDIG_P0__FUNC_IDDIG_A>;
 			bias-pull-up;
 		};
 	};
 
-	usb1_id_pins_float: usb1_iddig {
+	usb1_id_pins_float: usb1-iddig-pins {
 		pins_iddig {
 			pinmux = <MT2712_PIN_14_IDDIG_P1__FUNC_IDDIG_B>;
 			bias-pull-up;
diff --git a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
index ed1a9d3194153..f767f921bdee1 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt2712e.dtsi
@@ -249,10 +249,11 @@
 		#clock-cells = <1>;
 	};
 
-	infracfg: syscon@10001000 {
+	infracfg: clock-controller@10001000 {
 		compatible = "mediatek,mt2712-infracfg", "syscon";
 		reg = <0 0x10001000 0 0x1000>;
 		#clock-cells = <1>;
+		#reset-cells = <1>;
 	};
 
 	pericfg: syscon@10003000 {
-- 
2.43.0



