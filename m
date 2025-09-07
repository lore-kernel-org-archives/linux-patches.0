Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438A1B424F;
	Sun,  7 Sep 2025 20:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276553; cv=none; b=YvJV2IYSkBJ7zNucSjItIJdjxsngBV2e6B2T0ym4Olqdn+6g2/L6iozsTphzB7jni3EVTDuPnyUZjn0YUmZWcMTHunRJ2RBMgvTf+yp1JBN4nzKa+w5w1eixE64TTdayK8xxMZP/ReuUXDm0mLHdtSYDJtDJ6uru2O2IytSwcLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276553; c=relaxed/simple;
	bh=EII8aC/yDzLnTGuUGr6TEjVS+EBjFC3+i6VhTWDVjw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC8T7Ecs3J8FN9RgVPMsqlZl6/W0GiDjxdH03ErCqAOWRJKSklzLvA04UvcVTvExUL7EIz8RqoKQz/7nyp70o87Ei+tpwFFNPkoe9angzRYqP50S38d6qOj6WCNKiGTD4EDRIaiVAsdLq4MR89NN3rBlNtRJhUgLw5+tRgS72yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z15jDGFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z15jDGFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2674DC4CEF0;
	Sun,  7 Sep 2025 20:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276553;
	bh=EII8aC/yDzLnTGuUGr6TEjVS+EBjFC3+i6VhTWDVjw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z15jDGFFkWyZoKw2Sh6HVL384Op9sACeUkyrwfu9qR//bHJrtdNsLON3/H6E11eLj
	 Tll2d/7OXBWTEQoGIMBgkeU/gZaw7a6RfsQsacAPM6aFwDryto6iyJUMCQpW7urA+G
	 ms30SczEpLKdxO3lNvSZvKTleEbhRLL2bDxa8Sag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/121] wifi: ath11k: avoid forward declaration of ath11k_mac_start_vdev_delay()
Date: Sun,  7 Sep 2025 21:57:51 +0200
Message-ID: <20250907195610.732605619@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit ce59902e56ea0477ad9bef0067d0e47b6c4d707d ]

Currently ath11k_mac_start_vdev_delay() needs a forward declaration because
it is defined after where it is called. Avoid this by re-arranging
ath11k_mac_station_add() and ath11k_mac_op_sta_state().

No functional changes. Compile tested only.

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240123025700.2929-4-quic_bqiang@quicinc.com
Stable-dep-of: 97acb0259cc9 ("wifi: ath11k: fix group data packet drops during rekey")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 459 +++++++++++++-------------
 1 file changed, 228 insertions(+), 231 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 58cc079f0df4a..eb295d092a33c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -254,9 +254,6 @@ static const u32 ath11k_smps_map[] = {
 	[WLAN_HT_CAP_SM_PS_DISABLED] = WMI_PEER_SMPS_PS_NONE,
 };
 
-static int ath11k_mac_start_vdev_delay(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif);
-
 enum nl80211_he_ru_alloc ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy)
 {
 	enum nl80211_he_ru_alloc ret;
@@ -4896,100 +4893,6 @@ static void ath11k_mac_dec_num_stations(struct ath11k_vif *arvif,
 	ar->num_stations--;
 }
 
-static int ath11k_mac_station_add(struct ath11k *ar,
-				  struct ieee80211_vif *vif,
-				  struct ieee80211_sta *sta)
-{
-	struct ath11k_base *ab = ar->ab;
-	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
-	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
-	struct peer_create_params peer_param;
-	int ret;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	ret = ath11k_mac_inc_num_stations(arvif, sta);
-	if (ret) {
-		ath11k_warn(ab, "refusing to associate station: too many connected already (%d)\n",
-			    ar->max_num_stations);
-		goto exit;
-	}
-
-	arsta->rx_stats = kzalloc(sizeof(*arsta->rx_stats), GFP_KERNEL);
-	if (!arsta->rx_stats) {
-		ret = -ENOMEM;
-		goto dec_num_station;
-	}
-
-	peer_param.vdev_id = arvif->vdev_id;
-	peer_param.peer_addr = sta->addr;
-	peer_param.peer_type = WMI_PEER_TYPE_DEFAULT;
-
-	ret = ath11k_peer_create(ar, arvif, sta, &peer_param);
-	if (ret) {
-		ath11k_warn(ab, "Failed to add peer: %pM for VDEV: %d\n",
-			    sta->addr, arvif->vdev_id);
-		goto free_rx_stats;
-	}
-
-	ath11k_dbg(ab, ATH11K_DBG_MAC, "Added peer: %pM for VDEV: %d\n",
-		   sta->addr, arvif->vdev_id);
-
-	if (ath11k_debugfs_is_extd_tx_stats_enabled(ar)) {
-		arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats), GFP_KERNEL);
-		if (!arsta->tx_stats) {
-			ret = -ENOMEM;
-			goto free_peer;
-		}
-	}
-
-	if (ieee80211_vif_is_mesh(vif)) {
-		ath11k_dbg(ab, ATH11K_DBG_MAC,
-			   "setting USE_4ADDR for mesh STA %pM\n", sta->addr);
-		ret = ath11k_wmi_set_peer_param(ar, sta->addr,
-						arvif->vdev_id,
-						WMI_PEER_USE_4ADDR, 1);
-		if (ret) {
-			ath11k_warn(ab, "failed to set mesh STA %pM 4addr capability: %d\n",
-				    sta->addr, ret);
-			goto free_tx_stats;
-		}
-	}
-
-	ret = ath11k_dp_peer_setup(ar, arvif->vdev_id, sta->addr);
-	if (ret) {
-		ath11k_warn(ab, "failed to setup dp for peer %pM on vdev %i (%d)\n",
-			    sta->addr, arvif->vdev_id, ret);
-		goto free_tx_stats;
-	}
-
-	if (ab->hw_params.vdev_start_delay &&
-	    !arvif->is_started &&
-	    arvif->vdev_type != WMI_VDEV_TYPE_AP) {
-		ret = ath11k_mac_start_vdev_delay(ar->hw, vif);
-		if (ret) {
-			ath11k_warn(ab, "failed to delay vdev start: %d\n", ret);
-			goto free_tx_stats;
-		}
-	}
-
-	ewma_avg_rssi_init(&arsta->avg_rssi);
-	return 0;
-
-free_tx_stats:
-	kfree(arsta->tx_stats);
-	arsta->tx_stats = NULL;
-free_peer:
-	ath11k_peer_delete(ar, arvif->vdev_id, sta->addr);
-free_rx_stats:
-	kfree(arsta->rx_stats);
-	arsta->rx_stats = NULL;
-dec_num_station:
-	ath11k_mac_dec_num_stations(arvif, sta);
-exit:
-	return ret;
-}
-
 static u32 ath11k_mac_ieee80211_sta_bw_to_wmi(struct ath11k *ar,
 					      struct ieee80211_sta *sta)
 {
@@ -5018,140 +4921,6 @@ static u32 ath11k_mac_ieee80211_sta_bw_to_wmi(struct ath11k *ar,
 	return bw;
 }
 
-static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_sta *sta,
-				   enum ieee80211_sta_state old_state,
-				   enum ieee80211_sta_state new_state)
-{
-	struct ath11k *ar = hw->priv;
-	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
-	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
-	struct ath11k_peer *peer;
-	int ret = 0;
-
-	/* cancel must be done outside the mutex to avoid deadlock */
-	if ((old_state == IEEE80211_STA_NONE &&
-	     new_state == IEEE80211_STA_NOTEXIST)) {
-		cancel_work_sync(&arsta->update_wk);
-		cancel_work_sync(&arsta->set_4addr_wk);
-	}
-
-	mutex_lock(&ar->conf_mutex);
-
-	if (old_state == IEEE80211_STA_NOTEXIST &&
-	    new_state == IEEE80211_STA_NONE) {
-		memset(arsta, 0, sizeof(*arsta));
-		arsta->arvif = arvif;
-		arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
-		INIT_WORK(&arsta->update_wk, ath11k_sta_rc_update_wk);
-		INIT_WORK(&arsta->set_4addr_wk, ath11k_sta_set_4addr_wk);
-
-		ret = ath11k_mac_station_add(ar, vif, sta);
-		if (ret)
-			ath11k_warn(ar->ab, "Failed to add station: %pM for VDEV: %d\n",
-				    sta->addr, arvif->vdev_id);
-	} else if ((old_state == IEEE80211_STA_NONE &&
-		    new_state == IEEE80211_STA_NOTEXIST)) {
-		bool skip_peer_delete = ar->ab->hw_params.vdev_start_delay &&
-			vif->type == NL80211_IFTYPE_STATION;
-
-		ath11k_dp_peer_cleanup(ar, arvif->vdev_id, sta->addr);
-
-		if (!skip_peer_delete) {
-			ret = ath11k_peer_delete(ar, arvif->vdev_id, sta->addr);
-			if (ret)
-				ath11k_warn(ar->ab,
-					    "Failed to delete peer: %pM for VDEV: %d\n",
-					    sta->addr, arvif->vdev_id);
-			else
-				ath11k_dbg(ar->ab,
-					   ATH11K_DBG_MAC,
-					   "Removed peer: %pM for VDEV: %d\n",
-					   sta->addr, arvif->vdev_id);
-		}
-
-		ath11k_mac_dec_num_stations(arvif, sta);
-		mutex_lock(&ar->ab->tbl_mtx_lock);
-		spin_lock_bh(&ar->ab->base_lock);
-		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
-		if (skip_peer_delete && peer) {
-			peer->sta = NULL;
-		} else if (peer && peer->sta == sta) {
-			ath11k_warn(ar->ab, "Found peer entry %pM n vdev %i after it was supposedly removed\n",
-				    vif->addr, arvif->vdev_id);
-			ath11k_peer_rhash_delete(ar->ab, peer);
-			peer->sta = NULL;
-			list_del(&peer->list);
-			kfree(peer);
-			ar->num_peers--;
-		}
-		spin_unlock_bh(&ar->ab->base_lock);
-		mutex_unlock(&ar->ab->tbl_mtx_lock);
-
-		kfree(arsta->tx_stats);
-		arsta->tx_stats = NULL;
-
-		kfree(arsta->rx_stats);
-		arsta->rx_stats = NULL;
-	} else if (old_state == IEEE80211_STA_AUTH &&
-		   new_state == IEEE80211_STA_ASSOC &&
-		   (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_MESH_POINT ||
-		    vif->type == NL80211_IFTYPE_ADHOC)) {
-		ret = ath11k_station_assoc(ar, vif, sta, false);
-		if (ret)
-			ath11k_warn(ar->ab, "Failed to associate station: %pM\n",
-				    sta->addr);
-
-		spin_lock_bh(&ar->data_lock);
-		/* Set arsta bw and prev bw */
-		arsta->bw = ath11k_mac_ieee80211_sta_bw_to_wmi(ar, sta);
-		arsta->bw_prev = arsta->bw;
-		spin_unlock_bh(&ar->data_lock);
-	} else if (old_state == IEEE80211_STA_ASSOC &&
-		   new_state == IEEE80211_STA_AUTHORIZED) {
-		spin_lock_bh(&ar->ab->base_lock);
-
-		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
-		if (peer)
-			peer->is_authorized = true;
-
-		spin_unlock_bh(&ar->ab->base_lock);
-
-		if (vif->type == NL80211_IFTYPE_STATION && arvif->is_up) {
-			ret = ath11k_wmi_set_peer_param(ar, sta->addr,
-							arvif->vdev_id,
-							WMI_PEER_AUTHORIZE,
-							1);
-			if (ret)
-				ath11k_warn(ar->ab, "Unable to authorize peer %pM vdev %d: %d\n",
-					    sta->addr, arvif->vdev_id, ret);
-		}
-	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
-		   new_state == IEEE80211_STA_ASSOC) {
-		spin_lock_bh(&ar->ab->base_lock);
-
-		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
-		if (peer)
-			peer->is_authorized = false;
-
-		spin_unlock_bh(&ar->ab->base_lock);
-	} else if (old_state == IEEE80211_STA_ASSOC &&
-		   new_state == IEEE80211_STA_AUTH &&
-		   (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_MESH_POINT ||
-		    vif->type == NL80211_IFTYPE_ADHOC)) {
-		ret = ath11k_station_disassoc(ar, vif, sta);
-		if (ret)
-			ath11k_warn(ar->ab, "Failed to disassociate station: %pM\n",
-				    sta->addr);
-	}
-
-	mutex_unlock(&ar->conf_mutex);
-	return ret;
-}
-
 static int ath11k_mac_op_sta_set_txpwr(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_sta *sta)
@@ -9099,6 +8868,234 @@ static int ath11k_mac_op_get_txpower(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int ath11k_mac_station_add(struct ath11k *ar,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta)
+{
+	struct ath11k_base *ab = ar->ab;
+	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
+	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
+	struct peer_create_params peer_param;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ret = ath11k_mac_inc_num_stations(arvif, sta);
+	if (ret) {
+		ath11k_warn(ab, "refusing to associate station: too many connected already (%d)\n",
+			    ar->max_num_stations);
+		goto exit;
+	}
+
+	arsta->rx_stats = kzalloc(sizeof(*arsta->rx_stats), GFP_KERNEL);
+	if (!arsta->rx_stats) {
+		ret = -ENOMEM;
+		goto dec_num_station;
+	}
+
+	peer_param.vdev_id = arvif->vdev_id;
+	peer_param.peer_addr = sta->addr;
+	peer_param.peer_type = WMI_PEER_TYPE_DEFAULT;
+
+	ret = ath11k_peer_create(ar, arvif, sta, &peer_param);
+	if (ret) {
+		ath11k_warn(ab, "Failed to add peer: %pM for VDEV: %d\n",
+			    sta->addr, arvif->vdev_id);
+		goto free_rx_stats;
+	}
+
+	ath11k_dbg(ab, ATH11K_DBG_MAC, "Added peer: %pM for VDEV: %d\n",
+		   sta->addr, arvif->vdev_id);
+
+	if (ath11k_debugfs_is_extd_tx_stats_enabled(ar)) {
+		arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats), GFP_KERNEL);
+		if (!arsta->tx_stats) {
+			ret = -ENOMEM;
+			goto free_peer;
+		}
+	}
+
+	if (ieee80211_vif_is_mesh(vif)) {
+		ath11k_dbg(ab, ATH11K_DBG_MAC,
+			   "setting USE_4ADDR for mesh STA %pM\n", sta->addr);
+		ret = ath11k_wmi_set_peer_param(ar, sta->addr,
+						arvif->vdev_id,
+						WMI_PEER_USE_4ADDR, 1);
+		if (ret) {
+			ath11k_warn(ab, "failed to set mesh STA %pM 4addr capability: %d\n",
+				    sta->addr, ret);
+			goto free_tx_stats;
+		}
+	}
+
+	ret = ath11k_dp_peer_setup(ar, arvif->vdev_id, sta->addr);
+	if (ret) {
+		ath11k_warn(ab, "failed to setup dp for peer %pM on vdev %i (%d)\n",
+			    sta->addr, arvif->vdev_id, ret);
+		goto free_tx_stats;
+	}
+
+	if (ab->hw_params.vdev_start_delay &&
+	    !arvif->is_started &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_AP) {
+		ret = ath11k_mac_start_vdev_delay(ar->hw, vif);
+		if (ret) {
+			ath11k_warn(ab, "failed to delay vdev start: %d\n", ret);
+			goto free_tx_stats;
+		}
+	}
+
+	ewma_avg_rssi_init(&arsta->avg_rssi);
+	return 0;
+
+free_tx_stats:
+	kfree(arsta->tx_stats);
+	arsta->tx_stats = NULL;
+free_peer:
+	ath11k_peer_delete(ar, arvif->vdev_id, sta->addr);
+free_rx_stats:
+	kfree(arsta->rx_stats);
+	arsta->rx_stats = NULL;
+dec_num_station:
+	ath11k_mac_dec_num_stations(arvif, sta);
+exit:
+	return ret;
+}
+
+static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta,
+				   enum ieee80211_sta_state old_state,
+				   enum ieee80211_sta_state new_state)
+{
+	struct ath11k *ar = hw->priv;
+	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
+	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
+	struct ath11k_peer *peer;
+	int ret = 0;
+
+	/* cancel must be done outside the mutex to avoid deadlock */
+	if ((old_state == IEEE80211_STA_NONE &&
+	     new_state == IEEE80211_STA_NOTEXIST)) {
+		cancel_work_sync(&arsta->update_wk);
+		cancel_work_sync(&arsta->set_4addr_wk);
+	}
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE) {
+		memset(arsta, 0, sizeof(*arsta));
+		arsta->arvif = arvif;
+		arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
+		INIT_WORK(&arsta->update_wk, ath11k_sta_rc_update_wk);
+		INIT_WORK(&arsta->set_4addr_wk, ath11k_sta_set_4addr_wk);
+
+		ret = ath11k_mac_station_add(ar, vif, sta);
+		if (ret)
+			ath11k_warn(ar->ab, "Failed to add station: %pM for VDEV: %d\n",
+				    sta->addr, arvif->vdev_id);
+	} else if ((old_state == IEEE80211_STA_NONE &&
+		    new_state == IEEE80211_STA_NOTEXIST)) {
+		bool skip_peer_delete = ar->ab->hw_params.vdev_start_delay &&
+			vif->type == NL80211_IFTYPE_STATION;
+
+		ath11k_dp_peer_cleanup(ar, arvif->vdev_id, sta->addr);
+
+		if (!skip_peer_delete) {
+			ret = ath11k_peer_delete(ar, arvif->vdev_id, sta->addr);
+			if (ret)
+				ath11k_warn(ar->ab,
+					    "Failed to delete peer: %pM for VDEV: %d\n",
+					    sta->addr, arvif->vdev_id);
+			else
+				ath11k_dbg(ar->ab,
+					   ATH11K_DBG_MAC,
+					   "Removed peer: %pM for VDEV: %d\n",
+					   sta->addr, arvif->vdev_id);
+		}
+
+		ath11k_mac_dec_num_stations(arvif, sta);
+		mutex_lock(&ar->ab->tbl_mtx_lock);
+		spin_lock_bh(&ar->ab->base_lock);
+		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
+		if (skip_peer_delete && peer) {
+			peer->sta = NULL;
+		} else if (peer && peer->sta == sta) {
+			ath11k_warn(ar->ab, "Found peer entry %pM n vdev %i after it was supposedly removed\n",
+				    vif->addr, arvif->vdev_id);
+			ath11k_peer_rhash_delete(ar->ab, peer);
+			peer->sta = NULL;
+			list_del(&peer->list);
+			kfree(peer);
+			ar->num_peers--;
+		}
+		spin_unlock_bh(&ar->ab->base_lock);
+		mutex_unlock(&ar->ab->tbl_mtx_lock);
+
+		kfree(arsta->tx_stats);
+		arsta->tx_stats = NULL;
+
+		kfree(arsta->rx_stats);
+		arsta->rx_stats = NULL;
+	} else if (old_state == IEEE80211_STA_AUTH &&
+		   new_state == IEEE80211_STA_ASSOC &&
+		   (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_MESH_POINT ||
+		    vif->type == NL80211_IFTYPE_ADHOC)) {
+		ret = ath11k_station_assoc(ar, vif, sta, false);
+		if (ret)
+			ath11k_warn(ar->ab, "Failed to associate station: %pM\n",
+				    sta->addr);
+
+		spin_lock_bh(&ar->data_lock);
+		/* Set arsta bw and prev bw */
+		arsta->bw = ath11k_mac_ieee80211_sta_bw_to_wmi(ar, sta);
+		arsta->bw_prev = arsta->bw;
+		spin_unlock_bh(&ar->data_lock);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		   new_state == IEEE80211_STA_AUTHORIZED) {
+		spin_lock_bh(&ar->ab->base_lock);
+
+		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
+		if (peer)
+			peer->is_authorized = true;
+
+		spin_unlock_bh(&ar->ab->base_lock);
+
+		if (vif->type == NL80211_IFTYPE_STATION && arvif->is_up) {
+			ret = ath11k_wmi_set_peer_param(ar, sta->addr,
+							arvif->vdev_id,
+							WMI_PEER_AUTHORIZE,
+							1);
+			if (ret)
+				ath11k_warn(ar->ab, "Unable to authorize peer %pM vdev %d: %d\n",
+					    sta->addr, arvif->vdev_id, ret);
+		}
+	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
+		   new_state == IEEE80211_STA_ASSOC) {
+		spin_lock_bh(&ar->ab->base_lock);
+
+		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
+		if (peer)
+			peer->is_authorized = false;
+
+		spin_unlock_bh(&ar->ab->base_lock);
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		   new_state == IEEE80211_STA_AUTH &&
+		   (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_MESH_POINT ||
+		    vif->type == NL80211_IFTYPE_ADHOC)) {
+		ret = ath11k_station_disassoc(ar, vif, sta);
+		if (ret)
+			ath11k_warn(ar->ab, "Failed to disassociate station: %pM\n",
+				    sta->addr);
+	}
+
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static const struct ieee80211_ops ath11k_ops = {
 	.tx				= ath11k_mac_op_tx,
 	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
-- 
2.50.1



