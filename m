Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490326A0C5;
	Tue,  8 Apr 2025 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109850; cv=none; b=tWbKdlG2V/bVb9y6l6IVYzuq4SYfXlsXS+PjBBobHFn/jXPOw7qXxqqPvpaFWWzpnzLy25eUamWiztmI3+fW21pMJiBLaGgxJGhV7xLxTDYCnn7UHy51JwV/U3zK4JSnMDN4uwI5Z53mqJpwz3V5s8K3kbKs0RQG4fUTExQM0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109850; c=relaxed/simple;
	bh=iH9Fn9iqfRaxCIzLG7FMWWVSS0jyMoukYUQfS+fziCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv+uBi7TeUMSPedvIdUishkCctAWnUuCWyjO7nEIaEdIzV0tNx9Khwfb+IlpJMSL762sMT5RGGozHjnkjjqRq7w+KvI+0Yi0ZumNrRpklKzPP5QV9t7rtzb9/uLrSJdJor0ZrsLVZhlzbgMlKhIQjDY2tQXGbNydckAYd+iDW4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYoGEcXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYoGEcXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D52C4CEE5;
	Tue,  8 Apr 2025 10:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109850;
	bh=iH9Fn9iqfRaxCIzLG7FMWWVSS0jyMoukYUQfS+fziCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYoGEcXVFR6ho/5hQ4Q96i7Euxf7c4+A8Rr4YeAtSaC2O926l0V9XijFS8DOSo5k/
	 JYNB3cpMmL7FMQJjaSg0wjjNWwy4JOinY1PFT6DfiD61n9O9KX1codutbHK6r8tx8i
	 Eb+F+1ZPG43MvrFsoq8mdFuQkyXscnBrYQH0S+MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/227] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue,  8 Apr 2025 12:47:33 +0200
Message-ID: <20250408104822.639563978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0f243ffa5b54..f520e43e4e146 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -199,7 +199,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
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



