Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B9115AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D7AC433C7;
	Wed,  9 Aug 2023 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577858;
	bh=9iWuxtR3XoIcgS9o/ZEXtSGaLKz1lGXIqWlogCgiojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VILoksocyc/6gdxs6j8cx64tS03kyAGCFD5RVidODlQNXY1vdhwQuHlrOLM655WV2
	 0ICjNgXo7f6RJFxC/j/gvAqwqExVETTQnkWrF/jXCtbxLT+dPjllk8SZeHSspnteMQ
	 kQnENlS9Q57ilfxFKIHStbSFqYQ5lGOdfsBVP10s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 020/165] ARM: dts: at91: use generic name for shutdown controller
Date: Wed,  9 Aug 2023 12:39:11 +0200
Message-ID: <20230809103643.446233082@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 327ca228e58be498446244eb7cf39b892adda5d7 ]

Use poweroff generic name for shdwc node to cope with device tree
specifications.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20230616101646.879480-2-claudiu.beznea@microchip.com
Stable-dep-of: f6ad3c13f1b8 ("ARM: dts: at91: sam9x60: fix the SOC detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-qil_a9260.dts        | 2 +-
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts | 2 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts   | 2 +-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts | 2 +-
 arch/arm/boot/dts/at91sam9260.dtsi          | 2 +-
 arch/arm/boot/dts/at91sam9260ek.dts         | 2 +-
 arch/arm/boot/dts/at91sam9261.dtsi          | 2 +-
 arch/arm/boot/dts/at91sam9263.dtsi          | 2 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi          | 2 +-
 arch/arm/boot/dts/at91sam9n12.dtsi          | 2 +-
 arch/arm/boot/dts/at91sam9rl.dtsi           | 2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi           | 2 +-
 arch/arm/boot/dts/sam9x60.dtsi              | 2 +-
 arch/arm/boot/dts/sama5d2.dtsi              | 2 +-
 arch/arm/boot/dts/sama5d3.dtsi              | 2 +-
 arch/arm/boot/dts/sama5d4.dtsi              | 2 +-
 arch/arm/boot/dts/sama7g5.dtsi              | 2 +-
 arch/arm/boot/dts/usb_a9260.dts             | 2 +-
 arch/arm/boot/dts/usb_a9263.dts             | 2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm/boot/dts/at91-qil_a9260.dts b/arch/arm/boot/dts/at91-qil_a9260.dts
index 9d26f99963483..5ccb3c139592d 100644
--- a/arch/arm/boot/dts/at91-qil_a9260.dts
+++ b/arch/arm/boot/dts/at91-qil_a9260.dts
@@ -108,7 +108,7 @@
 				status = "okay";
 			};
 
-			shdwc@fffffd10 {
+			shdwc: poweroff@fffffd10 {
 				atmel,wakeup-counter = <10>;
 				atmel,wakeup-rtt-timer;
 			};
diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index 52ddd0571f1c0..d0a6dbd377dfa 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -139,7 +139,7 @@
 				};
 			};
 
-			shdwc@f8048010 {
+			poweroff@f8048010 {
 				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index bf1c9ca72a9f3..200b20515ab12 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -204,7 +204,7 @@
 				};
 			};
 
-			shdwc@f8048010 {
+			poweroff@f8048010 {
 				debounce-delay-us = <976>;
 
 				input@0 {
diff --git a/arch/arm/boot/dts/at91-sama5d2_xplained.dts b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
index 2d53c47d7cc86..6680031387e8c 100644
--- a/arch/arm/boot/dts/at91-sama5d2_xplained.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_xplained.dts
@@ -348,7 +348,7 @@
 				};
 			};
 
-			shdwc@f8048010 {
+			poweroff@f8048010 {
 				debounce-delay-us = <976>;
 				atmel,wakeup-rtc-timer;
 
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 16e3b24b4dddb..35a007365b6a5 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -130,7 +130,7 @@
 				clocks = <&pmc PMC_TYPE_CORE PMC_SLOW>;
 			};
 
-			shdwc@fffffd10 {
+			shdwc: poweroff@fffffd10 {
 				compatible = "atmel,at91sam9260-shdwc";
 				reg = <0xfffffd10 0x10>;
 				clocks = <&pmc PMC_TYPE_CORE PMC_SLOW>;
diff --git a/arch/arm/boot/dts/at91sam9260ek.dts b/arch/arm/boot/dts/at91sam9260ek.dts
index bb72f050a4fef..720c15472c4a5 100644
--- a/arch/arm/boot/dts/at91sam9260ek.dts
+++ b/arch/arm/boot/dts/at91sam9260ek.dts
@@ -112,7 +112,7 @@
 				};
 			};
 
-			shdwc@fffffd10 {
+			shdwc: poweroff@fffffd10 {
 				atmel,wakeup-counter = <10>;
 				atmel,wakeup-rtt-timer;
 			};
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index fe9ead867e2ab..528ffc6f6f962 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -614,7 +614,7 @@
 				clocks = <&slow_xtal>;
 			};
 
-			shdwc@fffffd10 {
+			poweroff@fffffd10 {
 				compatible = "atmel,at91sam9260-shdwc";
 				reg = <0xfffffd10 0x10>;
 				clocks = <&slow_xtal>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index ee5e6ed44dd40..75d8ff2d12c8a 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -158,7 +158,7 @@
 				clocks = <&slow_xtal>;
 			};
 
-			shdwc@fffffd10 {
+			poweroff@fffffd10 {
 				compatible = "atmel,at91sam9260-shdwc";
 				reg = <0xfffffd10 0x10>;
 				clocks = <&slow_xtal>;
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 024af2db638eb..565b99e79c520 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -126,7 +126,7 @@
 				};
 			};
 
-			shdwc@fffffd10 {
+			shdwc: poweroff@fffffd10 {
 				atmel,wakeup-counter = <10>;
 				atmel,wakeup-rtt-timer;
 			};
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 498cb92b29f96..7cccc606e36cd 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -152,7 +152,7 @@
 			};
 
 
-			shdwc@fffffd10 {
+			poweroff@fffffd10 {
 				compatible = "atmel,at91sam9rl-shdwc";
 				reg = <0xfffffd10 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index c2e7460fb7ff6..16a9a908985da 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -140,7 +140,7 @@
 				clocks = <&pmc PMC_TYPE_CORE PMC_MCK>;
 			};
 
-			shdwc@fffffe10 {
+			poweroff@fffffe10 {
 				compatible = "atmel,at91sam9x5-shdwc";
 				reg = <0xfffffe10 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index d7e8a115c916c..3d089ffbe1626 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -778,7 +778,7 @@
 				clocks = <&clk32k>;
 			};
 
-			shdwc@fffffd10 {
+			poweroff@fffffd10 {
 				compatible = "atmel,at91sam9260-shdwc";
 				reg = <0xfffffd10 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 0123ee47151cb..a1fed912f2eea 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -141,7 +141,7 @@
 				clocks = <&clk32k>;
 			};
 
-			shutdown_controller: shdwc@fffffe10 {
+			shutdown_controller: poweroff@fffffe10 {
 				compatible = "atmel,at91sam9x5-shdwc";
 				reg = <0xfffffe10 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index c8bedfa987e57..8b53997675e75 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -1297,7 +1297,7 @@
 				clocks = <&clk32k 0>;
 			};
 
-			shutdown_controller: shdwc@fffffe10 {
+			shutdown_controller: poweroff@fffffe10 {
 				compatible = "microchip,sam9x60-shdwc";
 				reg = <0xfffffe10 0x10>;
 				clocks = <&clk32k 0>;
diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index 5f632e3f039e6..8ae270fabfa82 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -680,7 +680,7 @@
 				clocks = <&clk32k>;
 			};
 
-			shutdown_controller: shdwc@f8048010 {
+			shutdown_controller: poweroff@f8048010 {
 				compatible = "atmel,sama5d2-shdwc";
 				reg = <0xf8048010 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 0eebf6c760b3d..d9e66700d1c20 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1016,7 +1016,7 @@
 				clocks = <&clk32k>;
 			};
 
-			shutdown_controller: shutdown-controller@fffffe10 {
+			shutdown_controller: poweroff@fffffe10 {
 				compatible = "atmel,at91sam9x5-shdwc";
 				reg = <0xfffffe10 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index de6c829692327..41284e013f531 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -740,7 +740,7 @@
 				clocks = <&clk32k>;
 			};
 
-			shutdown_controller: shdwc@fc068610 {
+			shutdown_controller: poweroff@fc068610 {
 				compatible = "atmel,at91sam9x5-shdwc";
 				reg = <0xfc068610 0x10>;
 				clocks = <&clk32k>;
diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
index b55adb96a06ec..9642a42d84e60 100644
--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -257,7 +257,7 @@
 			clocks = <&clk32k 0>;
 		};
 
-		shdwc: shdwc@e001d010 {
+		shdwc: poweroff@e001d010 {
 			compatible = "microchip,sama7g5-shdwc", "syscon";
 			reg = <0xe001d010 0x10>;
 			clocks = <&clk32k 0>;
diff --git a/arch/arm/boot/dts/usb_a9260.dts b/arch/arm/boot/dts/usb_a9260.dts
index 6cfa83921ac26..66f8da89007db 100644
--- a/arch/arm/boot/dts/usb_a9260.dts
+++ b/arch/arm/boot/dts/usb_a9260.dts
@@ -22,7 +22,7 @@
 
 	ahb {
 		apb {
-			shdwc@fffffd10 {
+			shdwc: poweroff@fffffd10 {
 				atmel,wakeup-counter = <10>;
 				atmel,wakeup-rtt-timer;
 			};
diff --git a/arch/arm/boot/dts/usb_a9263.dts b/arch/arm/boot/dts/usb_a9263.dts
index b6cb9cdf81973..45745915b2e16 100644
--- a/arch/arm/boot/dts/usb_a9263.dts
+++ b/arch/arm/boot/dts/usb_a9263.dts
@@ -67,7 +67,7 @@
 				};
 			};
 
-			shdwc@fffffd10 {
+			poweroff@fffffd10 {
 				atmel,wakeup-counter = <10>;
 				atmel,wakeup-rtt-timer;
 			};
-- 
2.40.1



