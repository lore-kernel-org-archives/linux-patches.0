Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209267;
	b=dZEZmA8xVfKghIpHXEA+M/+OCYbvSnAdBzx/v4bLbQVl6CwUPc2R/WMTatxgBYVgEMeD
	 cb+3yQwZCWddcV4e8NBUToIShJYX7d2qjTYjc4bHP2cUleKHgRn3piQtg6LzsPPkHPRz+
	 DVHeyvYDDQ0XP6DV1h+RRdP3s29jMMJR884WwyJH27KY6LHXHxwSY/b+h+bR2R8Uyxca2
	 J9SHi+t8glMbkrFuPsCdLvavS/HfUwWlHqiMRLueUdE5e1BriJjGi/qsto5hRSMKaLrTN
	 AQBCEn5s0p26c+ildhRCidZg9f8ReJmsVIGe2GTWi9Z5WeR5j/rwDDObMZvRp3/Jh0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7GC+WJlaUn4e/5vpqD9SHHZQtrS9jQzse8FIXoEFDi4=;
	b=HdnGKnVMlwHDfNIiOaJl2pY+DeAYmgeJdNY3CKe2q5Jj/DRrD5mqpSMhQLErWIUuQevI
	 e3HoqFT72lFtZUJIOnDVdNV8lIfNJmg3vdTUTKYYuw5h5eWV7g2l5hL9n5JAz/GEGo1JB
	 4223xO8XZuGEACCplGnYQKvinyHhcWlB4VA9Pn7ifCWeS5BpCDD7kk8j3C7FNE2wV+OXC
	 eFfA2vY/d9klRPFwjoSOJg/YvDPG4BEfUL/Cbjh0q6gpMmaGoAwTsshLXbEwn4acpapci
	 gzzfjy4bcaj1RcMXUi9I9kPtNpzXkKeod5S8nfXjAR+xC4w4V2K+sz+5U2S0+2z2bKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7MOhQ9B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA0606A31C;
	Wed, 28 Oct 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7MOhQ9B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC561F01825;
	Wed, 28 Oct 2026 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209267;
	bh=7GC+WJlaUn4e/5vpqD9SHHZQtrS9jQzse8FIXoEFDi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7MOhQ9Burq00XK5Aw76Lw+edKRYucbuG1tB7RdKxH52NFxSPjMdLuu74OmQaa631
	 mpTGoQERvAG3p+PhBvDtmy2Hxj01biFGkMlDmbM8KLvkppg0FJ1RsGMg8HeZVbhrmR
	 Gwh7guwfxUfHv/kxiXWDwtPSZS1yF3c8MCdRLwGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/516] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
Date: Wed, 28 Oct 2026 17:59:22 +0100
Message-ID: <20261028170013.196897107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 2039a272300b949c05888428877317b834c0b1fb ]

Make it less shouty and a static inline before adding more calls
through the log code.

Also convert internal log code that uses XFS_FORCED_SHUTDOWN(mount)
to use xlog_is_shutdown(log) as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflicts due to the following missing commits:
	956f6daa84bf ("xfs: add iclog state trace events")
	303591a0a947 ("xfs: cover the log during log quiesce")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c         | 30 +++++++++++++++---------------
 fs/xfs/xfs_log_cil.c     | 10 +++++-----
 fs/xfs/xfs_log_priv.h    |  7 +++++--
 fs/xfs/xfs_log_recover.c |  9 +++------
 fs/xfs/xfs_trans.c       |  2 +-
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b83b2b7786bc..bb57a125eae5e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -244,7 +244,7 @@ xlog_grant_head_wait(
 	list_add_tail(&tic->t_queue, &head->waiters);
 
 	do {
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
@@ -258,7 +258,7 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
 
@@ -361,7 +361,7 @@ xfs_log_writable(
 		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(mp->m_log))
 		return false;
 	return true;
 }
@@ -378,7 +378,7 @@ xfs_log_regrant(
 	int			need_bytes;
 	int			error = 0;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -446,7 +446,7 @@ xfs_log_reserve(
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -794,7 +794,7 @@ xlog_wait_on_iclog(
 {
 	struct xlog		*log = iclog->ic_log;
 
-	if (!XLOG_FORCED_SHUTDOWN(log) &&
+	if (!xlog_is_shutdown(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
 	    iclog->ic_state != XLOG_STATE_DIRTY) {
 		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
@@ -803,7 +803,7 @@ xlog_wait_on_iclog(
 		spin_unlock(&log->l_icloglock);
 	}
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 	return 0;
 }
@@ -913,7 +913,7 @@ xfs_log_unmount_write(
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -1013,7 +1013,7 @@ xfs_log_space_wake(
 	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
@@ -1479,7 +1479,7 @@ xlog_commit_record(
 	};
 	int	error;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
@@ -1561,7 +1561,7 @@ xlog_grant_push_ail(
 	xfs_lsn_t	threshold_lsn;
 
 	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
-	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -2779,7 +2779,7 @@ xlog_state_do_callback(
 			cycled_icloglock = true;
 
 			spin_lock(&log->l_icloglock);
-			if (XLOG_FORCED_SHUTDOWN(log))
+			if (xlog_is_shutdown(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
 				xlog_state_clean_iclog(log, iclog);
@@ -2830,7 +2830,7 @@ xlog_state_done_syncing(
 	 * split log writes, on the second, we shut down the file system and
 	 * no iclogs should ever be attempted to be written to disk again.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log)) {
+	if (!xlog_is_shutdown(log)) {
 		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
 	}
@@ -2878,7 +2878,7 @@ xlog_state_get_iclog_space(
 
 restart:
 	spin_lock(&log->l_icloglock);
-	if (XLOG_FORCED_SHUTDOWN(log)) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		return -EIO;
 	}
@@ -3720,7 +3720,7 @@ xfs_log_force_umount(
 	 * No need to get locks for this.
 	 */
 	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(XLOG_FORCED_SHUTDOWN(log));
+		ASSERT(xlog_is_shutdown(log));
 		return 1;
 	}
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fbe160d5e9b96..407e80d06bec7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -576,7 +576,7 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
-	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
+	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
 
 	/*
 	 * If the I/O failed, we're aborting the commit and already shutdown.
@@ -827,7 +827,7 @@ xlog_cil_push_work(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log)) {
+		if (xlog_is_shutdown(log)) {
 			spin_unlock(&cil->xc_push_lock);
 			goto out_abort_free_ticket;
 		}
@@ -888,7 +888,7 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, tic);
 out_abort:
-	ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	ASSERT(xlog_is_shutdown(log));
 	xlog_cil_committed(ctx);
 }
 
@@ -1041,7 +1041,7 @@ xlog_cil_commit(
 
 	xlog_cil_insert_items(log, tp);
 
-	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
+	if (regrant && !xlog_is_shutdown(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
@@ -1114,7 +1114,7 @@ xlog_cil_force_seq(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto out_shutdown;
 		if (ctx->sequence > sequence)
 			continue;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 42cd1602ac256..6e619b34c6bb5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -441,8 +441,11 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
-#define XLOG_FORCED_SHUTDOWN(log) \
-	(unlikely((log)->l_flags & XLOG_IO_ERROR))
+static inline bool
+xlog_is_shutdown(struct xlog *log)
+{
+	return (log->l_flags & XLOG_IO_ERROR);
+}
 
 /* common routines */
 extern int
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 527facd5126b2..46b1213e8ff32 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -145,7 +145,7 @@ xlog_do_io(
 
 	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
 			BBTOB(nbblks), data, op);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
+	if (error && !xlog_is_shutdown(log)) {
 		xfs_alert(log->l_mp,
 			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
 			  op == REQ_OP_WRITE ? "write" : "read",
@@ -3288,10 +3288,7 @@ xlog_do_recover(
 	if (error)
 		return error;
 
-	/*
-	 * If IO errors happened during recovery, bail out.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	/*
@@ -3313,7 +3310,7 @@ xlog_do_recover(
 	xfs_buf_hold(bp);
 	error = _xfs_buf_read(bp, XBF_READ);
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xlog_is_shutdown(log)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 73a1de7ceefc9..d334bb3ce643d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -901,7 +901,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
+		if (regrant && !xlog_is_shutdown(mp->m_log))
 			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
 		else
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-- 
2.53.0



