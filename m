Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D7B14B094;
	Mon, 16 Sep 2024 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488633; cv=none; b=oR/uVnb8bTURuMx4YvQG/l/ES28ry5b3LFE8SdzJIefLzGDoqYqoovbb/RYWerL9kZeBzaxavB/tl1Eq51V0/F4D8LeUeC5e+BnxYbEMa4RCNANcDiA2twBloUGSwLpeTwViq2EupAujEyCdKU854dIkibJZG8zN1UJShTOROts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488633; c=relaxed/simple;
	bh=mwHDxBCTf+EckuUhpn4BTTTKGCAJ2QbaOQtZ7WAg2MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBbLmV+VqlmJp0lFd/SincYt7vo/dRUd9KkGSjLTw2dICn1PVab/umf9lskqMamoHwDFKJZTs2CrpOI2hr7Y1CvH0cIFi0Gprm5B02JSKGszyab+DmuczajUmmouGfBXmhDSfS4BFws1FdYzZx5CnV6BKcPCkbyWp3yDqT5qTFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jX6rZwqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jX6rZwqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B488EC4CEC4;
	Mon, 16 Sep 2024 12:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488633;
	bh=mwHDxBCTf+EckuUhpn4BTTTKGCAJ2QbaOQtZ7WAg2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jX6rZwqOAGvlIu0W0ryBIX+ua2WoGXzfoVarMfOogJs1HgAwGf0ksflsleZFEIGIV
	 MMZ+fWIGuT6LwmbkEbmnAuhypxELx73bcJLQbv211xQ5JFcYy4jiH/LsSosVe34WWw
	 ZCCRxBw2FqqWUhWbVb4pMhUlJk/IPigzMKG24guU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/91] net/mlx5e: Add missing link modes to ptys2ethtool_map
Date: Mon, 16 Sep 2024 13:44:36 +0200
Message-ID: <20240916114226.471118212@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 7617d62cba4a8a3ff3ed3fda0171c43f135c142e ]

Add MLX5E_1000BASE_T and MLX5E_100BASE_TX to the legacy
modes in ptys2legacy_ethtool_table, since they were missing.

Fixes: 665bc53969d7 ("net/mlx5e: Use new ethtool get/set link ksettings API")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 50db127e6371..f973314b1724 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -136,6 +136,10 @@ void mlx5e_build_ptys2ethtool_map(void)
 				       ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT);
 	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_100GBASE_LR4, legacy,
 				       ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_100BASE_TX, legacy,
+				       ETHTOOL_LINK_MODE_100baseT_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_1000BASE_T, legacy,
+				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
 	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_10GBASE_T, legacy,
 				       ETHTOOL_LINK_MODE_10000baseT_Full_BIT);
 	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_25GBASE_CR, legacy,
-- 
2.43.0



