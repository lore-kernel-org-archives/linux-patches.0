Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061692;
	b=UPazxUCTooRGeHdmQ6QIbZEwVrlCgdltDS+lWF2E9OfiGsAZFJA1rpINQmUEh56m1AZK
	 KKthIqASMsqKCGWJIXr600BKF02VaqoCYs+YhkueHhcFukmOtEM7d/0O/ppbICS2orlFY
	 nOHGZD5lujuAW3YtkYSy62P0a7eEJXB9GS6slwYvh6QIplQsqRJqaqPM0Bt1mixnOqx0t
	 oKSWTXfo6A2wMgH/sbgxnTVvpmvveEFAR43VaH3wPWNra/Vep+mDK0BBrF/d3arRJov3K
	 hdIOEdf/rTZ9+l0e1ss9sWN1d5gRrPyC/qWYWg2AuRu3WgIrRfnRAxBgV1YviUmt1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhmMOujV+X4VahiFfAB969QFEePd4RHOScUghbr5BEg=;
	b=NCZJMo3CLunUycn7vLiTRcIoAHTKjeyDpyQVfHatQGdqZ8n0I8WLaX9p07Jrz6XFNNT7
	 dYVDb1KbqzJ6GuwtETxpPggfE9cw3Kq5ZE+bqhd9turef53BXrohNbbWm4JuMvfnjEJFX
	 zfVpauh9N0muKen9gDBLUf6baI/gMnwOQoYM+CMPgpr7cbRObGji+zinD2X70Q/TDAuea
	 LvHkFGT+haDV/vVR3WU1pCoEhPNRMg/kuja4LeY8rFJR21OqX8Y/YYFCDr9l6AnE73vYe
	 hLd22G9PisJ3Eqg93dvWHIun/NvnOioIyBhtEiNcO9CUNbNXzqqlb6sUBVXmbnNhDeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DToDhRoF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63AB606A326;
	Sat,  7 Nov 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DToDhRoF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF641F0089F;
	Sat,  7 Nov 2026 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061691;
	bh=DhmMOujV+X4VahiFfAB969QFEePd4RHOScUghbr5BEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DToDhRoF3PuLDBE0uHnm0kkH2TBZNZ95IdjU9/0lZfXh+kI5ZxMo8RoOr2g7hmGAU
	 Y+f2vvRbDNfYawfoQekZ137teftkTjM1+FPlEw4qjeeOQw6TKkNk2G8XwBTRVrkxo7
	 5p3tEKWdeXDvwl4JezuDKanpjIMFp3eoaMrST96M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0705/1536] xfs: allow softlimit with no hardlimit in quota scrub
Date: Sat,  7 Nov 2026 08:45:21 -0500
Message-ID: <20261107135017.296392978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


