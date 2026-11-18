Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031294;
	b=eCZngF5MY2qaXaYIrae3BIzeYQK36PGc1YR4z+Zd87zj/dGa0NRfVSRaPVi1q0H8Holp
	 Rij+6DBBwVFrZZ5R8cyyRYLt46NjrSaYyatYlal1+7+85MD+L5Ov4xml+ID8gQ+HM6cWv
	 tiLgUA281dqSfVD0+91mD52c8Ce7HKcjktqNjuq/TDfKFI0rD/mSUyh2frZ4LOFAmns97
	 avm7MfLxI1wB7Y8HLl8g0OHMcj/q+SEaAubrimwEvB/KlQzwwZJDG7yYliUiMxzeBB3Su
	 kBx+5IDpfv/jw5LgalgAnzhar7fAxieFBu+xwWMw3mLPor60NRm9oKWdQkMAsBRZa8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3CYFicmw+McH+H+r+J/K6ct896XH6owaeuu5f6Nm5jU=;
	b=GM+Ek0cfIMcAAwftT2i7T8dV/H0SPMy4w1k6ChAltqCL2n4QXkCnPH7eIIDcilgGM50E
	 luibSKONhzOEnm8Nb5vqnZExFO64+lQ5p3CNL6Ab0lTGNjiWQlCfDXWao5JN7Q9Js9itA
	 vRxQpTju6CIwCGOhK8S6FUjd8SULbnTpqnsTWQfSk8CFOOeyWrO+aq/pNdBN0/586nngA
	 3zIyL+ERA8GSlNHZ5yTdYmXfhxtNLq7PGVnXAGAB9dSZQfbnZ9CAkNkslzJCPsWBhpKSn
	 pwKqk/d0ULLw/9JhaRpYZbIzbp0mV3PEtqyc2nFKcJaHfNwQ57B11bc0nGA4+f1g1KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1cjxJj/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C33A606A330;
	Wed, 18 Nov 2026 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cjxJj/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBAD1F000C4;
	Wed, 18 Nov 2026 19:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031293;
	bh=3CYFicmw+McH+H+r+J/K6ct896XH6owaeuu5f6Nm5jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cjxJj/Sqd3v7OalUARncSFzqDpMY6Qse2WlFxkjRtqY97X/7S83QMBlcqEYcrrn7
	 nZrB2JJrjZV1Xbg9KXKobe0I7O+TnpVsRoaA8DncslhvhpoVCFrZ5ryMZnd3gO3cMB
	 6/70UE4gXGWVIb6vtpHw/RMm2k9hbd7Bd26xHWzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0970/1756] wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150048.743054481@linuxfoundation.org>
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

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 158c1145fe7ddd82914011a00de7cc3262616b16 ]

mt76_wcid_cleanup() releases dev->status_lock before calling
idr_destroy(&wcid->pktid) to tear down the pktid idr. Meanwhile,
mt76_tx_status_skb_add() from tx.c can concurrently insert into
that same idr during tx completion handling:

	spin_lock_bh(&dev->status_lock);

	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
			MT_PACKET_ID_MASK, GFP_ATOMIC);

Since idr_destroy() runs outside the lock, it can execute concurrently
with idr_alloc() on the same idr, corrupting its internal data
structures. Because idr nodes are freed through the generic slab
allocator, this corruption can resurface later as an unrelated-looking
crash anywhere in the kernel that happens to reuse the same freed
memory.

Fix this by calling idr_destroy() before releasing dev->status_lock,
so that the table teardown and any concurrent insertion are mutually
exclusive.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: bd1e3e7b693c ("mt76: introduce packet_id idr")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260820-mt76-pktid-idr-race-v1-1-451f176a6495@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 289c1a2815560..77708de932f30 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1641,9 +1641,8 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
 
 	mt76_tx_status_lock(dev, &list);
 	mt76_tx_status_skb_get(dev, wcid, -1, &list);
-	mt76_tx_status_unlock(dev, &list);
-
 	idr_destroy(&wcid->pktid);
+	mt76_tx_status_unlock(dev, &list);
 
 	spin_lock_bh(&phy->tx_lock);
 
-- 
2.53.0



