Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD1413B2B3;
	Tue, 27 Feb 2024 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042828; cv=none; b=tnnie5rQ9q1x3QTku+mrnSuzwWgDb3MBziYxOMkhL2rPcxk9Cm6hRwYp4l9EkZUBxi2xfiT5RpbqjcQBWlI6iFzPP2RrjnKiJPnlpYdkDykglS2YsRy7xtSBMSMM3I1I6ANTZi6F7BhvRp6oJJ7nhXqVNdtZr4TD34gGAZv4iEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042828; c=relaxed/simple;
	bh=NvBke//oTVEsye27O0J4EbYRJdSk0lRI8tJZ2XR99dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NM+G0+CvgIDYn50d6Xyl7KJcpCem7K4zFGgLfZzCpxsmFdm1i8m5NrenK1t75sLAqKGc1SwN5sYp7Y/tdfr1Qaa4/OICYdg1qbrvpW8DduEIz2mAUHUwmkLwEWgkSm3Z/aIsxT9kfSkmf7ZAJIajkjjT+icD3Av+hEYJguSAUIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoszFYWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoszFYWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5DBC433C7;
	Tue, 27 Feb 2024 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042828;
	bh=NvBke//oTVEsye27O0J4EbYRJdSk0lRI8tJZ2XR99dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoszFYWR5ycXPLgXpGKYqBolHqyDaCALk6/kPeGbrRxxdCkhOtqtJEsYNMKdW5Djp
	 xPstnukifCxK58ZUFO8zZ9ZPOuQ89HYbbHsZJXnNLUExISE1uZTvIUXJXb7RBD3OwS
	 Hm4nEL12Ihc1Rnr3m57VvVyq4SpXGGb/eAR3Nwus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/245] ARM: dts: BCM53573: Drop nonexistent "default-off" LED trigger
Date: Tue, 27 Feb 2024 14:25:24 +0100
Message-ID: <20240227131619.634812489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



