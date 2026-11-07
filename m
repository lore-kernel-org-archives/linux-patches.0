Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061919;
	b=gIjrZbI3tk72f/Wufdct6N1bR8BQykKPCxBy3yD4ff4hVVRiRU0MZdgKPhu8AJADUqob
	 bSmAyRhNWcUbhn3jMTgwQiAUAOj9SbXWrMH+P7zPrjeCYCXtKn6KTEQ6nxGYAWrSXuswg
	 SSvXmg3TSs7s25fMzi9g4CZ/DKOOWk7Wl5NfwQogFs+rDZmH0jpJyorhlRKvvGfOTILEc
	 DwobEKBNRMmWqVvnVJzKD1JtsKhegnmcoYoviccBEPCONjRflfwzNSPj7lmdhrLVaskn+
	 XRCKwOnYBCk6veafaG9ovgaHDw1QOodj7M6Bd7sguhNUQMuQRNBQo8Z33hzWmCVM0uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zxS5andnBactqoAg/FvK2MH+Dl5EMyZCJurIZt7xxlI=;
	b=uN2yMCicUN5n5Zzw+7u9StUCCe8XnZgK8GYJwHYo2PcYHwifX71bSgKQq5XY1KZY0xAM
	 u6TRnJpBBMmFvfMSubYKkXjU+SqUhqLbBZi+ACiRflxILg+VZqg0s2aXnLyXrJVGUO4/n
	 VVHqbBIjiMnf/H5B2cPcb5V5mto3TT+L4H9v+V6/DHjNqo2pv+NJrEWcTfD+ewOOvcbpo
	 HyS6rlcjeb8SY3ipaZFj2jHjO98hwiim5CAaViXDoo56o0ejg8sOId6zm5iA2uUZlL6OZ
	 NyrLUcU+QY8RLAOk65L2IxJpwFwTUMjnfsqgY3Oe78ROk7kpICHxc0fiqYO1VLkv2QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZJ+JeYf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127B606A32D;
	Sat,  7 Nov 2026 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZJ+JeYf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5561F008A1;
	Sat,  7 Nov 2026 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061918;
	bh=zxS5andnBactqoAg/FvK2MH+Dl5EMyZCJurIZt7xxlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZJ+JeYf2aI9aigwnFD0aj4bE78TuUp+4Yv3xS6SSyS98xF2IoZRGIlV5AniLZo6j
	 /p9gK3EucsqCmyqHlYkcT36rmLedKFKX0rF1XDXU7vjOC6gIffrQ/saNjMFGMT9C5k
	 pj29Sx5tm1qLTcQ4/gbMvw6VF6CgxUJJhXZDXn4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH 6.12 0925/1536] fs: make sure to call fsnotify_inoderemove() only once when inode is dead
Date: Sat,  7 Nov 2026 08:49:01 -0500
Message-ID: <20261107135023.626315495@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 669bb5af15d41a21359d00a441490f87a88eb52a ]

Daehyeon reported a race wherein fsnotify_removeinode() can be called
when inode still has a live alias.  This can lead to several undesired
outcomes such as crashes in fsnotify code or avoidance of inode mark
notifications.

Check that inode is really "dead", meaning no nlink and no more aliases
before calling fsnotify_inoderemove() for final cleanup of inode marks.
Also do not allow open_by_handle() to add new aliases to a "dead" inode.

Ideally, we'd call fsnotify_inoderemove() once last inode reference is
dropped to make things simpler. Alas fsnotify inode marks currently hold
inode references and thus this doesn't work. Once we teach fsnotify to
avoid holding inode references, these games with dead inodes can go as
well.

Reported-and-tested-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/20260827045007.3831259-1-4ncienth@gmail.com/
CC: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260902164924.1333135-2-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 982559a94d155..ad31c9dd53f77 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -388,6 +388,17 @@ static void dentry_free(struct dentry *dentry)
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
 }
 
+/*
+ * If inode is unlinked and doesn't have any aliases (i.e., all fds pointing to
+ * it are closed), it is pretty much dead. Except that file handle lookup could
+ * still revive it which causes issues to fsnotify. So once inode reaches this
+ * state we make sure to block creating any new aliases.
+ */
+static bool inode_notify_dead(struct inode *inode)
+{
+	return !inode->i_nlink && hlist_empty(&inode->i_dentry);
+}
+
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -397,14 +408,16 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool notify_dead;
 
 	raw_write_seqcount_begin(&dentry->d_seq);
 	__d_clear_type_and_inode(dentry);
 	hlist_del_init(&dentry->d_u.d_alias);
 	raw_write_seqcount_end(&dentry->d_seq);
+	notify_dead = inode_notify_dead(inode);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
+	if (notify_dead)
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
@@ -1953,7 +1966,12 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	sb = inode->i_sb;
 
-	res = d_find_any_alias(inode); /* existing alias? */
+	spin_lock(&inode->i_lock);
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* existing alias? */
+	else
+		res = ERR_PTR(-ESTALE);
+	spin_unlock(&inode->i_lock);
 	if (res)
 		goto out;
 
@@ -1965,7 +1983,10 @@ static struct dentry *__d_obtain_alias(struct inode *inode, bool disconnected)
 
 	security_d_instantiate(new, inode);
 	spin_lock(&inode->i_lock);
-	res = __d_find_any_alias(inode); /* recheck under lock */
+	if (!inode_notify_dead(inode))
+		res = __d_find_any_alias(inode);	/* recheck under lock */
+	else
+		res = ERR_PTR(-ESTALE);
 	if (likely(!res)) { /* still no alias, attach a disconnected dentry */
 		unsigned add_flags = d_flags_for_inode(inode);
 
-- 
2.53.0



