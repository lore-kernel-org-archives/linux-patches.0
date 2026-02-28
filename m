Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E354D35AC12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302739; cv=none; b=ssvCUysxWPzI9kw5IIsTM2G45FB/yTI4LD6dkK/XjfZ9Vf5UgozrsoApMhQO0yuN8MSNwvj70W3RR2iTNQh+YmjhsK/qDl+iBCCFoE8BAAwEpAxcDgLkYTU4y9dMkvu0rmJHnwSOrNsXe4lWldE2fDZU+nmqe965S8Mb1eNK3YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302739; c=relaxed/simple;
	bh=LFHBBrb+8wW6iLfBAkiJXLDQkqarqnWTyhKZm7xTNRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAsOaAVV7lVw7nv/NfZGpRgyLvvefvK92G+h/bVOuvYzTvOfUy/6ZVL465jxB/izLF1TwCVl9R+RuoUpiR4v1UUv8lGZ4C/i9ALrgRHqw+DqhsbCM+qeeuxMeNZOJhBqgO8PQfrJPAgzlgZaiYdRpg1SqwWRmLEan3eeT5DY8Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUg3mwem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUg3mwem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9DCC116D0;
	Sat, 28 Feb 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302738;
	bh=LFHBBrb+8wW6iLfBAkiJXLDQkqarqnWTyhKZm7xTNRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUg3mwemx7Syort5r8J8tMsInXlG/pjXcbHMGNC4idaaRq/Hqq/p8EWjjB9yiMHNX
	 2161ibHSfB++bbhk2nhcneHuMIOst5e3PQqnbiDqxBEDTxe/DmRPYVnpEezf3zVtRk
	 TsWjJakQTmUKlGEE+V7Jx66CWrMIdk+OqijQAuoXDe95I0Jcqj34Qg/QZsvz8BhJaG
	 g6RWR4+TIXiqoUBLQxRhjDr03Ip8AF37C/pFbjmmltz/+8Ygg7YfW7Lx5cpvWYjx9q
	 Wwr5Kjcgm59oICYjAZBsYX6IK3oxfCIERxE5bX679jPkWxSYttylbiUM6WjOERetjL
	 9TFluYEGGYrHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/147] RDMA/core: Fix a couple of obvious typos in comments
Date: Sat, 28 Feb 2026 13:16:51 -0500
Message-ID: <20260228181736.1605592-103-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index a96030b784eb2..3cc5ed902976b 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -675,7 +675,7 @@ void rdma_rw_init_qp(struct ib_device *dev, struct ib_qp_init_attr *attr)
 	factor = 1;
 
 	/*
-	 * If the devices needs MRs to perform RDMA READ or WRITE operations,
+	 * If the device needs MRs to perform RDMA READ or WRITE operations,
 	 * we'll need two additional MRs for the registrations and the
 	 * invalidation.
 	 */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ac6ffa5618843..495bf66620a6f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1070,7 +1070,7 @@ struct ib_qp_cap {
 
 	/*
 	 * Maximum number of rdma_rw_ctx structures in flight at a time.
-	 * ib_create_qp() will calculate the right amount of neededed WRs
+	 * ib_create_qp() will calculate the right amount of needed WRs
 	 * and MRs based on this.
 	 */
 	u32	max_rdma_ctxs;
-- 
2.51.0

