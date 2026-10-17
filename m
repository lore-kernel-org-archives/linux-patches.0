Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1BF39F18A;
	Sat, 17 Oct 2026 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254482; cv=none; b=BTqoMXzG1D361dxFqyOrXw8Y9A1n0CvDYRFS+FhTLi8CYnQopSQ6b1rl218sq9AhXBDcGJZs06z5DVx5c7SR/304mN20yNketQLMYed+dXexqDe5ZCF3b4FvsK/XW1byRZ487l3uS3pYiEWi7X/sQ4kjBav88ORCulqbLJ3KPe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254482; c=relaxed/simple;
	bh=0fpRjgENVzRShw5MhVylh3iawLPDEwEgjbYSyd66eYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly3JUQZKlVBcPrD58HJE7j8InApRme1M1+fnodtRJ/yNoSTJBiN96bnqi/lX4dN/+LtusqZqWZpyLvJ/n8va60B+vfuQcvF4unj09NPni4SJbQkNL4FsX0zuTNXwTyJ8LY6bimBLZv56vqGUJ3O0uPsXHthnunnPyaFyO5ROVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVBOZYfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVBOZYfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A859E1F000C4;
	Sat, 17 Oct 2026 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254481;
	bh=5mKtPKdiaKRadAhoYrsWW3aPbpJ+hvueXi7JwKd4RWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVBOZYfBIIP+ix/t0Wqb17KdvZUSvMTfTz/SH8Zj9gWm5owP6eDCaDUqahXIZWGNR
	 v7Qew8O+9PPLuuROMPMH1ztrlCpG3MfD5kltUk8+x4whg4TVi/FebAu+cvotmYBX3t
	 a+wAd8i6b6Y4XpauMrnKow4jonuyQmnaqWQQo3+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/869] RDMA/bnxt_re: Remove unusable nq variable
Date: Sat, 17 Oct 2026 17:55:01 +0200
Message-ID: <20261017160048.927089003@linuxfoundation.org>
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
Stable-dep-of: 131e2918b9b0 ("RDMA/bnxt_re: Free SRQ toggle page after firmware teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 7a17088186cb7..d2c3038aad69d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1722,10 +1722,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 					       ib_srq);
 	struct bnxt_re_dev *rdev = srq->rdev;
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
-	struct bnxt_qplib_nq *nq = NULL;
 
-	if (qplib_srq->cq)
-		nq = qplib_srq->cq->nq;
 	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
 		free_page((unsigned long)srq->uctx_srq_page);
 		hash_del(&srq->hash_entry);
@@ -1773,7 +1770,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		       struct ib_udata *udata)
 {
 	struct bnxt_qplib_dev_attr *dev_attr;
-	struct bnxt_qplib_nq *nq = NULL;
 	struct bnxt_re_ucontext *uctx;
 	struct bnxt_re_dev *rdev;
 	struct bnxt_re_srq *srq;
@@ -1819,7 +1815,6 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nqr->nq[0].ring_id;
 	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
 	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
-	nq = &rdev->nqr->nq[0];
 
 	if (udata) {
 		rc = bnxt_re_init_user_srq(rdev, pd, srq, udata);
-- 
2.53.0



