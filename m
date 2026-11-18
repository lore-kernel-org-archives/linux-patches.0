Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056212;
	b=fFylqEJbDIsA6/Gv/GjnNlFIJj8hPSHefgthArY6wRxgF9p6VL5Shkjth7g4F4wCOJze
	 EBdtJJBJ+Mt+w6Naa3nWomBbxM6UJ59vL6uJULinIPrQ65tpVf/ZVIuCoXGunWjV+8o8J
	 x3FjrLqeIQWJIUCGlcn/hIQoyiJyxLWTa05KefFurCMRTNJoTfZenfxmJzjE16h+F+wAS
	 oGBpwHghvBesFMc9vMVS54Ef7ALv9BSqkVCERz3qgxA3Gm7LjLpgEk6Pp5WvUJNZsaxZv
	 uVKUnNWr8h5EG/H8OTzE7ifKZmD2Y6aRTBuF4bgTgWxF4utcnpnqTDJp8EssR4+6d7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DGoVZmaLqJXrjjMl+HsRWh63psh1LzoHznymlHrR1o=;
	b=rWaZGK6ftCplhUq1NmJAWaq+cY2JUToKljfAEiWRErlNf5iIsKVxWtC+BmPEPQBvRAxY
	 OjZQkxbTKNisFxBcuBZP0mH6gtYsQ5gni1DJ7KyPDQGZ7f+pZN6gByBndkDhCbGiAvWoq
	 2QFtMNSXAXoUM9xc0PNwI1wWqyO8v/biGPmHg8M6m5ao2EyX6hdjc/JOt1CYZHfE17VDE
	 NQDL/q1vKQAVuyvUzADAbi37ckULrcxY9+2UIN+8Yu+0c0btM6XRj176l+JjTwQ0ksJZR
	 t0nDy0ZOqoZlnN0JDkzt+OfG/nU/AeT5H/ot1ezrF0kUNKLnW2XqN8S4HMIhCVQZ4yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L559059D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BAC606A320;
	Thu, 19 Nov 2026 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L559059D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91F1F000C4;
	Thu, 19 Nov 2026 02:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056212;
	bh=9DGoVZmaLqJXrjjMl+HsRWh63psh1LzoHznymlHrR1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L559059DnF9BhqiarZxATUvpQj1tsX4wgWvC9L0943AeVY9aFqTj35vAwDXS39yCl
	 9GvbaX6tjShzEL7pYZvytuuovHL3S8fFlJPh3CT0TzMFqjCgAqcmv3OdY4jIHfhtwj
	 sE46fANGqvfYrNcds5P6K7lX5wZlPVlTr22mmvhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1900/2214] ocfs2: retain all security xattrs during inode creation
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118150127.162019612@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d637475617d8468c2740a3436428681bcc8d3572 ]

When creating a new inode, ocfs2_init_security_get() stores the security
xattr returned by the LSM framework in ocfs2_security_xattr_info so that
it can be written later within the same transaction.  But
ocfs2_initxattrs() only ever looks at the first element of the xattr
array, and it keeps the name as a bare pointer into memory owned by the
security layer instead of copying it.  The value, by contrast, is already
duplicated with kmemdup().

With stacked LSMs, security_inode_init_security() provides one xattr per
LSM, so all labels but the first are silently dropped and never written to
disk, leaving newly created files without the security xattrs the other
LSMs rely on.

The borrowed name is not an outright bug with the LSMs in tree today:
security_inode_init_security() frees only ->value once the callback
returns, and documents ->name as the attribute name suffix, so the pointer
stays valid for as long as ocfs2 uses it.  It is fragile though, as an LSM
that allocates the name together with the value would turn it into a
use-after-free, so the rework below copies the names as well.

Fix this by storing copies of all the security xattrs: allocate an array
in ocfs2_initxattrs(), copy the names and values, account for all of them
in the credit calculations, and write each one in
ocfs2_init_security_set().

While at it, switch the allocations from GFP_KERNEL to GFP_NOFS.  The
callback runs in the inode creation path with the parent directory locked,
and the security layer allocates the very same xattr array with GFP_NOFS,
so direct reclaim must not be allowed to recurse into the filesystem from
here.

Link: https://lore.kernel.org/20260917014825.678947-1-joseph.qi@linux.alibaba.com
Fixes: de3004c874e7 ("ocfs2: Switch to security_inode_init_security()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c |   6 +--
 fs/ocfs2/xattr.c | 133 +++++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/xattr.h |  12 +++--
 3 files changed, 116 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 62f9d976c8fb3..98ec433b263a7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -244,7 +244,6 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
-		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota_inode = 0;
@@ -471,7 +470,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.value);
+	ocfs2_free_security_xattrs(&si);
 
 	ocfs2_acl_init_release(&acl_state);
 
@@ -1814,7 +1813,6 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 	int want_clusters = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
-		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
@@ -2046,7 +2044,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 
 	brelse(new_fe_bh);
 	brelse(parent_fe_bh);
-	kfree(si.value);
+	ocfs2_free_security_xattrs(&si);
 	ocfs2_free_dir_lookup_result(&lookup);
 	if (inode_ac)
 		ocfs2_free_alloc_context(inode_ac);
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 6a462fef115fc..d45c87d20fd36 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -580,10 +580,15 @@ int ocfs2_calc_security_init(struct inode *dir,
 			     int *xattr_credits,
 			     struct ocfs2_alloc_context **xattr_ac)
 {
+	int i;
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
-	int s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
-						 si->value_len);
+	int s_size = 0;
+
+	for (i = 0; i < si->count; i++)
+		s_size += ocfs2_xattr_entry_real_size(
+				strlen(si->xattrs[i].name),
+				si->xattrs[i].value_len);
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -600,14 +605,27 @@ int ocfs2_calc_security_init(struct inode *dir,
 		*xattr_credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 	}
 
-	/* reserve clusters for xattr value which will be set in B tree*/
-	if (si->value_len > OCFS2_XATTR_INLINE_SIZE) {
-		int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
-							    si->value_len);
+	/*
+	 * when blocksize = 512, the security xattrs may not fit in the
+	 * single block reserved above and a bucket has to be allocated
+	 * for them, so reserve the cluster it needs as well.
+	 */
+	if (dir->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE &&
+	    s_size > OCFS2_XATTR_FREE_IN_BLOCK(dir)) {
+		*want_clusters += 1;
+		*xattr_credits += ocfs2_blocks_per_xattr_bucket(dir->i_sb);
+	}
 
-		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
-							   new_clusters);
-		*want_clusters += new_clusters;
+	/* reserve clusters for xattr value which will be set in B tree*/
+	for (i = 0; i < si->count; i++) {
+		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
+			int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+						si->xattrs[i].value_len);
+
+			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+								   new_clusters);
+			*want_clusters += new_clusters;
+		}
 	}
 	return ret;
 }
@@ -617,12 +635,16 @@ void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			   int *want_clusters, int *xattr_credits,
 			   int *want_meta, struct ocfs2_acl_state *acl_state)
 {
+	int i;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
-	if (si->enable)
-		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
-						     si->value_len);
+	if (si->enable) {
+		for (i = 0; i < si->count; i++)
+			s_size += ocfs2_xattr_entry_real_size(
+					strlen(si->xattrs[i].name),
+					si->xattrs[i].value_len);
+	}
 
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
 		if (acl_state->default_acl && S_ISDIR(mode)) {
@@ -669,12 +691,14 @@ void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	 * reserve credits and clusters for xattrs which has large value
 	 * and have to be set outside
 	 */
-	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE) {
-		new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
-							si->value_len);
-		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
-							   new_clusters);
-		*want_clusters += new_clusters;
+	for (i = 0; si->enable && i < si->count; i++) {
+		if (si->xattrs[i].value_len > OCFS2_XATTR_INLINE_SIZE) {
+			new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+						si->xattrs[i].value_len);
+			*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+								   new_clusters);
+			*want_clusters += new_clusters;
+		}
 	}
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
 		if (acl_state->default_acl && S_ISDIR(mode)) {
@@ -7438,17 +7462,46 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
 {
 	struct ocfs2_security_xattr_info *si = fs_info;
 	const struct xattr *xattr;
+	struct ocfs2_security_xattr *xattrs;
+	int count = 0, i;
 	int err = 0;
 
 	if (si) {
-		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
-				    GFP_KERNEL);
-		if (!si->value)
+		for (xattr = xattr_array; xattr->name != NULL; xattr++)
+			count++;
+
+		xattrs = kcalloc(count, sizeof(*xattrs), GFP_NOFS);
+		if (!xattrs)
 			return -ENOMEM;
 
-		si->name = xattr_array->name;
-		si->value_len = xattr_array->value_len;
+		for (i = 0; i < count; i++) {
+			xattrs[i].name = kstrdup(xattr_array[i].name, GFP_NOFS);
+			if (!xattrs[i].name) {
+				err = -ENOMEM;
+				goto out_err;
+			}
+
+			xattrs[i].value = kmemdup(xattr_array[i].value,
+						  xattr_array[i].value_len,
+						  GFP_NOFS);
+			if (!xattrs[i].value) {
+				err = -ENOMEM;
+				goto out_err;
+			}
+			xattrs[i].value_len = xattr_array[i].value_len;
+		}
+
+		si->xattrs = xattrs;
+		si->count = count;
 		return 0;
+
+out_err:
+		for (; i >= 0; i--) {
+			kfree(xattrs[i].name);
+			kfree(xattrs[i].value);
+		}
+		kfree(xattrs);
+		return err;
 	}
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
@@ -7461,6 +7514,19 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
 	return err;
 }
 
+void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *si)
+{
+	int i;
+
+	for (i = 0; i < si->count; i++) {
+		kfree(si->xattrs[i].name);
+		kfree(si->xattrs[i].value);
+	}
+	kfree(si->xattrs);
+	si->xattrs = NULL;
+	si->count = 0;
+}
+
 int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    const struct qstr *qstr,
@@ -7478,7 +7544,7 @@ int ocfs2_init_security_get(struct inode *inode,
 		 * security_inode_init_security() does not return -EOPNOTSUPP,
 		 * we have to check the xattr ourselves.
 		 */
-		if (!ret && !si->name)
+		if (!ret && !si->count)
 			si->enable = 0;
 
 		return ret;
@@ -7495,10 +7561,21 @@ int ocfs2_init_security_set(handle_t *handle,
 			    struct ocfs2_alloc_context *xattr_ac,
 			    struct ocfs2_alloc_context *data_ac)
 {
-	return ocfs2_xattr_set_handle(handle, inode, di_bh,
-				     OCFS2_XATTR_INDEX_SECURITY,
-				     si->name, si->value, si->value_len, 0,
-				     xattr_ac, data_ac);
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < si->count; i++) {
+		ret = ocfs2_xattr_set_handle(handle, inode, di_bh,
+					     OCFS2_XATTR_INDEX_SECURITY,
+					     si->xattrs[i].name,
+					     si->xattrs[i].value,
+					     si->xattrs[i].value_len, 0,
+					     xattr_ac, data_ac);
+		if (ret)
+			break;
+	}
+
+	return ret;
 }
 
 const struct xattr_handler ocfs2_xattr_security_handler = {
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 016374e9a147e..78cb52af03692 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -20,13 +20,18 @@ enum ocfs2_xattr_type {
 	OCFS2_XATTR_MAX
 };
 
-struct ocfs2_security_xattr_info {
-	int enable;
-	const char *name;
+struct ocfs2_security_xattr {
+	char *name;
 	void *value;
 	size_t value_len;
 };
 
+struct ocfs2_security_xattr_info {
+	int enable;
+	struct ocfs2_security_xattr *xattrs;
+	int count;
+};
+
 extern const struct xattr_handler ocfs2_xattr_user_handler;
 extern const struct xattr_handler ocfs2_xattr_trusted_handler;
 extern const struct xattr_handler ocfs2_xattr_security_handler;
@@ -47,6 +52,7 @@ int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 int ocfs2_init_security_get(struct inode *, struct inode *,
 			    const struct qstr *,
 			    struct ocfs2_security_xattr_info *);
+void ocfs2_free_security_xattrs(struct ocfs2_security_xattr_info *);
 int ocfs2_init_security_set(handle_t *, struct inode *,
 			    struct buffer_head *,
 			    struct ocfs2_security_xattr_info *,
-- 
2.53.0



