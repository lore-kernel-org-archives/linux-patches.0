Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D84D90AA;
	Tue, 21 Jul 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649452; cv=none; b=Jpe+1mAwpe001X/GPMmNkMGSg/BmAW6H/8HEn8Nblg5bH6y4iiq+6q2JwFPXyWGXt7y0HMEoePpE6ftsjCy1WYdmsEKXtRGmN98UY8IQsyjoitd9e1SATXr+p4kqc44C2fW3QZQPGIrD+29tcgdcm0FcXgEtJ4UCkGqz8W0mCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649452; c=relaxed/simple;
	bh=r7JYPnsvb6jqaapxaz3riMvI4MYiIwaV+U/wJmGX0yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDp7BR/3osnWP590iSQdf26eZoKzbBKCXr6EX3cexCN/fy1mhqMHTCyVNelm5IXSVOhSij7e8uQPSR6upr/YwvMYvHBZP/wJkDI+JwfWiFRNGU7UqCjgS6/INqDh4bjnNk2S42PGrtiOVh7ZKp4088ZsASuDDyWJcQVfe6nvxZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVNjbzGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVNjbzGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377831F000E9;
	Tue, 21 Jul 2026 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649450;
	bh=SfkIWp//xOqPzuiIvlPN0EJHOY1FE2Sj1zCnXnP7erg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVNjbzGCPY8nUeOwYl57/u205/7FUG0yk8nz6Cs8DUtvrTx1K8NouGAG2f8RE5y39
	 3NiOM2DBnn7jIdrx9UuwI3vdlfRsDXbHYRbUcG0sf+x/CoBs/ZJJZaAIeHLUy6WhOp
	 Jy3YpKSSTTEY4Zfj52whBOcUEJL3UUef0kDpH2D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0582/2077] wifi: mt76: mt7996: Fix NULL pointer dereference in mt7996_init_tx_queues()
Date: Tue, 21 Jul 2026 17:04:15 +0200
Message-ID: <20260721152606.537798439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6794edb55b5f5ef834e03b0b241b1a8b725f82c0 ]

When MT76_NPU and CONFIG_NET_MEDIATEK_SOC_WED are enabled and
mt76 detects properly the Airoha NPU SoC, mt7996_init_tx_queues() will
dereference a NULL WED pointer.
Fix the issue by always passing the WED pointer from mt7996_dma_init().

Fixes: cd7951f242a7 ("wifi: mt76: mt7996: Integrate MT7990 dma configuration for NPU")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260418-mt7996-dma-init-npu-fix-v1-1-6b8dcffbcb57@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
index 8f5d297dafce23..3d9353811a02eb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
@@ -683,7 +683,7 @@ int mt7996_dma_init(struct mt7996_dev *dev)
 		ret = mt7996_init_tx_queues(&dev->phy, MT_TXQ_ID(0),
 					    MT7996_NPU_TX_RING_SIZE,
 					    MT_TXQ_RING_BASE(0) + hif1_ofs,
-					    NULL);
+					    wed);
 	else
 		ret = mt7996_init_tx_queues(&dev->phy,
 					    MT_TXQ_ID(dev->mphy.band_idx),
-- 
2.53.0



