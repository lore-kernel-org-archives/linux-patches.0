Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831685;
	b=eKXkl+6L2p0g0K6iW4eaMioEJqk9VcsTKaQ3u300L1n2MVR+0uyQViVj5LA53Q/xK1nI
	 RuxLE7yOY2F/P2S8I8A/QuSoJVL4zFaWU1xdhpKo17LywSLq9U5ZFyYH6n0WtA8hK7h0T
	 4d+DKr97JOdoUzpe/g+ICtIqjI1Do0v5zRPHLrwybHPKAvReu8vq3RW20r0SCrdwUh0DN
	 0QdO/mxLTpswWsx1n9M1xMJP/uodcuFjU3rNBC4fcLNEcML0mSJu+vI9d/KeRMkbmqpyP
	 3WbD/S2AoTo/XcuKlSXxCfPVjH30zHQ8szTsb8MbBirAYkogkg0N80pcl1QCbQaOccQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q5BCCmV4dgDkyuSbm/nWS/GYteIZ3nOLPCJElTCYVeQ=;
	b=pcA5twWGFKvoAws0AZRclbDlp5GNp2GsSl05yeWjPCSg9hKath6aibeFLVdXwvBZMt5/
	 VppQmUFMR69XbiP/5YDRLLrJ5J7q5AS1gQbZa+YHcdNev3Umq/IdX2iEczxHnuXUzimdi
	 inwVMevR/ric0nZihJEFqtgl7mZBVQ713MQQApRtNa25RjjbvCdhXzZVZbDVH9oWJILTF
	 N4cr3iUsge05og8Vd0KkBo1L7rqsSkpjl6R/uBSSazgsfYTvGg1S6frLBk9pec3pb8inK
	 0JGtuI0sY4pRAsNvtmmNQP2DiRz1/ymnh5OZmmS73BU0tyP82JUGCuJNDMzgDwW7YXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JElZJv+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA5D606A85B;
	Wed,  4 Nov 2026 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JElZJv+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18DF1F00A18;
	Wed,  4 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831684;
	bh=q5BCCmV4dgDkyuSbm/nWS/GYteIZ3nOLPCJElTCYVeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JElZJv+EHIb5qR9ERxlQB4q4c2YSw7z6DsGO23BW83oejlv/KRcfhAN+7ad38QogK
	 Z/DFectAdENgd/5W0Qj0gEbquH+FhEYg6nmlugjrKjYpIZ1jakRBPRg/Qvj9+7dYh9
	 ak2NVqSv+6q7feYxRq7/K5rA7rijkejw3WR5qHy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0854/1005] xfs: dont try to repair rtsummary if the summary file isnt computed
Date: Wed,  4 Nov 2026 16:09:47 -0500
Message-ID: <20261104211107.212364745@linuxfoundation.org>
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

commit 6e82b7641889ad0198f3bf17a5e4c6fe7aab0850 upstream.

LOLLM observed that we can erroneously try to repair the rtsummary file
if we've not yet computed its contents.  That results in a corrupt
summary file, so let's add a flag to track whether or not the incore
data is complete.

Cc: stable@vger.kernel.org # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtsummary.c        |    9 ++++++++-
 fs/xfs/scrub/rtsummary.h        |    1 +
 fs/xfs/scrub/rtsummary_repair.c |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -213,13 +213,20 @@ xchk_rtsum_compute(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xchk_rtsummary	*rts = sc->buf;
+	int			error;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	if (XFS_FSB_TO_B(mp, xfs_rtbitmap_blockcount(mp)) !=
 	    rtg_bitmap(rtg)->i_disk_size)
 		return -EFSCORRUPTED;
 
-	return xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	if (error)
+		return error;
+
+	rts->summary_computed = true;
+	return 0;
 }
 
 /* Compare the rtsummary file against the one we computed. */
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -17,6 +17,7 @@ struct xchk_rtsummary {
 	xfs_filblks_t		rsumblocks;
 	unsigned int		rsumlevels;
 	unsigned int		resblks;
+	bool			summary_computed;
 
 	/* suminfo position of xfile as we write buffers to disk. */
 	xfs_rtsumoff_t		prep_wordoff;
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -122,7 +122,7 @@ xrep_rtsummary(
 		return -EOPNOTSUPP;
 
 	/* Walk away if we disagree on the size of the rt bitmap. */
-	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
+	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks || !rts->summary_computed)
 		return 0;
 
 	/* Make sure any problems with the fork are fixed. */


