Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059964;
	b=QYWKcLVkoMJiWnBV5mZhgQboYGXMWwTm89KyT1kzFMQdDSbCGCSUBw/Sr26hbCHmG0sG
	 H73SbBe3k0pHrR833nWgDxGZd/+9jevpXyOsmYAiRoYnTw/VxZdZM0Zn3vUb/yJVKuBE/
	 s+USKQ7dlBgkhtF9a+6usiMSxPp5muaoWD4RI37itAeKyvceKEP0oDEHFybbWmxQwnKm9
	 Vj8HXF4buM1vncpcUGeHGHMzBGK0f50RWeyiX0GYyNwtebDfdjf2yx07RhEWuCyizv7sh
	 ldmKat5/z9xJQ6jZnAu7neGl7GeRQ/nn5/jzSeGkA4t+iH66AbRXRwtIzKojpeDWJPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xSQMN1fiZvcHDDKPqLirkCaSAs5QXaF9XB52SiHBmxk=;
	b=wFM6zJsvvBJMgbMG2kv2LrKe1Jdj3XcNpdJdfmetGvqgVJddDnktn2/aB0salAfbnpS7
	 vytwfvNXWdTXi3muIYlK8gG7FxUoIsmtC4kAgUhh4jg9bAxrViunFnJFKZ4uspB2egnYa
	 x92V3E6t6wLk5YyEro56j8X6m0BryMHU1eIwzHfwqLuGiNxpqN+YJbZhKESFNZiiBdbNI
	 StpM2JAARbpsQZvC7d0UHRubUMJAaYF5eZ62/u2BVUg13Ji8lmwsvDFoyTzPnMw/S95g2
	 2FeeUllbz7aylHqYdigmHCnfh6akG1mEZUOEhMdz3Fgzz4w4gfxAY1Mxyqyzt/nMBJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oExhJELb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0612606A32C;
	Thu, 19 Nov 2026 03:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oExhJELb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DFC1F000C4;
	Thu, 19 Nov 2026 03:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059963;
	bh=xSQMN1fiZvcHDDKPqLirkCaSAs5QXaF9XB52SiHBmxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oExhJELbobko3HZ5s9xadm2bfAzTiTyzyiNgubrCeb4ag+zONoFAW+NeufWm6M5BW
	 a9suSHT+/geLczE72Lls5IjGDy8GpvPbwjG20cZYtbreNk5Y9c2ft1lsm3eeVbMs3h
	 DIyGiFoqTF7IBiy/LwhIhDyOiUAtuXziW1JP3LDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1030/1848] procfs: kill ->proc_dops
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150000.513491787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3651bc8245227..ab9f499fc749f 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -261,7 +261,10 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
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
@@ -453,9 +456,8 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	INIT_LIST_HEAD(&ent->pde_openers);
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
 
-	ent->proc_dops = &proc_misc_dentry_ops;
 	/* Revalidate everything under /proc/${pid}/net */
-	if ((*parent)->proc_dops == &proc_net_dentry_ops)
+	if ((*parent)->flags & PROC_ENTRY_FORCE_LOOKUP)
 		pde_force_lookup(ent);
 
 out:
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e35e28415dd8e..56fc4197d92b8 100644
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
@@ -329,7 +328,7 @@ extern const struct dentry_operations proc_net_dentry_ops;
 static inline void pde_force_lookup(struct proc_dir_entry *pde)
 {
 	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
-	pde->proc_dops = &proc_net_dentry_ops;
+	pde->flags |= PROC_ENTRY_FORCE_LOOKUP;
 }
 
 /*
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9f8e0072b30fe..cd320ccb60bf6 100644
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



