Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590526;
	b=KFLhQD17waXh5heSf4gIyW8y70EbmCX/k5ogjCguGsi0sDU0rCCTcpDmGWUhgDyPdOKY
	 t8MhdzUwfhonz6FgvB87eGBuiJboqltpEoEQXZdHHaSUN30XlQz0Rdn3lreTJltfdgg0i
	 LgHXP5fQOWC6mNr20NieScEwmkyA73eG+WkHRgDcnxO4dult036au4NCFUeMZFoVXRdX5
	 wDcNTSWmhMJvS+EmHkvaSJgPqlhCdOInd6esP1bZRG37tVD73bNj5NdsBLl9uNqyU0Rws
	 viaZwAsYHTOQtHK1zzSyTRtA5T6ghoAljc6fB2ozrvs0ILkQmivF/u4cb4mCDd47u9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33nSFuSKMTKs4kM339oOVkWTZy0i48/rR5LL5ZiUUBc=;
	b=AtfL8rrEgdd8zp+x70d/kqDqrJ9IY1fEFNdeYLo7wxaplH0KxeawaT2WtzVkkikV0wt8
	 FcYLqw+UOb/EgzAWikxlvErDYjfqzuMD8yO5WNDvHqXDc7PD4tgAc55Uq24pC5lOh0mbV
	 02UPhqkm/G1GR502X5caIorZyqOAEoVJwTeNeNKlWtLdpMF3jj87jFnEtxqQ72L/Bd1Cg
	 GlHzZhfbohgSYn6WWISyV++4EREQ1LOc96qAxtBbgolB6yF+J0weZPTiJyRU47eowu74m
	 tQQAo0xKGOAtVOpIzrKMp6YbMTMG3X8/5ASCvmgeZ9D2SvCCtTXXWTyYDYKWqK19CZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNDkqc3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558B0606B362;
	Fri, 13 Nov 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNDkqc3z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2351F000C4;
	Fri, 13 Nov 2026 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590526;
	bh=33nSFuSKMTKs4kM339oOVkWTZy0i48/rR5LL5ZiUUBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNDkqc3z4brHhgwuuWjSmueZHnVE5BLn2yC4dycnn7DYC5TWR8ipqaXuuge8J6t1/
	 tZ5uiWkeyAdCXql0utdn5IChwdAKyFJhP8FnKMSa0J2pMZ/qjmvEy0bHaduYlhJHwq
	 p4Y9wxFxTQPeYvH3zpknehaugcxupjG8ZRjGcXOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 470/686] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Fri, 13 Nov 2026 10:50:03 -0500
Message-ID: <20261113153836.829548482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 656a314ad2159..125fbe1c73a9d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -804,6 +804,12 @@ struct damon_ctx {
 
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
index 54a29d21d0dd1..ec44433200c63 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2568,7 +2568,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -2578,14 +2577,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		return;
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < ctx->attrs.max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(t, nr_subregions, ctx->min_sz_region);
 
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.53.0



