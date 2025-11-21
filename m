Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42BA346782;
	Fri, 21 Nov 2025 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731069; cv=none; b=Z4SLWJIgUuQRwuOzPFW/fD7RW+164qR7TFHKk4DWUKRrOhFuAFoE8vMGt9EQ5D80CMUqN7IIp1vnPFbSZmIeWuPUqUWso7cSbg0HyPOZ5Ynu+IKJLmyu7ph99RAaUCFd5nwO1nXwGr/wTqEQbDoGipUDtYxVnXEOPtC4jHIH1gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731069; c=relaxed/simple;
	bh=1jPii+LBMyq8SxhB+S+i0+dvYgzsvZcjxlODT7+RP9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT4i3JBLckzSMEnnIP6BsY+qm+0LZZ2QrYlWCN9Y/vGRI96vVN87Cy5XqGE3rlW6SL4zHy9+U8sosesb/UOdxBC/zMGcoPQaZZn8IrgrzAd7F6PV8AD/C3pmXwYKkN/uCtVbU7IajY7m9/+HntB0lgXnqD3qw0k7SOOM2R1lHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7K5i5bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7K5i5bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB438C4CEF1;
	Fri, 21 Nov 2025 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731069;
	bh=1jPii+LBMyq8SxhB+S+i0+dvYgzsvZcjxlODT7+RP9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7K5i5bGNA1d0xCNzPOwgcq4uGSUh8ZgBKLg4l3/njDniP3Zqdt75/D6GdVQj5YHn
	 FZNOYdnYl9toAA18UgeEskWNpjkCDGa9VPokZjWB85YknYw63NobjolNin3vfHszg+
	 MIBdBDUpTi7h/c7jVq4UMlgYUfZMTUyE+3GRj1T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/247] net/mlx5: Fix typo of MLX5_EQ_DOORBEL_OFFSET
Date: Fri, 21 Nov 2025 14:10:25 +0100
Message-ID: <20251121130157.395871940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 917449e7c3cdc7a0dfe429de997e39098d9cdd20 ]

Also convert it to a simple define.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e5eba42f0134 ("mlx5: Fix default values in create CQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 1ab77159409d6..f3c714ebd9cb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -32,9 +32,7 @@ enum {
 	MLX5_EQ_STATE_ALWAYS_ARMED	= 0xb,
 };
 
-enum {
-	MLX5_EQ_DOORBEL_OFFSET	= 0x40,
-};
+#define MLX5_EQ_DOORBELL_OFFSET 0x40
 
 /* budget must be smaller than MLX5_NUM_SPARE_EQE to guarantee that we update
  * the ci before we polled all the entries in the EQ. MLX5_NUM_SPARE_EQE is
@@ -322,7 +320,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
 	eq->irqn = pci_irq_vector(dev->pdev, vecidx);
 	eq->dev = dev;
-	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
+	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBELL_OFFSET;
 
 	err = mlx5_debug_eq_add(dev, eq);
 	if (err)
-- 
2.51.0



