Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4949884;
	Mon, 18 Dec 2023 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkUYbJE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF1FC433CA;
	Mon, 18 Dec 2023 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908005;
	bh=rBE6FbeR4kHNmy81tG97WSgTRtB8Cl+Gq6/f6u2JsVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkUYbJE2wloUvN5mCht4gWZw4SoJbUVwTU8XXmf4Q3BZ7ltDtFmzxWwj1iHKCMd/m
	 73TxhfqP/+02irTox1T1O0X9G8YKUafqfYaBwmzWKmAEE1YHMutFoMjnyUcfAzynwj
	 hxtKRm2IzafAT4XaJ7NAhLjLzWVSWL+HxpM5jHmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/166] net/mlx5: Fix a NULL vs IS_ERR() check
Date: Mon, 18 Dec 2023 14:49:45 +0100
Message-ID: <20231218135105.800107139@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ca4ef28d0ad831d2521fa2b16952f37fd9324ca3 ]

The mlx5_esw_offloads_devlink_port() function returns error pointers, not
NULL.

Fixes: 7bef147a6ab6 ("net/mlx5: Don't skip vport check")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 825f9c687633f..007cb167cabc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1503,7 +1503,7 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch,
 						 rpriv->rep->vport);
-	if (dl_port) {
+	if (!IS_ERR(dl_port)) {
 		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
 		mlx5e_rep_vnic_reporter_create(priv, dl_port);
 	}
-- 
2.43.0



