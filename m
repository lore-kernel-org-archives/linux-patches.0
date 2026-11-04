Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831564;
	b=PSM+T3cvJUyRtMazb1ke7IK9oryO1XfpVuWfYCTgKGkCyjxfPyKOhZI413PAmCmK+xQU
	 xFn2QNZk6jjvRS8kKKUxqMH3USzux/4KL5/QA72R/lpdXCzxEPlW1kNkwc383lSVtfzPj
	 kRozSLriNmn7Mz3GXrcuaBONbXYjr7+FbxgZvSgr65XxJgjMZM7pPmQY7T5Y03g9OOCbk
	 z+pdS4qj7ziHC2NUEWyVJjXW97fP898EltRU/61FMqfQji3OR/S1whgSpr8/QuDM0PaEE
	 g6Usdq80ZDGU2IGn55h3/Jss8cNV8YuQTYUrjVQzMwRTr1rIJFocD2xTnVhz6n4DE7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3nwRZA3Eg69NuGtdhZ9GwwGjkLPd3yEL5UBDyQTwxQg=;
	b=w2NmSnsTlDg3flGNEnBY6enBnRn6f6FZbzyXt6axR01e5DL0Bpt0CzWzGpdsTwCADTrm
	 hJFGaVEMvxYV7F1QaLuct28ft0TMcMlyqvGrOquj/jAAAm+ChrLu1coCsWtdpEw9bobN7
	 2a+qdCr8tal0mImW2Dq8C0sbilpOdq6aeZnmDqVkAnxT/jc95/ZEp3/mFP6L2h/11h++Y
	 dKijUylC2QcdmI77cN8XsRDjWAjMM2xTCkTPH1BCTqyPPMmk8FIDHaDOGokH+7PSlLKli
	 MdVizqfgzq9CkYfru2k/7xvjdlAc+YEa8yQc4e1OMi+cIKxnKENCCyFXpe6l3kFGs7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ti9IcNFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23FC606A844;
	Wed,  4 Nov 2026 22:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ti9IcNFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C41F000C1;
	Wed,  4 Nov 2026 22:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831563;
	bh=3nwRZA3Eg69NuGtdhZ9GwwGjkLPd3yEL5UBDyQTwxQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ti9IcNFQexm3nU3Ax2CGf2wyK8pTJ9q+5I/1GHjBl2yvKrCy6ZTXlc0uTLQrOw3dD
	 +cFbqYnMsCusZM0fRbhAmCEPk3bTKKI7RDc8JDB0B6YuJ2Oum/y3C0fIjBhRAT41Vb
	 S3St8yqQ60F/GhhDtIyu2UnXCEjkigHIvGBTHAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0778/1005] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
Date: Wed,  4 Nov 2026 16:08:31 -0500
Message-ID: <20261104211105.163419388@linuxfoundation.org>
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

commit da483b8a9c2c3e7b23655699680feb57a194000c upstream.

LOLLM noticed that everywhere else in the kernel, a call to
xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
In particular, mount-time quotacheck does this, but online quotacheck
does not.

Looking at xfs_qm_adjust_dqlimits, that function is in charge of
conveying default limits to a dquot if that dquot's limits have been
zeroed.  That's quite possible in a repair, so we actually need to do
that.

However, there's a pre-existing pattern in the kernel -- for non-root
dquots, first we call xfs_qm_adjust_dqlimits to set the dquot's limits
to the defaults if they are zero, and then xfs_qm_adjust_dqtimers to
start grace periods if the dquot's usage is above the softlimit.  The
grace period decision cannot be made correctly if we forget to import
the default limits.

Therefore, let's combine both into a single xfs_qm_adjust_dqenforcement
helper that takes care of both pieces, which fixes quotacheck and makes
it hard to repeat this mistake.

Cc: stable@vger.kernel.org # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c      |    5 +----
 fs/xfs/scrub/quotacheck_repair.c |    3 +--
 fs/xfs/xfs_dquot.c               |   20 +++++++++++++++-----
 fs/xfs/xfs_dquot.h               |    2 +-
 fs/xfs/xfs_qm.c                  |    6 +-----
 fs/xfs/xfs_trans_dquot.c         |    6 +-----
 6 files changed, 20 insertions(+), 22 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -252,10 +252,7 @@ xrep_quota_item(
 
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_trans_dqjoin(sc->tp, dq);
-	if (dq->q_id) {
-		xfs_qm_adjust_dqlimits(dq);
-		xfs_qm_adjust_dqtimers(dq);
-	}
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(sc->tp, dq);
 	error = xfs_trans_roll(&sc->tp);
 	xfs_dqlock(dq);
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -112,8 +112,7 @@ xqcheck_commit_dquot(
 
 	/* Commit the dirty dquot to disk. */
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
-	if (dq->q_id)
-		xfs_qm_adjust_dqtimers(dq);
+	xfs_qm_adjust_dqenforcement(dq);
 	xfs_trans_log_dquot(xqc->sc->tp, dq);
 
 	/*
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -115,18 +115,15 @@ xfs_qm_dqdestroy(
  * We overwrite the dquot limits only if they are zero and this
  * is not the root dquot.
  */
-void
+static void
 xfs_qm_adjust_dqlimits(
 	struct xfs_dquot	*dq)
 {
 	struct xfs_mount	*mp = dq->q_mount;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_def_quota	*defq;
+	struct xfs_def_quota	*defq = xfs_get_defquota(q, xfs_dquot_type(dq));
 	int			prealloc = 0;
 
-	ASSERT(dq->q_id);
-	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
-
 	if (!dq->q_blk.softlimit) {
 		dq->q_blk.softlimit = defq->blk.soft;
 		prealloc = 1;
@@ -223,6 +220,19 @@ xfs_qm_adjust_dqtimers(
 	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_rtb, &defq->rtb);
 }
 
+/* Adjust enforcement limits and timers after a change in usage. */
+void
+xfs_qm_adjust_dqenforcement(
+	struct xfs_dquot	*dq)
+{
+	if (dq->q_id == 0)
+		return;
+
+	xfs_qm_adjust_dqlimits(dq);
+	xfs_qm_adjust_dqtimers(dq);
+	dq->q_flags |= XFS_DQFLAG_DIRTY;
+}
+
 /*
  * initialize a buffer full of dquots and log the whole thing
  */
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -220,7 +220,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
-void		xfs_qm_adjust_dqlimits(struct xfs_dquot *d);
+void		xfs_qm_adjust_dqenforcement(struct xfs_dquot *d);
 xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
 				xfs_dqtype_t type);
 int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1341,11 +1341,7 @@ xfs_qm_quotacheck_dqadjust(
 	 *
 	 * There are no timers for the default values set in the root dquot.
 	 */
-	if (dqp->q_id) {
-		xfs_qm_adjust_dqlimits(dqp);
-		xfs_qm_adjust_dqtimers(dqp);
-	}
-
+	xfs_qm_adjust_dqenforcement(dqp);
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 out_unlock:
 	xfs_qm_dqput(dqp);
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -566,11 +566,7 @@ xfs_trans_apply_dquot_deltas(
 			 * Get any default limits in use.
 			 * Start/reset the timer(s) if needed.
 			 */
-			if (dqp->q_id) {
-				xfs_qm_adjust_dqlimits(dqp);
-				xfs_qm_adjust_dqtimers(dqp);
-			}
-
+			xfs_qm_adjust_dqenforcement(dqp);
 			dqp->q_flags |= XFS_DQFLAG_DIRTY;
 			/*
 			 * add this to the list of items to get logged


