Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9139B97B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302601; cv=none; b=EmZSQDVvccvtox0bxrSN5qIqLDJiNvRH0k8ygKB8FMIoyehMgIJJHtU+1Hzwjxxw6gFpsnJYzYtGG5gnVuVwg+2g7OHtFACKo3648JT3Ve9oJTnpwYCfraUGEq4Zfwoyu/hq0avwgk+kFOaxDFKOvsj1mDxV3MSgcy6QYAqjVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302601; c=relaxed/simple;
	bh=Atj9hXnlnjeNL44LUsataArGEXc5G2Gm5FHAymwb7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DinLF2SNnWSS84D1IcYr+6TfKhngkZYHJ1Ng39eUl4udm1XYIzm0GS9v8QiPVHzHh7vM3vxNm5P9K0XJYjgLRXFlEWpQKW5wy73Vzro496lTCQR1oqvrwWy4zLfyPPE1N94vt0g9umr3sROn1OIsIAijHuSRbQRPrDfYelOnsnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MX/FY+Fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX/FY+Fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8730C19424;
	Sat, 28 Feb 2026 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302601;
	bh=Atj9hXnlnjeNL44LUsataArGEXc5G2Gm5FHAymwb7pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX/FY+FqZ4RsVT+EOMTxK7KyQXZqUXrJyNFhiMeDNssGXUDL7sUFArnMCTJW36a1t
	 5gUgMs5bIT5u+zaOyBJEP7aQFUOaBNh2k0ZyK6zmyfp7goo6fPDCzALu9ACq3Jc5Va
	 hgL9QNOdXd4ViTI2qZ3QN+5EGaXJlC5rWcT45yll5mtbzCF/qPJ8Id57z219CjlfOf
	 3G22a7Fs9HGedT06jLZvHL93ZtsxWUed6+cF4GcxkbS7ZpOKm/MgzweC49iARixMIg
	 GgQ7EmLqd6iR+0fuy3OwXjHB2mKWbrPhFQaZ5LDU4ey4UtObT7doeKFnsBuMiXasCc
	 SdViNNiNDnYrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/164] RDMA/core: Fix a couple of obvious typos in comments
Date: Sat, 28 Feb 2026 13:14:13 -0500
Message-ID: <20260228181505.1600663-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 5221cce656759..e35ad03ec7e92 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -676,7 +676,7 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 	factor = 1;
 
 	/*
-	 * If the devices needs MRs to perform RDMA READ or WRITE operations,
+	 * If the device needs MRs to perform RDMA READ or WRITE operations,
 	 * we'll need two additional MRs for the registrations and the
 	 * invalidation.
 	 */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f4257c2e96b6d..eada75848eec3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1073,7 +1073,7 @@ struct ib_qp_cap {
 
 	/*
 	 * Maximum number of rdma_rw_ctx structures in flight at a time.
-	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * ib_create_qp() will calculate the right amount of needed WRs
 	 * and MRs based on this.
 	 */
 	u32	max_rdma_ctxs;
-- 
2.51.0

