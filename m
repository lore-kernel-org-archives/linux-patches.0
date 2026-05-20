Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65043E832A;
	Wed, 20 May 2026 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300101; cv=none; b=LcKq0+uAKKW5OXBcurr/TtMffxpSmYD9HfMrxiKYrl2mTCZW1J03wkfr1pWilvzPLxcMtqfQz/1RUch3mk9wJUsfUvupt9chGQZUrB59kTkX++N7KOo4T6fF2LYWosB6rTJQAzjK3W/z7pjpiQyginM9CFooZeXFUZ36jaGtZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300101; c=relaxed/simple;
	bh=kBfP1hD8AwzK6hGXongp6RcgJb/iumEd6TrCPNg6Dg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgjyoBZ/zm/2XUSiGAF8JYn2MpWHX2JqnXRxUHBYGfsFpoV868YTIVCezD2H5uTZ0HBVyJTQECETB65o3huLs939jAZpaGXFNQw/VMGazXykicYfCDUafMmHSY8ud6NAmwuj6+kA982Q3nkzziVK7DJCg456rkinKsioXi6+kqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiF0ZTPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiF0ZTPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481011F000E9;
	Wed, 20 May 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300100;
	bh=MiGpaamwPPvHpdf1rYGBLcWrbKa3vPO1ONllvCnHXNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiF0ZTPu/yt9H0R+ffOI4rZXNLRcfOR4VjuUzAKL/Px9SI7p71z6g/JzFQeBVa4X/
	 9UpRdgiCV4zeNY0KAyJbBFmjyodckytJM3fY7im+a0H/3cG7BIx2mBAtf5PI8dAZPU
	 HQNTbattXfNM0PpTgTK5caZ/fKCTUWgzoEfZ4WWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/666] wifi: mt76: mt7996: fix FCS error flag check in RX descriptor
Date: Wed, 20 May 2026 18:14:19 +0200
Message-ID: <20260520162112.283583625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit d8db56142e531f060c938fa0b5175ed6c8cabb11 ]

The mt7996 driver currently checks the MT_RXD3_NORMAL_FCS_ERR bit in
rxd1 whereas other Connac3-based drivers(mt7925) correctly check this
bit in rxd3.

Since the MT_RXD3_NORMAL_FCS_ERR bit is defined in the fourth RX
descriptor word (rxd3), update mt7996 to use the proper descriptor
field. This change aligns mt7996 with mt7925 and the rest of the
Connac3 family.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20251013090826.753992-1-alok.a.tiwari@oracle.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b7a5426c933d0..6f8167bb86136 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -501,7 +501,7 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	    !(csum_status & (BIT(0) | BIT(2) | BIT(3))))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	if (rxd1 & MT_RXD3_NORMAL_FCS_ERR)
+	if (rxd3 & MT_RXD3_NORMAL_FCS_ERR)
 		status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
 	if (rxd1 & MT_RXD1_NORMAL_TKIP_MIC_ERR)
-- 
2.53.0



