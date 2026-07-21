Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD6D2417D9;
	Tue, 21 Jul 2026 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659981; cv=none; b=DrKxknWP+CAsD3hw7AZ91uTg//mpmRbZ08rdhN3PdrVNEcUBWA6LZN80EtPTmZwoC1pXr9ryWxn+IQeIylTeUoB+KeR+gR33ErDk5Jw3PIf3WgLIlDxlYBbrJvCNfAhNUICy5xKxDKafVK9BPR/bF7tnsQCM0wzafBuWEOJJhCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659981; c=relaxed/simple;
	bh=3YABuRu2OsmagC5nqNyl0zdpX3iItB1C5KdlF6T1l4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4p5FGGBaXfK95xta8KsRN9XBpgQ/XUabeqvLLRxeGgDeYrwmJzV+AfL2gu3gK1DwSB8+nVBN9hWm8bn/ppHsLEoZ2vAA3K8OAzfNwrIBg6ccqRvDwQXloTxqudcq4HTxzn3q71Th1bZtoE+rgPONAxB/idChSOWZqxVriQ9+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDJUmIp1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDJUmIp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714F71F000E9;
	Tue, 21 Jul 2026 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659979;
	bh=Choa8qvicH9sJIkajNvGJBCde0MDVp3Tz1JeLF7x0LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDJUmIp1TRSqcWGq3XEq2eueMGHL231NiybcszLEzJpJQAqfCDAVVwksiFUHV82Vd
	 IkfF+e7GM0M3EmbDBkMgO7H0+W/e8mkZdtUqcaXr7tEqBrodZORsTdJRIK+pEKBgwS
	 SNuX2V9bv8/anKF03QMJprfXaZqDPqh1hyzVSmYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0806/2077] RDMA/bnxt_re: Avoid displaying the kernel pointer
Date: Tue, 21 Jul 2026 17:07:59 +0200
Message-ID: <20260721152611.804529501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 7d70c704a06f620d5d421ab76bac5e225bfb4308 ]

While dumping the info on MR using the rdma tool, we
dump the mr_hwq which is a kernel pointer. There is
no need to expose this value for end user. So avoid
it.

Fixes: 7363eb76b7f3 ("RDMA/bnxt_re: Support driver specific data collection using rdma tool")
Link: https://patch.msgid.link/r/20260615224751.232802-9-selvin.xavier@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index a892f117291796..d25fdc458120e8 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1093,8 +1093,6 @@ static int bnxt_re_fill_res_mr_entry(struct sk_buff *msg, struct ib_mr *ib_mr)
 		goto err;
 	if (rdma_nl_put_driver_u32(msg, "element_size", mr_hwq->element_size))
 		goto err;
-	if (rdma_nl_put_driver_u64_hex(msg, "hwq", (unsigned long)mr_hwq))
-		goto err;
 	if (rdma_nl_put_driver_u64_hex(msg, "va", mr->qplib_mr.va))
 		goto err;
 
-- 
2.53.0



