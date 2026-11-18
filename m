Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033594;
	b=jwjIbzW+M0l1I1I8m7nmiwuTmprxY5LBiNaH2SgABpKoKXeWe67x1w2DwSmKhrg5U/GN
	 9yAYD4wUlwlvNzcNi+Ld2g2/uKVB6QD+rp+qAN4OWp7sog+LsJcHOQ9sTnW9VJpJYh6PO
	 IxeiD1JWO50RNhF3AFfitjc003uSlY2GrodXAiKD2HETYJqg1+G0JjCeN66w2jWJBvScW
	 0Puvy/rd+WDcMWGCwzFEJLuixpfzIuJGmbpfDmoiwQngUx82zzCpipOUepvHYpLRIYwB1
	 cKnxAotpSjEbPupPMn5D8xkk9hVjh/YhdmP01aGJPuR+cOS12BxtvV2QdaPclWqXodQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6m+jBuxAQJ9gnqE5ppptzANWiqZqGyTHCzyrxGrX5Q=;
	b=0L8l5G1rENTZntrbdCc3daaT8RzswEHQMGJ1eDvM6t+q2Xo6TSvobk/ck3z7VFOVEpv0
	 zIIXlYOTrhGAoUwhAbxQAdWySQF/b9Z7nFY6pGC7laZaT271wxkRyuQwWb6BlhqHtLyFF
	 TXtwhad3VPW3hAJiOmK7cUFYfcVzqpIkGYZjFv1ygAinGkfZNkbt7T9WlYn7vAir9xWx0
	 kp7XtR6iMLfbHud04qUHvndiwyhqiIujVm/3iGOQ4VrTx+mO/CIwA1XieOHJIpk4qo3YS
	 uaMuy2GRcZFaHPZUBg7zVIGuDV28yPpHVwBMs+fJziw+C3y4ZnCBGZOJ1AQSzA4TI1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjOEZVj1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87647606A320;
	Wed, 18 Nov 2026 20:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjOEZVj1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20201F000C4;
	Wed, 18 Nov 2026 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033594;
	bh=M6m+jBuxAQJ9gnqE5ppptzANWiqZqGyTHCzyrxGrX5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjOEZVj1ohrqv2iGwt/Gq1P1xQmjCN940JcWQBfUnYoSBWVzlCNXKAdWlArE8LtZ/
	 C1sCAFweY1TAWaKz1KRKsmPH+YZekD3ngyuLDL6pLkcURg35RJkhZoZlQHDWlUEmfm
	 YYux+/7I0qfzsBb1Vuv3lRXxtlBbNGqOBvBqLArw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhiwei Zhang <202275009@qq.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0068/3318] RDMA/rxe: Check PDs for memory window binds
Date: Wed, 18 Nov 2026 15:11:30 +0100
Message-ID: <20261118150316.056257953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiwei Zhang <202275009@qq.com>

[ Upstream commit fbbe1d5cd7d400a98afcf337969cfdb808cb198f ]

The IBTA Software Transport Verbs specification requires the QP,
Memory Window and Memory Region for a Bind Memory Window operation
to belong to the same HCA and protection domain.

rxe only checked the QP and MW protection domain for type 2 MWs.
Move the QP/MW PD check to the common bind path and also reject
binding an MW to an MR from a different PD.

Invalid bind requests continue to fail with IB_WC_MW_BIND_ERR.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
Link: https://patch.msgid.link/tencent_FD4FB25AA4FFA845E63F5AC36CF4A46CDC0A@qq.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mw.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 379e65bfcd49a..bddb7a2578313 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -72,13 +72,6 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 			return -EINVAL;
 		}
 
-		/* C10-72 */
-		if (unlikely(qp->pd != to_rpd(mw->ibmw.pd))) {
-			rxe_dbg_mw(mw,
-				"attempt to bind type 2 MW with qp with different PD\n");
-			return -EINVAL;
-		}
-
 		/* o10-37.2.40 */
 		if (unlikely(!mr || wqe->wr.wr.mw.length == 0)) {
 			rxe_dbg_mw(mw,
@@ -87,10 +80,21 @@ static int rxe_check_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 		}
 	}
 
-	/* remaining checks only apply to a nonzero MR */
+	/* C10-72 */
+	if (unlikely(qp->pd != rxe_mw_pd(mw))) {
+		rxe_dbg_mw(mw, "attempt to bind MW with qp with different PD\n");
+		return -EINVAL;
+	}
+
 	if (!mr)
 		return 0;
 
+	/* remaining checks only apply to a nonzero MR */
+	if (unlikely(qp->pd != mr_pd(mr))) {
+		rxe_dbg_mw(mw, "attempt to bind MW/QP to MR with different PD\n");
+		return -EINVAL;
+	}
+
 	if (unlikely(mr->access & IB_ZERO_BASED)) {
 		rxe_dbg_mw(mw, "attempt to bind MW to zero based MR\n");
 		return -EINVAL;
-- 
2.53.0



