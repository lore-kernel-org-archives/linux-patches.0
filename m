Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831568;
	b=M0XH8UZ6lzixMni2ry6/wFixmusO2aj9UH77bSDErn7hfppB/KTEehmrd8PmKTriEwRU
	 i0O4DZ6lT7mm3EE/R0WxPAuzxUp7EbKGmUS5mJlbcyGOQcQltDXA3e39pedU34mGwrL4p
	 PYjSz0SdBgkodBByEswk2g4CcsDdAYrBggKxt57jmVpmHofxqq/xVwclkou0yKEcFsyKu
	 tGaBZCXcyJJreMI2psacYmxtcg7d8Lk/1HZIbwqmcoSQ6pdWoUg3/f7ssvTIYCmesjlIF
	 rmaoD60rB7aW0IgCL5KTrjYjnME5Qg/9FSQOIpgFU080w1jB8u4wGWzk8f7CAYUtWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9n2qrBQ1+JVu6dUf5OLYC+80bT04EN0r6qiNxbeZTU=;
	b=Y2/cItBaAWjJDyPob5DL5V8vCHlpwBEBqH/wgeZ5myyQdnyMRWfMVLcb5cFzUC3vGz8e
	 pdmRvon73saZU6kH8lzaQIlGr7R2uf8V2EGClETVYWSsaoALrQmIJ1azHLil6AZYgi9Y3
	 Z6CywYQF7anxTS7BEmuCEkAxUU5D6JGwcomzCMBiccwq7DnE2VX5wC9Yw+sLaBy61rZsY
	 Mtk5NALZfu7ixORQRZ0up/rdXyZpq5aTfKggHRnlHwbduN8nboDhDjbvl7UsFIMoXDLwH
	 yPw0m0S7fJiH6IrS8B0HTKJfAFM8SZXwvWgr2pjirCZLHBpG1CV3yBurBh8z4Xy40zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETOTCU+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F5606A844;
	Wed,  4 Nov 2026 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETOTCU+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FCD1F00A02;
	Wed,  4 Nov 2026 22:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831568;
	bh=O9n2qrBQ1+JVu6dUf5OLYC+80bT04EN0r6qiNxbeZTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETOTCU+Ua9ZcXVTQWoBlJKr1Wi8yOFgRJ8sqr+n14QVaP8NUs7MzWtIYFhi4KfV5x
	 rIztLTpWNiHmtbehjYUB6MkJt1y1NBA0X5CLvGPnUrnvgGM68KCDdwEvzHSMEdaySk
	 REUjBKrvL9YNMCxE8oEtO0vrkpbMmu+XO0KsdxD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0781/1005] xfs: avoid cross-rtgroup reaping after a repair
Date: Wed,  4 Nov 2026 16:08:34 -0500
Message-ID: <20261104211105.238630784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit d7c204d4ea7ef0cf0dac908388984c2936f1f94e upstream.

LOLLM notices that the extents stored in a xrtb_bitmap (aka xfs_rtblock
bitmap) can span multiple rtgroups due to two circumstances.  The first
is that the size of an rtgroup is an exact power of two, which means
that rtgroups are adjacent in the segmented xfs_rtblock_t address space.
This is fairly common to reduce the amount of multiplication and
division needed to handle space on the rt volume.

The second is that (unlike in the original rtgroups design), rtgroups do
not have fixed-location metadata like AGs do, which means that there's
nothing to force a break between rtgroups.

Therefore, we must loop through the rtgroups in xreap_rtmeta_extent to
avoid running off the end of an rtgroup while reaping.

Cc: stable@vger.kernel.org # v6.14
Fixes: fd97fe1112088c ("xfs: fix CoW forks for realtime files")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |   59 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 11 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1080,26 +1080,23 @@ xreap_configure_rgcow_limits(
 				 XFS_RTGLOCK_RMAP | \
 				 XFS_RTGLOCK_REFCOUNT)
 
-/*
- * Break a rt file metadata extent into sub-extents by fate (crosslinked, not
- * crosslinked), and dispose of each sub-extent separately.  The extent must
- * be aligned to a realtime extent.
- */
-STATIC int
-xreap_rtmeta_extent(
-	uint64_t		rtbno,
+static int
+xreap_rtgroup_extent(
+	struct xreap_state	*rs,
+	xfs_rtblock_t		rtbno,
 	uint64_t		len,
-	void			*priv)
+	xfs_rgblock_t		*done)
 {
-	struct xreap_state	*rs = priv;
 	struct xfs_scrub	*sc = rs->sc;
 	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(sc->mp, rtbno);
-	xfs_rgblock_t		rgbno_next = rgbno + len;
+	xfs_rgblock_t		rgbno_next;
 	int			error = 0;
 
 	ASSERT(sc->ip != NULL);
 	ASSERT(!sc->sr.rtg);
 
+	*done = 0;
+
 	/*
 	 * We're reaping blocks after repairing file metadata, which means that
 	 * we have to init the xchk_ag structure ourselves.
@@ -1110,6 +1107,7 @@ xreap_rtmeta_extent(
 
 	xfs_rtgroup_lock(sc->sr.rtg, XREAP_RTGLOCK_ALL);
 
+	rgbno_next = rgbno + min(len, (uint64_t)rtg_blocks(sc->sr.rtg) - rgbno);
 	while (rgbno < rgbno_next) {
 		xfs_extlen_t	rglen;
 		bool		crosslinked;
@@ -1136,6 +1134,7 @@ xreap_rtmeta_extent(
 		}
 
 		rgbno += rglen;
+		*done += rglen;
 	}
 
 out_unlock:
@@ -1146,6 +1145,44 @@ out_unlock:
 }
 
 /*
+ * Break a rt file metadata extent into sub-extents by fate (crosslinked, not
+ * crosslinked), and dispose of each sub-extent separately.  The extent must
+ * be aligned to a realtime extent.
+ */
+STATIC int
+xreap_rtmeta_extent(
+	uint64_t		rtbno,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xreap_state	*rs = priv;
+	int			error;
+
+	/*
+	 * Space from adjacent rtgroups can be stored as a single bitmap extent
+	 * because rtgroups do not have fixed-location metadata such as a
+	 * per-group superblock that cannot be reaped.  Handle these overlaps
+	 * by only reaping within a single rtgroup at a time.
+	 *
+	 * In the somewhat unlikely event that an rtgroup size is not a power
+	 * of two, the segmented nature of xfs_rtblock_t prevents space in
+	 * adjacent rtgroups from merging in the bitmap.
+	 */
+	while (len > 0) {
+		xfs_rgblock_t	done = 0;
+
+		error = xreap_rtgroup_extent(rs, rtbno, len, &done);
+		if (error)
+			return error;
+
+		rtbno += done;
+		len -= done;
+	}
+
+	return 0;
+}
+
+/*
  * Dispose of every block of every rt metadata extent in the bitmap.
  * Do not use this to dispose of the mappings in an ondisk inode fork.
  */


