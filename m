Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BFA191F66;
	Mon, 22 Sep 2025 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569701; cv=none; b=qBYOZWUSX5lzJsqEzCYGH9hQJmigVWbbiFDgXimwwREj/povX2xgRZP/gsf7muMmwFk7+PxYDiAf/8mjA5NikrRvBpyqwLeY/2usFD2vM9aHQizxDIU+m1FGhGvDH4HtXPKND8m8FQ+6ZuNX1uEZ313dBBF/aWWdSHn/j5WTyio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569701; c=relaxed/simple;
	bh=UZnfHnJF2Ek5MiBF/FSur8X8rpz6u7OUA/+BqOE6RHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwP9jr+7vZhd0QrrgI+vOlpQ/wNWT/Z41Duggp52mj7k83er35+J7cBiIhmEObFo0Q9gjsrZ6xZUEEmm1VUffWV7le2oP9IHdrs5pRCaM6TxLAi9GvxRdzgSz6uoeUT7UqEYAfUxBnd42AhwF0URdnDzslPYGtRPhdGtCblNq24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WO2Yi7O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WO2Yi7O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB54C4CEF0;
	Mon, 22 Sep 2025 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569701;
	bh=UZnfHnJF2Ek5MiBF/FSur8X8rpz6u7OUA/+BqOE6RHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WO2Yi7O6otIIElOwvey56a6WQq50WOwPyjT7eFdpLvAFuvCqb13puCWiUKAvAIM5u
	 FnL+zteCdFGpVAAeLe/RAz49JJ8Izvih9wZfemf8GG3nOG1TpYCj0tHFENf4vzRytB
	 uOemo7qRGk0/icOmpcMCyUvG7Rqtjj8Yk9tr/FQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/70] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Mon, 22 Sep 2025 21:29:22 +0200
Message-ID: <20250922192405.156458650@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 3fbfe251cc9f6d391944282cdb9bcf0bd02e01f8 ]

This reverts commit d24341740fe48add8a227a753e68b6eedf4b385a.
It causes errors when trying to configure QoS, as well as
loss of L2 connectivity (on multi-host devices).

Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/20250910170011.70528106@kernel.org
Fixes: d24341740fe4 ("net/mlx5e: Update and set Xon/Xoff upon port speed set")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d378aa55f22f9..09ba60b2e744b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -109,8 +109,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (up) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
-		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
-						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.51.0



