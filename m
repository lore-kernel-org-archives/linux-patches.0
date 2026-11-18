Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048922;
	b=1hkQyx8cf3b0055iNwe0srwG5aFG0+UjbR6xTk+oOZabko6o/k7jmRcc997Mzoy9hYmr
	 vMu1tooEmXEX+Se9YD0fnF+Eu8Mik26grZ6+QpOB4uYzTzdnVcbbhMUhviNJ3/1raqtrm
	 vrYYD0AlaIk192Vb6cs/mdpX/HBnSYNm2BjEDEnvHs1OI4HalLVEgPq4S7wYIMVXBP4f4
	 fZcGq41LWClB/e9RxWYM/96EdAPbyF1aze9jUDWsVWsSll75e6x6KjQbaqpTU86d6D3Ax
	 XqfzoFZIKjTTCNWRLOn5rwhknJ9y76tqjfJCaVOkRqNSsxW0eIDyEA4xyD0CCwD2Yrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tiP41FY1usQcI0XCgsqw53j5gx4oogR/JXEs+30YoNI=;
	b=4DqiZP8eBZAaNYZ9+M+MMeww90anLwGGeETCpNQL1vDmvED4IIMr7v/NlrpKUihfg+CR
	 zLSSxdU9Sol9vM3qpc6E4R8nq3OgQ/N4SMqsRQj94S/fsPMHqwvZifxVuaf9AP4u1nVmz
	 XgNkSh1ZmpmKKp6IMxUTWGuGvqyUwOglOxdPfgNovCUh0V8yT2/gND5zg0VXKKX7DB1I9
	 KyJ/RC9FCUm2hI9aPWegilWlWCF9iLYGoZo3jCm4/nCdh4UemO8fCKIDZZnkF9F06VR+O
	 MG7P8AhwcQfpXDxyRnSNeaPKWwCH/4j9dYAI9ld+rqz2A8wNs4DsBWVkcQUuO+e7c1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syYT46Fh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB6606A320;
	Thu, 19 Nov 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syYT46Fh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8741F000C4;
	Thu, 19 Nov 2026 00:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048921;
	bh=tiP41FY1usQcI0XCgsqw53j5gx4oogR/JXEs+30YoNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syYT46Fhec4y4/4hIYkPA3MO9tSx7/qgqSHMb1SjuPWpsY0Z2v+CtNBAI253UXX5l
	 07dGh9Bv5JBL/g3qMA9KMgxPddO0wdA2FlwHYkI9Hk7hAM9I0oP13KLcXtyNDJlLdy
	 LqDXMIRTcQ86JQBSfLqIeGE7CCakn8gjfc8ml35A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2127/2857] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:52:41 +0100
Message-ID: <20261118150317.986957029@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34548929520a9..35f39f84f90ea 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1770,6 +1770,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



