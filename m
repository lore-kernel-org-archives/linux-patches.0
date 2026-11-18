Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030462;
	b=DoWoqW6dzxH5LjZd002LNxVLMueRpum5wTUJD9v6BDuQfp54/oQjkPlf410dQgD7auqr
	 7WDQCv8y+xVTvg3EvM2D4bMSi3wafRmyFXnFL2pCyMKa3KsqT25UmEF760Qxrz5cxFbV5
	 ozTGlTXk0SDDHXH+ITaqm9JiEE47/9+8yoGKKNmudE77xk8rhqr3VxL73crpCfBtusfUw
	 MFkogyNH2yYchGWLhE4mi+y/uuTev5OVhugyTYwgx1hBoPaGQbCLfF7zVkgZQn27FXOe1
	 cOb3Eu2VcqVWc4p74GNlqxR+tn1jCzqMyry/Uwrb0Qir3UBLX7L7MJpfu3aQ/hsnaHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s/e3+Vt1y2t3zdczH7DTSDr6XxbDADMD/3y8iTk+9VQ=;
	b=W7GXGShDI62S/Mv6neQbatHtzSiqHIP36h9jOzL6V6kirYZHjFhXVRfnezejcZDGEc19
	 C/qlkOgi2WyKX2krjjVixr+OHY8dlJnAhaP07o1Y3nczASJGa3vSDyju+cIvL2KhD8vsV
	 HnL4+4sVHkqhetCbo/diqqiWC9H00bpLEV2yyYqsBcz8zxwGZD6aMmsoSIxEQiNUv7jnK
	 fJBCna42405w6VtWpPCp4IilnGFgsD/jxrV0eRt+KKM10EnIN7kqSdWxcvFWioBPeA9Ed
	 HnVjgQ1eSYqt8EsCB4MU95SzeMjUsOS4g+Xk61vJREzNSSieLVFasV9I6HM4Q4wm1OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VVakcBO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634B2606A33D;
	Wed, 18 Nov 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVakcBO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F041F000C4;
	Wed, 18 Nov 2026 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030462;
	bh=s/e3+Vt1y2t3zdczH7DTSDr6XxbDADMD/3y8iTk+9VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVakcBO/nYlVXOXRO/qUQnCanFFaDhuymoRb2vuHeqY0dnUGbl7WR0nNb5WRZYvyX
	 J6IZPaIz7PRbiVwjQOHnSr/Hh5tMAtAYtcBtkIGiDVaCmg/ySTrGexAITxDdO4AGuk
	 Q/lBEjyOUNivoGZfPGFMfUNCvlLJywlJbDgI/tak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nguy=E1=BB=85n=20V=C4=83n=20Cao=20Nguy=C3=AAn?= <nguyennvc@greennode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0713/1756] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150037.773008714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyễn Văn Cao Nguyên <nguyennvc@greennode.ai>

[ Upstream commit 6de34bfb56ad8c24bf63b243b5f32b345d9cdd4d ]

irdma_modify_qp_roce() handles IB_QPS_RESET like IB_QPS_ERR and moves
the QP to ERROR. On a QP that was never moved to INIT, this makes the
following RESET->INIT fail with -EINVAL, while ibv_query_qp() still
reports RESET.

RESET->RESET is a valid transition. The Mooncake transfer engine
resets every new QP before INIT, so it cannot connect over an E810,
while mlx5 accepts the same sequence:

  ibv_create_qp(RC)        -> RESET
  ibv_modify_qp(RESET)     -> 0
  ibv_modify_qp(INIT, ...) -> -EINVAL

Skip the hardware modify when the QP has not been moved to INIT yet
(iwarp_state is IRDMA_QP_STATE_INVALID), as there is nothing to flush.
RESET after INIT still goes to ERROR.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Assisted-by: LLM
Signed-off-by: Nguyễn Văn Cao Nguyên <nguyennvc@greennode.ai>
Link: https://patch.msgid.link/20260930-irdma-reset-fresh-qp-v1-1-065327274e2b@greennode.ai
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8a3c08679953d..d1caa78b8184b 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1437,9 +1437,17 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			issue_modify_qp = 1;
 			iwqp->suspend_pending = true;
 			break;
+		case IB_QPS_RESET:
+			/*
+			 * A QP that was never moved to INIT has nothing to
+			 * flush, so skip the hardware modify. Moving it to
+			 * ERROR would make the following INIT fail.
+			 */
+			if (iwqp->iwarp_state == IRDMA_QP_STATE_INVALID)
+				break;
+			fallthrough;
 		case IB_QPS_SQE:
 		case IB_QPS_ERR:
-		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
 				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
-- 
2.53.0



