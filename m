Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE51B332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301264; cv=none; b=kboROtl1iwFU7s6bgVSl5MOntWbCZTh6YqeGqJKgk0rk7TdEouzgUuQ5lren9pyitob3q6scTt6SYRFYV/M+sS4005MuUVGB0UjElzEQI9SvFCVvuuYbO2B5pWszn58EhG456B87rk3/C9urctnZxXC3870XnYXuBkQbsxJYV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301264; c=relaxed/simple;
	bh=HOEFadT1XOWDeWomSRq7gVuDauwBWhjeXApIjqBti40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuqGJrWri3W1vB5rCn1aSUqmNFT/qeN8qMKjLWD0jLTwtq/WjzNMF03aB6/JwknXeTXrp/lTQYxwSFy6JGbM08WjRMXzdQJuDtCE9rUWkYiMCXMsuFdvI4rCi955oM7Dw5ASvDfz/rOsM8gyEbyaHCq0XxZSDp+5h/yuFsT+bJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcrkQtSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcrkQtSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144CDC116D0;
	Sat, 28 Feb 2026 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301264;
	bh=HOEFadT1XOWDeWomSRq7gVuDauwBWhjeXApIjqBti40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcrkQtSvrXJHSaH+jIaNUROXbbQowRre46Ovwa73vMxxvSlTmOlpz6/icBmNgzoNp
	 fSktXbJ9n4GzX9pd/4REUw7ia91XXme+ERkz+TDATXh0/F12gCVEPg06zMsHpaI07Z
	 WYOVUwNfalaxz0iowCVNLnDuygEmPHOwXvcqLYpcMPo6ntrzOANziLXIrbx63KhJwn
	 GUrkcNoySpWDFNVn0HL9bdaCB2ppMKgXh9pGd+kmYCAUNZa5orll2chmJ2RmSPN7Dd
	 K7h0JyLnyFTFDX58bs+Yj9bPKBm0SPxkWzQRj+INxXrMsSHePATICLqYEzWUa+jkZ+
	 9xTC1KnhVEU1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 448/752] net/mlx5: LAG, disable MPESW in lag_disable_change()
Date: Sat, 28 Feb 2026 12:42:39 -0500
Message-ID: <20260228174750.1542406-448-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit bd7b9f83fb9f85228c3ac9748d9cba9fab7fb5a2 ]

mlx5_lag_disable_change() unconditionally called mlx5_disable_lag() when
LAG was active, which is incorrect for MLX5_LAG_MODE_MPESW.
Hnece, call mlx5_disable_mpesw() when running in MPESW mode.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224114652.1787431-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c   | 8 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h | 5 +++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 8ec04a5f434dd..2d6019a32669c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1652,8 +1652,12 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	mutex_lock(&ldev->lock);
 
 	ldev->mode_changes_in_progress++;
-	if (__mlx5_lag_is_active(ldev))
-		mlx5_disable_lag(ldev);
+	if (__mlx5_lag_is_active(ldev)) {
+		if (ldev->mode == MLX5_LAG_MODE_MPESW)
+			mlx5_lag_disable_mpesw(ldev);
+		else
+			mlx5_disable_lag(ldev);
+	}
 
 	mutex_unlock(&ldev->lock);
 	mlx5_devcom_comp_unlock(dev->priv.hca_devcom_comp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 2d86af8f0d9b8..c217998604fdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -65,7 +65,7 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 	return err;
 }
 
-static int enable_mpesw(struct mlx5_lag *ldev)
+static int mlx5_lag_enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0;
 	int err;
@@ -124,7 +124,7 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	return err;
 }
 
-static void disable_mpesw(struct mlx5_lag *ldev)
+void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
 {
 	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
 		mlx5_mpesw_metadata_cleanup(ldev);
@@ -150,9 +150,9 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	}
 
 	if (mpesww->op == MLX5_MPESW_OP_ENABLE)
-		mpesww->result = enable_mpesw(ldev);
+		mpesww->result = mlx5_lag_enable_mpesw(ldev);
 	else if (mpesww->op == MLX5_MPESW_OP_DISABLE)
-		disable_mpesw(ldev);
+		mlx5_lag_disable_mpesw(ldev);
 unlock:
 	mutex_unlock(&ldev->lock);
 	mlx5_devcom_comp_unlock(devcom);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index 02520f27a033c..46de93ed790de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -31,5 +31,10 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev);
 void mlx5_lag_mpesw_disable(struct mlx5_core_dev *dev);
 int mlx5_lag_mpesw_enable(struct mlx5_core_dev *dev);
+#ifdef CONFIG_MLX5_ESWITCH
+void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev);
+#else
+static inline void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev) {}
+#endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_LAG_MPESW_H__ */
-- 
2.51.0

