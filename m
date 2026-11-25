Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622603;
	b=XCkJAsITw6QoCvblZf8h+Qn2NTYxG2nsnwQGGT6fpfeaDW5BSAKoGKxIw6B8Qt53hK5k
	 oeLFmgP8/CXv2R95FsPW//R5HAYABnagpkCc8Ece3gTI6tL5+79JERxZzYOP5VN41wV7D
	 dUS1HfLZiEQIzxBWSeLjyOaz1KF0Y5SGWxW9OFE/ILM47i8rsTJYHoeUanyeQdyCkJGVF
	 tz0q8PkABK3p6t/u5127u8P3oVjm+AZUcFmgFE7QTu+2YFy662N0eueG/g3tocBmknTr8
	 AaI7mB2rd/MnkXPzFcCECSHlN4izeht6e/IxvhF22SxfHLm0pZZmoNkQX1vwy0JAxIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E6BTK5Uat2JHleW+Harwptez5HbU6vji+YCNo5NmfXo=;
	b=MSNXJQwa+sRtWl80MoySLz4TU4As1ny6LtBgE8IpRCpJa9DQa+qiNxp/Ars9/nL0/7fC
	 utyphrhcUhtj+ioyH0XH2Kuvzl202ENM2Lz7w/lowOR/QdHZgdTd1W3OKIpO1OF6ue7tW
	 jLnCqMak8/t309wyaAJnEyoJGLImuwOrIBh5QzJlms5n9fUa6hXbFlJc2v/Pch+b10LLx
	 xjak5e6xvq5lhpxGQ43So7LIolJgVduZzaTLxJurX8DwFU0QZoob2pqC2bzdy9nNjKDMl
	 mpPeFBuoXmGyDend1Hc6W0i/OxWh8/AGHMuuibsNKLTJ7v/Q4NiFurzfNHU9VJA6cXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORcONJfJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596C5606A321;
	Wed, 25 Nov 2026 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORcONJfJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A144B1F000C0;
	Wed, 25 Nov 2026 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622603;
	bh=E6BTK5Uat2JHleW+Harwptez5HbU6vji+YCNo5NmfXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORcONJfJZGS+khLzbs4dKQhHDHpVt2QmhnVAEtLDvb7C2fx/RqgCiX5rxWfpc6yqj
	 Mb9OLituna+Ai8c3WKvHvzCCvGbgWNwsIEbQcVbHyTiVz8DrfgQ/by2GUE//wMOWAt
	 Mpg0n8y75qx/CUPqs8XM9IHEIXxiA7OWgmvoRU3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 588/990] net: stmmac: set real_num_tx_queues to max(offset + count)
Date: Wed, 25 Nov 2026 15:32:35 +0100
Message-ID: <20261125143835.863989921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 49161241d0328..bd28d0e6361d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1268,7 +1268,7 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 	for (u32 tc = 0; tc < num_tc; tc++) {
 		offset = qopt->offset[tc];
 		count = qopt->count[tc];
-		num_stack_tx_queues += count;
+		num_stack_tx_queues = max(num_stack_tx_queues, offset + count);
 
 		err = netdev_set_tc_queue(ndev, tc, count, offset);
 		if (err)
-- 
2.53.0



