Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019096;
	b=Yh6DMklTCwzZy1V5FguyN6DNLzWEUKLs4jb7J0Ab4O3BeX5RcXBx18q/OEjmYW7uhCJl
	 OmBAai0UfG1IFLJmuZ9kBcgj3gd0S7tPvjgZ6/X0LSMjUOnyPCOyFT8YhWVBAo0XlJ0go
	 Rt6j2wPT6qrydqd983Wvr04avOwBXOr0Ozp3mVcpIAzXJR2W655TX4F4osZ63408M1V6s
	 ZTAEFaLUIZz6m0j9PEDsYH60DG76jZdBcO2v3vkRO/nYvLZHwXpQUGgAySN1zhqzJf4JW
	 tmKFC3ZfEuZBK5JNyjLVR+0vTDI+v1B7CIqbCfTUkjXx6+9KJMlB+JF8quViq+AB+1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UbbXKYeeqlXDGYk3RM9QGR17Saje8Gd8sYs7L3Fs1PQ=;
	b=q55mCe2h3cUDmAwD88Tqn/QbhwieMnVpaWOP7sfwItaEgVTR1hJ2jIbDQ0Ux45guYbtk
	 oagpUI0vWoyB3WYOvTDYCLX+8UM6R2pij7D0TvdiYnelAUFDzxNpQZncoG/tLg6YnmLta
	 jRaHukmaXbuM6MhVlr2x+pIQmgr+Cg72X099MpOkGMN8kaUc+CcZEK7J3swkorPItqBSK
	 cYCOIdhVmrWXbAuZu4gl7m2H4xfSRVnUrM8ixp3LDWXM01kN3AJzOEMlZYWNnQv/ly43u
	 PS+bkHg2cU+SAJY8+vWECiQeF06f6b9yzj7q7XemOAHnzKXqtUP7oEk9y4jM+GaYnFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E3ul3/SR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D3C60A3807;
	Wed, 18 Nov 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E3ul3/SR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D401F000CC;
	Wed, 18 Nov 2026 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019096;
	bh=UbbXKYeeqlXDGYk3RM9QGR17Saje8Gd8sYs7L3Fs1PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3ul3/SR+hUl2YJ+jqLpQJp8UjpbaTjQ7jCU4rK8lyluK8yOKYj3z0219uZ7f5ipl
	 AgkDiFGR02job6EHuYlbTv5YdySmUss0xYGP5+mZFGnSmBNBkwgRTZVy+NIX205tq9
	 XXawJWDgdI9nJrU783LbZhpi743P8yvYRz9dD/Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1473/2651] wifi: mt76: mt7996: report station statistics from the primary link
Date: Wed, 18 Nov 2026 15:45:13 +0100
Message-ID: <20261118150341.060761903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 1ce4a3be93395..b52308c42d106 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1928,9 +1928,16 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
-	struct rate_info *txrate = &msta_link->wcid.rate;
+	struct mt7996_sta_link *msta_link;
+	struct rate_info *txrate;
 
+	rcu_read_lock();
+
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (!msta_link)
+		goto out;
+
+	txrate = &msta_link->wcid.rate;
 	if (txrate->legacy || txrate->flags) {
 		if (txrate->legacy) {
 			sinfo->txrate.legacy = txrate->legacy;
@@ -1973,6 +1980,9 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->rx_packets = msta_link->wcid.stats.rx_packets;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 	}
+
+out:
+	rcu_read_unlock();
 }
 
 static void mt7996_link_rate_ctrl_update(void *data,
@@ -2272,11 +2282,15 @@ static void mt7996_ethtool_worker(void *wi_data, struct ieee80211_sta *sta)
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
 
-- 
2.53.0



