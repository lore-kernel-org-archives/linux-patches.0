Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022841;
	b=DJYYOjL1IHCzibVj/S4Het/3p8Trhb0EfwrCQKpZYE0kpVCRVtQgB/B5KnMsBdc7o9yt
	 4Q50UxNhqCC/UFE0laZgNxccqGHanQsZ8RS2xm6Z3UcbPq3+uEOUyrn+uZcE1JhJeWgip
	 IYMBlqLDZxohUeESRAarCjHfTH0BjcAzZcCmmfujeezMiCnScagXQJzd29P9HhrGGeAk8
	 5uHzduxcVp+Z91I9y6lLU1bN3OQiRVqv3t+9aLCE5iZWdmfH359WBFI/U6EeTGfxGdiHY
	 fH6xdf9G4MvE0z+VQF2kvYORbN3EbnecV4ZwMoDaQK5mGxy3Am7y6jk8C9KAivYSJKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J29ASi68z97DGImyObfJzsylGVi1fcEY/8GpOMmAsok=;
	b=gfPaWTf3mYX8tRCvhSpvuO+MVNG2b8wsMZ9XAAs6cM2RiVb+DLZol4z6VxY3Y0y7DtQJ
	 p5BokWACtjNQjuJvdHxhn7LUXTzbTg8lKebB3yQDx3QEHDOKwxeIdiHoS7syGjZSvWsGx
	 QVr1xx/1QlFHgZuvir2dkXbVdVNNtBb/33GQAFXtwBzrwcbmx4lJHcBzrgEukGQdSEfa8
	 n2QtiNl8sefaUazCuNa017ydZXCbL2EZuRCBeg0s60bZGxrs9ZeRU+pXCZphXP8t6+HmP
	 NUL8V+nsoy8dqfzZ+0jQhyRzIX/sHQDLDyOUCHyPflWDmISuzVcmraBvGJJrgA9O+8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHC+OZb2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE355606A33D;
	Wed, 18 Nov 2026 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHC+OZb2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C77F1F000C6;
	Wed, 18 Nov 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022841;
	bh=J29ASi68z97DGImyObfJzsylGVi1fcEY/8GpOMmAsok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHC+OZb2rSJke3qrz5JJmmGiGqsp/d4QoEJNcebVdWVtSqwGPbu5K0ffd2Y90Sq+M
	 zlmPXZ9Lol4KxY4izgouh/xV3nEJTI7saDImc5hT3tVln+OM/4eGzvYR5wBywsKGsv
	 ohR6M1eZNMfxpZmx3jgBEqkFPwSGFGwMERCKnLdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0157/2151] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:31:32 +0100
Message-ID: <20261118150127.478280466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



