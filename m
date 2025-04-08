Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6830519AD5C;
	Tue,  8 Apr 2025 11:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112492; cv=none; b=aMRhn0OA4Uh/v9seiqhhhuCmI466rOUB7/DMfYxfzVH9FkA97Md3i9kPZARZzvjCOA0Obf+YwULjyQLxkVxP/9VWYxHopiATtg5q2yOLxAS6fgoUuVA4xF+LzPZF00oRkwBx6w+5sXKvn4dEqI90rCiSU1uqh4F7sadLQIJE90g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112492; c=relaxed/simple;
	bh=LwSfFAXYkJXt4YHa03VSQbPAKC3NE5YrFayV+u9mwaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbZuvKbeZ36BghauQSn7aDX35/vNMXr135rp0FEAu9bOuj+T9Zezqh227huJhYMFK5xaeVoTBK2KbMlpu8Q7sEGOrtCg0bJnpGsuoiEDVDrjn/0g9NxT4V5hoLMZtvWOvm/valqnKEmx9PqIxTAboLkqeB2hR4ObGOKKFn1dQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJ0AS+Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJ0AS+Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3746C4CEE5;
	Tue,  8 Apr 2025 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112492;
	bh=LwSfFAXYkJXt4YHa03VSQbPAKC3NE5YrFayV+u9mwaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJ0AS+Swppt8fiKrBKR2inJYBbbWKndf5y7f1dw625G1VL9MHLTTQfOSL9fKy8gLc
	 l1seHXqUb2nkXNeFvzUQWZLRDZ5TRu00yBPi4IlLACwmH5PdARr1x31j3jlYs4C3Yb
	 G7Ygm+DPnpmrip5b1w1MO4A+uev6PtmCi3rMYdoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/279] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue,  8 Apr 2025 12:47:52 +0200
Message-ID: <20250408104828.751162135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6b5e41a8b51fce520bb09bd651a29ef495e990de ]

There is no difference between the sge of READ and non-READ
operations in hns RoCE. Set max_sge_rd to the same value as
max_send_sge.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index e2d2f8f2bdbcf..83a6b8fbe10f0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -185,7 +185,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 				  IB_DEVICE_RC_RNR_NAK_GEN;
 	props->max_send_sge = hr_dev->caps.max_sq_sg;
 	props->max_recv_sge = hr_dev->caps.max_rq_sg;
-	props->max_sge_rd = 1;
+	props->max_sge_rd = hr_dev->caps.max_sq_sg;
 	props->max_cq = hr_dev->caps.num_cqs;
 	props->max_cqe = hr_dev->caps.max_cqes;
 	props->max_mr = hr_dev->caps.num_mtpts;
-- 
2.39.5



