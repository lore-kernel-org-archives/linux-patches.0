Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FF546F48C;
	Tue, 21 Jul 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656783; cv=none; b=coKyKnEOPXr1m4r9p3wGfVnoUneXPaMGPUKocJi5sxC+dGTqV89HMmNOf0eVg72RYWJrsU3FSCZSpwyMJmPmBHSElGllvqkHZJarvJXaVfyrKFyhVGkoFG+II278nIofgO8LEisu6nEYxP2StuQ6WnTcmumU78foQx3UUUM9vm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656783; c=relaxed/simple;
	bh=WJxpGE7599hmPxHv2ukiI+kqxXXK8OQXb1G+03ovyJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWBz2gS2dL36KI+7FgVlm2RbVsRqhDyWNKsWrEVwd2jgExR1Ls6Ot1hvHs3n8Hxv/PetgA2xRvn9aaRdHxw5hIzKXWQNWTKKv1VqXfpboffposDCjHHVsVDVRjp/KxnSSTT/PT5EvgedF++lKgC1wobdBAV8W+11n3IYIbKkfr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8Mo6o3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8Mo6o3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14B41F000E9;
	Tue, 21 Jul 2026 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656782;
	bh=oJSvbr2dhVcd4bxEH22X1qhUER6yaXHTqdTO/Tw9y50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8Mo6o3eFWSsW31AZlti+4EH4zdP/nlAGiMafIClTdEOUXL+k7fdC8a/v22EWsIZP
	 E5FTAiDIgRD36ANjgzsJ9iNlqOBiYtYmUNE2yXm9hdOREyRIIFU5KZ9RYNJmvYM7lO
	 E/XvJEiBROajOmYDdD8Ndc3u2RC/X8i/dkm6e30s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0473/1611] RDMA/mlx5: Remove DCT restrack tracking
Date: Tue, 21 Jul 2026 17:09:49 +0200
Message-ID: <20260721152525.964459426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 88724d15705d4b..67294cac625bfb 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3111,6 +3111,7 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	switch (qp->type) {
 	case MLX5_IB_QPT_DCT:
+		rdma_restrack_no_track(&qp->ibqp.res);
 		err = create_dct(dev, pd, qp, params);
 		break;
 	case MLX5_IB_QPT_DCI:
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 67841922c7b877..00a9bcb2603f0b 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -178,9 +178,6 @@ static int fill_res_qp_entry(struct sk_buff *msg, struct ib_qp *ibqp)
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



