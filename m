Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F693359A6B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302418; cv=none; b=ipEFKwR+ORt4Wee7OyoJ0jvlfEJh3bKbEHapcIiA/gDtIczHzCXmQWCyZmuvXMns9Y5sOV0aVLFWmXcBHFEQ5qZFZAczBWxRs8tWdobT5/lg5tF/dU5X29oNal7x3ATuIm7k1lECSXWlDDsAe1Sjotr7L4wPO/K9hJ579VZtoDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302418; c=relaxed/simple;
	bh=r28FSqOYKeJF7IzUqWVW9EryuAaDuYl7shjN+DkgpH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8EAXZPXM/KJblKhSod5PSJHhj12he4hrjMn/rNjYr3Tw5jBnNcyEdJkpGzt5MKLBq/D5313+Bj0FYGe8jf4dGyAVJAxOufboHSyTWKaVyfd35GwIwXHgtQmsExEHysmREKXyk/PVfIo6/Lq8eKKYdSK+NhiDjYpgxlrK/3Gc7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isu2OmGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isu2OmGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A587C116D0;
	Sat, 28 Feb 2026 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302417;
	bh=r28FSqOYKeJF7IzUqWVW9EryuAaDuYl7shjN+DkgpH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isu2OmGZ0o2dwjrm/StNtXiMfpJeiDqg3FUR5j9kLcdEW7nllgK19rm8WXPAgcK5P
	 xGbe8kjXB+y3qhrqs4hrGwcrtvYAjokfbvQdJIPQsUtDp11JLoqU79nJXl9iAeIn3S
	 Ea5LW/gCgDcehjsjC2DB1tbUaeyJp+TlJ7fuV+DDBa99XsdYCJ9rfMwhfOHxDM84D2
	 VJ1GYoAeszvKZHv3Up8Rd2MUk5MfReIUNKRJb+RR+YnT8wAYGcyiNn4eb7Tf/OzNb4
	 aImXEIFzNToiHnI+1C84HElOUPjfcYxiv5nWxQYqhZN2HZ9Ln1w05kaaz5/unNg+Xi
	 kxazPdRJuZLRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/232] RDMA/core: Fix a couple of obvious typos in comments
Date: Sat, 28 Feb 2026 13:10:05 -0500
Message-ID: <20260228181127.1592657-152-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0aa44595d61ca9e61239f321fec799518884feb3 ]

Fix typos.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/169643338101.8035.6826446669479247727.stgit@manet.1015granger.net
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rw.c | 2 +-
 include/rdma/ib_verbs.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 8367974b7998b..6354ddf2a274c 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -666,7 +666,7 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 	factor = 1;
 
 	/*
-	 * If the devices needs MRs to perform RDMA READ or WRITE operations,
+	 * If the device needs MRs to perform RDMA READ or WRITE operations,
 	 * we'll need two additional MRs for the registrations and the
 	 * invalidation.
 	 */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 41eb2a7c9695d..4d00fce739672 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1088,7 +1088,7 @@ struct ib_qp_cap {
 
 	/*
 	 * Maximum number of rdma_rw_ctx structures in flight at a time.
-	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * ib_create_qp() will calculate the right amount of needed WRs
 	 * and MRs based on this.
 	 */
 	u32	max_rdma_ctxs;
-- 
2.51.0

