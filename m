Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048843;
	b=rmC7WTKTQiuAnS5m7bQcMQUJ0pV3coVlO/FqzJBHvon8Dk3nH7qTfkUZLEVVXhgtyI2o
	 RS6TzQUxoX57t0U8Ho53uGn+c0/FN4RdkFC0ZnAKj4TchNMO9ijrqD64ZSyDMOCMGLmSG
	 7/JnHho/4UWWmkCFKOQ3rqm0KWvIhkIcM57Jmi5I4gNIBQ5HjErGPLw3nXg76zWIQvZag
	 wgtm+SV2cbHsbCUojVAjxZ8d9vg6brIf8o6MPoBSjTwHgmOlVsawIgOQOwYA0yN5MQOL4
	 B94uC6YD0fzrQT0uf0pWjaDRd+diKZ4yIeKR/El8CpTzXxLSjSCovEiRvaXGUQIgmqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=syjrjdR7FPM8VskTh6jAUKysfvrhlS3Xb8rTFL1moxk=;
	b=r8Cz16gUiWdRJg+/l1XflalGU9SJk6aqnUsAl6HMQSMsxnPhCjfb6FmomE9n9xHyicS8
	 DkGJPUOQM9GD24CaH6DhWJIgUwnB4ahD4pPtHQiTq9+gY2nq1DQCuw/sT4GsDNxo517OK
	 TQgLVJMkbbGhPcqqqw6A2fHAoKqq0lHbTgOOFz32go9uba3lAdrk/j1NA2M69KE1ynTXr
	 KZpyoxF0mFt4XTFhecU68R6ZIsPwTIAu50lwnAVEoCdCszl7UwgMtLaIqhvAnHa9Af/bZ
	 W/VqUj9fTQh4HCX9dhKDkhOLdAHtiS2+LBJg6Zmda97M/KalDSiGJZtF035zSrEMS5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAJ30Ron;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DA606A32F;
	Thu, 19 Nov 2026 00:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAJ30Ron
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C3A1F000C6;
	Thu, 19 Nov 2026 00:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048843;
	bh=syjrjdR7FPM8VskTh6jAUKysfvrhlS3Xb8rTFL1moxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAJ30RonUyV08irR+84W/J3DZEkQqkXZEPBN/Wmkj8g2hoUuoF+bku0p/ICYXAvJ8
	 0LV3EQGN0FvCNnb8fBDIeer9Vg9W7V981yYoabFkJV1I4scNFqYaTSqAM1ZTaRPLQX
	 +SiespFbD60ObMqcBME0POUf2KN4noRySLjMzQmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2139/2857] RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150318.419270954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 83bb8f2872453..7e592e3c04c6c 100644
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
 	req->need_inv &= !w_inval;
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



