Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92138F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302191; cv=none; b=Pgy66pTWVuXuIiMUPDEb5FilgFnau8baGdA9mrRA2P8cwYwjODgPtG8VXplwWgAwVJ6Tn3Lf4tKasIK4gww/H63sUho0bp6mdCcSilbr3pNwBhEaH6x2RlQozjG0GAfHLjuYAs+jd+gUIGk743Z3OPA47uR3wzH+Y2u5WEiW+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302191; c=relaxed/simple;
	bh=zBs3leEelXD/r4qkrRWYiuND5E/q/RcGEDS8szlTBzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq22xyqsD3yg3eDjBwd1mP55QHXVWh6WLpxp496Vg8o0ujrAy9nC8rfDoXd5sWyh/WJUOixgGAe3cObFoc0fKyb2eAYyQIbN1JM+63XFXyiTrkHfDBNnlWnqhPRtpkZKru8iRQ4e8Sr9GypVMoNEZsDuWjFH/Yi2WmmuUiaEn5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJLrVQ8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJLrVQ8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319F5C116D0;
	Sat, 28 Feb 2026 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302190;
	bh=zBs3leEelXD/r4qkrRWYiuND5E/q/RcGEDS8szlTBzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJLrVQ8W9NCyI2EHS89UnATHvxVIk0fgkynHZR8UTXkcSrJ3AUwhNjr8J+Xl8YgDu
	 jIoQW7cvVHhu5dOkIPntIRk6a1xqEqD3mCSBOGmWysFXYdmedkwxrGsThIZbquMCpq
	 1KmYaDXWgnI+gslf0ZN17oV6HT6ymUaeP/fpy/E87vKQsifDdLtuAVmofJopRpgUs+
	 8fsS0Pz6C+AWtV9lRAhSqWAVCvCIkwPgdi9Z53j4zvqOI7AvGEX510jIsvQojPe8iV
	 oxUUnvDkh0WsHCW9ydm1wivf3c/wiUQ0DAI36xUZaotr+hiBxTI9SkHCvIiUM0+M2P
	 l4itZb1D6x0NA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/283] RDMA/core: Fix a couple of obvious typos in comments
Date: Sat, 28 Feb 2026 13:05:34 -0500
Message-ID: <20260228180709.1583486-192-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index de1d88d41270c..038fa78835bed 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1096,7 +1096,7 @@ struct ib_qp_cap {
 
 	/*
 	 * Maximum number of rdma_rw_ctx structures in flight at a time.
-	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * ib_create_qp() will calculate the right amount of needed WRs
 	 * and MRs based on this.
 	 */
 	u32	max_rdma_ctxs;
-- 
2.51.0

