Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC061A00EC;
	Thu, 15 Aug 2024 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732628; cv=none; b=o2aTB5PM7RRSSxDMmOI1qXWf32zonY51Yk3caMoGTF2VjXlPCqBQ0JQFRVVKVpvivZO1QvhNPZGgyNgwJY3kFeVc95WYryLZe2nf+zNWiaUhHsvMjLogkKregKSLyGgCzbchJYHEseOcfw53G4NX/5sEGpjFSQdPAHAlHMZYIEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732628; c=relaxed/simple;
	bh=8pSMzoYtEvLwBlwHtSE5Mz3eMCxqG3ZCfj1f8wGal6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1PjKR408bGup6VHSAzf3zsR6OEwYYg3H2ayoZN9Mk1lX/eOHCd1o4ciZRUDkSbznttLWCIEILbvXWyJPDrRIJ6UPgehO/Hi2QTY/EOgEhzg1vwJhjBlISuDeXxoYHPnpVGYwi8nO+7saLz799DAxonGjZ+IkaRNc/LAnoGBb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etcbuO32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etcbuO32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F6C32786;
	Thu, 15 Aug 2024 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732628;
	bh=8pSMzoYtEvLwBlwHtSE5Mz3eMCxqG3ZCfj1f8wGal6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etcbuO32VkDRSJhd0/tDeRQCDeiYz22pfoIxvUAdfyCCnulQkvz5XA8i5LvBJACxP
	 LCFxlu6TfTpg7l1adRLzfjNw3kNFdSOMZd9+LjWTDtRXeqgwoTVI736do4SRDuWd9B
	 Zj8NV0s6rhcYr3kB29foNsCoT1jh5TquhopMGUsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/352] net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys
Date: Thu, 15 Aug 2024 15:25:03 +0200
Message-ID: <20240815131928.597114687@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 3f8e82a020a5c22f9b791f4ac499b8e18007fbda ]

Since the documentation for mlx5_toggle_port_link states that it should
only be used after setting the port register, we add a check for the
return value from mlx5_port_set_eth_ptys to ensure the register was
successfully set before calling it.

Fixes: 667daedaecd1 ("net/mlx5e: Toggle link only after modifying port parameters")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d3817dd07e3dc..1fdb42899a9f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1155,7 +1155,12 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	if (!an_changes && link_modes == eproto.admin)
 		goto out;
 
-	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
+	err = mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
+	if (err) {
+		netdev_err(priv->netdev, "%s: failed to set ptys reg: %d\n", __func__, err);
+		goto out;
+	}
+
 	mlx5_toggle_port_link(mdev);
 
 out:
-- 
2.43.0



