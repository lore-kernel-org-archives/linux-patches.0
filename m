Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053501;
	b=JwZxBLvUPlnCXMsNiPX4QU6KXH4eGhQstuutCjxc1QNtEMgf1SGLn3ucqPeAB2iJ9ya2
	 vA4zjx3c5RiHuPDOm5PHrsRLE6xOGZpMDVfvZRPQfsrUjUfrj0LEV5G1CgMFrb7c9Y8JP
	 UrFr462ehTWgKdKlGRB/AxeoQ2uIxfusIwl14FS5IUqX/IP9k0iJfVnXLHl8bpE5tc0fN
	 z/f9ljbq1JsR0rXN7zj4mT/jqjDhEaGxPLjN6sd4aOV4vxXL/WggZ4e4oydLc9/Y0WwB5
	 GzWnjWzeTEINFudqVtkl0ldlKTSTbJPsLWSQhccS5YzX91jytoLDqC9sMtgxqj4og4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s78EJJBB7wX8rzpEAoWFSXjgOpJApT3VX5bjg7UZZsQ=;
	b=rifArlQx8CVAxIr5eBOY1ok8DSrJq7yFaGBeON0/Sh59jOYe/3j/jEQceGdOOTZPC0R/
	 +splICJMGRpVPXuDK6TT107VJakL5FJgZ0wUieIfpRNxXXZw2XlG+X683izvLql1JRARI
	 jEYdDkORmVCQj51/waVDTJVtNnWlD8ZzCsXWBw5zPnfzGTSQZWl07bp9N13fCyJ0dstd7
	 LMfUqWvsVlzVkKHByQC+roL//IvpvfJTnifCfFvE7/HarIciIVaQc9KVRkNNLV0GgvTID
	 EO+uHfakxKLneGkcYeNr46UUZBGMmoZzAoot4eSkDsiiiMimF3Usc115jmrwTJFAzLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z16JvQlB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5F606A32A;
	Thu, 19 Nov 2026 01:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z16JvQlB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C506B1F000C4;
	Thu, 19 Nov 2026 01:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053501;
	bh=s78EJJBB7wX8rzpEAoWFSXjgOpJApT3VX5bjg7UZZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z16JvQlBxi/FpQRv4NCcXg6X+eeE8YxbvuuZbrru+UH0oMb69q/Ts+1cBLLQ1+Yg7
	 89+wimadPlgXLEbGKroW7pryngj89xjqCG8V1iXSs0BdAz6yPfnrJ3FAdu4aoyxfCl
	 HmjFOOKifcFj7CqF5vHsfHJ6+wRsGsn0V8byKdgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0943/2214] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150050.075132452@linuxfoundation.org>
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
index d68b67b8d458d..bc0cdd67e2473 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -203,6 +203,12 @@ struct damon_ctx {
 	unsigned long min_nr_regions;
 	unsigned long max_nr_regions;
 	struct list_head adaptive_targets;
+/* private: */
+	/*
+	 * number of regions after last merge.  Read kdamond_split_regions()
+	 * for more details.
+	 */
+	unsigned long last_nr_regions;
 };
 
 #define damon_next_region(r) \
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3a50ced2efc0f..1ce0438328b94 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -603,7 +603,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -613,14 +612,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		return;
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < ctx->max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(ctx, t, nr_subregions);
 
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.53.0



