Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C72E718E;
	Tue, 15 Jul 2025 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587733; cv=none; b=dm/n68ESIRmcfXdibNC+TuLjPcWoB6Ocp0cLB6Z2LSGKi7Ajq/2pY+mKOeFT9PuTIQiACP4Wv+fWwJJ2i0yjJL8Aep9JHDTzwz/8pEPjYPScGx4CEPMQ1/7alOxZE/TXDsZRx4Ehw2/9QDbnrQu4DJzz2otg3JUBHv0r3p2lckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587733; c=relaxed/simple;
	bh=mZ8Of4uskfBsy5jY3JrtDlMpI2AOQXKb8tjB7WnKVbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpkAlMlABd7HeAN3nHDFxgZx61AQIRR2lriwCJRYkdERhcfSzmBiBm86XTokSNRKE1sHayKqcxXdkKcyHj5Y5Y4CGxSPun1QOGRaXw8lCa7voExAIAnd9J5mMVSFNwrGf9q+xQN5sXaIzg7koT5o7Fehxb15lI3pR5DCkjjUTII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6mLGiEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6mLGiEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E906C4CEE3;
	Tue, 15 Jul 2025 13:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587732;
	bh=mZ8Of4uskfBsy5jY3JrtDlMpI2AOQXKb8tjB7WnKVbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6mLGiEiqq1PhP4S/jCOyHyvVo3IHY8ruxgWeLZCmlprtUaj6PvRUWMPPc4T2kHk3
	 9iIbCegHWTEWfhPVwEaGPVS0v0Cmcx/Hjo9Dab9ZdjfIh2U0A243YQKr7rFIFzlzCA
	 KpU5BrY2jhaKMOQ574wXVBAtTKfnBu0MBJPub5GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/208] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
Date: Tue, 15 Jul 2025 15:13:51 +0200
Message-ID: <20250715130815.832203954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f981a523e13a4..d7de60049700f 100644
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



