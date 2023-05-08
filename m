Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8F8168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C0EC433D2;
	Mon,  8 May 2023 09:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539835;
	bh=oo+mgKjtrMb1Vi08fabsduXLpZhxuZyzQg9XKNt2FCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou7Re6ASeqwqVigZgCuiXBhK8/W7vRjFCrSwlaPyxhmmNHb5GHAadGHLEjOeS3om7
	 6JWNEW1lJICXxZQcPhliz9m9S7YE/dColIV06nlD2ZFam/5zAY79dwFYnuvJMyt05G
	 oXzNHHFwuVYnBTpMH0FjqWoIuhqsi5clOCNEA+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/611] arm64: dts: broadcom: bcmbca: bcm4908: fix LED nodenames
Date: Mon,  8 May 2023 11:39:55 +0200
Message-Id: <20230508094427.254091865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 23be9f68f933adee8163b8efc9c6bff71410cc7c ]

This fixes:
arch/arm64/boot/dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dtb: leds@800: 'led-lan@19', 'led-power@11', 'led-wan-red@12', 'led-wan-white@15', 'led-wps@14' do not match any of the regexes: '^led@[a-f0-9]+$', 'pinctrl-[0-9]+'
        From schema: Documentation/devicetree/bindings/leds/leds-bcm63138.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/all/20230228144400.21689-2-zajec5@gmail.com/
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dts     | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dts b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dts
index 839ca33178b01..d94a53d68320b 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dts
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908-asus-gt-ac5300.dts
@@ -120,7 +120,7 @@
 };
 
 &leds {
-	led-power@11 {
+	led@11 {
 		reg = <0x11>;
 		function = LED_FUNCTION_POWER;
 		color = <LED_COLOR_ID_WHITE>;
@@ -130,7 +130,7 @@
 		pinctrl-0 = <&pins_led_17_a>;
 	};
 
-	led-wan-red@12 {
+	led@12 {
 		reg = <0x12>;
 		function = LED_FUNCTION_WAN;
 		color = <LED_COLOR_ID_RED>;
@@ -139,7 +139,7 @@
 		pinctrl-0 = <&pins_led_18_a>;
 	};
 
-	led-wps@14 {
+	led@14 {
 		reg = <0x14>;
 		function = LED_FUNCTION_WPS;
 		color = <LED_COLOR_ID_WHITE>;
@@ -148,7 +148,7 @@
 		pinctrl-0 = <&pins_led_20_a>;
 	};
 
-	led-wan-white@15 {
+	led@15 {
 		reg = <0x15>;
 		function = LED_FUNCTION_WAN;
 		color = <LED_COLOR_ID_WHITE>;
@@ -157,7 +157,7 @@
 		pinctrl-0 = <&pins_led_21_a>;
 	};
 
-	led-lan@19 {
+	led@19 {
 		reg = <0x19>;
 		function = LED_FUNCTION_LAN;
 		color = <LED_COLOR_ID_WHITE>;
-- 
2.39.2



