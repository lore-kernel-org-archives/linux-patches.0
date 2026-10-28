Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208135;
	b=m/p1pGXQSK/Iv+PqvyH+pBqYeuATJBJ34JWu+ua4R3/TqBskOzA2if8d7/yux89vrtJA
	 bJNEcHX8HuRfFrLvv71R9GqNgzDcRYhhsIU6p/LoBM/cqaySfWv4T+BueSM6zZOc3grbq
	 Zuui+bBSaXDLQ8eoETqzNb1aFw5z9ebXjX61odBrr0V488fhzsdWr21V3SQKQWf0SyfLQ
	 0svF1aLfizr+CGrCh+oGSYB6zi9Et8xG2uyt3rE+1X6CtV0tYHAkSRQfKs8ZXZwymWCZ5
	 mmsP/EYEcXLpba6RRvHkusYmZ3nxDRLwzbLXR9MzRvaEQ5YIL06dFOH3d8gL+Hia7Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFUPGFrkr/v+DhDgBj0+1khpkQwNUoriueZIvwdQMlQ=;
	b=OCAF8MEoQPXAh7V++BQxFazqzmSlO9qEDB+CsxZjvF434HPheeWjeZzoqKIwlRuFJYrO
	 2Ifgl+HWn9Cx7wykKySY/qlp4lfV4QaUTSz4r/iWf5WTSoRvcKDck/nZ+d9bDSAmhdbwK
	 UFFtt+5ilNRmul6wl73w19Dimd2SGydmpG/nOyDgL1QGixoT6jGTf/xL2mQnOCAgqYWU2
	 ccqytqBHj9uE2Tkgaa0bWL0n1oVS0UahFDGvgQSVgUNBFzwwdpoCnfjpjLxvZvcM1sJew
	 f0+CBubfQgRUs8UH11zrYD/vUpf+YfiXxOZRXpkgWPAIGH1+F9qscDVTgAFHczT6eVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eoI2Uj/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD44606A31C;
	Wed, 28 Oct 2026 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoI2Uj/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D6B1F01825;
	Wed, 28 Oct 2026 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208135;
	bh=wFUPGFrkr/v+DhDgBj0+1khpkQwNUoriueZIvwdQMlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoI2Uj/JFtsjLBmXhwOsZjw+gzGRhvkpT9oh5XAsN4RXAfQp6N0/CFzh8d0fEwMvU
	 dH8gl1Emwk7ZpnG92lPvLZ+Ceswsbk8nMgGRHAZ6j3ohSogarGxRSRtTyPxSXRt284
	 u8X79lpxtKefLWMrs/CxJGl61rtgVRu73FYtzges=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/516] nvme-tcp: Do not reset transport on data digest errors
Date: Wed, 28 Oct 2026 17:52:46 +0100
Message-ID: <20261028170003.865790604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 1ba2e507f55c5b0cbde8c0fbfe0d9e39612a3e52 ]

The spec says

  7.4.6.1 Digest Error handling

  When a host detects a data digest error in a C2HData PDU, that host
  shall continue processing C2HData PDUs associated with the command and
  when the command processing has completed, if a successful status was
  returned by the controller, the host shall fail the command with a
  non-fatal transport error.

Currently the transport is reseted when a data digest error is
detected. Instead, when a digest error is detected, mark the final
status as NVME_SC_DATA_XFER_ERROR and let the upper layer handle
the error.

In order to keep track of the final result maintain a status field in
nvme_tcp_request object and use it to overwrite the completion queue
status (which might be successful even though a digest error has been
detected) when completing the request.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 7fa3f73f6c8d ("nvme-tcp: reject a read that transferred too few bytes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9e1c45d7cc999..9be5e42d0c709 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -83,6 +83,7 @@ struct nvme_tcp_request {
 	u32			pdu_len;
 	u32			pdu_sent;
 	u16			ttag;
+	__le16			status;
 	struct list_head	entry;
 	struct llist_node	lentry;
 	__le32			ddgst;
@@ -524,6 +525,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
+	struct nvme_tcp_request *req;
 	struct request *rq;
 
 	rq = nvme_find_rq(nvme_tcp_tagset(queue), cqe->command_id);
@@ -535,7 +537,11 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		return -EINVAL;
 	}
 
-	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
+	req = blk_mq_rq_to_pdu(rq);
+	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
+		req->status = cqe->status;
+
+	if (!nvme_try_complete_req(rq, req->status, cqe->result))
 		nvme_complete_rq(rq);
 	queue->nr_cqe++;
 
@@ -806,7 +812,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
 		} else {
 			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-				nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
+				nvme_tcp_end_request(rq,
+						le16_to_cpu(req->status));
 				queue->nr_cqe++;
 			}
 			nvme_tcp_init_recv_ctx(queue);
@@ -836,18 +843,24 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 		return 0;
 
 	if (queue->recv_ddgst != queue->exp_ddgst) {
+		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
+					pdu->command_id);
+		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+		req->status = cpu_to_le16(NVME_SC_DATA_XFER_ERROR);
+
 		dev_err(queue->ctrl->ctrl.device,
 			"data digest error: recv %#x expected %#x\n",
 			le32_to_cpu(queue->recv_ddgst),
 			le32_to_cpu(queue->exp_ddgst));
-		return -EIO;
 	}
 
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
 		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
 					pdu->command_id);
+		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
-		nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
+		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
 		queue->nr_cqe++;
 	}
 
@@ -2379,6 +2392,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 		return ret;
 
 	req->state = NVME_TCP_SEND_CMD_PDU;
+	req->status = cpu_to_le16(NVME_SC_SUCCESS);
 	req->offset = 0;
 	req->data_sent = 0;
 	req->pdu_len = 0;
-- 
2.53.0



