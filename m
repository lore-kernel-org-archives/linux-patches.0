Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015524;
	b=unk2S0KjOkeSW+/6+JDXpxLjjW3I0/Prw6+RN+yBckeyJnHr2cANPrf8RnQicFQlStwv
	 Bq0pCgT/iO0KBrY/tB+l/N792G3Bj60adTtD/WDa0kq+8/Eg/538oR/XGqYrR5CLYoJ3b
	 Ze+bDaFMcO0bZrEQLalZpDorqONi6MvbZvvck0i4OH/QTKj0oAZXDmbQa/kAkc3UJ0r+9
	 bL44BlZFENcF07AOczDSIIZOgj03E3JhhcDhkAT56xDEFTWdGoMLL2bchxg30XVE3xUhK
	 89YeYplzDUiKbHepHnj15eh+Nge1tb3KwWz4kx2aqCUjW61kGo5lVtozHYlfNobCcBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0pr9RzAhhJhO5Zxbg7SzUpyqVOZ/Hubb3r+tav8rPs=;
	b=rsuSKvlUVp/crZGKihiC23PqLxpbdBIVPA0ZpoS+gSZFgBK62PQvXfg9MTErogArfNMo
	 abGP5svZJ30xuy4B7ctAHUGp+h9k9CMuYvThBh8z5fQTFh18q7a/yjV/E5QnEYN7ZhlWl
	 YtGRIrPI5HEbo4oxz503FEgLyW9Qeu3UbGijqkSvYhTC6yv56gdA/ZuYr14W0301FIXl9
	 o2YVTsOP75iETSh+PsZH13KLxkiTFlEtfkXmSkmJA7kJrX4Edn8wjz9Rm8cPAU7gBgdTV
	 kGqqDqxqHUWMCLfaxRDEbxZaGs3B191oXLgdbHAwnzg/d3N4gDh1w2RrhMdJadra8Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTGB3VPH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CCF60A2627;
	Wed, 18 Nov 2026 15:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTGB3VPH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D361F000C5;
	Wed, 18 Nov 2026 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015524;
	bh=A0pr9RzAhhJhO5Zxbg7SzUpyqVOZ/Hubb3r+tav8rPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTGB3VPHWc/pTNzE0KaLc9HpVY5AIthIKw2wZjjXZTdpAO2ispYwGqxa/6r/rnB3n
	 7la8wnu9elW2FsvO3PmJ6bJItb3n1l5Qzzgaus43cHKdU/nhceRXQglSrM1m8Fn/0g
	 IcCNQVvGHN9LeLioxirdaU4xZBVIXkF4hej6xg2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Andrea della Porta <andrea.porta@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0202/2651] arm64: dts: broadcom: bcm2712: adjust display status
Date: Wed, 18 Nov 2026 15:24:02 +0100
Message-ID: <20261118150255.135606079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 1cda59c6790be4ae93c76bffd81a003b88083ae9 ]

Typically non critical IP in a SoC are disabled by
default in the SoC .dtsi and enabled on board specific
configs. There are usecases, such as some CM5 carrier
boards, where display output may not be desired or
connected. So disable them on the SoC .dtsi and enable
them on the RPi5 board.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.com>
Cc: Andrea della Porta <andrea.porta@suse.com>
Fixes: 25d77bdd7df2 ("arm64: dts: broadcom: Add display pipeline support to BCM2712")
Link: https://lore.kernel.org/r/20260801165430.598302-1-pbrobinson@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/broadcom/bcm2712-rpi-5-b-base.dtsi    | 35 +++++++++++++++++++
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi     | 11 ++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-base.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-base.dtsi
index b7a6bc34ae1ab..d998bfae91acb 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-base.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-base.dtsi
@@ -104,6 +104,18 @@ wl_on_reg: wl-on-reg {
 	};
 };
 
+&ddc0 {
+	status = "okay";
+};
+
+&ddc1 {
+	status = "okay";
+};
+
+&disp_intr {
+	status = "okay";
+};
+
 &pinctrl {
 	bt_shutdown_default: bt-shutdown-default-state {
 		function = "gpio";
@@ -230,16 +242,27 @@ bluetooth: bluetooth {
 &hvs {
 	clocks = <&firmware_clocks 4>, <&firmware_clocks 16>;
 	clock-names = "core", "disp";
+	status = "okay";
 };
 
 &hdmi0 {
 	clocks = <&firmware_clocks 13>, <&firmware_clocks 14>, <&dvp 0>, <&clk_27MHz>;
 	clock-names = "hdmi", "bvb", "audio", "cec";
+	status = "okay";
 };
 
 &hdmi1 {
 	clocks = <&firmware_clocks 13>, <&firmware_clocks 14>, <&dvp 1>, <&clk_27MHz>;
 	clock-names = "hdmi", "bvb", "audio", "cec";
+	status = "okay";
+};
+
+&mop {
+	status = "okay";
+};
+
+&moplet {
+	status = "okay";
 };
 
 &pcie1 {
@@ -250,6 +273,18 @@ &pcie2 {
 	status = "okay";
 };
 
+&pixelvalve0 {
+	status = "okay";
+};
+
+&pixelvalve1 {
+	status = "okay";
+};
+
 &v3d {
 	clocks = <&firmware_clocks 5>;
 };
+
+&vc4 {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 45aa8ec5e2b1f..a2c71a4355bff 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -359,12 +359,14 @@ pixelvalve0: pixelvalve@7c410000 {
 			compatible = "brcm,bcm2712-pixelvalve0";
 			reg = <0x7c410000 0x100>;
 			interrupts = <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
 		};
 
 		pixelvalve1: pixelvalve@7c411000 {
 			compatible = "brcm,bcm2712-pixelvalve1";
 			reg = <0x7c411000 0x100>;
 			interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
 		};
 
 		mop: mop@7c500000 {
@@ -372,6 +374,7 @@ mop: mop@7c500000 {
 			reg = <0x7c500000 0x28>;
 			interrupt-parent = <&disp_intr>;
 			interrupts = <1>;
+			status = "disabled";
 		};
 
 		moplet: moplet@7c501000 {
@@ -379,6 +382,7 @@ moplet: moplet@7c501000 {
 			reg = <0x7c501000 0x20>;
 			interrupt-parent = <&disp_intr>;
 			interrupts = <0>;
+			status = "disabled";
 		};
 
 		disp_intr: interrupt-controller@7c502000 {
@@ -387,6 +391,7 @@ disp_intr: interrupt-controller@7c502000 {
 			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
+			status = "disabled";
 		};
 
 		dvp: clock@7c700000 {
@@ -405,6 +410,7 @@ ddc0: i2c@7d508200 {
 			clock-frequency = <97500>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			status = "disabled";
 		};
 
 		ddc1: i2c@7d508280 {
@@ -415,6 +421,7 @@ ddc1: i2c@7d508280 {
 			clock-frequency = <97500>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			status = "disabled";
 		};
 
 		bsc_irq: interrupt-controller@7d508380 {
@@ -460,6 +467,7 @@ hdmi0: hdmi@7c701400 {
 			interrupt-names = "cec-tx", "cec-rx", "cec-low",
 					  "hpd-connected", "hpd-removed";
 			ddc = <&ddc0>;
+			status = "disabled";
 		};
 
 		hdmi1: hdmi@7c706400 {
@@ -489,6 +497,7 @@ hdmi1: hdmi@7c706400 {
 			interrupt-names = "cec-tx", "cec-rx", "cec-low",
 					  "hpd-connected", "hpd-removed";
 			ddc = <&ddc1>;
+			status = "disabled";
 		};
 	};
 
@@ -667,6 +676,7 @@ v3d: gpu@1002000000 {
 
 	vc4: gpu {
 		compatible = "brcm,bcm2712-vc6";
+		status = "disabled";
 	};
 
 	timer {
@@ -701,5 +711,6 @@ hvs: hvs@107c580000 {
 		interrupt-parent = <&disp_intr>;
 		interrupts = <2>, <9>, <16>;
 		interrupt-names = "ch0-eof", "ch1-eof", "ch2-eof";
+		status = "disabled";
 	};
 };
-- 
2.53.0



