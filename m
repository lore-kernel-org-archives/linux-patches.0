Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044791;
	b=vvsf4a9mrB3yq1/Vmz/Bd9KhVcZHFwBdxi5wYifOG3Y343RP/CSs0Qdh7Y1bQJd6oS9R
	 1Blz71h9OtqZOBBiDjb8uBMaAwAdBNHMSyOAn4O2HYj7Qgym7e43WfhEZt86nz4LJCZDb
	 33LfoT/1ODzOQvyTUdG/a/21Go8Lf9NS1wyHs+bmwL+BMQXXLocDfX6d62+mA4c//kzoX
	 fzTYBOvt+OgRrqPmpazL2KVdEhG4aPBXeto1jaqQ9Rfg9t5UA1VhPJBWuhkU+YmfIkG9M
	 aFUY7YxJ0hVu35H50RTuU/GYTIV2zWHmTnbmTcwo1w+Eju818zfxSuI4X5RC0Mwwj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FFbZIhqVGBxnV6KLX9A17My7JAXkj/fgp6ph0heDh94=;
	b=fPYxg7Z2diLz1X3pgtKtrlZlqX+PpRdw4227wc3CMekFsZOJNRu06f5tY9GQfShVbxKA
	 iAPm7VPizqLVRVozIsJm5q+Youm1glObIfGhpbbMrLOxwnxPYLOV4UiGK2uBQOS6JXnuY
	 sfBe5JDVhEw9+17l69fR4OZoBetGTL+pdpAfsiEezYuwCxWcahZ3dGpP7PNwjoAsUKAY7
	 h4t4NWyz2Kx1p9cdlmHF7/1tJROZeCSrco1NxDihLZVR2HTAi0VoGrzQe9c4VrhLnE9ee
	 PU+sSdBzTRnTmEnSeMSTSARM16YGGzlP5+bGA7U4DGWCb3uM8mT1LdQ2FiTMXfk6ieQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqr8P+bI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A33A606D67F;
	Wed, 18 Nov 2026 23:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqr8P+bI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3406B1F000C8;
	Wed, 18 Nov 2026 23:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044790;
	bh=FFbZIhqVGBxnV6KLX9A17My7JAXkj/fgp6ph0heDh94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqr8P+bIgjbcWgJgqfJVq5/sz/EXPfHHW8Ckujy5aLXT//2JWMCS5m0zsp1ngxB+g
	 AihFk9YGWT+nGwj2nbKpRobi8fTfUKLm4vIbRctXbmCdmxWdLc7+5CW3aWdBjf16Ey
	 ZJ4ULN/95q27JXkZQ2Xae7tcpdicg42cGfrnpJ1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Peri <eperi1024@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0694/2857] staging: rtl8723bs: Fix indentation in conditional statements
Date: Wed, 18 Nov 2026 15:28:48 +0100
Message-ID: <20261118150226.546797444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Peri <eperi1024@gmail.com>

[ Upstream commit 6e006508f6e20a0f09dd9e64bc23c0592d92cc2d ]

Remove/add tabs in block statements in rtl8723bs/core to fix checkpatch
warnings for suspect code indent for conditionals.

Signed-off-by: Emily Peri <eperi1024@gmail.com>
Link: https://lore.kernel.org/r/Y1cH7br3mMcT4Dm5@marshmallow
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 495cb31c791b ("staging: rtl8723bs: fix protected RX frame validation in decrypt path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c     | 30 +++++++++----------
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |  2 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c     |  6 ++--
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c  |  2 +-
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 258972f6de3fa..58b3dbee58ad5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -389,7 +389,7 @@ int is_same_network(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst, u8 fea
 	__le16 tmps, tmpd;
 
 	if (rtw_bug_check(dst, src, &s_cap, &d_cap) == false)
-			return false;
+		return false;
 
 	memcpy((u8 *)&tmps, rtw_get_capability_from_ie(src->ies), 2);
 	memcpy((u8 *)&tmpd, rtw_get_capability_from_ie(dst->ies), 2);
@@ -669,7 +669,7 @@ int rtw_is_desired_network(struct adapter *adapter, struct wlan_network *pnetwor
 		uint ie_len = 0;
 
 		if ((desired_encmode == Ndis802_11EncryptionDisabled) && (privacy != 0))
-	    bselected = false;
+			bselected = false;
 
 		if (psecuritypriv->ndisauthtype == Ndis802_11AuthModeWPA2PSK) {
 			p = rtw_get_ie(pnetwork->network.ies + _BEACON_IE_OFFSET_, WLAN_EID_RSN, &ie_len, (pnetwork->network.ie_length - _BEACON_IE_OFFSET_));
@@ -795,7 +795,7 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 			pmlmepriv->to_join = false;
 			s_ret = rtw_select_and_join_from_scanned_queue(pmlmepriv);
 			if (s_ret == _SUCCESS) {
-			     _set_timer(&pmlmepriv->assoc_timer, MAX_JOIN_TIMEOUT);
+				_set_timer(&pmlmepriv->assoc_timer, MAX_JOIN_TIMEOUT);
 			} else if (s_ret == 2) {/* there is no need to wait for join */
 				_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING);
 				rtw_indicate_connect(adapter);
@@ -2015,8 +2015,8 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 		    in_ie[i + 3] == 0x50 && in_ie[i + 4] == 0xF2 &&
 		    in_ie[i + 5] == 0x02) {
 			for (j = i; j < i + 9; j++) {
-					out_ie[ielength] = in_ie[j];
-					ielength++;
+				out_ie[ielength] = in_ie[j];
+				ielength++;
 			}
 			out_ie[initial_out_len + 1] = 0x07;
 			out_ie[initial_out_len + 6] = 0x00;
@@ -2072,15 +2072,13 @@ static int rtw_append_pmkid(struct adapter *Adapter, int iEntry, u8 *ie, uint ie
 
 	if (ie[13] <= 20) {
 		/*  The RSN IE didn't include the PMK ID, append the PMK information */
-			ie[ie_len] = 1;
-			ie_len++;
-			ie[ie_len] = 0;	/* PMKID count = 0x0100 */
-			ie_len++;
-			memcpy(&ie[ie_len], &psecuritypriv->PMKIDList[iEntry].PMKID, 16);
-
-			ie_len += 16;
-			ie[13] += 18;/* PMKID length = 2+16 */
-
+		ie[ie_len] = 1;
+		ie_len++;
+		ie[ie_len] = 0;	/* PMKID count = 0x0100 */
+		ie_len++;
+		memcpy(&ie[ie_len], &psecuritypriv->PMKIDList[iEntry].PMKID, 16);
+		ie_len += 16;
+		ie[13] += 18;/* PMKID length = 2+16 */
 	}
 	return ie_len;
 }
@@ -2099,9 +2097,9 @@ signed int rtw_restruct_sec_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, u
 	memcpy(out_ie, in_ie, 12);
 	ielength = 12;
 	if ((ndisauthmode == Ndis802_11AuthModeWPA) || (ndisauthmode == Ndis802_11AuthModeWPAPSK))
-			authmode = WLAN_EID_VENDOR_SPECIFIC;
+		authmode = WLAN_EID_VENDOR_SPECIFIC;
 	if ((ndisauthmode == Ndis802_11AuthModeWPA2) || (ndisauthmode == Ndis802_11AuthModeWPA2PSK))
-			authmode = WLAN_EID_RSN;
+		authmode = WLAN_EID_RSN;
 
 	if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS)) {
 		memcpy(out_ie+ielength, psecuritypriv->wps_ie, psecuritypriv->wps_ie_len);
diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index 32fd3cd0a5f77..e07e797144e3a 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -5482,7 +5482,7 @@ u8 disconnect_hdl(struct adapter *padapter, unsigned char *pbuf)
 	u8 val8;
 
 	if (is_client_associated_to_ap(padapter))
-			issue_deauth_ex(padapter, pnetwork->mac_address, WLAN_REASON_DEAUTH_LEAVING, param->deauth_timeout_ms/100, 100);
+		issue_deauth_ex(padapter, pnetwork->mac_address, WLAN_REASON_DEAUTH_LEAVING, param->deauth_timeout_ms/100, 100);
 
 	if (((pmlmeinfo->state&0x03) == WIFI_FW_ADHOC_STATE) || ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE)) {
 		/* Stop BCN */
diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 2825375bff942..7c7b6495965f5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -161,7 +161,7 @@ int rtw_free_recvframe(union recv_frame *precvframe, struct __queue *pfree_recv_
 
 	if (padapter) {
 		if (pfree_recv_queue == &precvpriv->free_recv_queue)
-				precvpriv->free_recvframe_cnt++;
+			precvpriv->free_recvframe_cnt++;
 	}
 	spin_unlock_bh(&pfree_recv_queue->lock);
 	return _SUCCESS;
@@ -691,8 +691,8 @@ static signed int sta2sta_data_frame(struct adapter *adapter, union recv_frame *
 		if (bmcast) {
 			/*  For AP mode, if DA == MCAST, then BSSID should be also MCAST */
 			if (!IS_MCAST(pattrib->bssid)) {
-					ret = _FAIL;
-					goto exit;
+				ret = _FAIL;
+				goto exit;
 			}
 		} else { /*  not mc-frame */
 			/*  For AP mode, if DA is non-MCAST, then it must be BSSID, and bssid == BSSID */
diff --git a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
index beb11d89db186..c7de81f21bec0 100644
--- a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
@@ -551,7 +551,7 @@ u8 rtw_access_ctrl(struct adapter *padapter, u8 *mac_addr)
 	else if (pacl_list->mode == 2)/* deny unless in accept list */
 		res = match;
 	else
-		 res = true;
+		res = true;
 
 	return res;
 }
-- 
2.53.0



