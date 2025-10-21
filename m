Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52627510E;
	Tue, 21 Oct 2025 19:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076616; cv=none; b=nrgfP7qxQICteVlPGBvAl9i0EhowVnBgzFkLfs/h8ONEJ9UXFHgBoCXQ2XSQGYGrNwe0aoPKsJFJq3p/KImVR1Ef8wiqii6AQfgAWJ9zcBXSCC/qAQnasKe21rLwx/16cDckPcvQw9pOTjIHw2CkcV8JcoLaUBc/Wtrpr8XCiFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076616; c=relaxed/simple;
	bh=yfyCr2X1B0t/3IPllAdNhv989yuTIBSND82+OV4sti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B86RKptAkOr+rtrbqQcvHR2uhlGmyXyYFO6xbTKdKEf7AUJhruHXwXn77/6hy0WNEIUIcOT714/+JI7RRym9PRbtzDbbE8LV/Y+gx/f8YB6stN7SP8asbEYUVZxLlP4YIxoGfuXoTgW+vUY85P4QBafehhs644m3gV0O4euX7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myk+QXEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myk+QXEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CBBC4CEF1;
	Tue, 21 Oct 2025 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076616;
	bh=yfyCr2X1B0t/3IPllAdNhv989yuTIBSND82+OV4sti4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myk+QXEhtDraGyDHMWylEWQ88WyBRwqdmrg048C+UhnQ27mUDwCsdjNrTL9p769Vn
	 1YdY7uJTCjg7GUbKfDvX0gT6cc+oAIRrIm1hq6nsv7uo8wyX19ZHJwdVCQyi7rqjIf
	 EQMDdvU/rj29BU8IY+F3qYOw9JDeCwFafMEKP40c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/105] quota: remove unneeded return value of register_quota_format
Date: Tue, 21 Oct 2025 21:51:38 +0200
Message-ID: <20251021195023.764462957@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit a838e5dca63d1dc701e63b2b1176943c57485c45 ]

The register_quota_format always returns 0, simply remove unneeded return
value.

Link: https://patch.msgid.link/20240715130534.2112678-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: 72b7ceca857f ("fs: quota: create dedicated workqueue for quota_release_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/super.c      |    6 ++----
 fs/quota/dquot.c      |    3 +--
 fs/quota/quota_v1.c   |    3 ++-
 fs/quota/quota_v2.c   |    9 +++------
 include/linux/quota.h |    2 +-
 mm/shmem.c            |    7 +------
 6 files changed, 10 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1571,15 +1571,13 @@ static int __init ocfs2_init(void)
 
 	ocfs2_set_locking_protocol();
 
-	status = register_quota_format(&ocfs2_quota_format);
-	if (status < 0)
-		goto out3;
+	register_quota_format(&ocfs2_quota_format);
+
 	status = register_filesystem(&ocfs2_fs_type);
 	if (!status)
 		return 0;
 
 	unregister_quota_format(&ocfs2_quota_format);
-out3:
 	debugfs_remove(ocfs2_debugfs_root);
 	ocfs2_free_mem_caches();
 out2:
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -163,13 +163,12 @@ static struct quota_module_name module_n
 /* SLAB cache for dquot structures */
 static struct kmem_cache *dquot_cachep;
 
-int register_quota_format(struct quota_format_type *fmt)
+void register_quota_format(struct quota_format_type *fmt)
 {
 	spin_lock(&dq_list_lock);
 	fmt->qf_next = quota_formats;
 	quota_formats = fmt;
 	spin_unlock(&dq_list_lock);
-	return 0;
 }
 EXPORT_SYMBOL(register_quota_format);
 
--- a/fs/quota/quota_v1.c
+++ b/fs/quota/quota_v1.c
@@ -229,7 +229,8 @@ static struct quota_format_type v1_quota
 
 static int __init init_v1_quota_format(void)
 {
-        return register_quota_format(&v1_quota_format);
+	register_quota_format(&v1_quota_format);
+	return 0;
 }
 
 static void __exit exit_v1_quota_format(void)
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -422,12 +422,9 @@ static struct quota_format_type v2r1_quo
 
 static int __init init_v2_quota_format(void)
 {
-	int ret;
-
-	ret = register_quota_format(&v2r0_quota_format);
-	if (ret)
-		return ret;
-	return register_quota_format(&v2r1_quota_format);
+	register_quota_format(&v2r0_quota_format);
+	register_quota_format(&v2r1_quota_format);
+	return 0;
 }
 
 static void __exit exit_v2_quota_format(void)
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -526,7 +526,7 @@ struct quota_info {
 	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
-int register_quota_format(struct quota_format_type *fmt);
+void register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
 struct quota_module_name {
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4617,11 +4617,7 @@ void __init shmem_init(void)
 	shmem_init_inodecache();
 
 #ifdef CONFIG_TMPFS_QUOTA
-	error = register_quota_format(&shmem_quota_format);
-	if (error < 0) {
-		pr_err("Could not register quota format\n");
-		goto out3;
-	}
+	register_quota_format(&shmem_quota_format);
 #endif
 
 	error = register_filesystem(&shmem_fs_type);
@@ -4650,7 +4646,6 @@ out1:
 out2:
 #ifdef CONFIG_TMPFS_QUOTA
 	unregister_quota_format(&shmem_quota_format);
-out3:
 #endif
 	shmem_destroy_inodecache();
 	shm_mnt = ERR_PTR(error);


