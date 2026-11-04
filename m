Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831604;
	b=kx41syTu21R9YM2a5XDo6/3o/aKNPsKNLpzxtQZwvHXv4r+GQqI7UiL5rSA+x681PxGn
	 K+lPvqtg6V18qnJhbmZSjSA7xydQGk1Jtz+N3ejHIOFpTS+04EQ28xYMfAeGDA64MrOtl
	 z4JCfr9uZYgbzlJXc+oAQaKXcJF+2rGrsDqIl+sZcyXa2SmdxuY4e1p7BDM2nYcfArkG3
	 GWihnSJ9cP22a6UcF1TbcslUw0M1Ek+beJzIxrABFyXwOId9a2zNTKKD+w+9lP7lTzhlW
	 uGXNRTcYcJWra2mS9iY3YuQGjZSnB9q8zwJEny7r6ZfuK/Vdrzn2dzkKEM9B98ZAPLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjbCMvZLS+MgRNJaIDrSFniHaee0QPA/Ts1uYaQLuC4=;
	b=xACcw9Pxkmh2EuONTzMWEx+yE3Dx47KnbRzA4azqr9zbv3cwwn17+7j8QHhbMLAWcECX
	 qaFKKoga+vg7S7BmyOD2EtqNS0dhbdnrFIYg4vaa5a0IHjTokNqx/Xap0vNqOWPT7ul/z
	 baxVqjTysk4O1UHuqUhhZoq509PedVv6M9Wg8Rpr51ULzBgSvCawbdNJkm+LH6ctVJukp
	 mZhCqmArDhzdo06p0eEBKxBRBfJIkSfVb5sjGd4i/s53b5sJpmWdrY4kUpPW2X4CqLii1
	 ugN2ppNF5vvguyCvu5EqgQDiIk94RG7QjvTO8ylhR7K94Y+z5iGYV4RLpw7jS3OnQEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2RdaTBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12484606A31B;
	Wed,  4 Nov 2026 22:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2RdaTBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58141F00919;
	Wed,  4 Nov 2026 22:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831603;
	bh=CjbCMvZLS+MgRNJaIDrSFniHaee0QPA/Ts1uYaQLuC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2RdaTBvNz1QJTbcODfDRVyUvmmIcBfmY6ILjkd1YJsyibH5Ok4l0qooH86QHpMjO
	 1X3JzyU89V4bMWw0fzT7rJ4YEAInGNi7lBOcm0nzb+CnGyHTmJIYGLLVawfDeyJTdc
	 vzpEJAhgo63qM3/MePZUYewwUcT0iWtGdHZsy2xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0797/1005] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed,  4 Nov 2026 16:08:50 -0500
Message-ID: <20261104211105.670015689@linuxfoundation.org>
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

commit 342c2e00b3a99099a7088f7b8c8f075670c603a9 upstream.

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: stable@vger.kernel.org # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota.c        |    8 ++++----
 fs/xfs/scrub/quota_repair.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -185,21 +185,21 @@ xchk_quota_item(
 	 * suspect, which is why we flag it for review.
 	 *
 	 * Complain about corruption if the soft limit is greater than
-	 * the hard limit.
+	 * the hard limit and there's a hard limit set.
 	 */
 	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -197,17 +197,17 @@ xrep_quota_item(
 		return error;
 
 	/* Check the limits. */
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit) {
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit) {
 		dq->q_blk.softlimit = dq->q_blk.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit) {
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit) {
 		dq->q_ino.softlimit = dq->q_ino.hardlimit;
 		dirty = true;
 	}
 
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit) {
 		dq->q_rtb.softlimit = dq->q_rtb.hardlimit;
 		dirty = true;
 	}


