Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2184135C682;
	Tue, 21 Jul 2026 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672800; cv=none; b=eAFjxDSC6S5i6P1d8NpNDxVwUHc4oo2C2kYHyXnVbxdH0MKUh3KAzdUce9Gv/nimiLWYzi5LhJDo1b/KgRa9V3/3AQlq1nImkrxuKyuY5eOiT9o4awwwBRR/geE3hyrFDaxdQqhnRPp30encYlsm19SxUbqmlz+1Lbr/nFdyteQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672800; c=relaxed/simple;
	bh=/igyo4xEXvUf1uR9JgsSZt4Cf50c/fmEiFG1wMT1Iwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmQp8KSjRMFSFd1ERr5WmiYk/XnLcmuYN9Psg6kKjiJTWlLJdwEy6fERTSMD8D8VR+3JB8IBm06yxX7sGB8bXtsZlSAIkMz/9i/R0p6GR6GWFrZNiQ3LtaWaEDyfcR0/Bcip/tESysm2GC0k6FZ3PcbkmSk+0rp+zYGNgqNvbGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Koj5ERvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Koj5ERvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865201F000E9;
	Tue, 21 Jul 2026 22:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672799;
	bh=rpUV39pF4XuPMPpV1+UiAjBKYWscysyKV/uQ66kwZ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Koj5ERvXxDO+t7wFEKD3Zu7ppz+Zn6eTrCUnHIfUAe6ublLU1UkfOhv+ouLIaIjaO
	 AlWadEGg94mTqUURm1fDN6FMwf4rfbeQg+fa/6rd7TCvtuPp2WDVNyGhRwSwYIOEsZ
	 0U5+tqoR0AwajoPXZMAOcVmkzFqy9dNwAPfYlFms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 760/843] staging: rtl8723bs: remove redundant braces in if statements
Date: Tue, 21 Jul 2026 17:26:35 +0200
Message-ID: <20260721152423.147974812@linuxfoundation.org>
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

From: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>

[ Upstream commit 94579b02720bb63096312c4bc7694fd2f6df7cbb ]

Adhere to Linux kernel coding style.

Reported by checkpatch:

WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Link: https://lore.kernel.org/r/20220331113245.GA425141@euclid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1463ca3ec660 ("staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -341,9 +341,8 @@ int rtw_generate_ie(struct registry_priv
 
 	ie = rtw_set_ie(ie, WLAN_EID_IBSS_PARAMS, 2, (u8 *)&(pdev_network->configuration.atim_window), &sz);
 
-	if (rateLen > 8) {
+	if (rateLen > 8)
 		ie = rtw_set_ie(ie, WLAN_EID_EXT_SUPP_RATES, (rateLen - 8), (pdev_network->supported_rates + 8), &sz);
-	}
 
 	/* HT Cap. */
 	if ((pregistrypriv->wireless_mode & WIRELESS_11_24N) &&
@@ -372,9 +371,8 @@ unsigned char *rtw_get_wpa_ie(unsigned c
 
 		if (pbuf) {
 			/* check if oui matches... */
-			if (memcmp((pbuf + 2), wpa_oui_type, sizeof(wpa_oui_type))) {
+			if (memcmp((pbuf + 2), wpa_oui_type, sizeof(wpa_oui_type)))
 				goto check_next_ie;
-			}
 
 			/* check version... */
 			memcpy((u8 *)&le_tmp, (pbuf + 6), sizeof(val16));
@@ -499,9 +497,8 @@ int rtw_parse_wpa_ie(u8 *wpa_ie, int wpa
 	if (is_8021x) {
 		if (left >= 6) {
 			pos += 2;
-			if (!memcmp(pos, SUITE_1X, 4)) {
+			if (!memcmp(pos, SUITE_1X, 4))
 				*is_8021x = 1;
-			}
 		}
 	}
 
@@ -520,9 +517,8 @@ int rtw_parse_wpa2_ie(u8 *rsn_ie, int rs
 		return _FAIL;
 	}
 
-	if ((*rsn_ie != WLAN_EID_RSN) || (*(rsn_ie+1) != (u8)(rsn_ie_len - 2))) {
+	if ((*rsn_ie != WLAN_EID_RSN) || (*(rsn_ie+1) != (u8)(rsn_ie_len - 2)))
 		return _FAIL;
-	}
 
 	pos = rsn_ie;
 	pos += 4;


