Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D6054675;
	Mon,  8 Jan 2024 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMyHKA4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A6DC433CB;
	Mon,  8 Jan 2024 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728532;
	bh=CW+Sf270tEzBr0FxvfufwJdUf6mJGwKQlOoqccldDIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMyHKA4zGshLPBOURrw5PWhm2Rf3Ip4hq2yGNQmvKlsprvjPlV1Mp0q25/y7Xjxw9
	 HCI+vUsM34jWzqsDUIk8noCMcOL3slk/ULSmBBrt0TWsQc1WXPLRvYuFFPpUXrXOAb
	 WExnE3d2UJ1kU2GJGh87M960mNp+73vhGhm6I8mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/150] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date: Mon,  8 Jan 2024 16:35:57 +0100
Message-ID: <20240108153516.056507315@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 3313206827678f6f036eca601a51f6c4524b559a ]

Rearrange the variables in the dpaa2_eth_get_ethtool_stats() function so
that we adhere to the reverse Christmas tree rule.
Also, in the next patch we are adding more variables and I didn't know
where to place them with the current ordering.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: beb1930f966d ("dpaa2-eth: recycle the RX buffer only after all processing done")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index eea7d7a07c007..59888826469b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -227,17 +227,8 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
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
@@ -247,6 +238,13 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
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
2.43.0



