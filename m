Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064505;
	b=BD1HaogCDMMrLTd8YBpz2hAQaxHNcwdXKxc47FUaW+Hh8X2wA1jou7kWNF6vY5GdHlsl
	 3YqBojxjjc7Tmq7YCFfwoXs/AH+orzPrI0il8zfVpPIKEqXi1EwTeqqjKk3G7sxZlVSqi
	 36dM8oWWmJD125Zrg8ZuwoPVbqtVNcIPZTBRoBaPu2KkPamxR1XLzuhFK6065Y5Dq8utI
	 Kn7yMy6Nx1arjkfFU9CNxeg93u3qPJ4czHs8XysqFXrNctyYyP9z9T6ZlL3jbSi8pEhwR
	 zJHx6PJQAsEEv5kCI6lLjtJSF/jRYalWKNlKlmniiKfMlQmjaVkLLdqYUFYQf5FWmxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOpYxkj9xMcqL219eIC6VOta3DZvPBoXxvNljvHZcqI=;
	b=mJaj+NYgLE39jz8/pkigd1Wf2nJvZKwZCDRlXxUXJuA/ceoZqdgnP7BNsx78+f/mz6Wa
	 b+VkFptSp8+7b5KpgmYdKXDmm4/I6TtmMhQEB30+JqH2TI91Fg6Z2G/aMTtf8xybhSIBJ
	 xaRoCXkXIBRumW9QsdgIBScygjN/rSYzlB9xywTBCr7xeTnIMJR1qYiH5Ar6cmfq4ToF0
	 LtCqn9n7eKXbO9MX+mmLjZMYb5FpT+kV9kIxq8UDtZIHM5bY4c2f2jvFTCw6mQ/PrMbYG
	 ZGlstUWdJ6S5GZryAEa13wLXoie6ezqytXb98HIzr+fArRk3IgbTTzhuhBrSf8H+Fsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC9Q2yu9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311F606CE50;
	Sat,  7 Nov 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DC9Q2yu9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E684B1F008A2;
	Sat,  7 Nov 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064505;
	bh=mOpYxkj9xMcqL219eIC6VOta3DZvPBoXxvNljvHZcqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC9Q2yu9bPCbixuJ+7qmWOttABWEaDjCJkPsgTlpcMl2QNc1DjJlplPhROrmn2fpZ
	 9X3kXfE2ROu9I7floyL89EtjFk8LvCDU1uBi8J4Q7f3dpkhOaWKaDjkPR64O+Dokf5
	 d/9X1+kqWE4b7xi/JA0LHrlSCZFZrkA6ixkrxnD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0537/1257] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Sat,  7 Nov 2026 08:47:13 -0500
Message-ID: <20261107134954.237850700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 968c73e06a5f9..6f931d483bd6d 100644
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
index 3c623df2e741a..156d283243d3c 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -885,7 +885,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.53.0



