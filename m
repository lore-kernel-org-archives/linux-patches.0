Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC5F13AA4C;
	Tue, 27 Feb 2024 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044125; cv=none; b=qpre2PWTrT4jhHJhtiNinIebQhrK97ShzPUScWcO5xE9INDcTWZ44BzFoFtcH3Hjj/LU1heGWzkihpnK+vdEdp5H/BfPO7AjBlqGBRCjC9FS8S0jrKSoI5PK5CGCNFb2MbcEULmsBZ4jEPaCntQVG8UbFcz+kK+wvhtZJqRaygE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044125; c=relaxed/simple;
	bh=BoguvoyAGxvfb4jKv56AS6ldI+WHjp9VqJHlSAB2p5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hoJGYA4mQ+WylWaBT+FndvPfkVX0/ojAcnwwjBXmVPdlBkg/5AS0qwVTBHVVdQf7+w+vpZbBDj1kZ+fV9kESJj6jL9yrLh2Ywn2OSy+xpnE1UA9msFWAYzMFfihszu1Ru0z9+fWhM0soo8pVJGCHhqH4Yu3it1lC1s6IOUse1kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQwRZqu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQwRZqu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF61C433F1;
	Tue, 27 Feb 2024 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044125;
	bh=BoguvoyAGxvfb4jKv56AS6ldI+WHjp9VqJHlSAB2p5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQwRZqu0CaqRKYTnu3/xvM0UpbRgGrO6imC7fE2qE6WU57tQwUD4TAAlgP8OluACB
	 /pXfBkH50F3WKQRm2MVWzp2tFQrKMzbGmPO/I5d7OuPaWFonNoVZQTOaJni4Isddd8
	 Qx9FkEKWlene76Zns5V8S8cLmLzF6Js7hPZcFWag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/122] ARM: dts: BCM53573: Drop nonexistent "default-off" LED trigger
Date: Tue, 27 Feb 2024 14:26:44 +0100
Message-ID: <20240227131600.118833299@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit be7e1e5b0f67c58ec4be0a54db23b6a4fa6e2116 ]

There is no such trigger documented or implemented in Linux. It was a
copy & paste mistake.

This fixes:
arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dtb: leds: led-wlan:linux,default-trigger: 'oneOf' conditional failed, one must be fixed:
        'default-off' is not one of ['backlight', 'default-on', 'heartbeat', 'disk-activity', 'disk-read', 'disk-write', 'timer', 'pattern', 'audio-micmute', 'audio-mute', 'bluetooth-power', 'flash', 'kbd-capslock', 'mtd', 'nand-disk', 'none', 'torch', 'usb-gadget', 'usb-host', 'usbport']
        'default-off' does not match '^cpu[0-9]*$'
        'default-off' does not match '^hci[0-9]+-power$'
        'default-off' does not match '^mmc[0-9]+$'
        'default-off' does not match '^phy[0-9]+tx$'
        From schema: Documentation/devicetree/bindings/leds/leds-gpio.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230707114004.2740-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm47189-luxul-xap-1440.dts | 1 -
 arch/arm/boot/dts/bcm47189-luxul-xap-810.dts  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm47189-luxul-xap-1440.dts b/arch/arm/boot/dts/bcm47189-luxul-xap-1440.dts
index 00e688b45d981..5901160919dcd 100644
--- a/arch/arm/boot/dts/bcm47189-luxul-xap-1440.dts
+++ b/arch/arm/boot/dts/bcm47189-luxul-xap-1440.dts
@@ -26,7 +26,6 @@ leds {
 		wlan {
 			label = "bcm53xx:blue:wlan";
 			gpios = <&chipcommon 10 GPIO_ACTIVE_LOW>;
-			linux,default-trigger = "default-off";
 		};
 
 		system {
diff --git a/arch/arm/boot/dts/bcm47189-luxul-xap-810.dts b/arch/arm/boot/dts/bcm47189-luxul-xap-810.dts
index 78c80a5d3f4fa..8e7483272d47d 100644
--- a/arch/arm/boot/dts/bcm47189-luxul-xap-810.dts
+++ b/arch/arm/boot/dts/bcm47189-luxul-xap-810.dts
@@ -26,7 +26,6 @@ leds {
 		5ghz {
 			label = "bcm53xx:blue:5ghz";
 			gpios = <&chipcommon 11 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "default-off";
 		};
 
 		system {
@@ -42,7 +41,6 @@ pcie0_leds {
 		2ghz {
 			label = "bcm53xx:blue:2ghz";
 			gpios = <&pcie0_chipcommon 3 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "default-off";
 		};
 	};
 
-- 
2.43.0



