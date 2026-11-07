Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060864;
	b=uqdlBi8HGYzKp1Llzy+6BnA6LNnpLVE+hu0JMNfHTB8ukKHuPrpQx2jfQyGvGg42w52Q
	 ty+12m1r54LPjtVQ3gAsHPuALGJSyg57CaVcG9tCo+xn9bKBSujq6RNVQjg2U4Kvjj546
	 0m5cWy+slIPcdXLD1Gozy+hAoAoNzjaapiPG+U11gIg/PJ+qxaOxp3WIC+CCQRGVLUH5K
	 g/lSkXTu4ej2MInsHmv08Co5Q8GhCF0fX/m/Gx1SRPSqQ85oY3Z9/AsqW4mNs+UNh0mzS
	 Voox/9TvvbAg06aGG58jG/Ftg5EzPNuvuWEiekjH3/+FMEoty23o5lhU4c0Ffhwiiwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QKx613dasEPvth/LkrRrgAX/SZPKUgMh3IRB808pXns=;
	b=aAhwm8TgDRu9sPJ1ddu4nLXw0JieVwkYptf2fR1OnLULmDF3nCki9aOWa/gF96iuIwdB
	 jR7HhpAL7Q8IQ7kyiaQXYY/I/XH3Qu44XJih2F1sv9TKBW3VmNbU+tR8om4rBVgood7kC
	 qf3pDcBK1wMFBn7JzInTiGF0wn0rfo8F/MnKSZae6UeC1pbe6twKDQdC28BZCE6nmqRgL
	 BUeYywgwpl/PHF6W3z40gxscXnlwXjKyPe2eTye+CXkiMmClxcCWzJ7f9eptQyF0c9Cyg
	 p++DPVQkdijLioGtJrqYMq6rYp4P8N31HmvhdhIosnyVRcl38IAT1ki57pwxJHtAilQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+Kqd4k+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78751606A338;
	Sat,  7 Nov 2026 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e+Kqd4k+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1148A1F0089F;
	Sat,  7 Nov 2026 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060864;
	bh=QKx613dasEPvth/LkrRrgAX/SZPKUgMh3IRB808pXns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+Kqd4k+akscBj5nEFKeioVoBCG9hUae3fAYSlTu90XhFr0EmfmaLUuxY2rkgjm2Y
	 og8uJaKVcK5+YP2W5bw0vr/fuusjYKVYEKGQ5hF3mkfvAQvKMIsNxR+R9GNpcRaSCp
	 yDde4I3EVe/Xyu0rNJJVjOPdYVGCTtYuSuyCyz9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Rahul <prashantrahul23@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0245/1536] wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event
Date: Sat,  7 Nov 2026 08:37:41 -0500
Message-ID: <20261107135004.562760261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6caf8fbd6a7f2..bc7a99b58ba48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -348,8 +348,10 @@ void mt7921_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
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



