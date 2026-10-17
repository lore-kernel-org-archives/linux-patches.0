Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F4517BED0;
	Sat, 17 Oct 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258837; cv=none; b=ELin17MyeRAqFpFoaNpAlRQy4uEhCB8Z55tS0BuX6GFBzovImZOgaXurmt/u3qK7SPXC3nWePZ7Vhk2JNFYSkNQvinelqTZH1zZBLxUWshcWilh4rRUwHoZznCjVBxK98Orq01CoB6QJDlsW0V0Wmg1SJS6+LgJyh2owqs1uzJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258837; c=relaxed/simple;
	bh=RYVmon5iTqGNevJU8FS4McIPMGyRkCri8yUu4WgR4tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuCw8hiw+1SUhieFf+gFjKmotsizYtnu/WSE/h/A7/f+ZBQ97srGKO1bQCkZ0i1bNVX8D7TCvSRAPVKHklXr78qSeBjeGZGQiRhrr/RYVTyRMUHEEeVPdAiP8kP14Qm8mY6rHC5UHG/YIap62Gk4K+i/xtUTNJo5zlq8YSietmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsLJasVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsLJasVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AE51F000C4;
	Sat, 17 Oct 2026 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258836;
	bh=DX3raB/J3SknjcF1n1RSPiwfYObySOz9jhnMwN2GyY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsLJasVCZlKPBb03bNq/rIJ5ueYk/YZUKTz5dEhgsrdIpS6EEySqqq67sYj1xvUCR
	 PDCCdfulpStyjLjh8MfeTae52LyDszAl79VfoNBEDfoZV1IDwSvkoq63vg9xQnNlG9
	 XPGpl2Dnyb7d/gsF+GVTfUOON/fqnokQlBPpCOk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Salman Alghamdi <me@cipherat.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1013/1674] staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction
Date: Sat, 17 Oct 2026 17:54:45 +0200
Message-ID: <20261017160457.136746444@linuxfoundation.org>
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

From: Salman Alghamdi <me@cipherat.com>

[ Upstream commit 88e994c57a79f62d5338231d8d37ee8dd98baffe ]

Add guards to ensure ie_length is large enough before subtracting
fixed IE offsets to prevent unsigned integer underflow.

Fixes: 2038fe84b8bd ("staging: rtl8723bs: fix spacing around operators")
Fixes: d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
Closes: https://lore.kernel.org/linux-staging/DI2H39EAAFBZ.3KI5NWN02AQ2S@linux.dev/
Cc: stable <stable@kernel.org>
Signed-off-by: Salman Alghamdi <me@cipherat.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260513203455.31792-1-me@cipherat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 6994c7081476c..5ee859ecd6d2b 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -649,6 +649,8 @@ int rtw_is_desired_network(struct adapter *adapter, struct wlan_network *pnetwor
 	privacy = pnetwork->network.privacy;
 
 	if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS)) {
+		if (pnetwork->network.ie_length < _FIXED_IE_LENGTH_)
+			return false;
 		if (rtw_get_wps_ie(pnetwork->network.ies+_FIXED_IE_LENGTH_, pnetwork->network.ie_length-_FIXED_IE_LENGTH_, NULL, &wps_ielen))
 			return true;
 		else
@@ -663,11 +665,15 @@ int rtw_is_desired_network(struct adapter *adapter, struct wlan_network *pnetwor
 			bselected = false;
 
 		if (psecuritypriv->ndisauthtype == Ndis802_11AuthModeWPA2PSK) {
-			p = rtw_get_ie(pnetwork->network.ies + _BEACON_IE_OFFSET_, WLAN_EID_RSN, &ie_len, (pnetwork->network.ie_length - _BEACON_IE_OFFSET_));
-			if (p && ie_len > 0)
-				bselected = true;
-			else
+			if (pnetwork->network.ie_length < _BEACON_IE_OFFSET_) {
 				bselected = false;
+			} else {
+				p = rtw_get_ie(pnetwork->network.ies + _BEACON_IE_OFFSET_, WLAN_EID_RSN, &ie_len, (pnetwork->network.ie_length - _BEACON_IE_OFFSET_));
+				if (p && ie_len > 0)
+					bselected = true;
+				else
+					bselected = false;
+			}
 		}
 	}
 
-- 
2.53.0



