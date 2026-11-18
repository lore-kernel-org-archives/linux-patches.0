Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054511;
	b=O2aSZlR7kLxUMtRmcWtA5cJmbjLGtzZK3M/Uls1LVSEx5gr3mVxwO3la2wXRVpd4KyZc
	 p7bFHpR+N5XWEoE69ad+TCjc/kngIJoda5jGTX+DqlaP5n+yh++kweuLcNVnfhP7Adrt3
	 NECP+Qq7V3CPzKjOqyCa+2bgrF2NS0XMvgEjlgpMqQNKWcY883qaMvqUUH9guIp1XeA9p
	 k+ULQs7dHoHYMcDBlvJFxBxecDT1wEQKdHEu951TZfjTy79JZRsCKxL5bWnQ6SmzxV4Xy
	 1lE38rk8fpkFk5jg1rEbrU3biRxuK7UVvzGhV4Lw9t9iCxcv/uxMxHtkaHtgc8Fg35Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ZN677rXBYG5M1JuYEh3Q5ATDQ3P7rO71TCYYjDSk4Q=;
	b=C4dCaqu3citfPjI/hheXuqJJqixawL+PXbO3ZJCVkJ11dslUVOdi4zycTkC5Gqx5J3NH
	 rdpxEJDPf0tJL9JfptyLG91AQrPDIRyTTIjkOPdN/Woa3Sr1uZkDNzeyi+RtiAXQA8jtT
	 7TqjbfedYUyqBv/D0jBMWYiuHHjd3kshsFZLXJyb26O+bFsf9DqdWcxQSKmZSdTzpz+2G
	 oRV9HCCWzJk2ZpQFTK7BS5+hIq35HbFAv8WEvPaWEIQBBo9/JnRw5XqsZewMLR5dBK/3v
	 iZrts/7wwhyDQa+CxwoZjKdR6NnCP89E9lQt1Q31I6DnVP+fb4tOpyw109yDu4lsqLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr3sT82P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DDB606A32F;
	Thu, 19 Nov 2026 02:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr3sT82P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA4F1F000C4;
	Thu, 19 Nov 2026 02:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054511;
	bh=1ZN677rXBYG5M1JuYEh3Q5ATDQ3P7rO71TCYYjDSk4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sr3sT82PvgdAQHsPdVAMfbLJetuu2f45OibxjB1sNoFH13bWLO4/96/+Mgp7AAgaw
	 AsJil4jD8fTbyAzuXNsIjR5GhUSNPYR6GVwFAM4t416LKNw3mX5fUFiBQ4tJh2+8U9
	 Zg0PTIf4GGce7KL5edTuhiV8iz94Ytqe5tkj1EXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1301/2214] mm: document mmu_notifier_invalidate_range_start_nonblock()
Date: Wed, 18 Nov 2026 15:49:37 +0100
Message-ID: <20261118150103.566164138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 7ced098fcfe596feab3cea4f40128b0119c7bf1a ]

Document what mmu_notifier_invalidate_range_start_nonblock() is for.  Also
add a __must_check annotation to signal that callers must bail out if a
notifier vetoes the operation.

Link: https://lkml.kernel.org/r/20230918201832.265108-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6d65925777ec ("mm/mmu_notifier: finish non-blocking interval invalidation on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmu_notifier.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 45fc2c81e370c..786f0f8707981 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -461,7 +461,14 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 }
 
-static inline int
+/*
+ * This version of mmu_notifier_invalidate_range_start() avoids blocking, but it
+ * can return an error if a notifier can't proceed without blocking, in which
+ * case you're not allowed to modify PTEs in the specified range.
+ *
+ * This is mainly intended for OOM handling.
+ */
+static inline int __must_check
 mmu_notifier_invalidate_range_start_nonblock(struct mmu_notifier_range *range)
 {
 	int ret = 0;
-- 
2.53.0



