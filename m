Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC93146A79;
	Mon, 16 Sep 2024 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488639; cv=none; b=CIfnKSfuSHfdqcR2gEaTm3SGFdzluzPYOZxxhr8nRXKPtFC5aiXRIgJ8jAzf1CDbGC17xq+qf6Z+ggCv7mQ3GHCeFxlJ1JlnI9ee1K1fQQ3BovY+W9ngYCkqnBuRpX+Kk7yoNIL8ctyDzwMnKrL2V04Gi99KEDPQgGdp6uQbhrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488639; c=relaxed/simple;
	bh=2h7UeTQn+OQ8nCdaIKvuhTgJB+5sg0DMCSLhFwXFnqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0lcUdRLqm9nd5C4sk3nOxTah2bclIU45gaZR2XKSj/16fjophFCWVPVji9kLp9XwcslrP6DutmuwbxuBQhD8TZSWs37D5Xvi6eE1a6dYRtgeAnluNeyfUjwyylqjiVu460Uw7xZreARX7fBFUoeBnTOR7OEhRr96HbnT5yVv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDvsMmrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDvsMmrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66849C4CEC4;
	Mon, 16 Sep 2024 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488638;
	bh=2h7UeTQn+OQ8nCdaIKvuhTgJB+5sg0DMCSLhFwXFnqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDvsMmrdV2sa2/OGdAnZ+cbj3uOzn5g7M0TdZHtmXdR4GTHzFepPnTgoPb312uHfX
	 cgvu3EBoDxa/OqSiX/HGKabdiYWxpJXblVDHdkzXGNAB+LiGlRenTeA41kz21b3aAu
	 jQqOhiPjn6gk02NpAngkTfnECuPviyis7PSuAgbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/91] net/mlx5e: Add missing link mode to ptys2ext_ethtool_map
Date: Mon, 16 Sep 2024 13:44:38 +0200
Message-ID: <20240916114226.530447133@linuxfoundation.org>
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

[ Upstream commit 80bf474242b21d64a514fd2bb65faa7a17ca8d8d ]

Add MLX5E_400GAUI_8_400GBASE_CR8 to the extended modes
in ptys2ext_ethtool_table, since it was missing.

Fixes: 6a897372417e ("net/mlx5: ethtool, Add ethtool support for 50Gbps per lane link modes")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f973314b1724..54379297a748 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -205,6 +205,12 @@ void mlx5e_build_ptys2ethtool_map(void)
 				       ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_400GAUI_8_400GBASE_CR8, ext,
+				       ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT);
 	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_100GAUI_1_100GBASE_CR_KR, ext,
 				       ETHTOOL_LINK_MODE_100000baseKR_Full_BIT,
 				       ETHTOOL_LINK_MODE_100000baseSR_Full_BIT,
-- 
2.43.0



