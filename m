Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062342;
	b=KUt7rZC21KScSNdmU8DHnOtxnz7PAXgw+L31inypHvW8d9tbfm2dronFvGGlKZd50K/8
	 ZKdjNhXEpxY5uyFiwIf7DEf7VgS9okaus+bvhPJQeF3bPdKearwQh609gSYjHdCAYY2eN
	 M9HtH7uqXKWtcbdrSOqe9PGCf8J41BDasExs2bbXaUWyO24J7Yfb24aDw39bD5A0FiGP7
	 P092Q6K5Vn77DF//3e20YQjKJ+vrW4WHxOn+Nhf44pHr5/yqCmfU/IHCkP7vdp73ogUlx
	 ja+0F5QALDlWImuYm2URUJ48wKWOcb6vZuua4ExIPrDoXOmjPIusyySJcd9mOQuST3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ak+FplF4N+7NxsnNBeQ6ezl1n0qOfjstb4SVq3ehhvk=;
	b=G+4j875AV/9dgBMw2acsi5uJPTsQII6tn55QylcDiYNii27y01L5E7qgJtHSQ6Pf/FU5
	 ik7pGFvyGWSoYG0HdFFR64FQN0p9z7ktqBFZczGpKC/yB0Xttwy3dpkmGucICQS369SB3
	 uXAU4N2Ekv5izlwbOmQL/ZYKDWQL9YDom6A7p2liv25qYQsJ8TKvpkT8MWbTYttD9F3Hv
	 aJgcOaA1dKlYtqayCYjH9aQ5vOt5Em+R5HnFLpHyQj5n4sP8FUEYn3WpNAKaiLcphacID
	 Lb6ElpZQwYCTIM+Y5Bd5u3DOJqeo3sNzD4Fnto2FLPX+uTh/J69JAViCCq3LZVj7aOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrcMqZPB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792C26082BC0;
	Sat,  7 Nov 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OrcMqZPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4D41F008A1;
	Sat,  7 Nov 2026 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062342;
	bh=ak+FplF4N+7NxsnNBeQ6ezl1n0qOfjstb4SVq3ehhvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrcMqZPB3mIxgt9YcqrGWw3lgwGRjNVqIFqny+w7dpxNXULPijPk2OkqayIIPbOCR
	 VD81whfRo70B0I56nrBxpfpgyhWmn7oxnwBsON0fOyHxqSlVe3X1EBx8wI8Tw57nsS
	 ZThZoRXokLXyzjV7J1EdGJVs0RMx5Ckg/zdBC2Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1270/1536] f2fs: convert inline quota files when turning quota on
Date: Sat,  7 Nov 2026 08:54:46 -0500
Message-ID: <20261107135033.444639153@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit a85e09bd6cc80059b9e0ef5cd1467719aa3129a8 ]

With a block size larger than 4KB, the inline data area is large enough
to hold a freshly created quota file (quotacheck writes 6KB), so
aquota.user/aquota.group stay inline after quotaon. f2fs does not
expect quota files to be inline, and this causes two problems:

1. Quota file corruption. f2fs_write_single_data_page() sends quota
   inodes straight to f2fs_do_write_data_page(), which sees NULL_ADDR
   for index 0, treats the folio as truncated and drops it. Updates to
   the quota file are lost once the folio is reclaimed, so the quota
   tree reads stale data: chown/chgrp fail with EIO and quota entries
   of users disappear. For example, the kernel log shows:

     find_free_dqentry: Data block full but it shouldn't
     qtree_write_dquot: Error -5 occurred while creating quota

2. Deadlock. Writing a quota file past MAX_INLINE_DATA converts it from
   f2fs_write_begin() under f2fs_lock_op(). dquot_transfer() is called
   from f2fs_setattr() with f2fs_lock_op() already held, so chown/chgrp
   take cp_rwsem for read twice and hang, together with the checkpoint
   and every other writer, once a checkpoint waits for cp_rwsem in
   between (seen with generic/232).

Quota files only grow and there are at most MAXQUOTAS of them, so there
is no point in keeping them inline. Convert them in f2fs_quota_on() and
after dquot_quota_on_mount(), which keeps every block size on the same
path as 4KB blocks, where quota files never fit inline. Quota sysfiles
are created by mkfs with real blocks and are not affected.

Cc: stable@kernel.org
Fixes: d7e9a9037de2 ("f2fs: Support Block Size == Page Size")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c278ce7842056..1e5aea6352497 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2823,15 +2823,42 @@ static qsize_t *f2fs_get_reserved_space(struct inode *inode)
 	return &F2FS_I(inode)->i_reserved_quota;
 }
 
+/*
+ * Quota files only grow and there are at most MAXQUOTAS of them, so there is
+ * no point in keeping them inline. Writeback of quota files does not handle
+ * inline data and would drop what was written to them.
+ */
+static int f2fs_quota_convert_inline(struct inode *inode)
+{
+	int err;
+
+	if (!f2fs_has_inline_data(inode))
+		return 0;
+
+	inode_lock(inode);
+	err = f2fs_convert_inline_inode(inode);
+	inode_unlock(inode);
+	return err;
+}
+
 static int f2fs_quota_on_mount(struct f2fs_sb_info *sbi, int type)
 {
+	int err;
+
 	if (is_set_ckpt_flags(sbi, CP_QUOTA_NEED_FSCK_FLAG)) {
 		f2fs_err(sbi, "quota sysfile may be corrupted, skip loading it");
 		return 0;
 	}
 
-	return dquot_quota_on_mount(sbi->sb, F2FS_OPTION(sbi).s_qf_names[type],
+	err = dquot_quota_on_mount(sbi->sb, F2FS_OPTION(sbi).s_qf_names[type],
 					F2FS_OPTION(sbi).s_jquota_fmt, type);
+	if (err)
+		return err;
+
+	err = f2fs_quota_convert_inline(sb_dqopt(sbi->sb)->files[type]);
+	if (err)
+		dquot_quota_off(sbi->sb, type);
+	return err;
 }
 
 int f2fs_enable_quota_files(struct f2fs_sb_info *sbi, bool rdonly)
@@ -3043,6 +3070,10 @@ static int f2fs_quota_on(struct super_block *sb, int type, int format_id,
 
 	inode = d_inode(path->dentry);
 
+	err = f2fs_quota_convert_inline(inode);
+	if (err)
+		goto out;
+
 	err = filemap_fdatawrite(inode->i_mapping);
 	if (err)
 		goto out;
-- 
2.53.0



