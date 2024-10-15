Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB21E32AF;
	Tue, 15 Oct 2024 11:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992283; cv=none; b=CQUyHPig28SONdY78q4C6DL02bNxsNH4oXZCreac0aFqJqGDQ9TBBUMEOQML9m3jVw7fjUkcKUCco/BVOW5rBhYLQT522CHHapfJW/8E0ifBIfxV18lEQEwYC7kDBwW1cftRhjb2gFkcdrkUa/8B8YY38tPXK8NOYf9SoiXn6dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992283; c=relaxed/simple;
	bh=wgguHSVvPnKoz4X++Jpqz4EyLw3N59frdDuKyOWA4ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD288uw3Xxb9NtpRHGS38fhuIcy2NlME89G9uEyOZV46gfYZNzAThbzRlQWYZHyelx3ZVaLHaN6M1AwomsE39DV7kf4cNbIklvO3M5JThg3Ha0BfYTB66MY8G+Uvl4jic/b3GDNYrDPD/e2Tvsxu4gy2WuAjR3Clj5hZTvwOTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eghobOiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eghobOiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC2C4CEC6;
	Tue, 15 Oct 2024 11:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992283;
	bh=wgguHSVvPnKoz4X++Jpqz4EyLw3N59frdDuKyOWA4ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eghobOiwMhpMgFgZBk8odj/s7Mgyas9yQPfOrJ/SJWaezQUCftcLot3a2N5MIQcQf
	 oX8OAkFS2a0MAeKFX3cipR3hRtgxyjua4JZVt8i2pdScnH3y0hpFveyBEc5WNGqAY6
	 2kUJOP7sNhBR4vgaMaDY58QFT0hQKC9VldfeNp38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/691] net/mlx5e: Add missing link modes to ptys2ethtool_map
Date: Tue, 15 Oct 2024 13:19:52 +0200
Message-ID: <20241015112442.091513183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 06f6809b1c2b..a9080e3ecd84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -129,6 +129,10 @@ void mlx5e_build_ptys2ethtool_map(void)
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



