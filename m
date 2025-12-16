Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A33624D3;
	Tue, 16 Dec 2025 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887923; cv=none; b=PLBiOZv7J3vdL1wQlfc5/4IZrkiX1n+M4OG3B22c2p+yBdDiXwRQ/FQ3RIYMHenMyITYw9/+zwjajUALYOPU7zrI+03GUyL4d47LUnFHsEP3kbCiXsCC0c0zcb+dcD/GT9lPAGOhIVHvmIdecUZbMS62l5gOtcQk/EExW3ah72s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887923; c=relaxed/simple;
	bh=oli2fywteawu3ipDPp6Xy6i4lJu01882ppaMd2LkEkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZAf+hSnN4qJh1I43ihEjD7+JXP49UTjCVeC3acGsY6YMK4SgAb9Q2aaS7k55VUAoRwW8APwBRlD2AGbX3VKjcoTl14AfmBEKJoPlW4U/7N29/WE4pvaMLvKIHVrONhdmI6jvvV1UHaZaALFWUtLnhbPO2k5FK7WbXmb8yxwJAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt3GDhx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt3GDhx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BF9C4CEF1;
	Tue, 16 Dec 2025 12:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887921;
	bh=oli2fywteawu3ipDPp6Xy6i4lJu01882ppaMd2LkEkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt3GDhx/MTqisDAw4m6dKC+7GvtZxmNOZ0vneHX6ytS4+lOzmksHunWjfbWJxlG/Q
	 Zu8TTMuxfsH5omGiECIEZO0IeB7o1aofKsm6cC6A6GKiqJsFXljMIH+mB+Da8887D+
	 hYiKuQGXwI6tTzmrSFXUZp+p/H1FDTx+i6oZRg/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/614] RDMA/bnxt_re: Fix the inline size for GenP7 devices
Date: Tue, 16 Dec 2025 12:12:24 +0100
Message-ID: <20251216111415.021299127@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9ef581ed785c8..a9afac2cbb7cf 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -162,7 +162,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
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



