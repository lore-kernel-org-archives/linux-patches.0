Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065176;
	b=O8nGHP8UjaZOxYcAs3rUgqncCyDuURk3GaYTviIrbSy2j4d7Y9eKCQ36uLrz8Mo2dwCo
	 WvexW2Lrr10nvY4rMlrwMccpaAXDoK27zWkik8uhDqmBwUaOlGpJOPfrbwSgXYH1IVIWp
	 fIb2sSBhygGl8vTjDQZno0X0TjvtIhTZ9qNxgSAtTT6xbSkGFybZ9LAHxiq5RZIrppo5G
	 nnn3gt2YcP/3BwWqBFnv5AOwqcADTghdBrxqQ2BoGjEIWqN/ok94ArExziqBRQuv5MADp
	 wZuZ4HQdjbq3a399lo0wg3FcDyJV57JlsGngACXr3gS1UN0ENWbqG6y8mugh8Gw5qIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2rk4og1WO+Pcq9yGrbUTJoJvmw6+opabCg/hchCBUX0=;
	b=CvPocjLNc6FsSqHj18W+C8LfaKfgTCNSJpGPMCZPmDlI+d4X4ZvAdP4w1lDEg1kJiHKj
	 2mafp5oIAaFgvCc/Ilasw8kZORcgm+lh6SW64svCkkjGSKAQph9VicFcfxM6o0eU8MXFY
	 KH0Rp/Xfbefku+lYZfh3enuL2Opa6KPXEgm1eG37/e9LnwY0iM0uxzBMIoCJ4YXzFX01K
	 EJSd8gmL5PoPgcw0Bh4yRtQdZfY8v25ZZBelw/mzV7UDfGRgdiKWSQOG32mEFZLSuEBjW
	 G57St7CxVT4vTTPgMuK4t9MmKedgi2oAygmO+NhUG1qT3Ems9kpCUJSK4j0SRMvo9KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfNcwPZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229FE606A33A;
	Sat,  7 Nov 2026 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfNcwPZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DF81F0089F;
	Sat,  7 Nov 2026 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065176;
	bh=2rk4og1WO+Pcq9yGrbUTJoJvmw6+opabCg/hchCBUX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfNcwPZBE4yfHdcKNe1rTD04oCN0I3ScNbzVO4zkfFzFQ93YV6VLG3dc/HmHD2YbK
	 3/HH1q0KXVfyaVjr0036GH/mxD8zoxyUIIszNeX5FQDV1I566/GqFe3irncsz+QB77
	 5Aw/QoTpePDWexuk+9auRw7U3GainWiqHXoocPsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0919/1257] ntfs: set the volume dirty bit unconditionally on metadata changes
Date: Sat,  7 Nov 2026 08:53:35 -0500
Message-ID: <20261107135004.728850083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 55af94ca0ee3512c08d12ffbbb948229da4e1565 ]

The callers in file.c and namei.c skip ntfs_set_volume_flags() when
the in-memory vol_flags already show VOLUME_IS_DIRTY, but that check
runs without any lock: if it observes the bit set and ntfs_sync_fs()
clears it under the mrec_lock before the caller's metadata update
completes, the set is skipped and the volume can end up clean on disk
despite the modification, so chkdsk will not run on the next mount.

Drop the caller-side checks and call ntfs_set_volume_flags()
unconditionally: ntfs_write_volume_flags() already skips the write
under the mrec_lock when the combined value is unchanged.  That
unconditional call costs one mrec_lock acquisition per metadata
operation even in the already-dirty steady state; it cannot be
avoided, because deciding to skip the call without the lock is itself
what allows a concurrent ntfs_sync_fs() clear to lose the set.

The IOCB_NOWAIT path in ntfs_file_write_iter() goes through the same
sleeping call: a RWF_NOWAIT write can block in the marking, as it
already could before this change whenever the volume appeared clean.
Giving that path a non-blocking variant is left as follow-up work.
The callers keep the pre-existing behavior of proceeding when the
marking fails, so the dirty bit remains best-effort.

This closes the variant where the set is skipped outright.  A clear
for a concurrent, error-free sync can still land between the set and
the end of the metadata operation; that mark-at-start lifecycle is
pre-existing and is not changed by this patch.

Reported-by: Baolin Liu <liubaolin@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c  | 20 +++++++++++---------
 fs/ntfs/namei.c | 24 ++++++++----------------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 7c7cbd16e9446..e3020a4bf805a 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -341,8 +341,7 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		goto out;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	if (ia_valid & ATTR_SIZE) {
 		err = ntfs_setattr_size(vi, attr);
@@ -636,8 +635,13 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out_lock;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	/*
+	 * The volume must be marked dirty before the modification is made,
+	 * without an unlocked check of the in-memory flag: ntfs_sync_fs()
+	 * can clear the bit concurrently and the modification would then
+	 * land on a volume that is clean on disk.
+	 */
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	pos = iocb->ki_pos;
 	count = ret;
@@ -1169,11 +1173,9 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 			return err;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY)) {
-		err = ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
-		if (err)
-			return err;
-	}
+	err = ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	if (err)
+		return err;
 
 	inode_lock(vi);
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni)) {
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index fdf52fac43291..3e0adb9a0ea42 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -757,8 +757,7 @@ static int ntfs_create(struct mnt_idmap *idmap, struct inode *dir,
 		return err;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	ni = __ntfs_create(idmap, dir, uname, uname_len, S_IFREG | mode, 0, NULL, 0);
 	kmem_cache_free(ntfs_name_cache, uname);
@@ -1032,8 +1031,7 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 		return err;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	err = ntfs_delete(ni, NTFS_I(dir), uname, uname_len, true);
 	if (err)
@@ -1076,8 +1074,7 @@ static struct dentry *ntfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 		return ERR_PTR(err);
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	ni = __ntfs_create(idmap, dir, uname, uname_len, mode, 0, NULL, 0);
 	kmem_cache_free(ntfs_name_cache, uname);
@@ -1118,8 +1115,7 @@ static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return err;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	err = ntfs_delete(ni, NTFS_I(dir), uname, uname_len, true);
 	if (err)
@@ -1305,8 +1301,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		new_dir_first = is_subdir(new_dentry->d_parent,
 					  old_dentry->d_parent);
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	mutex_lock_nested(&old_ni->mrec_lock, NTFS_INODE_MUTEX_NORMAL);
 	if (new_ni)
@@ -1429,8 +1424,7 @@ static int ntfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	ni = __ntfs_create(idmap, dir, usrc, usrc_len, S_IFLNK | 0777, 0,
 			   symname, symlen);
@@ -1474,8 +1468,7 @@ static int ntfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 		return err;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	switch (mode & S_IFMT) {
 	case S_IFCHR:
@@ -1521,8 +1514,7 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -ENOMEM;
 	}
 
-	if (!(vol->vol_flags & VOLUME_IS_DIRTY))
-		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
+	ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
 
 	ihold(vi);
 	mutex_lock_nested(&ni->mrec_lock, NTFS_INODE_MUTEX_NORMAL);
-- 
2.53.0



