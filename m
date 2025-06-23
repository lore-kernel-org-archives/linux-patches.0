Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170B22370A;
	Mon, 23 Jun 2025 22:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717671; cv=none; b=gcRfBrywbQgSbmMvARC+PhPxKXWismNn2ocKvpr48rf3QzGC430eXPsURrefeTzaYz6vsr/4oY6umlT7v/1O6uiJ3VcWfjrOxndU3iL9lgyibBDlIOnw27ZuH4cOAiAyAhG/Ab8BQobgc4zaHXsY69/h9WNlTxxbedSqKu5EUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717671; c=relaxed/simple;
	bh=1yNHkV2VaoPD9Qr2ijYhOLNZyWurtihfXmB6B15w4Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0FK09H+wn8EDmnSip+Nv7PUV2OKQ7JV8fUBQclmG+gwJeEpSJkUTKxBxdcGyMqP47l4e6UsL8jjYVjPh2zk2QF6zuCsrDEJmGGeBf9/NQ1S0nwMZyzi6RgFB+zBRweR4exVCka4utPCuxwmu0supDXTzVQ90vKkQPaIkSlC4Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmdD2VCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmdD2VCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF36C4CEEA;
	Mon, 23 Jun 2025 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717671;
	bh=1yNHkV2VaoPD9Qr2ijYhOLNZyWurtihfXmB6B15w4Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmdD2VCckKehyg1nLSme4gVkT9woFjqtOIY0ViIXodq62lyiLVvNzEFzZwN81xuq1
	 3V7OfLSU6Lw3Wg6YbSB9/ZOrGrE3ocmbjZe6jl/tt6EZr3Lrf52dIa6Ls2VU/+Nsqt
	 rkUM86kM3H0uVvGjXzS7ceiADJb2W3zAWnEiVkLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.1 497/508] arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators
Date: Mon, 23 Jun 2025 15:09:02 +0200
Message-ID: <20250623130657.251329816@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 97b67cc102dc2cc8aa39a569c22a196e21af5a21 upstream.

Add device tree nodes for two power regulators on the J721E SK board.
vsys_5v0: A fixed regulator representing the 5V supply output from the
LM61460 and vdd_sd_dv: A GPIO-controlled TLV71033 regulator.

J721E-SK schematics: https://www.ti.com/lit/zip/sprr438

Fixes: 1bfda92a3a36 ("arm64: dts: ti: Add support for J721E SK")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250415111328.3847502-2-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -175,6 +175,17 @@
 		regulator-boot-on;
 	};
 
+	vsys_5v0: fixedregulator-vsys5v0 {
+		/* Output of LM61460 */
+		compatible = "regulator-fixed";
+		regulator-name = "vsys_5v0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&vusb_main>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
 	vdd_mmc1: fixedregulator-sd {
 		compatible = "regulator-fixed";
 		pinctrl-names = "default";
@@ -202,6 +213,20 @@
 			 <3300000 0x1>;
 	};
 
+	vdd_sd_dv: gpio-regulator-TLV71033 {
+		compatible = "regulator-gpio";
+		pinctrl-names = "default";
+		pinctrl-0 = <&vdd_sd_dv_pins_default>;
+		regulator-name = "tlv71033";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <3300000>;
+		regulator-boot-on;
+		vin-supply = <&vsys_5v0>;
+		gpios = <&main_gpio0 118 GPIO_ACTIVE_HIGH>;
+		states = <1800000 0x0>,
+			 <3300000 0x1>;
+	};
+
 	dp_pwr_3v3: fixedregulator-dp-prw {
 		compatible = "regulator-fixed";
 		regulator-name = "dp-pwr";
@@ -455,6 +480,12 @@
 		>;
 	};
 
+	vdd_sd_dv_pins_default: vdd-sd-dv-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x1dc, PIN_OUTPUT, 7) /* (Y1) SPI1_CLK.GPIO0_118 */
+		>;
+	};
+
 	wkup_i2c0_pins_default: wkup-i2c0-pins-default {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0xf8, PIN_INPUT_PULLUP, 0) /* (J25) WKUP_I2C0_SCL */


