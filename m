Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029082;
	b=BQ6E8ETw0k/4ILVrQRv2fEjUdqSSGSNEKn+QC6u6rWswOd9jZBG5oSLYaoFRsDXRQgJ4
	 rnR29OhH5D7KFYZNQeR47Lb7Adri+4eMpjWGeRrVRouJ8RoQhpDdKbIKFIyau1FYwZQFa
	 IBalTU82d9mxz4hw2U/sYzgEU3BvXu5ps+MNko/BSGmkp8BJk5kKDwSWFqJ5sXLQx3tpG
	 VyOt9V2j57p7TswTZJd6RDaVi8yXwV9KnLu/wpSmKi8lOxGZ2iHyGnGa6X9Tr0vvsyhEs
	 MFDSbxh5KzyJHBnAJtBqrKRrmtQxwrzjuykULHs0wIqFTGtMlavzokkC+0cSEbwCW7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iDOHQugVpz0fWZiRbB2hCSHKLb20vfTLMrpN8WbwpTg=;
	b=cED8JyTApT38kaL35en5MqHbZCV7aqCMBsbjStUiL0sKMHazHN+vuOqUI6RCen6cvyVE
	 3d76TWccXUWqbHFaCtxrUYZGX1ORKwI2kvGSsXCvatmrJWDakg1Eas+HfjNZca6nCUx7B
	 Re/fTtqmBd6c9c3MrnAZls8xGdZHg0e3kwvaAmlNEBRLKAZj3tdjPZBDZxEqqzKBRp1Xz
	 tulwbJGPK/7BxReDgsleZEKKqhezF5w/0v3CvPOLtqGy55Wg1bX0f2SyRE3P7IFn1Uxja
	 r0R9yP54KyEMSLEp+EoB7h59/jsc21XOw8ikSByau9M4sQgO8U2XRhI3iiA15okTkvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vkg0XcTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B54606A31C;
	Wed, 18 Nov 2026 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vkg0XcTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9411F000C4;
	Wed, 18 Nov 2026 19:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029081;
	bh=iDOHQugVpz0fWZiRbB2hCSHKLb20vfTLMrpN8WbwpTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vkg0XcTxPNtGFd6wI3LQcJIV7F9ZRpxooQdCQTjI6uAZsw9aWFuLcBGO1iTftp6FN
	 8T3afK4UvGs7TIMK8v8z3xB8Asw6zColSO2hqsmiw4LZ+3v6yzkOfmQoo+4SZzWxoy
	 xQrNA0hpRtpY2/CzsJQppT0zsi+jWmxbw67uFkmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Bert Karwatzki <spasswolf@web.de>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0224/1756] wifi: check if socket flags are valid
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118150017.209254998@linuxfoundation.org>
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

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit d7500fbfb12067ee7313f13f4c58f771be3018ab ]

Checking the SOCK_WIFI_STATUS flag bit in sk_flags may give wrong results
since sk_flags are part of a union and the union is used otherwise. Add
sk_requests_wifi_status() which checks if sk is non-NULL, sk is a full
socket (so flags are valid) and checks the flag bit.

Fixes: 76a853f86c97 ("wifi: free SKBTX_WIFI_STATUS skb tx_flags flag")
Suggested-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20250520223430.6875-1-spasswolf@web.de
[edit commit message, fix indentation]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: e035900ffe9e ("wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.h     | 3 +--
 drivers/net/wireless/marvell/mwifiex/main.c | 3 +--
 include/net/sock.h                          | 6 ++++++
 net/mac80211/mesh.c                         | 2 +-
 net/mac80211/tx.c                           | 6 +++---
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 33ccd0b248d4e..fff8b7f8abc5d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -617,8 +617,7 @@ static inline bool wil_need_txstat(struct sk_buff *skb)
 {
 	const u8 *da = wil_skb_get_da(skb);
 
-	return is_unicast_ether_addr(da) && skb->sk &&
-	       sock_flag(skb->sk, SOCK_WIFI_STATUS);
+	return is_unicast_ether_addr(da) && sk_requests_wifi_status(skb->sk);
 }
 
 static inline void wil_consume_skb(struct sk_buff *skb, bool acked)
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index c2b553194b780..20d1e6cd83c95 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -943,8 +943,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	multicast = is_multicast_ether_addr(skb->data);
 
-	if (unlikely(!multicast && skb->sk &&
-		     sock_flag(skb->sk, SOCK_WIFI_STATUS) &&
+	if (unlikely(!multicast && sk_requests_wifi_status(skb->sk) &&
 		     priv->adapter->fw_api_ver == MWIFIEX_FW_V15))
 		skb = mwifiex_clone_skb_for_tx_status(priv,
 						      skb,
diff --git a/include/net/sock.h b/include/net/sock.h
index a39b2349bf9b6..79e409bf3d13a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2844,6 +2844,12 @@ sk_is_refcounted(struct sock *sk)
 	return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
 }
 
+static inline bool
+sk_requests_wifi_status(struct sock *sk)
+{
+	return sk && sk_fullsock(sk) && sock_flag(sk, SOCK_WIFI_STATUS);
+}
+
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
  * Check decrypted mark in case skb_orphan() cleared socket.
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 23467fec56e5c..d32affec4e65d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -783,7 +783,7 @@ bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (ethertype < ETH_P_802_3_MIN)
 		return false;
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))
+	if (sk_requests_wifi_status(skb->sk))
 		return false;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 260fced04ecc4..3b72b38d9e278 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2966,7 +2966,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     ((skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS)) ||
+		     (sk_requests_wifi_status(skb->sk) ||
 		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
@@ -3868,7 +3868,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		return false;
 
 	/* don't handle TX status request here either */
-	if (skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))
+	if (sk_requests_wifi_status(skb->sk))
 		return false;
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
@@ -4792,7 +4792,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 			memcpy(IEEE80211_SKB_CB(seg), info, sizeof(*info));
 	}
 
-	if (unlikely(skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))) {
+	if (unlikely(sk_requests_wifi_status(skb->sk))) {
 		info->status_data = ieee80211_store_ack_skb(local, skb,
 							    &info->flags, NULL);
 		if (info->status_data)
-- 
2.53.0



