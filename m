Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030901;
	b=Oo1RivZUOVGSwRggvNvcMjGM6TyPb2NEcBapKQ63izibnDdQPgXWp1ZgcvnkZrbi7wGP
	 3JAZiHBI8pzq/On6SipZqR+TALs8tzXfKF04hLtO50mI4BhD0aDXUDFv5g5tVnNH5hA94
	 2bneuJYc4nj7vH6ymY9QHue2ffuHPvFPCfJYw2Pzmnci6X7fvwqsZ9oJu9kAGZBsaxp1R
	 ko8cKcvUpsE9Zqbbh3votnes6q4PlcJDGV3fKqcFQKJBhzBG343MzvMVOge7JzjTd/MX1
	 AL+jmkDC3qHdoGNG5u6aPAqyBvszhmNc2lkXZfvhtLpFSeAjqRNgTRV1IEFBOnWbqMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ppKp5mWWHBZ2BjCTG/VsOQYwceJuc6/kflmDSL7JeME=;
	b=KD290UHAm8vehDWKNevXF93WAgmEyVB1UiH+iMFeUmIJdPOUGp+ymHEAihU9iXPk/r4L
	 KeshigohYJxK1Uq9i+epKDlR5h18aeKI+WAvlIMxPl7ht6HSPYgtEWFhtFtOdgts3NA5t
	 9zooZhA6+SKduTsLcM49ejIC9Mq1VZh737HXeYX4tz6O6IKR6PP/Lct+T9TmuaS0pbz22
	 I5IqvMXdFKsK+ZdcB+aoy0vJ5gnlDU1Ofo3MWmyxsUJQytGBEGjeoQRcY1CpYaZHWbWyI
	 CmqG1NiNoe6m/UgI8B7DqJ3Jr/hVWr/e2fKImGc3TVZ6wIyMSU5HkV1T/qy6YzdZcFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIJkGYFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD01606DD26;
	Wed, 18 Nov 2026 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIJkGYFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3672D1F000C4;
	Wed, 18 Nov 2026 19:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030900;
	bh=ppKp5mWWHBZ2BjCTG/VsOQYwceJuc6/kflmDSL7JeME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIJkGYFPeCYnEHlssPL/YSNvDM4eQCRj69yWDXwP52UwvyeirhjcZizslaHvI2UcT
	 xwXYG1mG9ELgAr5uP7w3s3OeILXpC6pg8uQYhq5aKM2Y96wPJ2h+ryRRXgoYyDrf9T
	 qfkYxYuPNhJuBq0xqChF+5S/3HruZ1+hirKpnb0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0867/1756] Revert "wifi: mac80211: do not use old MBSSID elements"
Date: Wed, 18 Nov 2026 15:49:54 +0100
Message-ID: <20261118150043.827245830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 56fb2334c86cef0b6d44099a6b21de4c8d80a7cb ]

Commit a519be2f5d95 ("wifi: mac80211: do not use old MBSSID
elements") fixed the incorrect inclusion of stopped/removed
non-transmitted profiles from the Beacon frames, but it caused
a regression for channel switch (CSA) and BSS color change (CCA)
operations initiated from hostapd.

Hostapd passes two Beacon templates to kernel for CSA and CCA -
(1) beacon_csa/beacon_color_change used during the countdown.
(2) beacon_after/beacon_next used after the countdown completes.
Hostapd relies on the kernel to include the old MBSSID elements
while sending beacon_csa/beacon_color_change templates to the
driver.

This path is now broken and results in CSA/CCA failure.

Including existing MBSSID elements explicitly makes the netlink
buffer larger than default 4 KB depending on the number of APs
which would need unnecessary complication to pre-calculate the
buffer length.

Revert the commit to fix the regression.

Regarding the original issue fixed by the reverted commit -
Hostapd now has a new commit which always includes at least one
MBSSID element when the feature is enabled, hence when all
non-transmitted profiles are removed, this empty element ensures
that stopped profiles are not advertised.

Fixes: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002-csa_cca_fix-v1-1-b83a998aeb44@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5b65788f2f82f..1e47db63b5289 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1165,6 +1165,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
+	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1174,6 +1175,15 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
+	} else if (old && old->mbssid_ies) {
+		mbssid = old->mbssid_ies;
+		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
+		if (old && old->rnr_ies) {
+			rnr = old->rnr_ies;
+			size += struct_size(new->rnr_ies, elem, rnr->cnt);
+		}
+		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
+							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



