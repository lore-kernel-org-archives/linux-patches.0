Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060573;
	b=3DZY+ZhCUWRyotcbb5lnmPU5mrLaL7brXnAqiXx+spJtrEB6nXnRhzq3Pc786ghPen0g
	 zUSauSV9x7KqWClflo+odLAr9aZv2wHEhAyw3VBmJDfCGCWFDgSllXDeLul4KFCmEMpXw
	 0DZINb179mbo07fRFJUcjnH9nUBmJFvLfg8LGLjlRQt3uN8oE1EMGgit0MU2QoTgBNuPd
	 Hh/3FQ4gcspAxde6GRcrp314uMWEvUNgRbiMiwy1svf57MkbtJj1ifHMFXw8Lv1d1Fl2g
	 64qZJEbthymuh/BhGhUjP94GMqys71/7YHjUx20nGW4XEtpFwGVdy2l+K8QIozntAfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hu6c+DKM9M3IJtRNlPIer9X1c7FiBWS+tXvazqtXHeI=;
	b=bcRKvy+adFEhqMaQGbJ1EnSGH5FFIPKcccZJJ8dWN71sVUOUas38sB63lNtKrSwyWA9e
	 QXQAPe5wsOR3lgEP7UgRQIE7olVZnSniFOAprTsyBIcuBjV81O3MeDRUfVNs1ETaN4bVh
	 19RyGghMWVBWTudWbJmh4FDm7Dj2Qnc0xzvevLvfj/YgsMhoOB0u2Y0lm2B8LcFki0cft
	 7LGUg2L4puaGLnYJC2JkKodpcsDzUiYsSV/InDEVk30xXWRQI+GOx8A8mfxtx9qL2YuO5
	 ELKGXjX8/SLZ/0NwZ26+0Hb+p7gjhXbFLpt2WkDPye12lxaXvb4yWEI3e56QR36+FsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iODMcUn7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC56606A338;
	Thu, 19 Nov 2026 03:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iODMcUn7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3EF1F000C8;
	Thu, 19 Nov 2026 03:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060572;
	bh=Hu6c+DKM9M3IJtRNlPIer9X1c7FiBWS+tXvazqtXHeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iODMcUn74F9mBFOM09Z+L+fmXpR3QEZ1ZGIfJJYQKByOq0jNKgVxxjRzsurcbvtKJ
	 U9ESrjC9OjIrNdkrNllSI1RdVGzGF3ocDtJg9DVb6z8zgTxTKVls+0JvbeWMiDwvQX
	 pTKgMj1vN0+47z55ls3VmzccQeqpK9NjMn1m/soI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1240/1848] ARM: dts: imx7-tqma7: add SPI-NOR flash
Date: Wed, 18 Nov 2026 15:54:38 +0100
Message-ID: <20261118150011.756072790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 61b2f7b15839f5d6b4838a44b6faaff9957e98e7 ]

The SPI-NOR flash on the SoM was missing from the device tree.

The TQMa7 as a designated QSPI_RESET# pin, however depending on the
hardware configuration the pin may be unconnected, or be used for a
different purpose. With this in mind, we mux the pin as a pullup and
define an input hog for it, but keep it a separate pin group, so that it
is easy for dependent Device Trees to modify the configuration.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: f322f8f68c2c ("ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7-tqma7.dtsi | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/imx7-tqma7.dtsi b/arch/arm/boot/dts/imx7-tqma7.dtsi
index 8773344b54aad..22d0eaa4cef79 100644
--- a/arch/arm/boot/dts/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/imx7-tqma7.dtsi
@@ -19,6 +19,16 @@ &cpu0 {
 	cpu-supply = <&sw1a_reg>;
 };
 
+&gpio2 {
+	/* Configured as pullup by QSPI pin group */
+	qspi-reset-hog {
+		gpio-hog;
+		gpios = <4 GPIO_ACTIVE_LOW>;
+		input;
+		line-name = "qspi-reset";
+	};
+};
+
 &i2c1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
@@ -160,6 +170,25 @@ MX7D_PAD_SD2_RESET_B__GPIO5_IO11	0x4000005C
 		>;
 	};
 
+	pinctrl_qspi: qspigrp {
+		fsl,pins = <
+			MX7D_PAD_EPDC_DATA00__QSPI_A_DATA0	0x5A
+			MX7D_PAD_EPDC_DATA01__QSPI_A_DATA1	0x5A
+			MX7D_PAD_EPDC_DATA02__QSPI_A_DATA2	0x5A
+			MX7D_PAD_EPDC_DATA03__QSPI_A_DATA3	0x5A
+			MX7D_PAD_EPDC_DATA05__QSPI_A_SCLK	0x11
+			MX7D_PAD_EPDC_DATA06__QSPI_A_SS0_B	0x54
+			MX7D_PAD_EPDC_DATA07__QSPI_A_SS1_B	0x54
+		>;
+	};
+
+	pinctrl_qspi_reset: qspi_resetgrp {
+		fsl,pins = <
+			/* #QSPI_RESET */
+			MX7D_PAD_EPDC_DATA04__GPIO2_IO4		0x52
+		>;
+	};
+
 	pinctrl_usdhc3: usdhc3grp {
 		fsl,pins = <
 			MX7D_PAD_SD3_CMD__SD3_CMD		0x59
@@ -217,6 +246,20 @@ MX7D_PAD_LPSR_GPIO1_IO00__WDOG1_WDOG_B	0x30
 	};
 };
 
+&qspi {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_qspi &pinctrl_qspi_reset>;
+	status = "okay";
+
+	flash0: flash@0 {
+		compatible = "jedec,spi-nor";
+		reg = <0>;
+		spi-max-frequency = <29000000>;
+		spi-rx-bus-width = <4>;
+		spi-tx-bus-width = <4>;
+	};
+};
+
 &sdma {
 	status = "okay";
 };
-- 
2.53.0



