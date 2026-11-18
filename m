Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019049;
	b=ULiqGUGZm+X7fstyX9C4fELnA/K2sLqOxTerTPZ7tDuC/K44wRy1+R2mjemLXGhQXRmy
	 KoG8yAzPUm4nwJ2X3hZ2n5KXqHwyFH9/gqtWV9Cnu/0Y430y3vgFvVzneu7yhiLj+dqzZ
	 Cr8LLImENLVKhs0Wie9hFFBkLLR/0Skui8xe4df9kSPX87ayxx0ilXB4bpVl1VyqKi7Vn
	 m2taOTobkyYcncNVVqx8+LXNq72R0Oh2RNaqfDC6teSObWOcHFRvQP6Iou9+dQ9oF/cxH
	 MtyYH/Qy3B02p2FrX6TleFAIk0mU4nqMv7P69YEDnnmoVo7NlBFwAZklax+zXD5Q8dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJPgFmscZJi89qRybUw9c6EGK3L8ecDA3+F8ZcH59H0=;
	b=zkClTRP2eg8HvmDZ0smKT44d5zoghW6zmK4VMnM8ueYgHrPTGQhb6ta01+OyKXFuTUrt
	 V+S0OCm6bIuiw+CE3/nDMCRohpdRWdkzela7/UMhfSTNTBTqNnASKBTh+wkhnTRQJsHQS
	 Y9ocuYKdMjyzQXmD/pbYpWYu+RWxrIeuUfShsTYc0EaHf7a/aN+Lj/+VrVxCH7SsJya+c
	 Xd1JxIOYc/LRkpG6OZX5KEa5mLHSbFnZ4MWx7dAuNk52u5n+QUkSyeJXs+YBD5uImSlI/
	 +Ndb2L+yzLwgpSL/p58oN/+oKpzuMUqeMJRLykZ6Ar0mYsqyjwkL1gp3E24ztzc86Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVG5D4lw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D58A606A31C;
	Wed, 18 Nov 2026 16:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVG5D4lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A941F000C4;
	Wed, 18 Nov 2026 16:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019048;
	bh=QJPgFmscZJi89qRybUw9c6EGK3L8ecDA3+F8ZcH59H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVG5D4lw6kQfkhsY2CcOnrA433AHsmmqRkSeYxmwS6vlrWykW9cqNmThAonyI6a5F
	 9NNnef5VSWk/R3xCjM5674Xf3s7CAEJOFuV6ap90YIWaxy18BP8798dhKcqcFqM6rW
	 A3Axij85bSM550Y3MPaSU6+8IuqG8Kq9bVCl8o/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1457/2651] wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118150340.488931324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit e75897e6cb8b900d095acf6fbff1ffb026c86c35 ]

mt7996_mcu_ie_countdown() iterates over TLV entries in the countdown
event but only checks for a non-zero tlv->len.  A malformed event with
a TLV length smaller than the 4-byte TLV header advances the cursor by
less than a header size, causing misaligned reads on subsequent
iterations.  A TLV whose declared length exceeds the remaining buffer
is also not caught, so the cursor can overshoot the end.  The band
field of the event header is also read without checking that the event
is long enough to contain it.

This is the same class of bug fixed for mt7925 in
commit fc7801b7f11d ("wifi: mt76: mt7925: fix infinite loop in UNI
event TLV parsing").

Fix by checking that the event contains the header before reading the
band, and that each TLV is large enough to contain the countdown notify
payload and does not exceed the remaining buffer.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Assisted-by: Claude (Anthropic)
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB0001CCE8D1BEE1F330D9E57AC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6acb8897feb83..a534d07ea1e8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -488,6 +488,9 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	struct mt7996_mcu_countdown_notify *event;
 	struct mt7996_mcu_countdown_data cdata;
 
+	if (skb->len < sizeof(*rxd) + sizeof(*hdr))
+		return;
+
 	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
@@ -497,9 +500,14 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 
 	tail = skb->data + skb->len;
 	data += sizeof(*hdr);
-	while (data + sizeof(*tlv) < tail && le16_to_cpu(tlv->len)) {
-		event = (struct mt7996_mcu_countdown_notify *)tlv->data;
+	while (data + sizeof(*tlv) <= tail) {
+		u16 tag_len = le16_to_cpu(tlv->len);
 
+		if (tag_len < sizeof(*tlv) + sizeof(*event) ||
+		    data + tag_len > tail)
+			break;
+
+		event = (struct mt7996_mcu_countdown_notify *)tlv->data;
 		cdata.omac_idx = event->omac_idx;
 
 		switch (le16_to_cpu(tlv->tag)) {
@@ -517,7 +525,7 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 			break;
 		}
 
-		data += le16_to_cpu(tlv->len);
+		data += tag_len;
 		tlv = (struct tlv *)data;
 	}
 }
-- 
2.53.0



