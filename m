Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA942DFEC;
	Tue, 21 Jul 2026 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670530; cv=none; b=SsRJk1w91coo3M6IZwfwE5icx3IXFZXcTpJth8yn+GjdafusRMJ2/j1RzRJONzz5KQr78J0aglTLrJ/iscFuVrpd5EDe4aLexx+ETf4tRBTO6z1bNYClG6JCbnfJgXRE15v6KnGHVvTnptXx2Ob7+m6/+LlqT6VzpEftAiFvPCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670530; c=relaxed/simple;
	bh=VTDtOcrZ4fFyvxXmqSKbczMB/600hZf0p6iZT9KFhTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0vQPGGavfxsMwTE2KTtylkPy5ip1gTNcMot5XQl4IJNOi92QP9DyoJdIqAiJgeXF5zNaBNMXpaoiW4SQQ36jT+RMpdTr0v47vg8Av+AoQ3/NjjgFW/dWXyrdWFA2BIiXMF0iBHZQ0iU6XuXsaKZsOLVIM/5G+g0b6UTs9raDog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8eQ6V7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8eQ6V7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8E21F000E9;
	Tue, 21 Jul 2026 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670529;
	bh=ChhEETSO6zQIm7azkGvioD5H0qtl3eYxYueBO52lVGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8eQ6V7ijPAh2KN17nHV0+NV/kckkJ6liNxX/T8e9PD+0lkB0XGO7TbxLscQVj47G
	 t0yzqJmr3ct+XbCht8SKotuBKLHlXnOS5Avvg0wdYzj+iOIEplqZA7O6h4uh11A3qf
	 OYJETjey+IH+IKO0CriE3+3FlONKpC/HwWvANnns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0966/1067] staging: rtl8723bs: core: move constants to right side in comparison
Date: Tue, 21 Jul 2026 17:26:07 +0200
Message-ID: <20260721152446.148952762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Hansen-Baird <william.hansen.baird@gmail.com>

[ Upstream commit cf0f2680c30d4b438a5e84b73dc70be405936b54 ]

Move constants to right side in if-statement conditions.

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Link: https://patch.msgid.link/20251224100329.762141-3-william.hansen.baird@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1463ca3ec660 ("staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    4 ++--
 drivers/staging/rtl8723bs/core/rtw_security.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -1012,7 +1012,7 @@ static int rtw_get_cipher_info(struct wl
 	pbuf = rtw_get_wpa_ie(&pnetwork->network.ies[12], &wpa_ielen, pnetwork->network.ie_length-12);
 
 	if (pbuf && (wpa_ielen > 0)) {
-		if (_SUCCESS == rtw_parse_wpa_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x)) {
+		if (rtw_parse_wpa_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x) == _SUCCESS) {
 			pnetwork->bcn_info.pairwise_cipher = pairwise_cipher;
 			pnetwork->bcn_info.group_cipher = group_cipher;
 			pnetwork->bcn_info.is_8021x = is8021x;
@@ -1022,7 +1022,7 @@ static int rtw_get_cipher_info(struct wl
 		pbuf = rtw_get_wpa2_ie(&pnetwork->network.ies[12], &wpa_ielen, pnetwork->network.ie_length-12);
 
 		if (pbuf && (wpa_ielen > 0)) {
-			if (_SUCCESS == rtw_parse_wpa2_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x)) {
+			if (rtw_parse_wpa2_ie(pbuf, wpa_ielen+2, &group_cipher, &pairwise_cipher, &is8021x) == _SUCCESS) {
 				pnetwork->bcn_info.pairwise_cipher = pairwise_cipher;
 				pnetwork->bcn_info.group_cipher = group_cipher;
 				pnetwork->bcn_info.is_8021x = is8021x;
--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -1538,7 +1538,7 @@ void rtw_sec_restore_wep_key(struct adap
 	struct security_priv *securitypriv = &(adapter->securitypriv);
 	signed int keyid;
 
-	if ((_WEP40_ == securitypriv->dot11PrivacyAlgrthm) || (_WEP104_ == securitypriv->dot11PrivacyAlgrthm)) {
+	if ((securitypriv->dot11PrivacyAlgrthm == _WEP40_) || (securitypriv->dot11PrivacyAlgrthm == _WEP104_)) {
 		for (keyid = 0; keyid < 4; keyid++) {
 			if (securitypriv->key_mask & BIT(keyid)) {
 				if (keyid == securitypriv->dot11PrivacyKeyIndex)


