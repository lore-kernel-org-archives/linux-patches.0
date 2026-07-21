Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD73644B3;
	Tue, 21 Jul 2026 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662237; cv=none; b=ba7ldu/OkaHgdGHgwbXMGIfG0h1Hld03WKkExRpXpPwVq1aO1aEZRS4Ga2X4J1M+u/pgTzI+PkIa981tEcUvqmlb4Bg0LKFZbOhG4dppBOBT1e9XlBfi+TULfyQZ0efS7HcP8nv6WQ5tpm7vrTp9VC684KowcOKq7zcI3nMMdNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662237; c=relaxed/simple;
	bh=32EDPsPzMaJwFrBSaxOVT4rAEG0v9e94jn7hKX/9KMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbrL4aYFI9yxAmMOQsGy1lUC1p3AzYfxD7YXEjF2gaLWhyDOglye2K2Rf3KiwZ0P0useb1ACqEO+qlGEyOVVBYN0Lw1LSNvQ03cW5DN83kZ7Fi4aAHR9z5xTahJwGyLqvqCxLkamsDbWMIg1VHPDIhF/cKzWWOE6xu204Ducrco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnKddFSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnKddFSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3401F00A3F;
	Tue, 21 Jul 2026 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662235;
	bh=dc06jK5uB3sYWP/eh33DMahE5OOs8h5c9gsYHLefOko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnKddFSNH0oChVh86fvYG2DHI2kL6v8y4iI+5zoJ0Pbb88mscjc30MyBQwF28nyov
	 bRR+tk6LO6GeRAfhnBBZWWRHt3pG6tCbnNma9xkDPM63Ro9CfojXkmbrdsAf9tIKCk
	 8wz/1bz6kFHZNBPfJx/WlJdhS6l+04xZnLufzxlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0325/1276] RDMA/mlx5: Remove DCT restrack tracking
Date: Tue, 21 Jul 2026 17:12:48 +0200
Message-ID: <20260721152453.369454100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit b136a7af41f796a48665afc6a55907488a3d5500 ]

DCT restrack tracking wasn't working to begin with as it was only
tracking the first DCT which was added, since at creation the DCT number
isn't yet initialized because the DCT FW object is only created during
modify. The following DCT additions were failing silently.

Since the fix isn't trivial and there were no users that required or
complained about this issue we are dropping this for now instead of fixing.

Fixes: fd3af5e21866 ("RDMA/mlx5: Track DCT, DCI and REG_UMR QPs as diver_detail resources.")
Link: https://patch.msgid.link/r/20260607-restrack-uaf-fix-v1-1-d72e45eb76c2@nvidia.com
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c       | 1 +
 drivers/infiniband/hw/mlx5/restrack.c | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ded139b4e87aa4..ae0c3a24a1c9e6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3084,6 +3084,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	switch (qp->type) {
 	case MLX5_IB_QPT_DCT:
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_dct(dev, pd, qp, params);
 		break;
 	case MLX5_IB_QPT_DCI:
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index affcf8fe943c1d..76077fdfc8a93c 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -169,9 +169,6 @@ static int fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp)
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_RES_SUBTYPE,
 				     "REG_UMR");
 		break;
-	case MLX5_IB_QPT_DCT:
-		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_RES_SUBTYPE, "DCT");
-		break;
 	case MLX5_IB_QPT_DCI:
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_RES_SUBTYPE, "DCI");
 		break;
-- 
2.53.0



