Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D148F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA4DC433C7;
	Sun, 16 Jul 2023 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540231;
	bh=b4aDIJsYHPCcG85cEpSQBYX4Ui66WK5ExCnv8e0O/i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0npCxNo5xUJroNsj8tffDC674VIxSZaoRAhh1h/gGZ0sQ9IcXbj9p9hdjAWg/hY/k
	 FkYjywgON+FPg4w/UzqcmJ+uEkbAytajonBMoCm2h5z1It0myZOhVTVucUw3/SVC40
	 jqgv+xWTCytzpd8+Ze3lDtyu5n+wFOIIYrD06BgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/591] ARM: dts: lan966x: kontron-d10: fix board reset
Date: Sun, 16 Jul 2023 21:47:01 +0200
Message-ID: <20230716194931.189834723@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit bfcd5714f6424c03e385e0e9296dcd69855cfea7 ]

The pinctrl node was missing which change the pin mux to GPIO mode. Add
it.

Fixes: 79d83b3a458e ("ARM: dts: lan966x: add basic Kontron KSwitch D10 support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
[claudiu.beznea: moved pinctrl-* bindings after compatible]
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230616-feature-d10-dt-cleanups-v1-1-50dd0452b8fe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi b/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
index 0097e72e3fb22..42be207509a46 100644
--- a/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
+++ b/arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi
@@ -18,6 +18,8 @@ chosen {
 
 	gpio-restart {
 		compatible = "gpio-restart";
+		pinctrl-0 = <&reset_pins>;
+		pinctrl-names = "default";
 		gpios = <&gpio 56 GPIO_ACTIVE_LOW>;
 		priority = <200>;
 	};
@@ -59,6 +61,12 @@ miim_c_pins: miim-c-pins {
 		function = "miim_c";
 	};
 
+	reset_pins: reset-pins {
+		/* SYS_RST# */
+		pins = "GPIO_56";
+		function = "gpio";
+	};
+
 	sgpio_a_pins: sgpio-a-pins {
 		/* SCK, D0, D1 */
 		pins = "GPIO_32", "GPIO_33", "GPIO_34";
-- 
2.39.2



