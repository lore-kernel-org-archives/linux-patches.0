Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6339B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302582; cv=none; b=UomFwQuhDCvFBYJfFW3L6Mzitc+2Umc3iSlXh3jcvn4yCwPfp3Usri90prm8j+zifYa+Os0JP+oFSOJpJdADLvsQ2W/yA8ozXpakCW6MNZg7ngHTWERpH3fmbjrOF1GHGXzm/rHHRW/DBGqT2YXqADsigZShe6A4maAzLJ25fK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302582; c=relaxed/simple;
	bh=zlvmOJWk6SgnN/rmcm3JoQhB50VinVqqrmxylpOvORM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzVuXN++h7aDZ8izKoX9YQ4Ap7e1wokMPKyyLst8FVu4frAXDadgYwPrRsnx8eK4qdNWwHsvCE3cBhVT2i2nUqTdttCnRT1E8DZFH1DtSDdG8GA3L6TNji+uYPb6eTCjeLID6RWxugoNT4CMBj6YcyCxkX5xF02ajYSX4hwFPmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MajeZFMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MajeZFMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E4C19425;
	Sat, 28 Feb 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302582;
	bh=zlvmOJWk6SgnN/rmcm3JoQhB50VinVqqrmxylpOvORM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MajeZFMN1+A8Hsn9/hxBM+9XhYNM2y8M8iJHw0IvhE1x0ETJ8Y7+zGxB0f5x7gl5W
	 TKVTECFOMnA4bdUkgY2EDmnbIrjDT+IMDVDdY2/TkZrwKuhALgXY60LEctwOcukshW
	 N0uvwoV7LVXkIJCgYRBalvDrEVQiXDXPzNRvzMMe9VZBxnOzdIPKEFvJ6PZlFgLTj8
	 vDXznyFgyjz8sNLcC44mq+YE5E8oQO64Uz4rP+JyKXpSFVGQiap8/473QzusycxYVV
	 7mboHvM4hReICDRhpTLZpFvP1gc0HqKVmOPtLs7iuQPtcDPWm8T0jWImDKcePe+4DJ
	 CxoCAib77FZmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/164] RDMA/rtrs: server: remove dead code
Date: Sat, 28 Feb 2026 13:13:50 -0500
Message-ID: <20260228181505.1600663-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index ec3ab8df32f7d..0979bb728da24 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -212,7 +212,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -244,11 +243,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
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
@@ -281,7 +275,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0

