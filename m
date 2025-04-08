Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6726A0C5;
	Tue,  8 Apr 2025 10:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109837; cv=none; b=JIclxavk1+DHByXh5QcsJ+RRru9uNeQtlrUhA7pa3qkEDWEnBV+zMYSNicL0+KTcw3ppbiJQy9D5QWot2FP5gc+wbgPvzCyJhyiEyeWrcfp+h0GMcOgH9TEqW+coqCCyyid/ubM5+YcX5rR0LleK4VdpbUC6E7EoSkEYHALeod4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109837; c=relaxed/simple;
	bh=/zgzjqlHXFoziw0ik+BjE4wWd4/Cr2qhYWcA/KQFnEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qENka7BmGtuRB3gnHlFH8+I8w/RFDdguZvF0aUQr6aprNyVMi+kRw86iFb7xAKTuGjakmbXBlvN5cnaye/tPAzpuNSvN6uUvTce+kr00kAGKpD8/SJxUEPqgC6pvI40X9Ysc1tQbdyrxJUyn8mb91GevUjAHgMKg0klvvCHlrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjLbhMYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjLbhMYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14534C4CEEB;
	Tue,  8 Apr 2025 10:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109837;
	bh=/zgzjqlHXFoziw0ik+BjE4wWd4/Cr2qhYWcA/KQFnEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjLbhMYFBU2TNYBTARhx1rGBKPerZ425z4KPRPi3DGpqhUBSM83dF07qMRAGLDtaL
	 frjPgyo0x+5fuaaQL8NfL4DRGHKRMLGkKgQi+Q6EnPLcBdcDxby5rnYG6b6oJadSCr
	 Vm8foMyJRGw+3JRN0Tb2Nxy3ilopY6B2HFSB89bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/227] RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx
Date: Tue,  8 Apr 2025 12:47:28 +0200
Message-ID: <20250408104822.501416665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 67ee8d496511ad8e1cb88f72944847e7b3e4e47c ]

The modulo operation returns wrong result without the
paranthesis and that resulted in wrong QP table indexing.

Fixes: 84cf229f4001 ("RDMA/bnxt_re: Fix the qp table indexing")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1741021178-2569-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 69aa1a52c7f8d..db98fac4b5624 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -218,9 +218,10 @@ int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
 int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
 			 struct bnxt_qplib_ctx *ctx, int is_virtfn);
 void bnxt_qplib_mark_qp_error(void *qp_handle);
+
 static inline u32 map_qp_id_to_tbl_indx(u32 qid, struct bnxt_qplib_rcfw *rcfw)
 {
 	/* Last index of the qp_tbl is for QP1 ie. qp_tbl_size - 1*/
-	return (qid == 1) ? rcfw->qp_tbl_size - 1 : qid % rcfw->qp_tbl_size - 2;
+	return (qid == 1) ? rcfw->qp_tbl_size - 1 : (qid % (rcfw->qp_tbl_size - 2));
 }
 #endif /* __BNXT_QPLIB_RCFW_H__ */
-- 
2.39.5



