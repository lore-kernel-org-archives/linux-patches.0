Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213572;
	b=iNP2ER3iXqUoJ5stI3cHNHiwUGeclQhvh0fBXh2VC89DGpk529DgHa8hL1rUQVZjgq1y
	 JSTJTYSCjaE8B6nekNcRMcmAGnWHmoScLuxJJa1ICJuGEI9dWSXaooziQjf33ABwxTsRF
	 Yo9eEgWUbF08ptvJKX6ib7oAY/xd7WIPNnty/q2a7k1qg/qpD/zp531AcN3XhF+nXBxzm
	 NwKowph5pJ4fITZPA4NOs/wMhlElFTY2ClT0jeECnLrNntYDgniZ3npU5zaONuwykbp80
	 /CnlgrvR0AMG0ejnDzA2+lG9MN8dwsKudrevmaDSTph8q+PajWp4tJbWgGAkCaUIxUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ngmDNOzxod32eE2SX7tUHkSjJiCB6RUK3Z87EU7pJe4=;
	b=lLjCcl1QTePq6zbvm+PFr4ywj5AKV+EOXaV6NFoO7c3b5xF10unuVygnYJ6KLT/uasVm
	 219kbwgzNI6a0c0aAjKN8gPDLSc7uHQUIhMrxqeR0D1XCu2wxUw40DN0Y62ZMJx0RvGuW
	 1WzGGKLa1AUbXEWE6CrqhSt7r/hXeqQdZl12/X+W3kqp3chKKzBWgiHWXYgujsXBtCVNL
	 bm7EsIeR23K0evF5KC1hLV2UOB+kM0x7109CbhyUtyeEwzbmuWwP/pu1H7bfHhuOwuASC
	 uO/DC9Jj19S1qQNXoCxOv28TPDlZWL0Iwx+j2E/eaZmdhYOb5efi00uDhIwYWn5URzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVcjINzt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF698606A31A;
	Wed, 28 Oct 2026 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVcjINzt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3EF1F01825;
	Wed, 28 Oct 2026 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213571;
	bh=ngmDNOzxod32eE2SX7tUHkSjJiCB6RUK3Z87EU7pJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVcjINztgHr0ARYeyAztdHQ4SCWo29F5IwIs1xptjnlngoO2qNnLkYGLJWlxxBj36
	 fsWECwLC/dlmBggGA7FNh3bSqOWjYE0qYvqWgg1V4hoEbTpmagNz+a7E7cwCl8NWSh
	 gFA1rUIbwFRwGazIyjDoNTpci7CxX+LE2JsEWlbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0553/1887] fs: new helper: simple_rename_timestamp
Date: Wed, 28 Oct 2026 17:44:09 +0100
Message-ID: <20261028170511.961186679@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0c4767923ed6964d279309744cdb248890e95ec2 ]

A rename potentially involves updating 4 different inode timestamps. Add
a function that handles the details sanely, and convert the libfs.c
callers to use it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-Id: <20230705185812.579118-3-jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 49db9b1b86a8 ("reiserfs: Avoid touching renamed directory if parent does not change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c         | 36 +++++++++++++++++++++++++++---------
 include/linux/fs.h |  2 ++
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 63bc52c20f7e0..60ec2dd903589 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -449,6 +449,31 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 }
 EXPORT_SYMBOL(simple_rmdir);
 
+/**
+ * simple_rename_timestamp - update the various inode timestamps for rename
+ * @old_dir: old parent directory
+ * @old_dentry: dentry that is being renamed
+ * @new_dir: new parent directory
+ * @new_dentry: target for rename
+ *
+ * POSIX mandates that the old and new parent directories have their ctime and
+ * mtime updated, and that inodes of @old_dentry and @new_dentry (if any), have
+ * their ctime updated.
+ */
+void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct inode *newino = d_inode(new_dentry);
+
+	old_dir->i_mtime = inode_set_ctime_current(old_dir);
+	if (new_dir != old_dir)
+		new_dir->i_mtime = inode_set_ctime_current(new_dir);
+	inode_set_ctime_current(d_inode(old_dentry));
+	if (newino)
+		inode_set_ctime_current(newino);
+}
+EXPORT_SYMBOL_GPL(simple_rename_timestamp);
+
 int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
 			   struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -464,11 +489,7 @@ int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
 			inc_nlink(old_dir);
 		}
 	}
-	old_dir->i_ctime = old_dir->i_mtime =
-	new_dir->i_ctime = new_dir->i_mtime =
-	d_inode(old_dentry)->i_ctime =
-	d_inode(new_dentry)->i_ctime = current_time(old_dir);
-
+	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(simple_rename_exchange);
@@ -477,7 +498,6 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		  struct dentry *old_dentry, struct inode *new_dir,
 		  struct dentry *new_dentry, unsigned int flags)
 {
-	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = d_is_dir(old_dentry);
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
@@ -500,9 +520,7 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		inc_nlink(new_dir);
 	}
 
-	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
-		new_dir->i_mtime = inode->i_ctime = current_time(old_dir);
-
+	simple_rename_timestamp(old_dir, old_dentry, new_dir, new_dentry);
 	return 0;
 }
 EXPORT_SYMBOL(simple_rename);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 264381ae06e26..0692c2e0fcf3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3483,6 +3483,8 @@ extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
+void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry);
 extern int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
 				  struct inode *new_dir, struct dentry *new_dentry);
 extern int simple_rename(struct user_namespace *, struct inode *,
-- 
2.53.0



