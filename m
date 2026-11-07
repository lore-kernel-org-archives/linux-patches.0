Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063695;
	b=OWpD2DT2ibYh5Iig8ttHfKUAow6q7y9JfRkaMjMMz2PPsvjmXgg5QsBm3SdT/uqnIfJK
	 uVPoxj7GmH2zQTKEr0Wrp+CznBoF5tOegDSI6WN+xuDNHb9An6xue15IYoY5yk/y3PyIh
	 IeRbmoh5G9dhwHdlkezll83fvyJZ2/tTLHXGUQAKkdnTK1t27eeqcu+e5XHnJwtgOVtPa
	 Ope8rDjKjIBlR/MJDJLGWeQr+dNaMYlfLD+0gFBpyqFQTOj/Hr/NtWOccFgiGPXx1iqiF
	 SQOMfSQhVcl5LMJdxqDQV0/lALb+g6fN9rvy2yX33OLcn3I5FCRskZY0m1VoHcS+BHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qxb86AznLVPc+ISUgJe+2TCczz1N9SyhMXwbeWUNvJo=;
	b=ZB6m1/BBQ8BXavaqN8p0BI+pahetXMP1eWaq2F1xc9L/A14ILtIHJraH7y5VXrry+cKj
	 u7fsHbaHOcMCeR3fd40RO9yOOblphR+GwcWdxllsGgilXzQp/DOXS7cjMUsyyk7YRiIFO
	 8MNywiFUZ+nXwAur4orEIDVGRuk8p79sW/U9Int9hj6dVJJ6B+zj1WlGxEYlshrb2G7+f
	 yWM+H8GYOqlewnx0wXj+LvpJoFcIhBRnLljSB+DKrfMAc4m7JODSoFB1u38yN7V3yv1/f
	 7FGxDL1eg2BrHIqsEE4+f2RqAJZLcbxAy0kke9QwqdaSZjQ/h+XrWhp5d2uffKBTjPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2kVzJuz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820D606A32C;
	Sat,  7 Nov 2026 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2kVzJuz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056FF1F0089F;
	Sat,  7 Nov 2026 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063695;
	bh=Qxb86AznLVPc+ISUgJe+2TCczz1N9SyhMXwbeWUNvJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2kVzJuzJDE9QEyfo+Ym/74c5nGzlW/VptK6zXblJEFlYflnrO+XVrEc+ey8bbUzV
	 Y7tDNjVrdkGzzLreso9CqpJnhaOypdLgDeu52Q1EHWP2Xl1Kl12aOlX8/8gAhFN46b
	 z8w/9Zr0Wj580BrnMZUJcyjsqnBUMUgQlG95t/SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 800/869] ixgbe: reserve TX timestamp after skb preparation
Date: Sat,  7 Nov 2026 08:58:02 -0500
Message-ID: <20261107134919.969351897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index f950570909ab2..75ba78a84c865 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9426,23 +9426,6 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
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
@@ -9507,6 +9490,29 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
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



