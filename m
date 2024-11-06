Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184271F1301;
	Wed,  6 Nov 2024 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896761; cv=none; b=hRnjlqIOVV9iL/6wX/CqgdnDH3c1m6cREbEvne16Q+uSAFuje4w37B7ySkAqfX1Craft6gIUIkurDyq/Dmgz49mh1OqmSMFCG6mZRENGxLghaMM351XRMAdvRQeXdrjwiBL2XmMdSn016K5tqmAWRuWAjttwuGaEcRDTm8KUqc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896761; c=relaxed/simple;
	bh=Us11hKd/Z+kKz4ZR8TO4m5gAWPQgjQl2xvkoSZQF5Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZrmKDFCxc30MIOhNiSadq1DMVuT244mtpHUJmBiU5r8TLSVfsFPHGJMnv4j8T1oTzhxvGzQo7MCPsP33cC32Jz4Oq81mZyIhHQtw5RbAxl0Zxmafp1kCXy3BLWv15Kzr97UQnjnmfDTVGUk1wGBMDalb6aob7eT63YnWfxOSQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxQ7uBWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxQ7uBWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D2BC4CECD;
	Wed,  6 Nov 2024 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896760;
	bh=Us11hKd/Z+kKz4ZR8TO4m5gAWPQgjQl2xvkoSZQF5Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxQ7uBWzrsxS9VQHPzJroi318A51qn+SkCWcV1cM8dCiyxah5+6WCkJZD3/X9iPxE
	 BX9ZOa1zkE7sfgL8ArryHa7jRh9dC4xUjusLtZWu/xkOoNsOxoNOvWVAwJe2YYcdQo
	 5UWowCY4l1HxqFI3LOI+2CKr6qbxNKgIdToQBd1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/110] RDMA/cxgb4: Dump vendor specific QP details
Date: Wed,  6 Nov 2024 13:04:28 +0100
Message-ID: <20241106120304.907500360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8138c57a1e43b..2824511e20ade 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -472,6 +472,7 @@ static const struct ib_device_ops c4iw_dev_ops = {
 	.fill_res_cq_entry = c4iw_fill_res_cq_entry,
 	.fill_res_cm_id_entry = c4iw_fill_res_cm_id_entry,
 	.fill_res_mr_entry = c4iw_fill_res_mr_entry,
+	.fill_res_qp_entry = c4iw_fill_res_qp_entry,
 	.get_dev_fw_str = get_dev_fw_str,
 	.get_dma_mr = c4iw_get_dma_mr,
 	.get_hw_stats = c4iw_get_mib,
-- 
2.43.0



