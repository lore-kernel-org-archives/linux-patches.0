Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029078;
	b=WMw1va20hj2YQV7RV9LFhsbG/D+qsI6ASgNaYAecNvhoSGaw7I1VA0ror93Dgo5EGudT
	 ElfoflFZJK3EfAhe7dr03CFhgkFG/+DQBpaJpj2Tsr+HhmHK8REsMVflD5F8ENfqkl/xm
	 nKkDzRFt6lXwKRFuM5E08ejKYkQqgojPHs9C20fSYhbMiFmRP5r+qnT7eKid2WmlP7Db4
	 Kmwx1u0Y1gXUrBbs0zYJl1MXKo3YWD/5hG0NaQ5qpAoZzLMn6qOR61O7oEnaiLfYTNj+R
	 kqzIiJJZhCD5Oo8XaF34/EQ036vdaEBPIPFdNKj47CTgPW2Li9CWyIRcWTn4cTyQ0bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mvd2oQMas/90xrdlx95UUpAov1YBu3jotNzGM9ffTKA=;
	b=34RQ/iLzGRvLbzteebp5ippnzMwel65on0ckHdaBXDh/+BNHCDw4HKStjSILQwOtYNzq
	 Fr4uIsG+U4ZUxo6mciNzz7br6ExnD8uCXhUQi9ucecmfUkmS9e+28dzNkK5MMWDzXuZ3+
	 f0uCQL24Eux2OEp8I8BdWLGNUnPuA1MBAGGvk9isse9Tq5Dx8l+xM5+m4Ot6eb4iZupge
	 hwvueBDRqHxKsB9LGcXlpt/uKeJfPdiqxxjWo7ppxfA0tlHPNxDl/Fi4tn7s4W19Gi/GN
	 mNzaEdTNk9Pvtp1aJgwnyds6r7DQJtuXHe6pcko2GCABLQpFe2xQ5ZqW3dsAHgvttuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yqG/VCyf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989B6606A31C;
	Wed, 18 Nov 2026 19:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqG/VCyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A242E1F000C4;
	Wed, 18 Nov 2026 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029078;
	bh=Mvd2oQMas/90xrdlx95UUpAov1YBu3jotNzGM9ffTKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqG/VCyfFqVhyGDC/1ILZERtoXr+o/yFY4nLKQBk8NjMTnwVOlV0AmpP3E+sj7U54
	 WZDcyNQBdiRaERlWQqbIbLl1bF+qI4jAFQqo4yA/GtSIs9F76rxTWgvIgQ6ZCiW8mc
	 xSiy982+Oh0zqPmSFqZnWSqZHyiN9ERcb57LX4Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kerneljasonxing@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0223/1756] wifi: free SKBTX_WIFI_STATUS skb tx_flags flag
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150017.174247941@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 76a853f86c97b348dc96e75a6e6f94d8750715ee ]

Jason mentioned at netdevconf that we've run out of tx_flags in
the skb_shinfo(). Gain one bit back by removing the wifi bit.

We can do that because the only userspace application for it
(hostapd) doesn't change the setting on the socket, it just
uses different sockets, and normally doesn't even use this any
more, sending the frames over nl80211 instead.

Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20250313134942.52ff54a140ec.If390bbdc46904cf451256ba989d7a056c457af6e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: e035900ffe9e ("wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.h     | 3 ++-
 drivers/net/wireless/marvell/mwifiex/main.c | 3 ++-
 include/linux/skbuff.h                      | 3 ---
 include/net/sock.h                          | 2 --
 net/mac80211/mesh.c                         | 3 ++-
 net/mac80211/tx.c                           | 9 ++++-----
 6 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 689f68d89a440..33ccd0b248d4e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -7,6 +7,7 @@
 #ifndef WIL6210_TXRX_H
 #define WIL6210_TXRX_H
 
+#include <net/sock.h>
 #include "wil6210.h"
 #include "txrx_edma.h"
 
@@ -617,7 +618,7 @@ static inline bool wil_need_txstat(struct sk_buff *skb)
 	const u8 *da = wil_skb_get_da(skb);
 
 	return is_unicast_ether_addr(da) && skb->sk &&
-	       (skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS);
+	       sock_flag(skb->sk, SOCK_WIFI_STATUS);
 }
 
 static inline void wil_consume_skb(struct sk_buff *skb, bool acked)
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 2a9eae68d9ba1..c2b553194b780 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/suspend.h>
+#include <net/sock.h>
 
 #include "main.h"
 #include "wmm.h"
@@ -943,7 +944,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	multicast = is_multicast_ether_addr(skb->data);
 
 	if (unlikely(!multicast && skb->sk &&
-		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS &&
+		     sock_flag(skb->sk, SOCK_WIFI_STATUS) &&
 		     priv->adapter->fw_api_ver == MWIFIEX_FW_V15))
 		skb = mwifiex_clone_skb_for_tx_status(priv,
 						      skb,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index df548a3d60657..41c78025d8aa5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -480,9 +480,6 @@ enum {
 	/* generate hardware time stamp based on cycles if supported */
 	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
 
-	/* generate wifi status information (where possible) */
-	SKBTX_WIFI_STATUS = 1 << 4,
-
 	/* determine hardware time stamp based on time or cycles */
 	SKBTX_HW_TSTAMP_NETDEV = 1 << 5,
 
diff --git a/include/net/sock.h b/include/net/sock.h
index efa549885b7f8..a39b2349bf9b6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2760,8 +2760,6 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
 			*tskey = atomic_inc_return(&sk->sk_tskey) - 1;
 	}
-	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
-		*tx_flags |= SKBTX_WIFI_STATUS;
 }
 
 static inline void sock_tx_timestamp(struct sock *sk, __u16 tsflags,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 258c865921784..23467fec56e5c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -8,6 +8,7 @@
 
 #include <linux/slab.h>
 #include <linux/unaligned.h>
+#include <net/sock.h>
 #include "ieee80211_i.h"
 #include "mesh.h"
 #include "wme.h"
@@ -782,7 +783,7 @@ bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (ethertype < ETH_P_802_3_MIN)
 		return false;
 
-	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
+	if (skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))
 		return false;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b4ee237378612..260fced04ecc4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -26,6 +26,7 @@
 #include <net/codel_impl.h>
 #include <linux/unaligned.h>
 #include <net/fq_impl.h>
+#include <net/sock.h>
 #include <net/gso.h>
 
 #include "ieee80211_i.h"
@@ -2965,8 +2966,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     ((skb->sk &&
-		       skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS) ||
+		     ((skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS)) ||
 		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
@@ -3868,7 +3868,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		return false;
 
 	/* don't handle TX status request here either */
-	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
+	if (skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))
 		return false;
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
@@ -4792,8 +4792,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 			memcpy(IEEE80211_SKB_CB(seg), info, sizeof(*info));
 	}
 
-	if (unlikely(skb->sk &&
-		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)) {
+	if (unlikely(skb->sk && sock_flag(skb->sk, SOCK_WIFI_STATUS))) {
 		info->status_data = ieee80211_store_ack_skb(local, skb,
 							    &info->flags, NULL);
 		if (info->status_data)
-- 
2.53.0



