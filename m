Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A7E34B1A6;
	Tue, 21 Jul 2026 21:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670509; cv=none; b=ImJwke3IMZRHH9m5/6WJNiuuMxzAkUgaVu8jiDBMH83JxqducMKsg0s0Eq7Zk8wITWLJlMRjcEx+4HeZSQaDa7wLBegRx+VDkrdTHgw437kXWRcA0voBECO77n4tx4MyrkSkcBopsb6LccCxmQcUNaI5IL8btAuXPjA/xHLAjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670509; c=relaxed/simple;
	bh=5668pciazawglV/ruofbKY0rde3H0G+OiPCpjiQnTeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPJ98appgss29vZOpmXGfbuqeHfHKzbKLIV0Yj1J+aYjQVZicGa0YD/O4QDABQH9EDhbne94jADA8A0O53klmIUA7DFCEdxghnJBSt6/waK4bxhJrlpN+T4S5dqGkEi824eETR2tbUl97vMcnILRB/Hg3mMfq+maJqNij7glDMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAMb8WEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAMb8WEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF751F000E9;
	Tue, 21 Jul 2026 21:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670508;
	bh=i3enVe11abhsefDhPYxwDd+JJO5G4CbqF1XAAPTMGmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAMb8WEkiR1oHYx4y5AnZZAULp0XMoL8/x9CpFKzUjWf2wBFvvU+DQN3gojOBi+sl
	 gHn5M3b//jIO7Ii7FwZPjqR2wUkTTdqhWDJHDbWzQYO8QmfGLHp/7YZqrec12pKXup
	 lXjI0xi3h/1asZagpsfn4mjuidpBkfN+u6RK8Wc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franziska Naepelt <franziska.naepelt@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0959/1067] staging: rtl8723bs: Fix indentation issues
Date: Tue, 21 Jul 2026 17:26:00 +0200
Message-ID: <20260721152445.994743192@linuxfoundation.org>
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
@@ -1306,7 +1306,7 @@ static int cfg80211_rtw_scan(struct wiph
 	} else if (request->n_channels <= 4) {
 		for (j = request->n_channels - 1; j >= 0; j--)
 			for (i = 0; i < survey_times; i++)
-			memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
+				memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, ch, survey_times * request->n_channels);
 	} else {
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, NULL, 0);
@@ -2811,7 +2811,7 @@ int rtw_wdev_alloc(struct adapter *padap
 	wdev->netdev = pnetdev;
 
 	wdev->iftype = NL80211_IFTYPE_STATION; /*  will be init in rtw_hal_init() */
-	                                       /*  Must sync with _rtw_init_mlme_priv() */
+					   /*  Must sync with _rtw_init_mlme_priv() */
 					   /*  pmlmepriv->fw_state = WIFI_STATION_STATE */
 	padapter->rtw_wdev = wdev;
 	pnetdev->ieee80211_ptr = wdev;


