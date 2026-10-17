Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F5C356A12;
	Sat, 17 Oct 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259373; cv=none; b=u8CqmnjZMK9BQENLt4nX/uLWDffro/GyYuewkKCpKO6MgSVzEizlFwUnXhQsEgesOehx54GV8/2v3gdX15SOij2F4OM+CZhvTgyYIAgfy6yucXGO33aAt0bhpgc8lg9vo6QcWAVKmZ1GN7J+odOvXzfbfQxAF2W8TP+mHAa4L4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259373; c=relaxed/simple;
	bh=ClJ0Tzs8sbYzcxEkYzqBdtI5hx3CZrsIM8kpB63LAvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEPZB368d6Gcg6b24XlqQDumiCxgrlZwVb0rxCssGpiXxiauUjJJgPaej6O8SKsDk8x2heX/3iyTGrTBHFd0WeFbmbb+Bq+b4vA6pJ4SSRR8Xuv6ZECJzhbHEj78C6K9BBczsWFa1PTyzgIvO9Jr4jSxd8vWvv2WkVZvbwCMo0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOCkWHJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOCkWHJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2551F000C4;
	Sat, 17 Oct 2026 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259372;
	bh=UvxiXhLWFsA4CncKWv4NbgmnqO7QhxqE4cdjXTQQr/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOCkWHJtmp51Vc5qD74RFIRpbD+QCysIx/zQlFw034P+q7xWBdhV2hKeO3DZeP7aZ
	 4c6rC/SAlJdiMBQCSgQO+WaBYvHh9jaofKgEi8wiANEqiX0aKvIku/9Xz4JKRdmPn4
	 oUR4D/za4r0GjtkgCErX8u96m4wpB8/Ub8pAt+I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anantha Prabhu <anantha.prabhu@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1151/1674] RDMA/bnxt_re: Initialize dpi variable to zero
Date: Sat, 17 Oct 2026 17:57:03 +0200
Message-ID: <20261017160500.691278387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index babcfb153394c..a6a074ec2908d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4317,8 +4317,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
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



