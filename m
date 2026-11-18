Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047727;
	b=HwKDl5al//Cadic4vr4sBwmEBTFKlNA6gJt7O0kKA8HMUBckHsv5MNM9iEYsibv97G//
	 060W53K7qm1SZjp0Dtia0RHsfMjOGU++9tS6OzpuQChVXeg+e6J7zwPvl1oJnbhn4YYtE
	 rEhodNTZZlLTSE7iycUtVegPUX1AYFpUVRw/IBcUBTJUatauRTQwGjwGlLi5GSEnBgNDE
	 gmSCspjKkqHd3Cgwedk0m4Ya8263TOdnVDjoXkludDpAHTRFSVDdUJpHqhkNuiKhREpDh
	 belcZlYhnPp6jq2rHljrnf3d08E62pZPWVlcYDppLbat4lg4kIvhm4gcNz8tK4t34KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JE/CV2tJ6mRfkfsQSUVMebIH/dN5CrwQ1POW89+8hHo=;
	b=du6BOWByTaawaBe7ND1x6VqEvJRSczmruoXP6GcJNuwPc7MxUegwcnswhcN6MM6su9SS
	 jCcdnHLL6P0IqWQLjh8eJ2BwSBtlptvNk02X3WWsLewUrBpvem9pYw9dYAYuyaEA6l++Q
	 FHV3sjaGBccS8tGRITnijIS6rwv90F9b8bbuoeVW/uBmuTObyOxvTt3ojsVZiySCWt49C
	 i73+OCnfMZsBmOge81XHNU8ay5zVPsRpABBEZs/euuq7RwMsTjxr7imZlNR2GDZ1GH759
	 XEPEGjMnWRnm9785DEvGz9QFjlbRw9PVDe8Y7tfG6KwbGqmLOo917/3azkurnqkyEOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ync54CiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B0B606A320;
	Thu, 19 Nov 2026 00:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ync54CiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF41F000CC;
	Thu, 19 Nov 2026 00:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047727;
	bh=JE/CV2tJ6mRfkfsQSUVMebIH/dN5CrwQ1POW89+8hHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ync54CiZ1FJzzqiyGZBCgvJeS2mxyA4R9czk7ACRDX/FyophYDbV/Rqw9t0kSDZFJ
	 qE58aZGApoTwwYh6GENcaxbfISh+KrCD1heC1Z7UReRQVeMrbu9/vlY2aFbdXHqGYY
	 ZOAORkrneXbNcFj2a+BnxrlFWKQMH0kX3ALzik6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1743/2857] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150304.064225600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 5df4320a30a87f9bb918ace7b389026917c8d896 ]

This spi node is specified in armada-38x.dtsi with proper compatible
strings whereas they are not present here. Instead of copy and pasting
various lines, just reference the node in the dtsi.

This dts seems to predate the move of spi from internal-regs to the soc
node so this moves it in line there.

Allows proper probing of SPI at runtime.

Remove the microsom_spi1_cs_pins pinctrl group and its reference in
&spi1. The group only muxed mpp59 to the "spi1" function, but that
pin (SPI1 cs0) is already covered by spi1_pins, which selects the
same function for mpp56-59 in armada-38x.dtsi.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 1ed6ddf1719a7..33e30528bc7ca 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -254,13 +254,6 @@ sata3: sata-port@1 {
 				};
 			};
 
-			spi@10680 {
-				pinctrl-0 = <&spi1_pins
-					     &microsom_spi1_cs_pins>;
-				pinctrl-names = "default";
-				status = "okay";
-			};
-
 			sdhci@d8000 {
 				bus-width = <4>;
 				cd-gpios = <&gpio0 20 GPIO_ACTIVE_LOW>;
@@ -327,11 +320,13 @@ helios_fan2_pins: helios_fan2_pins {
 					marvell,pins = "mpp48", "mpp55";
 					marvell,function = "gpio";
 				};
-				microsom_spi1_cs_pins: spi1-cs-pins {
-					marvell,pins = "mpp59";
-					marvell,function = "spi1";
-				};
 			};
 		};
 	};
 };
+
+&spi1 {
+	pinctrl-0 = <&spi1_pins>;
+	pinctrl-names = "default";
+	status = "okay";
+};
-- 
2.53.0



