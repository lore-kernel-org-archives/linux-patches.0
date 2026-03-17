Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F043F54D9;
	Tue, 17 Mar 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767004; cv=none; b=kxyCCO1rS6KOTC4AgpF+5TY4knzx0Trclj2dbDQs7mKzeclCNtAWlw3JBSVdpEt96Dau9ZEwgqUcVrf7UxpXpA05EAUizp9JJEx9lmSGr696VaRTjyMz7by0ILF30GS01VyiFfaC0ZFv3UGVPVKtPIe6zy7C/Yt+XSHWgGPoa9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767004; c=relaxed/simple;
	bh=vGat6SrpF2rvRCHIEXfLDW+7qVycveNl0CYVU+jcSdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKCwbVVTHEEsORJ4zjIr+meJVNuYI8VO6EFSH7is0mGrsDFT1xpVbfCYg6ID15ZpyOnRUqjNXi0nlQuuOLH5irg067Nsyakx8SmuWdiGeBkUEMjBTkTXsQkt2gcfXUCrYcotarhE19vqKuH+o0j1ACIwJz+1YH9nL4ap0fjUaKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moz1OiO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moz1OiO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3A6C19424;
	Tue, 17 Mar 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767004;
	bh=vGat6SrpF2rvRCHIEXfLDW+7qVycveNl0CYVU+jcSdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moz1OiO3xjZlyuo5GBWXLoSPdC1/oinUjm+BzhWwOx4BVvmN8ELwFvdQrrbW/zGCY
	 gaPzLIKtKNDw1V7ro1s6Ab2Ex19aoZnnwHtOG6qVIUfqmNFByF1ou0QAZBccv7a91v
	 Z2mL+citLv99cnYiK6RiDr+cXcCkmXbpsTCcxdss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 371/378] mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
Date: Tue, 17 Mar 2026 17:35:28 +0100
Message-ID: <20260317163020.626677193@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit dfb1b0c9dc0d61e422905640e1e7334b3cf6f384 ]

The macro is for the default minimum size of each DAMON region.  There was
a case that a reader was confused if it is the minimum number of total
DAMON regions, which is set on damon_attrs->min_nr_regions.  Make the name
more explicit.

Link: https://lkml.kernel.org/r/20260117175256.82826-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h        |    2 +-
 mm/damon/core.c              |    2 +-
 mm/damon/lru_sort.c          |    2 +-
 mm/damon/reclaim.c           |    2 +-
 mm/damon/sysfs.c             |    2 +-
 mm/damon/tests/vaddr-kunit.h |    2 +-
 mm/damon/vaddr.c             |   24 ++++++++++++------------
 7 files changed, 18 insertions(+), 18 deletions(-)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -15,7 +15,7 @@
 #include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
-#define DAMON_MIN_REGION	PAGE_SIZE
+#define DAMON_MIN_REGION_SZ	PAGE_SIZE
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -546,7 +546,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->addr_unit = 1;
-	ctx->min_sz_region = DAMON_MIN_REGION;
+	ctx->min_sz_region = DAMON_MIN_REGION_SZ;
 
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -212,7 +212,7 @@ static int damon_lru_sort_apply_paramete
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,7 +208,7 @@ static int damon_reclaim_apply_parameter
 	if (!monitor_region_start && !monitor_region_end)
 		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
-	param_ctx->min_sz_region = max(DAMON_MIN_REGION / addr_unit, 1);
+	param_ctx->min_sz_region = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1470,7 +1470,7 @@ static int damon_sysfs_apply_inputs(stru
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_sz_region = max(
-				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -147,7 +147,7 @@ static void damon_do_test_apply_three_re
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -19,8 +19,8 @@
 #include "ops-common.h"
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
+#undef DAMON_MIN_REGION_SZ
+#define DAMON_MIN_REGION_SZ 1
 #endif
 
 /*
@@ -78,7 +78,7 @@ static int damon_va_evenly_split_region(
 
 	orig_end = r->ar.end;
 	sz_orig = damon_sz_region(r);
-	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
+	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION_SZ);
 
 	if (!sz_piece)
 		return -EINVAL;
@@ -161,12 +161,12 @@ next:
 		swap(first_gap, second_gap);
 
 	/* Store the result */
-	regions[0].start = ALIGN(start, DAMON_MIN_REGION);
-	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION);
-	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION);
-	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION);
-	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION);
-	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION);
+	regions[0].start = ALIGN(start, DAMON_MIN_REGION_SZ);
+	regions[0].end = ALIGN(first_gap.start, DAMON_MIN_REGION_SZ);
+	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION_SZ);
+	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION_SZ);
+	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION_SZ);
+	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION_SZ);
 
 	return 0;
 }
@@ -259,8 +259,8 @@ static void __damon_va_init_regions(stru
 		sz += regions[i].end - regions[i].start;
 	if (ctx->attrs.min_nr_regions)
 		sz /= ctx->attrs.min_nr_regions;
-	if (sz < DAMON_MIN_REGION)
-		sz = DAMON_MIN_REGION;
+	if (sz < DAMON_MIN_REGION_SZ)
+		sz = DAMON_MIN_REGION_SZ;
 
 	/* Set the initial three regions of the target */
 	for (i = 0; i < 3; i++) {
@@ -299,7 +299,7 @@ static void damon_va_update(struct damon
 	damon_for_each_target(t, ctx) {
 		if (damon_va_three_regions(t, three_regions))
 			continue;
-		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION);
+		damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 	}
 }
 


