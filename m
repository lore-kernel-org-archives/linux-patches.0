Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048451;
	b=WJZVlLnAhbTUUkz6lqvO/TmYDGIDJ15hjna2mGxH24itGw5DFSFpS5yaY1WmNbCkyyE/
	 Oi8qtQORWjc463+GxhG1yfIfnILPzfX5lC/wAWCxRxqngzfqnARGxQpNzi20c+QxSAmcV
	 x8s6hduWaERRejdOG2cxunXRsh+NmWkeff5R7RmYmYwLNIiMNHU45sqYtaAlkbVqM2dtf
	 xLy4lsIonPKh/cYaUtZB5XyPLdcO+cjFV6s77csRmiZ/l7v1MPnNg72KzIbLoqUwpzawd
	 WngfeSJBsEUjtCqv9dqqH+kMrGI0X9VhVRy0VH+BQPPnlxUXo7pr7PAp/rQoxBG3p3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OhPLXIH4OyqZLdAFykg+vG+lDCJkA6TUOfAy5NAtBQ=;
	b=T7uctFgu1vbFsNmCamuwkb6Jmn4PIPyaT72LK15KtAFEbzvzZWQLSF8OeWs3eB/HfDzi
	 8LrB+KZO7zyrtr2ulNgzSlB3vG0cszhPfeaa7YoSGre1YI9UJfU2I/+g4e5THROVQQ5T5
	 oL02XpaAuoJoF5YQVAYZ3w1HfjfL7sUcvLGJnpjiTrrV82hNVpRs2PWD9xNIW3Yu55WBw
	 rDISXdUkPavnNEM5XSs8p9vBBQdsNxpshFjaua6rj9ajdHKCQ3kxacEdCdHeJ3PAxA/qD
	 lYHgUpUMk0mgo69c7wmsWnCXcmtBRIBoUO2F+ewos5Vf6ripc4Q3EPckq7NnO57Mprw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQ7yWbop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB32C606A334;
	Thu, 19 Nov 2026 00:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iQ7yWbop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFF51F000C4;
	Thu, 19 Nov 2026 00:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048451;
	bh=1OhPLXIH4OyqZLdAFykg+vG+lDCJkA6TUOfAy5NAtBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQ7yWbopPWiG1I6+ZNx8+ZxIAQ7iO7w962fn3U7+kiPSj8H6wnMlKQuxZXldDiTzl
	 7vjWgMnxvTitxv49+6ht1rUStu5AgUm7JYkXtUqNaPOXWXIoKBf3Rrgzjlcgq3xV/b
	 twjFOiGxXwylcQIOGJ2LcuUVi7dgz5VFVpvr5/+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2000/2857] wifi: rtl8xxxu: Use dev_* instead of pr_info
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150313.376602900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit bd954a7e4aa0739630884fc572d2d0e4dcd16e25 ]

Replace two instances of bare pr_info with dev_info and dev_warn.

Also make their messages a little more informative.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/c9f3ebb2-769b-7d80-cac2-5a9d1bcc010a@gmail.com
Stable-dep-of: 9f7edf4e8584 ("wifi: rtl8xxxu: free RX skb when URB submission fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 20a7537d2cae8..19eadfd65a980 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -2000,7 +2000,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
 	if (val8 & MCU_FW_RAM_SEL) {
-		pr_info("do the RAM reset\n");
+		dev_info(&priv->udev->dev,
+			 "Firmware is already running, resetting the MCU.\n");
 		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
 		priv->fops->reset_8051(priv);
 	}
@@ -5320,7 +5321,8 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
-			pr_info("failed to requeue urb %i\n", ret);
+			dev_warn(&priv->udev->dev,
+				 "failed to requeue urb with error %i\n", ret);
 			skb = (struct sk_buff *)rx_urb->urb.context;
 			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
-- 
2.53.0



