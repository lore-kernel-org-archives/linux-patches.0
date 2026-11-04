Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831710;
	b=bRKIwzXh3NJXTQhoy6sqLltZDFe0/vpc/uIcCcdUgav5RGseVik8lzw4QDfESiTGjINA
	 PoKEy0htMDKjbpbm1Jkcw7ZdwZGLMLdAq+nh1Y+UAvdNpA0q1Aq5tewZCOGyzWSeCa6UL
	 ta+Muo+aG+ZdMZTO0oRf0Gh4oyXImVdkr5S6CrsSaptjrYn+EZenzO85LzZbZPg2Ur0Yg
	 6BXQFJ8mtRtbuwMEKTpA8JmbLPtYHHKvBcqtnx9enTKMNcc9WKeWu0i74xVEfLPhwTDjo
	 VMPd2H10CUMyHyPNGfPfTrTFXUTwnd8ScUadtkAAJk47LCGP+9gkBK0pdrXPfKTkypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fCEGZ7LXLoJPmf2HeHLs7wcYAEWiazgpvCuBhcpTCVo=;
	b=Vk4A1MUXoPKtIYSobClF2dH/rVLFi/bUtVAQi68/U3DY3GlIGYwlYeIZ1v9eh0EwzDhp
	 J6y0zAfvUo3LSNvWde2Ivf2ZeOywNk3ICpqEAoy5uj5G372Ri/fuJXFQwxkgInxb/i2JW
	 Url/+qCcsjo/g18kdZUiYVcHMOsxeaLaOlOwX0nT5KJogT1iMKnc5R6pqm5+V4ymj4+9O
	 t8i1VSht6EI/V+ce30ye4cq7+RPQKfq1f2xEIB4j+aw9d0+O5JL3F7fZ60Apkg9kwjXrk
	 ZdkY4SijE9wXWWDNs1xAqmU6APMyey0xtD4m+KuN6CVCZiVNlCe7/Jv4WYVOVBBQQ5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmMX8lrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD86606A337;
	Wed,  4 Nov 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nmMX8lrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ADA1F000C1;
	Wed,  4 Nov 2026 22:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831710;
	bh=fCEGZ7LXLoJPmf2HeHLs7wcYAEWiazgpvCuBhcpTCVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmMX8lrbooeRZRk4fqJsUDbE6ZmYCTrmMpLHYNNgehV6lRqVa1htXVaDFfrAlwk4N
	 wwHUaYc5gksxJUxBLv78Izo9DNv7czYzuz7NMKXQRGCbkMhwlaOSXtQsyZZ4VPzFaN
	 QwngdxwHIs6WV3GOXqzRroE3bq1QsKK9e9U+Mbo4=
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
Subject: [PATCH 6.18 0867/1005] smb: client: dont resurrect an exiting tcon from cached dir workers
Date: Wed,  4 Nov 2026 16:10:00 -0500
Message-ID: <20261104211107.557806644@linuxfoundation.org>
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
@@ -648,6 +648,17 @@ void invalidate_all_cached_dirs(struct c
 	flush_delayed_work(&cfids->laundromat_work);
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
@@ -692,6 +703,9 @@ bool cached_dir_lease_break(struct cifs_
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			if (!cached_dir_get_tcon(tcon,
+						 netfs_trace_tcon_ref_get_cached_lease_break))
+				break;
 			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
@@ -702,9 +716,6 @@ bool cached_dir_lease_break(struct cifs_
 			cfid->on_list = false;
 			cfids->num_entries--;
 
-			++tcon->tc_count;
-			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-					    netfs_trace_tcon_ref_get_cached_lease_break);
 			queue_work(cfid_put_wq, &cfid->put_work);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
@@ -812,12 +823,13 @@ static void cfids_laundromat_worker(stru
 		cfid->dentry = NULL;
 
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


