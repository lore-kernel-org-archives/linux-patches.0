Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030439;
	b=D8yOHEkqirmbcOcDbN625tXPAdTg+HC4jr5v8dgVwHkmxr7fzVO5P3RW3kZ40MQJjYbg
	 RSRVVR0irYx1ZUstPiCRQKez5cb2Kroh9tfs5kbxkAiPzHBhj0AcG6yxwH3Fpc5Ox1EKK
	 HWfC7BaGN5ZrkwZzd2gIr4U7WP/h3xrajh38P63MdvfpTgj4faBNhZot9LtsaiJzdqg7G
	 c5pIEQlZpH8840wws2jEVk4XP9J8AS+FAezgrDCldUbLJSOso5I8UFSIEzrngFNGOpfhs
	 kXSx7BydzrSI/SrMu1b94VdG+nj672VIJTNGY/d7dDV/Tu8KghGN71YjvWGokiNMy8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/gO5IalVBL+XOgofShEH9ZyiFxjiHU+OH0kFv4sz5I=;
	b=UNQfU/jC0T2/OLim6H0fNggGWThc073rMW8XSINIbOyiv2M8aZj6SVLK+NIjKgT5k7OL
	 y0GjDaKz4F/r6ry2c55tisEu75OdNMDKkeZHnXeTqUwID/zeOonPxswEJWysC8jostvqE
	 oAFzKkc9BIgUhlXbv3dxQFB+JLWTsIK+Ob2gDXXUlFTi0hCiVOgnfdkCxtIpLorGipgZJ
	 HuqyRseIns8So7xEhFGezovpgfjdUsTStH/F6pNFTSCdbJlm2umkUIwfLNxbAfOjAgL69
	 0NQqkTWRa9rVtxGcWEeysCBpEnPUtsdcln1NjKGO23dumQMwsENozwJs1sOeyqflB9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ7qCywW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A1606B10B;
	Wed, 18 Nov 2026 19:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ7qCywW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263F11F000C4;
	Wed, 18 Nov 2026 19:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030439;
	bh=E/gO5IalVBL+XOgofShEH9ZyiFxjiHU+OH0kFv4sz5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ7qCywWHG2Tlj23ICAqDg2mqwu7IjirfT9ID5KXCxonBmGeodghLOdGZxa2thVN0
	 nbmAJOu0ksq0lCeedu/oQhwtDxO52Raq5pvPDCw0Nzr5wHWCspaRXKJH+m6yqy6sya
	 /K4xxUWXd7JoInSgTIs1qYMHPZZEdHLKn7CylmEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0706/1756] RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150037.364461125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit c1fcde82f7b68181553af7efb4410df04109a9a8 ]

process_io_rsp() indexes clt_path->reqs[] with the 19-bit msg_id
taken from a WRITE_WITH_IMM immediate. That value is chosen by the
peer. The only check was WARN_ON(msg_id >= queue_depth), which still
lets a completion run after free_path_reqs() has set reqs to NULL,
or against a slot whose FRWR is already gone. Either path
dereferences req->mr and can GPF; KASAN reports a null-ptr-deref at
offsetof(struct rtrs_clt_io_req, mr).

Treat a missing reqs array, an out-of-range msg_id, or a req
without an MR as a protocol error and recover the connection.

Link: https://patch.msgid.link/r/20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/r/CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com
Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 99de772e99afb..dbce23eabcfd1 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -489,18 +489,22 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 					    imm, flags, wr, NULL);
 }
 
-static void process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
+static bool process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
 			   s16 errno, bool w_inval)
 {
 	struct rtrs_clt_io_req *req;
 
-	if (WARN_ON(msg_id >= clt_path->queue_depth))
-		return;
+	if (!clt_path->reqs || msg_id >= clt_path->queue_depth)
+		return false;
 
 	req = &clt_path->reqs[msg_id];
+	if (!req->mr)
+		return false;
+
 	/* Drop need_inv if server responded with send with invalidation */
 	req->mr->need_inval &= !w_inval;
 	complete_rdma_req(req, errno, true, false);
+	return true;
 }
 
 static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *wc)
@@ -562,7 +566,8 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 		if (WARN_ON(buf_id != msg_id))
 			goto out;
 		clt_path->rbufs[buf_id].rkey = le32_to_cpu(msg->rkey);
-		process_io_rsp(clt_path, msg_id, err, w_inval);
+		if (!process_io_rsp(clt_path, msg_id, err, w_inval))
+			goto out;
 	}
 	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev, iu->dma_addr,
 				      iu->size, DMA_FROM_DEVICE);
@@ -634,7 +639,13 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			w_inval = (imm_type == RTRS_IO_RSP_W_INV_IMM);
 			rtrs_from_io_rsp_imm(imm_payload, &msg_id, &err);
 
-			process_io_rsp(clt_path, msg_id, err, w_inval);
+			if (!process_io_rsp(clt_path, msg_id, err, w_inval)) {
+				rtrs_err(clt_path->clt,
+					 "Invalid IO rsp: msg_id %u queue_depth %zu\n",
+					 msg_id, clt_path->queue_depth);
+				rtrs_rdma_error_recovery(con);
+				return;
+			}
 		} else if (imm_type == RTRS_HB_MSG_IMM) {
 			WARN_ON(con->c.cid);
 			rtrs_send_hb_ack(&clt_path->s);
-- 
2.53.0



