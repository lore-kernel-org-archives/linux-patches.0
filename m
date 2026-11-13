Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591282;
	b=ufHZazQQj4tBeiOnD0bUaIogfGxj6FJxkrqetldELRZum6h8EIZbW6PIeTL0eaH0topw
	 YAL+4sSH+5m4NyNkzJGdxeaPFuIC74iR1ICV7NA9vjg/kDMTD8dTh7yew9c59p2SsMkqe
	 d1EpHetobRXckYgUzUZbHXmzwugLK0RHE5aDf/qJC7arUmuW9uIk275HNv/tCQX3UKNk4
	 wjwN1UUQ5Wa85XhcqzX49gC0Pghyl+RLgA+62otwB6w9z3PbbYB+O3EFA46rWu4c5xiaA
	 YBud68/G8LNu+yuysM6wIdchzeCNxcP/+sDbYztnojEZmkTxjCK0G2QcNB8XTuSf12A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jb5bhtJUKtrqjjmGflPyIpGpiYC4oxjFhNKMMgdNI38=;
	b=kaQ435w/mosDK4r4V/btsMvAdndGX3jXxTB/DK40DFkgvvJJ8FcT7YtFp/817qBpBqSx
	 k6MB4GdoYGb2L+AS0/PwVYaXi6voIF4yzjwxNevMe/j2aSZfEalmNgOyQuhumZgN+GV0c
	 iLNKRnQppTC4bH5zx9O06F/gQS9UJN9nC3Vtv4S249s0KcQXSLWsRif0TgXxihNKM6GZw
	 IoMHd9MTJblTJle+e2T5PQuFlyI6Vc3huo3fSJoaZT6g2j/L3ghH3SLa5QXQuXpuB3z1a
	 8NVUO+z0BbbAX8Bnu26bodUocgsJWzPrdqdiQjrqOw1NqjU6umrKnXqBSOtwyOPEIvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K17p0rlw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDC96077D4B;
	Fri, 13 Nov 2026 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K17p0rlw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C381F000C4;
	Fri, 13 Nov 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591282;
	bh=jb5bhtJUKtrqjjmGflPyIpGpiYC4oxjFhNKMMgdNI38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K17p0rlwgeDFir8jqVpwBrO0c3muq5nsXz4XE16F9eIHPoYz5vqbty2w2AJYl+RUK
	 /LBsHXFdI5JPjbbXLv0tA3UrLMUNOPKwDyjOaOyCXp3e3pOHbpN8R5QsPLffLht1WZ
	 FNK/NzNumMBmWbKnFzxs56sy8E59xZ+AsfzKx2go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/670] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Fri, 13 Nov 2026 10:49:26 -0500
Message-ID: <20261113153825.378896150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4688a10eca89b..b05c626f6479a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -641,6 +641,12 @@ struct damon_ctx {
 
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
index 4952ca7ac00dc..e41d201d4b8fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1971,7 +1971,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -1981,14 +1980,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
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



