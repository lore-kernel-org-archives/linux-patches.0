Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB235AC21
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302723; cv=none; b=SO4EwxI5FBqJR3AX7Cde8yiPaLfJibg5OB6RRDXQ08VXPPYjqUcqjhYqqmV2Ub6EYaBDfP07arF8cO4jOwmdTaGXaPxMTG+sXumUjLRVktcx38kEUMVNdtEWLiXAVwdQtH2ERJlHrvsEayt4KeQfYRzHRWf0w8fl6UG/PX1oJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302723; c=relaxed/simple;
	bh=Nl4CpR+ieGzP27GaSCtiB9rsqmCYkJI/g0tDi3jeJS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwTrpfIO99fOcKHv27XnH9/rXJnPpxsf4dH3EEOQFACdYf0pKuPHmZMzHth0GVYBfkQeGNlxFApCZLIuqug9NaX2JV7P7RGdvNJnBpapoOQLQBVjK43tvAkiN7JR95lOglaT1I0C32Ox83ZWJ1CXVgRA3HL0dtmXd+f8S7wjgKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iq5YMXDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iq5YMXDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8662FC19424;
	Sat, 28 Feb 2026 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302723;
	bh=Nl4CpR+ieGzP27GaSCtiB9rsqmCYkJI/g0tDi3jeJS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq5YMXDli9wVs0W+x4H4yQTQFZl8lhyIijh0LMKHU6adYEp8FznrQOT/S5dCCKQ6Q
	 /ObmC2JGGUpdjsAxT0RlvG6qeu80p+5GhJsM5uWYBWOr0Kz77FiiI6XcU6vjSQF9Gk
	 ZlnCfxmZ37ISMcC7t/KR2Q7h7SvLESDk/EPntOn2FqpptZfondZGaSPosax5OFJNPJ
	 JMzq0ZmlG9B4CBsxdYyXA8loFSOQOuXzoxvBitXMS3adhkW7oQvLZZ006yorAlAyq/
	 /ovCksynat8UGYpZvZzWzwg7yGjD6aoZUQm9F1zyGXn34dtwClwM/wY/QwQ40q0gee
	 9m5IV78YIA7PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/147] RDMA/rtrs: server: remove dead code
Date: Sat, 28 Feb 2026 13:16:31 -0500
Message-ID: <20260228181736.1605592-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 3e6f12f98a890..bb19bbc564413 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -239,7 +239,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	size_t sg_cnt;
 	int err, offset;
 	bool need_inval;
-	u32 rkey = 0;
 	struct ib_reg_wr rwr;
 	struct ib_sge *plist;
 	struct ib_sge list;
@@ -271,11 +270,6 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
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
@@ -308,7 +302,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		inv_wr.opcode = IB_WR_SEND_WITH_INV;
 		inv_wr.wr_cqe   = &io_comp_cqe;
 		inv_wr.send_flags = 0;
-		inv_wr.ex.invalidate_rkey = rkey;
+		inv_wr.ex.invalidate_rkey = wr->rkey;
 	}
 
 	imm_wr.wr.next = NULL;
-- 
2.51.0

