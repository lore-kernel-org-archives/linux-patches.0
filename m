Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032336;
	b=Mi8eBbjnMWFAE6/x+K65PUG6VKsHIZOVjFGKlzIh6aLqb3E/XZQwm7Qh6i3m6uxM4anV
	 tu2ajJcPfu3KruYGoLNrMzi3cVqu+dGnuRoJvbI767NyXw76/xIhaw0Ik1hxL3b7cODk5
	 w1BLyVTTEEU4ecl5h1tO4r7XQtnNO+WfBwp4IP8jKDVNxFc6a5tX4k1cdtBONhQhvmHwo
	 uAgWmez0DGGO0/h7hr8fDFdUl93kfofdP5o//96p1fT+ZWcSJ2syY0OxrPAYGWVdM690j
	 /qHrJJJ+o3gcOrxLIYfGH9OjpX+ZqidqaESfRCPtMDz7cCVYyEDCyeD6p/4g97TE/hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xjkplVVaEpvwvGUvBmNzikYvKG6AbZQtm4nL7ZbTf48=;
	b=fDchrcNHWITlWja2LShE/SJcBJzKsZqcqqrqPQTFMgm4bZ5lRK8o+tUo4fIKDRmyXb7C
	 +sWjQVSqVM/5vacWZhqx7liohTUkkKy8GMWV1cvq1S2+ygaEsIe4ILmCGcZAmM0+mkJGj
	 wKxHfAhiphLxxF/2rYNLygd7pDZbWSEqS8mhsGnRbTc7cSrA3DVvDkUYE1FOMciHAeJPc
	 fsU6/ugj6G/wt9RNYqIKSmR98ej0ukwv0wDcK5kjLWha9N1zhLz2CLa0MC2BuK/lW7p+i
	 VnMSNMfouDT93BaG6Uz/CBn5BLRU3Q6MSkvdkZ8/luHHb+Uee80yS3KPDmWGxPzxHsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1q7M3WvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0746606A336;
	Wed, 18 Nov 2026 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1q7M3WvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109651F000CA;
	Wed, 18 Nov 2026 20:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032336;
	bh=xjkplVVaEpvwvGUvBmNzikYvKG6AbZQtm4nL7ZbTf48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1q7M3WvB01KmmCZsYftfbvxb85eFkgek8x6usX78NAE5OyZjwjkeqoAzxw8OJpJti
	 e2XUcnlgTnqHx77AbVeriXRrN9+IaCBXDAxLBA7q7ogXr8I2XAnrctqvtoWUIxG4eX
	 s+SRtPRX63yd7Hij+/apq28TJ9uKbhXj3TMYYKZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1324/1756] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150102.132644677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Munari <stefanomunari.sm@gmail.com>

[ Upstream commit 9272297df14124fe603c81e40b52ff0c5dd88652 ]

The runtime PM handling removed the -EINVAL return for invalid
EEPROM/OTP write requests. These requests now return zero from a
successful usb_autopm_get_interface() call, even though no data is
written.

Set ret to -EINVAL for invalid requests while preserving the runtime
PM reference release.

Fixes: 8a7ffeb795f8 ("lan78xx: Fix for eeprom read/write when device auto suspend")
Signed-off-by: Stefano Munari <stefanomunari.sm@gmail.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de> # Raspberry Pi 3B+ (LAN7515)
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261010213248.15938-1-stefanomunari.sm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 69960d564a974..430a47ed64a20 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1740,13 +1740,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
 	/* Invalid EEPROM_INDICATOR at offset zero will result in a failure
 	 * to load data from EEPROM
 	 */
-	if (ee->magic == LAN78XX_EEPROM_MAGIC)
+	if (ee->magic == LAN78XX_EEPROM_MAGIC) {
 		ret = lan78xx_write_raw_eeprom(dev, ee->offset, ee->len, data);
-	else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
+	} else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
 		 (ee->offset == 0) &&
 		 (ee->len == 512) &&
-		 (data[0] == OTP_INDICATOR_1))
+		 (data[0] == OTP_INDICATOR_1)) {
 		ret = lan78xx_write_raw_otp(dev, ee->offset, ee->len, data);
+	} else {
+		ret = -EINVAL;
+	}
 
 	usb_autopm_put_interface(dev->intf);
 
-- 
2.53.0



