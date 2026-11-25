Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617774;
	b=bDMtYus5Rj0MN1YRddM90Ef2FmMF/tUf6JRd1QK1HGY9rwO+VgcPCWRF/Hop0sn6sFg1
	 M1+OjVr1RCIHALW3Hn3WquDtcBpf6UjLc11DtyGF1BAaMS4PRLU2TIt1W8T5U2MnyaNJH
	 /DhhiPgmR2PmNKnDNrs8zQC4mKUT5dIoBKnrtPYCTAfvDuvrI65zQZGBRBnLWWtjji3rB
	 KlVe9uvLANN4jnETDRJnVrJdpJ9e6jDm3mSdkaUwuGh0YM58DXWdi6gtqZ+YF2vSnnG6q
	 A2P/G/dtS3VK2mvS0nrIxBAYFIbYT0zMZS6X1jN/nUfJ+HCdKFx/06EIZC2tobMmIFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dlwBNv18gGlsyO2oEuMX5o0JrzXUnRSl+sk46JW7GU0=;
	b=Kwg9fInCkroVNBAy2QoIXFTsRZAgMzae+Tu3Ic0kxhFlkNJsTI6v95T7kFv3gu6cw+7T
	 vGdYybilD3FLYaM06fLmf6cenUnWVjC2RxEzLQTgXhODFVadRvoElFY18Vfb9jQI7EDqN
	 BfNcx6/L3bTQrG7QHto1MKLcCOFrK5eApcfsqeMlao6GgiWZ5WXWZxY7+amyaMww4pkUG
	 HfnayVBeok9AA7d3Oz1MhTjqrKjZFZFRYo620J+5jYWQuACeMSQKul4pX0cC4nSlm2TpY
	 lNUMNKkbqgf7YuuxB9b5MNCchyw1RmBHG/C5GwMMOHf4lRTgDsMBmCszWWrAgYhi+pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZallGJje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8408D606A323;
	Wed, 25 Nov 2026 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZallGJje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985681F000C4;
	Wed, 25 Nov 2026 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617774;
	bh=dlwBNv18gGlsyO2oEuMX5o0JrzXUnRSl+sk46JW7GU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZallGJjeokSZqwsQj7dDz+GleBJbPk42JJxi0t6zrA+7ZYPZNnRSQ9o1YTIVQzsMI
	 D65JY6HQjLj5hw+IMdFx5NEbh4Plo3FIVpKI5GKT1HHoW3HMTm1t3zaLnJt4M46SSw
	 3FWoTF+03ap7NB8+CG32Apsoydvb07m5BGDuw3XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0025/1005] wifi: rtw89: usb: Avoid crash with dynamically added device ID
Date: Wed, 25 Nov 2026 15:22:43 +0100
Message-ID: <20261125143822.326259581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852au.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 8 +++++++-
 drivers/net/wireless/realtek/rtw89/usb.c       | 5 ++++-
 drivers/net/wireless/realtek/rtw89/usb.h       | 3 ++-
 7 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 1e827205f2540..6672ebe68f172 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -59,10 +59,16 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
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
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852au.c b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
index 065f4e5b17afa..1a2e5dfbaab3c 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -73,10 +73,16 @@ static const struct usb_device_id rtw_8852au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852au_id_table);
 
+static int rtw8852au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852au_info);
+}
+
 static struct usb_driver rtw_8852au_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852au_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852au_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852au_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index de79a19a2824d..550fc4ac7a21f 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -73,10 +73,16 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
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
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
index 2dec9b8454815..6f852f4a713e1 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -133,10 +133,16 @@ static const struct usb_device_id rtw_8852cu_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8852cu_id_table);
 
+static int rtw8852cu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8852cu_info);
+}
+
 static struct usb_driver rtw_8852cu_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8852cu_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8852cu_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8852cu_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 56c79b1ec865f..2cd2b76d19acf 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -74,10 +74,16 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, rtw_8922au_id_table);
 
+static int rtw8922au_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw89_usb_probe(intf, id, &rtw89_8922au_info);
+}
+
 static struct usb_driver rtw_8922au_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = rtw_8922au_id_table,
-	.probe = rtw89_usb_probe,
+	.probe = rtw8922au_probe,
 	.disconnect = rtw89_usb_disconnect,
 };
 module_usb_driver(rtw_8922au_driver);
diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index 22a1a988f3073..8dc2c93e502ee 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -1206,7 +1206,8 @@ static const struct attribute_group rtw89_usb_group = {
 __ATTRIBUTE_GROUPS(rtw89_usb);
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id)
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info)
 {
 	const struct rtw89_driver_info *info;
 	struct rtw89_dev *rtwdev;
@@ -1214,6 +1215,8 @@ int rtw89_usb_probe(struct usb_interface *intf,
 	int ret;
 
 	info = (const struct rtw89_driver_info *)id->driver_info;
+	if (!info)
+		info = default_info;
 
 	rtwdev = rtw89_alloc_ieee80211_hw(&intf->dev,
 					  sizeof(struct rtw89_usb), info);
diff --git a/drivers/net/wireless/realtek/rtw89/usb.h b/drivers/net/wireless/realtek/rtw89/usb.h
index bdf3125597438..d2af29d068f19 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.h
+++ b/drivers/net/wireless/realtek/rtw89/usb.h
@@ -95,7 +95,8 @@ static inline struct rtw89_usb *rtw89_usb_priv(struct rtw89_dev *rtwdev)
 }
 
 int rtw89_usb_probe(struct usb_interface *intf,
-		    const struct usb_device_id *id);
+		    const struct usb_device_id *id,
+		    const struct rtw89_driver_info *default_info);
 void rtw89_usb_disconnect(struct usb_interface *intf);
 
 #endif
-- 
2.53.0



