Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829554;
	b=N7Sv2ldahqsLN+YgHKyFB8AdrjJbAdPdUpGi2rhxhSzqO575JS7wW7F2TsgYtDSVH3VE
	 ILWuzAKRgLauXVqMdLH64z3LxGHgaDoAqkphei9QwosB2505AL5+RyECZ5w+X9wglu9Np
	 2lXGh4W67Z7VFMnvlMrCXcLw1VFrP4vg96m2zvpCx/hCBeImN4NethT6pG1pcH23dc/tL
	 5rDhhIJGetzO8DZjsw/NkJbHStApc27wzwdJzdtRJQjVbueo4Jl8l2fqO676KCIiHlnCg
	 BBF+EV9eisaywpijexpzICckqpi8tCQXqZMRfP1hwDQ5/R2zirhpdQ/jClqpiM0CODw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37BPug6F0bNrNSKLgVcou92EuQI2ekhMK+4D6tBX6F8=;
	b=TkLT+8r8OO8xaIAGVlmfKoqtWDJ4m377pRvdo5lvkjdaTkD3pkupPLX6HgywZTnWKxf2
	 6dII2VYdmrFWRbfI034o0cyV4uT3uMlAdtmIlkpFwZQfDgd3tFqoLas+0U36Uh8dc5ZG0
	 qln8PoDSOtOpVfDT+1Jl/kKnnpSM5mnucRKBGCdeJKysdT19G5j/ZKkja4xXF0ZlTH9gR
	 QuiQe++zuetzpqZ7kHnq3wjDYdCRUeCfGXWruBlKFL/H94x6aY0oV4ZAI4AvmsvjsuY9J
	 2XOoJ4m5TNUh9ongMs/dWlHTywQBMJd5MdN6slM8JBjdVaWGRKOo4pXjF528EKXZKTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqVxzcde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41A9606A846;
	Wed,  4 Nov 2026 21:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqVxzcde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743381F00919;
	Wed,  4 Nov 2026 21:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829553;
	bh=37BPug6F0bNrNSKLgVcou92EuQI2ekhMK+4D6tBX6F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqVxzcde10Pbtd41+OgTtt24wiidBhwrBAKk+XothEldL086OSOGYVTyvrnFkMs/P
	 f0eEfFIGSr+SnN8JUNSfRuB3MdgTI54436nF26cjPCjj4jOvvqQvD3HFGhGc/miE3y
	 H08PvRUKFboXefUkHwT5oZeTNXhcvuaGoQp7cIbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0199/1005] wifi: iwlwifi: mld: validate wake packet crypto overhead
Date: Wed,  4 Nov 2026 15:58:52 -0500
Message-ID: <20261104211049.369060750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit c5cb9dd220ba9fdcf4ba485ce3d1d36ca32ac00b ]

Wake packet parsing only accounted for FCS and missed per-key
IV/ICV overhead for protected data frames.

Prevent size underflow and bad packet trimming when
notifications are malformed or truncated.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.e06595623533.Ie09494b7e34e5872b750fd90e325648ee469d0da@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 63 +++++++++++++++++++--
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 73fd4c69357ca..b75936125b46d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -53,6 +53,30 @@ struct iwl_mld_suspend_key_iter_data {
 	__le32 bigtk_cipher;
 };
 
+struct iwl_mld_wake_pkt_iter_data {
+	bool multicast;
+	u32 ivlen;
+	u32 icvlen;
+};
+
+static void
+iwl_mld_wake_pkt_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key, void *_data)
+{
+	struct iwl_mld_wake_pkt_iter_data *data = _data;
+	bool is_group_key = !sta;
+
+	/* ignore anything that is not a PTK / GTK */
+	if (key->keyidx > 3)
+		return;
+	if (is_group_key != data->multicast)
+		return;
+
+	data->ivlen = key->iv_len;
+	data->icvlen = key->icv_len;
+}
+
 struct iwl_mld_mcast_key_data {
 	u8 key[WOWLAN_KEY_MAX_SIZE];
 	u8 len;
@@ -707,11 +731,17 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			struct cfg80211_wowlan_wakeup *wakeup,
 			struct sk_buff **_pkt)
 {
-	int pkt_bufsize = wowlan_status->wake_packet_bufsize;
-	int expected_pktlen = wowlan_status->wake_packet_length;
+	u32 pkt_bufsize = wowlan_status->wake_packet_bufsize;
+	u32 expected_pktlen = wowlan_status->wake_packet_length;
 	const u8 *pktdata = wowlan_status->wake_packet;
 	const struct ieee80211_hdr *hdr = (const void *)pktdata;
-	int truncated = expected_pktlen - pkt_bufsize;
+	u32 truncated;
+
+	if (IWL_FW_CHECK(mld, pkt_bufsize < sizeof(*hdr),
+			 "pkt_bufsize is too short: %u\n", pkt_bufsize))
+		return;
+
+	truncated = expected_pktlen - pkt_bufsize;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		int hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -722,9 +752,18 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 		if (!pkt)
 			return;
 
-		skb_put_data(pkt, pktdata, hdrlen);
-		pktdata += hdrlen;
-		pkt_bufsize -= hdrlen;
+		if (ieee80211_has_protected(hdr->frame_control)) {
+			struct iwl_mld_wake_pkt_iter_data iter_data = {
+				.multicast =
+					is_multicast_ether_addr(hdr->addr1),
+			};
+
+			ieee80211_iter_keys(mld->hw, vif,
+					    iwl_mld_wake_pkt_key_iter,
+					    &iter_data);
+			ivlen = iter_data.ivlen;
+			icvlen += iter_data.icvlen;
+		}
 
 		/* if truncated, FCS/ICV is (partially) gone */
 		if (truncated >= icvlen) {
@@ -735,6 +774,13 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			truncated = 0;
 		}
 
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= hdrlen + ivlen + icvlen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
+		skb_put_data(pkt, pktdata, hdrlen);
+		pktdata += hdrlen;
+		pkt_bufsize -= hdrlen;
 		pkt_bufsize -= ivlen + icvlen;
 		pktdata += ivlen;
 
@@ -756,6 +802,11 @@ iwl_mld_set_wake_packet(struct iwl_mld *mld,
 			fcslen -= truncated;
 			truncated = 0;
 		}
+
+		if (IWL_FW_CHECK(mld, pkt_bufsize <= fcslen,
+				 "pkt_bufsize is too small %u\n", pkt_bufsize))
+			return;
+
 		pkt_bufsize -= fcslen;
 		wakeup->packet = wowlan_status->wake_packet;
 		wakeup->packet_present_len = pkt_bufsize;
-- 
2.53.0



