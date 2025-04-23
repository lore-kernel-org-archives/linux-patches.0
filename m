Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561B127CB33;
	Wed, 23 Apr 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419787; cv=none; b=SwZ4HRfx7a54MD8zv2GDFtJICt619sHhj5Py3z1NSgkIlc9RLUN8/IUU5nfYX6YRlVo6C8U1mLD6OHJP+fEuuRkaLnphOzRlNeW5gcLog3xdDa53Sgl9sjIe2qsaQDn8qqeljTTCgREkMa7KgRfi/ZqDUawB8/Oqdu7g5sExRAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419787; c=relaxed/simple;
	bh=IoqrGK5owEgWKsoU9Nv3qSdTsijndyZHDv6avjJyGA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+I9koa6iZ6QxTaI2xqgIJ3rhOLyTcY0w2T1yTuJ03EwKnNu+Hoi0QLUipTzYV91+uu5tlAceZS1DiOCn4Q0dOCAwo42Q2ApXf7URQO/tfAA3Lfp7HMNUvZ7n/gkfkfz3xJjvHyRc8flmwuSdaGHV7CPPHyvlu+bgFB2ddTvmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj7OwLNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj7OwLNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB88BC4CEE2;
	Wed, 23 Apr 2025 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419787;
	bh=IoqrGK5owEgWKsoU9Nv3qSdTsijndyZHDv6avjJyGA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oj7OwLNef1opVE+VRSrpM3uEVpOjy3NOlZdfPP+wJlarvmG+5al2mk1WbAU5LKqJz
	 GGFPTSNTAoTplO9ZAeRNFgS6XOAou6Y2Yu9ppWs8mTlPqxzw2ShxP8GIWNFnM3qlzw
	 Nykz1/BHhQecWWGCjA7tevp0QK3TkTeoILACZqsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/241] RDMA/bnxt_re: Remove unusable nq variable
Date: Wed, 23 Apr 2025 16:41:31 +0200
Message-ID: <20250423142621.626894010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit ffc59e32c67e599cc473d6427a4aa584399d5b3c ]

Remove nq variable from bnxt_re_create_srq() and bnxt_re_destroy_srq()
as it generates the following compilation warnings:

>> drivers/infiniband/hw/bnxt_re/ib_verbs.c:1777:24: warning: variable
'nq' set but not used [-Wunused-but-set-variable]
    1777 |         struct bnxt_qplib_nq *nq = NULL;
         |                               ^
   drivers/infiniband/hw/bnxt_re/ib_verbs.c:1828:24: warning: variable
'nq' set but not used [-Wunused-but-set-variable]
    1828 |         struct bnxt_qplib_nq *nq = NULL;
         |                               ^
   2 warnings generated.

Fixes: 6b395d31146a ("RDMA/bnxt_re: Fix budget handling of notification queue")
Link: https://patch.msgid.link/r/8a4343e217d7d1c0a5a786b785c4ac57cb72a2a0.1744288299.git.leonro@nvidia.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504091055.CzgXnk4C-lkp@intel.com/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index cb9b820c613d6..02b21d484677e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1773,10 +1773,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 					       ib_srq);
 	struct bnxt_re_dev *rdev = srq->rdev;
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
-	struct bnxt_qplib_nq *nq = NULL;
 
-	if (qplib_srq->cq)
-		nq = qplib_srq->cq->nq;
 	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
 		free_page((unsigned long)srq->uctx_srq_page);
 		hash_del(&srq->hash_entry);
@@ -1824,7 +1821,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		       struct ib_udata *udata)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
-	struct bnxt_qplib_nq *nq = NULL;
 	struct bnxt_re_ucontext *uctx;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_re_srq *srq;
@@ -1870,7 +1866,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nqr->nq[0].ring_id;
 	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
 	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
-	nq = &rdev->nqr->nq[0];
 
 	if (udata) {
 		rc = bnxt_re_init_user_srq(rdev, pd, srq, udata);
-- 
2.39.5



