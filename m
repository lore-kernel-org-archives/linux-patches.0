Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9636F421;
	Wed, 20 May 2026 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297607; cv=none; b=bpCkk4jb08iyQ56PCZt393kjEzkjCTFDh7urRt4iojb75mzStvs4beDXWPUxDr+2epR4N21xQy7eALRkZPP8XjtRAbn5zFpAFADRonod6J30RmW7wWKFsYEM5jyjaEft3ZcQjo+FJ8ftgvAEe6lM0yc54ah7GTAkPrxW5LRgajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297607; c=relaxed/simple;
	bh=Fh9YSNBNhFEPmPtN2f1W4jd9YOxU6NcifXKSx5Xfi0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzJoVpm+TetkUCPo+0Pif4YKJGtDet/GW0vd+gcz6opMkBz156MIAAwMpK53kcyQuNKtKgNePZ5IAJFDTysp6dKxXzj9L9/7d8L2cvPL8W+fcm28BjsHGGR9qJy9draqYMczSf0RUqOl+xsf9znxiVS2hd/wLQDcLa9OPANeHcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mnv7yBM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mnv7yBM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB91F00893;
	Wed, 20 May 2026 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297606;
	bh=c3BV0Jr5p6U4CcIqGjprnNbc3+iUDYLdtmhtx+fTxn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mnv7yBM/WCq8skejf58V8ByALQtTtRYhR0a02R27f9Kddh11A6Iu9wGZB3qCuILLA
	 KKtPks7BwW2FOAH3bsoYNVHCbReZnaiQvD55WAMzjmg5gWMLXCLKhGhzVkUWQ78YtH
	 GdfsR3TfWEreomdjNX4cegV2LyuYdQgyFWMGK5/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/957] wifi: mt76: mt7996: fix struct mt7996_mcu_uni_event
Date: Wed, 20 May 2026 18:09:39 +0200
Message-ID: <20260520162136.641570269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit efbd5bf395f4e6b45a87f3835d4c2e28170c77c5 ]

The cid field is defined as a two-byte value in the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260203155532.1098290-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 321098496a39e..c2d15128784bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -233,7 +233,7 @@ mt7996_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		event = (struct mt7996_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 		/* skip invalid event */
-		if (mcu_cmd != event->cid)
+		if (mcu_cmd != le16_to_cpu(event->cid))
 			ret = -EAGAIN;
 	} else {
 		skb_pull(skb, sizeof(struct mt7996_mcu_rxd));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index abfd7e5a775b3..7b51d7346bcaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -25,8 +25,8 @@ struct mt7996_mcu_rxd {
 };
 
 struct mt7996_mcu_uni_event {
-	u8 cid;
-	u8 __rsv[3];
+	__le16 cid;
+	u8 __rsv[2];
 	__le32 status; /* 0: success, others: fail */
 } __packed;
 
-- 
2.53.0



