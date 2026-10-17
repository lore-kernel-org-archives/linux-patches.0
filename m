Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0622F767;
	Sat, 17 Oct 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253523; cv=none; b=DSGLMnH86+jiqYsKWiFzBsT5dkDLmwOg0NWwPH8C0fIyyPMb+ealHB1hpK+KIboGouHXxzllEAbc4BUixrv1CRIoNYIF5dtvoNOm2ffxAbvv+4J2lWXYhUaOnSZo6rpg2vgT/fmxATevbJLgzy8pGhRw1jBk2AX2ZK9mBtg3XuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253523; c=relaxed/simple;
	bh=4nwRWKXXO5jTU1sai1UddElEZ5zyNJDZ7QI22cAQxCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdjffLOPsa+PH86p1oE3XUQKmQllXQFPiajaCGr0UAQfvs0WpMVQAY0Cr8+Qsf7mkT7QLJeX7+R27v2EkPL8B7KhXtgvsuhm5Z/4xsghBgskwhVOCk5/EeJo5ID7tOCEt8c1dPTDAfAGqvVrPPVnXYgYwSoefQ7iqp8Y6smweKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh9bbfFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh9bbfFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970F11F000C4;
	Sat, 17 Oct 2026 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253522;
	bh=C1TnFiBMgnvpqFHhgLz689mJiCFoCAuBazVCyT2+T4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh9bbfFyj9ttU8bAyFqL6orFibHiUGoqNu0jeGaz0vybnd1QhoKbjDSvM5LIZ8+/d
	 LeOEmMJcRcMsgZadElMCFVwwCN2LhxfqsqKYeSVvC6fP/hT0Y1IswTHqrAzXGEK9GO
	 J1tTDWhsogAIp0X72zb8LgRk1lfYU3Qt7IzaoZDs=
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
Subject: [PATCH 6.12 145/869] net/mlx5: Fix typo of MLX5_EQ_DOORBEL_OFFSET
Date: Sat, 17 Oct 2026 17:49:46 +0200
Message-ID: <20261017160040.757554293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4241cf07a0306..c53efb0711e16 100644
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
@@ -331,7 +329,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
 	eq->irqn = pci_irq_vector(dev->pdev, vecidx);
 	eq->dev = dev;
-	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
+	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBELL_OFFSET;
 
 	err = mlx5_debug_eq_add(dev, eq);
 	if (err)
-- 
2.53.0



