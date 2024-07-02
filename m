Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB5F15218A;
	Tue,  2 Jul 2024 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941193; cv=none; b=PV9Ga/xu3i9xHQ+bjIurj1z+7G4po2K1j+fUud0WE7FvMzS1JoHMfIQ+i2ZbgHxBeQlnr0QK67EHuxqpjoU4Npw8vjwyeYlHf9motMzQKR3fTxoBQH1yOAbNm8LtCMZasYpxwcDrakdquXCO5e2xJqKCaQ/IMDooT0iuAspcQYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941193; c=relaxed/simple;
	bh=WnggTFcKMogt6PFoxBGMVdXUUDiWT0qNYPWH0N435Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD1ZRT0QC0XcT8TM0tDWBygw0E5BA6JCdtGZQlBLuydLl9za8NLUC4OS2WRY7PaK31PhONrmz/6sCjdN40f2+HMeHFdm1w1GYmhuuRBslSKj50rSFkj+nnXkfY3qVKmMcXbxNE9FJlzNnAkQX99TMpkLIQOvdsJtN5Kso3SyE4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRGa7fu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRGa7fu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4926FC4AF0A;
	Tue,  2 Jul 2024 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941193;
	bh=WnggTFcKMogt6PFoxBGMVdXUUDiWT0qNYPWH0N435Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRGa7fu5e8wqf52hQAopyLjSOm/O7c3MGNdhx60j5OoJ5iR6TozNZ47i4f+8vEMk5
	 RiU302A2oSVrAry9fsEuXgrgtYWAqjEtd3nZO11tG3XoV3D6V0+TnQeIhvX6k/ZpAC
	 +3bXPFsoPQWjVotAcs1tIj52eNOtyESXYvElPKOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/163] arm64: dts: rockchip: Rename LED related pinctrl nodes on rk3308-rock-pi-s
Date: Tue,  2 Jul 2024 19:04:29 +0200
Message-ID: <20240702170238.928397006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit d2a52f678883fe4bc00bca89366b1ba504750abf ]

The nodename, <name>-gpio, of referenced pinctrl nodes for the two LEDs
on the ROCK Pi S cause DT schema validation error:

  leds: green-led-gpio: {'rockchip,pins': [[0, 6, 0, 90]], 'phandle': [[98]]} is not of type 'array'
        from schema $id: http://devicetree.org/schemas/gpio/gpio-consumer.yaml#
  leds: heartbeat-led-gpio: {'rockchip,pins': [[0, 5, 0, 90]], 'phandle': [[99]]} is not of type 'array'
        from schema $id: http://devicetree.org/schemas/gpio/gpio-consumer.yaml#

Rename the pinctrl nodes and symbols to pass DT schema validation, also
extend LED nodes with information about color and function.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-7-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index 40b2f27aa6312..4f6541262ab84 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -5,6 +5,8 @@
  */
 
 /dts-v1/;
+
+#include <dt-bindings/leds/common.h>
 #include "rk3308.dtsi"
 
 / {
@@ -24,17 +26,21 @@
 	leds {
 		compatible = "gpio-leds";
 		pinctrl-names = "default";
-		pinctrl-0 = <&green_led_gio>, <&heartbeat_led_gpio>;
+		pinctrl-0 = <&green_led>, <&heartbeat_led>;
 
 		green-led {
+			color = <LED_COLOR_ID_GREEN>;
 			default-state = "on";
+			function = LED_FUNCTION_POWER;
 			gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_HIGH>;
 			label = "rockpis:green:power";
 			linux,default-trigger = "default-on";
 		};
 
 		blue-led {
+			color = <LED_COLOR_ID_BLUE>;
 			default-state = "on";
+			function = LED_FUNCTION_HEARTBEAT;
 			gpios = <&gpio0 RK_PA5 GPIO_ACTIVE_HIGH>;
 			label = "rockpis:blue:user";
 			linux,default-trigger = "heartbeat";
@@ -154,11 +160,11 @@
 	pinctrl-0 = <&rtc_32k>;
 
 	leds {
-		green_led_gio: green-led-gpio {
+		green_led: green-led {
 			rockchip,pins = <0 RK_PA6 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 
-		heartbeat_led_gpio: heartbeat-led-gpio {
+		heartbeat_led: heartbeat-led {
 			rockchip,pins = <0 RK_PA5 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
-- 
2.43.0



