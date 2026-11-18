Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024651;
	b=RLiCM7Djbedq6lvFs1MSRUIzN3yw2al/kx6/sJsOXs65/GqRvaWf4KctMnGuDAWUEm0P
	 Zr+05pd+X3adYgCSSjh/ko+ncAd7w0Cx8GuesB1iSV3TSykmTdWd9X5HIBmtSHJIjMAJa
	 HMsumpZoHdIUUKANt4A27P4Ro2JvW7lc+GuGKlM+P+7sFtLQfAnA5wk/b7FDSqGRvPbD/
	 8hzSWo6+zdmjPr/9/E2Uachx/p/VjLzPuwJaGqCzR6vtNRxAYsv789R6VTgcwqk2amqev
	 pzK/HfIdLLkgmR0uNmp1PqshmDTksWfsJpuu5aouCbRRjoOuYG1wTaooEQ+Egvyx+IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fgZnLPWi8u8t5XZSDTjTO/GZJX/0Af+jymwWC0p8af4=;
	b=0zLtWFFss2VgorS0XSsljDb2VoO+RLJwGcpt3diYi1Pnb+3laHz7+VUF8r6ooyWZBSNj
	 shgtEhrR7Ips2Ab0zF7Q9M23CTlxVEe1l3kwE2UNZUJuSi/BQUTarXIk8RYrBa2SIQ6BB
	 GjjUye5vEKiZOraJ6O9GMVLGP/dVSh0PmxONUxttXiCOFYSOglqnFG2Svgy6V9IVoRr8S
	 E2Fsjmw1iSAqrtAshA/z+ab6nAgkNZWbtTohI6yro7MdnwFcTmxHPbVMuGynRZJYiNoP4
	 Oj1U2d8NwHSj8Q5kvduY4ADw/EVPYE/Tw67ZiLoTvlhh3IdzAfayJRLPt+p/YcUwhZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZk1XSrn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93060606A320;
	Wed, 18 Nov 2026 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZk1XSrn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43881F000C4;
	Wed, 18 Nov 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024651;
	bh=fgZnLPWi8u8t5XZSDTjTO/GZJX/0Af+jymwWC0p8af4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZk1XSrnUN+2bsBXFwEmoyzBZP0xmEakCOVs054ptml77JDWLcIR8866SyBBEjk/n
	 wwcgLigpNbZ5sWQ2vpr3ZJikn1PYCyaScbunNMGRgMGseULKoWzZ4dn/P7N78+5ncr
	 TbRJQoHCQUPHDsXz8KiqCpmLGAPcHNyX+d79mU7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0801/2151] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:42:16 +0100
Message-ID: <20261118150151.248640651@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit a4fa6497002c80b55ebe597242a1bba2ff268886 ]

create_raw_packet_qp() creates a separate firmware RQ object but never
assigned rq->base.mqp.event. Any firmware event on this resource (e.g.
WQ_CATAS_ERROR, WQ_ACCESS_ERROR) calls through a NULL pointer.

Set the event pointer before the RQ is inserted into the resource table.

Fixes: 0fb2ed66a14c ("IB/mlx5: Add create and destroy functionality for Raw Packet QP")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-13-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1084bf154e0eb..865000d1a2c52 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1617,6 +1617,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.53.0



