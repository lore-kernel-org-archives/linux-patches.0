Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF5820B3E;
	Tue, 23 Apr 2024 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908487; cv=none; b=CKG/oFbNUe5+oLNZ6fHSuDo1toZJc4Nzc4hu4uoWlfUoxdSFxHFw3J/r3g2iPlX7rp9KCCVKjOjulZLlCwRHgrgVDQ9mrw0jEUQAL2i8qyLjY+Rf6YDl8TJiGo7qpxVuW2HI2wwv9Z/LqqUAbG783HxOe0rRwzyQMi47I8inZqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908487; c=relaxed/simple;
	bh=i1r9BUuiZ1Vyhza9ZEPA78pYhEIlnIgTheRTq4mvbBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHg3JPrjYh2e2UMyHpKgrBtSKPDTF3rLCuNMLGQpbc91K71UHt6ZkItVbXfPNIHD1LAPLf8q/Q7j01EHOVW9rxAx1VkeyIc647i58iCxj4YbF64rBnlNhdF/KSlxtMqOrxUSL27bepTbTXhrhbbUW/OQNcBEdH0UzZIMMzjjnXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0qGiv2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0qGiv2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D263CC3277B;
	Tue, 23 Apr 2024 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908486;
	bh=i1r9BUuiZ1Vyhza9ZEPA78pYhEIlnIgTheRTq4mvbBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0qGiv2zdMUktc2ve1Rs/0iFw4EAhHjAReRrBwdux9gysx9nPOQPftD5oCbsUlkhg
	 wYLHOfcOs+0rosUUGJ/nNE49Em3xszFT9WKRC2+vBXFL8D5j9lWguxN//6PHJAwb9d
	 WSqLz5GlnPEYoMID9PJEuzAI9U24DfamA0zudlOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 026/158] net/mlx5: Restore mistakenly dropped parts in register devlink flow
Date: Tue, 23 Apr 2024 14:37:28 -0700
Message-ID: <20240423213856.718923812@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit bf729988303a27833a86acb561f42b9a3cc12728 ]

Code parts from cited commit were mistakenly dropped while rebasing
before submission. Add them here.

Fixes: c6e77aa9dd82 ("net/mlx5: Register devlink first under devlink lock")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240411115444.374475-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 131a836c127e3..e285823bd08f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1699,12 +1699,15 @@ int mlx5_init_one_light(struct mlx5_core_dev *dev)
 	err = mlx5_devlink_params_register(priv_to_devlink(dev));
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_devlink_param_reg err = %d\n", err);
-		goto query_hca_caps_err;
+		goto params_reg_err;
 	}
 
 	devl_unlock(devlink);
 	return 0;
 
+params_reg_err:
+	devl_unregister(devlink);
+	devl_unlock(devlink);
 query_hca_caps_err:
 	devl_unregister(devlink);
 	devl_unlock(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index e3bf8c7e4baa6..7ebe712808275 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -75,7 +75,6 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto peer_devlink_set_err;
 	}
 
-	devlink_register(devlink);
 	return 0;
 
 peer_devlink_set_err:
-- 
2.43.0



