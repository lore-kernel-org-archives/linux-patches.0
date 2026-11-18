Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054292;
	b=eP/AXJxT3uu2XLitLVB7QyS8C0DwlBYRT9/vw8Eg0MjyYcMk6oYimP5PFmfYKGKF1BDu
	 Kiup56aMn+ToXxJOp5Nvl1OG1uJqIZNIMBCERKnSYYP+zMBHTmUsBDB7Ds2UqOcJ8Y4lG
	 5vK4iS7omKSL9gtplR+XjfxaRvu4oRg7jube8M4HmL7HIooaoG44yloBIiWqTTNCuKks9
	 +2tX+wuhi8t8RFXT50FBTN6W0vPyJGI44c8iFyCa36QWU+ct82i28A4SmauuKAEy5mJwq
	 J1tEZvrgE5ujcR/veXj1X3VHz4T94qkoINJkbpeWeaWc9/0FKnJoq3JnqlLxHNCMjEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2nY4ZrRVNroGGy7pQ2oVP6oMBtf6liT9RQoMocZZOHM=;
	b=mMOJ8GAliRS94qu8KOkJIA4mYmsMHSpwB7VE9mJ5n2wx5T0dN01ImfzFlE1AcTlI6Mch
	 D7JMPeC5i1kFsQgSY/lTHHRk4zQ+8wO/yTtFhTCn5AZlyN3oknLVSuYdnUrp5cgwZnNkI
	 mGFsEidPyUR2XZeY52zyAmUCoSIC+NIY+TPguo9StazVrF25165+yHGruCTiWjhvLdmIy
	 kiXJgRGqtR7P+u6+ELJLiTMEyx9SON0zN8cJ3VokapGIzI4h3GQGi/GJYzu2ew6RGqmCa
	 OoeVRUwYl1Kdze1TS55O2Vr1iqWj8TQBTjtQp0aAbSLFfNWOlaNpNNSB+mLLNYNVCNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RxM/aFwJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40135606A31C;
	Thu, 19 Nov 2026 02:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxM/aFwJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B771F000C4;
	Thu, 19 Nov 2026 02:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054292;
	bh=2nY4ZrRVNroGGy7pQ2oVP6oMBtf6liT9RQoMocZZOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxM/aFwJ40rjxlgsg2xR9kXFNHPP3ur9x3ewtShslTEaQhvcIJK/OY+sjFOdw00yW
	 ybgcsGFcpPyRzb1dfMOUq22bfs6LmKYVjQxz5l/EwOftcTffUKj5BAxgOaBgbrEdCa
	 MEIKyEvhKUABoXnuEDJ8cIxBfEDUihEGjtlZY2Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1223/2214] procfs: kill ->proc_dops
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150100.696713551@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 5943c611c47c9444e834555c867dec744158b7ad ]

It has two possible values - one for "forced lookup" entries, another
for the normal ones.  We'd be better off with that as an explicit
flag anyway and in addition to that it opens some fun possibilities
with ->d_op and ->d_flags handling.

[moved PROC_ENTRY_FORCE_LOOKUP to include/linux/proc_fs.h, switched it
to an unused bit - there was a conflict]

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c       | 8 +++++---
 fs/proc/internal.h      | 3 +--
 include/linux/proc_fs.h | 2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 81756fd46c4ca..4a438f1f318d1 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -256,7 +256,10 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
 		inode = proc_get_inode(dir->i_sb, de);
 		if (!inode)
 			return ERR_PTR(-ENOMEM);
-		d_set_d_op(dentry, de->proc_dops);
+		if (de->flags & PROC_ENTRY_FORCE_LOOKUP)
+			d_set_d_op(dentry, &proc_net_dentry_ops);
+		else
+			d_set_d_op(dentry, &proc_misc_dentry_ops);
 		return d_splice_alias(inode, dentry);
 	}
 	read_unlock(&proc_subdir_lock);
@@ -448,9 +451,8 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	INIT_LIST_HEAD(&ent->pde_openers);
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
 
-	ent->proc_dops = &proc_misc_dentry_ops;
 	/* Revalidate everything under /proc/${pid}/net */
-	if ((*parent)->proc_dops == &proc_net_dentry_ops)
+	if ((*parent)->flags & PROC_ENTRY_FORCE_LOOKUP)
 		pde_force_lookup(ent);
 
 out:
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2c652681172b8..a51ff1a60e804 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -43,7 +43,6 @@ struct proc_dir_entry {
 		const struct proc_ops *proc_ops;
 		const struct file_operations *proc_dir_ops;
 	};
-	const struct dentry_operations *proc_dops;
 	union {
 		const struct seq_operations *seq_ops;
 		int (*single_show)(struct seq_file *, void *);
@@ -330,7 +329,7 @@ extern const struct dentry_operations proc_net_dentry_ops;
 static inline void pde_force_lookup(struct proc_dir_entry *pde)
 {
 	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
-	pde->proc_dops = &proc_net_dentry_ops;
+	pde->flags |= PROC_ENTRY_FORCE_LOOKUP;
 }
 
 /*
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 4789761707463..2d4c7e5801dee 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -27,6 +27,8 @@ enum {
 
 	PROC_ENTRY_proc_read_iter	= 1U << 1,
 	PROC_ENTRY_proc_compat_ioctl	= 1U << 2,
+
+	PROC_ENTRY_FORCE_LOOKUP		= 1U << 7,
 };
 
 struct proc_ops {
-- 
2.53.0



