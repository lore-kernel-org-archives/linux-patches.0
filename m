Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019349;
	b=EfqM8T0g3jtrG2akvOPs887pYIxFRYw+y6zX1JS7n13K/hIQ9XHHRDuS7qbLisj5qHtI
	 nbX0bCGGlDkWe1nJ4sBjZ09l7lUrnfMhxEdrGhr3w6HRMxyADaIcHsBumvGE9EKimJ6fo
	 6hIc2hkVo5xtDIBeFsM4UWburrDeusjeQu8asaqVxzXhadcK1cc+/iDHdkJOJBSzIEC+5
	 PWy/OSTiqEeEEcPCkl0vxkeE6sDsCpK655+bG1/YHMawJnliJK1T9ALpdWN3K47IQ8ZvF
	 5hCB/ca1ufS3x9wsxWa332KoBO+P+gNi4U1tpj6veKCPrSIOR07jYLqW47T0S1e0x+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZZ22bF4lAREycS4xeV1qNsRJ7HUk1/itDPNphyd2pRY=;
	b=ltq/b1bjPVgS+piCxrgnjHBvjtt72ErMANdLLI5ySDdzr1dwUVUl0JY7R+Ig3+4iqgjJ
	 +FOHCn0v0PLwpSJFMLao+gQITXgpj0cqKPaToKF70lSpAOFjtL3ch+3WtH4M/CloUxXSB
	 DWjlvyzoPh4trd2Z6MkEVvqPKpu/ziXKBLctxxrqEP9NXMJ0SmHWGRDY14b14NIsBwIMa
	 cUCckKuAmU3FE2R5Bg9TLvFPIGkggfM47oCwClu7ejAMOMQAdSK0Ju7JgBdaCUVc8ppf8
	 DvCAsUEbbX8DFYJRHfO9635T/PxznMJxiYa92Ruin7dUfs3cDRELXb9Y6bZh+Dqlwvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+9WQLrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72737606A333;
	Wed, 18 Nov 2026 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+9WQLrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59F61F000C4;
	Wed, 18 Nov 2026 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019349;
	bh=ZZ22bF4lAREycS4xeV1qNsRJ7HUk1/itDPNphyd2pRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+9WQLrVprFGALuPW729fos/lheXP2KdM6ag13GKCP3wY9Bt/waNaSuiJmZfesFzQ
	 0ogU4kf8yjWXpQ++kjpk/DMxGoQjAP4ZrD4hORuSnVAdo9vVtt6j9cQw9iJO9SMsMu
	 dwWuyXXC3aHgTVFD4MBhw40BquIOeHqawSH6Hj54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1563/2651] wifi: mac80211: use link address as TA for non-MLO 4-addr station on MLD AP
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118150344.219344812@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 07b3eb8b9048976b585d29f1a1df9a435423c473 ]

A 4-address AP_VLAN always sets A2 to sdata->vif.addr, which on an MLD
AP is the AP MLD address. For a non-MLO station, A2 must be the link
address it associated to.

Use the link address for a non-MLO station in the 4-address case as
well, like the AP case already does in ieee80211_build_hdr() and
ieee80211_check_fast_xmit(). Share the address selection between both
cases and both TX paths.

Fixes: 3e0278b717b0 ("wifi: mac80211: select link when transmitting to non-MLO stations")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20261007105249.1234601-1-nbd@nbd.name
[use guard]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 65 +++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0692021746cde..4e23f89867e35 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2730,6 +2730,29 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
 	kfree_skb(ack_skb);
 }
 
+static int ieee80211_ap_tx_addr_get(struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta, u8 *addr, u8 *link_id)
+{
+	struct ieee80211_link_data *link;
+
+	if (!ieee80211_vif_is_mld(&sdata->vif) || sta->sta.mlo) {
+		memcpy(addr, sdata->vif.addr, ETH_ALEN);
+		return 0;
+	}
+
+	guard(rcu)();
+
+	link = rcu_dereference(sdata->link[sta->deflink.link_id]);
+	if (WARN_ON(!link))
+		return -ENOLINK;
+
+	memcpy(addr, link->conf->addr, ETH_ALEN);
+	if (link_id)
+		*link_id = sta->deflink.link_id;
+
+	return 0;
+}
+
 /**
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
@@ -2798,7 +2821,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr1, sta->sta.addr, ETH_ALEN);
-			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
+			ret = ieee80211_ap_tx_addr_get(sdata, sta, hdr.addr2,
+						       &link_id);
+			if (ret)
+				goto free;
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
@@ -2823,18 +2849,12 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 
-		if (ieee80211_vif_is_mld(&sdata->vif) && sta && !sta->sta.mlo) {
-			struct ieee80211_link_data *link;
-
-			link_id = sta->deflink.link_id;
-			link = rcu_dereference(sdata->link[link_id]);
-			if (WARN_ON(!link)) {
-				ret = -ENOLINK;
+		if (sta) {
+			ret = ieee80211_ap_tx_addr_get(sdata, sta, hdr.addr2,
+						       &link_id);
+			if (ret)
 				goto free;
-			}
-			memcpy(hdr.addr2, link->conf->addr, ETH_ALEN);
-		} else if (link_id == IEEE80211_LINK_UNSPECIFIED ||
-			   (sta && sta->sta.mlo)) {
+		} else if (link_id == IEEE80211_LINK_UNSPECIFIED) {
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		} else {
 			struct ieee80211_bss_conf *conf;
@@ -3320,7 +3340,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
-			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+			if (ieee80211_ap_tx_addr_get(sdata, sta, hdr->addr2,
+						     NULL))
+				goto out;
 			build.da_offs = offsetof(struct ieee80211_hdr, addr3);
 			build.sa_offs = offsetof(struct ieee80211_hdr, addr4);
 			build.hdr_len = 30;
@@ -3331,21 +3353,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		build.da_offs = offsetof(struct ieee80211_hdr, addr1);
-		if (sta->sta.mlo || !ieee80211_vif_is_mld(&sdata->vif)) {
-			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
-		} else {
-			unsigned int link_id = sta->deflink.link_id;
-			struct ieee80211_link_data *link;
-
-			rcu_read_lock();
-			link = rcu_dereference(sdata->link[link_id]);
-			if (WARN_ON(!link)) {
-				rcu_read_unlock();
-				goto out;
-			}
-			memcpy(hdr->addr2, link->conf->addr, ETH_ALEN);
-			rcu_read_unlock();
-		}
+		if (ieee80211_ap_tx_addr_get(sdata, sta, hdr->addr2, NULL))
+			goto out;
 		build.sa_offs = offsetof(struct ieee80211_hdr, addr3);
 		build.hdr_len = 24;
 		break;
-- 
2.53.0



