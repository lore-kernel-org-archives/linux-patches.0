Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B876B1D0438;
	Wed,  2 Oct 2024 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879381; cv=none; b=YYOpqoInlb/Jz38EzJFnkRhDTD5UUGg7bOoK2Vfh2BaGA4CIXW2eXhi+yGrpVx6a9nGi3oEqKZpYa70PdKbOzhT4wqciOtisA+xKjNwrKlbgbx3koHxu0eFhF5+buhDztmrr1waJcxF4e+ilReug7dgalJcAkgeUKrr0VyuJtk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879381; c=relaxed/simple;
	bh=XpIrk0rhbQim73QgHh9eh6tOORqa4Ri8N187UIR0QAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDf6IuNox6pe6WqgFuAZayQySCxY+AX1bmX0xA3fOg9dbFkk2n6PjUCot4TyZBuseIBdgexsdwFUyo3dljpaS4uUxb8mR5cARumrNfBAlhMkwXdygNLRJdrqSSJF50S4/kFLnVhfzkPHZUgcRXIXik0ro16lASdGGMB7S6IZ6fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqXGcn81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqXGcn81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6C4C4CEC2;
	Wed,  2 Oct 2024 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879381;
	bh=XpIrk0rhbQim73QgHh9eh6tOORqa4Ri8N187UIR0QAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqXGcn81iyMsienSoP08nuvnC77kD+AuSN9Wys4rDzTnkHseUEZixHpaBm7ei8r2h
	 LZHUolJK7jSb7eOc9rsYb1Og3FAlN+PcXwD/r+tl+eS6N0g2eIRomGeSJzqlP0BObw
	 pCtyGkfntaoZ6UjfJMDETydT2kacG7BKiSOvaUUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/538] wifi: mt76: mt7996: fix uninitialized TLV data
Date: Wed,  2 Oct 2024 14:54:57 +0200
Message-ID: <20241002125754.494886376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9e461f4a2329109571f4b10f9bcad28d07e6ebb3 ]

Use skb_put_zero instead of skb_put

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20240827093011.18621-23-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6d9a92cafe484..b50743f7e030b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -520,7 +520,7 @@ void mt7996_mcu_rx_event(struct mt7996_dev *dev, struct sk_buff *skb)
 static struct tlv *
 mt7996_mcu_add_uni_tlv(struct sk_buff *skb, u16 tag, u16 len)
 {
-	struct tlv *ptlv = skb_put(skb, len);
+	struct tlv *ptlv = skb_put_zero(skb, len);
 
 	ptlv->tag = cpu_to_le16(tag);
 	ptlv->len = cpu_to_le16(len);
-- 
2.43.0



