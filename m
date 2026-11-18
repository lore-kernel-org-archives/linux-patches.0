Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025832;
	b=ntP+rWwNrCaPQ39wxiqqVVMmxUTcA2Z6XYW2a/XwCNc6VYCFBvuiH6jtK5UM+f8On//9
	 gfCgejeG9+tXamn0QWOI5OEbOQdG9w6qA6bwKVTLpVj1CVLCaV/t7wsQOKDdzdw6OO/pE
	 sjBGn0m2QtdMqDqgpnYLe2oGSk1zXCbrXcMyM8EkQy+UBMwrrOaY/Now79LJRQI1IBiFK
	 0TEG5+BkwRBN2yklbGDQT1SBg899pJBvJO/LNHGw81XhZy5LcyS70jbn5FhroQ/cxYFMU
	 nXSrYAjZnyhV2KA41mbLJ066BsFqy6WXv+ZjwSAX2mEC6DUnkPp/RqLE2QeX6gz3jMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OVbIJ/H8yjkQIaVnJSBzuJcSRkveLzhtlOqGB3/tkQM=;
	b=Hftc/MBNtM37lWtdYg632SWKG3ihRUII/21vfBk3QY+cctW8rJazSeHhCGqcDjqGPzD9
	 m2dfwr6Jhb/+k/42V0aiAqVANSiTg+dZMeMDdksQ5ynuRwbRuumxcvkMuYU+MSm+78Na0
	 5V7vLeunI1eHPjvXhdxU1LtASaUch0N9Q0ed36JLS121IhwhDnvQppJ1Dqn8ZbGVFy/Te
	 GGDDSJni55diSLiuYLJracqhatWefj+8HeZ30IBc0/HkGMGQCAR0l7ntHdO5HzvaTSjsS
	 KTR4uJeyqK6PCZtZUR7BHyj1kpzAajK/gh4SGSOz60zMrq70gdJZfeZ9smoJrZVoc+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuTq0etj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CFE60A2603;
	Wed, 18 Nov 2026 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuTq0etj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE101F000C9;
	Wed, 18 Nov 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025832;
	bh=OVbIJ/H8yjkQIaVnJSBzuJcSRkveLzhtlOqGB3/tkQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuTq0etjmHBMr/V2ePz92eKQ1Lg8EYhCV+lUj8YWeUJxmdI7W8oRLBp/rw3HdMAE4
	 zWxIHeJ2/3bZT59BGnEVupOx2XCgOosXjt4WNBzLuqq9tks3PltrpMp7id5o8/4NaI
	 dr+uRFDx1pfzzY/pZT318EVQV1Dcd7G5lNdUyyvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1219/2151] wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118150206.605301117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 165535f7f49cf..3a7d19da7f7fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -466,6 +466,9 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	struct mt7996_mcu_countdown_notify *event;
 	struct mt7996_mcu_countdown_data cdata;
 
+	if (skb->len < sizeof(*rxd) + sizeof(*hdr))
+		return;
+
 	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
@@ -475,9 +478,14 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 
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
@@ -495,7 +503,7 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 			break;
 		}
 
-		data += le16_to_cpu(tlv->len);
+		data += tag_len;
 		tlv = (struct tlv *)data;
 	}
 }
-- 
2.53.0



