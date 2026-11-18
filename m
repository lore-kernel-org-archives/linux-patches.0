Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060249;
	b=AwkxMj9OvFzeHP7Osx78h6w4nm9MuXVIlitizyr4dzXO3Nw5pjLS7Ca41qjgDQe4SSRg
	 0H8xY2UeAi3SoPiPM9XYQz/VCXp2w5cvcQ3kFLw18LWX95TeEh6MneWfR8OoH8kxb/IrP
	 BqqdKzPhSqjNy3QLmVotZK7L0UZk0bufu0/Lu3XqHYxrxuc+Hu89mnX2qHvfMZtG9gguD
	 Bp2HVYlFEAgv5WjpIGe2Kyff1aCcjA4c36oGJRcu3EmAjI3Xp/CkYi1OKcwqxr8TA2b0B
	 JXAKMQZ//fGXvvoseSjSH65rmOTgY81XGjsoCSRWmni5CuwgkvT70qa1Qdofkm6gK9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKYZp0Cm/esOhuWb0UEO4EAnl6UrUhfjlkOZkSQSBZg=;
	b=y/eOY8fFdo1eELt5mzyNq8RT/c44mWR1MCRFeNaWgY9LlyzYt7HX5ATDxf7lwo2Ce/N2
	 A+wrL9m7D3uhV4T+ng5Y3+phHOW2scBW0hnmFghg5MHfOymaVVH1HqH/xrG6fWdo1oFLP
	 D6r5AvhGRlWuKA3WdJ1CnULTyOSOSuQI0szxb+RgS2v5VG3iFRResJld7QuaMMhB4Zntl
	 G/yCeIdsbIG2uxRpiqI+Dsvf/h9M8tuFCK7Cn2iHRasb4h1Kp59mlD+B3krery60gclOn
	 PGCGjS+ZRayNjSzqWEIyzyo19SSd1rI+bYAJtK4EuhPYIfN6rRehrN/NFTuZYk2GEQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Do38rlLu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9FC606A325;
	Thu, 19 Nov 2026 03:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Do38rlLu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221C61F000C4;
	Thu, 19 Nov 2026 03:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060249;
	bh=JKYZp0Cm/esOhuWb0UEO4EAnl6UrUhfjlkOZkSQSBZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Do38rlLuw0QduBM7QoD6kov+etL2I1qkceOB3OQ29cnk+xPeI3dMNU8m2dq+mhWjy
	 pGpFOaZZCY7VGMxV9Dj54Gaa9FDRQx2qWhzgsjGDkr4be1ti6Hk9RdhbIu/MS0CgPB
	 wleYfc4jd2FhAXP9pAUpI7LLGH2cfM3t36QNqW6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1131/1848] ARM: dts: helios4: fix spi1 location
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150006.675555492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c397e13e78afd..be1a6eef3854a 100644
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



