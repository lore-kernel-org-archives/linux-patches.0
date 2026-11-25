Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619099;
	b=v0s26dOmjdBW66PTSZN7LW7LJc65uoyeF+vU7ArJDpjkx57X+E2QM8ci3u2Gc8e2212n
	 8YQ6lLXhGcl6U45+S2j9HYqkf6WLqFIXSjJJxbHVkzuLCu6RtMaYXi8sJIvVN7JgET7Su
	 0Bt9G+M15RtWSkhiUuRytHEF1oe+uyidDAHjSV13/Q/7i9Egm3To0TgKIZj7XoA7pqumk
	 qNaDB/gml2ij+S3eUd25rg9GiOfbxAtNQO0QUyd6fUUs37vIobI8Q2doUkn90TFUg3Q44
	 eK1lPgFFSGokxAG76CawAX1+KEQ97aQdnI9nSXQnDnJCgv7HtCXgqzjF9JJ7bHD0JBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6Oz7BrPiR1Cq0uJQjlC12NvSdHIFrbhDRe6VPtsqP0=;
	b=SYldxJwMxSAJFHO15WfwOuLNtP3gzmeQH4JgsObgurHkMUhSB9hbMFXUCXYZ4zIaupF9
	 I8zP+NqhjwGGnmbWk2SGLEIrKHXD19RALZeilcyRQXonNLabW7Vs4RFU0i8xbfmpQizEG
	 kiu4I3ooCmDkGoPolF3QnvMPi6kxXAGP3F+sxOd6OVemIAJefPZAsNHDHs93q252r4cqj
	 m+w9wZlwl3iBiTqldNSvX/TVrROo4nQP8KTCaAoaeTgcxPN9ylXtDWXFfsvOBsnoKDvj4
	 vmI2s/roqkMt1t3nk4JEl0aLBcE9I2jhSZSFJ4vVh/6nuNY3uUN1+bWT9OavcLscnLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuZWYtIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30E606A323;
	Wed, 25 Nov 2026 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuZWYtIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796841F000C0;
	Wed, 25 Nov 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619099;
	bh=v6Oz7BrPiR1Cq0uJQjlC12NvSdHIFrbhDRe6VPtsqP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuZWYtICLnv3fOJwYm+eLc/PX/pvykeQOejTgrKweYeUzLUlBKASYPP0KVXtTynEy
	 ZOJCUT01dXx8SBhR3duPrkAQV0cn9mu6ZVatreKOuLWCGemxL254xx5ENkX8XQbwur
	 AdHtvZrUFnbOK/HGznF6bTvBz6sQCeO+2Xh28Pm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0488/1005] NFSv4/flexfiles: Make the pinned device node pointer RCU-managed
Date: Wed, 25 Nov 2026 15:30:26 +0100
Message-ID: <20261125143833.178675859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

[ Upstream commit b14c22e01c5c4f8dfe9c7165c801796e1ec6ebae ]

Annotate mirror->dss[dss_id].mirror_ds as __rcu and convert the
remaining readers, completing the preparation for re-pointing the pinned
node while I/O is in flight:

 - ff_layout_get_mirror_ds() takes its reference under rcu_read_lock()
   with atomic_inc_not_zero(), retrying if it races a reset.  The
   resolve path takes the caller's reference before publishing the node
   with cmpxchg(), so a concurrent reset cannot drop the last reference
   under the caller: one reference is held for the installed pointer and
   one for the caller, and the pointer's reference is released elsewhere
   by xchg + put.
 - The availability scans hold rcu_read_lock() across the walk; they
   only test flags on the RCU-freed node.
 - ff_layout_cancel_io() holds a reference across the cancel and
   disconnect calls.  Both of its callers hold i_lock and nothing on
   that path sleeps, so the reference is not about blocking: it is
   what keeps the node alive between the RCU-protected read and the
   use of mirror_ds->ds.  The final put is never reached here, because
   the mirror's own pin outlives the loop -- which matters, since that
   put ends in nfs_put_client() and cannot run under a spinlock.
 - ff_layout_mirror_prepare_stats() reads the pointer with
   rcu_dereference() under rcu_read_lock().  i_lock, which both callers
   hold, is what excludes the re-pointing walk added later in this
   series; it does not exclude the resolve path's cmpxchg(), which runs
   from I/O submission, so the read cannot claim i_lock as its update-
   side lock.  A non-NULL pointer read there is stable regardless: the
   resolve path only ever installs over NULL.
 - ff_layout_free_mirror() tears down the last reference; no concurrency.

The pointer is still only ever set once per mirror lifetime, so there is
no behavior change; this commit makes the subsequent in-place re-resolve
on CB_NOTIFY_DEVICEID CHANGE safe to introduce.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Stable-dep-of: 788c4f628565 ("NFSv4/flexfiles: limit transport disconnects when cancelling I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c    |  35 ++++---
 fs/nfs/flexfilelayout/flexfilelayout.h    |   2 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c | 110 ++++++++++++++--------
 3 files changed, 93 insertions(+), 54 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 7105790c9ef5e..1bc6559ab660f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -313,7 +313,9 @@ static void ff_layout_free_mirror(struct nfs4_ff_layout_mirror *mirror)
 		cred = rcu_access_pointer(mirror->dss[dss_id].rw_cred);
 		put_cred(cred);
 		nfs_close_local_fh(&mirror->dss[dss_id].nfl);
-		nfs4_ff_layout_put_deviceid(mirror->dss[dss_id].mirror_ds);
+		/* the last reference to the mirror is gone; no concurrency */
+		nfs4_ff_layout_put_deviceid(rcu_dereference_protected(
+				mirror->dss[dss_id].mirror_ds, 1));
 	}
 
 	kfree(mirror->dss);
@@ -2578,22 +2580,29 @@ static void ff_layout_cancel_io(struct pnfs_layout_segment *lseg)
 	for (idx = 0; idx < flseg->mirror_array_cnt; idx++) {
 		mirror = flseg->mirror_array[idx];
 		for (dss_id = 0; dss_id < mirror->dss_count; dss_id++) {
-			mirror_ds = mirror->dss[dss_id].mirror_ds;
-			if (IS_ERR_OR_NULL(mirror_ds))
+			rcu_read_lock();
+			mirror_ds = rcu_dereference(mirror->dss[dss_id].mirror_ds);
+			if (IS_ERR_OR_NULL(mirror_ds) ||
+			    !atomic_inc_not_zero(&mirror_ds->id_node.ref)) {
+				rcu_read_unlock();
 				continue;
-			ds = mirror->dss[dss_id].mirror_ds->ds;
+			}
+			rcu_read_unlock();
+			ds = mirror_ds->ds;
 			if (!ds)
-				continue;
+				goto next;
 			ds_clp = ds->ds_clp;
 			if (!ds_clp)
-				continue;
+				goto next;
 			clnt = ds_clp->cl_rpcclient;
 			if (!clnt)
-				continue;
+				goto next;
 			if (!rpc_cancel_tasks(clnt, -ECANCELED,
 					      ff_layout_match_io, lseg))
-				continue;
+				goto next;
 			rpc_clnt_disconnect(clnt);
+next:
+			nfs4_ff_layout_put_deviceid(mirror_ds);
 		}
 	}
 }
@@ -3055,12 +3064,13 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 	struct nfs4_ff_layout_ds *mirror_ds;
 	int i = 0, dss_id;
 
+	rcu_read_lock();
 	list_for_each_entry(mirror, &ff_layout->mirrors, mirrors) {
 		for (dss_id = 0; dss_id < mirror->dss_count; ++dss_id) {
 			dss_info = &mirror->dss[dss_id];
 			if (i >= dev_limit)
 				break;
-			mirror_ds = dss_info->mirror_ds;
+			mirror_ds = rcu_dereference(dss_info->mirror_ds);
 			if (IS_ERR_OR_NULL(mirror_ds))
 				continue;
 			if (!test_and_clear_bit(NFS4_FF_MIRROR_STAT_AVAIL,
@@ -3070,10 +3080,8 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			/* mirror refcount put in cleanup_layoutstats */
 			if (!refcount_inc_not_zero(&mirror->ref))
 				continue;
-			/*
-			 * The mirror's pin holds the node while we're under
-			 * i_lock; take a reference for the encode, put in
-			 * ff_layout_free_layoutstats().
+			/* The pin holds a reference; it is exchanged out only
+			 * under i_lock.  Put in ff_layout_free_layoutstats().
 			 */
 			atomic_inc(&mirror_ds->id_node.ref);
 			memcpy(&devinfo->dev_id,
@@ -3102,6 +3110,7 @@ ff_layout_mirror_prepare_stats(struct pnfs_layout_hdr *lo,
 			i++;
 		}
 	}
+	rcu_read_unlock();
 	return i;
 }
 
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.h b/fs/nfs/flexfilelayout/flexfilelayout.h
index 31f3c1a20d401..24de108af2cf8 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -79,7 +79,7 @@ struct nfs4_ff_layout_ds_stripe {
 	struct nfs4_ff_layout_mirror   *mirror;
 	struct nfs4_deviceid		devid;
 	u32				efficiency;
-	struct nfs4_ff_layout_ds	*mirror_ds;
+	struct nfs4_ff_layout_ds __rcu	*mirror_ds;
 	u32				fh_versions_cnt;
 	struct nfs_fh			*fh_versions;
 	nfs4_stateid			stateid;
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 3712a47b20d08..3cef6a4a51a70 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -321,35 +321,54 @@ ff_layout_get_mirror_ds(struct pnfs_layout_hdr *lo,
 			struct nfs4_ff_layout_mirror *mirror,
 			u32 dss_id)
 {
-	struct nfs4_ff_layout_ds *mirror_ds;
+	struct nfs4_ff_layout_ds *mirror_ds, *old;
+	struct nfs4_deviceid_node *node;
 
 	if (mirror == NULL)
 		return ERR_PTR(-ENODEV);
 
-	mirror_ds = mirror->dss[dss_id].mirror_ds;
-	if (mirror_ds == NULL) {
-		struct nfs4_deviceid_node *node;
-
+retry:
+	rcu_read_lock();
+	mirror_ds = rcu_dereference(mirror->dss[dss_id].mirror_ds);
+	if (mirror_ds && !IS_ERR(mirror_ds) &&
+	    atomic_inc_not_zero(&mirror_ds->id_node.ref)) {
+		rcu_read_unlock();
+		return mirror_ds;
+	}
+	rcu_read_unlock();
+	if (IS_ERR(mirror_ds))
+		return mirror_ds;
+	if (mirror_ds != NULL)
+		/* raced with a reset; the field is being re-pointed */
+		goto retry;
+
+	node = nfs4_find_get_deviceid(NFS_SERVER(lo->plh_inode),
+			&mirror->dss[dss_id].devid, lo->plh_lc_cred,
+			GFP_KERNEL);
+	if (node) {
+		mirror_ds = FF_LAYOUT_MIRROR_DS(node);
+		/*
+		 * Take the caller's reference before the pointer becomes
+		 * visible below, so a concurrent reset of the installed
+		 * pointer cannot drop the last reference under us.
+		 */
+		atomic_inc(&node->ref);
+	} else {
 		mirror_ds = ERR_PTR(-ENODEV);
-		node = nfs4_find_get_deviceid(NFS_SERVER(lo->plh_inode),
-				&mirror->dss[dss_id].devid, lo->plh_lc_cred,
-				GFP_KERNEL);
-		if (node)
-			mirror_ds = FF_LAYOUT_MIRROR_DS(node);
-
-		/* check for race with another call to this function */
-		if (cmpxchg(&mirror->dss[dss_id].mirror_ds, NULL, mirror_ds) &&
-		    mirror_ds != ERR_PTR(-ENODEV))
-			nfs4_put_deviceid_node(node);
-
-		mirror_ds = mirror->dss[dss_id].mirror_ds;
 	}
 
-	if (IS_ERR(mirror_ds))
+	/* check for race with another call to this function */
+	old = unrcu_pointer(cmpxchg(&mirror->dss[dss_id].mirror_ds,
+				    NULL, RCU_INITIALIZER(mirror_ds)));
+	if (old == NULL)
 		return mirror_ds;
-	if (!atomic_inc_not_zero(&mirror_ds->id_node.ref))
-		return ERR_PTR(-ENODEV);
-	return mirror_ds;
+
+	/* lost the race; use the winner's node instead */
+	if (node) {
+		nfs4_put_deviceid_node(node);
+		nfs4_put_deviceid_node(node);
+	}
+	goto retry;
 }
 
 /**
@@ -570,49 +589,60 @@ unsigned int ff_layout_fetch_ds_ioerr(struct pnfs_layout_hdr *lo,
 static bool ff_read_layout_has_available_ds(struct pnfs_layout_segment *lseg)
 {
 	struct nfs4_ff_layout_mirror *mirror;
-	struct nfs4_deviceid_node *devid;
+	struct nfs4_ff_layout_ds *mirror_ds;
+	bool ret = false;
 	u32 idx, dss_id;
 
+	rcu_read_lock();
 	for (idx = 0; idx < FF_LAYOUT_MIRROR_COUNT(lseg); idx++) {
 		mirror = FF_LAYOUT_COMP(lseg, idx);
 		if (!mirror)
 			continue;
 		for (dss_id = 0; dss_id < mirror->dss_count; dss_id++) {
-			if (!mirror->dss[dss_id].mirror_ds)
-				return true;
-			if (IS_ERR(mirror->dss[dss_id].mirror_ds))
+			mirror_ds = rcu_dereference(mirror->dss[dss_id].mirror_ds);
+			if (!mirror_ds) {
+				ret = true;
+				goto out;
+			}
+			if (IS_ERR(mirror_ds))
 				continue;
-			devid = &mirror->dss[dss_id].mirror_ds->id_node;
-			if (!nfs4_test_deviceid_unavailable(devid))
-				return true;
+			if (!nfs4_test_deviceid_unavailable(&mirror_ds->id_node)) {
+				ret = true;
+				goto out;
+			}
 		}
 	}
-
-	return false;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static bool ff_rw_layout_has_available_ds(struct pnfs_layout_segment *lseg)
 {
 	struct nfs4_ff_layout_mirror *mirror;
-	struct nfs4_deviceid_node *devid;
+	struct nfs4_ff_layout_ds *mirror_ds;
+	bool ret = false;
 	u32 idx, dss_id;
 
+	rcu_read_lock();
 	for (idx = 0; idx < FF_LAYOUT_MIRROR_COUNT(lseg); idx++) {
 		mirror = FF_LAYOUT_COMP(lseg, idx);
 		if (!mirror)
-			return false;
+			goto out;
 		for (dss_id = 0; dss_id < mirror->dss_count; dss_id++) {
-			if (IS_ERR(mirror->dss[dss_id].mirror_ds))
-				return false;
-			if (!mirror->dss[dss_id].mirror_ds)
+			mirror_ds = rcu_dereference(mirror->dss[dss_id].mirror_ds);
+			if (IS_ERR(mirror_ds))
+				goto out;
+			if (!mirror_ds)
 				continue;
-			devid = &mirror->dss[dss_id].mirror_ds->id_node;
-			if (nfs4_test_deviceid_unavailable(devid))
-				return false;
+			if (nfs4_test_deviceid_unavailable(&mirror_ds->id_node))
+				goto out;
 		}
 	}
-
-	return FF_LAYOUT_MIRROR_COUNT(lseg) != 0;
+	ret = FF_LAYOUT_MIRROR_COUNT(lseg) != 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 static bool ff_layout_has_available_ds(struct pnfs_layout_segment *lseg)
-- 
2.53.0



