Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13CA7EEE2;
	Wed, 21 Feb 2024 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522532; cv=none; b=bE5MHfFJuovUKKtMm2xRiJNztxlYMM6jLAwZ9ffDpxR4QwH15tT2j3zq4N9Xz2+OZPW1/HRr+tjuRzbQIdZ1A7EnvRnQwNqHLZrQLMvff0E0POd2gEOZE80ciHVmQdVXUp9Gxa0qZEAVcUeKxw2GGi6FSbK9mfIoY9mjpNAih2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522532; c=relaxed/simple;
	bh=ikMyxss+AwqJq62c56GN3pSAI1eH1MLvlNcOaM/RO2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNWSyjqb+0FOH0Ml1meXKaqCu+em2pJP9QuwsL97k4DTmPxZkDjrutLmEEPebUVjQ/Sp8vcQ20fDNoK9obuDRomgsOvG1rf2OzAumO7BVdv3yN2mh2OSyEo53LjzWcWxjfe+YQ0UFH7FghhQq6uE1mY3+h81IpYkcOKUK0Pe6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbeA5nQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbeA5nQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D44C433C7;
	Wed, 21 Feb 2024 13:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522532;
	bh=ikMyxss+AwqJq62c56GN3pSAI1eH1MLvlNcOaM/RO2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbeA5nQ//3AGwKDa/c4bekaIkDleEvNDHLj4fd39uBZyoLmz1GvBv2cm8W4rwTl8s
	 Ko1ZyFtOCE3ifvJHthxVxzKePWwL3fe3FddRbov0c+5uAwgdpAC9ZYgBTRDA2Xecum
	 UOouR/ySl44FihQJdgwjBv5vsd4UBl7lbkn0zMYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/476] ARM: dts: imx27-apf27dev: Fix LED name
Date: Wed, 21 Feb 2024 14:04:01 +0100
Message-ID: <20240221130014.924498680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit dc35e253d032b959d92e12f081db5b00db26ae64 ]

Per leds-gpio.yaml, the led names should start with 'led'.

Change it to fix the following dt-schema warning:

imx27-apf27dev.dtb: leds: 'user' does not match any of the regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/leds/leds-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27-apf27dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index 68fcb5ce9a9e..3d9bb7fc3be2 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -47,7 +47,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gpio_leds>;
 
-		user {
+		led-user {
 			label = "Heartbeat";
 			gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
-- 
2.43.0



