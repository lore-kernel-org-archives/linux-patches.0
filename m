Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585642;
	b=FjrDAixLtO7mjSg750vJmsJ58ni9TT0Dir76h6voxqtbCAJoAzhxqO8778tur8mjwt94
	 WeRhLb7QUKsj9lwK57g6wFPgxuuYL5xQGLRIZ3R+d3apaHjNvqa20ErDZtgIC6JSUeHuJ
	 wycLTlfm31GTrOHduxHSlld0EDLK8YT6536UhD2nAblD6VkNG7nWXQ86tfzOB2N7gISUl
	 304GCWztXyWmvOLsNpO0WIrA0RJqvtfS9s0tLh4A0Pf8PB2K40IFaX9R1gExC/wLLaWGQ
	 W0SDyavZzXCoK/ksR3sPnCtF8qqHO/hU8AVUQQxl0JGCH/tR/Tdtipkn8GcvDp7aN6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttDnx6c6H63ubxUftv099r2iwX44353q/gC8rbrz5Bs=;
	b=1EielmG24y4g6Z+crpVS9mye/MvxxH1xkucwnEz56mJApeYUrVaZoDGqUQwKp5Bi6zBM
	 h2Y4OIe4SBQFDSWoyKBizXZIHILgd84lNVujfrx8YMOFjih4Qv7BVMf2c7Do4lq0/y79p
	 GTqR4c2IW04tbxCn3lAJQK/g8S3i2yW+WQaBg+kQE4WNIN3XDzKrqv331OUAC2SMlt7uX
	 NCQN5Cz/Irv29tVKMDqQ8dxGnYJF8tBl9wwi1kj+LtrSup/46nKiMbECZR7GqFiT6sUyS
	 AzsKwiqhUc/1H2IJjcSjFUIxqq7pXSRY9qNLFxtsQmHG+VaV0IJrTyD5GLsDm2Dzd4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzBXPeEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E460A3817;
	Fri, 13 Nov 2026 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzBXPeEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C5B1F000C8;
	Fri, 13 Nov 2026 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585641;
	bh=ttDnx6c6H63ubxUftv099r2iwX44353q/gC8rbrz5Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzBXPeEcmvKpBBirLLcbHt/mzrjPOx9lqtG1kmAJeEpOcAdqapwOe2OAydodHDAto
	 B2Xh8AZtrchzrhFythe0VkdMLPjzzIyPKl4OsdKgeajCPNGbpjQcP8BzOWqUxCYc0I
	 wMUblZGnZfRwlWTI0vqzRW4C9xgUGtoGowPxcNww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 233/507] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Fri, 13 Nov 2026 10:48:57 -0500
Message-ID: <20261113153802.388070837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9abb..c6de3ac2f4453 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -914,6 +914,11 @@ struct damon_ctx {
 
 	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
+	/*
+	 * number of regions after last merge.  Read kdamond_split_regions()
+	 * for more details.
+	 */
+	unsigned long last_nr_regions;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 229ab1674b4c1..6db6d2a80e812 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3610,7 +3610,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
 	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
-	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -3626,7 +3625,7 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 	}
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
@@ -3635,7 +3634,7 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 				       ctx->min_region_sz);
 
 done:
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.53.0



