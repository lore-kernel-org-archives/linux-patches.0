Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3134B346E6D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302169; cv=none; b=RmZMJ4Gb1L2sXQTuEwJ6ZzITY2faWHvAOY8sUR8gQ4To79BROYJRvCfZvpnp4F9trkegloggv6q+FPzz7icEn2YHT6gpstoGKXKvY98GL7Y8uwS86S9mrn4nx77o+/hAjVRFOFfwejTgobRn8Meya+hDYxxWXR4MgZpQfn09RaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302169; c=relaxed/simple;
	bh=ysn+qBNErJKt8uI2XM8jb5xe3jx2cTxOqROs6Bp9N0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBFHPhbVEdUefpESqLVVsN2oYdaL1BHIdLCP0L4ruRfUSu9ccgJRxvnLD5qTCb9zYS+7NIS4scVgWCuYU7ZuVjr15NSTqjRaQ/KlG2KMi0cn/Ybv2es5Op3KMi4QKUC2bzri4xat/huPT++parQjdqhL4MbF8szmjo4orAXb4qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsQREqEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsQREqEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93972C116D0;
	Sat, 28 Feb 2026 18:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302169;
	bh=ysn+qBNErJKt8uI2XM8jb5xe3jx2cTxOqROs6Bp9N0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsQREqEBO+3ixWjFPDuh//OSTlJzNaumZJsrvHYWvudIMKP8bbmH3jpwjl0PJWYzu
	 7/oRP17N12e+unqkL9Wh8qCeha2uMZwXH9p5qUAckN0HW3ViBO1UOY7DSM72GXsYGs
	 j7WBi25i8/v47awNIevI1zztPNWHT7AsNpmmtDao+TgLRA+1+ap3PmbGwYJh/eurkr
	 owO6D2mr1WcR674VnOkHgrcc8C/gDunSb/82riJcqopefHFbY2lEkxGMjBHWOWOuLN
	 947K7YCRX75U0A0hOFPI55FHykH7EB4K0cv0JE+KjI7OVaRH4BoY9hyKX+zsEevUco
	 quMMAO8BPJVWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/283] RDMA/rtrs: server: remove dead code
Date: Sat, 28 Feb 2026 13:05:08 -0500
Message-ID: <20260228180709.1583486-166-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5dbf315630c1a..f0beea7b90f25 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -205,7 +205,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -237,11 +236,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
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
@@ -274,7 +268,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0

