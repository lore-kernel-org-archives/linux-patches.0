Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045457;
	b=U1T+sj83IjRy+5ruL9GoT1rJ0pRU/dN8ITCH9C0joMRohB4Ny8BYxBzrVOCYnUjRKbGg
	 xy790BmYz7Ntt73IPXQyhYLG3ElwRWsK7mKQMQYhK1E2ji9DTHtw6TZ2hQQRpEOXJ4Ic9
	 oxbZkzq98BAWD4KDLxuk5ahGnKAiDtCuD5DUZBg8dYjVoB7/a8LIn1YsDC63uAL0KTbvc
	 XmnhwkHaRZTrkhUxjLnSdd47DKeVv1LdSZeFWDIrbiQPRuAasdmQzg1iUJQqDaibeIrgc
	 w8Ehz5J/zH+ce9FKBoBMSdotQuPHSUocdeyizgBq5RC4TNWYJNaTgQDY8BYPGei0AwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yJE4PawrBkq2pjQO0y/DZ5OhapwwJ5G54yhdy35r78=;
	b=UP0MZxaIzlLK4P1a3U7LEBdB9Yil2PX5N1bFGZlx3a12OkFu7mUX+6ZHHTVJ0g0KUj4M
	 cgNw5Dgf3hCAaxomCFRaYV6J7zT8LTIkRRnQJ3XEf0qWEQtTm+NLU2yOHUUj5sduwjc6N
	 5C8/lpInVh8jlITvgHeTMlkRYkqlSjCi0sy0eeKZaTyxW8TRR+fVitd9s1P4hjaakYuEQ
	 eMhU1JWYA9U7SN81s6p5GfyFOFLey3NJa4oRBAoSEZrdwQ0GCzi5PtwzGojz1Tzm4Tys8
	 EER3512bK5W/itePYJW54w7QysdNEtSzGXHSZOoVcXRTc5VVDWqxr76RkaSemCj8Fkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/xu0o+v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D47606A320;
	Wed, 18 Nov 2026 23:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/xu0o+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416501F000C4;
	Wed, 18 Nov 2026 23:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045456;
	bh=6yJE4PawrBkq2pjQO0y/DZ5OhapwwJ5G54yhdy35r78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/xu0o+vYM/QsCcjcMu20xvTHZOO25LCm/jH/VkP+0sPLKigTu2LWOeHwheRsOWNT
	 7KoRK7M3hoyTdhusObKFBSb4nskZfCqjGF/TAZAcDvvxgUCnHt4L/FHdd1jwvpyEEl
	 jNgmjtBvJiLnVvWhp4OeZwwfdc9ZIjO98XY+a/Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0893/2857] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Wed, 18 Nov 2026 15:32:07 +0100
Message-ID: <20261118150233.709475063@linuxfoundation.org>
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

From: Eason Lai <eason.lai@mediatek.com>

[ Upstream commit f5dd4833463ed45794027e33928539b3c532f82d ]

Using __skb_pad() instead of skb_pad() in mt76_skb_adjust_pad()
to prevent double-free, as the caller handles cleanup.

Free the MCU message skb in __mt76x02u_mcu_send_msg() as well, which
relied on skb_pad() to release it.

Fixes: 808f2767d421 ("wifi: mt76: mt792x: Fix memory leak in SDIO TX path")
Cc: stable@vger.kernel.org
Closes: https://github.com/morrownr/mt76/issues/83
Co-developed-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
Link: https://patch.msgid.link/20260914021920.32246-2-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/tx.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 02da543dfc5cf..b7162c2499c82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -90,7 +90,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	       MT_MCU_MSG_TYPE_CMD;
 	ret = mt76x02u_skb_dma_info(skb, CPU_TX_PORT, info);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500,
 			     MT_EP_OUT_INBAND_CMD);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 49886cdfa31bc..5a06392479a55 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -694,7 +694,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



