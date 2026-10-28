Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213589;
	b=BoxZt/tvowmlLcxo9bc83U/IsL2wgEJRH6baohQmHRYzPISMk40raIRe+CAo5HGsNHa+
	 DT0hgKmbZ6Y8HIR6A7PkYuhvmVBsEkgAue1O2Yt3Lf6Sd1FHPA+ytb0CLPWcVxhgYBKhb
	 RziEEFiXg7v5MrZDenyBH+hJIIU6smSeVyuyU4kP+bwM/y9H0GwBkxMI4Eewp5hg4Vt2P
	 JEK9031XIn4Kn0czrPLdzBf6SPZpUTGdoMzFwSkyjrqFmqtH3tOn1WoDwdT3iiIdt+Jd+
	 hu9UcakH0CzqYvbsMhic3UaFKJrIyLzfalspig5Au+AhMXlM2nNxo3SLHgD16VYsKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XYlMpUCZ+glqJWq5p6cXS8NR9vmg8+A4KhwRH+Wsvh8=;
	b=fCp0bMwqn3io+etd3KIGba4gImZ7Dh9tkEZXbJREdDO2WKCOooeW7JjzW8Q2MmSXTZxf
	 MTWFSFHH1OCv+r5AWJUAv9nXCdNhPYph8luFvEyI12GrX+hBS3jG/KWdqfH4zA3Cb0fLm
	 fY0nLqx3b0z1VjTvUdb0+noWHfrDrHqFxsLsWDEHyimnLF4g92Ii+XhBJWpctVGWdyP0G
	 rJWDrTJSme2K4zYe5dj8wgjbZzPtoJXZzKIJOCSlPAzj8WrCNcqvegqWjB++E9TY7ZYVP
	 GS7deBwacbAub2mWPdKIE2/SFokeHHfVmttFdRjbP1Iuk/dmI0TlWdfiVLUb24Bp6Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYNn2Lf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C0C606A31D;
	Wed, 28 Oct 2026 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYNn2Lf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551991F01828;
	Wed, 28 Oct 2026 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213588;
	bh=XYlMpUCZ+glqJWq5p6cXS8NR9vmg8+A4KhwRH+Wsvh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYNn2Lf+ZHl3WtDxgFQ8KkpVYMzMupQVO+i/SqZ8QBcHtIH7izCQo1JwCgW8GAEx5
	 +8pOsX86B11otqcdX1/vRl1N6V8Kt44OqBtEZgy6MvfuFMfPN2QYpwrawPmRIZxNFC
	 zUYg3ePWNj5CA06OpUONPyW7rLAUT/1ky5Dw2zFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0558/1887] smb: client: fix use-after-free in smb2_query_info_compound()
Date: Wed, 28 Oct 2026 17:44:14 +0100
Message-ID: <20261028170512.079641884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 5c86919455c1edec99ebd3338ad213b59271a71b ]

The following UAF was triggered when running fstests generic/072 with
KASAN enabled against Windows Server 2022 and mount options
'multichannel,max_channels=2,vers=3.1.1,mfsymlinks,noperm'

  BUG: KASAN: slab-use-after-free in smb2_query_info_compound+0x423/0x6d0 [cifs]
  Read of size 8 at addr ffff888014941048 by task xfs_io/27534

  CPU: 0 PID: 27534 Comm: xfs_io Not tainted 6.6.0-rc7 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0x7f
   ? srso_alias_return_thunk+0x5/0x7f
   ? __phys_addr+0x46/0x90
   kasan_report+0xda/0x110
   ? smb2_query_info_compound+0x423/0x6d0 [cifs]
   ? smb2_query_info_compound+0x423/0x6d0 [cifs]
   smb2_query_info_compound+0x423/0x6d0 [cifs]
   ? __pfx_smb2_query_info_compound+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0x7f
   ? __stack_depot_save+0x39/0x480
   ? kasan_save_stack+0x33/0x60
   ? kasan_set_track+0x25/0x30
   ? ____kasan_slab_free+0x126/0x170
   smb2_queryfs+0xc2/0x2c0 [cifs]
   ? __pfx_smb2_queryfs+0x10/0x10 [cifs]
   ? __pfx___lock_acquire+0x10/0x10
   smb311_queryfs+0x210/0x220 [cifs]
   ? __pfx_smb311_queryfs+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0x7f
   ? __lock_acquire+0x480/0x26c0
   ? lock_release+0x1ed/0x640
   ? srso_alias_return_thunk+0x5/0x7f
   ? do_raw_spin_unlock+0x9b/0x100
   cifs_statfs+0x18c/0x4b0 [cifs]
   statfs_by_dentry+0x9b/0xf0
   fd_statfs+0x4e/0xb0
   __do_sys_fstatfs+0x7f/0xe0
   ? __pfx___do_sys_fstatfs+0x10/0x10
   ? srso_alias_return_thunk+0x5/0x7f
   ? lockdep_hardirqs_on_prepare+0x136/0x200
   ? srso_alias_return_thunk+0x5/0x7f
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

  Allocated by task 27534:
   kasan_save_stack+0x33/0x60
   kasan_set_track+0x25/0x30
   __kasan_kmalloc+0x8f/0xa0
   open_cached_dir+0x71b/0x1240 [cifs]
   smb2_query_info_compound+0x5c3/0x6d0 [cifs]
   smb2_queryfs+0xc2/0x2c0 [cifs]
   smb311_queryfs+0x210/0x220 [cifs]
   cifs_statfs+0x18c/0x4b0 [cifs]
   statfs_by_dentry+0x9b/0xf0
   fd_statfs+0x4e/0xb0
   __do_sys_fstatfs+0x7f/0xe0
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

  Freed by task 27534:
   kasan_save_stack+0x33/0x60
   kasan_set_track+0x25/0x30
   kasan_save_free_info+0x2b/0x50
   ____kasan_slab_free+0x126/0x170
   slab_free_freelist_hook+0xd0/0x1e0
   __kmem_cache_free+0x9d/0x1b0
   open_cached_dir+0xff5/0x1240 [cifs]
   smb2_query_info_compound+0x5c3/0x6d0 [cifs]
   smb2_queryfs+0xc2/0x2c0 [cifs]

This is a race between open_cached_dir() and cached_dir_lease_break()
where the cache entry for the open directory handle receives a lease
break while creating it.  And before returning from open_cached_dir(),
we put the last reference of the new @cfid because of
!@cfid->has_lease.

Besides the UAF, while running xfstests a lot of missed lease breaks
have been noticed in tests that run several concurrent statfs(2) calls
on those cached fids

  CIFS: VFS: \\w22-root1.gandalf.test No task to wake, unknown frame...
  CIFS: VFS: \\w22-root1.gandalf.test Cmd: 18 Err: 0x0 Flags: 0x1...
  CIFS: VFS: \\w22-root1.gandalf.test smb buf 00000000715bfe83 len 108
  CIFS: VFS: Dump pending requests:
  CIFS: VFS: \\w22-root1.gandalf.test No task to wake, unknown frame...
  CIFS: VFS: \\w22-root1.gandalf.test Cmd: 18 Err: 0x0 Flags: 0x1...
  CIFS: VFS: \\w22-root1.gandalf.test smb buf 000000005aa7316e len 108
  ...

To fix both, in open_cached_dir() ensure that @cfid->has_lease is set
right before sending out compounded request so that any potential
lease break will be get processed by demultiplex thread while we're
still caching @cfid.  And, if open failed for some reason, re-check
@cfid->has_lease to decide whether or not put lease reference.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 97 +++++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fca8656929399..bac6ceccaaa9c 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -30,7 +30,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * fully cached or it may be in the process of
 			 * being deleted due to a lease break.
 			 */
-			if (!cfid->has_lease) {
+			if (!cfid->time || !cfid->has_lease) {
 				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
@@ -188,10 +188,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	npath = path_no_prefix(cifs_sb, path);
 	if (IS_ERR(npath)) {
 		rc = PTR_ERR(npath);
-		kfree(utf16_path);
-		return rc;
+		goto out;
 	}
 
+	if (!npath[0]) {
+		dentry = dget(cifs_sb->root);
+	} else {
+		dentry = path_to_dentry(cifs_sb, npath);
+		if (IS_ERR(dentry)) {
+			rc = -ENOENT;
+			goto out;
+		}
+	}
+	cfid->dentry = dentry;
+
 	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
@@ -253,6 +263,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	smb2_set_related(&rqst[1]);
 
+	/*
+	 * Set @cfid->has_lease to true before sending out compounded request so
+	 * its lease reference can be put in cached_dir_lease_break() due to a
+	 * potential lease break right after the request is sent or while @cfid
+	 * is still being cached.  Concurrent processes won't be to use it yet
+	 * due to @cfid->time being zero.
+	 */
+	cfid->has_lease = true;
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
@@ -267,6 +286,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->tcon = tcon;
 	cfid->is_open = true;
 
+	spin_lock(&cfids->cfid_list_lock);
+
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -274,20 +295,30 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
+	rc = -EINVAL;
+	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 
 	rc = smb2_parse_contexts(server, rsp_iov,
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key,
 			    &oplock, NULL, NULL);
-	if (rc)
+	if (rc) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+	}
+	rc = -EINVAL;
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
@@ -295,57 +326,49 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!npath[0])
-		dentry = dget(cifs_sb->root);
-	else {
-		dentry = path_to_dentry(cifs_sb, npath);
-		if (IS_ERR(dentry)) {
-			rc = -ENOENT;
-			goto oshr_free;
-		}
-	}
-	cfid->dentry = dentry;
 	cfid->time = jiffies;
-	cfid->has_lease = true;
+	spin_unlock(&cfids->cfid_list_lock);
+	/* At this point the directory handle is fully cached */
+	rc = 0;
 
 oshr_free:
-	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	spin_lock(&cfids->cfid_list_lock);
-	if (rc && !cfid->has_lease) {
+	if (rc) {
+		spin_lock(&cfids->cfid_list_lock);
 		if (cfid->on_list) {
 			list_del(&cfid->entry);
 			cfid->on_list = false;
 			cfids->num_entries--;
 		}
-		rc = -ENOENT;
-	}
-	spin_unlock(&cfids->cfid_list_lock);
-	if (!rc && !cfid->has_lease) {
-		/*
-		 * We are guaranteed to have two references at this point.
-		 * One for the caller and one for a potential lease.
-		 * Release the Lease-ref so that the directory will be closed
-		 * when the caller closes the cached handle.
-		 */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		if (cfid->has_lease) {
+			/*
+			 * We are guaranteed to have two references at this
+			 * point. One for the caller and one for a potential
+			 * lease. Release the Lease-ref so that the directory
+			 * will be closed when the caller closes the cached
+			 * handle.
+			 */
+			cfid->has_lease = false;
+			spin_unlock(&cfids->cfid_list_lock);
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			goto out;
+		}
+		spin_unlock(&cfids->cfid_list_lock);
 	}
+out:
 	if (rc) {
 		if (cfid->is_open)
 			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 				   cfid->fid.volatile_fid);
 		free_cached_dir(cfid);
-		cfid = NULL;
-	}
-
-	if (rc == 0) {
+	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
-
+	kfree(utf16_path);
 	return rc;
 }
 
-- 
2.53.0



