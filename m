Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024910;
	b=vxD/yygCpzgc/XErbUTrJBuPOrMX3YkfKIe2j9CYYbgyTSVTIRrTQusmEOByVTWCgC2q
	 y2INw3s5vSHdi2TnM1dESGMybIsgXfGka1sTkFHTTMZNRJNcx684IJSc9Mcoq7eaUnYli
	 4V5a0+Iyuo255n+tTk3MDvHz0dta4AMg54CpMnLhcQ5yTpwkLrhLfTFAxqg9bDbJO4Yrt
	 HW3r+PcYgY3yDZkyCjQovctGcSpUrMNMabqcIHnDjJlDh/Sve8MCq07cP6tJxJ+Axprhj
	 1SNDa33Fgug9C1+mg6wc/HiN9QgVLUOfuFX36A4NIA2//VoCytgyY2k+sQ1gPIOQEhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nkyzGdPL8uWnZotSj83YvLlE/332PFxXJsI+IHfWlm0=;
	b=pDItTyxpf+24O5Hpx+LW024vNhvtiiAPGDxm2B8r6KM4Op0kdnJV6YT59+uS2aouPq7q
	 Xc+3JHs6Eaosj8xHW2wVKx6l4zQ7sJQ+1c4VIxEuitPhxQzbukbAFKry1HOLtekEU6OuJ
	 S7lHufBXuKkSrJUSUCPEZrxYf88d0YkIeJqF3n2ZmkZYog+3Xk5C1GnbasduOhcHhHdZM
	 tAiT6E0htAVe1ovuKbuDKunlfNZ/HMcGfW5uCRPmZsU3cPXg6o30MArjjzlrjHcIntz74
	 2re3Yxh6si44XNWjN9HNBQEa8GaH8E9INdoPLXEPBZq74pDOS9rYK7txC+i4d0DYpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV5B1ccI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E280B606A31C;
	Wed, 18 Nov 2026 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV5B1ccI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3321F000C4;
	Wed, 18 Nov 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024909;
	bh=nkyzGdPL8uWnZotSj83YvLlE/332PFxXJsI+IHfWlm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sV5B1ccIcRKYkqCNWZERDl3ClH+yfpMa1DQrho1pbdtDHPhW/bsIBTFd2xFdpkPVc
	 oIjIWfkc0rASpkORjqiIDpJdbEFxUFc5ruTjp3R6em6yr4XIqEo99ubFJzdUIaB920
	 IRiPd6HZNQigKGZhfjQRKUS2KJcJT6j4i/zbRWnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0892/2151] RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118150154.793879463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



