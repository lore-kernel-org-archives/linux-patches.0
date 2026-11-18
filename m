Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015246;
	b=wZg9ItFtwv49yYMvpUfoBe0aFspbTPcncruxFB6GqQWDtvOqaDwet4OYzUDPK04TcFxR
	 6p2USVFSDwA4bBra+WWMUkDDMGPb0yJO6/kjlKAJDAz97NmV9IaO9zRiaaFTGllmD2OgN
	 bOVln5y7a3a2TzniiehwydyImP2d1A0C9DuTv5uMzCHskambaXXmVyJ4By2SeJxL5f+39
	 /iJcvMKq+PVMxGycYyNqVVDfIYq6WZ7+urYzyd6fATbl1mcwDRgvCvOZ1UbzcaKsv/GjX
	 R4mO9cmIGmgn5yd93Kf6AdHxhIWEvtB2wqV86hpY8F1WcmpZNfQme5F6d6h5bQhDm2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMF+GcMEfCmUMserBqOUckRpML0MKqrz0lPVqx9Nu6I=;
	b=xMF5wvn0PXuK7P18Q1ir6r47R/afSGiLokgM0Kj3pbtfMM8mUgrp8dLAV7JWARE5FG0G
	 o03+wrvcjcc6qsQnQ8Eu9h9RvudNnJRxXC2zWtgcZCidKinz/on9PUs39NAlZICuVDPqd
	 /NN2Qg47wNLh1hedkjsU57Uuwfn4LSUur5FS4Kd0pVsIFkQkMi0V1HsNRCZUcC2Muf+tF
	 DFFth2e8K+TZknjRELqPgtKgl73Fah5EkhsdRQRW860hoINejSjONF608RsnbzHFR304Y
	 iwdpJtkH91HCTYe1DaUVrywHMCvCpVXES11e0lVPFhizhlhaqe7e1LAFwYLqumgnaBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHADJ21t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0AD606A330;
	Wed, 18 Nov 2026 15:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WHADJ21t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC051F000C4;
	Wed, 18 Nov 2026 15:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015246;
	bh=YMF+GcMEfCmUMserBqOUckRpML0MKqrz0lPVqx9Nu6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHADJ21tuzmhPEqbX6DVL5m8yqHC6Xb81ZyF2KUOYR+6/Nz7YruGHOZp+yT9uVZbZ
	 K3aZIpVTP3PgMctmqTTsX3OI3ClI1MAzxYpF59UGyEckMEX3631IaZwMS1QKAEtFF+
	 PKQiOPwv/+rxjS3xWGX6JuxrSV6KLDw2ik+XlUU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0104/2651] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:22:24 +0100
Message-ID: <20261118150251.632170224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 .../arm/boot/dts/marvell/armada-388-helios4.dts | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 1ed6ddf1719a7..33e30528bc7ca 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
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



