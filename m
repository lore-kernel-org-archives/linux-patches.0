Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0C41F873B;
	Wed, 17 Sep 2025 12:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112967; cv=none; b=DFPxj00CADgfcluk/MDG+w58XxJutLdJ0CvrKSdUi8P3OoFTY1K0sQCGyUgnPfPMtBzTaHQoebO0vmI6BzuPaUApXFNQ6qM2m2IraTnxUOhXcD2Edh+8sk+hzHW5Y6XJfQntTtmvdeYIG8EkAsmmq492pvlHrWJsCWRq7TAXSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112967; c=relaxed/simple;
	bh=MKHA8LP7mnZoE6azn+IwX2T/OXRpnr8aBWtzSojzs+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq4/NThqgOltwINxU5lOWILDh93g/JpUr+R5EDPre/Mo2S6glJEMDFejsQ8tDiTE+yJVPzdofCAN853cCX79xvpIxjRx6K/BCKhnUWUXgq/8pGkCDrd1uQ5Yj+9luCvacTparO+ZwDqjofUB9OhYfmQ3siw17bqgjWMqOjNZ99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd4nNtON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd4nNtON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A8DC4CEF0;
	Wed, 17 Sep 2025 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112966;
	bh=MKHA8LP7mnZoE6azn+IwX2T/OXRpnr8aBWtzSojzs+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd4nNtONiqxV3n18aQRWt4yBeLNUMGiyLwMAZ9oO1il//CHKPskhVpdsm5ZV3Y0Yj
	 VP/9caR3q2wgLwjo8iPbHAZ+2V31E+WeZdgyHZiRO7cxCZbrxXVCzsr+zRfc8eaQK8
	 qbtlL6bjGgH6T4WYm54UQq6cxyGT59NfssizcoIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 130/189] wifi: ath12k: Fix missing station power save configuration
Date: Wed, 17 Sep 2025 14:34:00 +0200
Message-ID: <20250917123355.033918979@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 4b66d18918f8e4d85e51974a9e3ce9abad5c7c3d ]

Commit afbab6e4e88d ("wifi: ath12k: modify ath12k_mac_op_bss_info_changed()
for MLO") replaced the bss_info_changed() callback with vif_cfg_changed()
and link_info_changed() to support Multi-Link Operation (MLO). As a result,
the station power save configuration is no longer correctly applied in
ath12k_mac_bss_info_changed().

Move the handling of 'BSS_CHANGED_PS' into ath12k_mac_op_vif_cfg_changed()
to align with the updated callback structure introduced for MLO, ensuring
proper power-save behavior for station interfaces.

Tested-on: WCN7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00011-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: afbab6e4e88d ("wifi: ath12k: modify ath12k_mac_op_bss_info_changed() for MLO")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250908015025.1301398-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 122 ++++++++++++++------------
 1 file changed, 67 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index a885dd168a372..87944e4467050 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3650,12 +3650,68 @@ static int ath12k_mac_fils_discovery(struct ath12k_link_vif *arvif,
 	return ret;
 }
 
+static void ath12k_mac_vif_setup_ps(struct ath12k_link_vif *arvif)
+{
+	struct ath12k *ar = arvif->ar;
+	struct ieee80211_vif *vif = arvif->ahvif->vif;
+	struct ieee80211_conf *conf = &ath12k_ar_to_hw(ar)->conf;
+	enum wmi_sta_powersave_param param;
+	struct ieee80211_bss_conf *info;
+	enum wmi_sta_ps_mode psmode;
+	int ret;
+	int timeout;
+	bool enable_ps;
+
+	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	enable_ps = arvif->ahvif->ps;
+	if (enable_ps) {
+		psmode = WMI_STA_PS_MODE_ENABLED;
+		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
+
+		timeout = conf->dynamic_ps_timeout;
+		if (timeout == 0) {
+			info = ath12k_mac_get_link_bss_conf(arvif);
+			if (!info) {
+				ath12k_warn(ar->ab, "unable to access bss link conf in setup ps for vif %pM link %u\n",
+					    vif->addr, arvif->link_id);
+				return;
+			}
+
+			/* firmware doesn't like 0 */
+			timeout = ieee80211_tu_to_usec(info->beacon_int) / 1000;
+		}
+
+		ret = ath12k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
+						  timeout);
+		if (ret) {
+			ath12k_warn(ar->ab, "failed to set inactivity time for vdev %d: %i\n",
+				    arvif->vdev_id, ret);
+			return;
+		}
+	} else {
+		psmode = WMI_STA_PS_MODE_DISABLED;
+	}
+
+	ath12k_dbg(ar->ab, ATH12K_DBG_MAC, "mac vdev %d psmode %s\n",
+		   arvif->vdev_id, psmode ? "enable" : "disable");
+
+	ret = ath12k_wmi_pdev_set_ps_mode(ar, arvif->vdev_id, psmode);
+	if (ret)
+		ath12k_warn(ar->ab, "failed to set sta power save mode %d for vdev %d: %d\n",
+			    psmode, arvif->vdev_id, ret);
+}
+
 static void ath12k_mac_op_vif_cfg_changed(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif,
 					  u64 changed)
 {
 	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
 	unsigned long links = ahvif->links_map;
+	struct ieee80211_vif_cfg *vif_cfg;
 	struct ieee80211_bss_conf *info;
 	struct ath12k_link_vif *arvif;
 	struct ieee80211_sta *sta;
@@ -3719,61 +3775,24 @@ static void ath12k_mac_op_vif_cfg_changed(struct ieee80211_hw *hw,
 			}
 		}
 	}
-}
-
-static void ath12k_mac_vif_setup_ps(struct ath12k_link_vif *arvif)
-{
-	struct ath12k *ar = arvif->ar;
-	struct ieee80211_vif *vif = arvif->ahvif->vif;
-	struct ieee80211_conf *conf = &ath12k_ar_to_hw(ar)->conf;
-	enum wmi_sta_powersave_param param;
-	struct ieee80211_bss_conf *info;
-	enum wmi_sta_ps_mode psmode;
-	int ret;
-	int timeout;
-	bool enable_ps;
 
-	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
+	if (changed & BSS_CHANGED_PS) {
+		links = ahvif->links_map;
+		vif_cfg = &vif->cfg;
 
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
+		for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+			arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
+			if (!arvif || !arvif->ar)
+				continue;
 
-	enable_ps = arvif->ahvif->ps;
-	if (enable_ps) {
-		psmode = WMI_STA_PS_MODE_ENABLED;
-		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
+			ar = arvif->ar;
 
-		timeout = conf->dynamic_ps_timeout;
-		if (timeout == 0) {
-			info = ath12k_mac_get_link_bss_conf(arvif);
-			if (!info) {
-				ath12k_warn(ar->ab, "unable to access bss link conf in setup ps for vif %pM link %u\n",
-					    vif->addr, arvif->link_id);
-				return;
+			if (ar->ab->hw_params->supports_sta_ps) {
+				ahvif->ps = vif_cfg->ps;
+				ath12k_mac_vif_setup_ps(arvif);
 			}
-
-			/* firmware doesn't like 0 */
-			timeout = ieee80211_tu_to_usec(info->beacon_int) / 1000;
 		}
-
-		ret = ath12k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param,
-						  timeout);
-		if (ret) {
-			ath12k_warn(ar->ab, "failed to set inactivity time for vdev %d: %i\n",
-				    arvif->vdev_id, ret);
-			return;
-		}
-	} else {
-		psmode = WMI_STA_PS_MODE_DISABLED;
 	}
-
-	ath12k_dbg(ar->ab, ATH12K_DBG_MAC, "mac vdev %d psmode %s\n",
-		   arvif->vdev_id, psmode ? "enable" : "disable");
-
-	ret = ath12k_wmi_pdev_set_ps_mode(ar, arvif->vdev_id, psmode);
-	if (ret)
-		ath12k_warn(ar->ab, "failed to set sta power save mode %d for vdev %d: %d\n",
-			    psmode, arvif->vdev_id, ret);
 }
 
 static bool ath12k_mac_supports_station_tpc(struct ath12k *ar,
@@ -3795,7 +3814,6 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 {
 	struct ath12k_vif *ahvif = arvif->ahvif;
 	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(ahvif);
-	struct ieee80211_vif_cfg *vif_cfg = &vif->cfg;
 	struct cfg80211_chan_def def;
 	u32 param_id, param_value;
 	enum nl80211_band band;
@@ -4069,12 +4087,6 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 	}
 
 	ath12k_mac_fils_discovery(arvif, info);
-
-	if (changed & BSS_CHANGED_PS &&
-	    ar->ab->hw_params->supports_sta_ps) {
-		ahvif->ps = vif_cfg->ps;
-		ath12k_mac_vif_setup_ps(arvif);
-	}
 }
 
 static struct ath12k_vif_cache *ath12k_ahvif_get_link_cache(struct ath12k_vif *ahvif,
-- 
2.51.0



