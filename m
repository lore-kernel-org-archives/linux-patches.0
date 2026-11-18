Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041148;
	b=uNt4bkveWEGTiIAo2Zbl3MNJHprTMZqcEnXobM1o0cDsZ8IPl4WD9A4oIkOthEj5Z1dr
	 uLFiKE+mGuauNlifyZ6esCOwN46BiLMmyWy+GY6qEqFKd05Py43PjNC5ald441tO+OggW
	 FbetHdtwkzD0seMfs8j/CRMgjKnD5vBWqu+f8ub7Lw63M1zW3QMjpglyJcDt4IQdJeorK
	 KNQ9lFXIf6U736E5+/ifVGdnu4CmBY6NiJxc96BGptgWveNK1Ni4BOxLsHqMxJBNFM5Z2
	 W7HHDq309Ua2YVSwtwMn0ksbCUogbFBapwhicNz73NkU9euCQI9VQejHSCKamSu4z0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmfx+Iy67Ri5cON8kSSXwk9pqOCH0orLJkHY6DXCr5Y=;
	b=2VB79o9KxvW6XeRraM8nPdNQGVmtEJeOOkEapIPRDwzcOh4ry+GwwK6n+NfRZXrRObes
	 mhIu0WcPk/eor/zMG9+aFRqVMunizbghebZXo/fw58kI5ug76aOPPmqiAY28Io1/0l2xG
	 xPEsnnH5w9Uky6Hjn4711pTYk+4noiA5LRllGQuq6V6AGfQoo4R75fGK5pPvaKAlwFAFl
	 aVAJ+DSNLbl13TdOXbjX+kTwXCe1IzxXg9iqgzWJlUcwfM5HrbSBW4uzC6sdJhj8lEe0b
	 wWIU8R5dh7MDwyubS1AeAHv/tTrh6N25bqBNyZv/z+x3kQA1Jp1fjI0l75zZZTHU+5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brPRffp8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B2C606A320;
	Wed, 18 Nov 2026 22:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brPRffp8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B881F000C4;
	Wed, 18 Nov 2026 22:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041148;
	bh=qmfx+Iy67Ri5cON8kSSXwk9pqOCH0orLJkHY6DXCr5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brPRffp8+eibNiMn55vXIongNnzVa/af/zmH49g+qvtL75+toYp+ImZ/E9WDdNlId
	 ArkVerHprfT/6XHheub14aIl8CYqQni/XxFpXjQhoHZG80+pQTHF3huq4LzYIXgnIr
	 cadLaEaeEQ+4fCzgQNLyaP12f8d84fGDdj/zrsxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2673/3318] wifi: mt76: mt7615: validate MCU response lengths
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150441.193229465@linuxfoundation.org>
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
index 20f2854d134d1..81372cfaee9ab 100644
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



