Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB693A4F4B;
	Tue, 21 Jul 2026 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663211; cv=none; b=rNKN6wzsUHcpMPQBRhjeYPzxWvkb28U9/XkDYXZilpAzGEMn0D86EZD/rx0dK1YohBQ31OmkM7wcg1zpl/RT5mWjq88irBR7edoxONo3JsCdD3P9794tUFmcCGmx3Rh64a+pVMEHfp9VHapdf+XnJWaIZM3IKJ31nHpJ8iZbteA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663211; c=relaxed/simple;
	bh=enZCCNBfwosVPQiZ0Rk5RujzW3gbZAsdeOb3WkXsB54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpDaOKImQAiXn/Pexa9xYfNPx2qi6W+iT0nJcfYK7j7YNlHBqbS8S7av9lvvbxjyKtNWLy2hZRyiI2XF7FexEf649rPOsI1LoZkR543IiE4FT0laMPK2O4LFdYETZ5m4xAngAzRh9aJf0JmyzFXezr5AGWU0snw7oEC1DVoZWks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETCDKkdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETCDKkdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4141F000E9;
	Tue, 21 Jul 2026 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663210;
	bh=I3cQfOdDN7qN1fDLA7CqM0/0fUhu22qnhhz3zJdcdMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETCDKkdItdddrfQCVd5ayq/wQgCfe8t7BogVsQrVDhVAk/NaI9YcgcpF8ik3Ew5L2
	 W7Jo8H77k1TiuiX01uNkZKtBx/Szsjms+T0C1vTI+LAZ5423ss800ZEJQrWUURxzYq
	 PW3PpgE8G82ztMzKTMS7PsBd3T6E2tYOg40iUj60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0735/1276] afs: Remove the "autocell" mount option
Date: Tue, 21 Jul 2026 17:19:38 +0200
Message-ID: <20260721152502.528599314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4c5ad63f85ef984cc809538b2dcbc113aed82330 ]

Remove the "autocell" mount option.  It was an attempt to do automounting
of arbitrary cells based on what the user looked up but within the root
directory of a mounted volume.  This isn't really the right thing to do,
and using the "dyn" mount option to get the dynamic root is the right way
to do it.  The kafs-client package uses "-o dyn" when mounting /afs, so it
should be safe to drop "-o autocell".

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/20250224234154.2014840-7-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20250310094206.801057-3-dhowells@redhat.com/ # v4
Stable-dep-of: c9c3b615a462 ("afs: Fix misplaced inc of net->cells_outstanding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c      | 5 ++---
 fs/afs/dynroot.c  | 5 +----
 fs/afs/internal.h | 2 --
 fs/afs/super.c    | 5 -----
 4 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 50edd1cae28ace..037c89e05f4cf0 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1031,9 +1031,8 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	inode = afs_do_lookup(dir, dentry, key);
 	key_put(key);
 	if (inode == ERR_PTR(-ENOENT))
-		inode = afs_try_auto_mntpt(dentry, dir);
-
-	if (!IS_ERR_OR_NULL(inode))
+		inode = NULL;
+	else if (!IS_ERR_OR_NULL(inode))
 		fid = AFS_FS_I(inode)->fid;
 
 	_debug("splice %p", dentry->d_inode);
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 008698d706caa4..0b4cc291c65e2d 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -155,7 +155,7 @@ static int afs_probe_cell_name(struct dentry *dentry)
  * Try to auto mount the mountpoint with pseudo directory, if the autocell
  * operation is setted.
  */
-struct inode *afs_try_auto_mntpt(struct dentry *dentry, struct inode *dir)
+static struct inode *afs_try_auto_mntpt(struct dentry *dentry, struct inode *dir)
 {
 	struct afs_vnode *vnode = AFS_FS_I(dir);
 	struct inode *inode;
@@ -164,9 +164,6 @@ struct inode *afs_try_auto_mntpt(struct dentry *dentry, struct inode *dir)
 	_enter("%p{%pd}, {%llx:%llu}",
 	       dentry, dentry, vnode->fid.vid, vnode->fid.vnode);
 
-	if (!test_bit(AFS_VNODE_AUTOCELL, &vnode->flags))
-		goto out;
-
 	ret = afs_probe_cell_name(dentry);
 	if (ret < 0)
 		goto out;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 18f410559fe87b..aa66d8010f8942 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -714,7 +714,6 @@ struct afs_vnode {
 #define AFS_VNODE_ZAP_DATA	3		/* set if vnode's data should be invalidated */
 #define AFS_VNODE_DELETED	4		/* set if vnode deleted on server */
 #define AFS_VNODE_MOUNTPOINT	5		/* set if vnode is a mountpoint symlink */
-#define AFS_VNODE_AUTOCELL	6		/* set if Vnode is an auto mount point */
 #define AFS_VNODE_PSEUDODIR	7 		/* set if Vnode is a pseudo directory */
 #define AFS_VNODE_NEW_CONTENT	8		/* Set if file has new content (create/trunc-0) */
 #define AFS_VNODE_SILLY_DELETED	9		/* Set if file has been silly-deleted */
@@ -1089,7 +1088,6 @@ extern int afs_silly_iput(struct dentry *, struct inode *);
 extern const struct inode_operations afs_dynroot_inode_operations;
 extern const struct dentry_operations afs_dynroot_dentry_operations;
 
-extern struct inode *afs_try_auto_mntpt(struct dentry *, struct inode *);
 extern int afs_dynroot_mkdir(struct afs_net *, struct afs_cell *);
 extern void afs_dynroot_rmdir(struct afs_net *, struct afs_cell *);
 extern int afs_dynroot_populate(struct super_block *);
diff --git a/fs/afs/super.c b/fs/afs/super.c
index f3ba1c3e72f5b8..259c48e37537eb 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -194,8 +194,6 @@ static int afs_show_options(struct seq_file *m, struct dentry *root)
 
 	if (as->dyn_root)
 		seq_puts(m, ",dyn");
-	if (test_bit(AFS_VNODE_AUTOCELL, &AFS_FS_I(d_inode(root))->flags))
-		seq_puts(m, ",autocell");
 	switch (as->flock_mode) {
 	case afs_flock_mode_unset:	break;
 	case afs_flock_mode_local:	p = "local";	break;
@@ -478,9 +476,6 @@ static int afs_fill_super(struct super_block *sb, struct afs_fs_context *ctx)
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	if (ctx->autocell || as->dyn_root)
-		set_bit(AFS_VNODE_AUTOCELL, &AFS_FS_I(inode)->flags);
-
 	ret = -ENOMEM;
 	sb->s_root = d_make_root(inode);
 	if (!sb->s_root)
-- 
2.53.0



