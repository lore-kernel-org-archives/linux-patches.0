Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056377;
	b=Ae4eGf9uzszLcBZTawkeXWGGXDhanJVJm6WzBitIbZjycgTLAJljuWe5ggDOvgvt1hbT
	 LaiquWA8MABdl9v3FuSNySL6vIJv7aG6MtcaK0M1giG1VPJxC4Re2QHcGpY8A2+uPoem+
	 MgUICFodlIYpV2QFW0kHdfmaT9Q8Fd5tQHfgvalfX1ksykR55bpBo7EAg/auc3l0UrRxC
	 WXx7jRlK143/SbIHvbvSBH4eJ4a32nPfl2XbLbYhDZoFbXkEHt+NBhIOBRE45Q/sF9sOb
	 2gEeZyrZdAuSEO7k1HeRi2mgTK0OoCURmcc2LdgS8WsGp0gQeTQu/ksIgXtSuHYPgXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5T4bhG1R5ylJ9V1Wqeuv0KjyYBmEpWXHgg2udOgKWso=;
	b=3zhluxHhwqiBvlBGQ/VGWH51LLdORiD0Lxy05R/6cjpg1gNZa/ySGUNmu0VYnQU2X8jO
	 W0QtcK5Z/l4qzcR6RiujxI2B7td76w9ijmP2AuGrsvdsjMdW6ZIzoUoPNl1TIQpxhR6cz
	 vj5h1u+pV4Pj/uRTzuG8nX+9OjGvs42o3qj6vwEGEshNAQ0I74yinbmc2RYxOVJCA8rGm
	 1RFXMrbpLEO1NwFGtaWZu1HOtbEjd3XQbZi1kZRIBDPjUaOPEogsNBl3PdDUD02spDQ6F
	 Wjw4LQcvHqGrEma/bMdyk98ifMbpLYSUGxvDjatoaZucRQPJ864LX0/dnfrZZRB2Kbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ntaDhrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43033606A31C;
	Thu, 19 Nov 2026 02:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ntaDhrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F701F000C4;
	Thu, 19 Nov 2026 02:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056376;
	bh=5T4bhG1R5ylJ9V1Wqeuv0KjyYBmEpWXHgg2udOgKWso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ntaDhrkfgMf8ZSALHOnTZJk5WbLUTCRuMQMI7h+7UYd+lVDoWd6elfn1D/1iOtBa
	 dmZfwMhTLJ+B5ItpDhCKEig4KUGJsHKex0G+9+l441COCI/TJscWysR2BSMFYQmsYm
	 Y95H3Rfb2HcPF49JdWtXrTJLxf128Zjp4g/21zU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1966/2214] RDMA/rxe: Lookup kernel AH from ah index in UD WQEs
Date: Wed, 18 Nov 2026 16:00:42 +0100
Message-ID: <20261118150129.572939082@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit e2fe06c9080694f2c28894f14ef8ebfd923ac94d ]

Add code to rxe_get_av in rxe_av.c to use the AH index in UD send WQEs to
lookup the kernel AH. For old user providers continue to use the AV passed
in WQEs. Move setting pkt->rxe to before the call to rxe_get_av() to get
access to the AH pool.

Link: https://lore.kernel.org/r/20211007204051.10086-6-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c  | 20 +++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_req.c |  8 +++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 85580ea5eed0d..38c7b6fb39d70 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -101,11 +101,29 @@ void rxe_av_fill_ip_info(struct rxe_av *av, struct rdma_ah_attr *attr)
 
 struct rxe_av *rxe_get_av(struct rxe_pkt_info *pkt)
 {
+	struct rxe_ah *ah;
+	u32 ah_num;
+
 	if (!pkt || !pkt->qp)
 		return NULL;
 
 	if (qp_type(pkt->qp) == IB_QPT_RC || qp_type(pkt->qp) == IB_QPT_UC)
 		return &pkt->qp->pri_av;
 
-	return (pkt->wqe) ? &pkt->wqe->wr.wr.ud.av : NULL;
+	if (!pkt->wqe)
+		return NULL;
+
+	ah_num = pkt->wqe->wr.wr.ud.ah_num;
+	if (ah_num) {
+		/* only new user provider or kernel client */
+		ah = rxe_pool_get_index(&pkt->rxe->ah_pool, ah_num);
+		if (!ah || ah->ah_num != ah_num || rxe_ah_pd(ah) != pkt->qp->pd) {
+			pr_warn("Unable to find AH matching ah_num\n");
+			return NULL;
+		}
+		return &ah->av;
+	}
+
+	/* only old user provider for UD sends*/
+	return &pkt->wqe->wr.wr.ud.av;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 0938084192072..46d973ff2341f 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -379,9 +379,8 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	/* length from start of bth to end of icrc */
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
-	/* pkt->hdr, rxe, port_num and mask are initialized in ifc
-	 * layer
-	 */
+	/* pkt->hdr, port_num and mask are initialized in ifc layer */
+	pkt->rxe	= rxe;
 	pkt->opcode	= opcode;
 	pkt->qp		= qp;
 	pkt->psn	= qp->req.psn;
@@ -391,6 +390,9 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 	/* init skb */
 	av = rxe_get_av(pkt);
+	if (!av)
+		return NULL;
+
 	skb = rxe_init_packet(rxe, av, paylen, pkt);
 	if (unlikely(!skb))
 		return NULL;
-- 
2.53.0



