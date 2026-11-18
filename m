Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053054;
	b=Sjuv/X8jigUGquaEFGQci9J/gL8PVfEb0n5dT+/+Ek735kUSslCA8A3SpBYo3DacrKUk
	 DNELKD7oDBDg3W+2MZV1TcI9QyM3XBk6T+iJ7R5or3ZLrQ2lpP+6yNEug8RUzpz7hVVsp
	 yENO11ZtUS50x7B2vl5/r/4Dg6vSeYqvYPT+2E8w/lP0jkusdEjtG5J8nUiTuWx0oAcyb
	 9CcuqzQgqRkv3FCu/o8xuzgGpg2Hn+/fJfikLOCTJeO+HsuBJCrgPsEK8IaJ9ysrrunRL
	 0T5yIehjcHtHhUw+rjSljGaI5JORsExeNGx7qku29kqa18eullwKIgLyq5Pjpy3fCcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqRQs4swsbt4nWEuvFtSP1x5uphoMibcE2e50ANAwRs=;
	b=VrICjgyMX91LA9x5Us0Q+v20azXabVt391GL5NRv53LqJYTC4xJ74PHj4zNi3pBzwnWz
	 4GNEHVaWYhQkcsXS7nPBodMFWfW7gh5xi9azjgBW+IOt7NrhaFlkx5Yp1SyFU80YPBgun
	 PQHyq6jAJGmXwwy5hXsw+1tHdax++0nb9tj35UEVlRCKrTcRVUMxRronl6cRdb37kxfre
	 QMFtKR8Mt4qwLzrOn12r7u/gS0I/kcaA2ErNgiHkVYQRkjGcQl6kcQPtDuXSIa9OXele6
	 39bCJCCPwFT7kYHFwOwnXbSfiFyouHSFGrYSurZdm5OzedlDKIc0JcwVHFINJIYResA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIRIQbCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA1F606A31C;
	Thu, 19 Nov 2026 01:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIRIQbCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8051F000C4;
	Thu, 19 Nov 2026 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053054;
	bh=MqRQs4swsbt4nWEuvFtSP1x5uphoMibcE2e50ANAwRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIRIQbCkiWaibu+p8dznkEkUPvsJN0/NwWYQLY4EAy4d1en+Ht56AZ4sgH4TLxz7c
	 MAl2Md5OAOXBTnSRHT5H0addMv+jy8Pq/eSq5+8g+tGb1iF5vkPyEAuT0WpMR1Nq6Z
	 Y4O7KBAZs019gwroNtuo2krTgdZol9zvG+WqsN5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Potharaju <arun.potharaju@hammerspace.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0781/2214] NFSv4/flexfiles: fail I/O to the data server once a lock is lost
Date: Wed, 18 Nov 2026 15:40:57 +0100
Message-ID: <20261118150042.865643315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@hammerspace.com>

[ Upstream commit 7fa2ad367abe6d3155daefb57331e7fce1a17afd ]

When a client loses a byte-range lock, because its lease expired and it
may not recover the lock (nfs.recover_lost_locks=0) or because reclaim
failed, it marks the lock state NFS_LOCK_LOST and fails further I/O by
that lock owner.  Otherwise an application that believes it holds a
lock over a range is never told that the lock is gone, and can
overwrite data that another client has since written under its own
lock on that range.

The NFSv4 READ/WRITE and file layout I/O paths apply this in
rpc_call_prepare, where nfs4_set_rw_stateid() returns -EIO for a lost
lock.  The flexfiles data server I/O path does not: the NFSv3 data
server path never checked, and the check on the NFSv4 path was removed
when the data server stateid began to be taken from the layout.

Fail read and write RPCs to the data server in rpc_call_prepare when the
lock is lost.  The data server path has no use for the stateid that
nfs4_set_rw_stateid() selects, and selecting it looks up a delegation
or open stateid on every I/O.
Instead add nfs4_lock_context_lost(), which only tests NFS_LOCK_LOST,
and check it alongside the open state.  Its lookup,
__nfs4_lookup_lock_state(), is split out of __nfs4_find_lock_state()
and takes no reference: a lock state is only unlinked from
state->lock_states under state->state_lock, so one found while holding
that lock cannot be freed before it is released.  Use it in
nfs4_copy_lock_stateid() as well, which only reads the lock state under
that lock.  That drops a reference get and put from stateid selection
for all NFSv4 I/O without changing the stateid selected.

Terminating the RPC in rpc_call_prepare is not enough on its own.  The
done callback reads the -EIO as a data server connection error, forgets
the device ID, and resets the I/O to pNFS (or, for an NFSv4 data
server, possibly to the MDS).  After a reset to pNFS a new LAYOUTGET is
granted and rpc_call_prepare fails the I/O again, without end.  The
existing NFS_CONTEXT_BAD check does not loop, since the open state is
then invalid and pnfs_update_layout() fails the reset I/O, but it still
forgets the device ID.

So when an RPC that was never sent fails and the open context is bad,
the open state is invalid, or the lock is lost, complete it with -EIO
without error handling.  An RPC that was sent and failed is handled as
before, so a real data server error is still reported to the MDS.

Fixes: d67ae825a59d ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Fixes: bb21ce0ad227 ("flexfiles: use per-mirror specified stateid for IO")
Cc: stable@vger.kernel.org
Tested-by: Arun Potharaju <arun.potharaju@hammerspace.com>
Assisted-by: LLM
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
[ sashal: adapted lock-state lookup changes to existing fl_owner and fl_owner2 variable names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 25 +++++++++++++++--
 fs/nfs/nfs4_fs.h                       |  2 ++
 fs/nfs/nfs4state.c                     | 38 +++++++++++++++++++++++---
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index ac75372b5bf1d..ddf1c52b56595 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1374,12 +1374,27 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 	dprintk("%s: err %d op %d status %u\n", __func__, err, opnum, status);
 }
 
+static bool ff_layout_io_state_lost(const struct nfs_pgio_header *hdr)
+{
+	struct nfs_open_context *ctx = hdr->args.context;
+
+	return test_bit(NFS_CONTEXT_BAD, &ctx->flags) ||
+	       !nfs4_valid_open_stateid(ctx->state) ||
+	       nfs4_lock_context_lost(ctx->state, hdr->args.lock_context);
+}
+
 /* NFS_PROTO call done callback routines */
 static int ff_layout_read_done_cb(struct rpc_task *task,
 				struct nfs_pgio_header *hdr)
 {
 	int err;
 
+	if (task->tk_status < 0 && !RPC_WAS_SENT(task) &&
+	    ff_layout_io_state_lost(hdr)) {
+		task->tk_status = -EIO;
+		return 0;
+	}
+
 	if (task->tk_status < 0) {
 		ff_layout_io_track_ds_error(hdr->lseg, hdr->pgio_mirror_idx,
 					    hdr->args.offset, hdr->args.count,
@@ -1467,7 +1482,7 @@ static void ff_layout_read_record_layoutstats_done(struct rpc_task *task,
 static int ff_layout_read_prepare_common(struct rpc_task *task,
 					 struct nfs_pgio_header *hdr)
 {
-	if (unlikely(test_bit(NFS_CONTEXT_BAD, &hdr->args.context->flags))) {
+	if (unlikely(ff_layout_io_state_lost(hdr))) {
 		rpc_exit(task, -EIO);
 		return -EIO;
 	}
@@ -1548,6 +1563,12 @@ static int ff_layout_write_done_cb(struct rpc_task *task,
 	loff_t end_offs = 0;
 	int err;
 
+	if (task->tk_status < 0 && !RPC_WAS_SENT(task) &&
+	    ff_layout_io_state_lost(hdr)) {
+		task->tk_status = -EIO;
+		return 0;
+	}
+
 	if (task->tk_status < 0) {
 		ff_layout_io_track_ds_error(hdr->lseg, hdr->pgio_mirror_idx,
 					    hdr->args.offset, hdr->args.count,
@@ -1651,7 +1672,7 @@ static void ff_layout_write_record_layoutstats_done(struct rpc_task *task,
 static int ff_layout_write_prepare_common(struct rpc_task *task,
 					  struct nfs_pgio_header *hdr)
 {
-	if (unlikely(test_bit(NFS_CONTEXT_BAD, &hdr->args.context->flags))) {
+	if (unlikely(ff_layout_io_state_lost(hdr))) {
 		rpc_exit(task, -EIO);
 		return -EIO;
 	}
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 0a1e1c64b131a..89aab66d835ea 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -518,6 +518,8 @@ extern int nfs4_select_rw_stateid(struct nfs4_state *, fmode_t,
 		const struct cred **);
 extern bool nfs4_copy_open_stateid(nfs4_stateid *dst,
 		struct nfs4_state *state);
+extern bool nfs4_lock_context_lost(struct nfs4_state *state,
+		const struct nfs_lock_context *l_ctx);
 
 extern struct nfs_seqid *nfs_alloc_seqid(struct nfs_seqid_counter *counter, gfp_t gfp_mask);
 extern int nfs_wait_on_sequence(struct nfs_seqid *seqid, struct rpc_task *task);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index d070378c47387..c2a80f2cc5664 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -845,10 +845,13 @@ void nfs4_close_sync(struct nfs4_state *state, fmode_t fmode)
  * be made.  Failing that, a "consistent" choice is preferable.  The
  * consistent choice we make is to prefer the first owner, that of a
  * Posix lock.
+ *
+ * Called with state->state_lock held.  No reference is taken: a lock
+ * state is freed only after it is unlinked under state->state_lock.
  */
 static struct nfs4_lock_state *
-__nfs4_find_lock_state(struct nfs4_state *state,
-		       fl_owner_t fl_owner, fl_owner_t fl_owner2)
+__nfs4_lookup_lock_state(struct nfs4_state *state,
+			 fl_owner_t fl_owner, fl_owner_t fl_owner2)
 {
 	struct nfs4_lock_state *pos, *ret = NULL;
 	list_for_each_entry(pos, &state->lock_states, ls_locks) {
@@ -859,6 +862,16 @@ __nfs4_find_lock_state(struct nfs4_state *state,
 		if (pos->ls_owner == fl_owner2)
 			ret = pos;
 	}
+	return ret;
+}
+
+static struct nfs4_lock_state *
+__nfs4_find_lock_state(struct nfs4_state *state,
+		       fl_owner_t owner, fl_owner_t owner2)
+{
+	struct nfs4_lock_state *ret;
+
+	ret = __nfs4_lookup_lock_state(state, owner, owner2);
 	if (ret)
 		refcount_inc(&ret->ls_count);
 	return ret;
@@ -1007,7 +1020,7 @@ static int nfs4_copy_lock_stateid(nfs4_stateid *dst,
 	fl_flock_owner = l_ctx->open_context->flock_owner;
 
 	spin_lock(&state->state_lock);
-	lsp = __nfs4_find_lock_state(state, fl_owner, fl_flock_owner);
+	lsp = __nfs4_lookup_lock_state(state, fl_owner, fl_flock_owner);
 	if (lsp && test_bit(NFS_LOCK_LOST, &lsp->ls_flags))
 		ret = -EIO;
 	else if (lsp != NULL && test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) != 0) {
@@ -1015,11 +1028,28 @@ static int nfs4_copy_lock_stateid(nfs4_stateid *dst,
 		ret = 0;
 	}
 	spin_unlock(&state->state_lock);
-	nfs4_put_lock_state(lsp);
 out:
 	return ret;
 }
 
+bool nfs4_lock_context_lost(struct nfs4_state *state,
+			    const struct nfs_lock_context *l_ctx)
+{
+	struct nfs4_lock_state *lsp;
+	bool ret;
+
+	if (!test_bit(LK_STATE_IN_USE, &state->flags))
+		return false;
+
+	spin_lock(&state->state_lock);
+	lsp = __nfs4_lookup_lock_state(state, l_ctx->lockowner,
+				       l_ctx->open_context->flock_owner);
+	ret = lsp && test_bit(NFS_LOCK_LOST, &lsp->ls_flags);
+	spin_unlock(&state->state_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nfs4_lock_context_lost);
+
 bool nfs4_copy_open_stateid(nfs4_stateid *dst, struct nfs4_state *state)
 {
 	bool ret;
-- 
2.53.0



