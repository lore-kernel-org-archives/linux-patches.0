Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB08912C462;
	Tue, 30 Apr 2024 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474962; cv=none; b=E8SQQwhbf6OVaNGNLQh5q8GJuLDDTGpPLtclbyMfXJ7Gj38p1MjIHKPQNbnhWUcnp9Zl0pBoqQuwKty1hnjudUgphrEZtIF+xYfU0KZ6zX+tQr4eZnTAdkmA5CZSmB/4pJRolMGHdI5JyBerOPUdQUKBZjUfbrH4uN+tVC7XAF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474962; c=relaxed/simple;
	bh=qOv8XcV+4vqMh0HBLphYkNd2C2yDrB5TMlGG1xQLBlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2iOT8nwm5Dtk7Ue09V2mgfdmf7cyjJxfldA/k9nRX1IcIogjlPTcizdcGW2hoSzEyljUi/I2or/EkrrlcJ0Zab40w3LvfGn/T6RKOMMvdVyATjqVtcilAA2DLlSqkWF5ciIHZPD85vvXZYFsr2tgi152mzGYpsjJVyGr61E3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/+jqQ1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/+jqQ1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8C4C2BBFC;
	Tue, 30 Apr 2024 11:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474962;
	bh=qOv8XcV+4vqMh0HBLphYkNd2C2yDrB5TMlGG1xQLBlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/+jqQ1+Yrw7h0rGAPuXf8ee1F7RN7e9Ir1tL1qMIRAtcQFF8rHGEwLloqjoqe3BA
	 K3AaZnsmOhC+drXBve69dKp0NbfsbJScB8Kg7XvqDVTJqMBntjwtjSP0BNwM4L6YkV
	 Xw28Ii1Ox6dt4cPrJ6xFsxusyjo1TJfDYk2u0woI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/138] arm64: dts: mediatek: mt2712: fix validation errors
Date: Tue, 30 Apr 2024 12:39:27 +0200
Message-ID: <20240430103051.836273966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d20cabf4f699..99515c13da3cf 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -127,7 +127,7 @@
 };
 
 &pio {
-	eth_default: eth_default {
+	eth_default: eth-default-pins {
 		tx_pins {
 			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GBE_TXD3>,
 				 <MT2712_PIN_72_GBE_TXD2__FUNC_GBE_TXD2>,
@@ -154,7 +154,7 @@
 		};
 	};
 
-	eth_sleep: eth_sleep {
+	eth_sleep: eth-sleep-pins {
 		tx_pins {
 			pinmux = <MT2712_PIN_71_GBE_TXD3__FUNC_GPIO71>,
 				 <MT2712_PIN_72_GBE_TXD2__FUNC_GPIO72>,
@@ -180,14 +180,14 @@
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
index cc3d1c99517d1..f7ce2eba10f7a 100644
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



