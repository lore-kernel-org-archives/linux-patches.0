Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213212;
	b=shIG9F6fbuTkN5FK3e4LHgvKjD6HxNQC66YcLoTdh6yw1soYK/r33IGSWGI8A3jrT+VC
	 KZM9n8PvKa6IND2TKkmAqeYnWWwp4tMXZJb3nATq4xwBAVlNMmDVSW+rwHrgIcdSAd6CX
	 B2YsMY15Oa8GLbUVJu8wsujBLRwLztIkAwGtUD6alojzA92caWCl3uumgeZ42UAcaf2P0
	 Rdfc7cinkHI4c5vfhyrTG4yxQRvKHUPqkIVyMvwaN/9S3gVSojlpzq+UWOWv/sA6ACxsK
	 14ovl6DDUCfsdATXOCZFbEdQiEcms87yHw6WAhnSaEhjK0lAjNq0WvcQZQUYhfd2oAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKzyc7UsO/kmeHWqluL5gSuNMGjk1I5P986VkSHgdDM=;
	b=3ccVCaKJ8sgLbI7rD2PBL3ySPsgJzdWQMW9tWaC/U6fAtIypa+QUyXU1BHEICYjZBYDP
	 YQvwcf7k5rJGxoV3ZgwDCvLFuSTe++nrIeEyPiZOJgX1b0/f+QH82PFZRCNm5xiWJ3MMC
	 3rKBm1K/a8HnQXB0wp9HGf8CFCPBtbJ2/Rl9j9k6Uf+J4f6JPb1d4JN0j1LZm3g/btDoD
	 cMj8Ug/xKk3veUGOU4bAvwaGcb9/LDdpQpev9ucBtgwHFGvSaJcWygeSgBHIDGsOaZJhg
	 4UzIJ2CFg3Xnzvt76CgnpcE425lbD5hT9SSaYxyLj1zHiXfuD40Qq3832sQ7FB7+DTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsW43rq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070E606A31A;
	Wed, 28 Oct 2026 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsW43rq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707401F01825;
	Wed, 28 Oct 2026 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213212;
	bh=RKzyc7UsO/kmeHWqluL5gSuNMGjk1I5P986VkSHgdDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsW43rq+8MUvYcFBhQd+zJayWi7gBudGeXXKZlaHem2dLx1xxnaitkEprgncLIqB/
	 vGwu05JJQDm12vbkILIy3q1FgGyr5XHcHullfGXqCUigG2o/0IJfJlgLK04BVFY0Xf
	 hgKOMV3JhbBn+SDegUmd6aSJ1unyZj5KiyjTS6po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0425/1887] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Wed, 28 Oct 2026 17:42:01 +0100
Message-ID: <20261028170508.906011466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 1745ccbd2907db2bdaa843e4abccde4fdaccbe5d ]

kdamond_apply_schemes() is using damon_for_each_region_safe(), which is
safe for deallocation of the region inside the loop.  However, the loop
internal logic does not deallocate regions.  Hence it is only wasting the
next pointer.  Also, it causes a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.  The
intention is to let DAMOS apply action to only filtered-in address ranges.
However, it is using damon_for_each_region_safe(), which sets the next
region before the execution of the iteration.  Hence, the region that
split and now will be next to the previous region, is simply ignored.  As
a result, DAMOS applies the action to target regions bit slower than
expected, when the address filter is used.  Shouldn't be a big problem but
definitely better to be fixed.  damos_skip_charged_region() was working
around the issue using a double pointer hack.

Use damon_for_each_region(), which is safe for this use case.  And drop
the work around in damos_skip_charged_region().

Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 568f24da26e6e..6d7a5f18158a0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -788,8 +788,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 					sz = DAMON_MIN_REGION;
 				}
 				damon_split_region_at(t, r, sz);
-				r = damon_next_region(r);
-				sz = damon_sz_region(r);
+				continue;
 			}
 			quota->charge_target_from = NULL;
 			quota->charge_addr_from = 0;
@@ -858,7 +857,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 
 	damon_for_each_scheme(s, c) {
@@ -912,7 +911,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	}
 
 	damon_for_each_target(t, c) {
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 }
-- 
2.53.0



