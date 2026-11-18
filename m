Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025863;
	b=dMJXjin+euDfPzTEFP/yRnGS3O0SKDc6VYQ7pckSLdCbcHtzMN6ud3ULlyRZPpwT1WO5
	 1L/qk/My/83MQ4TY8CGRPpaI1e4KT/FlNrVhL/FJdiItv8wNMrXwefBn4mFjvvITUrXhk
	 JBwtoG9Nnnp/vDWVp9qdgVTaCjRrhH5uRwYGhSH+voQXAb7bNxwz+88xcvMMjjiIHJxP4
	 9PMN5WeuWH10Q3BnL6TYwtseUJt8HJEMd4LyWT7ixRjUsi5iGVXzyTmNi6DpOi8kObt6H
	 kS2V12bqQ7Q/PGADKVXFziC5RRo/z1oG/Dv2B0jmYipqckjDVQ4pd4s5PooEuEJR+fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iopnfnlxUdLAtqb3yuFybixL5EDPKVafvroXM2Gq6dM=;
	b=aA9L4vhE5x3o1UaGZ0exEgtLl1+J1qrVu4/uzKt5Xf51w8mlYAFYxgLwrtj9b+3ydECs
	 OAsf74MxIHYgbACEMUYYm5350EuDh6tN9wVMlEqoAJVOU3ZCFh8W05mS+1LKcpvNHP6xq
	 entXvtTxVRI5J2C3VR2l2AvRGzC0q+6sfN3qJ8XwwQ0EQKrFErrRZsxXQ3GYkXiBLkXwQ
	 d21L8549ReulbpMl2Gwy+7bsxfwtdh3NsUM6Rw88TkkXfzVIRv3b/GUrDbOLDHTJBjMtg
	 PXGSzIba2uXag/JhBE5ZoKDQnWbHLMnkcjCs+W1WmaH278gL3nkgCGczeMnYFBvhBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIoszn0Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C26606A320;
	Wed, 18 Nov 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIoszn0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A90C1F000C4;
	Wed, 18 Nov 2026 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025863;
	bh=iopnfnlxUdLAtqb3yuFybixL5EDPKVafvroXM2Gq6dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIoszn0Qoe4RX3Krpcjq1wi0sFQtfdjF3MuLwVOOV/YVxuiZlLuSemS3UgznYRu6m
	 r8F7Zr8bybqONBy9neogf2icqAOcBugkOSTXGOSWayD24i+IeRKqRp6aiMpPcw6txj
	 vt+3TlIMZ+uTkVSLNsZjmeqJjz5JYbhnG0jn9Uug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1229/2151] wifi: mt76: mt7996: report station statistics from the primary link
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118150206.957519740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit a9792846fbc62af2290552ab66b5a855415acaa8 ]

mt7996_sta_statistics() and mt7996_ethtool_worker() read the TX rate,
the TX counters and the ACK signal from msta->deflink. That is the
msta_link of the first link of the station, not of its primary link.
When the first link of an MLD station is removed, msta->deflink keeps
the values of the removed link, and the station reports them until it
is removed.

Read them from the link that deflink_id selects.

msta->deflink also holds the RX reorder state, the TX aggregation
state and the def_wcid target of all links. These are state of the
whole station, and wcid_to_sta() needs def_wcid at the start of
drv_priv, so they stay there.

Fixes: f520eceacd24 ("wifi: mt76: mt7996: Add mt7996_mac_sta_change_links callback")
Link: https://patch.msgid.link/20261006205936.669125-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1753,9 +1753,16 @@ static void mt7996_sta_statistics(struct
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
-	struct rate_info *txrate = &msta_link->wcid.rate;
+	struct mt7996_sta_link *msta_link;
+	struct rate_info *txrate;
+
+	rcu_read_lock();
 
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (!msta_link)
+		goto out;
+
+	txrate = &msta_link->wcid.rate;
 	if (txrate->legacy || txrate->flags) {
 		if (txrate->legacy) {
 			sinfo->txrate.legacy = txrate->legacy;
@@ -1798,6 +1805,9 @@ static void mt7996_sta_statistics(struct
 		sinfo->rx_packets = msta_link->wcid.stats.rx_packets;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 static void mt7996_link_rate_ctrl_update(void *data,
@@ -2084,11 +2094,15 @@ static void mt7996_ethtool_worker(void *
 {
 	struct mt76_ethtool_worker_info *wi = wi_data;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
+	struct mt7996_sta_link *msta_link;
 
 	if (msta->vif->deflink.mt76.idx != wi->idx)
 		return;
 
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (!msta_link)
+		return;
+
 	mt76_ethtool_worker(wi, &msta_link->wcid.stats, true);
 }
 


