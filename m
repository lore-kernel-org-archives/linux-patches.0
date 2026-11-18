Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039164;
	b=clDLy+vfHNKj/eZu+cUiTGNoV6+Gms9kmCHLb/DyL7F/qkVvEUy2wYuCBXTbI6rd1Q9V
	 2vQmAsBJ34vY2M3fgbusKUPpRdkbYzLX829HLpyNZAX4vcivlC+YyXqewkZiMQLUv8AbL
	 ZCGfvorQpd1K4cYBL8aOfZdgeH0k3dVoejMnAtck/I1Fe1JcsgmY8lzm/65Ri8YYoy/OM
	 1aMTBsIPl1r4lKF1kecOhp77LFHCMGugc57xGpYufAVixy94hrKuymyjkcygn5/PlvLgE
	 /Ja6Qa5HjhlfUyx03N36loFN2+PfMq50w48Rx1eClX0ErA/MpWxgnOTaBU+cRE0CFsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KOmAa33yXDUnPDbHvheNGGuFwPvCXf6kgY3+LsKrHzo=;
	b=OoR2ALlaU/LGr4agA9NO8izpTJ6V4wCXV670oysGGgqXVCH3ebypOOWzKTIOzcJzNd7o
	 +HWD9SgVFSDt5Olc3GnaHI5KPk53hcemwzADWox/lYgskjlmsKTSTUQKI66BfYQAk6WOC
	 o5s3Sq+/KybuOqEA1au48TQb9sbbKRjEpr6aFAjLKVJG54IOhn3xJwMqJhBq3IZUywMYw
	 6uRlhbVskDQo/qTJahQY/LNMjahol5SGTNYuu1MMgdG/bffSdLivyB2OZYFblmHRpc8pA
	 pddiMeFMzjqGaNfZCMQVpLtCj9WZ4d6KPngCBuYqbxsk3vKQP9UbVIucVJHWJyF2Z6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAyg9wVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8724E606A32A;
	Wed, 18 Nov 2026 21:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAyg9wVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F111F000C5;
	Wed, 18 Nov 2026 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039164;
	bh=KOmAa33yXDUnPDbHvheNGGuFwPvCXf6kgY3+LsKrHzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAyg9wVa0/MMvSVJd+kwttdF14gjtpi7dvn14wvkjFYKn4SWgmMklTz89/8DAIrhF
	 a1FfFDwr2yUwkdLWizmS8JHj/gtt7LJ8QOXv1dQrMUndykGuiEzQ0W+g4qiOTY+4Cb
	 IyjC1EpWiJiZCIIi1Uv7erv/glW+AllZWvrjv7cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2000/3318] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:43:42 +0100
Message-ID: <20261118150422.051596143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



