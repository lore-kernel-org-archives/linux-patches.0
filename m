Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54A34403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301829; cv=none; b=MQFOjqfpk/83i6RXLvLkD4rwJpKF28eOIF7GIGOn8BhLjrtAoy8qpcASi1LaKqFGdz6Uv8pGqR7NXq6Zf9Nc1n1pvkSuPqyl5zkfOk2dqUAmDL5Y6TQTxgHMkfBMW+zVfY+dFjEtvLY8x0yH5sDEm6XBgDctm2xYfV7w8pof+II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301829; c=relaxed/simple;
	bh=O0wTXUwvzZTTpfNctWa+Frh9oQAmn6ypXxXr39Pit1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6Ojv/RC5TxJ2OrFL/191PCOFcaENhdBYum2hs7K3+sEzKL6NWq7PZA2ulxg7fGDS8qTNEeLWMTIlDK37GD2gYWi6SyXY4abwG/v+0FU4+/Z6h+vPnldZ7acp1AevReXKZqHTsiOC1B/cGjmF3twWso/1t7938C3ZDTP1U7JrSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8LgMthJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8LgMthJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF30FC19424;
	Sat, 28 Feb 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301829;
	bh=O0wTXUwvzZTTpfNctWa+Frh9oQAmn6ypXxXr39Pit1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8LgMthJ6TCY7KNThU6g32niVbs5Z2FRSr0VUMYIlmGsJpLY5IBOkoHqzZlTK/WQ+
	 ndHk7DUrsCjavZerTPeGXN0PLPMVqHZHLWa5CaxSCRZ3xz36MlrF/m3n7JGDvM5BFW
	 DVvo0I4IW+D1F/+PmW6GxsdD6JB8ew6tHenKHCvOEXN25dYJ9BmcoJqQJheQiAg33u
	 476kE8rvCD5sDD6Lrl2hApr/XlIwQLtm0L5xhQcH5NsT6CIoQKYOM0RG8GPUHK6HJR
	 AwF4kloY/CHCRdkV7SGcuEqrXLps+qXW6wjoWeTrCpaLTmmvfFJNoOn445pqUGQzDy
	 SC5RyVvWuZCIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/385] RDMA/rtrs: server: remove dead code
Date: Sat, 28 Feb 2026 12:57:47 -0500
Message-ID: <20260228180011.1568201-245-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Honggang LI <honggangli@163.com>

[ Upstream commit a3572bdc3a028ca47f77d7166ac95b719cf77d50 ]

As rkey had been initialized to zero, the WARN_ON_ONCE should never been
triggered. Remove it.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20251224023819.138846-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 9ecc6343455d6..7a402eb8e0bf0 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -208,7 +208,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -240,11 +239,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	wr->wr.num_sge	= 1;
 	wr->remote_addr	= le64_to_cpu(id->rd_msg->desc[0].addr);
 	wr->rkey	= le32_to_cpu(id->rd_msg->desc[0].key);
-	if (rkey == 0)
-		rkey = wr->rkey;
-	else
-		/* Only one key is actually used */
-		WARN_ON_ONCE(rkey != wr->rkey);
 
 	wr->wr.opcode = IB_WR_RDMA_WRITE;
 	wr->wr.wr_cqe   = &io_comp_cqe;
@@ -277,7 +271,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0

