Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017943;
	b=XAVpfjVDdS7AKqKk7fZtc54CmWcBL2Bz9zmK5ESs4anzkLictGDCbpxhvfrCkQWBzpZd
	 AQXByq8WDY7whRKHWyFVrqw6sDawa6uQSdLosgNaHC04IvP0rrLCbNmhYAbB6IsDWEmvN
	 T2T6MYt5NIGROwJGlxMvuwS5KCsM8m/RVwCzpYWgpXXl7IACaB9fU4hGE3AQo6+izLr/5
	 jk7sQLwm0WOE7kucJDciaTgJhNPooifqnBLRmiD6zsD4HBqix+4N5XE9p/tCSwmiMJ/Mq
	 n/DoqZ822Egiv/vsDRVJaNZjOMCeOBA2bTQV7NjQodfKcgl9a9iFC9KaJCNmXpD31hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tiKp3ROMg1EZkWfc/W/biI8jG+9mR4oFjD12BhSIMSQ=;
	b=PKmvfrKMhKUfsODgcAJ8CehZJ2nckqXRaExA44CUlAHooF01wMe68+d9/JQ4y2kXxMSB
	 6SouNPxLYVih24D8Of1za5mKShi2TQt74Y63OkcgUtSHsZij2DgxVzxa2V25UuwM/P1lN
	 +hab3E45v9A/fXryJOcQhrH6j5GsBf1SpVLH0JXPO28QGFDEKPztTvE/DQbcssQFuEx/h
	 xAfyTh+F5ZfoZpUNp5nUIi1CLyRYASSyvYjdWGizqCEqqglkmq+9AgE6wlh/BiCFTvukd
	 ox0aydVd9H35tPFyu0fmCRzds8fUazYp548Z0AFRFhnP1CYUCapyL6TTSDXpasZDusg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vv2DE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE29606A320;
	Wed, 18 Nov 2026 16:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vv2DE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E451F000C4;
	Wed, 18 Nov 2026 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017942;
	bh=tiKp3ROMg1EZkWfc/W/biI8jG+9mR4oFjD12BhSIMSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1vv2DE+1GPDnP74VlhACAOKN3GNlZ0/FeIZ+aISPj3HcHGxKYlsbHw3UksCG4E0O
	 hfP+zPQEQ91uXaTHF/YObn4UWNmj9cwqZuqCaGM+S0rJ4vuGJc232sks1kNknnn3Wb
	 6l3ayRpI0pmLO1Ld8kSogTsZyM535hlNrAkV++0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nguy=E1=BB=85n=20V=C4=83n=20Cao=20Nguy=C3=AAn?= <nguyennvc@greennode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1064/2651] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
Date: Wed, 18 Nov 2026 15:38:24 +0100
Message-ID: <20261118150326.285143638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 55237b20a052d..2820d94a5e8df 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1576,9 +1576,17 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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



