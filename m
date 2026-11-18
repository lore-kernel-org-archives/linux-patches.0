Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052508;
	b=2J1OQl3m4vOFGFf4ySSxpBUlcJTZyhKfIHlfDwPL5ZGki+FFtd+xDuu1Od+CZB3Z6+7Q
	 6Gu8pFJOZgNnkfffiAm0WopKr21q3WmflTjVdh6KBUDklemUxda2rY7S+NBgsM9DxG5Sb
	 SEOfIQW5OXypO+abkANpq1nsd3P8wq3SKaUBbmT/cSurildBBitRy1EAitr4MrD5ClxOk
	 xraEiI5fzJgWN6LRO57sPOl9aNAvFTemfHvuRvnEaybCGSaTtb9ElaK4PkyFy4eHFAaDU
	 sdrITcjTUaW0hgOswzKR8BYYVkyS5bpUxpr/jBFdjmoSdXqG1ZztcSI4QV2+miI1xjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RtxA/up1EQUte4le/T50lrfZ1KwHyxwIzlDiid5bTrk=;
	b=nBxXiTiPWz48zge8Wp3hHs2vDxts4bZsArdTZsJ9BMj9LPV2fTkErxYRxIWLYG8F1YrG
	 bC5p7uOMz4NXyj1KX7o58GGU9vJ3N7HjnScPhubpnhnsUOqmNVb9zfcnSucdJrK7o22n0
	 ZhHjl7XM13XyokBgLMUpnNMip0tWUW83Q71+P0WtXye/2Eg3eal7qJcpGehMTtcbB0bFT
	 RcU697Rj6c87uWMJMgzUUutGylhyvkF8V+L29G13WV81oP5DF9SNuezJIxdSDvhJIhlbT
	 E5YMj8kGbzRonh18bbkspHEuIPEKWypAdtB4LQA0P4+5t9BuRFzmRZk2zV2kJaH4c7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vP40SAXU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25489606A31C;
	Thu, 19 Nov 2026 01:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vP40SAXU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785111F000C5;
	Thu, 19 Nov 2026 01:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052508;
	bh=RtxA/up1EQUte4le/T50lrfZ1KwHyxwIzlDiid5bTrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vP40SAXUWHicRvfqHXCP8i4Go0c52dDDfAccq2UKzGMTqm/ofpwBG5YFTpdqZ6jsJ
	 AIetmF72y9kQS60eNdCLPTy12sOvoiBSIE3WtKi3nU2dG7s/+twbcPKy3JZZbdPseJ
	 dQgptxQNgKCdkUAmx+qjwk0jIyI2MO/BrbV3OIAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0590/2214] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Wed, 18 Nov 2026 15:37:46 +0100
Message-ID: <20261118150034.501064638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6c16fe8ee859..561be2f4f3478 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -103,7 +103,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	       MT_MCU_MSG_TYPE_CMD;
 	ret = mt76x02u_skb_dma_info(skb, CPU_TX_PORT, info);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500,
 			     MT_EP_OUT_INBAND_CMD);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index c9697dca579c9..e1fa866582b49 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -655,7 +655,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



