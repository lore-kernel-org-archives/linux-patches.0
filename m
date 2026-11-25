Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620902;
	b=WJQPL+eIn2sTeVKoO9t2sVOeY9atOTy4XJyeQLGGGA7BWEPZoY8wVhS48WVdE3J/JKxE
	 KxJu5yPyL5u2LUPM2mkigMpSvAQfntL3VnJGgiGvHe9qK3JKCbBs/0w7clG7fcGBMsLNz
	 cgalLlX3x9XiIgvHAkR6W5vLfZ/HMPXc3NNW6Jul/RPeajFmedE0x8B7w04J1Y6gU0HgY
	 11vH3JgqlvErFJGFeMDcgC81GWS9CIanCdF82W/ZrXup+xU92xfOkPBbSfbWJuaM2yeKe
	 /ZnYyq9CiwGR3iwPQM4WmMT5dFswqS7FK4AcEKWRU/z4v58GA+dACqT1EqZrOWGGVAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0F57NnWc1mk+X8cvwFG6eLmYzqv0VoFylcA6m7ZBuD0=;
	b=0WdM32ha8P2uIGBtYykzYkKZTQczMcNXbxFxV4mAuSLfQv8eg7DIHf9ib/KXj4Zz2Pxm
	 pVKlaEuRNnW10N9s+wxn90Njgbg5kUgQs/lutWKbPzZHVIEEHK9DRkIduU8ra6bMDkUAo
	 zoI25gpWVplMB2JhjXoV/6LtRQzbe5yYZsc/o8zu7u/Kud4B4rizb2EZt7SGeS5mH+Bz7
	 fKgRWYpddJu33ZslHCYhAiN4XdA7CqcWlhu+CS4P5TRZOC2jnHgyGm/HtzqpsMPu4YFOI
	 4voyrnxJY3UotA1zXg6eX6Dtav7IPHIiEzZ1sBcx31JjScd1XaHmBzT+U9EBh9F7PDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5QMvLM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141AB606A31E;
	Wed, 25 Nov 2026 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5QMvLM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CC81F000D0;
	Wed, 25 Nov 2026 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620901;
	bh=0F57NnWc1mk+X8cvwFG6eLmYzqv0VoFylcA6m7ZBuD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5QMvLM4Nsy6wgZpbXwWnpOqzAR3S/vTJcJyab7reNBucwsu0zSW53A9TXgT5g1Xu
	 A87gIfbTxFWK6aQ6FYf+89hF5R1Sm62H9+MpoPCfylaguPItvDicvqVZaD/CvEAZ/u
	 uWA2bPjsMnJPlRXV3/TlhX2+jqcxYUyhQvLPgXBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/990] wifi: rtw89: usb: Avoid crash with dynamically added device ID
Date: Wed, 25 Nov 2026 15:23:44 +0100
Message-ID: <20261125143823.422400975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit b1827227176821af9bba0cb643728d23328f3660 ]

Adding a device ID via sysfs causes a crash when the device is plugged
in, because the driver_info pointer is null.

Check for null driver_info in rtw89_usb_probe() and add a wrapper in
each driver to pass it a reasonable default value.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/7a537b2e-67d2-40fb-8ef2-fcbc7bbc93af@gmail.com
[ Dropped the hunks for rtw8852au.c, rtw8852cu.c and rtw8922au.c,
  these drivers are not in 6.18. ]
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/usb.c       | 5 ++++-
 drivers/net/wireless/realtek/rtw89/usb.h       | 3 ++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 10fcfade6151e..f9078923bbaa1 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -32,10 +32,16 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8851bu_id_table);
 
+static int rtw8851bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8851bu_info);
+}
+
 static struct usb_driver rtw_8851bu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8851bu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8851bu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8851bu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index add5987110b33..fbeb3f5b7375d 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -46,10 +46,16 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852bu_id_table);
 
+static int rtw8852bu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852bu_info);
+}
+
 static struct usb_driver rtw_8852bu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852bu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852bu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852bu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index 512a46dd9d06a..faf1e471e3040 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -931,7 +931,8 @@ static void rtw89_usb_intf_deinit(struct rtw89_dev *rtwdev,
 }
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id)
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info)
 {
 	const struct rtw89_driver_info *info;
 	struct rtw89_dev *rtwdev;
@@ -939,6 +940,8 @@ int rtw89_usb_probe(struct usb_interface *intf,
 	int ret;
 
 	info = (const struct rtw89_driver_info *)id->driver_info;
+	if (!info)
+		info = default_info;
 
 	rtwdev = rtw89_alloc_ieee80211_hw(&intf->dev,
 					  sizeof(struct rtw89_usb),
diff --git a/drivers/net/wireless/realtek/rtw89/usb.h b/drivers/net/wireless/realtek/rtw89/usb.h
index c1b4bfa209795..fe0f86dc7794f 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.h
+++ b/drivers/net/wireless/realtek/rtw89/usb.h
@@ -59,7 +59,8 @@ static inline struct rtw89_usb *rtw89_usb_priv(struct rtw89_dev *rtwdev)
 }
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id);
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info);
 void rtw89_usb_disconnect(struct usb_interface *intf);
 
 #endif
-- 
2.53.0



