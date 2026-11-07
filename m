Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060687;
	b=wmT9zqkMhpFlLFU2sSiL1xdp3s4FdtIDYs1/fAIFzu9UZ8NHX0fe9ABEmpUZnjbgQcWz
	 vEGkagjz7/BouyZAdVx5WCfA+sIPoWtVxkacPmGMVtBHsXlz5Y90bdlSgC37GDiAEsx4l
	 +ZgFXFjF421eHpMj/gxZs0psFjCN4VX2MGVXON4mNZD8YHewiLs2XfzynAUPfcQkSX+Fi
	 KbTverWP7teY8tc9YuwLia6cv7XE9Fd3lEr8W21A0iOqLWp53q9WwxwVx0i6MwMA3hjw6
	 fEMOVcHBq+gurP2PkeAm5e9bx+5nX6MHK1tvVqf0/uUyCslsyalLntA0nhnRd57HqAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPvW1kLqBRHIzWiJObcaC81kaHsBs5SQDBE8gCzI7G0=;
	b=OeUUOy3CUCnCs2XFX2xIJopUFsWVVQX+NPnL6hK/+q050o470d+LVAN7lMa4K53nxC1O
	 meDsk4pRNr1VFukfJUFnkmsCGopuCR+y4cDSjzJ8t6fkaPI5orYyLKTEjl14wSNRT+sAq
	 hUdHLiPZiBjVgY7D5zoPJYVJ2hXob0zY0FK8fYNESjOU9u7rSXUVLV9GDE0DXdYYqD3Fe
	 Nw5iYZfFXHEUII3wdfDWGaCt64jYuw02WdY2P52+QMwsO+vOFd/VV6qzO/Gjp4w33GdI1
	 xNw0R4aDPzstvyTXasDATdNgt693xhc/hBdEuJcrsIH2DLIiNBLy7LzC/YORVzqh6tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QN6G1A2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227EC606A32C;
	Sat,  7 Nov 2026 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QN6G1A2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF0F1F0089F;
	Sat,  7 Nov 2026 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060687;
	bh=GPvW1kLqBRHIzWiJObcaC81kaHsBs5SQDBE8gCzI7G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QN6G1A2Du7s9hp6OvPAaW/d51Gt1cTj2jm+yvb2P7Pa0v2Cfuo7q6BjzJuhawBo3+
	 VOKLMeEjWLnbfAOhFV6GKUhACXIRc66L41VP4tLcDFAkUIJewmwolmoWfzcpzv1/Rz
	 K50Uv/0SzbTAcb3xfD+Pzm5YryCy+5kSchG1HGq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhiwei Zhang <202275009@qq.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0082/1536] RDMA/rxe: Check PDs for memory window binds
Date: Sat,  7 Nov 2026 08:34:58 -0500
Message-ID: <20261107134959.977532528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



