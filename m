Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030392;
	b=NpWU2VNHraAKNrUkkCYj3xAok2Cl3BUpi7d4fkO9i/z0T8SZy1z2Xe7HEjZlfIOuHO5c
	 mkA1fdm+2ujJb/RMl7Fl9O77zAZkK5P3YaAyiQXCXD7htpqHnX2dxnmyluuoMrBBqvcvx
	 Rw+tI2bnPS0tSwvuvBYa/Yg2Y6OXgPx5NG6i0fyFvG8aSV/R3DkHUzFBEjkO4LFpz+32s
	 f8WDt6T2Ei5sw/lAfdah2QJm+wbonE410WghV77V1ogf1w4rl6pCpiLaDa82c47nWtD7P
	 DApP+DtM2s+puZgnPhscXOUM5Ys5CvbPxFF4ml4UtWi/Jkzg1FRJIr9zGQ7XO6nDcYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNvaeAYVzw+EV55ZdM5NdwZuoaPxDuvUqr8gTMRyhMk=;
	b=1lb/GUZrqASHmIE51LF5P4mCoy6ogm0iOjjTYtXFj1Mg0jiaEiJW+Ig7yKonBN1jTvRh
	 5LhqLrOdBaCJ68NbGkWo1uClGP9lZABS6ea3LurDcop2J0AMV1QlF8ryjIqcto5p8thvX
	 CqnbQjk1GMtKzO2EGpNq+dLP0kuRo4uFuKUDcankAbc0ltGaDz78va6fdWJW/t9kL04OT
	 /w64GxK5FlPOUbxj8/B3n+pTBD4Lo54YoWqPerihmFRgC9K/YCjIgO5SSmqDhIeW04LgQ
	 Qo9vq1sm/JRkWnsJIl7sVi0eTCTLfLK6ZvffgIGXYahaQ5hAvurW0UUCfeThdWdwPgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7l6qSyj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC03606A7F1;
	Wed, 18 Nov 2026 19:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7l6qSyj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED5E1F000C6;
	Wed, 18 Nov 2026 19:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030392;
	bh=NNvaeAYVzw+EV55ZdM5NdwZuoaPxDuvUqr8gTMRyhMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7l6qSyj2iT9Aof/OBIdDlaaGGn/6wT+YFUJwNI6Crs++P812/6gSIn8dqgH5cZX+
	 90A46VyqF1WGJSahyExrJETXLscdaeWmkOTlqJlnJa/Mlxc0+sg2f9HBFby71u7jPz
	 jcXBW7xAf0yoR9gIdMwcLyvwjNn+t0exbfGsYQiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0686/1756] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150036.538790379@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 4d8168a3b7c93385c11dc836df569d337089b218 ]

wqe is declared once above the WR loop and never zeroed, so
wqe.flags holds indeterminate stack contents on the first WR and the
previous WR's stale value thereafter. This propagates straight into
the hardware-visible srqe->flags in bnxt_qplib_post_srq_recv().

Most values of the wqe struct is set except flags. So initialize
flags also.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index cabed393390dc..e9f47f96be1ea 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1936,6 +1936,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



