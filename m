Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F79729AAFC;
	Tue, 25 Mar 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905633; cv=none; b=G6JwRhFp4Cx3s0egRnUIQsa1h6AeXYA5GCyWq0IO8P+x49AdE6vNv9W8eHxQT4Y1a5TYFAqVb/3qkvWKGkOs4zDSRTrvbmGZ5XnUBO6+1SDdG8R7Aouf7wxEzFZ4dtNQYjHKi3SJ2S3ARxu7twrNHzuDq0/Rpq4pdzjzVHHrL6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905633; c=relaxed/simple;
	bh=lVVPTK3Xa/Wv4PUIbzmAg0HoSGnzORQGZunFuTI84sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5gK3sAz1RlzTIoICef/tm7xZNt3Mm0eDLP+iX2iz132YtTNid4RH9HcMpsofvIt7dH8gpYhkKcMruH9c2MLPBb0rEYekRta7J/RL2h2HfWexyeqH8jICVhilrrM60d7zIrIzZP644lMbpP22y6vFkXbrSRvkCiQH31PtTkxV58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhPaoluP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhPaoluP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCCEC4CEED;
	Tue, 25 Mar 2025 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905632;
	bh=lVVPTK3Xa/Wv4PUIbzmAg0HoSGnzORQGZunFuTI84sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhPaoluPthoSocdKGyxnpJwvR1kElIaVJlTTpMUS5hidtGNXzN0zkLPElHwLyP2V7
	 nT/naocXAoiBLk50v33EL6f5x2ENSecMmkFj+7QPC2X2sOijTKPVQzosidpjEQbImd
	 s26rmxavYco0YjeV/IonT830PPwd49YEiu6B75vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 080/198] xfs: fix confusing xfs_extent_item variable names
Date: Tue, 25 Mar 2025 08:20:42 -0400
Message-ID: <20250325122158.740201737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 578c714b215d474c52949e65a914dae67924f0fe ]

Change the name of all pointers to xfs_extent_item structures to "xefi"
to make the name consistent and because the current selections ("new"
and "free") mean other things in C.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   32 ++++++++++-----------
 fs/xfs/xfs_extfree_item.c |   70 +++++++++++++++++++++++-----------------------
 2 files changed, 51 insertions(+), 51 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2493,20 +2493,20 @@ xfs_defer_agfl_block(
 	struct xfs_owner_info		*oinfo)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*new;		/* new element */
+	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_cache_zalloc(xfs_extfree_item_cache,
+	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
-	new->xefi_blockcount = 1;
-	new->xefi_owner = oinfo->oi_owner;
+	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
+	xefi->xefi_blockcount = 1;
+	xefi->xefi_owner = oinfo->oi_owner;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
 }
 
 /*
@@ -2521,7 +2521,7 @@ __xfs_free_extent_later(
 	const struct xfs_owner_info	*oinfo,
 	bool				skip_discard)
 {
-	struct xfs_extent_free_item	*new;		/* new element */
+	struct xfs_extent_free_item	*xefi;
 #ifdef DEBUG
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_agnumber_t			agno;
@@ -2540,27 +2540,27 @@ __xfs_free_extent_later(
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
 
-	new = kmem_cache_zalloc(xfs_extfree_item_cache,
+	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	new->xefi_startblock = bno;
-	new->xefi_blockcount = (xfs_extlen_t)len;
+	xefi->xefi_startblock = bno;
+	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	if (skip_discard)
-		new->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
 		if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
-			new->xefi_flags |= XFS_EFI_ATTR_FORK;
+			xefi->xefi_flags |= XFS_EFI_ATTR_FORK;
 		if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
-			new->xefi_flags |= XFS_EFI_BMBT_BLOCK;
-		new->xefi_owner = oinfo->oi_owner;
+			xefi->xefi_flags |= XFS_EFI_BMBT_BLOCK;
+		xefi->xefi_owner = oinfo->oi_owner;
 	} else {
-		new->xefi_owner = XFS_RMAP_OWN_NULL;
+		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
 	trace_xfs_bmap_free_defer(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
 }
 
 #ifdef DEBUG
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -345,30 +345,30 @@ static int
 xfs_trans_free_extent(
 	struct xfs_trans		*tp,
 	struct xfs_efd_log_item		*efdp,
-	struct xfs_extent_free_item	*free)
+	struct xfs_extent_free_item	*xefi)
 {
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
 	uint				next_extent;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
-							free->xefi_startblock);
+							xefi->xefi_startblock);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-							free->xefi_startblock);
+							xefi->xefi_startblock);
 	int				error;
 
-	oinfo.oi_owner = free->xefi_owner;
-	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+	oinfo.oi_owner = xefi->xefi_owner;
+	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
-			free->xefi_blockcount);
+			xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, free->xefi_startblock,
-			free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
-			free->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	error = __xfs_free_extent(tp, xefi->xefi_startblock,
+			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -382,8 +382,8 @@ xfs_trans_free_extent(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
 	return error;
@@ -411,7 +411,7 @@ STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_efi_log_item		*efip,
-	struct xfs_extent_free_item	*free)
+	struct xfs_extent_free_item	*xefi)
 {
 	uint				next_extent;
 	struct xfs_extent		*extp;
@@ -427,8 +427,8 @@ xfs_extent_free_log_item(
 	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
 	ASSERT(next_extent < efip->efi_format.efi_nextents);
 	extp = &efip->efi_format.efi_extents[next_extent];
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 }
 
 static struct xfs_log_item *
@@ -440,15 +440,15 @@ xfs_extent_free_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &efip->efi_item);
 	if (sort)
 		list_sort(mp, items, xfs_extent_free_diff_items);
-	list_for_each_entry(free, items, xefi_list)
-		xfs_extent_free_log_item(tp, efip, free);
+	list_for_each_entry(xefi, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, xefi);
 	return &efip->efi_item;
 }
 
@@ -470,13 +470,13 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	int				error;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
-	error = xfs_trans_free_extent(tp, EFD_ITEM(done), free);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
@@ -493,10 +493,10 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -522,7 +522,7 @@ xfs_agfl_free_finish_item(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
 	int				error;
@@ -531,13 +531,13 @@ xfs_agfl_free_finish_item(
 	uint				next_extent;
 	struct xfs_perag		*pag;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	ASSERT(free->xefi_blockcount == 1);
-	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
-	oinfo.oi_owner = free->xefi_owner;
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	ASSERT(xefi->xefi_blockcount == 1);
+	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
+	oinfo.oi_owner = xefi->xefi_owner;
 
-	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
+	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, xefi->xefi_blockcount);
 
 	pag = xfs_perag_get(mp, agno);
 	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
@@ -558,11 +558,11 @@ xfs_agfl_free_finish_item(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 


