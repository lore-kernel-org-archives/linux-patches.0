Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044083;
	b=LrIXdBZLM0fG7X52z1q6LWMWTepy9NMMw1GMChmuNMmM5r2jybDBiCnd3c3l1vxxwGlx
	 KZMfKywhvisSK0BVvV/78mG4D3HaaaIjuj/mCtrWaxZTollJhjGwfV17ZuuLrkzcM38qV
	 gJYSaeeMgTgx8wcIsRzqpgdouyOyuOpYmp6GbiMujzgYQrElRwIpd+br8JbX3ZM4bCe+j
	 6qE/VP/C8QsOplQ6IIAfrBcJFA2nikSfH9lfACI3PWZeiOsizYjY9o7eFXy2j+xTvIOdb
	 p7ILTLkkfK7DA8u4j8x/pGwuXWJgXpuBnIdj11rKnKF5Z5qOiuxjeCLYt54xueVrfDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebIaAM9e9fMnJJ+z8FmWO36qsisPq5trPyYAWyqR/wc=;
	b=Dt/DM9bWjlhAAZW0RyDDA0tMEs0B1KzTKuG793KDi5tXDpnz3+zJyXa6DUNlEfOW41GW
	 gcz7h3SsCo3IEXjasEveHlOP1Ul0cPnl1W0z3wWAlEOmeR7FOIvnNdlLUtMFKONqLQ1oa
	 nNE0+m0OeM0xbkuXgH6OjOevjHjJccUrqn7IAshJJc6VRiZwDlVGTCTJOBtNb405QXXw3
	 WDnERWF8ssBEYcqfs0xlAl+zZt1KjHhlmAxINT6DVjhidO90eAfqmrCnAqRT/8w4E5XXk
	 EwP3FGDyskrdCv6k+lgarZcHpsmfQKV0Q8PSXmuQKbxHYwEatYUcCHS2Zj6NNMQnCqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KULCQEaU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBF2606A31C;
	Wed, 18 Nov 2026 23:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KULCQEaU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC731F000C4;
	Wed, 18 Nov 2026 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044083;
	bh=ebIaAM9e9fMnJJ+z8FmWO36qsisPq5trPyYAWyqR/wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KULCQEaUrDM/qwXmXPLeuYHxEu4B7AIyuyDPIS4kP/3rN9BNcuDRAqaIlJww4Ey0R
	 uY8s+NZZs0p4gBm1maG1ThLGHNlyO5knl/vuWjRuxpzRHnx/WGkC3ooD9Ienjx3E9b
	 F8ww2PO9Sra54F8L9qL8QlmGaAugScLwivGQIXzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	syzbot+2a13ad6914e6fcec716c@syzkaller.appspotmail.com,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0414/2857] fs/ntfs3: use d_instantiate_new() in ntfs_create_inode() and murder syzbots "WARNING in do_new_mount" saga
Date: Wed, 18 Nov 2026 15:24:08 +0100
Message-ID: <20261118150216.292749243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: Adapted the exit path to this tree's return inode signature by dropping unlock_new_inode(inode) instead of the upstream if (!err) form. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index ba1395c78313c..cb8e6d10c81d3 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1642,10 +1642,10 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 	}
 
 	/*
-	 * Call 'd_instantiate' after inode->i_op is set
+	 * Call 'd_instantiate_new' after inode->i_op is set
 	 * but before finish_open.
 	 */
-	d_instantiate(dentry, inode);
+	d_instantiate_new(dentry, inode);
 
 	ntfs_save_wsl_perm(inode);
 	mark_inode_dirty(dir);
@@ -1696,8 +1696,6 @@ struct inode *ntfs_create_inode(struct user_namespace *mnt_userns,
 		return ERR_PTR(err);
 	}
 
-	unlock_new_inode(inode);
-
 	return inode;
 }
 
-- 
2.53.0



