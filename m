Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE5D53F6AA;
	Wed, 23 Sep 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175297; cv=none; b=LUFz0DrpHvYarzns8LHjP1rErwsvrrqeFYtQnM7Xl0CExBprxrpuS5tCdFqPOKuzhcpcDnjV3j6GjEVdFxtDqU2i+qxwvEyFn9hYbqmUc08Z68nieDK4qzYyXK8KbWI1fCB0STspRepMqaZqfGL+dZ+4+8Hc/Haj30KLCVGzPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175297; c=relaxed/simple;
	bh=7Yw3yr34VSSMCp+JnWLKrCVQO86/5DU0PxiArlhVD0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRjbfDiPnwcVsZCzw/53Wvt9P721zim3ROIz+dbKnP5xqmxUWNDtza/vqlw6CjZILkVOyF5qwy7C0+NgAnUOkw9DQR8ueHRPkkNUpgq0FNRNF2hVcTiCwjnvPP347qZcUhD82ZkUa2aLrIzhHWZJeubgwq93AXiTeZT7hCvZzbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeCh4qFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeCh4qFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C791F00893;
	Wed, 23 Sep 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175295;
	bh=o3Il8HYdE73XjaFkUBaQfO00GsMrD/acFAl43NgRg8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeCh4qFEyVY7o1Nzx/m7WBu9gaQiFOLRAJxphuPuQFYzozOMOqEBXXWslHDYfvY5Y
	 EHLTnNMCw1hpA/KrJRN5DMBVYZt4ZKRI2FYtg4JXj2NL+JuIuXEgrOEXm+kt2vFZTD
	 3x3GALzTkGcsVZbsC7vWwzEWUiTpKeU0Yk2uWof8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/398] xfs: convert xchk_inode_xref_set_corrupt to xchk_ip_xref_set_corrupt
Date: Wed, 23 Sep 2026 16:07:36 +0200
Message-ID: <20260923140653.364369008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

[ Upstream commit bef4cee25fbc26ee8b07028e461190fa57b02788 ]

All xref corruption reports have the xfs_inode structure, so switch
the helper to work based on that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 4d3c07591534 ("xfs: fix under-reservation of blocks when repairing sf directories")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.c    |    6 +++---
 fs/xfs/scrub/common.h    |    4 ++--
 fs/xfs/scrub/dirtree.c   |    4 ++--
 fs/xfs/scrub/inode.c     |    6 +++---
 fs/xfs/scrub/nlinks.c    |    2 +-
 fs/xfs/scrub/rtbitmap.c  |    4 ++--
 fs/xfs/scrub/rtsummary.c |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -309,12 +309,12 @@ xchk_ino_set_corrupt(
 
 /* Record a corruption while cross-referencing with an inode. */
 void
-xchk_ino_xref_set_corrupt(
+xchk_ip_xref_set_corrupt(
 	struct xfs_scrub	*sc,
-	xfs_ino_t		ino)
+	struct xfs_inode	*ip)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xchk_ino_error(sc, ino, __return_address);
+	trace_xchk_ino_error(sc, ip->i_ino, __return_address);
 }
 
 /* Record corruption in a block indexed by a file fork. */
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -41,8 +41,8 @@ void xchk_qcheck_set_corrupt(struct xfs_
 
 void xchk_block_xref_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
-void xchk_ino_xref_set_corrupt(struct xfs_scrub *sc,
-		xfs_ino_t ino);
+void xchk_ip_xref_set_corrupt(struct xfs_scrub *sc,
+		struct xfs_inode *ip);
 void xchk_fblock_xref_set_corrupt(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset);
 
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -981,7 +981,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_scanlock;
 	}
@@ -1011,7 +1011,7 @@ xchk_dirtree(
 		if (oc.bad || oc.good + oc.suspect != 1)
 			xchk_ip_set_corrupt(sc, sc->ip);
 		if (oc.suspect)
-			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ip_xref_set_corrupt(sc, sc->ip);
 	}
 
 out_scanlock:
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -710,17 +710,17 @@ xchk_inode_xref_bmap(
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < xfs_dfork_data_extents(dip))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 
 	error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != xfs_dfork_attr_extents(dip))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 
 	/* Check nblocks against the inode. */
 	if (count + acount != be64_to_cpu(dip->di_nblocks))
-		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, sc->ip);
 }
 
 /* Cross-reference with the other btrees. */
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -741,7 +741,7 @@ xchk_nlinks_compare_inode(
 		 * number of subdirectory entries in the directory.
 		 */
 		if (obs.children != obs.backrefs)
-			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
+			xchk_ip_xref_set_corrupt(sc, ip);
 	} else {
 		/*
 		 * Non-directories and unlinked directories should not have
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -284,7 +284,7 @@ xchk_xref_is_used_rt_space(
 	if (xfs_has_zoned(sc->mp)) {
 		if (!xfs_zone_rgbno_is_valid(rtg,
 				xfs_rtb_to_rgbno(sc->mp, rtbno) + len - 1))
-			xchk_ino_xref_set_corrupt(sc, rtg_rmap(rtg)->i_ino);
+			xchk_ip_xref_set_corrupt(sc, rtg_rmap(rtg));
 		return;
 	}
 
@@ -295,5 +295,5 @@ xchk_xref_is_used_rt_space(
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (is_free)
-		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
+		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
 }
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -190,7 +190,7 @@ xchk_rtsum_record_free(
 	rtlen = xfs_rtxlen_to_extlen(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
-		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
+		xchk_ip_xref_set_corrupt(sc, rtg_bitmap(rtg));
 		return -EFSCORRUPTED;
 	}
 


