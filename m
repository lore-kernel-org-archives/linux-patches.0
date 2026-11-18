Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046570;
	b=kDTPoQxVwvjxllrBYRpt1hKkCTQPz8Rx5n/wrbWi8mt9EhXDAiEj6fqwl6z5YlM+M17k
	 RWXTYMchn02oBSufvwSc24w2KBdTjO0XH+o2rwFaWI2ReSFK+IDuV9c1h421IJSdmvNOO
	 p9Smpwn/QFPpz7Hkbk6qqTfkiwksvBcRv72BYcY+IbzoD0+mEDhskQpWhRI37Fut9Z7D1
	 +Xeh4mjzFUF5H/FtSZhgvP9VOilTcFryGHOxba7rqMTTQmnJyvfz7jxDADWCR2Y33tdUK
	 nEWQ2SSEhxeN9bo90C5iTqB7k+8OPCFz6Yt4mLjT/NfiqatWEYawVXbVpoB2YEtWDCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xy9pgr5chcpHJZGhRZMJqiW1FfKPpZABdQBMSNva1M4=;
	b=NYiruY0Wl9Cwp2yLUHFa4I+EaXObsGp+xIOwmQTmeetPYy5f2vCIbO+L7AjniAG+W+fx
	 1bMJF9d2fMjYNK1bGC3mFaOmrXMXY3K6pwyaS5o5Oi6JbQZqpy0zAV727t9ztOw+owcY6
	 2q1p1NfdGu/EjJluYwoqSU8vAaTfpIbfRKqUEniUV0X2fRhI8xjOPh+FaE6NLW80Re/j7
	 j9R72XRXzN8KXrf8/v22RnbbmCjxE+T/JtsYWov+zvg2WWZLwq2Td7LX7W+6qOfQYj5Fx
	 hkWwkQesTQBkrs6gy4ld86Fl4M4iSL9oDK3HdLNRXSkK/DcBsXUmsgxc7Jj1tpfC7Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YACdCJBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E71606A333;
	Thu, 19 Nov 2026 00:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YACdCJBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2FD1F000C4;
	Thu, 19 Nov 2026 00:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046569;
	bh=xy9pgr5chcpHJZGhRZMJqiW1FfKPpZABdQBMSNva1M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YACdCJBjRse/qm+mleVj1MDuTaz61oGvNMYpD+YMFNnBTDRp3qet5o9APiacuuvvD
	 3+8PM/ss+yETYG3OCk7tRmzffSKsk8j/3bTTr+V/XkcJTHtFYuO0OiNu81ogC1UpSR
	 XFko6WBeeqKAZ+GPuCs9vuLp+aP1vH34U4U9jlcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1327/2857] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150249.218657465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 26ae50a0901a44f7d50053f87dc38abd9f9a269c ]

kdamond_split_regions() uses a static variable last_nr_regions, to infer
if the region boundaries are too stable.  If it looks too stable, it
does a more aggressive region split because it might be a fake stability
coming from non-aggressive split.  Because the variable is static, the
inference can be racy and wrong when multiple kdamonds are running in
parallel.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort monitoring accuracy can be degraded when multiple kdamonds
are used in parallel and the workload has certain access patterns. Still
it is a bug that is better to fix.

Move the variable into the damon_ctx struct to fix the problem.

Link: https://lore.kernel.org/20261025164808.152048-3-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 5 ++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0387d86b56697..0b63617106416 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -465,6 +465,12 @@ struct damon_ctx {
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
+/* private: */
+	/*
+	 * number of regions after last merge.  Read kdamond_split_regions()
+	 * for more details.
+	 */
+	unsigned long last_nr_regions;
 };
 
 static inline struct damon_region *damon_next_region(struct damon_region *r)
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 01f93146b92fe..afc0f06ea88d5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1101,7 +1101,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -1111,14 +1110,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		return;
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < ctx->attrs.max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(t, nr_subregions);
 
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.53.0



