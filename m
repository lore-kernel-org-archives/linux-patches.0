Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F97231829;
	Tue, 21 Jul 2026 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659973; cv=none; b=C5P03yY+U/BoUSIcN7y5xhmGp14udgfGSDh4xyPIP3uKEBIWFby176wGHO77gpTD8pb+0wZPCOmEMmYElmlI8B+u+EKggcfRlzQUROzV/KI6u30PVn8g7oJX+GkrKHcYxRZHhTG9ASzuiWthX7baKS023aNK1eM+/DoFiaQowwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659973; c=relaxed/simple;
	bh=DO4R7rclvz/VTXsvopO+lIRGO6UZBM1mAclpZ+aUcw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DogpAXza9FB4xwUdFG5SMJtZexySStgW3CHwC2gbhP/vrbJvYvvoImzxu5zSJ7E3OdjdSe86FFUyGd3waXjq0TboM0zeaLMob4oxZiBjBsbFxAHT7PO3ZZpsAXf5o0j7AiSCT5nphDdQwQOa9Tj8ZJ6HFv3Or8YAH/r475S9Axg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEq5nKRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEq5nKRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC5C1F000E9;
	Tue, 21 Jul 2026 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659972;
	bh=k7UL1RgrDfsoNTPEapWEUX3r4WzAEz1mhDS/G8EArG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEq5nKRFBrcovw+a7G/6by0N59RlX+6hT27aMviLwQs5hzucVraROMxh9a27zlEFC
	 BA3sxxA5RvK1ZLHr/4+Q8HX/aqwtGs9vu5jQ1HjrQb4f97upzZ68X0YvK7Q1MTjFfR
	 NF4HE+6mVn07CRS8eBNjp0LyeY4+5PLaCwCUMIAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anantha Prabhu <anantha.prabhu@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0803/2077] RDMA/bnxt_re: Initialize dpi variable to zero
Date: Tue, 21 Jul 2026 17:07:56 +0200
Message-ID: <20260721152611.732518397@linuxfoundation.org>
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
 drivers/infiniband/hw/bnxt_re/uapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 3eaee7101615bf..61ddfa94c1aa1a 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -76,8 +76,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 	struct ib_ucontext *ib_uctx;
 	struct bnxt_re_dev *rdev;
 	u64 mmap_offset;
+	u32 dpi = 0;
 	u32 length;
-	u32 dpi;
 	u64 addr;
 	int err;
 
-- 
2.53.0



