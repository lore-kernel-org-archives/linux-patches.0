Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37DA2DCF48;
	Tue,  8 Jul 2025 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994156; cv=none; b=ZQz785XMPWUcVtHlsy/JKsclbtOcN1WS3f51R2n8zzTb7rXKSNiC597zm83+hWX8IEzG+km+KNQzvnmDGv03SPJA9qZ8wGqbI5EVpKu96yQNNoNmETFlDFbfWNKJl/8qQJ106vcL6mtDVS7C2F2fJ6cpBrsw0/Ofu5+wNSOX9Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994156; c=relaxed/simple;
	bh=KzGj0fw+HmAYXXh0I/DtbMGyOqz/7f+qAWgLmSApOZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPs/k+PCVd5wgK2S2ivu7aSZ0d7LnCtTItyWvYYuHIePKL2LZp7yeMjz0a4xPZm343wgv2YJ763pS/buxD8D6Z7kvcrscWcXZwSqKWPtxbRp7eLElytbOrTCF5UbUq3BIUILqrGZFdE6kSz3bqJA74L1OJp9VP912gXGDici2Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQz4GZxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQz4GZxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F993C4CEED;
	Tue,  8 Jul 2025 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994156;
	bh=KzGj0fw+HmAYXXh0I/DtbMGyOqz/7f+qAWgLmSApOZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQz4GZxH6rl72Hn+afJulrmuom3qfHj67AYGv1ezXmKKRwSLnXhDH6ggd0eB8SBfr
	 eIFfZGzmARfiT5zpqzQuGgMt4ghXyYqdlAhpdoCf99zwhEY/KnGs14ov/FrwydEEjk
	 FOpwy5H5z3XgAJDnG84zoyGn6fttvel7W9O3zBlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/160] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date: Tue,  8 Jul 2025 18:23:02 +0200
Message-ID: <20250708162235.361637804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 3313206827678f6f036eca601a51f6c4524b559a ]

Rearrange the variables in the dpaa2_eth_get_ethtool_stats() function so
that we adhere to the reverse Christmas tree rule.
Also, in the next patch we are adding more variables and I didn't know
where to place them with the current ordering.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2def09ead4ad ("dpaa2-eth: fix xdp_rxq_info leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 2da5f881f6302..3a310d92ef2f7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -225,17 +225,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 					struct ethtool_stats *stats,
 					u64 *data)
 {
-	int i = 0;
-	int j, k, err;
-	int num_cnt;
-	union dpni_statistics dpni_stats;
-	u32 fcnt, bcnt;
-	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
-	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
-	u32 buf_cnt;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	struct dpaa2_eth_drv_stats *extras;
-	struct dpaa2_eth_ch_stats *ch_stats;
+	union dpni_statistics dpni_stats;
 	int dpni_stats_page_size[DPNI_STATISTICS_CNT] = {
 		sizeof(dpni_stats.page_0),
 		sizeof(dpni_stats.page_1),
@@ -245,6 +236,13 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		sizeof(dpni_stats.page_5),
 		sizeof(dpni_stats.page_6),
 	};
+	u32 fcnt_rx_total = 0, fcnt_tx_total = 0;
+	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
+	struct dpaa2_eth_ch_stats *ch_stats;
+	struct dpaa2_eth_drv_stats *extras;
+	int j, k, err, num_cnt, i = 0;
+	u32 fcnt, bcnt;
+	u32 buf_cnt;
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
-- 
2.39.5



