Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590035;
	b=wO3d21b/CcNXsVkO00XUVRxjzRVlwERjbK+xHWclrHc91xl5/CRejXvIheGbcepodSmC
	 P3yoPjIXRw2sqBDJ+QMJpFA+LuS4mhas3vTCRpO5kDMleL/BvCqnJyDYCXhx8UHjRYtgH
	 dH7ZXbkk0BLjzxgzyY5Hw/dUt7YGBrSH9JmrwY2sYYHvvxXm8UtWVCuXztsnV/LgH4CoV
	 iDX640aCci354xIET/k81jeDTHkS2X9elB3SAvyI0RO+/hnptuqnx4g3bjUrvhnv42AoG
	 FJfv0DTJD+qusFz0VwSHINRVsGeLRFslwMmBMnvrBJtqgqltEMA88Icr1DuVJaY3/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGPPTZQ1Nd3m5fjT9gZkrF+G+r21n3+8qSDPrMjVwJ4=;
	b=maMFXu0GDXHPoi7JTNODbZ1YCjZDtJEAY4llpZ38QR5nwOe/M+byW2Gml+Wn4vGzyHIB
	 J6IjRyz5qYdspBtoDrfLMjZH7w6inUv8UIZWxAmIsERdz5Zi4rrd5OzlzkOAwpHsTQHTr
	 KpsajIq6kQUTLlU5tOhbgNC699C3nyBG3NpP7+RziW4/yFFNNLRU7vRXts14beGSfplRt
	 tGzAWJgizeuRHt2sLj7O98bR3YcTbJrWbVTH3NedxzDvyfjkKk3cu2qWodkzMDlW7zwp8
	 DQi5sFjegQPfgNEKdnJHYF6EcL8JyqqmOk1GwLC4O1NAIEXGCUuLicNYYqSRt0oXD8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=da2MoI9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BAC60A6F7A;
	Fri, 13 Nov 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=da2MoI9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9683C1F000CA;
	Fri, 13 Nov 2026 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590034;
	bh=KGPPTZQ1Nd3m5fjT9gZkrF+G+r21n3+8qSDPrMjVwJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=da2MoI9VpcVNJzvutzQF6J0FxGf0tgNMBVDme0Zi5qJAanVK5OeKXxBXUGBqrT3jW
	 HyqMqw5H7ZoHfIZZ3oT+xGpU0pGz+ZFXdT91Gqz6g7zulR3JVgrz5MMLmDMW6pYhh2
	 Ou3WKVroddWTxHvrGM2aGlKm+ZtKBbhA3Fj24lLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/686] mm/damon/core: skip applying scheme if region split for quota fails
Date: Fri, 13 Nov 2026 10:43:25 -0500
Message-ID: <20261113153823.348014033@linuxfoundation.org>
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

6.18.y porting notes.  Modify damon_split_region_at() to return
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
index 56f2343ffefac..09365f4275032 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1700,7 +1700,7 @@ static void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
@@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_sz_region);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_filter_out(c, t, r, s))
 			return;
@@ -2462,15 +2463,17 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
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
 
@@ -2480,6 +2483,7 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-- 
2.53.0



