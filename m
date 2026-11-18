Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038996;
	b=pn+zc0/0NFEmOAqS65/nnlo5E15UwGJ2xpXol46kxm2VDAvmWhxtCHVQ+f7ty0w4k+Mw
	 6e7iltuLEktFBAFzYAsZXbV4GVDqf6A5YhxLmuuCEszb18drgqWGLaH7huX5liO8Jj1bd
	 L+Ta7U6WQoYoHgdTdcupqFW5cFEECKw4pu8ffM1by60WFWPT23Y55WLQUgCMDA/g4d5Gj
	 7BZceUjljjSWiMfJW3fqy5QXR5O9cJk74gdl1zLxXfdIqsoBJGEX9VXjFfh2XVtJE6xyq
	 YcCHseG7LNCeq5vX1FRHxcDWxKcZe+gGEO/E0+ryysEYg1OCqxFp3mYPcjPBhT6IsnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dveeqE3s7jKWMJdG4LcV1j0o/8cW0a9kirKkNCSFTso=;
	b=FHL3Y7fKAFY1FDRcDYLdMnYaVbCF1xjEhx2WKQG6wHoNVmH6ldN8aO4NJQBIMaG2tXJ/
	 Y10XzKUay3ORxSVTVYj59J2D9mI1E6WVW08eYc3KSAp8UWxauPqgjSOeTAS38K1SKVIbA
	 Qd5YYUxk5Oj+J8m/PzJMsuiq+IcRk5UV0TIZ/DQx4Mg1PjEtj4FK4aTnpjU0V1qynpjOu
	 CiSAiMHeEonN3clKIuWvofw7Kfet57/Rnr6+beruQxR9DZpSNxhaBtwzz53CE6ZugwNMk
	 B3/TkC34G4Ngp/FqU28d1XC483qCrl1hs6GICQs93GdDsFEgL6dHdRyVH4t+NgdQB7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PS3NoMyD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CEA606A325;
	Wed, 18 Nov 2026 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PS3NoMyD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B201F000C4;
	Wed, 18 Nov 2026 21:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038995;
	bh=dveeqE3s7jKWMJdG4LcV1j0o/8cW0a9kirKkNCSFTso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS3NoMyD9omqHMaflSPEwaHy5Z6r+jv44Rwp8YAR5ds4jbS2n67bUIfc3gCftO/H2
	 6zRvDWE2pgP0g30JOuiHjVtSiXdh1SD6Z/nKARyKdAe5KMId6NVcCGHSqsTUpuMD02
	 HqbkEfiodIZwM6WRC0uUkSueU47KULtHYpndbkvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Johnson <dgj@amazon.com>,
	YouYou Yu <youyouyu@amazon.com>,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1942/3318] quota: initialize dquot cache before mounting rootfs
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118150420.310045609@linuxfoundation.org>
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

From: YouYou Yu <youyouyu@amazon.com>

[ Upstream commit e21a6f39aa6d0336ffbf5f34e5fa20ff8de36773 ]

On some systems, a tmpfs backed rootfs is extensively used throughout
system's lifecycle. tmpfs quotas are needed to limit per user rootfs
usage. However, booting with CONFIG_TMPFS_QUOTA=y, an initramfs, no root=
and "initramfs_options=usrquota" panics at boot:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:dqget+0x1ac/0x490
  Call Trace:
   __dquot_initialize
   dquot_initialize
   shmem_get_inode
   shmem_fill_super
   ...
   mnt_init
   vfs_caches_init
   start_kernel

The rootfs is mounted from mnt_init(), but the dquot hash table and
cache are only set up later by dquot_init(), an fs_initcall. Creating
the root inode of a quota enabled rootfs thus dereferences the NULL
dquot_hash in dqget().

Rename dquot_init() to dquot_cache_init() and call it from
vfs_caches_init() before mnt_init(). The slab, percpu and early
workqueue code it relies on is available there, and the workqueue
rescuer and shrinker debugfs entries are set up later by their own
subsystems. Keep the sysctl registration in an fs_initcall, as done
for the dcache, inode and mount sysctls. This only moves existing
allocations earlier in boot.

Fixes: 278033a225e1 ("fs: Add 'initramfs_options' to set initramfs mount options")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Dylan Johnson <dgj@amazon.com>
Signed-off-by: Dylan Johnson <dgj@amazon.com>
Signed-off-by: YouYou Yu <youyouyu@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Link: https://patch.msgid.link/20261021181217.20171-1-youyouyu@amazon.com
Signed-off-by: Jan Kara <jack@suse.cz>
[ sashal: adjusted patch context to match the existing quota initialization code ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c              |  2 ++
 fs/quota/dquot.c         | 10 ++++++----
 include/linux/quotaops.h |  5 +++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 023a9ab9c7574..c0d7ab8c5aab0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/list_lru.h>
+#include <linux/quotaops.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -3357,6 +3358,7 @@ void __init vfs_caches_init(void)
 	inode_init();
 	files_init();
 	files_maxfiles_init();
+	dquot_cache_init();
 	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7562ee4ff2929..d6295b987ef5f 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -3030,15 +3030,13 @@ static struct ctl_table fs_dqstats_table[] = {
 	{ },
 };
 
-static int __init dquot_init(void)
+void __init dquot_cache_init(void)
 {
 	int i, ret;
 	unsigned long nr_hash, order;
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
-	register_sysctl_init("fs/quota", fs_dqstats_table);
-
 	dquot_cachep = kmem_cache_create("dquot",
 			sizeof(struct dquot), sizeof(unsigned long) * 4,
 			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
@@ -3075,7 +3073,11 @@ static int __init dquot_init(void)
 					   WQ_UNBOUND | WQ_MEM_RECLAIM, WQ_MAX_ACTIVE);
 	if (!quota_unbound_wq)
 		panic("Cannot create quota_unbound_wq\n");
+}
 
+static int __init init_fs_dquot_sysctls(void)
+{
+	register_sysctl_init("fs/quota", fs_dqstats_table);
 	return 0;
 }
-fs_initcall(dquot_init);
+fs_initcall(init_fs_dquot_sysctls);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index a9be09f96b10e..9a4e5df8f52a2 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -40,6 +40,7 @@ void __quota_error(struct super_block *sb, const char *func,
 /*
  * declaration of quota_function calls in kernel.
  */
+void dquot_cache_init(void);
 int dquot_initialize(struct inode *inode);
 bool dquot_initialize_needed(struct inode *inode);
 void dquot_drop(struct inode *inode);
@@ -206,6 +207,10 @@ static inline int sb_has_quota_active(struct super_block *sb, int type)
 	return 0;
 }
 
+static inline void dquot_cache_init(void)
+{
+}
+
 static inline int dquot_initialize(struct inode *inode)
 {
 	return 0;
-- 
2.53.0



