Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035362;
	b=yY5REYr63Z+G0Z/ZxX+yOuPK622vvCnGE89G63m9RT3w8+XmTvuOBGPxob+WMLSbzd7g
	 GvtUJUl+60DC2BOotM+hFK+0HbSXFMhoByV+qdtXWitPrxSq/k2u4+NDAAExfPkzhsqsS
	 QveAaJnI/vLHQEj9vUiZoO0uLBcS3g3Y3DA8qDOe3+H3roZf6n6mMV4bhgEnsnyAJ23FD
	 bqZXrFBTcGJRYM4jd6BVAQ0JlcCZrrkyuZ6HPxwxJ3o0ALDHW9EwUAxkJVAsJ7CAbbKzM
	 dYbIIGOqjdnrAmC18+Gi6DUDBQTQHTK/URIweSgMzVIESsXuw8V/rKOe/17OGuT6J+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ovr2H8Ro+f80DWC3zj3W638i3TU4ulWrBJZXgK+vAmI=;
	b=oqjjwb+t1zlXApX759QXLUFi6bAGdCkhT39lynLaeNL4xNgj5A8T9eFHiuMogI1KXEE7
	 XoIFICyoyHQYGk/CHGSFV/4XvlXfCvbGtxpHVFBC7/Mliy2dL4kZ15xpAwL0BP7Bjz2c0
	 gGLiubUvwB2AKhMVxT0i1Yfs5H7OthvNlMU1EYZewnQ6bhAdf1ho/79WAiXD+V9s1PLvv
	 xUei30As9QtyOtuxLKOWjMsIbpeyDBCeiJIZJv2gBUg7blCS4Ylxr0u5Nr4V2CJ26vnlE
	 PTmjD3Wb/E23t7Qa2yluOsEHtu2dVv1UqLqk3jOfOrKL51CJtWiCZgOVPodKFWwGe+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h2M/M9o6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB806606A31C;
	Wed, 18 Nov 2026 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2M/M9o6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7EB1F000C4;
	Wed, 18 Nov 2026 20:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035362;
	bh=ovr2H8Ro+f80DWC3zj3W638i3TU4ulWrBJZXgK+vAmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2M/M9o6rlvFJ4hMfYck2henk3C7sxslTxaAOwJNkaeYXN12mMNZ8SnZX87J7u1Bn
	 z2eG99A43QqvHdk9sWEHgfm7hnQMNG6fCsR8bGGKDfm79dacG5wRz3nYoyRQl5Uv6L
	 qFUQnmj9T2v5FiOIBd8fBJZs9sPFjFt2CRg5xBvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.6 0676/3318] smb: client: dont resurrect an exiting tcon from cached dir workers
Date: Wed, 18 Nov 2026 15:21:38 +0100
Message-ID: <20261118150338.438538202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit d58e7b40908a8a57755811d5b37af1df3380278f upstream.

cfids_laundromat_worker() bumps tcon->tc_count for every expired open
cfid and queues cached_dir_offload_close() without checking whether the
tcon is already being torn down.  Racing with the final cifs_put_tcon(),
the tcon comes back from zero and gets torn down twice:

  T1                                  T2
  cifs_put_tcon()
   --tc_count == 0, TID_EXITING
   tconInfoFree()
    free_cached_dirs()
     cancel_delayed_work_sync()       cfids_laundromat_worker()
                                       ++tc_count == 1
                                       queue_work(serverclose_wq)
    kfree(tcon->origin_fullpath)
    kfree(tcon)
                                      cached_dir_offload_close()
                                       close_cached_dir()  [UAF]
                                       cifs_put_tcon()
                                        tconInfoFree()     [double free]

cached_dir_lease_break() also bumps tc_count without tc_lock, racing with
the laundromat's locked update.

Take the tcon reference through a helper that refuses once the tcon is
TID_EXITING or its refcount has dropped to zero.  Queued put_work and
close_work then always hold a tcon reference, so tconInfoFree() can't
run before they finish and free_cached_dirs() doesn't need to flush any
workqueue.  If the laundromat can't get a reference, put the cfid back on
the dying list for free_cached_dirs() to free; its handle goes away with
the tree connection.

The lease break path finds the tcon on ses->tcon_list under
cifs_tcp_ses_lock, so it can't see TID_EXITING, but it now takes tc_lock.

Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -614,6 +614,17 @@ void invalidate_all_cached_dirs(struct c
 	spin_unlock(&cfids->cfid_list_lock);
 }
 
+static bool cached_dir_get_tcon(struct cifs_tcon *tcon,
+				enum smb3_tcon_ref_trace trace)
+{
+	guard(spinlock)(&tcon->tc_lock);
+	if (tcon->status == TID_EXITING || tcon->tc_count <= 0)
+		return false;
+	++tcon->tc_count;
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count, trace);
+	return true;
+}
+
 static void
 cached_dir_offload_close(struct work_struct *work)
 {
@@ -663,6 +674,9 @@ int cached_dir_lease_break(struct cifs_t
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			if (!cached_dir_get_tcon(tcon,
+						 netfs_trace_tcon_ref_get_cached_lease_break))
+				break;
 			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
@@ -673,9 +687,6 @@ int cached_dir_lease_break(struct cifs_t
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			++tcon->tc_count;
-			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_lease_break);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
@@ -789,12 +800,13 @@ static void cfids_laundromat_worker(stru
 
 		dput(dentry);
 		if (cfid->is_open) {
-			spin_lock(&cfid->tcon->tc_lock);
-			++cfid->tcon->tc_count;
-			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cfid->tcon->tc_lock);
-			queue_work(serverclose_wq, &cfid->close_work);
+			if (cached_dir_get_tcon(cfid->tcon,
+						netfs_trace_tcon_ref_get_cached_laundromat)) {
+				queue_work(serverclose_wq, &cfid->close_work);
+				continue;
+			}
+			scoped_guard(spinlock, &cfids->cfid_list_lock)
+				list_add_tail(&cfid->entry, &cfids->dying);
 		} else
 			/*
 			 * Drop the ref-count from above, either the lease-ref (if there


