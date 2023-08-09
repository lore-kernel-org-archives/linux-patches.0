Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDC215AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F028C433C9;
	Wed,  9 Aug 2023 10:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577852;
	bh=60DFOGa/HHKmdf1Yd0iNhzdGpOWjP3yJ+d5qQGWMFZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVb0/01WJMJ94LtSGQ4bn44ZMqYt/PGepAN9xz8gwZB/IWqjjHtrwD7wqqS/L+mIf
	 l+6ll2RA2vKj5hxLEBjn+P/X9DqKfHCa66oKn94x1maK8qcVB6pVPkgc6ibf4dpohl
	 +YfzVk3UHm5CR/5AhAwm0fV8lxhKq6ye37VBmvnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 018/165] ARM: dts: at91: use clock-controller name for PMC nodes
Date: Wed,  9 Aug 2023 12:39:09 +0200
Message-ID: <20230809103643.375905843@linuxfoundation.org>
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

[ Upstream commit d08f92bdfb2dc4a2a14237cfd8a22c568781797c ]

Use clock-controller generic name for PMC nodes.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230517094119.2894220-2-claudiu.beznea@microchip.com
Stable-dep-of: f6ad3c13f1b8 ("ARM: dts: at91: sam9x60: fix the SOC detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91rm9200.dtsi   | 2 +-
 arch/arm/boot/dts/at91sam9260.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9261.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9263.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9g20.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9g35.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9n12.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9rl.dtsi   | 2 +-
 arch/arm/boot/dts/at91sam9x25.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9x35.dtsi  | 2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi   | 2 +-
 arch/arm/boot/dts/sam9x60.dtsi      | 2 +-
 arch/arm/boot/dts/sama5d2.dtsi      | 2 +-
 arch/arm/boot/dts/sama5d3.dtsi      | 2 +-
 arch/arm/boot/dts/sama5d3_emac.dtsi | 2 +-
 arch/arm/boot/dts/sama5d4.dtsi      | 2 +-
 arch/arm/boot/dts/sama7g5.dtsi      | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index 6f9004ebf4245..37b500f6f3956 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -102,7 +102,7 @@
 				reg = <0xffffff00 0x100>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 789fe356dbf60..16e3b24b4dddb 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -115,7 +115,7 @@
 				reg = <0xffffee00 0x200>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9260-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index ee0bd1aceb3f0..fe9ead867e2ab 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -599,7 +599,7 @@
 				};
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9261-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 3ce9ea9873129..ee5e6ed44dd40 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -101,7 +101,7 @@
 				atmel,external-irqs = <30 31>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9263-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index 708e1646b7f46..738a43ffd2281 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -41,7 +41,7 @@
 				atmel,adc-startup-time = <40>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9g20-pmc", "atmel,at91sam9260-pmc", "syscon";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
index d2f13afb35eaf..ec3c77221881c 100644
--- a/arch/arm/boot/dts/at91sam9g25.dtsi
+++ b/arch/arm/boot/dts/at91sam9g25.dtsi
@@ -26,7 +26,7 @@
 				      >;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9g25-pmc", "atmel,at91sam9x5-pmc", "syscon";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9g35.dtsi b/arch/arm/boot/dts/at91sam9g35.dtsi
index 48c2bc4a7753d..c9cfb93092ee6 100644
--- a/arch/arm/boot/dts/at91sam9g35.dtsi
+++ b/arch/arm/boot/dts/at91sam9g35.dtsi
@@ -25,7 +25,7 @@
 				      >;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9g35-pmc", "atmel,at91sam9x5-pmc", "syscon";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 95f5d76234dbb..76afeb31b7f54 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -129,7 +129,7 @@
 				reg = <0xffffea00 0x200>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9g45-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 83114d26f10d0..c2e7460fb7ff6 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -118,7 +118,7 @@
 				reg = <0xffffea00 0x200>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9n12-pmc", "syscon";
 				reg = <0xfffffc00 0x200>;
 				#clock-cells = <2>;
diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 364a2ff0a763d..a12e6c419fe3d 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -763,7 +763,7 @@
 				};
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9rl-pmc", "syscon";
 				reg = <0xfffffc00 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
index 0fe8802e1242b..7036f5f045715 100644
--- a/arch/arm/boot/dts/at91sam9x25.dtsi
+++ b/arch/arm/boot/dts/at91sam9x25.dtsi
@@ -27,7 +27,7 @@
 				      >;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9x25-pmc", "atmel,at91sam9x5-pmc", "syscon";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9x35.dtsi b/arch/arm/boot/dts/at91sam9x35.dtsi
index 0bfa21f18f870..eb03b0497e371 100644
--- a/arch/arm/boot/dts/at91sam9x35.dtsi
+++ b/arch/arm/boot/dts/at91sam9x35.dtsi
@@ -26,7 +26,7 @@
 				      >;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9x35-pmc", "atmel,at91sam9x5-pmc", "syscon";
 			};
 		};
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 0c26c925761b2..af19ef2a875c4 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -126,7 +126,7 @@
 				reg = <0xffffea00 0x200>;
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,at91sam9x5-pmc", "syscon";
 				reg = <0xfffffc00 0x200>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index e67ede940071f..89aafb9a8b0fe 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -1282,7 +1282,7 @@
 				};
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "microchip,sam9x60-pmc", "syscon";
 				reg = <0xfffffc00 0x200>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index 14c35c12a115f..86009dd28e623 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -284,7 +284,7 @@
 				clock-names = "dma_clk";
 			};
 
-			pmc: pmc@f0014000 {
+			pmc: clock-controller@f0014000 {
 				compatible = "atmel,sama5d2-pmc", "syscon";
 				reg = <0xf0014000 0x160>;
 				interrupts = <74 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index bde8e92d60bb1..4524a16322d16 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1001,7 +1001,7 @@
 				};
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 				compatible = "atmel,sama5d3-pmc", "syscon";
 				reg = <0xfffffc00 0x120>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
index 45226108850d2..5d7ce13de8ccf 100644
--- a/arch/arm/boot/dts/sama5d3_emac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
@@ -30,7 +30,7 @@
 				};
 			};
 
-			pmc: pmc@fffffc00 {
+			pmc: clock-controller@fffffc00 {
 			};
 
 			macb1: ethernet@f802c000 {
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index af62157ae214f..e94f3a661f4bb 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -250,7 +250,7 @@
 				clock-names = "dma_clk";
 			};
 
-			pmc: pmc@f0018000 {
+			pmc: clock-controller@f0018000 {
 				compatible = "atmel,sama5d4-pmc", "syscon";
 				reg = <0xf0018000 0x120>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
index 929ba73702e93..b55adb96a06ec 100644
--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -241,7 +241,7 @@
 			clocks = <&pmc PMC_TYPE_PERIPHERAL 11>;
 		};
 
-		pmc: pmc@e0018000 {
+		pmc: clock-controller@e0018000 {
 			compatible = "microchip,sama7g5-pmc", "syscon";
 			reg = <0xe0018000 0x200>;
 			interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.40.1



