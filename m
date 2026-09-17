Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D0849D5AF;
	Thu, 17 Sep 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667835; cv=none; b=oVj05fk4T1J2QiJa5lWAXzu6rQmtHYfnV4+mXJ4q1Re9NPMcP/tOLqBK+OmAJCANMCu9uxZamblBLx/BmLH839WXpA8TxJNlXN/jE3rXhYIcruY0qnnCyv8DYctbnJiJLx4UoxcywY38XQHWg7G7Wmxu/h+sMfMkDdGG4vyICxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667835; c=relaxed/simple;
	bh=fCYCF/Zs9AVQIqBSXCBv9RhEl66kuV/0tzjs6g1Ndu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpsC3Scj6rVC5Mxv9lw8iW8gvnCBBn7qzz6xQ/xC0228gqOvGGo4aSK8p9CMfyT6SQNBsT+5pwQyTIqkIFqF+dr9Iggf5sucUKUB+vRrNXk/0SJFsqj0eYCXcj7KJdmxpmlDEH3RlbD1QNns/vcc8fgHih3/TBlHcLK3GG+r7oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgngC6lC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgngC6lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198F71F000FF;
	Thu, 17 Sep 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667834;
	bh=WFvO13201fgGTYaoNfcak1UkEBVCrmTGSFPO89tGc/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgngC6lCEM75bZeUDO1QsQwK67oPdt1P2Eczt8e7a6qSuh1LGDfxLfTuYus/Mk+0C
	 P38uAWa6gP7FzwwLVfH21j0GQrfE41NrLL6ykZ23HUC6QwPJtzBV9CCGj4sdP4NRw1
	 /1yoBOYu3YelzBykocyX9d5AX8gmu9Js+AfbB54g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0226/1102] RDMA/irdma: Fix typo in SQ completions generation
Date: Thu, 17 Sep 2026 16:02:49 +0100
Message-ID: <20260917151545.254905775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Cyrill Gorcunov <gorcunov@gmail.com>

[ Upstream commit b548a6c4eee5c428663f3944e173e6c92e2e8d6f ]

When we generate completion for SQ the opcode while being properly read
from ring buffer is ignored when written back to completion. Seems
to be a simple typo.

Link: https://patch.msgid.link/r/ahjB87k54bYdFbft@grain
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index a88f93b961682..45c3f82887eff 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2473,7 +2473,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
 			cmpl->cpi.wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
 			sw_wqe = qp->sq_base[wqe_idx].elem;
 			get_64bit_val(sw_wqe, 24, &wqe_qword);
-			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, IRDMAQPSQ_OPCODE);
+			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, wqe_qword);
 			cmpl->cpi.q_type = IRDMA_CQE_QTYPE_SQ;
 			/* remove the SQ WR by moving SQ tail*/
 			IRDMA_RING_SET_TAIL(*sq_ring,
-- 
2.53.0



