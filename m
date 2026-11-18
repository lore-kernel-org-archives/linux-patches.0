Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058731;
	b=JaEdXWVv+9zI83VkyJfiYasOOvAyI+Oca96y39W0MAd3N3KLbuDoZBzGHbifU+XjhNDL
	 wMalQ3PeqFavLUOZ3pAc0LIHTE2zMSlIa2y9LqKnUtTDKFjGwth6A1LSz4g5uEyO1d63C
	 e3QYmSbq0LiG3Kjnnr6pcWtyox02k3ZV3+D3atrlzPsWwUhudhqhbZpEKIXvwyy+Dg04n
	 TvWv2aEjASb+9V45KfzOdgLm56WZpHyzWUqSywfBgyf/fajZ8BDpiRYlJoJA2Lo4Q20jt
	 +bQPu1CTG5iMaIXNYgxqwgm4iA0WYUeUocpTQCOKrFRHvARRLdDjBdyrICLyIO9Lxwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RtkcCtvl6R743rERew1eU6onNOss/raRwyox775SWK4=;
	b=J2STD5HQ+qMNAwbbTvPC7sTHV6IQGXuVIMiRqXbDMLbNVQzwRNJ9Ao9UH7CiQby62MYz
	 AR4eyX3+m9fkoo0O9SXhh1MF/1znZOGqXeuy1FvB4Sab2zB7iJ+seaKKXD5vd6BDOyrSD
	 rS+1ptrMsCHfqxem0fujrmn0PLcZzqk5GhwJAk3QdC3nKLfVXaLrY1y3wYmd0L7iSj7QL
	 3K4LIDzjDXld1X1b5juDuD16CqQO9yEU83pbP+jjZ3mpgddx9NozoM4e7aXuN7bRKBlri
	 xmKVk1DWLERixo4E3TtxAlDi+eXHTeOqIF7nZ9ivHvkz+E45pihUDpuqqa5R1w1en1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBs5KTHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BADB606A31C;
	Thu, 19 Nov 2026 03:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NBs5KTHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BED01F000C4;
	Thu, 19 Nov 2026 03:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058731;
	bh=RtkcCtvl6R743rERew1eU6onNOss/raRwyox775SWK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBs5KTHAoETZliS+HCC2KEEr8NmAc7cH6BOLAvTqL3Vfgx3dDsZlxaQqURNFTRz3b
	 oWT2AMhiHT/BoCi/X4Wn2OwXMP1bKvC4+v9LhVioakemC/hSLhdzPW02KVp9VJkYHS
	 9saeVdy3aOSUkKvAWsVDabfMc4P+LyzzblbJHe3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0591/1848] ixgbe: reserve TX timestamp after skb preparation
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118145940.158317719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit f75062536e2d45ee182828f0e47e0124be2fdc8d ]

ixgbe_xmit_frame_ring() takes an extra skb reference with skb_get()
for the pending TX timestamp before preparing the skb for transmit.
Several of the following steps may need to reallocate the skb head:

- ixgbe_tso() calls skb_cow_head(), which reaches pskb_expand_head()
  when the header is cloned (e.g. a packet tap holds a clone).
- ixgbe_tx_csum() falls back to skb_checksum_help() for unsupported
  checksum offsets, which can call pskb_expand_head() through
  skb_ensure_writable().
- With DCB and a software VLAN tag, skb_cow_head() is called to
  rewrite the VLAN priority.

pskb_expand_head() used to BUG() on shared skbs. Since commit
c7d8bc3dd511 ("net: skbuff: don't BUG() on bad arguments to
pskb_expand_head()") it returns -EINVAL instead, so these packets
are dropped (TSO, DCB) or sent with an unfinished checksum
(skb_checksum_help() errors are ignored by ixgbe_tx_csum()).

Reserve the TX timestamp right before ixgbe_tx_map(), after all skb
preparation, as i40e and ice already do. The timestamp request
remains covered on the FCoE path, and the cleanup on ixgbe_tx_map()
failure is unchanged.

Fixes: 891dc0821d20 ("ixgbe: Add ptp work item to poll for the Tx timestamp")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20261026082035.335770-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 40 +++++++++++--------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index b7672200dc624..4f935d0b86a22 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8665,23 +8665,6 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 	}
 	protocol = vlan_get_protocol(skb);
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-	    adapter->ptp_clock) {
-		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
-		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
-					   &adapter->state)) {
-			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
-
-			/* schedule check for Tx timestamp */
-			adapter->ptp_tx_skb = skb_get(skb);
-			adapter->ptp_tx_start = jiffies;
-			schedule_work(&adapter->ptp_tx_work);
-		} else {
-			adapter->tx_hwtstamp_skipped++;
-		}
-	}
-
 #ifdef CONFIG_PCI_IOV
 	/*
 	 * Use the l2switch_enable flag - would be false if the DMA
@@ -8746,6 +8729,29 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #ifdef IXGBE_FCOE
 xmit_fcoe:
 #endif /* IXGBE_FCOE */
+	/* Reserve the Tx timestamp only after all skb preparation:
+	 * skb_get() makes the skb shared, and pskb_expand_head()
+	 * (reached from skb_cow_head() or skb_checksum_help())
+	 * refuses shared skbs.
+	 */
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    adapter->ptp_clock) {
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
+					   &adapter->state)) {
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
+			first->tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
+
+			/* schedule check for Tx timestamp */
+			adapter->ptp_tx_skb = skb_get(skb);
+			adapter->ptp_tx_start = jiffies;
+			schedule_work(&adapter->ptp_tx_work);
+		} else {
+			adapter->tx_hwtstamp_skipped++;
+		}
+	}
+
 	if (ixgbe_tx_map(tx_ring, first, hdr_len))
 		goto cleanup_tx_timestamp;
 
-- 
2.53.0



