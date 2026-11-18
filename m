Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055034;
	b=j+X/r6AA7Qy1crDojkFuiN+L/Bgasn3a4+iaXDmVlskYT9AKtv7RlUzqnLcSUs9ZAB58
	 su6sOrhlftHD1H6UUM3YJp5Nb6hFcqqZKovNjqSQloUwMrTGQpK5rVmDNGcSIM3Bazmng
	 24obTtDVtofm5PGyofYUuza/raHWkAt1m29gWsTxVZeWbWwXBwUgrFUcptbU3ESCsMqwu
	 Pf+Vxze8S2FzyEv3q6UyixVfUZZ2f2MsROgycF8aYDSBWujR08HX4pYfDPBqHNZF0+a+o
	 Dgmyn2NHKycoJAy/ibcAeVcEZ5yQ6R7BoJQtmYj/jehtEfHcuiWA1dYqZEJpAKOQKhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhSPoflr1WI3wXEX4Ci+SObOW1JlIIx39hDfVS6O7ds=;
	b=UQdrdeJZeIpIAR30TQKAkx375Dau+fPkEmhIqlrCsGA8Lf6emWZd7Vh4QZw5qOI0l064
	 wMN+kDPPPXRm3iy30icYM4csfO/6yOj90rPnifBLNj42Smd2pXWRgeXfo5NReJoqYjzrf
	 vNYyzvsaVWIlebFNHsVCVSaxFUQwr45EyMV2gv6Mtlp2YgD36SWoJKMYNpdu4yvJbgV3h
	 Mr2fDMV5znBHTeeUnaEiCkdx8348cVs2BP/qJ+SUlH7sp9QsZI681bJ8cKK2HE+LShFAZ
	 xHAOFbMl59pluEUw9t0te7PCjVeznlxRTGWPNfsTnuDQLDc211rmWQedc0k21mt+wPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VX6JZYca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5F560A2603;
	Thu, 19 Nov 2026 02:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VX6JZYca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DC61F000C4;
	Thu, 19 Nov 2026 02:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055034;
	bh=AhSPoflr1WI3wXEX4Ci+SObOW1JlIIx39hDfVS6O7ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VX6JZYcaIv0lKzYnQCEf38qU2wd4PBjm8WAi8S1JTsuSDpiaXxuqakC9Rdhexg/lF
	 JGQGgd/UkhyMj6BmdZhUWbK7wGu2kQiU6eW08gUdCayeNA3YJWndv2CEAe/+VT/Rz2
	 DS5yjgCQ64zJDd52IguFLqE4O/20e8VZNI6p5eIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1487/2214] ARM: dts: imx7-tqma7: add SPI-NOR flash
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150110.721198644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



