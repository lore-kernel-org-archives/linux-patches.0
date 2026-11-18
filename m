Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031321;
	b=2k0yzHKGjmz9orp5iWsckWE64fc0JmPI20pPHQHQK13Zd95WJvSuKsfMCyohwL4gVP9a
	 H6hFC0ahvJeXY2fhFu8kuOzYSKNGzDrB9i16FT/Zz/DCFDnMSPwHPHV1mAMbWhB36/28E
	 OhsjI/PhLuEUtMjTfDw8Hp4wP+OXt0VCEQK5xEhEmXqOg8r/UcFXJRXPnjVXfmt2i7RYc
	 gawrINqCwoOp3XuJBA3FjgEwQNU3Tg/c5yF8KRHsMBycx/6QOTNGS6luCKyzU6E4//t+T
	 Ztmzyf4+C8NNpNLxW36EMVdAcJsNr9FBVPNRVLrVqzJJaS4J+duz0po4aR89lakeFjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1A9lLRfiD2wYT4mrFMg6F/QlMiae2HurPoi5eJjiCkU=;
	b=H9QwkylpQCo48wMLiGP7RDNwzV0bPVswmFQT6EeJzg8rVbAsj2nqC4rpoASkWcZaUgUf
	 bCwG0mekk7i+vKmEdFCdC/1DI5leQmhYnhiEZA/S0LlkGZmur4KJGfEYknX0FAPP5rSO5
	 H7KhsRDbAxu/81Ay0I9citKrWGGWRlXnkqkO1a0evdIxUnons7MaNb3XFyywLcW+dy70h
	 k0BA6WrNhotDHsCdlLU2p8mx+SJE6bRb05PJaIf3tWg+/aSHV1WbU1UfrEs6vR2GnM930
	 muKm95VV1U9QgD+URzQD5FjUHZHkSuLuU0kxtmj5M8apNhGNpDyKp1noTjeI8g/5HxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/Bmi49E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3638606A325;
	Wed, 18 Nov 2026 19:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/Bmi49E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565001F000C5;
	Wed, 18 Nov 2026 19:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031320;
	bh=1A9lLRfiD2wYT4mrFMg6F/QlMiae2HurPoi5eJjiCkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/Bmi49ELX9IEv1XUSwCvLRU1SpmLGGvQ+k7BlGt3krXA1ZQiQNzSdt+wHHySzhk/
	 MZz9vojE7mGOAxGYkApVu5UjrxopyFetWwHtmMeDgfzyDsD0on7KQx0AH5XFVTbVbb
	 Qtl68ChaWTwxRAOtku/B+htNhZf1HZ5banVZESU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0975/1756] wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150048.956198933@linuxfoundation.org>
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

From: John Crispin <john@phrozen.org>

[ Upstream commit 7a5a3843178c61d99d939b231318692d08fff79b ]

mt7996_unregister_device() leaves the RX NAPIs enabled, so
mt76_dma_cleanup() deletes enabled NAPIs and destroys page pools that
are still bound to them. On rmmod, the kernel warns in
__netif_napi_del_locked() for every RX queue and in
page_pool_disable_direct_recycling(). Until the IRQ tasklet is disabled,
an interrupt can still schedule a NAPI that was already deleted.

Disable every RX NAPI that was added before the MCU exit and the DMA
cleanup. This includes the host RRO queues: mt76_dma_init() skips them,
but mt7996_dma_rro_start() adds their NAPIs later when WED is not
active, so a check for mt76_queue_is_wed_rro() would miss them.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: John Crispin <john@phrozen.org>
Link: https://patch.msgid.link/20261006205936.669125-27-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 6da42d9411656..80b1df96c9ee4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1403,6 +1403,8 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	int i;
+
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	cancel_work_sync(&dev->reset_work);
@@ -1413,6 +1415,10 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 	mt7996_coredump_unregister(dev);
 	mt76_unregister_device(&dev->mt76);
 	mt7996_wed_rro_free(dev);
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++) {
+		if (dev->mt76.napi[i].dev)
+			napi_disable(&dev->mt76.napi[i]);
+	}
 	mt7996_mcu_exit(dev);
 	mt7996_tx_token_put(dev);
 	mt7996_dma_cleanup(dev);
-- 
2.53.0



