Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061003;
	b=IrDS5iwGbZxgfziamtcHtFvYesenYOBSauI3Oa0cnW7aBmRZCZpIb/t5UzjkaNeGPd5+
	 U1qrfQ4q1mm0BT0PBQ067+B9Lht5VSbptOaAciGLIMThWGHPsiiU6eSaiKtivFT/ac/ec
	 DwEHXu6H+d92EREx5g6i9sdQE5Uof9nv7eOKJEg8kk4sQoHgEnaQflG0FOzwgsiuTa8p8
	 JOgDEmAT0YQQmZEn56t7lO1vtTRAqD/GgFiqPppQpmvp9KtAVKib9A1LbdAhXc8QT2EWx
	 AYlc4jp/w7E8bgmkZrhoZSpXcH2euc0s1mi+/87ziPbCH94FZSXlJ/cW1kRKzxYZ14w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IjsnHPAynMhEvNRVQz0s0MesYv+YyxJhVL1tUfrSD+o=;
	b=3oH8DxL6KZQ8fx7uiGoy7VmueAZakLq3rcLDTRymkmeFoHLnJzYLU0AqU7PGj+l7GGy/
	 Yk0mnupy4zEfsrZu3JMfqObWFzMMQ3O3W1uiw0zLD10eFgWJ/ul4v1FDfE4jwsGVmOvjC
	 SfeN/fwuuJJA0BnGheuIOYBK4ZWpGXwX1Vx8yZWS8i071++oOAH6/uicV92NvDh9anT/n
	 TXEyZERe1XwbVjlDe84j1A0+Ibq92bQkKo1TSfK01SduvjLaDPbrODCWpzZBOXYH+aQka
	 GYAun46MvGSQJb2uPv7p0m6nxBlMSUpxG3/y0KqEXEUroQCj6AXm6aJwE6gk//SPTkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqOsEo6l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CF1606A326;
	Thu, 19 Nov 2026 04:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqOsEo6l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1833B1F000C4;
	Thu, 19 Nov 2026 04:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061003;
	bh=IjsnHPAynMhEvNRVQz0s0MesYv+YyxJhVL1tUfrSD+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqOsEo6lo05uAEy4jVocCuLK7KSdiY4mXYfyCsKaQoVH194aHRNf/8oWnl2VZGEKv
	 V96lmdKO8Y54FubF1f4bbAXKN8wET5X/nVRG9qMY8wove0w3Jh02jWZNvvcUya7pvV
	 UePaxQ2t0U8Gi577qG+07opRKaS77l8IMvSkBPtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1399/1848] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150018.098281331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9454829290b62..7c9a537b572ab 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1769,6 +1769,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



