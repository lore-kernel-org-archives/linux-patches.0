Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B48A1FE467;
	Tue,  3 Dec 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240529; cv=none; b=VbCrIvpypKu08EqTVJuU7LLGhPwJIIV91JYHPiT+6eoaYdMnJHA2I7UtKaBCVmmOqLzT+/ihC3yv9AR0uPe/TyC0o5wKG+Z/4wvVcZb4FCNwmiHNjB3NqeOk2yyqODNHjCmc22dQNkFCubNZeKTGVSUh2ICyzqLiQnqZCRYgYqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240529; c=relaxed/simple;
	bh=Tnd406yWuNk8qNx6PgxHsPGrWNQG3lnIbA/xCt/LLu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU2uBdSbKhGljeiFWcjxJ0qtczNAZXyPUncbFrjZEvHsROJDk95bbWYKgH7XGQfwwvLWt8ACKZyD8qZEoHkAgGKgWfMd7g7LnGH2IAfY0S52uJGA+jr1Zjt+BZ/Kf6Uml24ggnhBd0Kbb+qzpYVuKtQF3T+zv/UZ3RTkkwTAjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adSTNtOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adSTNtOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1150BC4CECF;
	Tue,  3 Dec 2024 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240529;
	bh=Tnd406yWuNk8qNx6PgxHsPGrWNQG3lnIbA/xCt/LLu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adSTNtOhTRkOc4PNpcG7QKhR+0SrG2c0Si07lTF090ypdfCNbvRLLJwIUq+6CZXKS
	 ydRQPMykR3aqWXDnWIRaje5/8zGQybylP22vS+Qtq9nDxZQVc43Urh0IftKcuJAFQn
	 WGOVKWp+H+rEzp5PQbOax6S00aL13W/sAaQtB87k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/826] arm64: dts: mediatek: mt8183-kukui-jacuzzi: Fix DP bridge supply names
Date: Tue,  3 Dec 2024 15:38:09 +0100
Message-ID: <20241203144750.058122584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c4e8cf13f1740037483565d5b802764e2426515b ]

Some of the regulator supplies for the MIPI-DPI-to-DP bridge and their
associated nodes are incorrectly named. In particular, the 1.0V supply
was modeled as a 1.2V supply.

Fix all the incorrect names, and also fix the voltage of the 1.0V
regulator.

Fixes: cabc71b08eb5 ("arm64: dts: mt8183: Add kukui-jacuzzi-damu board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241030070224.1006331-3-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi.dtsi    | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
index 783c333107bcb..ac7ec0676e147 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi
@@ -8,11 +8,13 @@
 #include <arm/cros-ec-keyboard.dtsi>
 
 / {
-	pp1200_mipibrdg: pp1200-mipibrdg {
+	pp1000_mipibrdg: pp1000-mipibrdg {
 		compatible = "regulator-fixed";
-		regulator-name = "pp1200_mipibrdg";
+		regulator-name = "pp1000_mipibrdg";
+		regulator-min-microvolt = <1000000>;
+		regulator-max-microvolt = <1000000>;
 		pinctrl-names = "default";
-		pinctrl-0 = <&pp1200_mipibrdg_en>;
+		pinctrl-0 = <&pp1000_mipibrdg_en>;
 
 		enable-active-high;
 		regulator-boot-on;
@@ -24,7 +26,7 @@ pp1800_mipibrdg: pp1800-mipibrdg {
 		compatible = "regulator-fixed";
 		regulator-name = "pp1800_mipibrdg";
 		pinctrl-names = "default";
-		pinctrl-0 = <&pp1800_lcd_en>;
+		pinctrl-0 = <&pp1800_mipibrdg_en>;
 
 		enable-active-high;
 		regulator-boot-on;
@@ -46,11 +48,11 @@ pp3300_panel: pp3300-panel {
 		gpio = <&pio 35 GPIO_ACTIVE_HIGH>;
 	};
 
-	vddio_mipibrdg: vddio-mipibrdg {
+	pp3300_mipibrdg: pp3300-mipibrdg {
 		compatible = "regulator-fixed";
-		regulator-name = "vddio_mipibrdg";
+		regulator-name = "pp3300_mipibrdg";
 		pinctrl-names = "default";
-		pinctrl-0 = <&vddio_mipibrdg_en>;
+		pinctrl-0 = <&pp3300_mipibrdg_en>;
 
 		enable-active-high;
 		regulator-boot-on;
@@ -146,9 +148,9 @@ anx_bridge: anx7625@58 {
 		pinctrl-0 = <&anx7625_pins>;
 		enable-gpios = <&pio 45 GPIO_ACTIVE_HIGH>;
 		reset-gpios = <&pio 73 GPIO_ACTIVE_HIGH>;
-		vdd10-supply = <&pp1200_mipibrdg>;
+		vdd10-supply = <&pp1000_mipibrdg>;
 		vdd18-supply = <&pp1800_mipibrdg>;
-		vdd33-supply = <&vddio_mipibrdg>;
+		vdd33-supply = <&pp3300_mipibrdg>;
 
 		ports {
 			#address-cells = <1>;
@@ -391,14 +393,14 @@ &pio {
 		"",
 		"";
 
-	pp1200_mipibrdg_en: pp1200-mipibrdg-en {
+	pp1000_mipibrdg_en: pp1000-mipibrdg-en {
 		pins1 {
 			pinmux = <PINMUX_GPIO54__FUNC_GPIO54>;
 			output-low;
 		};
 	};
 
-	pp1800_lcd_en: pp1800-lcd-en {
+	pp1800_mipibrdg_en: pp1800-mipibrdg-en {
 		pins1 {
 			pinmux = <PINMUX_GPIO36__FUNC_GPIO36>;
 			output-low;
@@ -460,7 +462,7 @@ trackpad-int {
 		};
 	};
 
-	vddio_mipibrdg_en: vddio-mipibrdg-en {
+	pp3300_mipibrdg_en: pp3300-mipibrdg-en {
 		pins1 {
 			pinmux = <PINMUX_GPIO37__FUNC_GPIO37>;
 			output-low;
-- 
2.43.0



