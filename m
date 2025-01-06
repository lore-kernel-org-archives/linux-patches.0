Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E7D44C7C;
	Mon,  6 Jan 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177774; cv=none; b=jfrSlNVT5daavQzURqNRKT6Nu+Yw7jTfLra544R8FGPFHqH426RIPelBcSCSEwd8ENEyyd0Z/pf7cyjm+hzk8dVPYZGRweykHBZO9aJPzQwven0pON7xY/GhOR0iU1UvcYs7GwMyQHZv68hAydlcqAfwhCU4NOia7rn8yKhl/Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177774; c=relaxed/simple;
	bh=CFTjEREH966mq3+UnFnO3kZ/hRtW/O+n6sDmAZiemQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI7V+Z9Bs3wj7p7CRvXKhtgt9XnBhKXsfZtnxq/8ZjgbWR+6ovaY3Zt3HuJ+19eZyGs0CtqGljUBsJYwVpVbpgW794XgsUcx9lsqEkNms+4CxmC3b4/JCAQ5vKLZHK8xrcb3x0IcMzCKAc7HbCaZmHWHnsEGtOObXzIB2EUiggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHfIS4hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHfIS4hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8BFC4CED2;
	Mon,  6 Jan 2025 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177774;
	bh=CFTjEREH966mq3+UnFnO3kZ/hRtW/O+n6sDmAZiemQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHfIS4hresulGe43nT0i6bJ28UjYNVnaYXC48JrzIclcvy41GGH3tVizEWnnuMh33
	 KkDfgx2GZiWJqfCYzjk2k3CAfd6yVlONYRiotNCDdLbKJrLI94ZFW4bBD+xRYXQ54z
	 iflwgnUuP5+y2CtdF21u2DNIjj+Pt71MOUnb/HjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/156] RDMA/bnxt_re: Fix the check for 9060 condition
Date: Mon,  6 Jan 2025 16:15:07 +0100
Message-ID: <20250106151142.541548609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5938db37220d..f5db29707449 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2598,10 +2598,12 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
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



