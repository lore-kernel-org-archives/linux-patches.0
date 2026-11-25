Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625348;
	b=DB9S4VKXYNZPbo8O27gJRtGT62siD1vufR5KLRaZwMRdfNAD3fiRie3QLCzLiDUt7qaa
	 00Io+xL3Zt1HepcdNXK6ieavLchvRqEwbialN9q5qN3uCVOdeK3V8pP0GFrCWwUu6nNuh
	 nXBqbOw0RYwbKbfBu9SKHfism+LEPOVUnFcNkGqLnuCr+YCGC0KW70Vh6RpT7VunZEVV+
	 POieIJoKC0mCB4uD2Ixr1ajt0OTYrOUs+PVqTcAfzIQHiVdIwPgYIEdZ1KnmVwNNUg0nn
	 GBqtxC45e7W+1uxy+LboiagjjNh5pUwx4s2dswA1SF/y2PsoiKs8vKgsQL5axwGsKHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TfHOOQ1wUd2uRbjVjJcnimD0ULZFUq8hlDe6WkPlRbM=;
	b=GrhbAwMbxvDw1fyhAAMWHsgksLgc7nIKZqXhxRruJiwtpt9GxEDdxtQq7/HMegJVjyuN
	 8XdpUaZyrWB/dcvJaRya7cnoluF9Q5w7QTHTlwyu6X0OnZ/A94eu2CBhA7kjS5ZWlOBv9
	 0z0EJzjBi2dHgLPjLXRURAoFoJUR+xwo/JH3hXMheZYGea++nPOVKDgKkoJNbJpFRJhLU
	 RpokU1elSgDR98vxFhOM+//yB6wJzKhFSpi0FAmQTmWta55wDDThf8JMEYttkimVGpiv3
	 kMfeGrpCN+j7TG2a5cGCdDhD1XZ50AHcWWCDY9O6VyR5QWYj/CCERrTQpp5RwogyySg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDmf25nK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B53606A31E;
	Wed, 25 Nov 2026 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDmf25nK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E581F000C4;
	Wed, 25 Nov 2026 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625348;
	bh=TfHOOQ1wUd2uRbjVjJcnimD0ULZFUq8hlDe6WkPlRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDmf25nKZMlxc7Ar+IHJNP/iU+hbk77LayZ00ZYHIKUpmw4qF8tkOAhdxNW/ypZIP
	 XaiU0ny/AfqIzDrakhAIlk62rRQjlQwo6hWwesKZkt1x85xCGYS3SY9TYU5TX44rNX
	 EO5ZIkkRs8s91M88rjfjGb+h0jJiwMPR4gQyRqjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/816] net: stmmac: set real_num_tx_queues to max(offset + count)
Date: Wed, 25 Nov 2026 15:33:55 +0100
Message-ID: <20261125143900.466909002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit d128212667593c548a3c67d30031063ed46c29b7 ]

tc_setup_dwmac510_mqprio() computes the number of real TX queues as the
sum of the per-TC queue counts. mqprio_validate_queue_counts() only
rejects out-of-bounds or overlapping ranges, so layouts with gaps or a
non-zero first offset are accepted, and in those cases the sum is smaller
than the highest queue referenced by the netdev TC map.

netif_set_real_num_tx_queues() then passes this too-small count to
netif_setup_tc(). However stmmac_set_ndev_tcs() has already zeroed
dev->prio_tc_map() through netdev_reset_tc(), so when netif_setup_tc()
runs every priority maps to TC0 and only the TC0 range is checked. A
layout whose TC0 range fits but where a later TC references a queue
beyond the new real_num_tx_queues is left with num_tc set and its TC map
pointing at queues that are no longer real, without any warning; only
when TC0 itself is out of range is the mapping disabled. The real
prio_tc_map is programmed later by the qdisc, after this call, so the
driver cannot rely on netif_setup_tc() to catch those cases.

Compute num_tx_queues as the maximum of offset[i] + count[i] instead of
the sum of the counts, so real_num_tx_queues always covers the highest
queue referenced by the TC map. This is a no-op for the contiguous
channel-mode layouts where offset[i] == i and count[i] == 1.

The issue has been reported by sashiko and the patch has been tested on
Qualcomm RB3-Gen2 board.

Fixes: 195e4f409a40 ("net: stmmac: support fp parameter of tc-mqprio")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261006-stmmac-mqprio-prio-offload-v5-1-d7da93419784@oss.qualcomm.com
Tested-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 65085f9c9290e..f29fa17584788 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1265,7 +1265,8 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 	for (u32 tc = 0; tc < num_tc; tc++) {
 		offset = qopt->offset[tc];
 		count = qopt->count[tc];
-		num_stack_tx_queues += count;
+		num_stack_tx_queues = max(num_stack_tx_queues,
+					  offset + count);
 
 		err = netdev_set_tc_queue(ndev, tc, count, offset);
 		if (err)
-- 
2.53.0



