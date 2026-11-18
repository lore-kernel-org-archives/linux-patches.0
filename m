Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055687;
	b=iI6VHWNv+Y5PR16AKBQTd2IDQclFxdXo3JzSwr8sMCmE1co1pUanKuT3T/qexf891iXr
	 qWpte/v2kC0QQcQd4ArC6BEMn/oEuwzCJGsoS/FmEBlASHLik5qpXsDR5DAbWL7tgfYVP
	 R/qtNf2SZCj8fy7f4oL25gA66yxC510JBam2MPKc5ipYQaFOyD4hLFP8446ds08yWu/14
	 5frskQWXbyomQtNA1Ih+hmdmsxR+FgnWnep1GOSXzUg4FaJFdUCbkle6nFO1vbKVkRq02
	 gUiUuNLMIEdcm/NR0JjtiPd55zlAFo3s0WhZkj0yXqfvnOKalBZk0v6SyRjrhfXZsOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eBhE90DBPo1slDJRoyGvdxvmw3nb4oTR3RbUE/1zNmg=;
	b=gkj8z40p0JtcEEcVzMVeitvM2bD6hbu2OhAoKQHuaG6JKB3VvuHFe+1JbXITz9y3wBRa
	 HIX0s85i3fiKrpbqZdNwP5cB7piNlm9ZSJRc8CgOlpIp2Npj72HjSxvbFomsc7oUQIMEZ
	 93hI5gnfDYtBlHYrX1LD9QhU+NrHxQq58ELcDqer+jgR9vuUks6R8I24ODDpIpHGa57uV
	 ilxfKCVg/Nwlq0RBLs25jZYTOM5PDUchYlE7TcQ6OhbXA7VfcTQ2dO1hnp9NuChLWPP/j
	 5iOhMZ/LJwk+8t0pl6AcZCEyeYOtG0WvbwchN5RMKTHE+3kcX2DqK/bAas56mb1WcOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1VxCs0yj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1011606A32C;
	Thu, 19 Nov 2026 02:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1VxCs0yj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003671F000C4;
	Thu, 19 Nov 2026 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055686;
	bh=eBhE90DBPo1slDJRoyGvdxvmw3nb4oTR3RbUE/1zNmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VxCs0yjKlcTic5omhmYsvRGbidZeNb19zgQRmyj2QBas32t9Y2K9QXS76HU3JmXv
	 6sRmCtuIr83wZxoYEZ7lVKFU5n5AGnVb2e2QklOuZvEsfvOWM2ZofIC/gu5Wd/yr+f
	 Ny7BR1edBBVtQMpdFrOlUR7gdtIFDvPkMqSSIBsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nguy=E1=BB=85n=20V=C4=83n=20Cao=20Nguy=C3=AAn?= <nguyennvc@greennode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1683/2214] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
Date: Wed, 18 Nov 2026 15:55:59 +0100
Message-ID: <20261118150119.163748184@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e8ac04826b0e..33b573b509df3 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1348,9 +1348,17 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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



