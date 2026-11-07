Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064815;
	b=T/mfLtuRAzNbHGXZ21jzvVrDo+3rDBj3r2PNBq+LdcTr0QIwEzBDHYbFbdqwwdOn98Wp
	 vZz7zucUtT1HJGpJu75szM/YL7LoU/mVcs0KfGfMNbOWF2YxAvWW7LKUJecpvH2gnDtO0
	 cpO6GVkEokZVk4FntCkG3up5aLQsFeMhkiRI99tJCoSTmwmvZY1xoie6Xh25lO5AXuPvR
	 5x6eZuhx+mzHmjUQFXcsdEB1wXRJmkDlMJ9OwXifiSQXN1UBCOV1FV884WCT2JK7G4tim
	 eBHwhJTy0vAkeB4tibe3evo5nRUSAsX3sIqSLE3CcBP5uNzl8+v+Zmabgcg4rfvwm3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8htte6Vwab+0RF+kTlIgCLdqOq5rs5CU3s9zENGgMVw=;
	b=i42H+XWJ/w/qzGCrQAsJiVhYUWBfEg2/PFGmSOFqYY30WVPUm4wHZ4SDX79SoMIj2qo4
	 406e3yM3JT+6fLnTQLLYGNoTj825ibL427bgHxC2O+xsGFaJrSUpJ+InjPPWGp2lm+WtM
	 wyu9APrjaH3/tQ8OvP/VhC2h8iZNgJXquTLOQ/OLjb5X91ogPaL7ud7UA+SlstNKUWjJ6
	 V4aW/RxBYuWzPKi6GKJIkJ0BPFMWtSc3c+VvZzurMuaMl32R7mFP07iRgnYPLZQfP3YJ4
	 HPm+XC39CniAMx7PevctWKOp9lN06XHLSIrZuy4TRNJgnxSpgnSRW1RlqpCC9yMnHVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FLFn1/lj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB55606C03C;
	Sat,  7 Nov 2026 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLFn1/lj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57BD1F008A1;
	Sat,  7 Nov 2026 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064815;
	bh=8htte6Vwab+0RF+kTlIgCLdqOq5rs5CU3s9zENGgMVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLFn1/ljryWz93PxZuDQjweFCfniEiCQJihJg6pB5JsUcrNBezQng6LFnhEBkIrKy
	 ovtP7i/htOFMeAm8RLAMvIS5VpWiNK3JrX0KQSTXDBbxPxA9XvuNzOPWXs8PXDSrBw
	 h5w7QBel4I66DxRgQ93Cx0GKvCenidwI7NWd8CuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0714/1257] f2fs: convert inline quota files when turning quota on
Date: Sat,  7 Nov 2026 08:50:10 -0500
Message-ID: <20261107134958.978097860@linuxfoundation.org>
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
index 1314b6ccced98..137b123777edc 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3305,15 +3305,42 @@ static qsize_t *f2fs_get_reserved_space(struct inode *inode)
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
@@ -3518,6 +3545,10 @@ static int f2fs_quota_on(struct super_block *sb, int type, int format_id,
 
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



