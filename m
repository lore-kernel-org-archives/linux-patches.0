Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830833;
	b=IQY/kKgJGGcnQg5l97dP108e1cUgkaRHtYGU3FVLjfTMV0i4CQVoNInBsNYD+jpFMCS4
	 1HAingvxgTO6aspu9AX7o42Qr4eefukH6n5umw/ejeAglPc9yatWZJQEG4u4r/uTMwuBw
	 ptE0S9eOBbfskQcRqkDNlrkpjWd7iNPyr6AV9uU3SKBz7rLn020qjQVAO9jZr3GMTsVDb
	 CcmvS96NkwMA6JDiL+qn0pDhdKppcSslu9TRacwcea/QI/AK2aTxnDP0YzatwYwITMoZ1
	 Co8YdZVGriLvIIFCyMYGgKysFZ9TCGE2+xecfmznnxZk/xuwnXhGQXFNwmrN3NgjHdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZndNSRgBbVGx3vuqXQYgS9z6GkG9vV+ljSSByQnUbKU=;
	b=mJRVxn4WHwEzDk4j0dSQz5VB4q0sXwyOU+hyZvj9NsusB1oZQIUDvTJoxgcTbKmN1gyP
	 GZdW/bGebXxbSjDS0dZSYQmRWDMribZGYf0DD3tzgzfGkW1t3G4ZT0bI3keQHYAnG5GsL
	 tn+sRxQ8nPOxme+jT3ZJ8UOqvdy2aaAHvtyy9xhSvDjFU0jJVcIBIGgGtuHdnpuSYZACb
	 GC/BFDqbalXthvlr3i0ugU4vJJ1NDTRxqFo9IpSrNmdkct06vMufGukfzKww1i5YD7Er5
	 tTIS0gSV4N0PRjkUIqWxLl/bJh5K77mmjkXarRuXRGSaUtX4TK2Y9qAj4dzHjp5WhCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgUi4hd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15662606CA02;
	Wed,  4 Nov 2026 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PgUi4hd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA051F00A02;
	Wed,  4 Nov 2026 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830832;
	bh=ZndNSRgBbVGx3vuqXQYgS9z6GkG9vV+ljSSByQnUbKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgUi4hd5r4LBGdheDK8Ch56denL50IATnW57Sg7/VjYcy3Hh3PT/kQA10hd1FSSCU
	 BGPdMACt79UxhjyHlFDGfnXT76PAYZ5PRjV0FsycN/vB6rZpZGRs2dwfcTBWBYGCYX
	 FdL3p4YhisOClIkhy7RsikGjwDxn3ty6gTsgQqtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0309/1005] wifi: mt76: mt7603: restore hardware PS buffering after a service period
Date: Wed,  4 Nov 2026 16:00:42 -0500
Message-ID: <20261104211052.585905074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

[ Upstream commit 636a883e2feef5e4ff95695d3c372ceff03960f5 ]

Releasing buffered frames has to turn off the PSE redirect for the
station, otherwise the released frames are looped straight back into the
driver PS queue. Nothing ever turns it back on: mt7603_sta_ps() only runs
on an observed PM bit transition, and MT_WCID_FLAG_PS keeps mt76 from
reporting the same state twice. After the first service period the
hardware therefore treats a dozing station as awake and transmits at it
directly, which is where the retry storms and the packet loss reported
against U-APSD clients come from.

Re-arm hardware buffering from mt7603_mac_work() for every station that
is still known to be asleep, once the PSD queue has drained and the
released frames have passed the redirect stage. Frames that are still
queued belong to the service period that was just served, so unlike on a
sleep transition they must not be pulled back with mt7603_filter_tx().

Track the sleep state separately from the WTBL state, so a station that
wakes up while the re-arm is pending is not put back to sleep.

Link: https://patch.msgid.link/20260801145334.1166751-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 73 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  4 +
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 6387f9e61060a..85c727fc44e6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -235,16 +235,17 @@ void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	sta->smps = enabled;
 }
 
-void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
-			bool enabled)
+static void
+__mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+		     bool enabled, bool filter)
 {
 	int idx = sta->wcid.idx;
 	u32 addr;
 
-	spin_lock_bh(&dev->ps_lock);
+	lockdep_assert_held(&dev->ps_lock);
 
 	if (sta->ps == enabled)
-		goto out;
+		return;
 
 	mt76_wr(dev, MT_PSE_RTA,
 		FIELD_PREP(MT_PSE_RTA_TAG_ID, idx) |
@@ -255,7 +256,7 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 
 	mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
 
-	if (enabled)
+	if (enabled && filter)
 		mt7603_filter_tx(dev, sta->vif->idx, idx, false);
 
 	addr = mt7603_wtbl1_addr(idx);
@@ -264,8 +265,34 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		 enabled * MT_WTBL1_W3_POWER_SAVE);
 	mt76_clear(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
 	sta->ps = enabled;
+}
 
-out:
+void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool enabled)
+{
+	spin_lock_bh(&dev->ps_lock);
+	__mt7603_wtbl_set_ps(dev, sta, enabled, enabled);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta, bool ps)
+{
+	spin_lock_bh(&dev->ps_lock);
+	sta->ps_sleeping = ps;
+	__mt7603_wtbl_set_ps(dev, sta, ps, ps);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta)
+{
+	spin_lock_bh(&dev->ps_lock);
+	/*
+	 * Frames that are already queued for the station belong to the service
+	 * period that has just been served, so unlike on a sleep transition
+	 * they must not be pulled back into the PS queue.
+	 */
+	if (sta->ps_sleeping)
+		__mt7603_wtbl_set_ps(dev, sta, true, false);
 	spin_unlock_bh(&dev->ps_lock);
 }
 
@@ -1816,6 +1843,39 @@ mt7603_false_cca_check(struct mt7603_dev *dev)
 	mt7603_adjust_sensitivity(dev);
 }
 
+/*
+ * Releasing buffered frames turns off the PSE redirect for a station, since
+ * the released frames would otherwise be looped back into the driver PS queue
+ * again. mac80211 never tells us when the service period is over, so hardware
+ * buffering has to be re-armed here for every station that is still known to
+ * be asleep. Waiting for the PSD queue to drain makes sure that the released
+ * frames have already passed the redirect stage.
+ */
+static void
+mt7603_mac_ps_check(struct mt7603_dev *dev)
+{
+	int i;
+
+	if (dev->mphy.q_tx[MT_TXQ_PSD]->queued)
+		return;
+
+	rcu_read_lock();
+	for (i = 0; i < MT7603_WTBL_STA; i++) {
+		struct mt76_wcid *wcid = mt76_wcid_ptr(dev, i);
+		struct mt7603_sta *msta;
+
+		if (!wcid || !wcid->sta)
+			continue;
+
+		msta = container_of(wcid, struct mt7603_sta, wcid);
+		if (msta->ps || !msta->ps_sleeping)
+			continue;
+
+		mt7603_wtbl_restore_ps(dev, msta);
+	}
+	rcu_read_unlock();
+}
+
 void mt7603_mac_work(struct work_struct *work)
 {
 	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
@@ -1830,6 +1890,7 @@ void mt7603_mac_work(struct work_struct *work)
 	dev->mphy.mac_work_count++;
 	mt76_update_survey(&dev->mphy);
 	mt7603_edcca_check(dev);
+	mt7603_mac_ps_check(dev);
 
 	for (i = 0, idx = 0; i < 2; i++) {
 		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index f8a43d9f72f95..04e3966ab047f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -410,7 +410,7 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	struct sk_buff_head list;
 
 	mt76_stop_tx_queues(&dev->mphy, sta, true);
-	mt7603_wtbl_set_ps(dev, msta, ps);
+	mt7603_wtbl_sta_ps(dev, msta, ps);
 	if (ps)
 		return;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 55a034ccbacd9..c43ddd3e693c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -80,6 +80,7 @@ struct mt7603_sta {
 	u8 smps;
 
 	u8 ps;
+	u8 ps_sleeping;
 };
 
 struct mt7603_vif {
@@ -229,6 +230,9 @@ int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
 			struct ieee80211_key_conf *key);
 void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			bool enabled);
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool ps);
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta);
 void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			  bool enabled);
 void mt7603_filter_tx(struct mt7603_dev *dev, int mac_idx, int idx, bool abort);
-- 
2.53.0



