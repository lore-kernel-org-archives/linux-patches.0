Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1578AC433F0;
	Wed, 28 Dec 2022 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240176;
	bh=1dgAvwn1P/cNp3q8xu+IBu4pqFPpqjA+96QZODMhQuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFNNzM0uYu2l5cfilgTVdA0cgS0ivxUNHPfD2qQ1MN0rSl4Zcz5OS/z/DxM6c9pf5
	 OjVz5l3Vnm2GB0rHu11+g1Di29pej0iObguFCVZfO7KWXd6Vd1ugd47QUwbXWbD8nC
	 +LLvRFpqV3dDvXIB+7giapWOpmN3cGMuM51VVCLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0089/1146] ARM: dts: armada-38x: Fix compatible string for gpios
Date: Wed, 28 Dec 2022 15:27:08 +0100
Message-Id: <20221228144332.561705224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c4de4667f15d04ef5920bacf41e514ec7d1ef03d ]

Armada 38x supports per CPU interrupts for gpios, like Armada XP. Pre-XP
variants like Armada 370 do not support per CPU interrupts for gpios.

So change compatible string for Armada 38x from "marvell,armada-370-gpio"
which indicates pre-XP variant to "marvell,armadaxp-gpio" which indicates
XP variant or new.

Driver gpio-mvebu.c which handles both pre-XP and XP variants already
provides support for per CPU interrupts on XP and newer variants.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 7cb2acb3fbae ("ARM: dts: mvebu: Add PWM properties for armada-38x")
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-38x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index 446861b6b17b..12933eff419f 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -304,7 +304,7 @@ spdif_pins: spdif-pins {
 			};
 
 			gpio0: gpio@18100 {
-				compatible = "marvell,armada-370-gpio",
+				compatible = "marvell,armadaxp-gpio",
 					     "marvell,orion-gpio";
 				reg = <0x18100 0x40>, <0x181c0 0x08>;
 				reg-names = "gpio", "pwm";
@@ -323,7 +323,7 @@ gpio0: gpio@18100 {
 			};
 
 			gpio1: gpio@18140 {
-				compatible = "marvell,armada-370-gpio",
+				compatible = "marvell,armadaxp-gpio",
 					     "marvell,orion-gpio";
 				reg = <0x18140 0x40>, <0x181c8 0x08>;
 				reg-names = "gpio", "pwm";
-- 
2.35.1



