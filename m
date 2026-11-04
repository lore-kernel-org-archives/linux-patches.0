Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828973;
	b=OUGSaTrdcl+dLHDC/05Bg8M8Ug0IEJwjScN6XT9HGVKA3GrLn2TX2CgGuv9evyQRgzGh
	 Y3DKArYhGSSncIZqY4AsbJSPetoLBgzq9kjNhidjGIlHPbC/+Rr6tWrZw6fM8ibquVGaI
	 n/ykGlbYVu6eHo4bKvHCDm6yPi4yHuAkbFycc5RSpY+mRtkr8K/smj5RoqtMek6Y+szOY
	 7lKZYLXFEgTqSPaIG+DxN+lCLMN7q34p79P28CUt7UpwNQu22sJCgyACqXFuXoKWgjF96
	 xyGUhmb92+8bN+YbtDru+5dfDnrpG27/imQI+Z4Y+ujBcq4qVMo7/ULUKygkhfTJIHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u20Z3NNTyCgDRNk/kdqrWIC54guxtmAQYVhQh3B7Xwc=;
	b=g9g1Qpow9x4BkK2vspXz5BcJBQgp8U7h7aRr0pR63RUYquk29yzEiOSYdn0Aqo5I6vF8
	 ijgVx0R8cXV9nU8HQLJoXlx03lfGSYxdNYkfK6T8Yn8/sZJ6xlU9+gw3FAgIJjQ+4WNM1
	 YOmpEd9UEyYuaUaM2crIv2u4i+BmNh/fTWtsaHcIv8KMyUTN9mnIPBlix+S5cK5xN2ZLD
	 KYUpShZfxyqekfIk4NJ9eMt+ug4oPa3Yv6nDjikWsnP/0gjyVhmvsr6Qd2UC4Q9iKn/t9
	 2Tgjayvdmt2FKYkDlUqoMz2x54RTggJTK2HUBHAC7yRFj2KvUBW9qIAq7ZspsxHp2Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=po3uyR37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE26072665;
	Wed,  4 Nov 2026 21:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=po3uyR37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26F11F00A16;
	Wed,  4 Nov 2026 21:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828973;
	bh=u20Z3NNTyCgDRNk/kdqrWIC54guxtmAQYVhQh3B7Xwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=po3uyR37tHJhfxlKlnW76WDhDsim+btNA35Nn1GsT5VyTuvZsxO6XbESZQbZflSGV
	 FehWvgBsY+r1qXsvcq/lRRiuf3dkrPvnOe3ux3Pue8HsMwId7Sem0d6marZhkDXenx
	 xw5I6puAEtSWYhBOqaYraD0owI2n/ozvDAQ3scjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 363/547] xfs: dont try to repair rtsummary if the summary file isnt computed
Date: Wed,  4 Nov 2026 16:09:07 -0500
Message-ID: <20261104211048.605278884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -212,13 +212,20 @@ xchk_rtsum_compute(
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


