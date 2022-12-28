Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC831863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F999C433D2;
	Wed, 28 Dec 2022 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240184;
	bh=P+OT3LYAnQdBBVs8i0SJtQUcn4ygZ0OcuKdOqFtSL6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ei2PXKs26gey7UqOdgGvDR0+QVk9rCgMcf2pJFC6JY03WvTm2NkXdAjHS6KDEk6N2
	 66Gu5wi8oxO2LDjWCFOczGp0OVqJ+ctwbI2zEyY1ld2cLUHUOWD9/EliDG+eZ3Mo60
	 WFb0VP1kJ2DFBCF0AK20r2JglrwP8WVC4D5IfIPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0090/1146] ARM: dts: armada-39x: Fix compatible string for gpios
Date: Wed, 28 Dec 2022 15:27:09 +0100
Message-Id: <20221228144332.588490251@linuxfoundation.org>
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

[ Upstream commit d10886a4e6f85ee18d47a1066a52168461370ded ]

Armada 39x supports per CPU interrupts for gpios, like Armada XP.

So add compatible string "marvell,armadaxp-gpio" for Armada 39x GPIO nodes.

Driver gpio-mvebu.c which handles both pre-XP and XP variants already
provides support for per CPU interrupts on XP and newer variants.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: d81a914fc630 ("ARM: dts: mvebu: armada-39x: add missing nodes describing GPIO's")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-39x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-39x.dtsi b/arch/arm/boot/dts/armada-39x.dtsi
index 9d1cac49c022..1e05208d9f34 100644
--- a/arch/arm/boot/dts/armada-39x.dtsi
+++ b/arch/arm/boot/dts/armada-39x.dtsi
@@ -213,7 +213,7 @@ nand_pins: nand-pins {
 			};
 
 			gpio0: gpio@18100 {
-				compatible = "marvell,orion-gpio";
+				compatible = "marvell,armadaxp-gpio", "marvell,orion-gpio";
 				reg = <0x18100 0x40>;
 				ngpios = <32>;
 				gpio-controller;
@@ -227,7 +227,7 @@ gpio0: gpio@18100 {
 			};
 
 			gpio1: gpio@18140 {
-				compatible = "marvell,orion-gpio";
+				compatible = "marvell,armadaxp-gpio", "marvell,orion-gpio";
 				reg = <0x18140 0x40>;
 				ngpios = <28>;
 				gpio-controller;
-- 
2.35.1



