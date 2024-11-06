Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51830646;
	Wed,  6 Nov 2024 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899132; cv=none; b=TVP4u1SlYQn2LzxXL5lOcJUghvz4T4x0CkMDLttnRhChOysfKrP3u2My45HHA0NZHILxNTm18SWXSSxtP0uGoy0679jQ29iFEE8W5RJhkYd/Jm6LoZmyTIPL+y9ZCjNu6CWKVfGRn/pjMbkPZVCajK6tjtPNZ/PZOOiRlXyQ10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899132; c=relaxed/simple;
	bh=Amheh2PjUFiRf7jwEirNHqH0hx4gKHN4p2qVokvxcNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWaawCTKVr+9gkG7wsqaRdtEiwxT0ivu7ROd+ZeQhLdBh12Rb0xRaFgIz+BrakQNTGtL8v6IFGdDNVK70eMbsRB+xSdZE8XiozCOf8uXnqYKop+2OlkAMJWkGYM51QxMFJUf3Dd7c3g1lRR1ASSuuPO6Bf4ywqK9uzWhOpeiQ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwe2TqLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwe2TqLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C13C4CECD;
	Wed,  6 Nov 2024 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899132;
	bh=Amheh2PjUFiRf7jwEirNHqH0hx4gKHN4p2qVokvxcNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwe2TqLl/Bckq1w7ktrZVX3hD29gDx1zYkNfo5IMmw1VSHeKS2qcowEqGrERHQYbA
	 3CrR3A/ygWi5DF5j1LbyPqSFvC/mIAsQyd56zRvCeP9PYp1Y7vp9ggj5Ktz992qggu
	 9nasXDJnJ8eygKyZJNJJF59Gk7hoATr57tmXmYFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/73] RDMA/cxgb4: Dump vendor specific QP details
Date: Wed,  6 Nov 2024 13:05:14 +0100
Message-ID: <20241106120300.270830152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 89f8c6f197f480fe05edf91eb9359d5425869d04 ]

Restore the missing functionality to dump vendor specific QP details,
which was mistakenly removed in the commit mentioned in Fixes line.

Fixes: 5cc34116ccec ("RDMA: Add dedicated QP resource tracker function")
Link: https://patch.msgid.link/r/ed9844829135cfdcac7d64285688195a5cd43f82.1728323026.git.leonro@nvidia.com
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Closes: https://lore.kernel.org/all/Zv_4qAxuC0dLmgXP@gallifrey
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index e7337662aff87..8cbbef770086c 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -469,6 +469,7 @@ static const struct ib_device_ops c4iw_dev_ops = {
 	.fill_res_cq_entry = c4iw_fill_res_cq_entry,
 	.fill_res_cm_id_entry = c4iw_fill_res_cm_id_entry,
 	.fill_res_mr_entry = c4iw_fill_res_mr_entry,
+	.fill_res_qp_entry = c4iw_fill_res_qp_entry,
 	.get_dev_fw_str = get_dev_fw_str,
 	.get_dma_mr = c4iw_get_dma_mr,
 	.get_hw_stats = c4iw_get_mib,
-- 
2.43.0



