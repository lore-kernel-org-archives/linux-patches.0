Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034708;
	b=cNECfAAjDIuKPBm7sdVIRKvXadef6tSyE9A0L+uFWVzbEM0osce1h46R7eU114I16ngg
	 /PvswNQPMxtT73Uk/Sg/jw91YJCnbosaYN2VAzRniJNiDe9bKWYFPtnQ8PkPZeDpidENS
	 9/b8GBbGdJMSzLnlsKVYYQKvMf33SBP0BZ5krwM0JEn+cLXmPSEV8KquMxaWKuwBYawVr
	 bfvGe50ZfD2h/FumY3Mi+hmvCITcB4YYU5SL1QNcUgcIWPW/stLIkrkRSDG0YJr2B4cUC
	 M1BVZLwC52Iz5yuIRqeBkXqBiiIKzciUnJsc5oQfJKyqgiTDJNgI9WDvbdr76/qqxrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2hHlzFlIOHWVGOCKBYZKyrolHVL6XE1S8ybQCb3FOE=;
	b=tlyQZ0m5Mtr70/SAxrw/LmN61TgqCbPd1q/Ni2pjIXJX7eVq5GnrsWDODiOgrn6ImAGR
	 r/yF8aFxi0Sn1VHp0SxtuRXP4sIjmaifXb/ZOAAI2c2BSuKLjxUnw4P5f5jwlhfdIfPY3
	 otUbn+eW89DXTgyJ/EdYKi3hw/QaYkg00FdGjNnvNg2HCkDiW58s1zLtVmZm05PQhAssH
	 qOknwnZ0ob3oV+HosKKUk61/on8ZYyeNXJRoFeTOkkGZ8rHecY2Mmvlkj2CbwDev1MvFb
	 WwIWPD+VI6il0DoODmpe4uTmcz0lsMNcYxW6B/fwpLgFdzP5xmacFipBvaTfgMlgO6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQ06V3fO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CB2606A31C;
	Wed, 18 Nov 2026 20:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQ06V3fO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901661F000C4;
	Wed, 18 Nov 2026 20:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034708;
	bh=R2hHlzFlIOHWVGOCKBYZKyrolHVL6XE1S8ybQCb3FOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQ06V3fOhEblQNeQxcyV40Pus3FbRER6Y4XsQMsxcUKkdcpz6xA+DvgVbazRsJJ8Q
	 8pZPvRFP3z4dymnt26IL+3bZyWIZjKh1iA7+0JSPGBHPOIblqnLqpTMknSJ18KGdya
	 XyU5CizfknPwH0o5ydnTO6tFRHS+a7oidK9SoVuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot+2a13ad6914e6fcec716c@syzkaller.appspotmail.com,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0464/3318] fs/ntfs3: use d_instantiate_new() in ntfs_create_inode() and murder syzbots "WARNING in do_new_mount" saga
Date: Wed, 18 Nov 2026 15:18:06 +0100
Message-ID: <20261118150330.764368008@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1abd643f3783ea8f8e273c18697ff0413aa92dc7 ]

ntfs_create_inode() creates a new inode via ntfs_new_inode(). It hashes
it with insert_inode_locked() and so it's marked as I_NEW until
unlock_new_inode().

ntfs 3 calls d_instantiate() in between though... Since the dentry was
already hashed by the lookup before the create any path walk finds it
without touching the parent's i_rwsem and so can lock the inode.

If the inode is a directory unlock_new_inode() calls
lockdep_annotate_inode_mutex_key() and marks i_rwsem with the
i_mutex_dir_key class.

That resets the count and the owner of a lock somebody else may already
hold by now...

syzbot has been spamming us with the same godforsaken bug

  "WARNING in do_new_mount"

since 2023. I can't take it anymore so I went looking. Afaict, syzbot's
executor chdirs into a freshly mounted ntfs3 image, creates a
directory and then mounts some pseudofs on it. Everytime the mkdir()
takes longer than syzbot waits mount() runs concurrently:

  mkdir("./sys")                        mount(NULL, "./sys", "sysfs")
  ntfs_create_inode()
    d_instantiate()
                                        user_path_at() finds the dentry
                                        do_lock_mount()
                                          inode_lock(inode)
                                          namespace_lock()
    unlock_new_inode()
      lockdep_annotate_inode_mutex_key()
        init_rwsem(&inode->i_rwsem)
                                        unlock_mount()
                                          inode_unlock(inode)

The mount side then releases a lock that according to the rwsem nobody
holds:

  DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && ...):
  count = 0x0, magic = 0xffff888043a854e8, owner = 0x0,
  curr 0xffff888000244880, list empty
  WARNING: CPU: 0 PID: 5346 at kernel/locking/rwsem.c:1368 __up_write
  Call Trace:
   inode_unlock include/linux/fs.h:877 [inline]
   unlock_mount fs/namespace.c:2892 [inline]
   do_new_mount_fc fs/namespace.c:3828 [inline]
   do_new_mount+0x777/0xa40 fs/namespace.c:3887

On PREEMPT_RT the same thing shows up as

  DEBUG_LOCKS_WARN_ON(rt_mutex_owner(lock) != current)
  WARNING: kernel/locking/rtmutex_common.h:193 at rt_mutex_slowunlock

The up_write() underflows the reset count. A following inode_lock() on
that directory then never returns. A path walk into the new directory
racing with the mkdir() corrupts the lock the same way via
inode_lock_shared() in lookup_slow().

Switch to d_instantiate_new() and drop the trailing unlock_new_inode().
All error paths bail out before that point with I_NEW still set and
keep using discard_new_inode().

May we never see this fscking bug report again.

Link: https://patch.msgid.link/20260909-work-ntfs3-d_instantiate_new-v1-1-2db697162ce8@kernel.org
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v5.15+
Reported-by: syzbot+2a13ad6914e6fcec716c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a9beced.a5e650b3.26d8a.000b.GAE@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adapted the tail of ntfs_create_inode() to this tree's struct inode * return convention, dropping only the trailing unlock_new_inode() while keeping the ERR_PTR(err) / return inode logic. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index b13a11f6a6341..2deb98b484660 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1705,10 +1705,10 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		goto out6;
 
 	/*
-	 * Call 'd_instantiate' after inode->i_op is set
+	 * Call 'd_instantiate_new' after inode->i_op is set
 	 * but before finish_open.
 	 */
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 
 	/* Set original time. inode times (i_ctime) may be changed in ntfs_init_acl. */
 	inode->i_atime = inode->i_mtime =
@@ -1757,8 +1757,6 @@ struct inode *ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	if (err)
 		return ERR_PTR(err);
 
-	unlock_new_inode(inode);
-
 	return inode;
 }
 
-- 
2.53.0



