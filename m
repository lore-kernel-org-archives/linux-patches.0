Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018756;
	b=TnjCdlZD3Dt2DQsZn4hR1xAVQ1UQbhV1aTW3LWuU0WVVNsQ90s1cmvLktKZeeCyk47RF
	 VLPJxCw0X78yeh0R7LkQCzZvEyFuZfyWeFoy4S0n5xg+URhp+PpkF1AzHbczI99eq5hUg
	 YleQw+SsGVv1tAP/HI5eK3NTgKI74Zauro9Mw0BUg+8m3eG6To9uNMB1SywWWcfRJSmUb
	 Mif3kUWorY6/reBp75cRLTfFlHRznCAMA64zaDyvl6uTW8O4lqGWfTZ+LGHXVjb15TCYM
	 GTXlgjRoQf+2r+iCJsuzHguAW0zysru9QDnWEPnsI1gN9eIndzOlvFFgyE42v0kN2Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhSSj+0cjqrJyDe+iQkQgERca8um2MxzyrKW97eWM5s=;
	b=NJwdPd5ebvHh7HfYhqRjfO3Tq2zPNN98YEwdWfbnKl2qIjkgsXtk/ok89C2jJu5eVRQO
	 M4/SHM3VLWQE9r5I9GI7uD4GzS86TIgB+jkj8ZJ17PMutYHJBGW0XQb4sEfKYs2Kn4+s8
	 KZB6A7HoYeV/w2EPkyWWJIIprQkxopqL3wl8H9eDwIj6pP4g3okftgDI7Jj9aMZNS1b/S
	 w9XDY3nfQrWUgSSWFyCERjJ2ZB/RzRMQpNYaqjewdy47RmBAFPfdco3FJ4LV4F5QkqG/h
	 qk+XMj01RrNfB0CtauExivxdAtIPMN2C8WTERv1GGaeyT43umlpHkFe5zEh54e8kbog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udaLiwc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FAD606A339;
	Wed, 18 Nov 2026 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udaLiwc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A131F000C5;
	Wed, 18 Nov 2026 16:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018756;
	bh=AhSSj+0cjqrJyDe+iQkQgERca8um2MxzyrKW97eWM5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udaLiwc0EL+BsIyohoOIzaJnrMF3A6s/8l8fdNlHAX8/mh11BA1PHzM/JM1jh4QvL
	 RuAtA5VnzI3D0kGK2Q5I3/iXyGDLS5/z/CpmHe33S6SJSVKU0SlSbT3GIQdbHp+zkH
	 o+JWSpbMyG425Gocj/HLNKY1Yqyx7mEC+Wo9Wiyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1312/2651] Revert "wifi: mac80211: do not use old MBSSID elements"
Date: Wed, 18 Nov 2026 15:42:32 +0100
Message-ID: <20261118150335.205712347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 797d654c9221b..e86255b4721d1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1501,6 +1501,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
+	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1510,6 +1511,15 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
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



