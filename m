Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7DE46D2A4;
	Tue, 21 Jul 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654019; cv=none; b=gzkQUHgVfqTWG5W07529RW43PBd4LUlV51kN2bSEGPW8gOb0HKnpjgExZMSXV0LaAnABdqxK2ZqhlmlSkScG5hauYA8upGqaZw+BYJwy8BWN32Lu3y8NG9xMlUEyT5DiyITuBolq3bUAW/B+yUoS9PYhZotziRkVbP7e8TpMvIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654019; c=relaxed/simple;
	bh=C4oVVLRqM00D7ukF2Px4DttINlZFFK380zSBdeU2cjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqT/M3tkQMrZPWKXg6lVdhVspRXclM6AQieE+m9AWtrzRskFLU6kx5RX/F1exHm+K8ATjbxtM0PB3co1dL3zqkKU3ECtuvOf8fbzxb7df7AVssEb4Wb4u+zvh9yj/GWq2gvLOlsvNXfUlbWKY1AxUCOdRwmmr1ZQmEmgHEwUnpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NP5K1SCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NP5K1SCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820FD1F00A3A;
	Tue, 21 Jul 2026 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654018;
	bh=FGdJItu8t3aYwcnkwoTNifAGuaHatbWg8CCPrtyFJC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NP5K1SCM1nKi+wm1QXKdK6YvVwCl+SWNzKcvEor3LpbGxtfhQ8QyEmv4IV9NUwEOG
	 ET/BPsEFTK0K2/yyG9XC0xcnoRuvfzUN3pCi5ylVWMYiQ00WijpAZ4heQKuc6nx7ak
	 JcazUf5Rp3mG406opnyCt19LTNyWvHnGr6t6INX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 7.1 1546/2077] ARM: dts: stm32: stm32mp15x-mecio1-io: Move expander gpio-line-names to board files
Date: Tue, 21 Jul 2026 17:20:19 +0200
Message-ID: <20260721152629.240440923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit a0d6c2a06fffff47bcca4d5bfdab4cc428a315fc upstream.

Move the gpio-line-names properties for the I2C GPIO expanders (gpio0
and gpio1) out of the common mecio1-io.dtsi file and into the specific
board dts files.

The layout originally defined in the common include file belonged to the
mecio1r1 (Revision 1) hardware. This layout is moved 1:1 into the
stm32mp153c-mecio1r1.dts file.

The mecio1r0 (Revision 0) hardware utilizes a completely different
pinout for these expanders. A new, accurate mapping reflecting the
Revision 0 schematics is added to stm32mp151c-mecio1r0.dts.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260318105123.819807-8-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts  |   14 ++++++++++++++
 arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts  |   14 ++++++++++++++
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |    8 --------
 3 files changed, 28 insertions(+), 8 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
+++ b/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
@@ -97,6 +97,20 @@
 	st,eth-clk-sel;
 };
 
+&gpio0 {
+	gpio-line-names = "HSIN0_BIAS", "HSIN1_BIAS", "HSIN2_BIAS", "HSIN3_BIAS",
+			  "HSIN4_BIAS", "", "STP_VREF0_LVL", "HSIN_VREF0_LVL",
+			  "STP0_FB_BIAS", "STP1_FB_BIAS", "STP2_FB_BIAS", "STP3_FB_BIAS",
+			  "", "", "", "";
+};
+
+&gpio1 {
+	gpio-line-names = "HSIN5_BIAS", "HSIN6_BIAS", "HSIN7_BIAS", "HSIN8_BIAS",
+			  "HSIN9_BIAS", "", "STP_VREF1_LVL", "HSIN_VREF1_LVL",
+			  "STP4_FB_BIAS", "STP5_FB_BIAS", "STP6_FB_BIAS", "",
+			  "", "", "LSIN8_BIAS", "LSIN9_BIAS";
+};
+
 &gpiod {
 	gpio-line-names = "", "", "", "",
 			  "", "", "", "",
--- a/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
+++ b/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
@@ -90,6 +90,20 @@
 	clock-frequency = <24000000>;
 };
 
+&gpio0 {
+	gpio-line-names = "HSIN0_BIAS", "HSIN1_BIAS", "HSIN2_BIAS", "HSIN3_BIAS",
+			  "", "", "HSIN_VREF0_LVL", "HSIN_VREF1_LVL",
+			  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN7_BIAS",
+			  "", "", "", "";
+};
+
+&gpio1 {
+	gpio-line-names = "HSIN8_BIAS", "HSIN9_BIAS", "HSIN10_BIAS", "HSIN11_BIAS",
+			  "", "", "HSIN_VREF2_LVL", "HSIN_VREF3_LVL",
+			  "HSIN12_BIAS", "HSIN13_BIAS", "HSIN14_BIAS", "HSIN15_BIAS",
+			  "", "", "LSIN8_BIAS", "LSIN9_BIAS";
+};
+
 &gpioa {
 	gpio-line-names = "", "", "", "",
 			  "", "", "", "",
--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -184,10 +184,6 @@
 		reg = <0x20>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		gpio-line-names = "HSIN0_BIAS", "HSIN1_BIAS", "HSIN2_BIAS", "HSIN3_BIAS",
-				  "", "", "HSIN_VREF0_LVL", "HSIN_VREF1_LVL",
-				  "HSIN4_BIAS", "HSIN5_BIAS", "HSIN6_BIAS", "HSIN7_BIAS",
-				  "", "", "", "";
 	};
 
 	gpio1: gpio@21 {
@@ -195,10 +191,6 @@
 		reg = <0x21>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		gpio-line-names = "HSIN8_BIAS", "HSIN9_BIAS", "HSIN10_BIAS", "HSIN11_BIAS",
-				  "", "", "HSIN_VREF2_LVL", "HSIN_VREF3_LVL",
-				  "HSIN12_BIAS", "HSIN13_BIAS", "HSIN14_BIAS", "HSIN15_BIAS",
-				  "", "", "LSIN8_BIAS", "LSIN9_BIAS";
 	};
 };
 


