Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043010;
	b=oxcay1VbW2qyfSgvjT+NJmwPyJDZMKqEwo9hY19TjBsF4+4OtKB5rmCMaYFNU45E+OQM
	 i8VGN7MuLnPrZgLwecWD2Fc2k9NN+pvQuODvqtI0RmGFYqxusZsjgm2nN8tHnCJxUxivR
	 azyMn7fyRCdJdN1m2p40s4IZQhw0RCnq00+Pqr4l1r+MWyazr8++jfNCrx45EfqQhki+g
	 H/KJVxeGeh7ghdYt+2SbJlGMiEQ8ELugXGYXzVmLodV80N5XabF1050nOyPFTXnPT1xAj
	 Q2mo7RfwkIaobHoQluQMqXAqwXefxUR0M67jJ19hB17YRAzhrDr65A2W3BeQkhBwd6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zrHXwyZCV7AgYOr2icst0bZlN18bYZ1vMrXUJX+POhU=;
	b=uNcobxQp/XzMC7ffP6kawD7vIHEJGnM/AJ6TQBBOR0TKQXya5VEpccxI2/jYC/2mL+jg
	 eJKPmLM7mGCVv6csYCcQhPC5QtkB2CG4TECYRlDG15xeC4Vq6kSezmWazf/crHdvoL+Cd
	 ELcbP7rmo/+3JWT+VUtt5BGo4oMm/hnYE3cC/T1tWo+8zVlp2Cp07f147byiQX/OcCf/m
	 pSoc951MgyI1v/I8d5Od70kuiHGqZwBn0tZKQjExcCm4cApYIsnGk3hF15vZxCVAX+c1b
	 qS+lQDleWeV/mLQ0rJbn7N2aPJidZtb0kAFpj0N5aqvHR0sVTKOmOOOyr3DsF8aVV8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLBQd4OL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06685606A320;
	Wed, 18 Nov 2026 23:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLBQd4OL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E565A1F000C4;
	Wed, 18 Nov 2026 23:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043009;
	bh=zrHXwyZCV7AgYOr2icst0bZlN18bYZ1vMrXUJX+POhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLBQd4OLrtgNCdWTbj+HjPPs6vO2YI4bnnR2LJFZAwvSfRc5Bs46XjUbxAd6WR1Pu
	 Pph5/GR01dz6WkT7rlrtyJI2LaY9WLcY1hKbHMM8XfvtD5sJ9uk1Cq01hHvxATDXcL
	 Xo2Wvv3PYg7KFlL1+aapnbKytfOsY4/tFl1iBlCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhiwei Zhang <202275009@qq.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0056/2857] RDMA/rxe: Check PDs for memory window binds
Date: Wed, 18 Nov 2026 15:18:10 +0100
Message-ID: <20261118150203.324983066@linuxfoundation.org>
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
index cebc9f0f428d8..9ed6647f156d5 100644
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



