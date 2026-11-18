Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041291;
	b=Zx2cpfR2oKui+szeRGviGzfFcA+HuYtYNdkZwfh06onRzrHK1a6fs1awLt/ysWh9yQ7M
	 r/4uvUwlDTDe6r/bY3Hk8ee+bR+NK1kw0eRPAod1N47qiYDW7SpbVahoru+eBl11O1oYU
	 fi+aEpNx5NJMu6999Urm3Nu9CbFOQKFLF6TWlQAqoZhBVjMQeJ0eWVtvDbLQS641MIHlM
	 N3ezsKq+FxSizM1d8tbwyz6bW6R8Z+aChwyeDMpgSAbsbnzZB6V20VYH9JHNdyQeC0ua9
	 sCshnnYymDdM1lEPC/T8CVzIS12Uhs4Gdfbf6KeQmAxExlFqTI/IeW9h56ptrelEt4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FN2YgcxbE+mkr+GgtVYTE15yNxhGWyqeoZDNlu+HFQU=;
	b=nk1gZOMOFd8dvi7M5KPu9CG1u+/0N4tiblPswJAzvrY4tNBpaB7PBbEElETleaRoYiXA
	 asmDeKuyQ0DwBxMjbjjt9WYn65Bo5g6ABe/87EPtOtIVWsfI5XWYFJ193OiK2HIa3BzYu
	 FHPZ/4cksCkElfZl8mlgAqtXbQjGy7KmK+xXm1pcn+oicnPYv8qnZ4tEEZ52zhEJeEwH+
	 H/NWo2oUW4TcHEFTyzVIHZ9x2cRbMKw1XwROle0PP9JCvCj36MCFaSDM4WI1a17D3TQyn
	 p6ksr7I2AXqiA8RktKEazUTlU/pJFKPHvs97XU71UVKYz+pi5ThkM3RYp5kpJtdMWNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13QQ1NLE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C118C606A31C;
	Wed, 18 Nov 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13QQ1NLE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5D61F000C4;
	Wed, 18 Nov 2026 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041291;
	bh=FN2YgcxbE+mkr+GgtVYTE15yNxhGWyqeoZDNlu+HFQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13QQ1NLEQ9GTGLrLvEIR4TXeV0lbPjpJQ4WSGsCj/o7zEd4RNSiYvEL9lYdI1POZY
	 eF25FIP/DaR2Qdwoz+2CNXusXky+P29IJy10AYgPWlMyNRP1GhjUu79eg+hPZY32nz
	 TRWwNau/9gDl30fmG/qh65eVE3bvQUfQrnLZCfmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2720/3318] wifi: mac80211: use link address as TA for non-MLO 4-addr station on MLD AP
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150442.452123538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43a66201db299..0c348c7b3f639 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2630,6 +2630,29 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
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
@@ -2698,7 +2721,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
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
@@ -2723,18 +2749,12 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
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
@@ -3204,7 +3224,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
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
@@ -3215,21 +3237,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
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



