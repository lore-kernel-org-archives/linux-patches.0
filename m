Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE39415F04;
	Tue, 21 Jul 2026 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664444; cv=none; b=LmL9Uny/8Ql2IMhggBEL4PzlAXgNL0ViwTmA6iPWNAZJ6nA2B7YNecjCrBhcL3kmDkSrNYJppFwIORWEI2vzPsynlb5Bj/ZN8ViTpJqFfLtMnjo9ZzYpfua5LtAB9XSx+5Pa2maSGf+v/LP+NMvNMzWn5tEFa61c4Rz2sCC1Zh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664444; c=relaxed/simple;
	bh=F7QSXcVnRDqyTpO9Akci7e8JTEiAZSqMhST67h+eko8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpMUbSoQmhJm/PiAmSbMTBHIwJgDEFpWF4rYqsRxz5H2zunaHIjXfZqCOjDQ/swXHQvbaJ+lTcjPQVA9Rpz/EavhFeHcKDCReLtPiuyGWQLkLRtLpf1Wi71KCflgE3sL7Lqu6cLQvJUKk84MFxdAMnhkJzybiQZBh0BJWn1I7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOxbbkkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOxbbkkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E11F000E9;
	Tue, 21 Jul 2026 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664443;
	bh=1qkQkhfpgiW7X0VJzhgA4cD4zYKP/l84as1XLxUMgvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOxbbkkcmnzeMjBw86m5VkXOBUou7GbI81fxoN/WAMYvzMsMJLdm46Y1hHlEUQUh7
	 03FVZhBmyfZJmF/Ud02bnzYuy5WLz3lAcCa7gtFlVkz6tIhc28NdUdlMEFHLysc7Ac
	 0JCiRVL8E37hu0N5QJ/fRbviMh0pAKQrBrOTL8T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kulikov <nikolayof23@gmail.com>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1159/1276] staging: rtl8723bs: fix spaces around binary operators
Date: Tue, 21 Jul 2026 17:26:42 +0200
Message-ID: <20260721152511.953187586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kulikov <nikolayof23@gmail.com>

[ Upstream commit 0c9d1b56f9af0762a5be5118e1bb962f23784dc4 ]

Add missing spaces and fix line length to comply with kernel coding
style.

Signed-off-by: Nikolay Kulikov <nikolayof23@gmail.com>
Reviewed-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260221172751.52329-1-nikolayof23@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1463ca3ec660 ("staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   78 +++++++++++++------------
 1 file changed, 42 insertions(+), 36 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -456,10 +456,10 @@ int rtw_parse_wpa_ie(u8 *wpa_ie, int wpa
 		return _FAIL;
 	}
 
-	if ((*wpa_ie != WLAN_EID_VENDOR_SPECIFIC) || (*(wpa_ie+1) != (u8)(wpa_ie_len - 2)) ||
-	   (memcmp(wpa_ie+2, RTW_WPA_OUI_TYPE, WPA_SELECTOR_LEN))) {
+	if ((*wpa_ie != WLAN_EID_VENDOR_SPECIFIC) ||
+	    (*(wpa_ie + 1) != (u8)(wpa_ie_len - 2)) ||
+	    (memcmp(wpa_ie + 2, RTW_WPA_OUI_TYPE, WPA_SELECTOR_LEN)))
 		return _FAIL;
-	}
 
 	pos = wpa_ie;
 
@@ -519,7 +519,7 @@ int rtw_parse_wpa2_ie(u8 *rsn_ie, int rs
 		return _FAIL;
 	}
 
-	if ((*rsn_ie != WLAN_EID_RSN) || (*(rsn_ie+1) != (u8)(rsn_ie_len - 2)))
+	if ((*rsn_ie != WLAN_EID_RSN) || (*(rsn_ie + 1) != (u8)(rsn_ie_len - 2)))
 		return _FAIL;
 
 	pos = rsn_ie;
@@ -587,18 +587,18 @@ int rtw_get_wapi_ie(u8 *in_ie, uint in_l
 	while (cnt < in_len) {
 		authmode = in_ie[cnt];
 
-		/* if (authmode == WLAN_EID_BSS_AC_ACCESS_DELAY) */
-		if (authmode == WLAN_EID_BSS_AC_ACCESS_DELAY && (!memcmp(&in_ie[cnt+6], wapi_oui1, 4) ||
-					!memcmp(&in_ie[cnt+6], wapi_oui2, 4))) {
+		if (authmode == WLAN_EID_BSS_AC_ACCESS_DELAY &&
+		    (!memcmp(&in_ie[cnt + 6], wapi_oui1, 4) ||
+		     !memcmp(&in_ie[cnt + 6], wapi_oui2, 4))) {
 			if (wapi_ie)
-				memcpy(wapi_ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(wapi_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
 
 			if (wapi_len)
-				*wapi_len = in_ie[cnt+1]+2;
+				*wapi_len = in_ie[cnt + 1] + 2;
 
-			cnt += in_ie[cnt+1]+2;  /* get next */
+			cnt += in_ie[cnt + 1] + 2;  /* get next */
 		} else {
-			cnt += in_ie[cnt+1]+2;   /* get next */
+			cnt += in_ie[cnt + 1] + 2;   /* get next */
 		}
 	}
 
@@ -622,9 +622,10 @@ void rtw_get_sec_ie(u8 *in_ie, uint in_l
 	while (cnt < in_len) {
 		authmode = in_ie[cnt];
 
-		if ((authmode == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt+2], &wpa_oui[0], 4))) {
+		if ((authmode == WLAN_EID_VENDOR_SPECIFIC) &&
+		    (!memcmp(&in_ie[cnt + 2], &wpa_oui[0], 4))) {
 			if (wpa_ie)
-				memcpy(wpa_ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(wpa_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
 
 			*wpa_len = in_ie[cnt + 1] + 2;
 			cnt += in_ie[cnt + 1] + 2;  /* get next */
@@ -633,10 +634,10 @@ void rtw_get_sec_ie(u8 *in_ie, uint in_l
 				if (rsn_ie)
 					memcpy(rsn_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
 
-				*rsn_len = in_ie[cnt+1]+2;
-				cnt += in_ie[cnt+1]+2;  /* get next */
+				*rsn_len = in_ie[cnt + 1] + 2;
+				cnt += in_ie[cnt + 1] + 2;  /* get next */
 			} else {
-				cnt += in_ie[cnt+1]+2;   /* get next */
+				cnt += in_ie[cnt + 1] + 2;   /* get next */
 			}
 		}
 	}
@@ -668,20 +669,20 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
 	while (cnt < in_len) {
 		eid = in_ie[cnt];
 
-		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt+2], wps_oui, 4))) {
+		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
 			wpsie_ptr = &in_ie[cnt];
 
 			if (wps_ie)
-				memcpy(wps_ie, &in_ie[cnt], in_ie[cnt+1]+2);
+				memcpy(wps_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
 
 			if (wps_ielen)
-				*wps_ielen = in_ie[cnt+1]+2;
+				*wps_ielen = in_ie[cnt + 1] + 2;
 
-			cnt += in_ie[cnt+1]+2;
+			cnt += in_ie[cnt + 1] + 2;
 
 			break;
 		}
-		cnt += in_ie[cnt+1]+2; /* goto next */
+		cnt += in_ie[cnt + 1] + 2; /* goto next */
 	}
 
 	return wpsie_ptr;
@@ -759,12 +760,12 @@ u8 *rtw_get_wps_attr_content(u8 *wps_ie,
 
 	if (attr_ptr && attr_len) {
 		if (buf_content)
-			memcpy(buf_content, attr_ptr+4, attr_len-4);
+			memcpy(buf_content, attr_ptr + 4, attr_len - 4);
 
 		if (len_content)
-			*len_content = attr_len-4;
+			*len_content = attr_len - 4;
 
-		return attr_ptr+4;
+		return attr_ptr + 4;
 	}
 
 	return NULL;
@@ -1010,20 +1011,25 @@ static int rtw_get_cipher_info(struct wl
 	int group_cipher = 0, pairwise_cipher = 0, is8021x = 0;
 	int ret = _FAIL;
 
-	pbuf = rtw_get_wpa_ie(&pnetwork->network.ies[12], &wpa_ielen, pnetwork->network.ie_length-12);
+	pbuf = rtw_get_wpa_ie(&pnetwork->network.ies[12],
+			      &wpa_ielen,
+			      pnetwork->network.ie_length - 12);
 
 	if (pbuf && (wpa_ielen > 0)) {
-		if (rtw_parse_wpa_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x) == _SUCCESS) {
+		if (rtw_parse_wpa_ie(pbuf, wpa_ielen + 2, &group_cipher,
+				     &pairwise_cipher, &is8021x) == _SUCCESS) {
 			pnetwork->bcn_info.pairwise_cipher = pairwise_cipher;
 			pnetwork->bcn_info.group_cipher = group_cipher;
 			pnetwork->bcn_info.is_8021x = is8021x;
 			ret = _SUCCESS;
 		}
 	} else {
-		pbuf = rtw_get_wpa2_ie(&pnetwork->network.ies[12], &wpa_ielen, pnetwork->network.ie_length-12);
+		pbuf = rtw_get_wpa2_ie(&pnetwork->network.ies[12], &wpa_ielen,
+				       pnetwork->network.ie_length - 12);
 
 		if (pbuf && (wpa_ielen > 0)) {
-			if (rtw_parse_wpa2_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x) == _SUCCESS) {
+			if (rtw_parse_wpa2_ie(pbuf, wpa_ielen + 2, &group_cipher,
+					      &pairwise_cipher, &is8021x) == _SUCCESS) {
 				pnetwork->bcn_info.pairwise_cipher = pairwise_cipher;
 				pnetwork->bcn_info.group_cipher = group_cipher;
 				pnetwork->bcn_info.is_8021x = is8021x;
@@ -1092,21 +1098,21 @@ u16 rtw_mcs_rate(u8 bw_40MHz, u8 short_G
 	u16 max_rate = 0;
 
 	if (MCS_rate[0] & BIT(7))
-		max_rate = (bw_40MHz) ? ((short_GI)?1500:1350):((short_GI)?722:650);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 1500 : 1350) : ((short_GI) ? 722 : 650);
 	else if (MCS_rate[0] & BIT(6))
-		max_rate = (bw_40MHz) ? ((short_GI)?1350:1215):((short_GI)?650:585);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 1350 : 1215) : ((short_GI) ? 650 : 585);
 	else if (MCS_rate[0] & BIT(5))
-		max_rate = (bw_40MHz) ? ((short_GI)?1200:1080):((short_GI)?578:520);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 1200 : 1080) : ((short_GI) ? 578 : 520);
 	else if (MCS_rate[0] & BIT(4))
-		max_rate = (bw_40MHz) ? ((short_GI)?900:810):((short_GI)?433:390);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 900 : 810) : ((short_GI) ? 433 : 390);
 	else if (MCS_rate[0] & BIT(3))
-		max_rate = (bw_40MHz) ? ((short_GI)?600:540):((short_GI)?289:260);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 600 : 540) : ((short_GI) ? 289 : 260);
 	else if (MCS_rate[0] & BIT(2))
-		max_rate = (bw_40MHz) ? ((short_GI)?450:405):((short_GI)?217:195);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 450 : 405) : ((short_GI) ? 217 : 195);
 	else if (MCS_rate[0] & BIT(1))
-		max_rate = (bw_40MHz) ? ((short_GI)?300:270):((short_GI)?144:130);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 300 : 270) : ((short_GI) ? 144 : 130);
 	else if (MCS_rate[0] & BIT(0))
-		max_rate = (bw_40MHz) ? ((short_GI)?150:135):((short_GI)?72:65);
+		max_rate = (bw_40MHz) ? ((short_GI) ? 150 : 135) : ((short_GI) ? 72 : 65);
 
 	return max_rate;
 }


