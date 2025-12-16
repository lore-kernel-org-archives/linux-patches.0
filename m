Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880BC33D6F5;
	Tue, 16 Dec 2025 11:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884609; cv=none; b=rhxxgtQDnXGcRJKhg6xosNo1lNGO1gWN2AI8Y4x3PxJhWIe10e2Z78+JlPoC7SvO3WMBBOiB1xhu9rQdm1yfewjBknDOu/vnhIv8j5CariAWA/oi4It7WLT+P2Wcsg4SpEAoE6P3/7i/U6sRLWC32LATw5W9MVNITYMzpo577jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884609; c=relaxed/simple;
	bh=sWH58wR/PoQgFZ8EdbGvdWyh6TNIwgT10tE+5E3q9eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKiyvNC4s6Lvz1cbWc1fE63Pz+0wtKd6zOFQv8E5pqGpDZiv6hVKb7+ovCB7PIXRtqJCaXx3pxQ2aZHLubFz/tfh3R4IcPSr6OO43cMF3TBhGoFAzG8EcD9OACEHVwOIKT2GVGxT1Bq5lAgV8MHdUc5eeDEMavEPHJeHDGqP5MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUDcbSG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUDcbSG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D35C4CEF1;
	Tue, 16 Dec 2025 11:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884609;
	bh=sWH58wR/PoQgFZ8EdbGvdWyh6TNIwgT10tE+5E3q9eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUDcbSG7f8K3mfX93JViIbjHgH2wTgCwG6CA9b+2M8KqLiHWYrYekNJ87BA2PmzLB
	 z29MRNg7yaadds66FpquBA63zINKrVgzgjybPrbgvZGwnjWZJgbYQDdj5ncqgwh6Z8
	 LpJQvGdBv1ytz2EEqOv131TdRqEcsh+4PrgZvofU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/354] RDMA/bnxt_re: Fix the inline size for GenP7 devices
Date: Tue, 16 Dec 2025 12:13:00 +0100
Message-ID: <20251216111328.636940586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 807439b1acb51..59093d78062d3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -161,7 +161,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
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



