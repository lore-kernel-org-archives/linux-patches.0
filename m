Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B344841A508;
	Sat, 12 Sep 2026 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209006; cv=none; b=Mjbyek3xUjPB8YVpBruXkfgfbyPob59GXxvQ/8a/wRnRJszblYgfDNKcr9B3rCMzgEjBp5Md43pyvE9GIGSr+N74PCRj4E3ReaVWhSActij6PtklXYveRoHYUfqop5M/gyQ89mp2R70v6uB/AiXAFj3i/ZFI0Pzigq7AhCRwJmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209006; c=relaxed/simple;
	bh=z8MasXcnmN33YqxfY/0PjmZInmQNVF8yCWd85dY3+Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtxEhImPDduLZm5qbfvxGcKJOKRXkUJnrpJ+wTaScgD/JbjB7qv3M03QdA+F4c0bVtrkOzMUdJ60qjh7YS8ueDGj9OSapXF6gPh+rfpfFj4iXbIpfQw7h7X/yxyG5qnDKsJhb1jWlHC3h+mwKjx9Z4YmtZ9suhAoGEP7FIbnsgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0tzGKk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0tzGKk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CAF1F000FF;
	Sat, 12 Sep 2026 10:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209005;
	bh=LfsUGPVIPmMNU+/2/t6fOdxwpagbMK0mhrUmHTp4m38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0tzGKk5sG/xLsVhsL6Eo9Ynk+H/KYy9Ul6+T4Vk6VuEFtapceS6Rs9t0ln59ivYY
	 uv+o8q8X4h2dMldRAeCifBhlllgkwnK70Yu7YnPI+bLM390yXFzleHZdpBtdacZeX4
	 FOHjYaf+WR50df0GTaKNHdztJxLfgCcknAIfwAQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0731/1518] wifi: mt76: always enable RRO queues for non-MT7992 chipset
Date: Sat, 12 Sep 2026 08:48:20 +0200
Message-ID: <20260912065639.971244708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f801fec3f0850ac00073bc322c0e4ea446d938ae ]

MT7990 NPU binary requires to initialize NPU desc_base after configuring
ring_size. This is a preliminary patch to enable NPU offload for MT7996
(Eagle) chipset.

Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260122-mt76-npu-eagle-offload-v2-3-2374614c0de6@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 915672c5ae32 ("wifi: mt76: mt7921: Add PCIe AER handler support to prevent system crash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index b36ceec45c4d7..66df27480f39a 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -6,6 +6,7 @@
 #include <linux/dma-mapping.h>
 #include "mt76.h"
 #include "dma.h"
+#include "mt76_connac.h"
 
 static struct mt76_txwi_cache *
 mt76_alloc_txwi(struct mt76_dev *dev)
@@ -188,16 +189,18 @@ mt76_dma_queue_magic_cnt_init(struct mt76_dev *dev, struct mt76_queue *q)
 static void
 mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	Q_WRITE(q, desc_base, q->desc_dma);
-	if ((q->flags & MT_QFLAG_WED_RRO_EN) && !mt76_npu_device_active(dev))
+	if ((q->flags & MT_QFLAG_WED_RRO_EN) &&
+	    (!is_mt7992(dev) || !mt76_npu_device_active(dev)))
 		Q_WRITE(q, ring_size, MT_DMA_RRO_EN | q->ndesc);
 	else
 		Q_WRITE(q, ring_size, q->ndesc);
 
 	if (mt76_queue_is_npu_tx(q)) {
-		writel(q->desc_dma, &q->regs->desc_base);
 		writel(q->ndesc, &q->regs->ring_size);
+		writel(q->desc_dma, &q->regs->desc_base);
 	}
+
+	Q_WRITE(q, desc_base, q->desc_dma);
 	q->head = Q_READ(q, dma_idx);
 	q->tail = q->head;
 }
-- 
2.53.0



