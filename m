Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061625;
	b=yjhEl7ZTJ1D7KEgvYnb+HxWgVtKlc++8+vsFmPpnx5oOoie4gXKNshMdVMP2THPjRxWT
	 tnx3NEwnQbvbH+ox/+DrkdPWjWNlnmETjLF/8x99BQ5fO2YZjTYy+cLfedNJX64fr8nks
	 4to7mq5EwhvjFBBhsLvSjDqMnD3kSc7guQqt5TWv4GChqoDY++M/sYbDWTb0kq8O4mNR8
	 Q/w9aXoc2vaPxy6B+OMqtkMk6wrOB7gTHJlnN5wba4baw8qn1sl83+d6lHlcF6vGYlVwX
	 DXaeGmcI7wHuzTWeHK8ww8yE+kvM/VeGZ2Xe1YsPYRYLACrzwmOnr8iWng2065okF0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RGJ0FA+pj0/t3MR9X0Y0TnGX8S5KAIRtfaAJ5uYSLag=;
	b=BPcMTfzDK4BSvu860eeWhr8iwCa7PG/lOj7dLtzKHKVjzvE/aF0Hj+yQ1/l7pHZwsqjm
	 iQNhOnsTewK3QloRuCdALeW6Azq8r50ba9l/Yz5n3NKx66j9yZfZzWU4v7LSh7qrgL3Cs
	 yHadl7wn7JfvvlpVXR6dfXd5iSzk5Kh27oecFUsDqSrhd9fhl26MSUTSmhFGIXadyRd3U
	 LLRsgJjXLU6l7cTCB5cJxQbHZv0jjtSov3oqGIpd9/CJmwo3BMtQ+tgXAdnO++Dr/LyOm
	 Bx2tHMcSZ2k9BGb9Q7EZaC8Ir+KNI4mRF8Mrpqm2ftfEtKKQcKRJbGRIiks+fHVtNlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVkQC52F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F0F606A32D;
	Sat,  7 Nov 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVkQC52F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EE11F0089F;
	Sat,  7 Nov 2026 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061625;
	bh=RGJ0FA+pj0/t3MR9X0Y0TnGX8S5KAIRtfaAJ5uYSLag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVkQC52FKvAjQbwVp1bNJMc5j3qSwWhpzcMsBX8HCUSbtu/v77rnwHkBGmlTzvyyK
	 5Qqr6HAomx35+HC7HjoE90KRldpTt/Ww/19PGC/8FOs7CKcrQmQ+d5k9hbF/gxf22/
	 xr2Vo8vow0564uL/egxvcZpAC7bPGQivBYUkSReU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0691/1536] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
Date: Sat,  7 Nov 2026 08:45:07 -0500
Message-ID: <20261107135016.896629639@linuxfoundation.org>
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
@@ -219,6 +216,19 @@ xfs_qm_adjust_dqtimers(
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
@@ -207,7 +207,7 @@ void		xfs_qm_dqdestroy(struct xfs_dquot
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
@@ -1135,11 +1135,7 @@ xfs_qm_quotacheck_dqadjust(
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
@@ -562,11 +562,7 @@ xfs_trans_apply_dquot_deltas(
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


