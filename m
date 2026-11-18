Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019060;
	b=bbEbHaMGppmWWsrVD7BEsGN9F85UBWZCfXaL/ZOoR14eCmnp71KNeBGOqjhmyE61p1NN
	 XevKHLoEm2+VIdYu1AiNRKVRAhOvz/SMLwUbeUTlKC8yOA4SQe19KYs89qMRnUsZ3eKNk
	 2SoOWS/7womj/xm9M/Nm1Sl8ra7OBOvjir1jT8rReD0f534R0jrBInzekZkXZZa6yxu9S
	 toEc9lmRTSzYzWKcSSRFjHg5HvsRg8+i5034laQi8pFMydOu2mtZ9Rdr/HjjlU94bPU/0
	 yTyetyMT4UXtVkEO7OAgkqNI0J0n/sDM0aL2TUSDnGFI3KTvxZony5zAKfnQCZbp2AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A8+wDgMKMWpmbtMEqetHuwBjYE45CipqGYMXv9hBHas=;
	b=lhl3RxFsEMVHi8D1uqb3vx4KRM5zzlP9lBg/I1FSk40s4EKheo7PvO5o5DR/XhAUu2L/
	 FrWa1+v3qlE12WS8m0Uz065Ut5zaJiSVpkFj/CjfQ6Q3+PlaR2JC2z8pndTAkZSrwYRG1
	 H/0iC3RurE/EMOqSqKtANoHmM5dpzs2gjhL5t0lLgr312tMqLX6QdPXioW4yfXa9497jS
	 Y7vubw0tIJvuDM0PaqJZholUptsJR1MneuhMVZilgy5E4i2RDnONetcFQ0im3C37E6aS+
	 TcIjCv5PN5S2/hvp7fR+6bka0ZXD+0lOI6RLAW6TSDRa9I3cGoTnLlRIHgSk+yqopLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SCOlGX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4A7606A320;
	Wed, 18 Nov 2026 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SCOlGX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBDA1F000C8;
	Wed, 18 Nov 2026 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019060;
	bh=A8+wDgMKMWpmbtMEqetHuwBjYE45CipqGYMXv9hBHas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SCOlGX3xR0QNbwuTC7OpLuPqOVwg0aR9Obo6CJCuqq9nnF5mVOJW4hr0nexZJqMf
	 nCWjPjKIwbBzj1Syglwn0GXE6gA4LM2YQlIfZGOdfvi7wxcUzH+4JcoQYWc+EK9BH2
	 7uMRynan9kWboGoTksU01Kx7wY5lDEmMC8VzFGa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1461/2651] wifi: mt76: mt7615: validate MCU response lengths
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150340.631884022@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 356735fc612ea54062eb741ea15fa4ff7df4fc36 ]

mt7615_mcu_parse_response() reads the common response header before
checking its size and then consumes command-specific fields after unchecked
skb_pull() calls. A short firmware response can therefore be read beyond
its current extent.

Validate the common header and each command-specific payload before reading
it.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830131049.2097-1-pengpeng@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 1ce0192c2c91f..aab4303fef652 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -145,6 +145,9 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	}
 
 	rxd = (struct mt7615_mcu_rxd *)skb->data;
+	if (skb->len < sizeof(*rxd))
+		return -EMSGSIZE;
+
 	if (seq != rxd->seq)
 		return -EAGAIN;
 
@@ -152,11 +155,15 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + (is_mt7663(mdev) ? 8 : 4))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		if (is_mt7663(mdev))
 			skb_pull(skb, 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
+		if (skb->len < sizeof(*rxd) + 8 + sizeof(__le32))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)&skb->data[8]);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
@@ -167,12 +174,16 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(SUSPEND)) {
 		struct mt76_connac_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 	} else if (cmd == MCU_CE_QUERY(REG_READ)) {
 		struct mt76_connac_mcu_reg_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_reg_event *)skb->data;
 		ret = (int)le32_to_cpu(event->val);
-- 
2.53.0



