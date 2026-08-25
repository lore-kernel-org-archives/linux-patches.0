Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F273909A4;
	Tue, 25 Aug 2026 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665538; cv=none; b=RwMTQShjw6r1AsP/2imkkv8AEKhCSDgnpEJLvW2bizLLwP5PvWT7IHc1Zee9lh/tC6eHdORvZW9YkcNr0k2MOEGi3UMlW9DzrVy9iBtvKqVJj0M1rOVH5NPcQQsL1/THxiGeoLrv+4H+SJQCZMJN3OOlMHK6Wi0s+MKi5Fwf2+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665538; c=relaxed/simple;
	bh=Yogulcc07RWmxhjrEm1EaRGkP0niLGai7jzSIRvfv5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLYui+74FzHT6WtYb1LYulmPtDtc6CB7YKM55Rw7UhaRlUXxvRZxhy8N8wqHmR4+jZgtQuC5GZVa6dKCN+yb1FCf+AhcA0XkBjhD697QRE99v3im+kqJr9nm7c62R1jXp42tAUOTtAcuYiO8bFv0e+yCbs2MB2lA7J5rW0f6J+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVI2wWEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVI2wWEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7DA1F00A3A;
	Tue, 25 Aug 2026 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665537;
	bh=sfmU8LJQgbNzX+UavJfy2Fwf+ku5DM+CflDaqz/iGvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVI2wWEmvwJLZwMsTK2BpA3I0D06IzEm7Kz2LVoatAfyL5jRhIUW+8D9j0t8FjU+x
	 k7NGU6xpdhZlD4WVqKhAdgApYoHJyjY7u+y5qRyzwWQaawJrwptXZ7MOIqyOV7z/dd
	 /5hl1gRtrxl3MkK1iFOYRq9UUYtOJgn1+TN0sDgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/77] xfs: namespace the maximum length/refcount symbols
Date: Tue, 25 Aug 2026 15:25:42 +0200
Message-ID: <20260825132542.356031782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 70fcf6866578e69635399e806273376f5e0b8e2b ]

Actually namespace these variables properly, so that readers can tell
that this is an XFS symbol, and that it's for the refcount
functionality.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 813f8136a2ce ("xfs: bounds-check buffer log item's dirty bitmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_format.h     |    4 ++--
 fs/xfs/libxfs/xfs_refcount.c   |   18 +++++++++---------
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/refcount_repair.c |    4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1625,8 +1625,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -128,7 +128,7 @@ xfs_refcount_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -138,7 +138,7 @@ xfs_refcount_check_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -853,9 +853,9 @@ xfs_refc_merge_refcount(
 	const struct xfs_refcount_irec	*irec,
 	enum xfs_refc_adjust_op		adjust)
 {
-	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
-	if (irec->rc_refcount == MAXREFCOUNT)
-		return MAXREFCOUNT;
+	/* Once a record hits XFS_REFC_REFCOUNT_MAX, it is pinned forever */
+	if (irec->rc_refcount == XFS_REFC_REFCOUNT_MAX)
+		return XFS_REFC_REFCOUNT_MAX;
 	return irec->rc_refcount + adjust;
 }
 
@@ -898,7 +898,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -933,7 +933,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -967,7 +967,7 @@ xfs_refc_want_merge_right(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cright->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -1196,7 +1196,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -421,7 +421,7 @@ xchk_refcount_mergeable(
 	if (r1->rc_refcount != r2->rc_refcount)
 		return false;
 	if ((unsigned long long)r1->rc_blockcount + r2->rc_blockcount >
-			MAXREFCEXTLEN)
+			XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -177,7 +177,7 @@ xrep_refc_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
-	irec.rc_refcount = min_t(uint64_t, MAXREFCOUNT, refcount);
+	irec.rc_refcount = min_t(uint64_t, XFS_REFC_REFCOUNT_MAX, refcount);
 
 	error = xrep_refc_check_ext(rr->sc, &irec);
 	if (error)
@@ -416,7 +416,7 @@ xrep_refc_find_refcounts(
 	/*
 	 * Set up a bag to store all the rmap records that we're tracking to
 	 * generate a reference count record.  If the size of the bag exceeds
-	 * MAXREFCOUNT, we clamp rc_refcount.
+	 * XFS_REFC_REFCOUNT_MAX, we clamp rc_refcount.
 	 */
 	error = rcbag_init(sc->mp, sc->xmbtp, &rcstack);
 	if (error)


