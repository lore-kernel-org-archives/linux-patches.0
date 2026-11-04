Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829454;
	b=ksSkRmcTR4/n6poNBz4EZLC3zu/+sGtll5+hei9eeuYsmOEXbQi5f+zbW5a61Q9C13dp
	 N40sFnlTyp55KNIkxUlq5yPLEPwzHrZYrgzBWMSONB8rNrN+eLGMzc1LKNAZYl84aOJUl
	 CDVNSoz5QLTWA3NokCd2awbTQ6biDLT2o+dn4p8AGcJq1OxFIfou1HT363lNXjo7YMIX1
	 QTix0jOh6pztZRdHsLm4SeRrpKqQ32aPiFTHuebmWUpcq8hLXIokUT/rMClY9O0IK1y7H
	 viXsc2/TQDpJRdkgn1WFs+NCOczA3gayO4vIfKMn1HbKqCCSinfTmyBioguKo0FZu0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRoe/3k9FV5xKubSQbfQ8c8rrWMFh1EgsS7cHt10bk0=;
	b=TkEUGWK0EXdbJFwFd2iCmlTaUVQkDwMxvyU//iJ8wbK+sjOuQ7AUfVERQXYVx/Hz4t0K
	 A19OJORlxqVb+j6ZjP7DaYKR6e1X94eQAWMnYZDYNvevTzYzmwQHPgi2leRaiX8NmZKRb
	 Hk5qifUFt226orqySXHWdUpxCxFo/jFjhwlZXnWYs0EsHLhyr+3OSW0hCX+jVwitq1DoH
	 3Zs3aDGpcTkneVQa42CQ2ABDDNYZVfNEjuN9INROZa0RJ7zkhFxIKKCJo7XUHRdIjCVVU
	 QhtGIR4fKSWiNs3n0hLuS4PiDy2a7zpbTYCL6Jn8XuFt2+h+fHKti3NSZ6eEFZDIAjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IE5p9ITn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD223606AB0B;
	Wed,  4 Nov 2026 21:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IE5p9ITn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427AF1F000C1;
	Wed,  4 Nov 2026 21:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829453;
	bh=uRoe/3k9FV5xKubSQbfQ8c8rrWMFh1EgsS7cHt10bk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IE5p9ITnty2fm1KEnrpnkZKPEGeddFL9Nhg9sWxS1B0Yu99xEZIKUt5G7HNVrvLTZ
	 eRgwk5YX6xsTpZaJD46BdIrCbq/iNkcZs6PrgR7agxyD3JH6P0rwToplOedgkxPxfy
	 ImO06QFuH9k8D6J1AytbYY39/iIPWvbREiv+IIhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhiwei Zhang <202275009@qq.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0097/1005] RDMA/rxe: Check PDs for memory window binds
Date: Wed,  4 Nov 2026 15:57:10 -0500
Message-ID: <20261104211046.349603812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



