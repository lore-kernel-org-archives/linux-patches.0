Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73104522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E9AC433C8;
	Sun,  9 Jul 2023 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902339;
	bh=3zj4oZUJyZWCGWg8Zukn8g9TG9uTMq5TEYYjkZ2RAHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2/PMnMQqVtPTBSSnpaj9H/kE/s8M0QKKz5L3uv8BrbD8fKD297eN+n17krXqrrE4
	 QBlQFfUE1nv52Ue2a2GlHA2mhR2inbAIVuqy/+ZEWJUT6uLl2JdjKWfgB/LD0XtZPW
	 +/RIxn4BqDVZ1VkfbQSvEJyuD/YiILnOz80W4HN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 333/431] ARM: dts: lan966x: kontron-d10: fix SPI CS
Date: Sun,  9 Jul 2023 13:14:41 +0200
Message-ID: <20230709111458.980874506@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit fcb79ee3f0b15ed15f35eca5f24e952fdced9c61 ]

The pinctrl node was missing which change the pin mux to GPIO mode.
Add it so we don't have to rely on the bootloader to set the correct
mode.

Fixes: 79d83b3a458e ("ARM: dts: lan966x: add basic Kontron KSwitch D10 support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230616-feature-d10-dt-cleanups-v1-2-50dd0452b8fe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi b/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
index 42be207509a46..f4df4cc1dfa5e 100644
--- a/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
+++ b/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
@@ -41,7 +41,7 @@ &flx3 {
 	status = "okay";
 
 	spi3: spi@400 {
-		pinctrl-0 = <&fc3_b_pins>;
+		pinctrl-0 = <&fc3_b_pins>, <&spi3_cs_pins>;
 		pinctrl-names = "default";
 		status = "okay";
 		cs-gpios = <&gpio 46 GPIO_ACTIVE_LOW>;
@@ -79,6 +79,12 @@ sgpio_b_pins: sgpio-b-pins {
 		function = "sgpio_b";
 	};
 
+	spi3_cs_pins: spi3-cs-pins {
+		/* CS# */
+		pins = "GPIO_46";
+		function = "gpio";
+	};
+
 	usart0_pins: usart0-pins {
 		/* RXD, TXD */
 		pins = "GPIO_25", "GPIO_26";
-- 
2.39.2



