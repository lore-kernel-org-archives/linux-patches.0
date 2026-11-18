Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060703;
	b=bi/5p9NIjLVgTncw1dmY/CM10pjqpoN79lAj0yJAMRoxSSNE+A+jSLxGfGbRTfiOxukv
	 V9A6W6l6uWr+6pgbhBxOZZnGYX3qEPDq3OQp8RhvNMqCus5xRZntJ5PcXclemS+ROy2Xt
	 YMxC1oe9yy1VbRGArH4ajnLn6ZRgtFixHOF3e1G2pM7o6QrXtqLeuAasaZW4M9IYhYo63
	 CqitkFdwCbY7GTR2HBKojzAOakNMfe4OaejUj8Ui0wiaVqiYafsvxJCiZ/sz4Usptzih/
	 32Rh+DToCDrpN1hkd5fvIv5a290iaJlacmbDR+Yya4b4DY9JAT7xxd6Xd6VBf37GcTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9G91N+EG7LVMwu2VG+l1zRGAw7GawcA5dBo4fY4TUhM=;
	b=a/oautg13BX6u3fRYFkASCLJOFQxxJtP7COzK0e1otQIiJcpJeCb38CTeSJGRsPditZx
	 vecKXBrR8o1PlWJhXevHL0n+2+KLrwiLLhHf7PtM7I1Kaq3hrjuVt/n2i9SuCaGs9jqZ8
	 bV8D+GmWp4JQq9/CmqVJvmH2dROJwjdpq3GlWkiADZRrumApooK6A4Zp6qvgC7tICy9Am
	 5BlYLtmVDNoPedJoVBZvup2KPNW/KnwX17afnD+3eCbY/t2mXEAcRxxnLpJJr5N78p3OC
	 hQDHl6I7JZIikIIgA26e78pR4G0y7C6lrdOQ/RXLXWLutBMn76pWrMcwW9ltiDR/lIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFHQgPXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D7D606A325;
	Thu, 19 Nov 2026 03:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFHQgPXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD01F000C4;
	Thu, 19 Nov 2026 03:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060703;
	bh=9G91N+EG7LVMwu2VG+l1zRGAw7GawcA5dBo4fY4TUhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFHQgPXi39KvcHUXhs4qvYf0fOBUkoqFETJhOFf1KT625udC+qoYu/Y/B3bANtidL
	 VH+XERPmPwioGBMTzv/JlgfIuqvciUjpVNKRytfZvx8rmNkJXS/jsGHaVwoldFOcuS
	 BbZ39Yo5rhje+zkqc0gah105HLl51AtY1nA+wJto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1295/1848] wifi: rtl8xxxu: Use dev_* instead of pr_info
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150013.749276467@linuxfoundation.org>
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
index ff161685ad75f..cdbb39b3986ec 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1996,7 +1996,8 @@ static int rtl8xxxu_download_firmware(struct rtl8xxxu_priv *priv)
 
 	val8 = rtl8xxxu_read8(priv, REG_MCU_FW_DL);
 	if (val8 & MCU_FW_RAM_SEL) {
-		pr_info("do the RAM reset\n");
+		dev_info(&priv->udev->dev,
+			 "Firmware is already running, resetting the MCU.\n");
 		rtl8xxxu_write8(priv, REG_MCU_FW_DL, 0x00);
 		priv->fops->reset_8051(priv);
 	}
@@ -5228,7 +5229,8 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
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



