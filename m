Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055448;
	b=Q927glI5PIJ8QJo77O4i9yWKxGYJmdGga3y7UjsZJNJj7dbWF0IUfGpsrW6W3TiZVq6e
	 UjJ+Qq3szt159qDHluzq3ebaTaA3rN5BxtyeV3nM5X0mqvYTCQM60H6NpS2GhxMQXn9YC
	 n0M39FBZdS7XSVwP7l8cgvZmj1KPkOxUb3frXIUir5idaM9w4EmmkfoqVRSR8vPe49/TY
	 Vyx3L3VnALxc1lf5ZXQxwMMsevTlzjx2A+2STiWldQElZI8wCB1WZ+vnBabqrMWeTenWL
	 QmaF7b24FUs5K4zeZ1zOLbailHg0iVy5JbncLtSLJnqDEGiy5PCpJuzkNItlakNZXKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zknluOSM5GSvFJqnYjYcePNGSgsutWLR/sVg1Wt0If8=;
	b=COJaGZTSPhlaNTlyKljd2+k27+N8m0Z6DkJC0DvZTfMVGiuCTQp+G/UrQDcBwH1JKZY2
	 ULWVbdEbAplSjmUvyQqvzNARz87lpXAePbLeL6Xo05PFN7iiYSmMGSnqUckqXq7iAXZXR
	 2wuRpawV8v4FaYpZfk71fqqkwj2bpGUqJMVu8xGvPceojffE6sd5sF/n8SqomJOxmDa90
	 riAotQNrXWF3Ji/QYE+Mkl+kiyz/ApTogzNzzjzATQSUJt/k0WaV9wtWLccQFUlt0ku1M
	 4FRMbTb1P8C930cy0V7ql8aFnzqGy2CZZ0U5qZsN9MQFdZBbzRyqySKgvriqSQP1Drg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHc2Hj29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E7606A31C;
	Thu, 19 Nov 2026 02:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QHc2Hj29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9C81F000C6;
	Thu, 19 Nov 2026 02:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055448;
	bh=zknluOSM5GSvFJqnYjYcePNGSgsutWLR/sVg1Wt0If8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHc2Hj29REo7pcNV9qffQZWWRL5r184BaKtRSvGcc6ZQvc2gYatXK62LHNd7OgHdU
	 YftqBK9+O72xZLtHfDKTlWB51jX0n8nJs7ayyEn6ELvNwNHLzLcdn9fGAvyoiAIFVd
	 KoCTLgwAzD18PgZ7lQzswJ26112sYuejquHEE+Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1633/2214] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:55:09 +0100
Message-ID: <20261118150117.276155039@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit d2aa15620e98dc4c6516944397ebea03b7a62b90 ]

mlx5_cmd_create_srq() stores the SRQ into the xarray before
srq->msrq.event was assigned. A firmware SRQ event arriving in that
window calls through a NULL pointer.

Move the assignment before mlx5_cmd_create_srq().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-12-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index dfed4c4321337..eff5e21e590de 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -281,6 +281,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -289,8 +290,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0



