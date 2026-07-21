Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C81B44AB9F;
	Tue, 21 Jul 2026 22:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674646; cv=none; b=ZlrHrMBROz6/tx+yRBCtIl/y+7BuxC7EQ/2s2XDWZLShG+DMJIE/uPJl3RqbkDMo3MxIH9GoFiu89kAIN20GPgiNWj2ro0XICgB+04/V0ddpzfYTr4sYDi5EMHPBdE6ICJOFazncY4T7cAyVkEkKUe26e8qa2IlV/prNUxK0Ei0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674646; c=relaxed/simple;
	bh=dbLZRt/duW+ASP7aLiBq5vQj/aYHcsUjDu9m7bZprsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teZblB0zgGFntlg5kKZe05vsiZt6+Ms3apBUf1U9CIJJXkBn8M/CdgemE3S+TkA8V0jQDtmwE+4Jy+XpFzXKPrZouCq4fAMd0xpo4YFufiQlSMDRFcpDGeqUI1BYCTMrtkPseRwTuRaqvcK7YdTTaZ9ifj4oH4Rdpd8UfX+/2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2n/LMoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2n/LMoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21341F000E9;
	Tue, 21 Jul 2026 22:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674645;
	bh=Gjysfbm1TMK8YBlztpX8W1CkHeLIVI6BD3Ru97109q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2n/LMooZa0188xTFq2VGhx7CmKxNRkOydfw9s6o4a948/3A9g48mDSe/FTHSGKFh
	 P3yB13ZUb997/Y8GnaUUhu12dk0KtIUJB0MN4+1HY7ipkoCNaO+DwwdpZaZlpT792I
	 UuvGVJuil+Qz8OGHach5EX8XjI0fQ35cK3pNwwMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 618/699] staging: rtl8723bs: remove 5Ghz code blocks
Date: Tue, 21 Jul 2026 17:26:17 +0200
Message-ID: <20260721152409.686638141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit ddd7c8b0033ba01a0ee605697f12a33fd31e6fca ]

remove 5 Ghz code blocks, related to networks
working over channel numbers above 14.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/c64443b92ce1a60f568db153842a62e3244a8c3a.1626874164.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1fc19d61f66 ("staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c  |    7 ++-----
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |   20 +++-----------------
 2 files changed, 5 insertions(+), 22 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -4116,7 +4116,7 @@ static void issue_action_BSSCoexistPacke
 			p = rtw_get_ie(pbss_network->IEs + _FIXED_IE_LENGTH_, _HT_CAPABILITY_IE_, &len, pbss_network->IELength - _FIXED_IE_LENGTH_);
 			if ((p == NULL) || (len == 0)) {/* non-HT */
 
-				if ((pbss_network->Configuration.DSConfig <= 0) || (pbss_network->Configuration.DSConfig > 14))
+				if (pbss_network->Configuration.DSConfig <= 0)
 					continue;
 
 				ICS[0][pbss_network->Configuration.DSConfig] = 1;
@@ -6118,10 +6118,7 @@ u8 join_cmd_hdl(struct adapter *padapter
 			{
 				struct HT_info_element *pht_info = (struct HT_info_element *)(pIE->data);
 
-				if (pnetwork->Configuration.DSConfig > 14) {
-					if ((pregpriv->bw_mode >> 4) > CHANNEL_WIDTH_20)
-						cbw40_enable = 1;
-				} else {
+				if (pnetwork->Configuration.DSConfig <= 14) {
 					if ((pregpriv->bw_mode & 0x0f) > CHANNEL_WIDTH_20)
 						cbw40_enable = 1;
 				}
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -135,14 +135,7 @@ static char *translate_scan(struct adapt
 		else
 			snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11bg");
 	} else {
-		if (pnetwork->network.Configuration.DSConfig > 14) {
-			if (vht_cap)
-				snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11AC");
-			else if (ht_cap)
-				snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11an");
-			else
-				snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11a");
-		} else {
+		if (pnetwork->network.Configuration.DSConfig <= 14) {
 			if (ht_cap)
 				snprintf(iwe.u.name, IFNAMSIZ, "IEEE 802.11gn");
 			else
@@ -762,7 +755,7 @@ static int rtw_wx_get_name(struct net_de
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	u32 ht_ielen = 0;
 	char *p;
-	u8 ht_cap = false, vht_cap = false;
+	u8 ht_cap = false;
 	struct	mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 	struct wlan_bssid_ex  *pcur_bss = &pmlmepriv->cur_network.network;
 	NDIS_802_11_RATES_EX* prates = NULL;
@@ -788,14 +781,7 @@ static int rtw_wx_get_name(struct net_de
 			else
 				snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11bg");
 		} else {
-			if (pcur_bss->Configuration.DSConfig > 14) {
-				if (vht_cap)
-					snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11AC");
-				else if (ht_cap)
-					snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11an");
-				else
-					snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11a");
-			} else {
+			if (pcur_bss->Configuration.DSConfig <= 14) {
 				if (ht_cap)
 					snprintf(wrqu->name, IFNAMSIZ, "IEEE 802.11gn");
 				else


