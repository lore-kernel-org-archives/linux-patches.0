Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97697415F18;
	Tue, 21 Jul 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656911; cv=none; b=hzkG3eLwQZbSnJPCi1NRIB9qYQsoo8Xgc0S3E7Pm5zItbbn4N4Yvzk3RlGhHhia/DNbMUzlWTJgrCaMdyTAoJp4oVx6GnnOJJyT8kU2eQEUV5V35Vfg+wixyRvYFgyR1+EXSD50HI8K9PHFKDs1nSbWJ+mz8Zb0lOqHkxnrWr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656911; c=relaxed/simple;
	bh=yo8NB8qAfF1BtEuIpiPTBfKzb9wkIKHVsIaxaXG72WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS7YsrdqliRwJMPI+Zpbn+2rr93vTD4sSjYy/Ydj0MbXwyq8BVK+6lwS4G8+nL3chwl5q0/lFKaQfIQmwq2ElfRBGfTfI7kHmURRMxRFGsPCrS81l+PJhI8WE4AIuCp+X6wgi/aGbC0S6eTdSpS9S0gJRW5KodjtxSOlVNe0L8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idaIPkwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idaIPkwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73021F000E9;
	Tue, 21 Jul 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656910;
	bh=DVQqJsGo6qZWuXL40Y64FT+YUgYBCGp3xX4kMvN6jCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idaIPkwJgyx93nKfKN9rur5eR9f145r+b5Q9htLlb0BftNx+fcFXtO615WCLPGBQH
	 n35GIKs33+Sa4s5wDlVt2kQt16gZlopb0MVtOVUMB+gm/TfzQMpHf1H1TL10W71sFP
	 CaZeJ9aSze8FtPDNjAKd4zkbrMnx1tllwNCgeSmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0558/1611] RDMA/bnxt_re: Avoid displaying the kernel pointer
Date: Tue, 21 Jul 2026 17:11:14 +0200
Message-ID: <20260721152527.928586637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index b13810572c2e89..4ca2eee6fbc22d 100644
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



