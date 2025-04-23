Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25E22918CE;
	Wed, 23 Apr 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422063; cv=none; b=IXVw6pYhINdKE4FrNDLnw6cOU/yuxOkRCsLY8rsEclsHrXDD+KUjdYJJ1I/Bh12SA6qKMa6rzmiZD7DWvDd71k2toR3FDEQV4CzKYZkCBagWCZfhOYzCc7wRhaBlw6FA/3yd+2gwOW34TQD1L2pDMPvw5Ilq9HBdvmkx8n/FWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422063; c=relaxed/simple;
	bh=jx7nKo2v7Q4mHjBec5nf73HmK37Gj7u95S6uF5FDfMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8YKQiVKYrZpH3pPUTe4385c+sUO5IFbNvRpqmpPlSJj12bkSLPfyr8FTIuNhPLbw3s6j/SYNWQz9ZDZRzYu+KIeMJ3T/3aupCiVJYUPTUogAFO41ycLSprMgYfBc9Lw2qIEJyzoruat4tRafjFGgbIdlc0oIam+/8zuw9ktEXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLQeFvT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLQeFvT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822DFC4CEE2;
	Wed, 23 Apr 2025 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422062;
	bh=jx7nKo2v7Q4mHjBec5nf73HmK37Gj7u95S6uF5FDfMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLQeFvT76SuM6wMtwmMOj+mICxxrstKlYNqbtYZNLW6Tes5r1GRaaxgP0sCdgC/cU
	 35bdBqyth2tFLTOoJZ/bireTA0zB5a8gfgDD1I2rcDwX5Am/DLImkuXqPuNtC9X3BZ
	 EgJKB/h9s57qpkrNwr7b5CQBXmsbSc0t0VJjK5KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/393] net: ethernet: ti: am65-cpsw-nuss: rename phy_node -> port_np
Date: Wed, 23 Apr 2025 16:42:47 +0200
Message-ID: <20250423142654.552452012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 78269025e192ec8122ddd87a1ec2805598d8a1ab ]

Rename phy_node to port_np to better reflect what it actually is,
because the new phylink API takes netdev node (or DSA port node),
and resolves the phandle internally.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20240528075954.3608118-2-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 903d2b9f9efc ("net: ethernet: ti: am65-cpsw: fix port_np reference counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 +++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8ffc1fbb036f9..dbca0b2889bc5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -626,7 +626,7 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	/* mac_sl should be configured via phy-link interface */
 	am65_cpsw_sl_ctl_reset(port);
 
-	ret = phylink_of_phy_connect(port->slave.phylink, port->slave.phy_node, 0);
+	ret = phylink_of_phy_connect(port->slave.phylink, port->slave.port_np, 0);
 	if (ret)
 		goto error_cleanup;
 
@@ -2076,7 +2076,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				of_property_read_bool(port_np, "ti,mac-only");
 
 		/* get phy/link info */
-		port->slave.phy_node = port_np;
+		port->slave.port_np = port_np;
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
@@ -2217,7 +2217,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	}
 
 	phylink = phylink_create(&port->slave.phylink_config,
-				 of_node_to_fwnode(port->slave.phy_node),
+				 of_node_to_fwnode(port->slave.port_np),
 				 port->slave.phy_if,
 				 &am65_cpsw_phylink_mac_ops);
 	if (IS_ERR(phylink))
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index f3dad2ab9828b..f107198e25721 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -29,7 +29,7 @@ struct am65_cpts;
 struct am65_cpsw_slave_data {
 	bool				mac_only;
 	struct cpsw_sl			*mac_sl;
-	struct device_node		*phy_node;
+	struct device_node		*port_np;
 	phy_interface_t			phy_if;
 	struct phy			*ifphy;
 	struct phy			*serdes_phy;
-- 
2.39.5



