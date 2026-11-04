Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829717;
	b=dgOqfRBvQPokZW6B5y6y9+ILTfksp7hBw0Jw80l3iqhhtmmoePFoq9TGc00MGFnHaeFy
	 pwC4Kkqd7FVXnKHilDw69xSIKD+xmeraFdWXEEmdGk4LGAzaPKqzITuCx/Q6T9Xt+lpsk
	 p2HFoXJJck0PBD8MB4P8EJoAC/m3FHE7rrjGFmaMTnlwPcXoZQ5nZK4okLnUIZ2P6UxKQ
	 Q/yQP5dim2MlGwmYM6XSZZIU3+0+O1H4ps11jBihQNTGZE+HtBpsdWwa6rnCZSNfDITH6
	 fKIU1/AjP/FE6j4qtXoabNjB2+hfw93ZEa38E9HfxbZitQAhMg2xD++vyIgqU/5VX8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gIY2WMjzHCdnwT4uAnrau6GBIdGKF0kwIUGuc3qMS0Q=;
	b=rJvwRUeSrBsgJAFdMfvDNWupQGv9EYo0GGiCRbLK6beRbFEMj5nA8Ph6/l9pC8gXmQMi
	 w8yamF3CvAsRbQCsow8WU0PFVIJQp8GokBPMxTJitJ2NIa2YYOL2MOtIKiKH+n4M79tNA
	 HFRAcl9FwQ2GoR9RA9YfjU8IDVgZvyP8zS+FfnzylftEhGLVaGRJlOZMywRvsRtThkoLU
	 7t5qLHM6NmccYi/ues5j5qzSGRz4TihB39IdWzci7qIPgYlCwP3tfsJaDOtOb8Epm8yD7
	 wCVlbvCbPqS8nXa76cHsSt8UsWH43k2PDcOZxZZRFmXcEObgoYQQtGVBQ8qCaw+KFFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrpzv1SS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92229606AB3A;
	Wed,  4 Nov 2026 22:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrpzv1SS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E73F1F00919;
	Wed,  4 Nov 2026 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829717;
	bh=gIY2WMjzHCdnwT4uAnrau6GBIdGKF0kwIUGuc3qMS0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrpzv1SSaNdAjdvFOgMjdTKXCBvVH9WSeYyP/zD7R2H7AkWKoJQ1bgEXxZJWyz0lY
	 UGfxTDmJHzGdaJgqy8HcTLelwwD10O9YM+VbrzB9o7hBr4UurfygdQ5vAIrfXjjava
	 oD2iGxh9UeV0GWXu/bLptRSRTwlVszUJqxJCwhAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Rahul <prashantrahul23@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0298/1005] wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event
Date: Wed,  4 Nov 2026 16:00:31 -0500
Message-ID: <20261104211052.257784797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Prashant Rahul <prashantrahul23@gmail.com>

[ Upstream commit 4361f1660101270611eb5dc39799f620b35f2e4d ]

The ownership of sk_buff skb is passed to mt7921_queue_rx_skb, each
path inside it under the switch case handles cleaning of skb and it
is true for mt7921_mcu_rx_event as well.

mt7921_mcu_rx_event, on a success path, either queues skb via
mt76_mcu_rx_event or cleans it immediately inside
mt7921_mcu_uni_rx_unsolicited_event.

However inside mt7921_mcu_rx_event, if skb_linearize fails, the function
returns immediately and never bothers cleaning skb which leaks skb.

Since skb is fully owned at this point, it is safe to call
dev_kfree_skb which fixes the leak.

Granted, the skb_linearize failure is rare as it can only fail under
heavy memory usage, but at the same time, leaking memory under heavy
memory usage can worsen the OOM condition.

Signed-off-by: Prashant Rahul <prashantrahul23@gmail.com>
Link: https://patch.msgid.link/20260716-mt7921-mem-leak-v1-1-6e9c0ea19f63@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 8c8b35cba856c..f63ef02542387 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -354,8 +354,10 @@ void mt7921_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_connac2_mcu_rxd *rxd;
 
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		dev_kfree_skb(skb);
 		return;
+	}
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 
-- 
2.53.0



