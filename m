Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62742157031;
	Mon, 29 Jan 2024 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548155; cv=none; b=pr7J+AWT+Uk3lGjL6dmdfsRebget1DflZDXi5vODm1DOqVVRk+B0Ta/3SEdoXE/C3Vc/iViaGvsLTjoTov95ZSSmQKyQG7N2Zcb4CKA4bR7gjsRYJD8oEOXjdFQvvye0jYbAKWNSt9uq5tVaVTU1TNnvjGkLDrayYCpJ7H/g5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548155; c=relaxed/simple;
	bh=Syh6LFDqr7Et1FBgwdRAfqT2xBBnwAjC2630qAFtPAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHQNfdOgHv7kQdv3nKJ3t85+L3uqwWg7A2bTGSc1AhH0kVnwHT+1DAvjdRHyHT37ARabR1BwnYcKWecB/9p/a9LQUaphAfky0rOj68AinnK0SV/p65YXavt3yXLGgstfaBNDC/1m1MFdgumQcxEjoy8U4N1qac9LBvFtp+/beNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JD2QTsyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JD2QTsyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E89C433C7;
	Mon, 29 Jan 2024 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548155;
	bh=Syh6LFDqr7Et1FBgwdRAfqT2xBBnwAjC2630qAFtPAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JD2QTsyxZzPPjlEtzk9KwX/WwSvI9T+Q8q+u1nXvB8F9Sk7M2JezuKgFSHnn8SAIL
	 NgoRYK/MVX5WmRkkI8QkX6coCv2FJPSN+UTg//1QqfzHG/dF/co1NFcj4ZNqBWwiW9
	 Pj4iBh7aVP1rOKoB/LTLPVtiJisaGq0AohrnC7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 193/346] net/mlx5: Use mlx5 device constant for selecting CQ period mode for ASO
Date: Mon, 29 Jan 2024 09:03:44 -0800
Message-ID: <20240129170022.079755027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 40c7be124041..58bd749b5e4d 100644
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



