Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A1043E066;
	Tue, 21 Jul 2026 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672781; cv=none; b=bgKMSN3Y+nGGbrbUyuvTjgcTkhFl6+G84M8/KhHi9c7o5Qojqw1VKkk9EoyCeIvo28GvUsQuTrHLxJvYAXD1xR+mRNBJ0M58E9E2/pKyW8ICIJwDg/ElxpsLFC/bh0+xULNaGPtvPWHHkufYUO1Ix3y5W3yGHV68CKElO3ch5qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672781; c=relaxed/simple;
	bh=DTOWSIw29tYTJm7oRmlXHe/M/tptg9YswqrpCKSr550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPKDwVKGjvikRI2LgiN79vWU+1alHFNA3ZL3Xw11kPzquBAG2SBnAxAITs+oTv0BXdtxNgwgr5V3UJ1UpR6ohGpYrnNnkW+LIlLuFHyPF5ZoaxGIoGnh6W/U/RAZFTrM1FbBIrPBXHevaoVl/Kz1BiVbSOBtU//PTRbwdhG4of4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/wLXCm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/wLXCm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115641F000E9;
	Tue, 21 Jul 2026 22:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672780;
	bh=vt5hkSawvfhnbWkHvqL8C0ykjcWEexZn86muNyH+yDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/wLXCm9D+xTlW9LRR0Q2IYyN3siUnyURvbKyl/LO+69WNpXGWwuGf/fAg1YLi8eS
	 xAn7RqLJcEVbR6/lcRv/MCvK6OOA6LikYXP8cyu++Id+p6L4+q9k3DwK366Slvo2CR
	 8JsHiE4DtNzTLmBcHgXsK8KF4OApvPROGglqYluI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franziska Naepelt <franziska.naepelt@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 753/843] staging: rtl8723bs: Fix indentation issues
Date: Tue, 21 Jul 2026 17:26:28 +0200
Message-ID: <20260721152422.990789829@linuxfoundation.org>
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

[ Upstream commit b59cba2309b16fa364df03e3693b8d45c3fadbd6 ]

Fix the following checkpatch indentation issues:
- WARNING: suspect code indent for conditional statements (32, 48)
- WARNING: suspect code indent for conditional statements (24, 24)
- ERROR: code indent should use tabs where possible

Signed-off-by: Franziska Naepelt <franziska.naepelt@gmail.com>
Link: https://lore.kernel.org/r/20230619180351.18925-1-franziska.naepelt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5a752a616e75 ("staging: rtl8723bs: fix heap buffer overflow in rtw_cfg80211_set_wpa_ie()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -582,7 +582,7 @@ static int rtw_cfg80211_ap_set_encryptio
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 				if (param->u.crypt.key_len == 13)
-						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
+					psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 
 			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
@@ -1305,7 +1305,7 @@ static int cfg80211_rtw_scan(struct wiph
 	} else if (request->n_channels <= 4) {
 		for (j = request->n_channels - 1; j >= 0; j--)
 			for (i = 0; i < survey_times; i++)
-			memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
+				memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, ch, survey_times * request->n_channels);
 	} else {
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, NULL, 0);
@@ -2805,7 +2805,7 @@ int rtw_wdev_alloc(struct adapter *padap
 	wdev->netdev = pnetdev;
 
 	wdev->iftype = NL80211_IFTYPE_STATION; /*  will be init in rtw_hal_init() */
-	                                       /*  Must sync with _rtw_init_mlme_priv() */
+					   /*  Must sync with _rtw_init_mlme_priv() */
 					   /*  pmlmepriv->fw_state = WIFI_STATION_STATE */
 	padapter->rtw_wdev = wdev;
 	pnetdev->ieee80211_ptr = wdev;


