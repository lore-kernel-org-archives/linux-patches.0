Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031312;
	b=cZlsuUxOab2MQbiFNTyiEwzEuQ0G9dVJPwnI3u0iaepjHYI3YSDScCU5CEkvodlr7NPR
	 XgkZGXy59bsRXIojWoPqPfZnWcqMIhNGmUhUDjxG9sgSNnKT+DPPaWikKJtJ1XcD4hHTX
	 +OmtaofZm8nCLLS0VBbv0kjveYjFkZThGc8gc4OHTURpMbSaEaimtdzTG12RKwF2rwgbv
	 knILKU6G2ndWpUj2rgLy8KsmleS4LkaogFfTxv4+B1wuA6yyJXTWg1Q2LFGGL0O8JJxdX
	 nFPf9Z+f2+7dYMp7DfbpmNr8VJxb+xKkKDpfnQg9q9x4B+kqqPXjvkbcojTlPDOIr2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VlUm3aon6VNv1X22l6D+iw1AEEAtE+BzsKDPBkPbg94=;
	b=4F1nrvJeELWueJQ+KGrqaD68TIc2uB/x1P9LTtVet9+MHuFgfHoq2K0jmR6V1xxAKcBC
	 eLha/GuNm/lvDGe40x4c0daMiyLEiZTK2aFJ7GNx/RbO77MvdYIfVlm4qGYpBZ/+1s2ju
	 VvLmgP9+DyxCPYivi2UNhPjFBrxOE+dcwwLbcO6IMYFPVnNGar3ctGWXoxjwrqy7FIA/O
	 fIOzlqbQxbzkzC2fUWEY138k+21OHeySOw6tb9TfunpbKi9GVEQ59TQUYxyHkHz7CmoVA
	 vw+4hHIHaP8LrqWOAboiKM7K4GVtb26+T99GNkVUGx67U1qhaNBQ+fwQtE4zulFAYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1Hg67lr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB18606A31C;
	Wed, 18 Nov 2026 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1Hg67lr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BC91F000C5;
	Wed, 18 Nov 2026 19:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031312;
	bh=VlUm3aon6VNv1X22l6D+iw1AEEAtE+BzsKDPBkPbg94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1Hg67lruxd2nIUix4w+uwaPdrkRqfBRFQg5JuZNF2AilD8z1g5ucXljflZlyoC3n
	 iELtXA6zmLW0EeM3aA2PnrEoPhWruvx5LHkh4+UGDTbMmYXo89g7beCDMbYy5FL2ZS
	 yaJUwn6Us9mHglJyBU9je7dv5VrzP8zKN6ansu4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0972/1756] wifi: mt76: mt7615: validate MCU response lengths
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150048.845447637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 1121c6a243750..ead3370254e4e 100644
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



