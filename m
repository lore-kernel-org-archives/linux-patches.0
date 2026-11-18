Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025144;
	b=xQMVLaEOSdLHLQbMS6KmP2gYd/x5necqtGVYi9e/sxGhf7eyG6RT+tOhRdhEprAJr3uz
	 ZeAVp2dktVDtoeQCBEGb6Dl6C9WieBeCSNRccKhoybIkOjoJy/V6FwhANnFoLpHTbNkQh
	 EEmHwxhJiUBd8tbYNcEOeIp+QOWcU109DlPcj72xSLMCanT/N74OObRkutGZ4ZZyqge4N
	 fX/vub0p5ImLQwPLlDgagKhsLqg2gBFSf+aOzFtM++ZVGRNxnNv6FB/SxCbBYgvHLciFj
	 VmzlqICfodZRpI59qFssGcSuan6cRVSVZH1KmaZQTSrPHrYjdvy9gTCrY0Baxhp7bzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1diUHlBKhqC3cPUPjdlWcYgZQn2cM6rCDdteNjrS2Po=;
	b=AVvVDscHC9QtSvj1S+V83Hnoh0sbEXxL/3Nqp2Yr+CAgo9ciPC/nK7Z3yQx/C4tO3NV6
	 XaxEMwiuthjr6pxf5V23JPNUvLWZucZoWcBKHGrAFDrPAiiCyMGJVBJEYz+robhs6rBh7
	 vrbWVtMJVhqgb3sZDGDu4OfzADizph5kILC2v8lEFrdJvRn7lp64uKOHlL9DjX6v3Brwr
	 CvnSrzoX438DdQn35+BF0JUZzmHO8FH+6gGCUEOAVHbNu7E/6F7Q4CMC6Mx27NicRGj4E
	 5G+0IeNFG+aFJ8YRlTyaFGhDrv2l80IQfRkR3hAMnH3sNfkaod57h4cz19+1oNgpQFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wh18mVwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A9606A31C;
	Wed, 18 Nov 2026 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wh18mVwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6CB1F000CB;
	Wed, 18 Nov 2026 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025143;
	bh=1diUHlBKhqC3cPUPjdlWcYgZQn2cM6rCDdteNjrS2Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wh18mVwHOu1647HOy/R64Jxrh/m6pHBD+WuXrKKHaLmcBhHWFF6Or12wq27b6gwXK
	 QyFUHQRxg4sA1aDhZPit6/pwaWdzZ+ckZzab5VMdfsscD6fZjFen0agAxJkk/IvBns
	 /1mxgZMaIJaDoa0pKwjxXlupIZz2P7O1AIksPN+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0934/2151] debugfs: make debugfs_create_str() read-only
Date: Wed, 18 Nov 2026 15:44:29 +0100
Message-ID: <20261118150156.515191785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 5ec78be9552035e1e71de218f968c03c44181bf0 ]

debugfs_create_str() supports replacing the backing string from userspace.
Concurrent writers can race and free the same old string twice.

All writable in-tree users have been converted to local file operations.
Remove the generic write support from debugfs_create_str(), and refuse to
create a file when the caller passes write permission bits.

This makes unsupported writable use visible instead of silently creating a
file with different permissions.

Fixes: 86b5488121db ("debugfs: Add write support to debugfs_create_str()")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260807100053.1089834-4-chenyichong@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 81 ++++++-----------------------------------------
 1 file changed, 10 insertions(+), 71 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 880a8a9deacfe..4c2214621a077 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -1048,98 +1048,37 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-static ssize_t debugfs_write_file_str(struct file *file, const char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-	struct dentry *dentry = F_DENTRY(file);
-	char *old, *new = NULL;
-	int pos = *ppos;
-	int r;
-
-	r = debugfs_file_get(dentry);
-	if (unlikely(r))
-		return r;
-
-	old = *(char **)file->private_data;
-
-	/* only allow strict concatenation */
-	r = -EINVAL;
-	if (pos && pos != strlen(old))
-		goto error;
-
-	r = -E2BIG;
-	if (pos + count + 1 > PAGE_SIZE)
-		goto error;
-
-	r = -ENOMEM;
-	new = kmalloc(pos + count + 1, GFP_KERNEL);
-	if (!new)
-		goto error;
-
-	if (pos)
-		memcpy(new, old, pos);
-
-	r = -EFAULT;
-	if (copy_from_user(new + pos, user_buf, count))
-		goto error;
-
-	new[pos + count] = '\0';
-	strim(new);
-
-	rcu_assign_pointer(*(char __rcu **)file->private_data, new);
-	synchronize_rcu();
-	kfree(old);
-
-	debugfs_file_put(dentry);
-	return count;
-
-error:
-	kfree(new);
-	debugfs_file_put(dentry);
-	return r;
-}
-
 static const struct file_operations fops_str = {
 	.read =		debugfs_read_file_str,
-	.write =	debugfs_write_file_str,
-	.open =		simple_open,
-	.llseek =	default_llseek,
-};
-
-static const struct file_operations fops_str_ro = {
-	.read =		debugfs_read_file_str,
-	.open =		simple_open,
-	.llseek =	default_llseek,
-};
-
-static const struct file_operations fops_str_wo = {
-	.write =	debugfs_write_file_str,
 	.open =		simple_open,
 	.llseek =	default_llseek,
 };
 
 /**
- * debugfs_create_str - create a debugfs file that is used to read and write a string value
+ * debugfs_create_str - create a debugfs file that is used to read a string value
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
  *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the debugfs filesystem.
- * @value: a pointer to the variable that the file should read to and write
- *         from. This pointer and the string it points to must not be %NULL.
+ * @value: a pointer to the variable that the file should read from. This
+ *         pointer and the string it points to must not be %NULL.
  *
  * This function creates a file in debugfs with the given name that
- * contains the value of the variable @value.  If the @mode variable is so
- * set, it can be read from, and written to.
+ * contains the value of the variable @value.  The file can be read from.
+ * Writable files are not supported; if @mode contains write permission bits,
+ * no file is created.
  */
 void debugfs_create_str(const char *name, umode_t mode,
 			struct dentry *parent, char **value)
 {
 	if (WARN_ON(!value || !*value))
 		return;
+	if (WARN(mode & 0222,
+		 "%s() does not support writable files\n", __func__))
+		return;
 
-	debugfs_create_mode_unsafe(name, mode, parent, value, &fops_str,
-				   &fops_str_ro, &fops_str_wo);
+	debugfs_create_file_unsafe(name, mode, parent, value, &fops_str);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_str);
 
-- 
2.53.0



