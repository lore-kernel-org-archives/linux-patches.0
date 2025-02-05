Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E315116F288;
	Wed,  5 Feb 2025 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767151; cv=none; b=SZWG/tTIRVCFvLRQ6mRzSkF8d1uTIePCsTmUyYccwl6tP3FrXygGEdoZpgf/JqXLEB2OxoC49dDhrzfyLh6MWFuOFHPw0Wbujp/GXz6wNdvXCvdnkT5dQSU0yK4LUHjRatOTq2lAjJ2rOYvQGYH47ssUoDOO62lHpGw3Y4VztIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767151; c=relaxed/simple;
	bh=CqcF53Tq4MknSWRqc9GQNzz6A19O1KMarns77rlFVsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmXN4DbKyqJ3zSlsKxb3RRkaZZ7gsgpumpAAGnATGGB1GI03DcWdVNut9EFhJQ+IdB0XkXLZZstBVWDdWqKibRU57PuzVwYLbUOasW7pDKzIp8PZ1OZ4EVEYTHTdl5cXwmaKp7Xk9CmNSdhiMnDnwc+wnjOm6z+XHPLPv6ES984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK2oM+Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK2oM+Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE90C4CED1;
	Wed,  5 Feb 2025 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767150;
	bh=CqcF53Tq4MknSWRqc9GQNzz6A19O1KMarns77rlFVsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK2oM+FhL4jYCM809A+OT+HjUM2umGVtFGs5E0EXcaBrAllfEzvDOnVxVfmmm8vxk
	 62hDS00DWc58eFjn56oy7/Q7uPlBH3A0UboTRfcmsuZuSEo+bZCiDdY/QIShTErnul
	 OZa9sBEuCeMWXhki9xsKeO2BYE2IJpWwDvC20/lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 363/623] ARM: dts: stm32: Deduplicate serial aliases and chosen node for STM32MP15xx DHCOM SoM
Date: Wed,  5 Feb 2025 14:41:45 +0100
Message-ID: <20250205134510.109177252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 73317d327123472cb70e9ecbe050310f1d235e93 ]

Deduplicate /aliases { serialN = ... } and /chosen node into
stm32mp15xx-dhcom-som.dtsi , since the content is identical
on all carrier boards using the STM32MP15xx DHCOM SoM. No
functional change.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Stable-dep-of: 479b8227ffc4 ("ARM: dts: stm32: Swap USART3 and UART8 alias on STM32MP15xx DHCOM SoM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi   | 12 ------------
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi    | 10 ----------
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi | 10 ----------
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi     |  7 +++++++
 4 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi
index bb4f8a0b937f3..abe2dfe706364 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-drc02.dtsi
@@ -6,18 +6,6 @@
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/pwm/pwm.h>
 
-/ {
-	aliases {
-		serial0 = &uart4;
-		serial1 = &usart3;
-		serial2 = &uart8;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-};
-
 &adc {
 	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi
index 171d7c7658fa8..0fb4e55843b9d 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-pdk2.dtsi
@@ -7,16 +7,6 @@
 #include <dt-bindings/pwm/pwm.h>
 
 / {
-	aliases {
-		serial0 = &uart4;
-		serial1 = &usart3;
-		serial2 = &uart8;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
 	clk_ext_audio_codec: clock-codec {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi
index b5bc53accd6b2..01c693cc03446 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-picoitx.dtsi
@@ -7,16 +7,6 @@
 #include <dt-bindings/pwm/pwm.h>
 
 / {
-	aliases {
-		serial0 = &uart4;
-		serial1 = &usart3;
-		serial2 = &uart8;
-	};
-
-	chosen {
-		stdout-path = "serial0:115200n8";
-	};
-
 	led {
 		compatible = "gpio-leds";
 
diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
index 74a11ccc5333f..086d3a60ccce2 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -14,6 +14,13 @@
 		ethernet1 = &ksz8851;
 		rtc0 = &hwrtc;
 		rtc1 = &rtc;
+		serial0 = &uart4;
+		serial1 = &usart3;
+		serial2 = &uart8;
+	};
+
+	chosen {
+		stdout-path = "serial0:115200n8";
 	};
 
 	memory@c0000000 {
-- 
2.39.5



