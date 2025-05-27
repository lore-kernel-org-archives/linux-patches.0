Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D76182D7;
	Tue, 27 May 2025 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366580; cv=none; b=txKTsd2ADFR4Gf+tCpGgVUmIJq52/9XWYO8C+4uY2tuH0wE5pRXlZ3WeX3uUloTjfQIq6XCYqiZy3mf9uZ913KbPoJNFw3UWynoXMU74wS/f6Gnur9vuppWJW5Z64gnQYQTypkcivAjfFuaL+U6lP0WbFMUZB6oQHIAWko5+AoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366580; c=relaxed/simple;
	bh=m5Zv7KjFLbBWUpt3v+U3nYVax6mOAXfUlkf4dp8RnKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i92KjJUDjVaESCgK/ke/9JGzjSllzdet7CQuiYaAftVpIQ47o1n+YetP/wAvMdeT/2Q64FAvdOKCEQdu38AvzhNUyw5M4FykYmBGdjAxZDXducVRWZzi2E9yYNyQAJLXe1VyXpY4znQs+3D8Eqhuyio1SlOGCXmUxvjCNG6SbPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FlTN01X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FlTN01X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C774C4CEE9;
	Tue, 27 May 2025 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366580;
	bh=m5Zv7KjFLbBWUpt3v+U3nYVax6mOAXfUlkf4dp8RnKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FlTN01XBgnc4tmKv9Lz47/MKopdBlcXqpjPBsV++5EoXxgU/+/2waVUGhmHDNwZb
	 watrzvicOuJLJHehdwVl718xYTuk7kACv0MpRWMtYpVEa5AL9r8J4ZndgK1oD4vWZx
	 pi4T/tn8N1dfjzImh1A9oCTtaSKDHI011/O72DP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 113/783] wifi: mt76: Check link_conf pointer in mt76_connac_mcu_sta_basic_tlv()
Date: Tue, 27 May 2025 18:18:30 +0200
Message-ID: <20250527162517.751914687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 9890624c1b3948c1c7f1d0e19ef0bb7680b8c80d ]

This is a preliminary patch to introduce MLO support for MT7996 driver.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250311-mt7996-mlo-v2-10-31df6972519b@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index d0e49d68c5dbf..bafcf5a279e23 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -391,7 +391,7 @@ void mt76_connac_mcu_sta_basic_tlv(struct mt76_dev *dev, struct sk_buff *skb,
 		basic->conn_type = cpu_to_le32(CONNECTION_INFRA_BC);
 
 		if (vif->type == NL80211_IFTYPE_STATION &&
-		    !is_zero_ether_addr(link_conf->bssid)) {
+		    link_conf && !is_zero_ether_addr(link_conf->bssid)) {
 			memcpy(basic->peer_addr, link_conf->bssid, ETH_ALEN);
 			basic->aid = cpu_to_le16(vif->cfg.aid);
 		} else {
-- 
2.39.5



