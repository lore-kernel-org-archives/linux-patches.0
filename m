Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020475;
	b=sh5IdH7mOgcNHkT9/W4cGDJS4HL1wfqi0ZpIDRRHyKbedpicg4QjzdXJOV19Ctmp/VOh
	 y7gnv3cTYccug37Vldtchuj+OI2guw/zEgUCEbA6rN2vb9hvvmnHnttZP0RA7v8Sh4R7s
	 tp4GyR7D6Z+iiU416vWjiTDZn+Xg6xn7GJMlr/rX4jZGOmxWWH0c2rnAcOTh5eEcg8aff
	 EDck+smuSMh8IGhVu898eJg04P/zeH3BKw6BWumjHPIAD7gmy/RprttkZb2vztaNWNUOr
	 zA1XG3Txs6pwPIXsyKgN70RJoPV6nTXrDjbijVaNp/7bJbsxWNzAay4PbwbG0roa3Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ygLt0x/NO49XWJtJ5uzUj+0qoLLnfAWGkZDfIcA2Ybk=;
	b=jJIgTHIe/f4XQWz/mID0fSugXorcI9HgUv3AchRpofFrn3vH9ZR6SDg+YANLpfn4sZi5
	 9D7uLEjgywyx5xoixa60Omuz74x9AITUVCWvkfmbEPl8FoyaoVJXD8bNjC7fQUEQbBWRv
	 UZBinLyrqIVR+n1eH6fycQeBHt/luEmZn/x9onEnBVj8KRLrGK1yo+UyL5GIeg7WYaEDW
	 8yIVwl1BoGF3aP6qnxh3EDhFqtROS1HVYgGCgAlJwZei8oVGbpGrRedoCpWPu21AV5vy3
	 75Vl71QVhTx9C7ZR8G5oLdVuZced86cW3aAKk+VGJqg3wUfG7EvYRkzPCGa15z2qAiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Sh/4Q3Wl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8237B606A31C;
	Wed, 18 Nov 2026 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sh/4Q3Wl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27E51F000C4;
	Wed, 18 Nov 2026 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020475;
	bh=ygLt0x/NO49XWJtJ5uzUj+0qoLLnfAWGkZDfIcA2Ybk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sh/4Q3WlGpQH23GZZHSF7fPaFtxVpAOwKRzhLm/+Tt45KAPNf1Uvx2Ez0YyatJOsm
	 GsOm2xHfJBfP5lcJumlu0zaj7d99nACvfSnAsJShwponGhjfPfP1iYTfzn6U+oLzha
	 xq+jF7SlNdTtfYqR1KjUJmyewI3dC6Dol1jUCJVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1963/2651] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150357.185247707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

[ Upstream commit 56a27df6cedd4f3918969d61c7b9d3cc177b2d1b ]

When RDMA READ request for 2GiB in single WR, res->read.resid is u32
0x80000000, which is INT_MIN (-2147483648).

    payload = min_t(int, res->read.resid, mtu);

The `min_t` function will return -2147483648 for payload. The wrong
size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
-> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
invalid size. The passive side failed to emit response packet for RDMA
READ request.

After fixed it, the active side of RDMA READ failed with error code
"IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.

   int resid	= dma->resid;

This conversion set resid to -2147483648. `copy_data` abort as length
greater than resid.

RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20261002142250.657151-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 7c3cc48e845c4..e57861a628236 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
 int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		unsigned int length, enum rxe_mr_copy_dir dir);
 int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
-	      void *addr, int length, enum rxe_mr_copy_dir dir);
+	      void *addr, u32 length, enum rxe_mr_copy_dir dir);
 int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
 enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
@@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt);
+				u32 paylen, struct rxe_pkt_info *pkt);
 void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 3a914c2438294..bc7e3cb5a11b2 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -418,13 +418,13 @@ int copy_data(
 	int			access,
 	struct rxe_dma_info	*dma,
 	void			*addr,
-	int			length,
+	u32			length,
 	enum rxe_mr_copy_dir	dir)
 {
-	int			bytes;
+	u32			bytes;
 	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
-	int			offset	= dma->sge_offset;
-	int			resid	= dma->resid;
+	u32			offset	= dma->sge_offset;
+	u32			resid	= dma->resid;
 	struct rxe_mr		*mr	= NULL;
 	u64			iova;
 	int			err;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 9f1c7f21d88d9..c572cda8fe18c 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -571,7 +571,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 }
 
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt)
+				u32 paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index ba3b2d23b36b7..1b7f317372259 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -614,7 +614,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 }
 
 static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
-				     int data_len)
+				     u32 data_len)
 {
 	int err;
 
@@ -829,20 +829,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
 static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 					  struct rxe_pkt_info *ack,
 					  int opcode,
-					  int payload,
+					  u32 payload,
 					  u32 psn,
 					  u8 syndrome)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct sk_buff *skb;
-	int paylen;
-	int pad;
+	u32 paylen;
+	u32 pad = 0;
 	int err;
 
 	/*
 	 * allocate packet
 	 */
-	pad = (-payload) & 0x3;
+	if (payload % 4)
+		pad = 4 - payload % 4;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
 	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
@@ -936,9 +937,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 {
 	struct rxe_pkt_info ack_pkt;
 	struct sk_buff *skb;
-	int mtu = qp->mtu;
+	u32 mtu = qp->mtu;
 	enum resp_states state;
-	int payload;
+	u32 payload;
 	int opcode;
 	int err;
 	struct resp_res *res = qp->resp.res;
@@ -984,7 +985,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min(res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-- 
2.53.0



