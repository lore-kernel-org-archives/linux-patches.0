Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2302C026C;
	Sat, 17 Oct 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254488; cv=none; b=MHoAXndXAvA9uG67cxXi6JcA8SCNLoBmN8z6Gikiia/cVJ0eeFwc8Bmc/lAoOPv/CSf8nzHNKca8mucamF7heNeHFV38vWy6DIp8aljJBQ6JRlbC/zJshgPGLYGnvyicgQesqKaHPK41OOJKibR2osGUbitD3KR6kVusXHZtcVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254488; c=relaxed/simple;
	bh=4BdVh32epVMxJl/rrMx3LPybbm1VoZY2FeKFKQNsff0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoDZo7eGstlRJcEKeYhe1hPgCYC5V/HW+o9INfLuHdJWvZE8PET9hwUAivWRg6eHo4fedCEtwnpeFs16fp7/+ka5p7IqOk6Zw2/eDd4Ltg3dSgf0loTXjq2CE1K5it2V2wsV1FArFKHn5Bzcc2gKzAZi0+1RMbPBhu6mQVcDR3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5ev7g8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5ev7g8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A294D1F000C4;
	Sat, 17 Oct 2026 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254487;
	bh=dPPRL6iQ38yQ/xyDj30MIcsH96+YXrJHBfUNSvufwbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5ev7g8qsWzxDlJE4vLEakyDztrqcDjh7l3kyltRsG9VmOfMsz5Jkud6yqjxZxnUB
	 B6VgLZ1zMogXD2U/cr3Tc30yFXeEPaUWx59k/YQazumruVLU7DtCQ9MpseJdqgbQM0
	 jFcKx7LnmxgV39ITlqu1w/X0Sp6nzdRr8s9HG6IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anantha Prabhu <anantha.prabhu@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/869] RDMA/bnxt_re: Initialize dpi variable to zero
Date: Sat, 17 Oct 2026 17:55:03 +0200
Message-ID: <20261017160048.976387138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 978b27d6ce538bb832ccd69e45802824e4301c4b ]

dpi is initialized only for BNXT_RE_ALLOC_WC_PAGE, but copied
for all the cases. So initialize the dpi to 0.

Fixes: eee6268421a2 ("RDMA/bnxt_re: Move the UAPI methods to a dedicated file")
Fixes: 360da60d6c6e ("RDMA/bnxt_re: Enable low latency push")
Link: https://patch.msgid.link/r/20260615224751.232802-2-selvin.xavier@broadcom.com
Reviewed-by: Anantha Prabhu <anantha.prabhu@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 4e3086e6340ee..8231fd9b665ce 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4429,8 +4429,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 	struct bnxt_re_ucontext *uctx;
 	struct bnxt_re_dev *rdev;
 	u64 mmap_offset;
+	u32 dpi = 0;
 	u32 length;
-	u32 dpi;
 	u64 addr;
 	int err;
 
-- 
2.53.0



