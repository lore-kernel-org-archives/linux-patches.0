Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A071119AD5C;
	Tue,  8 Apr 2025 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112575; cv=none; b=GMDGMDBuMYsM9UQ+7mlwX7oY1DX3wj3RiXBbdREmq1R84hX3OA2AcGlMhp7Rz+7++qWVVbIlEOE+QDk49pggR0eY3U8inOuWrGlp+97FLt1u/mJlYfi1DJ9TxrOQHshe7KpMwyTZopIgbZzmlTn6K/U2SAcjTth2UCZR9OcE4ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112575; c=relaxed/simple;
	bh=neTksa80ZzCiS5XyojV0ZM4KL4UZ7+RMZ0JlcmJma5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1yOg/iu1UolJCurfNZxaSeKOnHBfGXHK9C215VGvkKVnOHUkAJfe0GsCD0t1g7Tfk8qfsHz5UxSh9/IS7nqUvItmJvveUbsX9Lo9OUjFDN84+U6rtXQzI1pcV5d+oo8MBJMXvF8+knYB86nZm4fiw1374kmokE1oFFIedSfC/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+QNZJCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+QNZJCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06812C4CEE5;
	Tue,  8 Apr 2025 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112575;
	bh=neTksa80ZzCiS5XyojV0ZM4KL4UZ7+RMZ0JlcmJma5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+QNZJCm7D5tt5xM7qkzeHYNAxPr1I7X2WynE4benIJ3vBHSYvrhHjRWqcPmls85g
	 oDdD4JzxsR8sLBj2T4i2xCTzOYwGO0sL5tmuVvQoVf/HcldluB/Tczyodv966vbpsW
	 3gRuiojMGJgoTyUSuK2IBNw8o9rtz3tag7HuhUtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/279] RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx
Date: Tue,  8 Apr 2025 12:47:45 +0200
Message-ID: <20250408104828.554763576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aaf06cd939e69..08ea292512797 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -220,9 +220,10 @@ int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
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



