Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019923;
	b=Rj4reVoIZeIuVL54Xkjj9NfB9UeOvexv1r/AQr/GYi4AWsctTWK0iG5GKW05i3Ym1Jlu
	 WT4d64zcZTkYTrKaPPjLZeSqv9+4kIrWDuWOvzCK5Fa6W8nB6ZIpcPkOqZmhqk6QBiPST
	 qQuy+vA7l8lFq4Yy1doX19luHTd5qlAwzrvEAoRdRbPNC9rjc2xajCbfayekCG9E8mzE8
	 Wjqtd7L6bnyfVdGUB96SKohYaYCQ90pEMBXlLCtSk3AdmvFGBsncsoABbPrGoCoGz3Z47
	 1hhCJUBCD9xMjUzRgRS2M8j52v4dAh55p4hJ66h58csSqZjNodgCTrisvs+bhQH7vkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKs1jqkQVb8g6P/Ud6lx+sjjhvZCvZ45i5MJqcYGfLA=;
	b=R7VhvtBfx5MzcSDdU5aq4woo4Vglw6EnL8BIuULLNwgd8IWebsiwanYlZNhuKsMLci/N
	 9KWm5loB2IA1x+8nG30cwAjnop2vL7+rnwf0Znfv0LY0I4GkIeEUtHOlUPbSXAzZJDQU/
	 gDutbaOxvOp7YIJ16/xawoaCivMJLMLEX1tnv8fcccBDuqDEpNHHIXsFZld01ssFFeDYU
	 Wk9E+vn38TB20kCBXfzosvynWwinHbpQ2ou0TCiII3CmgJFulLB9YW+w+1810ysKoyTYD
	 pyNHjsEpD8enLZJTmf8ndujeVQcjbxyknSQ62eShFYIHZ8IiNYperwVRq6K86UOAD+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2a7dH16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D8606A320;
	Wed, 18 Nov 2026 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2a7dH16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6EC1F000C4;
	Wed, 18 Nov 2026 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019923;
	bh=aKs1jqkQVb8g6P/Ud6lx+sjjhvZCvZ45i5MJqcYGfLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2a7dH16gOUTX3HL4bLZgeL7bM15DYzwcrg3apK6LBScFGpzu6x4w8evlGd9EEJV3
	 TyqgSAdvEoxKeDqDtMkwQa0dmVIg2oL3nfeu/7td45idlqTHG7KwwGFQjx1RJdDxKo
	 id5YDgVOjSDW2IXOiv3p6O2MNgOL0P9E0dMoSVGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1768/2651] RDMA/bnxt_re: Use kvzalloc for QP table allocation
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118150351.078065532@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>

[ Upstream commit 724a39b36af94787d32094da87729f24a28888b7 ]

The QP table size depends on the firmware reported max_qp, so it can
be large and a physically contiguous kzalloc may fail. Use kvzalloc_objs()
and free it with kvfree().

Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
Signed-off-by: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20261013140427.256612-2-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 7ff587ce91269..e8a111646fc9a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -910,7 +910,7 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
 void bnxt_qplib_free_res(struct bnxt_qplib_res *res)
 {
-	kfree(res->rcfw->qp_tbl);
+	kvfree(res->rcfw->qp_tbl);
 	bnxt_qplib_free_sgid_tbl(res, &res->sgid_tbl);
 	bnxt_qplib_free_pd_tbl(&res->pd_tbl);
 	bnxt_qplib_free_dpi_tbl(res, &res->dpi_tbl);
@@ -927,8 +927,8 @@ int bnxt_qplib_alloc_res(struct bnxt_qplib_res *res, struct net_device *netdev)
 
 	/* Allocate one extra to hold the QP1 entries */
 	rcfw->qp_tbl_size = max_t(u32, BNXT_RE_MAX_QPC_COUNT + 1, dev_attr->max_qp);
-	rcfw->qp_tbl = kzalloc_objs(struct bnxt_qplib_qp_node,
-				    rcfw->qp_tbl_size);
+	rcfw->qp_tbl = kvzalloc_objs(struct bnxt_qplib_qp_node,
+				     rcfw->qp_tbl_size);
 	if (!rcfw->qp_tbl)
 		return -ENOMEM;
 
-- 
2.53.0



