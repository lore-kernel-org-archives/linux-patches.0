Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20F13790B;
	Mon, 17 Aug 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976426; cv=none; b=uqOesxiuEBAAlPyV77V35a4gt756hRq1NeNj+K9y8G5Bh83WecFVIZGwTr/cF3/39i2aLH8eNT4taoTzAY+8CgwBFu5cPVOniCOq7RSD1zFhNod7HqgX6jFXs/rMV4HSydPAu8Don7Nn557V572P5FPYYxsoBqMr6X47+59o7mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976426; c=relaxed/simple;
	bh=V3fdTsZ6xgMjuMP6rzgry8/YkPwzW7fcJK+XCi60FzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjAvbFC1oFhwd5OcWKouoHQUTakbJo+tIcbe+yD/GrPqqrmouuu9xuI04/mBOg57aAEy3GbEqynXf5DaHM8BIiqijQQMwyUSFjd5oWEvQTsK5bu5LE5dhsYjVzB6CgGc1oA/DID0G7a6WXex4QmSMXM7Sw3zAxwOL0mUKMrFoBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxjcWeO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxjcWeO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB901F000E9;
	Mon, 17 Aug 2026 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976424;
	bh=tSogiHsXdv5JynE0TpDGkS0e5+GDCqrsx3ByvlxNW1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxjcWeO1o2VLgBLm1ozSsuN5igqdKBGYrI48CxyDaKwxeLWB1A5yiPEC1SHcUyVG1
	 zTY4N7ukubW3TX6Hbvlc5nDcJ7gmUlobhqT3meN5BctgTgpLCYYp1ZBQ3gSjqHcPZY
	 sd4hxssBT7/ETUX2xDUdfADBqhpTp3WvQCo1yGEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/389] net/mlx5: Remove second FW tracer check
Date: Mon, 17 Aug 2026 15:32:38 +0200
Message-ID: <20260817132551.397609071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7e615b9978021a034124166d4fa3dc4fc0ea4b16 ]

The FW tracer check is called twice, so delete one of them.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: af39eb111ce6 ("net/mlx5: fw_tracer, return NULL on create error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c       | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f3985421e739e..a83bfdfe51325 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1205,7 +1205,7 @@ int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
 	int err;
 
 	if (IS_ERR_OR_NULL(tracer))
-		return -EINVAL;
+		return 0;
 
 	dev = tracer->dev;
 	mlx5_fw_tracer_cleanup(tracer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index a2d9904e10492..d2bf20035e20d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -208,16 +208,11 @@ static void mlx5_fw_live_patch_event(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      fw_live_patch_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
-	struct mlx5_fw_tracer *tracer;
 
 	mlx5_core_info(dev, "Live patch updated firmware version: %d.%d.%d\n", fw_rev_maj(dev),
 		       fw_rev_min(dev), fw_rev_sub(dev));
 
-	tracer = dev->tracer;
-	if (IS_ERR_OR_NULL(tracer))
-		return;
-
-	if (mlx5_fw_tracer_reload(tracer))
+	if (mlx5_fw_tracer_reload(dev->tracer))
 		mlx5_core_err(dev, "Failed to reload FW tracer\n");
 }
 
-- 
2.53.0



