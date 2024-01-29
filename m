Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6439157050;
	Mon, 29 Jan 2024 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548327; cv=none; b=j5lQ1/jb/w6U+LNGAmxkpGVzbCOrHHDOx0xSxqLVv+MkkW/Du6Mv0B7Lc7xBCHeK2uXniHK5NiHKKDD5lCayqrzTOd54yBJcremm6LmCzhD3SYAprHgk2BSbvM5QsopmnKrbWILYo36BgEM2iF7nQmAvMGmoTCIZDpxw8bynq9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548327; c=relaxed/simple;
	bh=n52wBGp3Qeoc5sCG/yH6DhCYT0Faib9p1cd2uoolju8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iP8YQeAgIs1sfd/G0U9U1MTIMaXDWyVNug/zJYPkQka5J1Bq8UJzTa+2C9DDyrmfcgsljbsw14p4TJqXq0VDntNzFFDyIsi/1vtB6FZR9FOBlmMKSpkCn5t8D6d/vm+y2YIMEqAMvLxox4EjrzQT3i+tfzTaEmTDHqilDU9XpCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKL1kiSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKL1kiSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD79CC433C7;
	Mon, 29 Jan 2024 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548326;
	bh=n52wBGp3Qeoc5sCG/yH6DhCYT0Faib9p1cd2uoolju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKL1kiSyvd07BkJPqe9nUouEukCP+pM7A51m3WwiDpFRsf4uSjYlA9XX3oQ0ehje3
	 6+0tn1giFpRLBsw3de133MZczvYzdmv1ReY2O6U7PCNP7v++diPT4l8arJwkh+0WoT
	 wVPSEzJ1K/vS2NZSTf2ML6n3+21td0IQAGIZG6WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/185] net/mlx5: Use mlx5 device constant for selecting CQ period mode for ASO
Date: Mon, 29 Jan 2024 09:04:57 -0800
Message-ID: <20240129170001.712692265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 20cbf8cbb827094197f3b17db60d71449415db1e ]

mlx5 devices have specific constants for choosing the CQ period mode. These
constants do not have to match the constants used by the kernel software
API for DIM period mode selection.

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index c971ff04dd04..c215252f2f53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -98,7 +98,7 @@ static int create_aso_cq(struct mlx5_aso_cq *cq, void *cqc_data)
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf,
 				  (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas));
 
-	MLX5_SET(cqc,   cqc, cq_period_mode, DIM_CQ_PERIOD_MODE_START_FROM_EQE);
+	MLX5_SET(cqc,   cqc, cq_period_mode, MLX5_CQ_PERIOD_MODE_START_FROM_EQE);
 	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
 	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.uar->index);
 	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
-- 
2.43.0



