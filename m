Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705095;
	b=BcGC5wH+dWbJ297rI26x6Yg5VZTmHCkFqXFySfvQAvfV6vUX8TljPJNQf70C9ako7NGr
	 odFzDS0/c/yzKqgtOGcSqigjn2bEfWmhYOUFwd2J0Hxdv/E7OycGh0cuPYPcAmI1SqRnN
	 0t2Hx9gx4SJet30DWyZseyBZc1ynMG/qrsTfgpzPjY2l+InRVO9lIwAeQfkhciO3t3yZR
	 Tyot0zjgsxGtkpIQKNOHyPFoqDTCmroGhDw8XAbsnGgmX7mxG4cPqVWc4CeDRAHjlyM9B
	 6jkIHdBIajAgG3V+4d+1W/lHZRNvR5r7tjPVU9JNmVfEKo/pHI2o08WCAzeZF+ss5Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OabFvHwriNHmgxa9cLGKuDQs1lp1SBZ4OtkqKGRnksM=;
	b=08CkryFB2lEHdNXtNLnq3PYgTMFHMDs/Uv2mwGXdh2SoRYdS2sOCdnwLwS4jkrobfa+c
	 Q67cmt51FNmKcK6+IoWQvdH6mtujch2Uub5acvU3fKsMeXjlRn03Q7AM/xMahwhJLKMdo
	 F6eV/VmgTk8838blJsUXAwXRy6zJ8xsa23RUeoXlcRlhbaUoN1fcN7Kkz8CzpPDtNC+cG
	 deEwO9uwL7EX0odTlDpXxaqQLpklUnmuEJvFERi5q6ns0reHnEx8FdpdiekpVHZA/fcXI
	 RVTqDyEqivFynWx9WZvhA9uhLzFmNtquBvkp3NDexCAsqU4N/38ipDPzbuQEDT9PzUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZlUascN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A62606A335;
	Thu, 26 Nov 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZlUascN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8D41F000CA;
	Thu, 26 Nov 2026 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705095;
	bh=OabFvHwriNHmgxa9cLGKuDQs1lp1SBZ4OtkqKGRnksM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZlUascNegv4s6dQug/Uye/XlJLrRbAinS89GVGKZJmZ0XxOr9aAakuMfKv4AyjOH
	 zw9xhUA8xxjHeB60ST/MOww+gm43bQqyNowz734+eZyekBWTRWihNoN+Dz2qExowvT
	 pW6PmNkxDCpCvyCr4aou+LdHgLW6hoyfxainnDMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Old=C5=99ich=20Jedli=C4=8Dka?= <oldium.pro@gmail.com>,
	Edward Matijevic <motolav@gmail.com>,
	Zhijun You <hujy652@gmail.com>
Subject: [PATCH 5.15 026/319] ath10k: add encapsulation offloading support
Date: Thu, 26 Nov 2026 15:36:34 +0100
Message-ID: <20261126144007.331844209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Ryazanov <ryazanov.s.a@gmail.com>

[ Upstream commit af6d8265c47e46881b80c6b073f53c8c4af52d28 ]

Frame encapsulation from Ethernet into the IEEE 802.11 frame format
takes a considerable host CPU time on the xmit path. The firmware is
able to do this operation for us, so enable encapsulation offloading for
AP and Sta interface types to improve overall system performance.

The driver is almost ready for encapsulation offloading support. There
are only a few places where the driver assumes the frame format is IEEE
802.11 that need to be fixed.

Encapsulation offloading is currently disabled by default and the driver
utilizes mac80211 encapsulation support. To activate offloading, the
frame_mode=2 parameter should be passed during module loading.

On a QCA9563+QCA9888-based access point in bridged mode, encapsulation
offloading increases TCP 16-streams DL throughput from 365 to 396 mbps
(+8%) and UDP DL throughput from 436 to 483 mbps (+11%).

Tested-on: QCA9888 hw2.0 PCI 10.4-3.9.0.2-00131
Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00157-QCARMSWPZ-1
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Tested-by: Oldřich Jedlička <oldium.pro@gmail.com> # TP-Link Archer C7 v4 & v5 (QCA9563 + QCA9880)
Tested-by: Edward Matijevic <motolav@gmail.com> # TP-Link Archer C2600 (IPQ8064 + QCA9980 10.4.1.00030-1)
Tested-by: Edward Matijevic <motolav@gmail.com> # QCA9377 PCI in Sta mode
Tested-by: Zhijun You <hujy652@gmail.com> # NETGEAR R7800 (QCA9984 10.4-3.9.0.2-00159)
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220516032519.29831-5-ryazanov.s.a@gmail.com
Stable-dep-of: 2a87e367c628 ("wifi: ath10k: Stop unanswered temperature reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 67 +++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0a8fc3cd74038..4ffb9b0adc586 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
 MODULE_PARM_DESC(cryptmode, "Crypto mode: 0-hardware, 1-software");
 MODULE_PARM_DESC(frame_mode,
-		 "Datapath frame mode (0: raw, 1: native wifi (default))");
+		 "Datapath frame mode (0: raw, 1: native wifi (default), 2: ethernet)");
 MODULE_PARM_DESC(coredump_mask, "Bitfield of what to include in firmware crash file");
 MODULE_PARM_DESC(fw_diag_log, "Diag based fw log debugging");
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d90909ffa6780..5d0aff78fd6bd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3725,6 +3725,9 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	const struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 
+	if (IEEE80211_SKB_CB(skb)->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return ATH10K_HW_TXRX_ETHERNET;
+
 	if (!vif || vif->type == NL80211_IFTYPE_MONITOR)
 		return ATH10K_HW_TXRX_RAW;
 
@@ -3885,6 +3888,12 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 	bool noack = false;
 
 	cb->flags = 0;
+
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
+		cb->flags |= ATH10K_SKB_F_QOS;	/* Assume data frames are QoS */
+		goto finish_cb_fill;
+	}
+
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
 		cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
 
@@ -3923,6 +3932,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 		cb->flags |= ATH10K_SKB_F_RAW_TX;
 	}
 
+finish_cb_fill:
 	cb->vif = vif;
 	cb->txq = txq;
 	cb->airtime_est = airtime;
@@ -4046,7 +4056,11 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		ath10k_tx_h_seq_no(vif, skb);
 		break;
 	case ATH10K_HW_TXRX_ETHERNET:
-		ath10k_tx_h_8023(skb);
+		/* Convert 802.11->802.3 header only if the frame was erlier
+		 * encapsulated to 802.11 by mac80211. Otherwise pass it as is.
+		 */
+		if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP))
+			ath10k_tx_h_8023(skb);
 		break;
 	case ATH10K_HW_TXRX_RAW:
 		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags) &&
@@ -4658,12 +4672,10 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_txq *txq = NULL;
-	struct ieee80211_hdr *hdr = (void *)skb->data;
 	enum ath10k_hw_txrx_mode txmode;
 	enum ath10k_mac_tx_path txpath;
 	bool is_htt;
 	bool is_mgmt;
-	bool is_presp;
 	int ret;
 	u16 airtime;
 
@@ -4677,8 +4689,14 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	is_mgmt = (txpath == ATH10K_MAC_TX_HTT_MGMT);
 
 	if (is_htt) {
+		bool is_presp = false;
+
 		spin_lock_bh(&ar->htt.tx_lock);
-		is_presp = ieee80211_is_probe_resp(hdr->frame_control);
+		if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
+			struct ieee80211_hdr *hdr = (void *)skb->data;
+
+			is_presp = ieee80211_is_probe_resp(hdr->frame_control);
+		}
 
 		ret = ath10k_htt_tx_inc_pending(htt);
 		if (ret) {
@@ -5478,6 +5496,30 @@ static int ath10k_mac_set_txbf_conf(struct ath10k_vif *arvif)
 					 ar->wmi.vdev_param->txbf, value);
 }
 
+static void ath10k_update_vif_offload(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif)
+{
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	struct ath10k *ar = hw->priv;
+	u32 vdev_param;
+	int ret;
+
+	if (ath10k_frame_mode != ATH10K_HW_TXRX_ETHERNET ||
+	    ar->wmi.vdev_param->tx_encap_type == WMI_VDEV_PARAM_UNSUPPORTED ||
+	     (vif->type != NL80211_IFTYPE_STATION &&
+	      vif->type != NL80211_IFTYPE_AP))
+		vif->offload_flags &= ~IEEE80211_OFFLOAD_ENCAP_ENABLED;
+
+	vdev_param = ar->wmi.vdev_param->tx_encap_type;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+					ATH10K_HW_TXRX_NATIVE_WIFI);
+	/* 10.X firmware does not support this VDEV parameter. Do not warn */
+	if (ret && ret != -EOPNOTSUPP) {
+		ath10k_warn(ar, "failed to set vdev %i TX encapsulation: %d\n",
+			    arvif->vdev_id, ret);
+	}
+}
+
 /*
  * TODO:
  * Figure out how to handle WMI_VDEV_SUBTYPE_P2P_DEVICE,
@@ -5687,15 +5729,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	arvif->def_wep_key_idx = -1;
 
-	vdev_param = ar->wmi.vdev_param->tx_encap_type;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-					ATH10K_HW_TXRX_NATIVE_WIFI);
-	/* 10.X firmware does not support this VDEV parameter. Do not warn */
-	if (ret && ret != -EOPNOTSUPP) {
-		ath10k_warn(ar, "failed to set vdev %i TX encapsulation: %d\n",
-			    arvif->vdev_id, ret);
-		goto err_vdev_delete;
-	}
+	ath10k_update_vif_offload(hw, vif);
 
 	/* Configuring number of spatial stream for monitor interface is causing
 	 * target assert in qca9888 and qca6174.
@@ -9380,6 +9414,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.stop				= ath10k_stop,
 	.config				= ath10k_config,
 	.add_interface			= ath10k_add_interface,
+	.update_vif_offload		= ath10k_update_vif_offload,
 	.remove_interface		= ath10k_remove_interface,
 	.configure_filter		= ath10k_configure_filter,
 	.bss_info_changed		= ath10k_bss_info_changed,
@@ -10049,6 +10084,12 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
 		ieee80211_hw_set(ar->hw, SUPPORTS_TDLS_BUFFER_STA);
 
+	if (ath10k_frame_mode == ATH10K_HW_TXRX_ETHERNET) {
+		if (ar->wmi.vdev_param->tx_encap_type !=
+		    WMI_VDEV_PARAM_UNSUPPORTED)
+			ieee80211_hw_set(ar->hw, SUPPORTS_TX_ENCAP_OFFLOAD);
+	}
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
-- 
2.53.0



