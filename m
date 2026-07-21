Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4859E43F08A;
	Tue, 21 Jul 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672784; cv=none; b=ZEc62KuZFTZN9s1lYMP4cHmDaQdh1AuBCeF00jEvz9W1jtzkMCstVMrpwcDAJM0nlJiHH7Qp+A5vfWv79sPIoT5Pods7/AhNjjZ65dlOgvw6rvHn7TkKGGHUYTrYYKv6sghrggiOcbNTvt3uojbo9CDCHArW9t14DmZ0zBu0+u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672784; c=relaxed/simple;
	bh=OYqpuPuj3zIiHS+vq48r6Qy359j39Av8acFc1rjV2go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B226q3h4U3o0l2fxxDkaugrVqZjLDXHE9aGAmBH2NzkKLuso6aRz66YDJ46kIZ/oGdp1AQnQGXvwEvDDkfKkyLji9GxzmHX4uvO5boxu9QfHlPB9SN6LhitUf2rPvpqZVAw3qU01LsNpkSZkbPrp+21+esmvGCNM1A/C7+0Y+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KS95Rc10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KS95Rc10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7B81F000E9;
	Tue, 21 Jul 2026 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672783;
	bh=4+22Wss+XsGieX3olPORcnHuyT3O7ObfLVHZjhFrWTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KS95Rc10roQ7dh4z/dlK3CZy2j9rGssTeTfvqtxjTPV3iwnQQufzhal5+DLoGQ+AB
	 GMgEO2QVMprWaaYl/APvGDVQRpsywRSq1k/Bg7QhkwQEI9FvPCLp1gm00SelKjvZjk
	 c/p9ZatioaapeNKLFlKqpTW03j/IJcMYNFChqgqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franziska Naepelt <franziska.naepelt@googlemail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 754/843] staging: rtl8723bs: Fix space issues
Date: Tue, 21 Jul 2026 17:26:29 +0200
Message-ID: <20260721152423.012915937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franziska Naepelt <franziska.naepelt@googlemail.com>

[ Upstream commit c4b811b9361b0d7ea167a79587f5ec0a13fd8863 ]

Fix the following checkpatch space issues:
- CHECK: spaces preferred around that '*' (ctx:VxV)
- CHECK: spaces preferred around that '+' (ctx:VxV)
- CHECK: spaces preferred around that '-' (ctx:VxV)
- CHECK: spaces preferred around that '|' (ctx:VxV)
- CHECK: No space is necessary after a cast
- WARNING: please, no spaces at the start of a line

Signed-off-by: Franziska Naepelt <franziska.naepelt@googlemail.com>
Link: https://lore.kernel.org/r/20230701102538.5359-1-franziska.naepelt@googlemail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5a752a616e75 ("staging: rtl8723bs: fix heap buffer overflow in rtw_cfg80211_set_wpa_ie()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   76 +++++++++++-----------
 1 file changed, 38 insertions(+), 38 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -95,14 +95,14 @@ static struct ieee80211_channel rtw_2ghz
 static void rtw_2g_channels_init(struct ieee80211_channel *channels)
 {
 	memcpy((void *)channels, (void *)rtw_2ghz_channels,
-		sizeof(struct ieee80211_channel)*RTW_2G_CHANNELS_NUM
+		sizeof(struct ieee80211_channel) * RTW_2G_CHANNELS_NUM
 	);
 }
 
 static void rtw_2g_rates_init(struct ieee80211_rate *rates)
 {
 	memcpy(rates, rtw_g_rates,
-		sizeof(struct ieee80211_rate)*RTW_G_RATES_NUM
+		sizeof(struct ieee80211_rate) * RTW_G_RATES_NUM
 	);
 }
 
@@ -126,8 +126,8 @@ static struct ieee80211_supported_band *
 	if (!spt_band)
 		goto exit;
 
-	spt_band->channels = (struct ieee80211_channel *)(((u8 *)spt_band)+sizeof(struct ieee80211_supported_band));
-	spt_band->bitrates = (struct ieee80211_rate *)(((u8 *)spt_band->channels)+sizeof(struct ieee80211_channel)*n_channels);
+	spt_band->channels = (struct ieee80211_channel *)(((u8 *)spt_band) + sizeof(struct ieee80211_supported_band));
+	spt_band->bitrates = (struct ieee80211_rate *)(((u8 *)spt_band->channels) + sizeof(struct ieee80211_channel) * n_channels);
 	spt_band->band = band;
 	spt_band->n_channels = n_channels;
 	spt_band->n_bitrates = n_bitrates;
@@ -247,10 +247,10 @@ struct cfg80211_bss *rtw_cfg80211_inform
 		u32 wpsielen = 0;
 		u8 *wpsie = NULL;
 
-		wpsie = rtw_get_wps_ie(pnetwork->network.ies+_FIXED_IE_LENGTH_, pnetwork->network.ie_length-_FIXED_IE_LENGTH_, NULL, &wpsielen);
+		wpsie = rtw_get_wps_ie(pnetwork->network.ies + _FIXED_IE_LENGTH_, pnetwork->network.ie_length - _FIXED_IE_LENGTH_, NULL, &wpsielen);
 
 		if (wpsie && wpsielen > 0)
-			psr = rtw_get_wps_attr_content(wpsie,  wpsielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
+			psr = rtw_get_wps_attr_content(wpsie, wpsielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
 
 		if (sr != 0) {
 			/* it means under processing WPS */
@@ -277,9 +277,9 @@ struct cfg80211_bss *rtw_cfg80211_inform
 	/* We've set wiphy's signal_type as CFG80211_SIGNAL_TYPE_MBM: signal strength in mBm (100*dBm) */
 	if (check_fwstate(pmlmepriv, _FW_LINKED) == true &&
 		is_same_network(&pmlmepriv->cur_network.network, &pnetwork->network, 0)) {
-		notify_signal = 100*translate_percentage_to_dbm(padapter->recvpriv.signal_strength);/* dbm */
+		notify_signal = 100 * translate_percentage_to_dbm(padapter->recvpriv.signal_strength);/* dbm */
 	} else {
-		notify_signal = 100*translate_percentage_to_dbm(pnetwork->network.phy_info.signal_strength);/* dbm */
+		notify_signal = 100 * translate_percentage_to_dbm(pnetwork->network.phy_info.signal_strength);/* dbm */
 	}
 
 	buf = kzalloc(MAX_BSSINFO_LEN, GFP_ATOMIC);
@@ -453,20 +453,20 @@ check_bss:
 		roam_info.channel = notify_channel;
 		roam_info.bssid = cur_network->network.mac_address;
 		roam_info.req_ie =
-			pmlmepriv->assoc_req+sizeof(struct ieee80211_hdr_3addr)+2;
+			pmlmepriv->assoc_req + sizeof(struct ieee80211_hdr_3addr) + 2;
 		roam_info.req_ie_len =
-			pmlmepriv->assoc_req_len-sizeof(struct ieee80211_hdr_3addr)-2;
+			pmlmepriv->assoc_req_len - sizeof(struct ieee80211_hdr_3addr) - 2;
 		roam_info.resp_ie =
-			pmlmepriv->assoc_rsp+sizeof(struct ieee80211_hdr_3addr)+6;
+			pmlmepriv->assoc_rsp + sizeof(struct ieee80211_hdr_3addr) + 6;
 		roam_info.resp_ie_len =
-			pmlmepriv->assoc_rsp_len-sizeof(struct ieee80211_hdr_3addr)-6;
+			pmlmepriv->assoc_rsp_len - sizeof(struct ieee80211_hdr_3addr) - 6;
 		cfg80211_roamed(padapter->pnetdev, &roam_info, GFP_ATOMIC);
 	} else {
 		cfg80211_connect_result(padapter->pnetdev, cur_network->network.mac_address
-			, pmlmepriv->assoc_req+sizeof(struct ieee80211_hdr_3addr)+2
-			, pmlmepriv->assoc_req_len-sizeof(struct ieee80211_hdr_3addr)-2
-			, pmlmepriv->assoc_rsp+sizeof(struct ieee80211_hdr_3addr)+6
-			, pmlmepriv->assoc_rsp_len-sizeof(struct ieee80211_hdr_3addr)-6
+			, pmlmepriv->assoc_req + sizeof(struct ieee80211_hdr_3addr) + 2
+			, pmlmepriv->assoc_req_len - sizeof(struct ieee80211_hdr_3addr) - 2
+			, pmlmepriv->assoc_rsp + sizeof(struct ieee80211_hdr_3addr) + 6
+			, pmlmepriv->assoc_rsp_len - sizeof(struct ieee80211_hdr_3addr) - 6
 			, WLAN_STATUS_SUCCESS, GFP_ATOMIC);
 	}
 }
@@ -721,7 +721,7 @@ static int rtw_cfg80211_set_encryption(s
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
 
-	if (param_len < (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len) {
+	if (param_len < (u32)((u8 *)param->u.crypt.key - (u8 *)param) + param->u.crypt.key_len) {
 		ret =  -EINVAL;
 		goto exit;
 	}
@@ -1035,10 +1035,10 @@ static int cfg80211_rtw_get_station(stru
 	}
 
 	/* for Ad-Hoc/AP mode */
-	if ((check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)
- || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE)
- || check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		&& check_fwstate(pmlmepriv, _FW_LINKED)) {
+	if ((check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) ||
+	     check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) ||
+	     check_fwstate(pmlmepriv, WIFI_AP_STATE)) &&
+	    check_fwstate(pmlmepriv, _FW_LINKED)) {
 		/* TODO: should acquire station info... */
 	}
 
@@ -1237,7 +1237,7 @@ static int cfg80211_rtw_scan(struct wiph
 	spin_unlock_bh(&pwdev_priv->scan_req_lock);
 
 	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
-		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS|_FW_UNDER_SURVEY|_FW_UNDER_LINKING) == true) {
+		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS | _FW_UNDER_SURVEY | _FW_UNDER_LINKING) == true) {
 			need_indicate_scan_done = true;
 			goto check_need_indicate_scan_done;
 		}
@@ -1291,7 +1291,7 @@ static int cfg80211_rtw_scan(struct wiph
 	}
 
 	/* parsing channels, n_channels */
-	memset(ch, 0, sizeof(struct rtw_ieee80211_channel)*RTW_CHANNEL_SCAN_AMOUNT);
+	memset(ch, 0, sizeof(struct rtw_ieee80211_channel) * RTW_CHANNEL_SCAN_AMOUNT);
 	for (i = 0; i < request->n_channels && i < RTW_CHANNEL_SCAN_AMOUNT; i++) {
 		ch[i].hw_value = request->channels[i]->hw_value;
 		ch[i].flags = request->channels[i]->flags;
@@ -1305,7 +1305,7 @@ static int cfg80211_rtw_scan(struct wiph
 	} else if (request->n_channels <= 4) {
 		for (j = request->n_channels - 1; j >= 0; j--)
 			for (i = 0; i < survey_times; i++)
-				memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
+				memcpy(&ch[j * survey_times + i], &ch[j], sizeof(struct rtw_ieee80211_channel));
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, ch, survey_times * request->n_channels);
 	} else {
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, NULL, 0);
@@ -1461,7 +1461,7 @@ static int rtw_cfg80211_set_wpa_ie(struc
 		goto exit;
 	}
 
-	if (ielen > MAX_WPA_IE_LEN+MAX_WPS_IE_LEN+MAX_P2P_IE_LEN) {
+	if (ielen > MAX_WPA_IE_LEN + MAX_WPS_IE_LEN + MAX_P2P_IE_LEN) {
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -1481,19 +1481,19 @@ static int rtw_cfg80211_set_wpa_ie(struc
 
 	pwpa = rtw_get_wpa_ie(buf, &wpa_ielen, ielen);
 	if (pwpa && wpa_ielen > 0) {
-		if (rtw_parse_wpa_ie(pwpa, wpa_ielen+2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
+		if (rtw_parse_wpa_ie(pwpa, wpa_ielen + 2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
 			padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X;
 			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPAPSK;
-			memcpy(padapter->securitypriv.supplicant_ie, &pwpa[0], wpa_ielen+2);
+			memcpy(padapter->securitypriv.supplicant_ie, &pwpa[0], wpa_ielen + 2);
 		}
 	}
 
 	pwpa2 = rtw_get_wpa2_ie(buf, &wpa2_ielen, ielen);
 	if (pwpa2 && wpa2_ielen > 0) {
-		if (rtw_parse_wpa2_ie(pwpa2, wpa2_ielen+2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
+		if (rtw_parse_wpa2_ie(pwpa2, wpa2_ielen + 2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
 			padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X;
 			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPA2PSK;
-			memcpy(padapter->securitypriv.supplicant_ie, &pwpa2[0], wpa2_ielen+2);
+			memcpy(padapter->securitypriv.supplicant_ie, &pwpa2[0], wpa2_ielen + 2);
 		}
 	}
 
@@ -1891,7 +1891,7 @@ static int cfg80211_rtw_set_pmksa(struct
 
 			memcpy(psecuritypriv->PMKIDList[index].PMKID, (u8 *)pmksa->pmkid, WLAN_PMKID_LEN);
 			psecuritypriv->PMKIDList[index].bUsed = true;
-			psecuritypriv->PMKIDIndex = index+1;
+			psecuritypriv->PMKIDIndex = index + 1;
 			blInserted = true;
 			break;
 		}
@@ -2090,8 +2090,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 		/* Use the real net device to transmit the packet */
 		return _rtw_xmit_entry(skb, padapter->pnetdev);
 
-	} else if ((frame_control & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE)) ==
-		   (IEEE80211_FTYPE_MGMT|IEEE80211_STYPE_ACTION)) {
+	} else if ((frame_control & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+		   (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION)) {
 		/* only for action frames */
 		struct xmit_frame		*pmgntframe;
 		struct pkt_attrib	*pattrib;
@@ -2205,7 +2205,7 @@ static int rtw_cfg80211_add_monitor_if(s
 		goto out;
 
 	*ndev = pwdev_priv->pmon_ndev = mon_ndev;
-	memcpy(pwdev_priv->ifname_mon, name, IFNAMSIZ+1);
+	memcpy(pwdev_priv->ifname_mon, name, IFNAMSIZ + 1);
 
 out:
 	if (ret && mon_wdev) {
@@ -2299,14 +2299,14 @@ static int rtw_add_beacon(struct adapter
 	if (head_len < 24)
 		return -EINVAL;
 
-	pbuf = rtw_zmalloc(head_len+tail_len);
+	pbuf = rtw_zmalloc(head_len + tail_len);
 	if (!pbuf)
 		return -ENOMEM;
 
-	memcpy(pbuf, (void *)head+24, head_len-24);/*  24 =beacon header len. */
-	memcpy(pbuf+head_len-24, (void *)tail, tail_len);
+	memcpy(pbuf, (void *)head + 24, head_len - 24);/*  24 =beacon header len. */
+	memcpy(pbuf + head_len - 24, (void *)tail, tail_len);
 
-	len = head_len+tail_len-24;
+	len = head_len + tail_len - 24;
 
 	/* check wps ie if inclued */
 	rtw_get_wps_ie(pbuf + _FIXED_IE_LENGTH_, len - _FIXED_IE_LENGTH_, NULL, &wps_ielen);
@@ -2595,7 +2595,7 @@ static int cfg80211_rtw_mgmt_tx(struct w
 	pwdev_priv = adapter_wdev_data(padapter);
 
 	/* cookie generation */
-	*cookie = (unsigned long) buf;
+	*cookie = (unsigned long)buf;
 
 	/* indicate ack before issue frame to avoid racing with rsp frame */
 	rtw_cfg80211_mgmt_tx_status(padapter, *cookie, buf, len, ack, GFP_KERNEL);


