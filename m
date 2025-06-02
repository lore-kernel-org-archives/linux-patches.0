Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6FB221D94;
	Mon,  2 Jun 2025 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872768; cv=none; b=PoB3ID1pDh5EfizS13Djtvk4FD9g8bewrE/BoxLc4UoQFIh4IHA6HSjaprKwVPSDiLARzwfhsZ3/4p6cVKjajir+pGwnpJksSvgGiCOiGojQdcM8lZxB+8VTVNdzJONJV0lccGysZnoV0QCogJCG7+2YJWvPCImz+1TiHiTzIjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872768; c=relaxed/simple;
	bh=o+SXJ3/plLxH8wV7jCSuKsF0IHK/i5+RspgZaJQLl7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB2AebyXrW9OdFDTCMMNAspqMyYw5dZpkwPfn3JcPWJxR6GG8V14JYoVFWaPqKCAeH4iNncTs5EDZydAVLbpAmPOvSqjvO3+7ZrYRRtbrAziYywsMWZf66vVqD3u0Ccessgxp6KYcP7m7MrFBvPQ4H5rcm+gGaJ8u2O/6eBKabU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QX3ClcwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QX3ClcwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC67C4CEEB;
	Mon,  2 Jun 2025 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872768;
	bh=o+SXJ3/plLxH8wV7jCSuKsF0IHK/i5+RspgZaJQLl7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QX3ClcwQ8PqkdlZRUgdDKxI19IRdWvf/iPOrzftY22BOrvMk/y9269CBqAmeRs2SI
	 qhGaZQsH0f2NCm1OPuxRt98xsmR7b3WWUnwBXY3AkLDe8+0ZIiZhKUAYPcgHQUWH6v
	 qm8faDebtoo/v8K1Ygb5H+Qol7N0d/mkOVATnGzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 35/73] arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators
Date: Mon,  2 Jun 2025 15:47:21 +0200
Message-ID: <20250602134243.081435836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -184,6 +184,17 @@
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
@@ -211,6 +222,20 @@
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
 	transceiver1: can-phy1 {
 		compatible = "ti,tcan1042";
 		#phy-cells = <0>;
@@ -613,6 +638,12 @@
 		>;
 	};
 
+	vdd_sd_dv_pins_default: vdd-sd-dv-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x1dc, PIN_OUTPUT, 7) /* (Y1) SPI1_CLK.GPIO0_118 */
+		>;
+	};
+
 	wkup_uart0_pins_default: wkup-uart0-default-pins {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0xa0, PIN_INPUT, 0) /* (J29) WKUP_UART0_RXD */


