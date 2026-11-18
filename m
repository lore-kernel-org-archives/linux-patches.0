Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056379;
	b=Ri/D13oIVKRPJVML9ogSipgWZg5LOJgwIV62QnzohOmTyC74KrsUJA2ync2ZhLR4KDZN
	 KqwJkj4bfqeHV1tUDXLB5LHDbx3UVYFjqweTYtQXWavCKiJKDHT+Q2Fv1cdM8n0Kfjh3b
	 M/+gjtqb1+wR7edLrCcXsX3awjd6IflY4aFbMLmEl4LEDx7h5o1/Nnnzi1dgcDun0zRJu
	 DKnxh+pqWKfdgwz8B+R0Cj/3DqXwz98iBNHJEdjLZmtryesjxieBC0419ZphWnCYdRrDI
	 8awAv9/SjQ7ahhH84qMndn1tL36t0Ae5QZw9rodfvERAqS0vmGDa5XpV5Q7wolqux9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRCs3dTeG2lXHRI7HFn0f6mEzf3Go3PwwQpCpbXsNu4=;
	b=pes+wyK9WP8GjPYz4BJYn0+HC7tzeMwlU+qDjQCYOZG9Msa+67JtcDo2vfButWLxZrge
	 O34Q7A1ngp7ZnKKKSINGIMw4DCjocGFYlbmHBXKTp/dHoXgm2CCV8RlhkDLzXuZOIpJKo
	 oyz5/Ckgip6YRAkgARAg08oaHlXW8TwcbxmUxA+FmNu3pdF74dDFOofX16b+ehCLZ5kF2
	 9d+EHl8xJ828tnaucPD0njWKySs+rAZVuC3amxhbREJIYEpqDBe0OaE90YrytfjSMXcCJ
	 XzMbgqm9YpA/uyqQpRTFJKTqB6gEA+bKUZCCJ6O58koNQvMHb45h1VQX/kNjw/hGr8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbvFsB+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4789606A325;
	Thu, 19 Nov 2026 02:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbvFsB+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1B21F000C4;
	Thu, 19 Nov 2026 02:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056379;
	bh=GRCs3dTeG2lXHRI7HFn0f6mEzf3Go3PwwQpCpbXsNu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbvFsB+LVUx8acNJ4ARK5begUpNXSCfu6PJQ5N8loueTqGYhmChSqAYdmpIL4/78V
	 a4NWzjXJSW7qipwTtFLqbDyNv9dYJ4vjKuMAKY/nLR/N1JvoXj859OrNkLInYYxs/p
	 lGKYi9X0zU06DHn4v2sMIPfbKoR+bKDUUkZmsxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengguang Xu <cgxu519@mykernel.net>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1967/2214] RDMA/rxe: Change variable and function argument to proper type
Date: Wed, 18 Nov 2026 16:00:43 +0100
Message-ID: <20261118150129.609183765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit 7e8e611d6a0ff228577b1167335ffefb0f44d5d8 ]

The type of wqe length is u32 so in order to avoid overflow and shadow
casting change variable and relevant function argument to proper type.

Link: https://lore.kernel.org/r/20220307145047.3235675-1-cgxu519@mykernel.net
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 46d973ff2341f..ffc94561deb01 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -362,7 +362,7 @@ static inline int get_mtu(struct rxe_qp *qp)
 
 static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 				       struct rxe_send_wqe *wqe,
-				       int opcode, int payload,
+				       int opcode, u32 payload,
 				       struct rxe_pkt_info *pkt)
 {
 	struct rxe_dev		*rxe = to_rdev(qp->ibqp.device);
@@ -456,7 +456,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 static int finish_packet(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		       struct rxe_pkt_info *pkt, struct sk_buff *skb,
-		       int paylen)
+		       u32 paylen)
 {
 	int err;
 
@@ -504,7 +504,7 @@ static void update_wqe_state(struct rxe_qp *qp,
 static void update_wqe_psn(struct rxe_qp *qp,
 			   struct rxe_send_wqe *wqe,
 			   struct rxe_pkt_info *pkt,
-			   int payload)
+			   u32 payload)
 {
 	/* number of packets left to send including current one */
 	int num_pkt = (wqe->dma.resid + payload + qp->mtu - 1) / qp->mtu;
@@ -547,7 +547,7 @@ static void rollback_state(struct rxe_send_wqe *wqe,
 }
 
 static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
-			 struct rxe_pkt_info *pkt, int payload)
+			 struct rxe_pkt_info *pkt, u32 payload)
 {
 	qp->req.opcode = pkt->opcode;
 
@@ -621,7 +621,7 @@ int rxe_requester(void *arg)
 	struct sk_buff *skb;
 	struct rxe_send_wqe *wqe;
 	enum rxe_hdr_mask mask;
-	int payload;
+	u32 payload;
 	int mtu;
 	int opcode;
 	int ret;
-- 
2.53.0



