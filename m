Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030222;
	b=KMxMKXaOSKIWigJAkOaVGGvKLSgnLf9BSTKMR9cy2+DGuQ00fDyKrj48zqB5hE7dHE9+
	 QQYM8x/5H6JNibhHRCTlRs03pRroiliTldEAyscoVstfs4HC1v/iKujCGEeW2BUBtJTxf
	 TOGSQGuPHDgC65c/sdD4tD7X1h2PvzhS/jADgjpIkO5FaMHtsStuf9ktXGb1OgA/D5Hqe
	 ELJ3xzqbeaHpig5Wd3EJmcq2F6pu0sJChbKmnrL9xrdJT196pZmr16T1/P0Eq1lzGJGVJ
	 lLXvqzorLyLLViAowBw3W2/M3HAsolA0U/ORlFrBrpuE9soO0Ophtgfxb5iQ36jBtLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCLGgtxeKk91FHedg2ZH+1QfErEud0oo3wsOo8iQC48=;
	b=D9hl4kdSZbrgWh5148nV+RHvH0tyAti+tWNcOe1pxb+hU7Taf1ztvXxavzLBQDHGPYw/
	 3F+iy/OuNWkVIYMaGNvlcW2VN6lwAwVdSDE4KEay+BrmjL/POn3L/rpoLESVqLn938NQH
	 FCfCGnvwcsdJURUyvIha1zeWA9fxLxOAfi//3YtFxyW0r8fc4Ah9RgFSsXUMBxjRPE7rq
	 LuYSJZVA26u8u0Tv5H7ul1/aUaJ9uxqk861cetPfEAkIYXymQIW1bT/Qq45wv5EADbzgC
	 PpXzEfCKKMmcZFJ4WG++OijhuwtDmJGtagDELgKiuITveNAdHNQwe4H11uf4V7XZz1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+zm8PkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3B6606DD09;
	Wed, 18 Nov 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+zm8PkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB061F000C4;
	Wed, 18 Nov 2026 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030222;
	bh=bCLGgtxeKk91FHedg2ZH+1QfErEud0oo3wsOo8iQC48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+zm8PkYMBy7bzpl0xqHDjWvSyIvef9V05dUU+/9eicO8bX5gefe5/OcrqH1Zx0Ri
	 cVijzpXPLXqzIJOh8H6nPeosur4vPTIx58966CDZ17g9LAhv0xQen5qJ7+81qpn34c
	 v9b4Wa8GUoKZyye1MVxCDaHFGwftFyckqS9ENS38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0628/1756] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:45:55 +0100
Message-ID: <20261118150033.883807386@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44c16bbe3cc17..2a71aed3b25ac 100644
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



