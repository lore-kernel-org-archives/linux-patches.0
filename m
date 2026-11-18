Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024932;
	b=lT7ezrvMxDSndSkoy75S0w1HKAjvsT3bKSCS3hQ6Je0mhHNsAGL5JbAG05fyU4ecG1OY
	 85tdFwiuFyyK1UwAc/I6X133GB7HjBDq7HQ0bXdi2L0AaPmHO/MlZxF2ZLUXsmPuicSAk
	 Hak1eH9bCzZNsP4nq650Vjf0Vt2Yb0TZFiFjaq6cGTlJ4+H6NN3gbQFKtYYq9cpK36wpI
	 YJO+qZK4YzgB65y2bkTluWWlK9vGQOEpYXS08TMtXUXiiL0Ct95NAScwb8kjfEzG7nn1i
	 JvVRqeZ/0+sNi1q2b1KNOYo7QxeHpaVkcdx1BIvqKCm5/xSa1WjB0+fdvXXKLgtDZYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rwH72d7rnOTiTW3qloK9UXkS8v481qCTAFA4O6qhNGE=;
	b=TfoqEdNLp0EBUQJDrejEcff+hF5gwSVAw1hsIn2Y8lGlmaWgPf6gB8n2FEWVuM94LNPG
	 /vnp1m17twSyPexao2cnSpUhCLd70nxYEsTVEb++FfKDIZaDGWZ0u+wODAzD5EnRLhPCT
	 F+LwQdjC/ODrjcZlRDRu57xJ71bmOadWsIO0AVYP95ZWjOxGWlIsbzkpGcZlluXMKofLZ
	 CHNNxKhRvEusruL3KjrK/xMAc/MNtXNUAgucYtkVhNatoHebOqsCqQapvAyF0WtnxAu6t
	 3Y3r4nR3l6EgbJJV90De8t3IR4nRxZi3PIOYxzMDaw4C9RDzyvLaBaTLmFH+fQOjNWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/LzKxYP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC45606A31C;
	Wed, 18 Nov 2026 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/LzKxYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05E71F000C4;
	Wed, 18 Nov 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024932;
	bh=rwH72d7rnOTiTW3qloK9UXkS8v481qCTAFA4O6qhNGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/LzKxYPczvZHydKFR4Qhx3uX7NV/GJ2PeUJ4PKvRgtwEg9tqj9oSd2X1hs4yvZW4
	 bgVczy0SvtgOj5dLCFpRV9e7dJOJVyIXSKYS91SvcDhh7QJuVdHMFxpZRplOEr5Ahx
	 /Q1ldILGUeYE+s6sot9naKcMq9RzKIkNtdP4NlfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nguy=E1=BB=85n=20V=C4=83n=20Cao=20Nguy=C3=AAn?= <nguyennvc@greennode.ai>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0899/2151] RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET
Date: Wed, 18 Nov 2026 15:43:54 +0100
Message-ID: <20261118150155.042181388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 950950038763f..9ee59f0ca9c79 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1537,9 +1537,17 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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



