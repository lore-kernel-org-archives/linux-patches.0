Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAFB385D7B;
	Sat, 17 Oct 2026 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258858; cv=none; b=B3oqmBBcTRMoNqxn1ft85hmkiWyya9p2Prflt5AMYghu7QTmC3ah9a3LMEBO7RvikE3gWTHDc66FqUfRCF0U8IGoJQRxWSZsGBX4m89q/DhoS95OACCGIgh+Y3ZpmqFo7QHWgrAOJBMVfy1I4qjjpUcVgDYU/HuqSuWbvPUV8iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258858; c=relaxed/simple;
	bh=XZJO4htN0hAEqBQCm5STOb7O4t5NNobZ9M3h2jcY+J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyhEzQi/VXOMPFwb3iiYrCymsP7VhmgoicR0xxNi4NwgamxuaJZ/k6jmEl/Ek1LhR0miy/kHUjtOjd8IH3wZnflGAwpZ7mRt2ensL9FtTRzeaxia98ISX9D5FmYb4pbmLWFAB8BvKuUY05Dh0tRX73bZEJPdEfPNPcEEtbzpP6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IplS9YYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IplS9YYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABD91F000C4;
	Sat, 17 Oct 2026 17:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258857;
	bh=74+UI+I6N0o6tACwbDO6N0mceX1cizYv++QCT1gFWi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IplS9YYhyJhV4F4BdTsiGJUEeysDZ8JOtFjnOkZg4u9eqsEhH4EQHvvR7scPhKNtW
	 Cf7/YOsUMGKDwCezjYw8VomPyNo5z/MHfWIHnDRTMZwb1S1gdC0AoBspo3naN4yYgE
	 EJ3pUwXmkz6iQh+0rXwXyP7j8xAc6G9CzaEbUfXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir6264@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1015/1674] Staging: rtl8723bs: Delete dead code from update_current_network()
Date: Sat, 17 Oct 2026 17:54:47 +0200
Message-ID: <20261017160457.185829844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meir Elisha <meir6264@gmail.com>

[ Upstream commit e945c43df60b50bda05800ef83d380ec34e391e2 ]

Remove dead code from rtw_mlme.c in order to improve code readability.

Signed-off-by: Meir Elisha <meir6264@gmail.com>
Link: https://lore.kernel.org/r/20240407123836.115055-1-meir6264@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 514ab9836459 ("staging: rtl8723bs: fix buffer over-read in rtw_update_protection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 92 ++---------------------
 1 file changed, 5 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index b5fb0ad08f384..2422bf30ab757 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -22,7 +22,6 @@ int	rtw_init_mlme_priv(struct adapter *padapter)
 
 	pmlmepriv->pscanned = NULL;
 	pmlmepriv->fw_state = WIFI_STATION_STATE; /*  Must sync with rtw_wdev_alloc() */
-	/*  wdev->iftype = NL80211_IFTYPE_STATION */
 	pmlmepriv->cur_network.network.infrastructure_mode = Ndis802_11AutoUnknown;
 	pmlmepriv->scan_mode = SCAN_ACTIVE;/*  1: active, 0: passive. Maybe someday we should rename this varable to "active_mode" (Jeff) */
 
@@ -109,32 +108,6 @@ void _rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
 	}
 }
 
-/*
-struct	wlan_network *_rtw_dequeue_network(struct __queue *queue)
-{
-	_irqL irqL;
-
-	struct wlan_network *pnetwork;
-
-	spin_lock_bh(&queue->lock);
-
-	if (list_empty(&queue->queue))
-
-		pnetwork = NULL;
-
-	else
-	{
-		pnetwork = container_of(get_next(&queue->queue), struct wlan_network, list);
-
-		list_del_init(&(pnetwork->list));
-	}
-
-	spin_unlock_bh(&queue->lock);
-
-	return pnetwork;
-}
-*/
-
 struct	wlan_network *rtw_alloc_network(struct	mlme_priv *pmlmepriv)
 {
 	struct	wlan_network	*pnetwork;
@@ -207,13 +180,9 @@ void _rtw_free_network_nolock(struct	mlme_priv *pmlmepriv, struct wlan_network *
 	if (pnetwork->fixed)
 		return;
 
-	/* spin_lock_irqsave(&free_queue->lock, irqL); */
-
 	list_del_init(&(pnetwork->list));
 
 	list_add_tail(&(pnetwork->list), get_list_head(free_queue));
-
-	/* spin_unlock_irqrestore(&free_queue->lock, irqL); */
 }
 
 /*
@@ -231,8 +200,6 @@ struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr)
 		goto exit;
 	}
 
-	/* spin_lock_bh(&scanned_queue->lock); */
-
 	phead = get_list_head(scanned_queue);
 	list_for_each(plist, phead) {
 		pnetwork = list_entry(plist, struct wlan_network, list);
@@ -244,8 +211,6 @@ struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr)
 	if (plist == phead)
 		pnetwork = NULL;
 
-	/* spin_unlock_bh(&scanned_queue->lock); */
-
 exit:
 	return pnetwork;
 }
@@ -320,16 +285,6 @@ void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
 	_rtw_free_mlme_priv(pmlmepriv);
 }
 
-/*
-static struct	wlan_network *rtw_dequeue_network(struct __queue *queue)
-{
-	struct wlan_network *pnetwork;
-
-	pnetwork = _rtw_dequeue_network(queue);
-	return pnetwork;
-}
-*/
-
 void rtw_free_network_nolock(struct adapter *padapter, struct wlan_network *pnetwork);
 void rtw_free_network_nolock(struct adapter *padapter, struct wlan_network *pnetwork)
 {
@@ -494,12 +449,9 @@ static void update_current_network(struct adapter *adapter, struct wlan_bssid_ex
 		&(pmlmepriv->cur_network.network));
 
 	if ((check_fwstate(pmlmepriv, _FW_LINKED) == true) && (is_same_network(&(pmlmepriv->cur_network.network), pnetwork, 0))) {
-		/* if (pmlmepriv->cur_network.network.ie_length<= pnetwork->ie_length) */
-		{
-			update_network(&(pmlmepriv->cur_network.network), pnetwork, adapter, true);
-			rtw_update_protection(adapter, (pmlmepriv->cur_network.network.ies) + sizeof(struct ndis_802_11_fix_ie),
-									pmlmepriv->cur_network.network.ie_length);
-		}
+		update_network(&(pmlmepriv->cur_network.network), pnetwork, adapter, true);
+		rtw_update_protection(adapter, (pmlmepriv->cur_network.network.ies) + sizeof(struct ndis_802_11_fix_ie),
+								pmlmepriv->cur_network.network.ie_length);
 	}
 }
 
@@ -540,7 +492,6 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 
 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
-	/* if (phead == plist) { */
 	if (!target_find) {
 		if (list_empty(&pmlmepriv->free_bss_pool.queue)) {
 			/* If there are no more slots, expire the oldest */
@@ -613,15 +564,8 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 void rtw_add_network(struct adapter *adapter, struct wlan_bssid_ex *pnetwork);
 void rtw_add_network(struct adapter *adapter, struct wlan_bssid_ex *pnetwork)
 {
-	/* struct __queue	*queue	= &(pmlmepriv->scanned_queue); */
-
-	/* spin_lock_bh(&queue->lock); */
-
 	update_current_network(adapter, pnetwork);
-
 	rtw_update_scanned_network(adapter, pnetwork);
-
-	/* spin_unlock_bh(&queue->lock); */
 }
 
 /* select the desired network based on the capability of the (i)bss. */
@@ -637,10 +581,7 @@ int rtw_is_desired_network(struct adapter *adapter, struct wlan_network *pnetwor
 	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	u32 desired_encmode;
 	u32 privacy;
-
-	/* u8 wps_ie[512]; */
 	uint wps_ielen;
-
 	int bselected = true;
 
 	desired_encmode = psecuritypriv->ndisencryptstatus;
@@ -1060,9 +1001,8 @@ static struct sta_info *rtw_joinbss_update_stainfo(struct adapter *padapter, str
 			memset((u8 *)&psta->dot11rxpn, 0, sizeof(union pn48));
 		}
 
-		/* 	Commented by Albert 2012/07/21 */
-		/* 	When doing the WPS, the wps_ie_len won't equal to 0 */
-		/* 	And the Wi-Fi driver shouldn't allow the data packet to be transmitted. */
+		/* When doing the WPS, the wps_ie_len won't equal to 0 */
+		/* And the Wi-Fi driver shouldn't allow the data packet to be transmitted. */
 		if (padapter->securitypriv.wps_ie_len != 0) {
 			psta->ieee8021x_blocked = true;
 			padapter->securitypriv.wps_ie_len = 0;
@@ -1072,7 +1012,6 @@ static struct sta_info *rtw_joinbss_update_stainfo(struct adapter *padapter, str
 		/* if A-MPDU Rx is enabled, resetting  rx_ordering_ctrl wstart_b(indicate_seq) to default value = 0xffff */
 		/* todo: check if AP can send A-MPDU packets */
 		for (i = 0; i < 16 ; i++) {
-			/* preorder_ctrl = &precvpriv->recvreorder_ctrl[i]; */
 			preorder_ctrl = &psta->recvreorder_ctrl[i];
 			preorder_ctrl->enable = false;
 			preorder_ctrl->indicate_seq = 0xffff;
@@ -1083,7 +1022,6 @@ static struct sta_info *rtw_joinbss_update_stainfo(struct adapter *padapter, str
 		bmc_sta = rtw_get_bcmc_stainfo(padapter);
 		if (bmc_sta) {
 			for (i = 0; i < 16 ; i++) {
-				/* preorder_ctrl = &precvpriv->recvreorder_ctrl[i]; */
 				preorder_ctrl = &bmc_sta->recvreorder_ctrl[i];
 				preorder_ctrl->enable = false;
 				preorder_ctrl->indicate_seq = 0xffff;
@@ -1247,8 +1185,6 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 		rtw_reset_securitypriv(adapter);
 		_set_timer(&pmlmepriv->assoc_timer, 1);
 
-		/* rtw_free_assoc_resources(adapter, 1); */
-
 		if ((check_fwstate(pmlmepriv, _FW_UNDER_LINKING)) == true)
 			_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING);
 
@@ -1270,7 +1206,6 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 		#endif
 
 			_set_timer(&pmlmepriv->assoc_timer, 1);
-			/* rtw_free_assoc_resources(adapter, 1); */
 			_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING);
 
 		#ifdef REJOIN
@@ -1365,7 +1300,6 @@ void rtw_stassoc_event_callback(struct adapter *adapter, u8 *pbuf)
 	/* to do : init sta_info variable */
 	psta->qos_option = 0;
 	psta->mac_id = (uint)pstassoc->cam_id;
-	/* psta->aid = (uint)pstassoc->cam_id; */
 
 	/* for ad-hoc mode */
 	rtw_hal_set_odm_var(adapter, HAL_ODM_STA_INFO, psta, true);
@@ -1480,10 +1414,8 @@ void rtw_stadel_event_callback(struct adapter *adapter, u8 *pbuf)
 
 		if (adapter->stapriv.asoc_sta_count == 1) {/* a sta + bc/mc_stainfo (not Ibss_stainfo) */
 			u8 ret = _SUCCESS;
-			/* rtw_indicate_disconnect(adapter);removed@20091105 */
 			spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
 			/* free old ibss network */
-			/* pwlan = rtw_find_network(&pmlmepriv->scanned_queue, pstadel->macaddr); */
 			pwlan = rtw_find_network(&pmlmepriv->scanned_queue, tgt_network->network.mac_address);
 			if (pwlan) {
 				pwlan->fixed = false;
@@ -2102,14 +2034,6 @@ signed int rtw_restruct_sec_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, u
 	} else if ((authmode == WLAN_EID_VENDOR_SPECIFIC) || (authmode == WLAN_EID_RSN)) {
 		/* copy RSN or SSN */
 		memcpy(&out_ie[ielength], &psecuritypriv->supplicant_ie[0], psecuritypriv->supplicant_ie[1]+2);
-		/* debug for CONFIG_IEEE80211W
-		{
-			int jj;
-			printk("supplicant_ie_length =%d &&&&&&&&&&&&&&&&&&&\n", psecuritypriv->supplicant_ie[1]+2);
-			for (jj = 0; jj < psecuritypriv->supplicant_ie[1]+2; jj++)
-				printk(" %02x ", psecuritypriv->supplicant_ie[jj]);
-			printk("\n");
-		}*/
 		ielength += psecuritypriv->supplicant_ie[1]+2;
 		rtw_report_sec_ie(adapter, authmode, psecuritypriv->supplicant_ie);
 	}
@@ -2146,7 +2070,6 @@ void rtw_update_registrypriv_dev_network(struct adapter *adapter)
 	struct wlan_bssid_ex    *pdev_network = &pregistrypriv->dev_network;
 	struct	security_priv *psecuritypriv = &adapter->securitypriv;
 	struct	wlan_network	*cur_network = &adapter->mlmepriv.cur_network;
-	/* struct	xmit_priv *pxmitpriv = &adapter->xmitpriv; */
 
 	pdev_network->privacy = (psecuritypriv->dot11PrivacyAlgrthm > 0 ? 1 : 0) ; /*  adhoc no 802.1x */
 
@@ -2395,7 +2318,6 @@ unsigned int rtw_restructure_ht_ie(struct adapter *padapter, u8 *in_ie, u8 *out_
 		rtw_hal_get_def_var(padapter, HW_VAR_MAX_RX_AMPDU_FACTOR,
 				    &max_rx_ampdu_factor);
 
-	/* rtw_hal_get_def_var(padapter, HW_VAR_MAX_RX_AMPDU_FACTOR, &max_rx_ampdu_factor); */
 	ht_capie.ampdu_params_info = (max_rx_ampdu_factor&0x03);
 
 	if (padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)
@@ -2425,14 +2347,10 @@ void rtw_update_ht_cap(struct adapter *padapter, u8 *pie, uint ie_len, u8 channe
 {
 	u8 *p, max_ampdu_sz;
 	int len;
-	/* struct sta_info *bmc_sta, *psta; */
 	struct ieee80211_ht_cap *pht_capie;
-	/* struct recv_reorder_ctrl *preorder_ctrl; */
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ht_priv 	*phtpriv = &pmlmepriv->htpriv;
-	/* struct recv_priv *precvpriv = &padapter->recvpriv; */
 	struct registry_priv *pregistrypriv = &padapter->registrypriv;
-	/* struct wlan_network *pcur_network = &(pmlmepriv->cur_network);; */
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info *pmlmeinfo = &(pmlmeext->mlmext_info);
 	u8 cbw40_enable = 0;
-- 
2.53.0



