Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037953;
	b=gOsaIkWRQLBX1FP711Wr3pE4Iol73cgNafKpzL/8PxITggh0wJs+kKKXTlCpm6A7zc7y
	 eHBpnbP4A4ZSFfz8naHZ2gC4/i5q/fJe8L8k6lLXvJTOul3LOYLxl+38HeL7rvAcEFqXK
	 W04v6p8pCu9Fv167H/CDm9DdHeFXIA7YPL+eYeE2zA87Qom0vBBrf5+VbJTmSgZGVyXcQ
	 YoBrzVMtbMOJO19VRn1vbR5ZtHpbIhY4YRwUgJuHxuvhYLTqgaa2ZdQag1QNxqUCJNpJE
	 WMnyaQgLerVHo9Z0TpRO8tnenc6EBXjhV7Cfj55SyZIgXgZeInlSj4pQQQiUXtVGKpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x2jNtTP5lGRFJpUvcWjPK0TF7l9WyP1nvKUXYoIuV74=;
	b=gHpxpRy9nUxrivYYfLSU5JbfftmYWQlH6euzCwIv2SK+sffBqjWN6ke8b/Rfxt15Yk8r
	 4Z7kAZhvKphOhsrGHdKFe7EZGduZRh9wqcL4WMDGiaJAdYgK9zL0Ldky5m8fTT+oqm0Sa
	 ekp28zyJwsiY+Wl4y4msb8v7H0CQY/BfwmCc7/493y3LHct7O5YjdS5GmB87Tv0Uhhddj
	 veC5voIGeAU6JzDJPOqQQiBNzHReStAFuhmUxL/ZZE1JGiWPXScW3KQVqh9FamNql1cIj
	 oWwqoWUbV+g2PxnQiVt9bj6My2i19+WMf/0sDFGagr/BWOtdgsbZ+VM9UH0lkXI+2NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJGjNoUF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A15B606A31C;
	Wed, 18 Nov 2026 21:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJGjNoUF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354031F000C4;
	Wed, 18 Nov 2026 21:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037952;
	bh=x2jNtTP5lGRFJpUvcWjPK0TF7l9WyP1nvKUXYoIuV74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJGjNoUFXkGSaZg0nN/QjzOLX+Invm4K7DYdDtUztuH1HutR3EKaJyxbZRQgsjj8C
	 j1/fxFxgNoS4Bod7P7U9AG6MqSelVhZWjiR+pp5u7DurLqxtl5vKwiBw4mSfgOiQV7
	 zGogn6e84G9cyjsd5I0EwG1mif5qw6akPgvFwUvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1576/3318] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Wed, 18 Nov 2026 15:36:38 +0100
Message-ID: <20261118150408.396144098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16d28a190dae0..8186f7c0f597f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -557,6 +557,12 @@ struct damon_ctx {
 
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
index 8fcb8356101b3..3176b97fe3a23 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1360,7 +1360,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -1370,14 +1369,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
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



