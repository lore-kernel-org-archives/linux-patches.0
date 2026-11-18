Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059280;
	b=34g3dWlsMA2fEaOAPmkbUA/+WZ+wfyDuNQWEbl/uL+VcCH+bUPiZKeDSV6i53iS6aj/l
	 XabfnFyxw8iFn0yTrRiwr3zjB0KQRDN0uhCuZEwUeLs2OfXt8AnNJmAv4VIXDVRpwDHAD
	 +YDYwr8A8TBs2NouMnXA4FA9ILVbYi9anZoB62ERA6xDh6MPduIuysuVTobpDaNtn5LSq
	 zgqYi/wtdQrxyPrS3Bmgo+6avj9mEhiQSVP8ZG+23LV2p5AMPPZsrrxDgvg65YPVTF2fn
	 48Y7FZcOP1O0k11uLFPp6Eh+AapKqpQpL30DCgs2N12C1qIILb9kcliba7vaIDjAuOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ei5Tqp+SinMrv2DJ5D/xXhETxnrXxASI6Qa5ZB4MGM4=;
	b=YCX4FAdEUqkqnXQ9gJZGlfv+thH27pFqHXviMWSeOeHMBbret3UHFjjOEzaIJ0EjNTGb
	 p1E51BmAtuTfGet6LJ/SvPZLFa9LuNCDdaLNIKbWs2DSGmMtYC7P8VzjhB1OrVcQ7uuaa
	 QKVNO/KIZlzrHPWDn6jI/AOV8BhdY3qntziDo6SlQwLDie4TtcuBg3DnWy7pqVIeuhr23
	 MtNoassWrVYkYsECD6gXBnIMlPJgoI3GODO2K34yhEuiLPJvOiSUWDAg92u6ddg75VGDc
	 XOofIXIQhwKGwHdZY/VC0TIEEGsFE6UqqsD90PV4jnjIMFzjd0Hs68RyefDHBk9M5Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJnPKggk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86526606A325;
	Thu, 19 Nov 2026 03:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJnPKggk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCFF1F000C4;
	Thu, 19 Nov 2026 03:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059280;
	bh=Ei5Tqp+SinMrv2DJ5D/xXhETxnrXxASI6Qa5ZB4MGM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJnPKggkWCZuaCiiq0+quJ0ALeoYOo+ZipQOCKJJUQWtJXkB6GRz/CPkZ+L3hMLNN
	 LZQD4kHa4MITvYAvCxksLLVE7lpsDfwzryNHaZXBdbx31ekm16I7K8XhNg7LE+2Evh
	 POiNP398tdYwEiminIzS6MtQJzLOaxCuGgGQHAtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Musto <federico@rimpianto.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0784/1848] net: atl1c: drop oversized RX frames instead of panicking
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118145949.284801351@linuxfoundation.org>
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

From: Federico Musto <federico@rimpianto.com>

[ Upstream commit c4ba1716853de5178a9df785844ebb5e397a80e6 ]

atl1c sizes its receive buffers from the netdev MTU plus a fixed set of L2
overheads, which comes to 1522 bytes at the default MTU.  A link partner
that sends a longer frame - in practice a MikroTik CCR2004-1G-2XS-PCIe,
whose RouterOS side defaults to l2mtu 1600 while the host stays at MTU 1500
- makes the length reported by the RX return descriptor exceed what the
hardware wrote, and skb_put() then either includes bytes that were never
received or trips skb_over_panic and takes the host down.

Compare the descriptor length against buffer_info->length, the length the
hardware was given, rather than against skb_tailroom(): the skb carries 64
bytes of slack for the DMA erratum, so tailroom is larger than the DMA
buffer and a frame in between would pass the check and still be delivered
with a tail the device never wrote.  The same test rejects frames shorter
than ETH_HLEN + ETH_FCS_LEN; before this change a reported length below
ETH_FCS_LEN underflowed in skb_put().

The frame is dropped with kfree_skb_reason(SKB_DROP_REASON_PKT_TOO_BIG) so
drop_monitor and the kfree_skb tracepoint see it, and counted through
dev_core_stats_rx_dropped_inc(), which survives atl1c_get_stats()
overwriting the hardware counters on every read.  It also counts as work:
atl1c_clean_rfd() has already recycled the RFD, and the refill at the end
of the poll only runs when work_done is non-zero, so sustained oversized
traffic would otherwise drain the ring and stop RX.

Tested on a MikroTik CCR2004-1G-2XS-PCIe (4x AR8151) in a Proxmox VE host,
with atl1c built from a DKMS tree carrying this change: the l2mtu-1600
traffic that panics the stock driver is dropped and counted with the patch
applied, and received normally once the host MTU is raised to match.

This complements commit 36c2009d90f2 ("net: atl1c: fix soft lockup on
out-of-range tpd_cons read"), which fixed the TX side of the same
"host dies while the card resets" problem.

Fixes: 43250ddd75a3 ("atl1c: Atheros L1C Gigabit Ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Federico Musto <federico@rimpianto.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
[ Federico Musto: 5.10.y has neither dev_core_stats_rx_dropped_inc() nor
  kfree_skb_reason(): count the drop in netdev->rx_dropped, the counter
  dev_core_stats replaced, which dev_get_stats() adds to what
  atl1c_get_stats() returns, and free the skb with kfree_skb().  The RX
  loop is atl1c_clean_rx_irq() here: work_done is an int * and the refill
  at the end of the poll is gated on the local count, so the drop path
  bumps both.  5.10.y does not have the 64 bytes of RX slack from commit
  86565682e905 ("atl1c: Work around the DMA RX overflow issue"), but the
  skb can still be larger than the buffer mapped for DMA, so the bound is
  the same and only the comment is reworded.  Build-tested only, not run
  on hardware. ]
Signed-off-by: Federico Musto <federico@rimpianto.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 46a293b8a21c9..1a930cdf285cf 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1844,6 +1844,40 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			break;
 		}
 		atl1c_clean_rfd(rfd_ring, rrs, rfd_num);
+
+		/* A link partner whose l2mtu is larger than ours can hand us a
+		 * frame that does not fit the buffer the hardware was given:
+		 * the descriptor reports the untruncated length while at most
+		 * buffer_info->length bytes were written.  skb_put() of such a
+		 * length would pull in whatever the tail of the buffer holds
+		 * and, past the end of the skb, trips skb_over_panic and takes
+		 * the host down.  Bound it by what the device actually wrote
+		 * rather than by skb_tailroom(): the skb can be larger than
+		 * the buffer mapped for DMA, so the two are not the same.
+		 *
+		 * Frames shorter than an Ethernet header plus its FCS are
+		 * rejected by the same test; before this, a length below
+		 * ETH_FCS_LEN underflowed in skb_put().
+		 */
+		if (unlikely(length < ETH_HLEN + ETH_FCS_LEN ||
+			     length > buffer_info->length)) {
+			atomic_long_inc(&netdev->rx_dropped);
+			if (netif_msg_rx_err(adapter))
+				dev_warn_ratelimited(&pdev->dev,
+						     "dropped rx frame: %u bytes, buffer %u\n",
+						     length, buffer_info->length);
+			kfree_skb(skb);
+			/* atl1c_clean_rfd() has already recycled the RFD, so
+			 * count the drop as work: the refill at the end of the
+			 * poll only runs when count is non-zero, and
+			 * sustained oversized traffic would otherwise drain the
+			 * ring and stop RX for good.
+			 */
+			(*work_done)++;
+			count++;
+			continue;
+		}
+
 		skb_put(skb, length - ETH_FCS_LEN);
 		skb->protocol = eth_type_trans(skb, netdev);
 		atl1c_rx_checksum(adapter, skb, rrs);
-- 
2.53.0



