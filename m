Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2B47253D;
	Tue, 21 Jul 2026 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663447; cv=none; b=qPMFvtyIhiYO4O13VsyG/OGpT6ZnDig3/TOlnPnQsJGfa1Vru+Rh4EQL/oCKpW4bceXG5lOP3+43ElsFhmmmuhUWuwg0TFd4STWvxUKjrqOLMBg8hYxGf0+9mqv6SRFGwOIZg4+0hpLUthbL9bKUqx/i+m1YotPAt2jzOtnpUjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663447; c=relaxed/simple;
	bh=qu6VWUb6eoJPU9LPTR62dsBYUusAybmy7NE0Jj2tYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srZePsv19Fh83o2nAl4rXSpBmFd1ibt0uG51D7y2GykE53Rc9OeNXlyS49M4T2m4ulG+IZprR7gqqBJLm0EJdVCdw4aWoeHZVqJbIz3ktn7rwYTY1KO7P0JdIYiVl3k0SbCzqJ+3MD5yepWaS1eOEI2reu1RiR98WqzNbmeLlh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekDgjZOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekDgjZOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E851F00A3A;
	Tue, 21 Jul 2026 19:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663446;
	bh=tzxoDu5xAhVSAc+tHLBMeZEvbCEqQfbu6ShSc7CWz7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekDgjZOI8uPdXBqvaggOmctpGVtD2GfIO7q8MU/DkO/dv3Kpqtat18hsEy1Cuv6zI
	 zqQaVmtR/Q9smIDtodNdQxzqcvsMGAhiyXP6+BUWMPgJpiurREF2fV0cIdkrpKbWlh
	 RqR3E6OE15CKiSscHPhll4+sm02K+Om1mcPtDIfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.12 0824/1276] ARM: dts: stm32: stm32mp15x-mecio1-io: Move gpio-line-names to board files
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152504.504053495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


