Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365F315C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8216EC433D6;
	Mon,  5 Dec 2022 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269139;
	bh=wxKEgFnY9/izPf4MrPaPYvIXeNVWiAsJczUmn5/0w3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viogrTxoSYehxxk0c13P97+v82aTa/1TEJnikjZxeCpH9wZmTp5hmmGiWeGprv4m2
	 4Y3+5DEJL6u3EUWOP0euyqpcPE9ith/q+R7ZwoyhURaR95ScQvOA3L/RabBmJdRpRL
	 sNWRxv5jiJlZDYIK5ufcFntwcqc8bQjCZ+WGcNQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	nicolas.ferre@microchip.com,
	ludovic.desroches@microchip.com,
	alexandre.belloni@bootlin.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/153] ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl
Date: Mon,  5 Dec 2022 20:09:02 +0100
Message-Id: <20221205190809.270570473@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 40a2226e8bfacb79dd154dea68febeead9d847e9 ]

We set the PIOC to GPIO mode. This way the pin becomes an
input signal will be usable by the controller. Without
this change the udc on the 9g20ek does not work.

Cc: nicolas.ferre@microchip.com
Cc: ludovic.desroches@microchip.com
Cc: alexandre.belloni@bootlin.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de
Fixes: 5cb4e73575e3 ("ARM: at91: add at91sam9g20ek boards dt support")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221114185923.1023249-3-m.grzeschik@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 287566e09a67..3d694b60d452 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -38,6 +38,13 @@ pinctrl_pck0_as_mck: pck0_as_mck {
 
 				};
 
+				usb1 {
+					pinctrl_usb1_vbus_gpio: usb1_vbus_gpio {
+						atmel,pins =
+							<AT91_PIOC 5 AT91_PERIPH_GPIO AT91_PINCTRL_DEGLITCH>;	/* PC5 GPIO */
+					};
+				};
+
 				mmc0_slot1 {
 					pinctrl_board_mmc0_slot1: mmc0_slot1-board {
 						atmel,pins =
@@ -83,6 +90,8 @@ macb0: ethernet@fffc4000 {
 			};
 
 			usb1: gadget@fffa4000 {
+				pinctrl-0 = <&pinctrl_usb1_vbus_gpio>;
+				pinctrl-names = "default";
 				atmel,vbus-gpio = <&pioC 5 GPIO_ACTIVE_HIGH>;
 				status = "okay";
 			};
-- 
2.35.1



