Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024822;
	b=LSzKTOgKvtDyBEJU/4qveeWJ2dDFhudQu+DwNJbq7F7o5ReNY15jzXaLv+VtICeB2fp1
	 94399pmotlK0VLM1zSEcvNr2rVJJA4+7szZIR5Qsg3m6r9OwRSw4Vn69XRI+6a6ZffqMq
	 h18Ur13HzHo620g88HBC67+VWFPO3pW4tc66qTg7P5632DuEB7fjJo+umQOpwSTvlGHu/
	 RuE677fEj+foZ0ltXIjIw05Mq/II9RgLoN1iuI6fHaUEmoWpmk0rbHtFf1RmVgJjoaW+e
	 GGEIZRQcScTNuKh/17MLKJPp4PnHsj9LKEfyYsXTa3rXoTF5lyYtaAQqfL0he5ap+ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q62Y0OvszQLgqkPt49748hgNp2bJsxrOE0Zc1XfuIqM=;
	b=wk6xRS14ntuD2CKo87XMryXH2gxmVDCcwdnEpnGFMbQotNJIuiOo/C1DFub7Pt1c37oK
	 puKe8CveVwEAsgHhiuivJ/PuUVAQnzYnRX78K2n+Sm/zb2MFfgZCM46EprzNTEkBcls4X
	 49Sr4Ii45en9pPlDkEwpceFnxkH+o6GxiJ7GMH8zidL7jW5lI8fkycuf7FIi4vYpbUulc
	 5fM2IeGS7lwuH6aHpWFZ4cMqi8OIyYGgQdcgR9yNnbI7pqjYWGsMOzQoLfoyHV7CMquno
	 KHDRJ8/Qfn3tmkAr0Sy5YFnT/GrrbUNSefJLhJ4mLxNcMpN09yMF4OkQ9iSZt4GSPQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jG1k/OLm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80A606A32A;
	Wed, 18 Nov 2026 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jG1k/OLm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9EA1F000C4;
	Wed, 18 Nov 2026 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024822;
	bh=Q62Y0OvszQLgqkPt49748hgNp2bJsxrOE0Zc1XfuIqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jG1k/OLmZdWz90YlnPNbxKUZYtfQr+aPSS/plsWxxOXxFapK9KHSWjNDtvb4GWPlh
	 6zmooAENdhJd2D/zSXHO1vKaWfOKppFpRCYyLKPgC9+jLicTgMqPY7/I/eywBoD/Og
	 kI83WxQiV9DXg6vX9ma51rp9J2q//FxiuokSBV6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0860/2151] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:43:15 +0100
Message-ID: <20261118150153.560316320@linuxfoundation.org>
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
index 656b39753f353..6e29ffc0704b8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2042,6 +2042,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



