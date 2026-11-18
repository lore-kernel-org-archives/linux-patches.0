Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056385;
	b=uR2krgVVi/A/g/8Gv/GV5mzaa5Tv5qiqiAsezUy1ymxeAaHeZdQTSw74OYl7wo0xdB3Z
	 9MXiIQNQv6rc6z4dE0kIbWu8SnyB1j5akfVRb3KwPoRWFyF7j0nxGpE4BisaDrexs+ZHy
	 D06Lqe4w2Z+o9OUT4m+DHaKPzNXGZ83QIfltgJz5xJV8qswJRmWu5rqDXTSnLqGn0V29W
	 vkPzFoeseBLFA2L4FKMbpV+vYL/EX+AjIR91zHlzl8VhfWOkIk8cdEXMhQtxiaCVrDAqU
	 UmtDQ+xu9iidMqclyaW48L1VamDzeynKxBRzBNQl7izaiB0KM0OBeDwtdQUzrgDHYig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlauYRfm/f+ivuxBe40dSugYYfGtbHO+JflEwTnesaE=;
	b=XIHrJNnv1hesRJInoKgJxtTCvyNXC1sukYRavA9B0z5NiQoUhE/eSPzeAzi+dAFB2aDv
	 yfXy9jWM7nX/zFr/LOj5sqlJTiQ5P0pkz94yBfiUdJhqyMZ9ZAOT9+rOmRnpEWOvUnsen
	 oyqgOmAufma8371YWvco+oBGCq3+QkcJ4BDkrVNM+LLU1bf9Syenun3jbof/8MzNgS81T
	 /2oR9/oIPVeYjmdzIyPIhTIPUnKlSGmzXW+m2LBuLBKylG298JXiI7plhgw7qQvPletiH
	 8IvPrYzqkOED8WX4rFRpnh04XNgvn2ToBuAGriVtOlXxT8I1m2/YyjTkypfneZPg49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nrhGO8m+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA73606A325;
	Thu, 19 Nov 2026 02:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nrhGO8m+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A466E1F000C4;
	Thu, 19 Nov 2026 02:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056385;
	bh=OlauYRfm/f+ivuxBe40dSugYYfGtbHO+JflEwTnesaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrhGO8m+JwI0O1gti3acpulTV1VUvCP+fQe42aSLqW9IQI3s9HIQhyM4tempcZL/n
	 SP9sMm42Cqo5wbvof4r+siEYvISM+cZJRAzXJikqWCQ2CRiTdxSkeN33bm2yJ7YfS2
	 CYBgqPJmzkIQjNz6GmWvpRQCcmdq+FW1F7tG7w/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1969/2214] RDMA/rxe: Replace paylen by payload
Date: Wed, 18 Nov 2026 16:00:45 +0100
Message-ID: <20261118150129.685680929@linuxfoundation.org>
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

[ Upstream commit e7734156b0ad7c32643de851d644db74ea4b0074 ]

In finish_packet() in rxe_req.c a variable was incorrectly called paylen
instead of payload. Elsewhere in the rxe source payload is always used for
the RoCE payload length and paylen is always used for the UDP payload
length. This will cause unnecessary confusion.

Replace paylen by payload in finish_packet().

Link: https://lore.kernel.org/r/20220420172316.5465-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index c8c78fbde5443..0a025a60ae767 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -444,7 +444,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 
 static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 			 struct rxe_send_wqe *wqe, struct rxe_pkt_info *pkt,
-			 struct sk_buff *skb, u32 paylen)
+			 struct sk_buff *skb, u32 payload)
 {
 	int err;
 
@@ -456,19 +456,19 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 		if (wqe->wr.send_flags & IB_SEND_INLINE) {
 			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
 
-			memcpy(payload_addr(pkt), tmp, paylen);
+			memcpy(payload_addr(pkt), tmp, payload);
 
-			wqe->dma.resid -= paylen;
-			wqe->dma.sge_offset += paylen;
+			wqe->dma.resid -= payload;
+			wqe->dma.sge_offset += payload;
 		} else {
 			err = copy_data(qp->pd, 0, &wqe->dma,
-					payload_addr(pkt), paylen,
+					payload_addr(pkt), payload,
 					RXE_FROM_MR_OBJ);
 			if (err)
 				return err;
 		}
 		if (bth_pad(pkt)) {
-			u8 *pad = payload_addr(pkt) + paylen;
+			u8 *pad = payload_addr(pkt) + payload;
 
 			memset(pad, 0, bth_pad(pkt));
 		}
-- 
2.53.0



