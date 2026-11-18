Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034051;
	b=GeBjSVPQGxLwtT7Rw6H4NpQ/S1R4dk3Q3ix6Kr6RtwGKEJ6uBa86VasEQXn4NSlawJvS
	 jXIOqoi5Ve9sFztyqhxBSPnltXDChZJnSKSPsp+r0fLruIKYlINdDEqg7JpWl9erGCFLq
	 iQVOw8HOKTcYENP/338jyWefjYq6JYh7NWtoV4cqQGOUsiizAhlbOFTCFIuOI+g11bfTM
	 BVjDjxn67vNICtRkNAeS8h95jKbDZNxhU5jJSPBk/okAvwa86R9Z9B2Zum1P2JH3IypB6
	 Pitk/Qek24kY2BbuDg0BlktzzBqWQ/E6Srmj+Jtlz9FXgfiVWSMLdsNyOboLjqzi5sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kbs2uw5zEhV9LTM/HINEfBXyTpl8xsDT39DbI20F1JU=;
	b=R8OHW4IJN4wQaxmGU8F3cgEYpUsfxnF+GSOHc+NTUQdqU7G/miULoxKi5y8c1R0MsYn6
	 /OQx5vu8cvNNxAPWbC9psjyHwqCEYvD4tF8mYO89YIBp4fOQis5lLYxvSBGf2RlRsDWVJ
	 sr1KvoFN7czJR8pYchmfKsdiUaOj0psnKFzQXOQrypUzGZk7x2Foov8oorYla9jT/oBU0
	 QjoN8QnBIripT+zxTATo2n8hMgkaa6LTZOW8nigdezEaY9lr3U5GCc1aXygDf4Tvfdk4L
	 LWvIeR9tYPz6u+olGvkOuF/uBeoDY2D98iAKwsDC4C+wHpw/rM+f224Ofg01kE7Bscw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/4oTW6D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FF9606A32A;
	Wed, 18 Nov 2026 20:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/4oTW6D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED321F000C4;
	Wed, 18 Nov 2026 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034051;
	bh=Kbs2uw5zEhV9LTM/HINEfBXyTpl8xsDT39DbI20F1JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/4oTW6DRvALc23VzeEco6AoNyKIJ5A6+qVjMX5r0YYTEGJRfQmKU3qwyWCMunCwp
	 TR6+nWBZSiuo55LEqKcowjVLyHkh0h5vQXXKK8W7zE+AIsmT4F7y6coyK/2W17kPsh
	 boR12q77wx8AAVBmgGF4DSVDTJRKRuyPX0Oqyiu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Rahul <prashantrahul23@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0205/3318] wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event
Date: Wed, 18 Nov 2026 15:13:47 +0100
Message-ID: <20261118150321.043885634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 141c06a706bf2..f4e3c99bf729b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -309,8 +309,10 @@ void mt7921_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
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



