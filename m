Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3B29CE9;
	Tue, 21 Jul 2026 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658491; cv=none; b=S+i/OLse1qgvGKXsS23d5KhrNa3ljzpMKuo4wN6rCT/lfQ4uFcRZBt61dKRtF1LNycBJ+jQPEU7WBeJD3wghp7ok+8pS1HDI9QKK4ZS6EVBA5rfOAO8t7eFd8N09odJjMLfjDbi4Kv2H6ZxZAsgvul/+G0y3JPBxIL7YYQjVkaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658491; c=relaxed/simple;
	bh=RRTDXAi01aejtpK7wFdAL/Q+N0Rc5x9no6xma3wRzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esWrriBMsJmuaNoEPk1pTfeR7pM258qgLvttqY4TOBb3gqATzUZxKUtcoW2zuOor5NbVSeXA8xYuNDce+hD8BRtQQmXbmO2gxKo42yD7LPcCHlx/8vKKQ4IUEoLOQTz6ftpkPkUtvyFcOddBRBGbZ0B+om9AD4ZsFIKPSzJaXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSjkcVp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSjkcVp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AF11F000E9;
	Tue, 21 Jul 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658489;
	bh=SZQiXrBSTj+EI5UXftRG/kwcEY8WzaGD3RG8zhDzggY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSjkcVp/xuy52chnSVL/VnjZ2twUiK5AdTgeGuNVOZwBCdIwmt6xRkgK9XVjOgKgG
	 BkWfn+uglpoMZT6MfpLW0BL+LB1aHmgPB/IUsHCEtK9iBxK5rnKWYD9jXyyLgIdu6B
	 j+ygDtIpuW75vPGi7TLSwn4tYueRfripjrdipedo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1120/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Move gpio-line-names to board files
Date: Tue, 21 Jul 2026 17:20:36 +0200
Message-ID: <20260721152540.611957680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jander <david@protonic.nl>

commit 4f5069609ac99894c0632d8b8c4c016f85199de9 upstream.

Move the gpio-line-names properties out of the common mecio1-io.dtsi file
and into the specific board dts files.

The pinout originally defined in the common include file belonged to the
mecio1r0 (Revision 0) hardware. This is moved 1:1 into the
stm32mp151c-mecio1r0.dts file without any modifications.

A large number of GPIO pins are swapped on the mecio1r1 (Revision 1)
hardware, so a new, board-specific gpio-line-names mapping is added to
stm32mp153c-mecio1r1.dts to reflect those hardware changes.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-6-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts  |   64 ++++++++++++++++++++
 arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts  |   80 +++++++++++++++++++++++++
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |   63 -------------------
 3 files changed, 144 insertions(+), 63 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
+++ b/arch/arm/boot/dts/st/stm32mp151c-mecio1r0.dts
@@ -96,3 +96,67 @@
 	assigned-clock-rates = <125000000>; /* Clock PLL3 to 625Mhz in tf-a. */
 	st,eth-clk-sel;
 };
+
+&gpiod {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "", "", "", "",
+			  "STP_RESETN", "STP_ENABLEN", "HPOUT0", "HPOUT0_ALERTN";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_hog_d_mecsbc>;
+};
+
+&gpioe {
+	gpio-line-names = "HPOUT0_RESETN", "HPOUT1", "HPOUT1_ALERTN", "",
+			  "", "", "HPOUT1_RESETN",
+			  "LPOUT0", "LPOUT0_ALERTN", "LPOUT0_RESETN",
+			  "LPOUT1", "LPOUT1_ALERTN", "LPOUT1_RESETN",
+			  "LPOUT2", "LPOUT2_ALERTN", "LPOUT2_RESETN";
+};
+
+&gpiof {
+	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "LPOUT3_RESETN",
+			  "LPOUT4", "LPOUT4_ALERTN", "LPOUT4_RESETN",
+			  "", "",
+			  "", "", "", "",
+			  "", "", "", "";
+};
+
+&gpiog {
+	gpio-line-names = "LPOUT5", "LPOUT5_ALERTN", "", "LPOUT5_RESETN",
+			  "", "", "", "",
+			  "", "", "", "",
+			  "", "", "", "";
+};
+
+&gpioh {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "GPIO0_RESETN", "", "", "",
+			  "", "", "", "";
+};
+
+&gpioi {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "HPDCM0_SLEEPN", "HPDCM1_SLEEPN", "GPIO1_RESETN", "",
+			  "", "", "", "";
+};
+
+&gpioj {
+	gpio-line-names = "HSIN10", "HSIN11", "HSIN12", "HSIN13",
+			  "HSIN14", "HSIN15", "", "",
+			  "", "", "", "",
+			  "", "RTD_RESETN", "", "";
+};
+
+&gpiok {
+	gpio-line-names = "", "", "HSIN0", "HSIN1",
+			  "HSIN2", "HSIN3", "HSIN4", "HSIN5";
+};
+
+&gpioz {
+	gpio-line-names = "", "", "", "HSIN6",
+			  "HSIN7", "HSIN8", "HSIN9", "";
+};
+
--- a/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
+++ b/arch/arm/boot/dts/st/stm32mp153c-mecio1r1.dts
@@ -90,6 +90,86 @@
 	clock-frequency = <24000000>;
 };
 
+&gpioa {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "", "", "GPIO1_RESETN", "",
+			  "", "", "", "LPOUT5";
+};
+
+&gpiob {
+	gpio-line-names = "", "", "", "",
+			  "LPOUT4_RESETN", "", "", "",
+			  "", "LPOUT4_ALERTN", "", "",
+			  "", "", "", "";
+};
+
+&gpioc {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "", "LPOUT4", "", "",
+			  "", "", "", "";
+};
+
+&gpiod {
+	gpio-line-names = "LPOUT2", "", "LPOUT3_RESETN", "",
+			  "LPOUT2_ALERTN", "", "MECIO_ADDR0", "",
+			  "HPOUT1_ALERTN", "HPOUT1_RESETN", "", "",
+			  "", "", "HPOUT0", "HPOUT1";
+};
+
+&gpioe {
+	gpio-line-names = "LPOUT0_RESETN", "", "", "",
+			  "", "LPOUT3", "LPOUT5_ALERTN", "",
+			  "", "", "", "",
+			  "", "", "", "HSIN_RESETN";
+};
+
+&gpiof {
+	gpio-line-names = "LPOUT5_RESETN", "", "", "HPOUT0_ALERTN",
+			  "", "LPOUT1", "", "",
+			  "", "", "", "",
+			  "", "", "", "";
+};
+
+&gpiog {
+	gpio-line-names = "", "", "", "HPOUT0_RESETN",
+			  "", "", "LPOUT3_ALERTN", "",
+			  "", "", "GPIO0_RESETN", "",
+			  "", "", "", "LPOUT2_RESETN";
+};
+
+&gpioh {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "", "LPOUT0", "", "",
+			  "", "LPOUT0_ALERTN", "STP_ENABLEN", "STP_RESETN";
+};
+
+&gpioi {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "",
+			  "", "", "SPE_RESETN", "",
+			  "HPDCM0_SLEEPN", "", "", "";
+};
+
+&gpioj {
+	gpio-line-names = "", "", "", "",
+			  "", "", "", "MECIO_ADDR1",
+			  "", "", "", "",
+			  "", "", "", "LPOUT1_RESETN";
+};
+
+&gpiok {
+	gpio-line-names = "", "", "RTD_RESETN", "",
+			  "", "LPOUT1_ALERTN", "", "";
+};
+
+&gpioz {
+	gpio-line-names = "", "", "", "",
+			  "HPDCM1_SLEEPN", "", "", "";
+};
+
 &m_can1 {
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&m_can1_pins_b>;
--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -173,69 +173,6 @@
 	};
 };
 
-&gpiod {
-	gpio-line-names = "", "", "", "",
-			  "", "", "", "",
-			  "", "", "", "",
-			  "STP_RESETN", "STP_ENABLEN", "HPOUT0", "HPOUT0_ALERTN";
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_hog_d_mecsbc>;
-};
-
-&gpioe {
-	gpio-line-names = "HPOUT0_RESETN", "HPOUT1", "HPOUT1_ALERTN", "",
-			  "", "", "HPOUT1_RESETN",
-			  "LPOUT0", "LPOUT0_ALERTN", "LPOUT0_RESETN",
-			  "LPOUT1", "LPOUT1_ALERTN", "LPOUT1_RESETN",
-			  "LPOUT2", "LPOUT2_ALERTN", "LPOUT2_RESETN";
-};
-
-&gpiof {
-	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "LPOUT3_RESETN",
-			  "LPOUT4", "LPOUT4_ALERTN", "LPOUT4_RESETN",
-			  "", "",
-			  "", "", "", "",
-			  "", "", "", "";
-};
-
-&gpiog {
-	gpio-line-names = "LPOUT5", "LPOUT5_ALERTN", "", "LPOUT5_RESETN",
-			  "", "", "", "",
-			  "", "", "", "",
-			  "", "", "", "";
-};
-
-&gpioh {
-	gpio-line-names = "", "", "", "",
-			  "", "", "", "",
-			  "GPIO0_RESETN", "", "", "",
-			  "", "", "", "";
-};
-
-&gpioi {
-	gpio-line-names = "", "", "", "",
-			  "", "", "", "",
-			  "HPDCM0_SLEEPN", "HPDCM1_SLEEPN", "GPIO1_RESETN", "",
-			  "", "", "", "";
-};
-
-&gpioj {
-	gpio-line-names = "HSIN10", "HSIN11", "HSIN12", "HSIN13",
-			  "HSIN14", "HSIN15", "", "",
-			  "", "", "", "",
-			  "", "RTD_RESETN", "", "";
-};
-
-&gpiok {
-	gpio-line-names = "", "", "HSIN0", "HSIN1",
-			  "HSIN2", "HSIN3", "HSIN4", "HSIN5";
-};
-
-&gpioz {
-	gpio-line-names = "", "", "", "HSIN6",
-			  "HSIN7", "HSIN8", "HSIN9", "";
-};
-
 &i2c2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;


