Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57ED359A62
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302400; cv=none; b=gHoM9vsqRqc5BtTJ38QewnSDgj+lIo8rSZ0qtKA348JW5/LKiT3tFZzxgWl/AVDIRywg31haxiPG+70i7/6oC9KHMqLZF/Ob2LuORCddhH+GnOnNJHZ6Zsw/Cs+X29FRoUPhIpuKjnGGJGtuiLvOc6IDEMGrMxsctll8DBRxVCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302400; c=relaxed/simple;
	bh=IUQnGUypTUhmQeXFI0MkQUo1oQVw0P8WaCKX1EgzFwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUHjReG7OtAyTo5OVZqJDLDq2UCSywunfCXVALzlBr3Dza/XxR3gOUAIxLQvQ8e95dYQTlRlUECUo06W7FopMI2H8MRSugstVPz/mFtHbG+1lo5CKZC9fa8Dyb2IKK8xhBpHCeMKEH63s2Nb/QaaRKJzmaGOdZ3o/lLMwd1IGt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCFD0puH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCFD0puH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54476C116D0;
	Sat, 28 Feb 2026 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302399;
	bh=IUQnGUypTUhmQeXFI0MkQUo1oQVw0P8WaCKX1EgzFwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCFD0puHArji1ytfQbY2iOLk+Xu1BtIErrIoXafxbMMWJUG0Oy3o4pc2mpffC1V0q
	 sEbGJHJfraubebxpTlZE3XDy0GtQEMOjVFO4T/3HDmFl4o+zrBJIZALAqYvb6Q6NNc
	 E5bgsiLHfUAqfJuHwcusekYrRz+bAfy9Io1dnI4i1eLNdSptnftiC8DAn5l6tyeKNz
	 qoDXhHSay6XUX4XgCSn98nibTn3rkLL12n3f/YW6FGwqJwvhqVwnk0qODuQB1FdvGO
	 nL2XJf/KeHOijzsQSe2ra/gyVl1+/f3nRyifaHi7wkcjflVXBUaVqNxd7FoSnDGU71
	 QPx7lY7PTO4AA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/232] RDMA/rtrs: server: remove dead code
Date: Sat, 28 Feb 2026 13:09:43 -0500
Message-ID: <20260228181127.1592657-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 51ec4620ca821..b69d6c5c9442b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -203,7 +203,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -235,11 +234,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
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
@@ -272,7 +266,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0

