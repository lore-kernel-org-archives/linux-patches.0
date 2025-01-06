Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92151146D40;
	Mon,  6 Jan 2025 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177345; cv=none; b=s3xhq16xjWdhRVBLTbT81p3uTwIcSYw1QrmxKHtm+U6FsDMVFWAwh7ZZ/7IPNLPLvB5U1jI3qfjssHemykNFyjPHKyGK+2ECl26e35JhsuZyBUEQ2I/30H1P/L3w4mcjBu/fzg6YX0B3d8PyfSnTaaqmjQHdxshP+epefaDsNos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177345; c=relaxed/simple;
	bh=xLBwBUukk027eRt3p3ROpz4CYVDpeOoPkLOkNDzG1Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2LlQA34VMtCfYC9wyAkLUGalTINf3AQe+QVPW2tQSOBpheUImAFY2yfEj/QGOw2iG4yTOU5hL4NYB9DHseoS41CFv03FaDaaKFtsMr0JmRPyVrwSYpIr6GxZSXJ3JlKD66WKFZQakxicuuaCRb3iKkm+76r78Pxg9bl4u/s6j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pzop9idb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pzop9idb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40BBC4CED2;
	Mon,  6 Jan 2025 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177344;
	bh=xLBwBUukk027eRt3p3ROpz4CYVDpeOoPkLOkNDzG1Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pzop9idbugU7L7wgIC9Rm5TwN60kFhxX0bIQ8FEdkcCRJhTT6XNmlkAoY58KzaknY
	 PdGym9XETRfvXw0vJkTDABykJLbKFGW0Uzw5OEdcD0BGjpPqfK1oULlO/KaE1X/mqe
	 CIQ1CPO9OyJfdAcpYGw1GXaoGB+/Bv/N8wWTlg4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/222] RDMA/bnxt_re: Fix the check for 9060 condition
Date: Mon,  6 Jan 2025 16:15:37 +0100
Message-ID: <20250106151155.803302677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 38651476e46e088598354510502c383e932e2297 ]

The check for 9060 condition should only be made for legacy chips.

Fixes: 9152e0b722b2 ("RDMA/bnxt_re: HW workarounds for handling specific conditions")
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index d38e7880cebb..8997f359b58b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2536,10 +2536,12 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
 			bnxt_qplib_add_flush_qp(qp);
 		} else {
 			/* Before we complete, do WA 9060 */
-			if (do_wa9060(qp, cq, cq_cons, sq->swq_last,
-				      cqe_sq_cons)) {
-				*lib_qp = qp;
-				goto out;
+			if (!bnxt_qplib_is_chip_gen_p5_p7(qp->cctx)) {
+				if (do_wa9060(qp, cq, cq_cons, sq->swq_last,
+					      cqe_sq_cons)) {
+					*lib_qp = qp;
+					goto out;
+				}
 			}
 			if (swq->flags & SQ_SEND_FLAGS_SIGNAL_COMP) {
 				cqe->status = CQ_REQ_STATUS_OK;
-- 
2.39.5



