Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFA31A7EA;
	Fri,  9 Jan 2026 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959857; cv=none; b=FdMh5FonDFL14KVaVb1YGS0ioiRn8IMnvv2w57yMyxV20ls10SQXTaLwtunawDIR4f/uh1/ybSCW1/GCAdP/UPTW7doCgRmiOcgJMdRVvYWQuP106Rri/ASYHUcj+9I9/bkeq9iiSGLZ/17e2zFCacAw14PrbTK6gtJULfesz3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959857; c=relaxed/simple;
	bh=Aud7brorSkkvXky/sf3Pr50ZimX10brVgFtc3iq6qAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZd3z7L3gjDt+87WY7iO5SHOJsX7oWP9MxEYixCA6GxOeTHrBYOBO1YPbfwDzFjFhQROEHsPctZ4/aIWHWm4bSIyN3nXvkwi4rH7Wv24y1UufL70FuDqtdBAQE3NtBryMpSx1gXDtTmSjMk0F2zCRBjELdZECzg89wVwaRgVQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCNehZxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCNehZxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07AFC4CEF1;
	Fri,  9 Jan 2026 11:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959857;
	bh=Aud7brorSkkvXky/sf3Pr50ZimX10brVgFtc3iq6qAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCNehZxXw2BINaQFTR6hWw3UCGwTHqlETa41eHlDO8Yng6845NwtWj2GLgqJ7eOki
	 gnA+OPFLaFxap4xzjUQpEOX8eBxQu9FYhUz1Xfe1C8ThARMeMdfodajEykETrCK+Mx
	 CMAbSoFcDwJzGlFIYHh+lXvhNs/ub8ja1iqzJgWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/737] RDMA/bnxt_re: Fix the inline size for GenP7 devices
Date: Fri,  9 Jan 2026 12:35:38 +0100
Message-ID: <20260109112141.489069977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 6afe40ff484a1155b71158b911c65299496e35c3 ]

Inline size supported by the device is based on the number
of SGEs supported by the adapter. Change the inline
size calculation based on that.

Fixes: de1d364c3815 ("RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters")
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1763624215-10382-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 74c3f6b26c4d3..0b713c1821c3b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -161,7 +161,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
 	attr->max_srq_sges = sb->max_srq_sge;
 	attr->max_pkey = 1;
-	attr->max_inline_data = le32_to_cpu(sb->max_inline_data);
+	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
 		attr->l2_db_size = (sb->l2_db_space_size + 1) *
 				    (0x01 << RCFW_DBR_BASE_PAGE_SHIFT);
-- 
2.51.0



