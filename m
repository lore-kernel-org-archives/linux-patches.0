Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048860;
	b=fWnU00krkpwTnjieKENn3zMJm5YK6lkiXrjSBeMYHs+/0LiLXmUoxlqzB26G0MLqvniP
	 pySgXiMILUi1pN3+U7IrnCGTOXOhKpDi+PUbgF/U21LiR9ENIt+hNUf0KcjCcwufAjcGh
	 RSd/ZF/3xbd0/fhf6lz55gB1obEPl+mQWUtMsditSKbhQMjDAhZ0mtPkmDJS7zGY8pNED
	 0sZ0PwEsaZhWdXPbb5Oezud5weymDGJmvpaRJv3ZFdwlCnMzQB/MraBjAN/F7fI2dzIXO
	 zQEZOb6ns5Cmj5zUnhlQ9vEWcJnn4LNlrPQ1E+7ff4VXhj18deEpd6ojxV1M4AleGOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+yrSw9DKb7lguquLWb9yBO6sc6YRBCGs55G3iBP3NDs=;
	b=NPVy0Nk6QaS6TMKWpi2JY3dKbJV8zFthPx/uKCty1HDzniGagPzAsivsDr+EUlevbk+y
	 CWLQKlQWEF8C/vF4WZkQv42VeU5lqH0B/GlewhzsObsW5PEWAv0XdOoGgkbNZf7CKViGl
	 ZkFU+E5n1EbQu23h0wj6fTOSQoLu/v/i2l5JSW9TkjpDDbv9Er6HmmLphGS8sq78p2qLB
	 gMtBsPui97IrpGd2J5b9s+gSYP0Gdsfu5I7VwnLuu6jA6G5Kh+Wsycrfhe4WE8qgRN2XR
	 5LINkFfIZBLOOJQWYtJ2y5vffovXdVN+wiEGvu+XkUkEPbl3X03SgJHpo1SlB+yTGlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDAPpk9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDD5606A320;
	Thu, 19 Nov 2026 00:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDAPpk9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466891F000C4;
	Thu, 19 Nov 2026 00:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048859;
	bh=+yrSw9DKb7lguquLWb9yBO6sc6YRBCGs55G3iBP3NDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDAPpk9mZNkecheWg9xv5/KKrUhmCt9TjSOqm4ywmD6lDJV0YsvbK4geYLTvBgOjA
	 f5Mg8gAEt5EuEpr5iSZLV+Q6p08nUFb3dD60XG1UdZr6L1JzUTS0A1WuwckrzV5WYV
	 5Go43juKuo1AUSvwGWTtfFTgj/0vWDE0D99pTLDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nguy=E1=BB=85n=20V=C4=83n=20Cao=20Nguy=C3=AAn?= <nguyennvc@greennode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2145/2857] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150318.633271596@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 246dfae3ce0e6..fa7d09fa9ef22 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1413,9 +1413,17 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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



