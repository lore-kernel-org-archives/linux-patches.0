Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A19D2ED154;
	Tue, 25 Aug 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665174; cv=none; b=hvyTIKj8rCYRtqn1x04+8DpTeOPCEfSUKp+ZxclFk4cxpYbpD0UYH5n+hGYZXw6PWYEhlI5EAogs2KqeSb2g06gSMxBl2nZt/vsdVKokLnCd+Stl2sUpQeHbF+2ifx+ebEO2KVBGAfaaDS1ZDCSr8ZNoprbo07bBpqxRYVmNMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665174; c=relaxed/simple;
	bh=F4wBxIgD/aoei6/4n9CXviXG6Wu1YxhXsnUkRsLVwhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmYxSj8TIoX3PHGJIsKklWLxRYt3aR4AbnGI/xzSQ1Nz4FL7U+IDuuFj+LdbeCOrp5Q7tKUBCfxfE+OO39I4n7pNqsl88Z0B1BFN3NNO41pTvWg27vQrX4chFcQ0Qneyh0PkfP7j+TBTG+wh/p5cg6tg4WC3QsXUXEanddhgWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHfYyNox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHfYyNox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407EB1F000E9;
	Tue, 25 Aug 2026 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665172;
	bh=q9Rh4N0O1ywAz5dAJNrzZv/QCFtU4+BwsZRZn4TuqGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHfYyNoxgyKtO1l08zd2miHurPekscpzgBLpkTQOYyJhrR4ezu2RvuN9GUyoKvtkA
	 Ncuizjql2aJiqJLnuLro3zMj62l/grzj+qwEAd5DB3EgntSmekL9PADOxepyRxJ6UD
	 82S5eER6mEe1qtRb5uc3ljWAXxgyIVuj9B29C0sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 04/94] xfs: add a xchk_ip_set_corrupt helper
Date: Tue, 25 Aug 2026 15:25:00 +0200
Message-ID: <20260825132542.055168663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit aa7cfdb6e16b474328c79736f9b9dad09addc81c ]

Add a smaller wrapper to set a inode corrupted by the xfs_inode
pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 8ed78104722b ("xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/bmap.c      |    8 ++++----
 fs/xfs/scrub/common.c    |   10 +++++-----
 fs/xfs/scrub/common.h    |    2 ++
 fs/xfs/scrub/dir.c       |    2 +-
 fs/xfs/scrub/dirtree.c   |    4 ++--
 fs/xfs/scrub/metapath.c  |    6 +++---
 fs/xfs/scrub/nlinks.c    |   12 ++++++------
 fs/xfs/scrub/parent.c    |    6 +++---
 fs/xfs/scrub/rtbitmap.c  |   12 ++++++------
 fs/xfs/scrub/rtsummary.c |   12 ++++++------
 10 files changed, 38 insertions(+), 36 deletions(-)

--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1040,7 +1040,7 @@ xchk_bmap(
 	case XFS_COW_FORK:
 		/* No CoW forks filesystem doesn't support out of place writes */
 		if (!xfs_has_reflink(mp) && !xfs_has_zoned(mp)) {
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 			return 0;
 		}
 		break;
@@ -1052,7 +1052,7 @@ xchk_bmap(
 		 * attr here.
 		 */
 		if (!xfs_has_attr(mp))
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		break;
 	default:
 		ASSERT(whichfork == XFS_DATA_FORK);
@@ -1137,7 +1137,7 @@ xchk_bmap_data(
 	int			error;
 
 	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTD_ZAPPED)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -1165,7 +1165,7 @@ xchk_bmap_attr(
 	 * returning immediately.
 	 */
 	if (xchk_file_looks_zapped(sc, XFS_SICK_INO_BMBTA_ZAPPED)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1099,7 +1099,7 @@ xchk_install_live_inode(
 	struct xfs_inode	*ip)
 {
 	if (!igrab(VFS_I(ip))) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		return -EFSCORRUPTED;
 	}
 
@@ -1428,13 +1428,13 @@ xchk_metadata_inode_forks(
 
 	/* Metadata inodes don't live on the rt device. */
 	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
 	/* They should never participate in reflink. */
 	if (xfs_is_reflink_inode(sc->ip)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -1451,7 +1451,7 @@ xchk_metadata_inode_forks(
 				&error))
 			return error;
 		if (shared)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 	/*
@@ -1460,7 +1460,7 @@ xchk_metadata_inode_forks(
 	 */
 	if (xfs_inode_hasattr(sc->ip)) {
 		if (!xfs_has_metadir(sc->mp)) {
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 			return 0;
 		}
 
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -30,6 +30,8 @@ void xchk_set_corrupt(struct xfs_scrub *
 void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
+#define xchk_ip_set_corrupt(_sc, _ip) \
+	xchk_ino_set_corrupt((_sc), (_ip)->i_ino)
 void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
 #ifdef CONFIG_XFS_QUOTA
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -1075,7 +1075,7 @@ xchk_directory(
 
 	/* Plausible size? */
 	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -979,10 +979,10 @@ xchk_dirtree(
 	xchk_dirtree_evaluate(dl, &oc);
 	if (xchk_dirtree_parentless(dl)) {
 		if (oc.good || oc.bad || oc.suspect)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	} else {
 		if (oc.bad || oc.good + oc.suspect != 1)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		if (oc.suspect)
 			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 	}
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -314,7 +314,7 @@ xchk_metapath(
 
 	/* Parent required to do anything else. */
 	if (mpath->dp == NULL) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		return 0;
 	}
 
@@ -329,7 +329,7 @@ xchk_metapath(
 	trace_xchk_metapath_lookup(sc, mpath->path, mpath->dp, ino);
 	if (error == -ENOENT) {
 		/* No directory entry at all */
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_ilock;
 	}
@@ -337,7 +337,7 @@ xchk_metapath(
 		goto out_ilock;
 	if (ino != sc->ip->i_ino) {
 		/* Pointing to wrong inode */
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 out_ilock:
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -719,7 +719,7 @@ xchk_nlinks_compare_inode(
 	 * count, but it will let them decrease it.
 	 */
 	if (total_links > XFS_NLINK_PINNED) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		goto out_corrupt;
 	} else if (total_links > XFS_MAXLINK) {
 		xchk_ino_set_warning(sc, ip->i_ino);
@@ -727,7 +727,7 @@ xchk_nlinks_compare_inode(
 
 	/* Link counts should match. */
 	if (total_links != actual_nlink) {
-		xchk_ino_set_corrupt(sc, ip->i_ino);
+		xchk_ip_set_corrupt(sc, ip);
 		goto out_corrupt;
 	}
 
@@ -748,7 +748,7 @@ xchk_nlinks_compare_inode(
 		 * back references.
 		 */
 		if (obs.backrefs != 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 
@@ -757,7 +757,7 @@ xchk_nlinks_compare_inode(
 		 * children.
 		 */
 		if (obs.children != 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	}
@@ -770,7 +770,7 @@ xchk_nlinks_compare_inode(
 		 * the root directory.
 		 */
 		if (obs.parents != 1) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	} else if (actual_nlink > 0) {
@@ -779,7 +779,7 @@ xchk_nlinks_compare_inode(
 		 * least one parent.
 		 */
 		if (obs.parents == 0) {
-			xchk_ino_set_corrupt(sc, ip->i_ino);
+			xchk_ip_set_corrupt(sc, ip);
 			goto out_corrupt;
 		}
 	}
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -729,10 +729,10 @@ xchk_parent_count_pptrs(
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 		else if (VFS_I(sc->ip)->i_nlink > 0 &&
 			 pp->pptrs_found == 0)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	} else {
 		/*
 		 * Starting with metadir, we allow checking of parent pointers
@@ -743,7 +743,7 @@ xchk_parent_count_pptrs(
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink != pp->pptrs_found)
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_set_corrupt(sc, sc->ip);
 	}
 
 	return 0;
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -200,13 +200,13 @@ xchk_rtbitmap(
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rtb->rextents) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* Is sb_rextslog correct? */
 	if (mp->m_sb.sb_rextslog != rtb->rextslog) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
@@ -215,17 +215,17 @@ xchk_rtbitmap(
 	 * case can we exceed 4bn bitmap blocks since the super field is a u32.
 	 */
 	if (rtb->rbmblocks > U32_MAX) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* The bitmap file length must be aligned to an fsblock. */
 	if (rbmip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
@@ -235,7 +235,7 @@ xchk_rtbitmap(
 	 * file can be larger than sb_rbmblocks.
 	 */
 	if (rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -315,25 +315,25 @@ xchk_rtsummary(
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rts->rextents) {
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 
 	/* Is m_rsumlevels correct? */
 	if (mp->m_rsumlevels != rts->rsumlevels) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
 	/* Is m_rsumsize correct? */
 	if (mp->m_rsumblocks != rts->rsumblocks) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
 	/* The summary file length must be aligned to an fsblock. */
 	if (rsumip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
@@ -343,7 +343,7 @@ xchk_rtsummary(
 	 * the file can be larger than rsumsize.
 	 */
 	if (rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
-		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		xchk_ip_set_corrupt(sc, rsumip);
 		return 0;
 	}
 
@@ -359,7 +359,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (error)


