Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B116431E51;
	Tue, 21 Jul 2026 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662244; cv=none; b=WCj6K8++ieLeNhL3YpP4ZSVaXDUc2kQFpJJAtiXILJmIOpSIRSa/j3YiI7GhXgN6P6P95tBaFYMWgZGzr+kV5lobqQm50Am0X1P+r3l0JsZYH7K3wfcnCPhE3Wf1G84EkSwGlUV9bZVso7HizpbP3SMKNgFlFm4tYO/m7rlDAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662244; c=relaxed/simple;
	bh=XzhaY/+JWG5DD+jEAkzAaTRymT4xCyeXO+GlgIdkzrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To7aKKlG65v3fIuH6KUsqW/eGT3MUmxn5xgbCV+p6PHBBEek7Ky7jo4jsXllUv96F4t8uPYxK1AunzPb+bOFk0KFBxp04zx+zucZ6T/9QiYzA1kuahDJjziktOt2IEyJe5Qc96s97u68mLOKcIXLbvHPP2PDuiWFnIuR8Fl82K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTAtKFLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTAtKFLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B58E1F000E9;
	Tue, 21 Jul 2026 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662243;
	bh=+0ZPi3sZLRPI7AR8Mk479zS1IM+rNwge5Ui01TnN93I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTAtKFLcHM/wtdA5JGieIqOQy5Q0pqv4x1VhgR1D2FrTxswhodz64DZs8EM6YwEDw
	 fZRZ0MoF+5OjcDc/n8Iaw3PS6GOiGb0iBqi5h/Hf0BVZhwwLsek35XfB2KYK4kTzxU
	 AMkAuWicz9c8/hqPmQMqh+bLbE2esP/VKVGQtxSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0328/1276] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW=E2=80=91provided=20UAR?= =?UTF-8?q?=20index=20rather=20than=20the=20SW=20one?=
Date: Tue, 21 Jul 2026 17:12:51 +0200
Message-ID: <20260721152453.436528570@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 449ae7927152e46acbe5f19f97eafdae6d3a96b1 ]

Free the UAR index returned by the hardware.

Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")
Link: https://patch.msgid.link/r/20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f5d0eb60db2a4..edd38510c0259c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2412,7 +2412,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.53.0



