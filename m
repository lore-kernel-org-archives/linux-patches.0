Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214136;
	b=aS7IMhh1pYIstS/md1cIK73JV11KpPHMCDh+fooOEJvSHjjK5VOMechIFM2M9g0eVBu/
	 fbjOFq6RkaPJ4hbe/zWlx0XYV/wdif8t+l5dmlCI0CGRp4Udi2qKnrrrd4+gpUwam+5Cq
	 ZpW8U4rOaknW3kAmC2x9iVIQXSSCzGu1Z658CKG4KKTbyEwYLSs5JHBzxIld4RBa834mT
	 xYPvFEf7AioTCTtTZUyGG+pMfMc4QtP9/LZH+UlQgyM462qIsQjnqwO3AI1AtGYfmGKvD
	 aOqx/GOzNCn0tpdlM7MKQHWAGsirKT36PCsrffg/fJODEWGQwY9GexCt3m8rLRTAGaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuvW/uCg9CJNnqF1WP6m+ISK4vthN91wIBcfbtPor1c=;
	b=y69xwx8h6R75A6E+m7wr4bmAFFe/bRqvqeAxrUvR360GtpyvlCnHBcS74G5EQFvSHlZU
	 7CArcIyDpXdo3BQTWLsXTcNU4cxHDRH8OTh/2RYRgcU7OEuZUwV8CpTogzqa7ZCXvtCMJ
	 +92TI2ocXmwAdNu1H3FQXF8jgN5DAdMcVr6YfDnXJj0NPQKnMGM9ieSeuRQR5yrkQ1Bci
	 /SeI4skjCltGWhWBzE9zY+Fij8anjbJSbXEYdoKsmGByabvR3eAM12VnkPbTZrzIoIgbk
	 1kTuyCVRcezXNQt1nznMpE2X7b/8zhYt/vkkryeBpJmiM3TrPZI/AXy5tv8p5FJtHxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gzC/hhc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50545606A31C;
	Wed, 28 Oct 2026 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzC/hhc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680C81F01825;
	Wed, 28 Oct 2026 19:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214135;
	bh=YuvW/uCg9CJNnqF1WP6m+ISK4vthN91wIBcfbtPor1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzC/hhc/f2Dr16lnBqGCczxOcKxt33iaf78k2a1MEUtyWIpT9W30cXmv1I92JkYTJ
	 gOIrz82SM+w/twv9B2NsQ6ItNRo5mUbD2qED9xc5YrVtDZS7kyHFr5/prUibQzAzeX
	 TWYAWmvfnSFQ4yu/4sAGe2dOQ/etgp3WQIIgz2ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0751/1887] net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC
Date: Wed, 28 Oct 2026 17:47:27 +0100
Message-ID: <20261028170516.534790739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit a562d0c4a893eae3ea51d512c4d90ab858a6b7ec ]

Actually ENETC VFs do not support HWTSTAMP_TX_ONESTEP_SYNC because only
ENETC PF can access PMa_SINGLE_STEP registers. And there will be a crash
if VFs are used to test one-step timestamp, the crash log as follows.

[  129.110909] Unable to handle kernel paging request at virtual address 00000000000080c0
[  129.287769] Call trace:
[  129.290219]  enetc_port_mac_wr+0x30/0xec (P)
[  129.294504]  enetc_start_xmit+0xda4/0xe74
[  129.298525]  enetc_xmit+0x70/0xec
[  129.301848]  dev_hard_start_xmit+0x98/0x118

Fixes: 41514737ecaa ("enetc: add get_ts_info interface for ethtool")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-5-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c         |  3 +++
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 80eec93f99870..ce15034234392 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2713,6 +2713,9 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 		priv->active_offloads |= ENETC_F_TX_TSTAMP;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
+		if (!enetc_si_is_pf(priv->si))
+			return -EOPNOTSUPP;
+
 		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
 		priv->active_offloads |= ENETC_F_TX_ONESTEP_SYNC_TSTAMP;
 		break;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index d4623a41f0137..71c64317c5b85 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -772,6 +772,9 @@ static int enetc_set_coalesce(struct net_device *ndev,
 static int enetc_get_ts_info(struct net_device *ndev,
 			     struct ethtool_ts_info *info)
 {
+#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+#endif
 	int *phc_idx;
 
 	phc_idx = symbol_get(enetc_phc_index);
@@ -791,8 +794,11 @@ static int enetc_get_ts_info(struct net_device *ndev,
 				SOF_TIMESTAMPING_SOFTWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
-			 (1 << HWTSTAMP_TX_ON) |
-			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
+			 (1 << HWTSTAMP_TX_ON);
+
+	if (enetc_si_is_pf(priv->si))
+		info->tx_types |= (1 << HWTSTAMP_TX_ONESTEP_SYNC);
+
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);
 #else
-- 
2.53.0



