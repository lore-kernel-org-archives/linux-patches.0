Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063821;
	b=yFBUqfCkuKobFYFL9ZGcmYvsDTWn80P5pLjhwdKqkXwmThUE6DPDfejj3Nj/VgYFFwDD
	 m+3MTPHh/D6q7YZT6vhWkeCE0eOuHRazEpb4NSmd49oumUzWIGJ2t1l/Zt3YemDbIR2Mx
	 8eN1ZPcGNXiVx43aBfoc8MAKbFbTZQpPJ198QW7RWAzz5IGyxTb9+ffAjrdz8VBdZlRsY
	 Z3I/PGEeTmgBS97qzCKt8YVSK14kZM6ABOQ1Ji8Y3CBJiMiUeCoOlFt+8fvRM4L1oAtZH
	 399LodTsUpCT/pTCGE/u3YfH6C7bqAiKWPlIsrVePyEwLQk8WiqIJoUOQhCMWG81Bhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0gU7kx6lAUrkcrvufhN7XC3VDBmi5jU63WuT4gmel9E=;
	b=UeWUGOc1mSTQOjP3nKSIKpUJIi5mY6EXoDvVKbncXbz1/X+dyTnYxlhaO/qTYZ/TEAhF
	 DcJCvHG35CFh6ulsQ5y4gYU5VXPSfTD6xnQlUMmU0R3jIy72yMfgn71plUMcdimGn2j41
	 5CXHR+N0QqViZjj8uqW8ZhzO34LX03dTt9oOlT68g1cF+FGvUR5YwTnJn98P20eG6+iZ+
	 mXYahFXTav1WfPXm7EybvMFnkBsOeqdngv0cA+aMQkUSaeDg80FU7R4UCOuCqDaGirN3r
	 tLN3bWT/fDYTx3aTeziyJixYzVLl1hafLuYuoT0JQfg4Qok2VHuFMCfP2GPf0UvREeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQ4bhjrY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFD2606A326;
	Sat,  7 Nov 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQ4bhjrY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA081F008A1;
	Sat,  7 Nov 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063820;
	bh=0gU7kx6lAUrkcrvufhN7XC3VDBmi5jU63WuT4gmel9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQ4bhjrYoB+7R792ADKG0mOVIvKruoieW0tUnH3KlX+ZPdzuadTb4i7efT9nRlYW5
	 YWlMC8kIpVMdOiXKqxa2PwvGltx+OQuwKucAkM5Tbw3CF12h+rdcxbaQ6OyDG14+8n
	 NDS5lOO+UouGYRx8TLGnuzztzOliLubdbrJkV8jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Sandeen <sandeen@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0036/1257] devtmpfs: restore mount option reconfiguration on get_tree
Date: Sat,  7 Nov 2026 08:38:52 -0500
Message-ID: <20261107134940.404115963@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 1c7df6fa838a46f0d5090ef134f67511f0592f33 ]

commit cb0e0a8bf4e1 ("devtmpfs: replace ->mount with ->get_tree in
public instance") converted the public devtmpfs instance to the new
mount API but broke the ability to reconfigure the shared superblock
options via subsequent mount() calls, as had been fixed once in
a6097180d884 ("devtmpfs regression fix: reconfigure on each mount")

This makes boot-time defaults permanent.

Fix this using an approach suggested by Al Viro: at init_fs_context
time, create a reconfigure-mode context via fs_context_for_reconfigure()
and save it in fc->fs_private. The devtmpfs parse ops can then use
this context to parse options appropriately for the underlying filesystem.

This also removes the devtmpfs_configure_context() one-time ops-copying
approach and the global mutable ops table it required.

Fixes: cb0e0a8bf4e1 ("devtmpfs: replace ->mount with ->get_tree in public instance")
Reported-by: Simon Liebold <simonlie@amazon.de>
Cc: stable@vger.kernel.org
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Link: https://patch.msgid.link/b1bd3b15-78ea-4487-b6a8-aad0b05dd3bb@redhat.com
Tested-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devtmpfs.c | 108 ++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index aef0fcc6aba1e..11c70888f38be 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -72,39 +72,90 @@ static struct file_system_type internal_fs_type = {
 	.kill_sb = kill_anon_super,
 };
 
-/* Simply take a ref on the existing mount */
+struct devtmpfs_context {
+	struct fs_context *fc;
+};
+
+static void devtmpfs_free(struct fs_context *fc)
+{
+	struct devtmpfs_context *ctx = fc->fs_private;
+
+	if (ctx) {
+		put_fs_context(ctx->fc);
+		kfree(ctx);
+	}
+}
+
+static int devtmpfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct devtmpfs_context *ctx = fc->fs_private;
+
+	return ctx->fc->ops->parse_param(ctx->fc, param);
+}
+
+static int devtmpfs_parse_monolithic(struct fs_context *fc, void *data)
+{
+	struct devtmpfs_context *ctx = fc->fs_private;
+
+	if (ctx->fc->ops->parse_monolithic)
+		return ctx->fc->ops->parse_monolithic(ctx->fc, data);
+	return generic_parse_monolithic(ctx->fc, data);
+}
+
 static int devtmpfs_get_tree(struct fs_context *fc)
 {
+	struct devtmpfs_context *ctx = fc->fs_private;
 	struct super_block *sb = mnt->mnt_sb;
+	int err;
 
 	atomic_inc(&sb->s_active);
 	down_write(&sb->s_umount);
+
+	if (ctx->fc->ops->reconfigure) {
+		err = ctx->fc->ops->reconfigure(ctx->fc);
+		if (err) {
+			deactivate_locked_super(sb);
+			return err;
+		}
+	}
+
 	fc->root = dget(sb->s_root);
 	return 0;
 }
 
-/* Ops are filled in during init depending on underlying shmem or ramfs type */
-static struct fs_context_operations devtmpfs_context_ops = {};
+static const struct fs_context_operations devtmpfs_context_ops = {
+	.free		  = devtmpfs_free,
+	.parse_param	  = devtmpfs_parse_param,
+	.parse_monolithic = devtmpfs_parse_monolithic,
+	.get_tree	  = devtmpfs_get_tree,
+};
 
-/* Call the underlying initialization and set to our ops */
 static int devtmpfs_init_fs_context(struct fs_context *fc)
 {
-	int ret;
-#ifdef CONFIG_TMPFS
-	ret = shmem_init_fs_context(fc);
-#else
-	ret = ramfs_init_fs_context(fc);
-#endif
-	if (ret < 0)
-		return ret;
+	struct devtmpfs_context *ctx;
+	int err;
+
+	ctx = kzalloc_obj(struct devtmpfs_context);
+	if (!ctx)
+		return -ENOMEM;
+
+	/* Each mount will reconfigure the shared superblock w/ new options */
+	ctx->fc = fs_context_for_reconfigure(mnt->mnt_root,
+					     mnt->mnt_sb->s_flags, MS_RMT_MASK);
+	if (IS_ERR(ctx->fc)) {
+		err = PTR_ERR(ctx->fc);
+		kfree(ctx);
+		return err;
+	}
 
+	fc->fs_private = ctx;
 	fc->ops = &devtmpfs_context_ops;
 
 	return 0;
 }
 
 static struct file_system_type dev_fs_type = {
-	.name = "devtmpfs",
+	.name		 = "devtmpfs",
 	.init_fs_context = devtmpfs_init_fs_context,
 };
 
@@ -442,31 +493,6 @@ static int __ref devtmpfsd(void *p)
 	return 0;
 }
 
-/*
- * Get the underlying (shmem/ramfs) context ops to build ours
- */
-static int devtmpfs_configure_context(void)
-{
-	struct fs_context *fc;
-
-	fc = fs_context_for_reconfigure(mnt->mnt_root, mnt->mnt_sb->s_flags,
-					MS_RMT_MASK);
-	if (IS_ERR(fc))
-		return PTR_ERR(fc);
-
-	/* Set up devtmpfs_context_ops based on underlying type */
-	devtmpfs_context_ops.free	      = fc->ops->free;
-	devtmpfs_context_ops.dup	      = fc->ops->dup;
-	devtmpfs_context_ops.parse_param      = fc->ops->parse_param;
-	devtmpfs_context_ops.parse_monolithic = fc->ops->parse_monolithic;
-	devtmpfs_context_ops.get_tree	      = &devtmpfs_get_tree;
-	devtmpfs_context_ops.reconfigure      = fc->ops->reconfigure;
-
-	put_fs_context(fc);
-
-	return 0;
-}
-
 /*
  * Create devtmpfs instance, driver-core devices will add their device
  * nodes here.
@@ -482,12 +508,6 @@ int __init devtmpfs_init(void)
 		return PTR_ERR(mnt);
 	}
 
-	err = devtmpfs_configure_context();
-	if (err) {
-		pr_err("unable to configure devtmpfs type %d\n", err);
-		return err;
-	}
-
 	err = register_filesystem(&dev_fs_type);
 	if (err) {
 		pr_err("unable to register devtmpfs type %d\n", err);
-- 
2.53.0



