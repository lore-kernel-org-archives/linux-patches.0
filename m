Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039976;
	b=NYUOc8rY4qoH2fC5GMvsllj7pD5Len3Ysrw4af/6s6G4B+xiLiDkD/1QJ7VogVCsYuoX
	 w+e1cElO4Owc8TvDrrRhcvpaZ/OHMT/7HG+NXm+O28Ep2oyok03tQ6mpDwMqkV8qTdhjO
	 LltfaPjRPI6kJjwuiCnsfzlWuLOa+ep3i+Wbdy+TScQTLCINiwem2qgOCF5bkssmUrWC/
	 VXWBCLvJMWLbKNWTD2HDxQEzBFbTNbBdsn5aKMq3nZ0tsh0/zw7u2RTrXjWC+TJyY2S9u
	 cFAzmeC3vz7Ary71IvgHj+DfI2k6bg6XgSlynMFgbnzjRBTWPz1xcH2d5oXj5vrsSOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQwrmWBGlbSMUS+NSryuhUHYDPz5Fat2hYvryyxCGhI=;
	b=uGWnmZJF/MOSpM9AEdr+pi9QxxpdIEn7DPcfyEK5KjfRF8vgedmlassdQvbYFnQy7sua
	 ESmdi+QqBJbrRKarSIyB5pbRm2xRiHkX9mafXjz7ewDDpD3Jl5U390Xt55+64eZ2LeVM8
	 898KhXeP6yYys6dZkzQw5Nu2b+5ThHdhAp4Zvpfq+Y5i+0ntLLW1y43NlidD0Vk9vrzJ3
	 YY4yy97M1xL5TxDDMb9dYtpmggTK+eXh/mQL45glgxU7cE+CDaYiIl6adb6TA+2kRDwkS
	 9j3LSs6g8UjPFGo7zRJ55VMMh87HSNiM2L4HM3ENgy/5UCntUY+52c5i0P5PW/8rDqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoLTiMOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7E606A325;
	Wed, 18 Nov 2026 22:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoLTiMOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4871F000C4;
	Wed, 18 Nov 2026 22:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039975;
	bh=hQwrmWBGlbSMUS+NSryuhUHYDPz5Fat2hYvryyxCGhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoLTiMOaX1GTAcMA0DuE2CE20i7r2WFP4nSNnl63RhhEKIOeMP2XQqzBq0J6fYmUf
	 NnNufL9zydbu7nrTBe+zB3UVyPxMD9gkdHk2rpUU11r1L6bDEn5vTxft9jsav1DmDv
	 i0QZty58zPviBz4G5GlVqRiHUCgrppj42SjZyKWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2292/3318] arm64: dts: ti: verdin-am62: add support for Verdin USB1 interface
Date: Wed, 18 Nov 2026 15:48:34 +0100
Message-ID: <20261118150430.499777404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

[ Upstream commit 4543e286649e327691699c51420e524bf5d27a14 ]

Add support for Verdin USB1 interface, implements role switch
functionality using "gpio-usb-b-connector", VBUS is also now
controlled with "regulator-fixed" using a standard GPIO.

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240209130106.38739-1-andrejs.cainikovs@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 11a51e82e1f9 ("arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 55 +++++++++++++++++-----
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 466a214a165f3..fc43b5c673033 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -42,6 +42,22 @@ aliases {
 		usb1 = &usb1;
 	};
 
+	connector {
+		compatible = "gpio-usb-b-connector", "usb-b-connector";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usb0_id>;
+		id-gpios = <&main_gpio1 19 GPIO_ACTIVE_HIGH>;
+		label = "USB_1";
+		self-powered;
+		vbus-supply = <&reg_usb0_vbus>;
+
+		port {
+			usb_dr_connector: endpoint {
+				remote-endpoint = <&usb0_ep>;
+			};
+		};
+	};
+
 	verdin_gpio_keys: gpio-keys {
 		compatible = "gpio-keys";
 		pinctrl-names = "default";
@@ -151,6 +167,18 @@ reg_sdhc1_vqmmc: regulator-sdhci1-vqmmc {
 		vin-supply = <&reg_sd_3v3_1v8>;
 	};
 
+	reg_usb0_vbus: regulator-usb0-vbus {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usb0_en>;
+		enable-active-high;
+		/* Verdin USB_1_EN (SODIMM 155) */
+		gpio = <&main_gpio1 50 GPIO_ACTIVE_HIGH>;
+		regulator-max-microvolt = <5000000>;
+		regulator-min-microvolt = <5000000>;
+		regulator-name = "USB_1_EN";
+	};
+
 	reserved-memory {
 		#address-cells = <2>;
 		#size-cells = <2>;
@@ -429,6 +457,13 @@ AM62X_IOPAD(0x0244, PIN_INPUT_PULLUP, 7) /* (C17) MMC1_SDWP.GPIO1_49 */ /* SODIM
 		>;
 	};
 
+	/* Verdin USB_1_EN */
+	pinctrl_usb0_en: main-gpio1-50-default-pins {
+		pinctrl-single,pins = <
+			AM62X_IOPAD(0x0254, PIN_INPUT, 7) /* (C20) USB0_DRVVBUS.GPIO1_50 */ /* SODIMM 155 */
+		>;
+	};
+
 	/* On-module I2C - PMIC_I2C */
 	pinctrl_i2c0: main-i2c0-default-pins {
 		pinctrl-single,pins = <
@@ -647,13 +682,6 @@ AM62X_IOPAD(0x0038, PIN_OUTPUT,       5) /* (E24) OSPI0_CSn3.UART5_TXD    */ /*
 		>;
 	};
 
-	/* Verdin USB_1 */
-	pinctrl_usb0: main-usb0-default-pins {
-		pinctrl-single,pins = <
-			AM62X_IOPAD(0x0254, PIN_OUTPUT, 0) /* (C20) USB0_DRVVBUS */ /* SODIMM 155 */
-		>;
-	};
-
 	/* Verdin USB_2 */
 	pinctrl_usb1: main-usb1-default-pins {
 		pinctrl-single,pins = <
@@ -1000,7 +1028,7 @@ &main_gpio1 {
 		"",
 		"",
 		"SODIMM_17",
-		"", /* 50 */
+		"SODIMM_155", /* 50 */
 		"",
 		"",
 		"",
@@ -1411,11 +1439,16 @@ &usbss0 {
 	status = "disabled";
 };
 
-/* TODO: role swich using ID pin */
 &usb0 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_usb0>, <&pinctrl_usb0_id>;
+	adp-disable;
+	usb-role-switch;
 	status = "disabled";
+
+	port {
+		usb0_ep: endpoint {
+			remote-endpoint = <&usb_dr_connector>;
+		};
+	};
 };
 
 /* Verdin USB_2 */
-- 
2.53.0



