Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDEB15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E79C433C8;
	Wed,  9 Aug 2023 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577864;
	bh=+iNwGQses/SvbmlJy8x4N/eQpUAviko1J+QkN9HH9vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbKg29Ybr8mXAHjBaFM11AM6t9kjpvATDasEo3LNx3kq3GL9GsEKkk/SsoesmJOKN
	 V0qZjPqvfCEY5BoZIZ8jYzLGX4jaOaNkyKGiWew9IhFgwA4PKQVtVXQSIH09AlHtLz
	 /YPluVRzHNLfhid/b9UE3b/EciqoK8ZC9x0/eFOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Durai Manickam KR <durai.manickamkr@microchip.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 021/165] ARM: dts: at91: sam9x60: fix the SOC detection
Date: Wed,  9 Aug 2023 12:39:12 +0200
Message-ID: <20230809103643.485419217@linuxfoundation.org>
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

From: Durai Manickam KR <durai.manickamkr@microchip.com>

[ Upstream commit f6ad3c13f1b8c4e785cb7bd423887197142f47b0 ]

Remove the dbgu compatible strings in the UART submodule of the
flexcom for the proper SOC detection.

Fixes: 99c808335877 (ARM: dts: at91: sam9x60: Add missing flexcom definitions)
Signed-off-by: Durai Manickam KR <durai.manickamkr@microchip.com>
Link: https://lore.kernel.org/r/20230712100042.317856-1-durai.manickamkr@microchip.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sam9x60.dtsi | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index 8b53997675e75..73d570a172690 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -172,7 +172,7 @@
 				status = "disabled";
 
 				uart4: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <13 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -240,7 +240,7 @@
 				status = "disabled";
 
 				uart5: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					interrupts = <14 IRQ_TYPE_LEVEL_HIGH 7>;
@@ -370,7 +370,7 @@
 				status = "disabled";
 
 				uart11: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <32 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -419,7 +419,7 @@
 				status = "disabled";
 
 				uart12: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <33 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -576,7 +576,7 @@
 				status = "disabled";
 
 				uart6: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <9 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -625,7 +625,7 @@
 				status = "disabled";
 
 				uart7: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <10 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -674,7 +674,7 @@
 				status = "disabled";
 
 				uart8: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <11 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -723,7 +723,7 @@
 				status = "disabled";
 
 				uart0: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <5 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -791,7 +791,7 @@
 				status = "disabled";
 
 				uart1: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <6 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -859,7 +859,7 @@
 				status = "disabled";
 
 				uart2: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <7 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -927,7 +927,7 @@
 				status = "disabled";
 
 				uart3: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <8 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -1050,7 +1050,7 @@
 				status = "disabled";
 
 				uart9: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <15 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
@@ -1099,7 +1099,7 @@
 				status = "disabled";
 
 				uart10: serial@200 {
-					compatible = "microchip,sam9x60-dbgu", "microchip,sam9x60-usart", "atmel,at91sam9260-dbgu", "atmel,at91sam9260-usart";
+					compatible = "microchip,sam9x60-usart", "atmel,at91sam9260-usart";
 					reg = <0x200 0x200>;
 					interrupts = <16 IRQ_TYPE_LEVEL_HIGH 7>;
 					dmas = <&dma0
-- 
2.40.1



