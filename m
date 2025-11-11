Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF0334A3CD;
	Tue, 11 Nov 2025 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825331; cv=none; b=ep0nio3bzu6MSQ7Z9pHWR2OhKouqCs03pW6srnUsz6RwpRkqhyKw36DNq091DS7cVg2nJtp8iyQhBvRCKODdepX3FXlqYSJcO8zE9p2ZNPn4fso6ACz7gXhjwsO0XchkKNf1/cShSSA0uA7W9tw3qkRnAtJQUYNUL+gD9CCgmIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825331; c=relaxed/simple;
	bh=TqsxLAC8AnZcgkA8sux/4w9D71Yp2//H9JNlc9j5v3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCuLTeUuuWyPzyB8ItTj1iEGLfBLHuOgfmeG2Pd9hWOnq2+m+gsVp0lKTcjPCwXz5mDwdkLZNF+KmmnvDZaBWNbMwuVklJpxJ5Wp5xPEtlUAXdEkJF7MSneLX8fRpijN6kzvMscDuRK84ZnC9bTd9aF/TmJvnqmhdNuaPiiQFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGR8bLZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGR8bLZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76636C4CEF5;
	Tue, 11 Nov 2025 01:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825328;
	bh=TqsxLAC8AnZcgkA8sux/4w9D71Yp2//H9JNlc9j5v3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGR8bLZ+i6IIjDYKypahUCFItNm1+prOqEKv4JRLXExqsNQr3Et5xt3RE122KBWQh
	 x+LBVnQjNpUuJCri97aL+4HU4YKCf2X1X9vLZmalMrxazAv00D6XZ0klUkVER+zXIk
	 F5Qyyw4NlmZFUq/IDsCgTJa76cyexh5tkyzpiJyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Brown <true.robot.ross@gmail.com>,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 754/849] Revert "wifi: ath12k: Fix missing station power save configuration"
Date: Tue, 11 Nov 2025 09:45:24 +0900
Message-ID: <20251111004554.661735733@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 9222582ec524707fbb9d076febead5b6a07611ed ]

This reverts commit 4b66d18918f8e4d85e51974a9e3ce9abad5c7c3d.

In [1], Ross Brown reports poor performance of WCN7850 after enabling
power save. Temporarily revert the fix; it will be re-enabled once
the issue is resolved.

Tested-on: WCN7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00011-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Fixes: 4b66d18918f8 ("wifi: ath12k: Fix missing station power save configuration")
Reported-by: Ross Brown <true.robot.ross@gmail.com>
Closes: https://lore.kernel.org/all/CAMn66qZENLhDOcVJuwUZ3ir89PVtVnQRq9DkV5xjJn1p6BKB9w@mail.gmail.com/ # [1]
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251028060744.897198-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 122 ++++++++++++--------------
 1 file changed, 55 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d717e74b01c89..fd584633392c1 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4078,68 +4078,12 @@ static int ath12k_mac_fils_discovery(struct ath12k_link_vif *arvif,
 	return ret;
 }
 
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
-
-	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
-
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
-
-	enable_ps = arvif->ahvif->ps;
-	if (enable_ps) {
-		psmode = WMI_STA_PS_MODE_ENABLED;
-		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
-
-		timeout = conf->dynamic_ps_timeout;
-		if (timeout == 0) {
-			info = ath12k_mac_get_link_bss_conf(arvif);
-			if (!info) {
-				ath12k_warn(ar->ab, "unable to access bss link conf in setup ps for vif %pM link %u\n",
-					    vif->addr, arvif->link_id);
-				return;
-			}
-
-			/* firmware doesn't like 0 */
-			timeout = ieee80211_tu_to_usec(info->beacon_int) / 1000;
-		}
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
-	}
-
-	ath12k_dbg(ar->ab, ATH12K_DBG_MAC, "mac vdev %d psmode %s\n",
-		   arvif->vdev_id, psmode ? "enable" : "disable");
-
-	ret = ath12k_wmi_pdev_set_ps_mode(ar, arvif->vdev_id, psmode);
-	if (ret)
-		ath12k_warn(ar->ab, "failed to set sta power save mode %d for vdev %d: %d\n",
-			    psmode, arvif->vdev_id, ret);
-}
-
 static void ath12k_mac_op_vif_cfg_changed(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif,
 					  u64 changed)
 {
 	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
 	unsigned long links = ahvif->links_map;
-	struct ieee80211_vif_cfg *vif_cfg;
 	struct ieee80211_bss_conf *info;
 	struct ath12k_link_vif *arvif;
 	struct ieee80211_sta *sta;
@@ -4203,24 +4147,61 @@ static void ath12k_mac_op_vif_cfg_changed(struct ieee80211_hw *hw,
 			}
 		}
 	}
+}
 
-	if (changed & BSS_CHANGED_PS) {
-		links = ahvif->links_map;
-		vif_cfg = &vif->cfg;
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
 
-		for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
-			arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
-			if (!arvif || !arvif->ar)
-				continue;
+	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
-			ar = arvif->ar;
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	enable_ps = arvif->ahvif->ps;
+	if (enable_ps) {
+		psmode = WMI_STA_PS_MODE_ENABLED;
+		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
-			if (ar->ab->hw_params->supports_sta_ps) {
-				ahvif->ps = vif_cfg->ps;
-				ath12k_mac_vif_setup_ps(arvif);
+		timeout = conf->dynamic_ps_timeout;
+		if (timeout == 0) {
+			info = ath12k_mac_get_link_bss_conf(arvif);
+			if (!info) {
+				ath12k_warn(ar->ab, "unable to access bss link conf in setup ps for vif %pM link %u\n",
+					    vif->addr, arvif->link_id);
+				return;
 			}
+
+			/* firmware doesn't like 0 */
+			timeout = ieee80211_tu_to_usec(info->beacon_int) / 1000;
 		}
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
 	}
+
+	ath12k_dbg(ar->ab, ATH12K_DBG_MAC, "mac vdev %d psmode %s\n",
+		   arvif->vdev_id, psmode ? "enable" : "disable");
+
+	ret = ath12k_wmi_pdev_set_ps_mode(ar, arvif->vdev_id, psmode);
+	if (ret)
+		ath12k_warn(ar->ab, "failed to set sta power save mode %d for vdev %d: %d\n",
+			    psmode, arvif->vdev_id, ret);
 }
 
 static bool ath12k_mac_supports_tpc(struct ath12k *ar, struct ath12k_vif *ahvif,
@@ -4242,6 +4223,7 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 {
 	struct ath12k_vif *ahvif = arvif->ahvif;
 	struct ieee80211_vif *vif = ath12k_ahvif_to_vif(ahvif);
+	struct ieee80211_vif_cfg *vif_cfg = &vif->cfg;
 	struct cfg80211_chan_def def;
 	u32 param_id, param_value;
 	enum nl80211_band band;
@@ -4528,6 +4510,12 @@ static void ath12k_mac_bss_info_changed(struct ath12k *ar,
 	}
 
 	ath12k_mac_fils_discovery(arvif, info);
+
+	if (changed & BSS_CHANGED_PS &&
+	    ar->ab->hw_params->supports_sta_ps) {
+		ahvif->ps = vif_cfg->ps;
+		ath12k_mac_vif_setup_ps(arvif);
+	}
 }
 
 static struct ath12k_vif_cache *ath12k_ahvif_get_link_cache(struct ath12k_vif *ahvif,
-- 
2.51.0



