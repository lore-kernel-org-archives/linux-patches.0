Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590886;
	b=hGZs+JLU/EQhL5icpPquFeeHjbvx1OjhbPJqdlFUsugA2lLd6JVO0WsFEwdxP+AyWD0W
	 Rze8Qvv5YNm0hVpwRcz0xgybXyB6NJhULaLdIOFnpQSlnMJOlMF/sRwypsYOvtTSVEwaE
	 b/IXgHlfNT7q+I1uNgzkE3qQveLKMivRx3ODfyCnj2FgQmy0Tc6S/73vXtE0ehcZUwTGb
	 In7Ui1uhnZIiQhJ0Zq18K3kAeQJwt9kHIYYY2rgwUYfkcx2WCqXDqVjlQLhMVD2+xzbf8
	 hLp0hkldFM1dRnurkF99pq5nb5ySuiskpM1VeZHVc3VSzxVv/VcHkgwISTU+bpBerAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LiI6jdBVJBwHwsHHR9jHJBXG7e9hXtZaKYrAHFM6gQ=;
	b=frFuN9Y2YxlCVC+9jJCGvBO/IomPzBsfVaDl8y0lDw3NPX0ECZlMe+SovIBjWSQD43RW
	 1QJ2u9t/zlAL7HvSsOOr9hhiPEnwBOLVIcSmTU11Bc+geVStuQD1aipknZ0QrGWo7bwMY
	 zwDTL6ME72uXMRRBM7AUOEn4OAr33x0KE7IrS+XZjgz+1df05aznZIFFzCxdFa8Q36DHU
	 6fTIFgJQNe6Qa3heoTY4gjR1DbLGoN+U7L6ucnCeLOKgDuQwJwEnUr9SFMRxXwI6a/Zof
	 AQps8RjfN5R/JgNyCSQ1p60PCzdq/NQBPlVPqG36iQge8fo7sPRxbGA0tlx/aERfYhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ua2FSUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DEA606D4B5;
	Fri, 13 Nov 2026 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ua2FSUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207341F000C6;
	Fri, 13 Nov 2026 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590886;
	bh=1LiI6jdBVJBwHwsHHR9jHJBXG7e9hXtZaKYrAHFM6gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ua2FSUMvM+s/z/Iar0XpvOXYHSVUfyYnMbUHgQJ6QGlr1jj64NSY/juluPGJfo1c
	 VpOtFddGj4fbUQDxcPuwOnJFaWhz/UmXPXmZ55kwfsQ5QmvtozSemTcAPMtOd0hrxA
	 UzftlChTi+THPTAizKSPgEDdZcecLVn1aEhUPJ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/670] mm/damon/core: skip applying scheme if region split for quota fails
Date: Fri, 13 Nov 2026 10:44:04 -0500
Message-ID: <20261113153814.429462850@linuxfoundation.org>
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

[ Upstream commit 90c2fa6adfed7abe0935506a43cdff3a05c1fff0 ]

Patch series "mm/damon: fix DAMOS bugs in core, paddr and vaddr".

Fix misc bugs of DAMOS.  Patch 1 makes DAMOS less stress memory allocator
under extreme situation.  Patches 2 and 3 fix wrong folios walking in
DAMON_PADDR.  Patches 4 and 5 fix wrong folios walking in DAMON_VADDR.
Patches 6-8 handle extreme and unlikely memory situations that can cause
divide by zero and underflow.

All bugs are discovered by Sashiko.

This patch (of 8):

damos_apply_scheme() splits a region and apply the action to the subregion
if it is needed for not violating the quota.  The split operation
(damon_split_region_at()) could fail for allocation failure.  In the case,
the quota could be violated.  From the user's perspective, DAMOS becomes
more aggressive than expected under the extreme situation.  Handle the
failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set min_nr_regions
to set the maximum size of each region.  If it is reasonably set, the
transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

6.12.y porting notes.  Modify damon_split_region_at() to return
failures.  It is a part of commit c60874860762 ("mm/damon/core: handle
region split failure in apply_min_nr_regions()").  Without it, build
fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3142776e2e0ee..200cadceed148 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1274,7 +1274,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 	}
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -1478,7 +1478,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					DAMON_MIN_REGION);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -1870,15 +1871,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
 
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -1888,6 +1891,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.53.0



