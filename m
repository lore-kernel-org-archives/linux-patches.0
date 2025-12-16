Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE27334F469;
	Tue, 16 Dec 2025 11:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886139; cv=none; b=b8K0kgGsJpnY5/O4V0Ddk7AnsVsQLxPXQ0O816QyKK+8LfBd/qO8IPjOkjY5HjPNpLpe2WnPmtao2W47JtWjJqs7qJnMyf6sK32BLmQ5TkblbS2RSqzvID3AetdtSAUHRcBoCvSaEVEOOFFwAJkEPAumEKvwxWGczbTtE7uAXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886139; c=relaxed/simple;
	bh=cTISUqNg1cs6Hag7vJy5/TJoFesRmmmNJ0A2pQDkIy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYZIrrkuRo1mTm1ibmDmemwNSqK9hPakplz/yLmCGJCBNhLAuGbOCquz7+zR0bZceTa3l5lDh39fsISWMHpOgZ1yS/wXzHp5tpbiRuY325J62L5SMX/Q/Oogh+FtN5peuf5YEQJHEKHtsElUSTZ+rMZ5ADrtHDXx0vIcdjvYhg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fY1XAPWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fY1XAPWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC56C4CEF1;
	Tue, 16 Dec 2025 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886139;
	bh=cTISUqNg1cs6Hag7vJy5/TJoFesRmmmNJ0A2pQDkIy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fY1XAPWGbt69opYooc/TyvWKbF3AvkMo/5myXeOJsWeuHnavmU6pusUPr8B6wbj5L
	 DIaNp2rXHvFaCbGjxZEK+fnbJ7J+UZAh5RnoncjZksC+G1emG8V06QBWK/l6Llkvsd
	 qAuMbev8DC7nidd3YfUsKqkJTNdOO5hWYlOi2xwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 317/507] RDMA/bnxt_re: Fix the inline size for GenP7 devices
Date: Tue, 16 Dec 2025 12:12:38 +0100
Message-ID: <20251216111356.953549764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 68981399598d8..f40b7d1692b06 100644
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



