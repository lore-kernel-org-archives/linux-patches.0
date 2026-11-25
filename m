Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618404;
	b=e8d5jwHVOpkCAd/F2noaaHXoMLXpcrWDWI12VArUKWJOD62g6r3kV+4XzNGoS2bLrd8M
	 SuVspAh9O/qpMLYyldSmUrViZGt4TjvOES7tKBnqyMEOfNsYdtwVSeNYedH7QjsNzLogM
	 /nkf7zGkyvliVC5WE4nNGXRGYNkdAlPlflmtpEyo2zSPESLWEyOVj3mP8j3AmzmcDQ6hA
	 hhJPunhLKyuW84+JsGSQ43gTc1sorMwYAzYGU/ViOZWE7v3jOLROvNkdlx3VJ6+I5Aqqy
	 tYsXGqVGoWhxx/ec+4yeT04HqYM0e/n4vbrGw8DppeiTMA5EE3rAl1jPkIROVtbDRTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFg2wmgQuM3R/r7zJUnL83umQbf1+fzEtgB4/8sFTGA=;
	b=u4ETC4/+WPN/OOfa76awqozRexZctMEmjidOhQEZJLCfqHw3199xZM7aielMdMeL3H58
	 X8JQpYBLAVgSu6aILIUxogKJW32ckV6vgNp4b1kfPHPtP/TWlsjdYHmyQZ8pGp3srY4Hr
	 zmpyfQiA6OPIz7SjQwHl0GOLnSz93b6+pbNt639S9IGH385uCE4ZUdqsIJEkktW7U9xhU
	 7EWG0zBErETuO30nFTw8F0jr/QRdCq0bRlOP6rE7w2GQj6uGBdnZZDxrPPQL49N6r56el
	 02s40jYhtmRoL8eqmktOB+PC1j7WBzUcirV/c19hRq8Q2lYq3QpIuJYD2XRRB8S1zsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLpnQF6M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A32606A31E;
	Wed, 25 Nov 2026 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLpnQF6M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880671F000D8;
	Wed, 25 Nov 2026 14:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618404;
	bh=xFg2wmgQuM3R/r7zJUnL83umQbf1+fzEtgB4/8sFTGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLpnQF6MQ5Y1W50/Z2WAqDHp+lK62CqC9p3BcqvNT3cfJ0m/Lur1sZH3M38VI1k2f
	 3Oof5xI3t9Vn2/qlhrohGGQwhIV+axoAkfkJFw385086Gq3E9VJ/Ckf+aVPMDbT5Ce
	 NpJCv7GlQoVQuFUbKWI/jy+OIVlF1Wi9dvroJOso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0270/1005] erofs: treat files shared by inode_share as stacked
Date: Wed, 25 Nov 2026 15:26:48 +0100
Message-ID: <20261125143828.064459665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 7c26dc33ea7bb677db294bfb4e58d4207477c9e3 ]

A file-backed mount whose image or extra device is on a block-backed
EROFS passes erofs_is_stacked_file(). If inode_share shares that file,
erofs_real_inode() may pick an inode of a file-backed EROFS in the same
domain to read it. File-backed reads then nest in the same task.

Treat files that use erofs_ishare_fops as stacked.

Fixes: 34096ba919fd ("erofs: support unencoded inodes for page cache share")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261030-erofs-fileio-bioset-v1-1-caf47adbb3a3@samsung.com
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ee01a5ef85931..e92a7fa90ae34 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -125,9 +125,12 @@ void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 /* see the comment in erofs_fc_fill_super() */
 static bool erofs_is_stacked_file(struct file *file)
 {
-	struct super_block *sb = file_inode(file)->i_sb;
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
 
-	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth;
+	return (sb->s_op == &erofs_sops && !sb->s_bdev) || sb->s_stack_depth ||
+	       (IS_ENABLED(CONFIG_EROFS_FS_PAGE_CACHE_SHARE) &&
+		inode->i_fop == &erofs_ishare_fops);
 }
 
 static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
@@ -713,6 +716,9 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * EROFS is the only fs supporting file-backed mounts for now.
 		 * It MUST change if another fs plans to support them, which
 		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
+		 * Files shared by inode_share may be read through a
+		 * file-backed EROFS in the same domain, so treat them as
+		 * stacked too.
 		 */
 		if (erofs_is_stacked_file(sbi->dif0.file)) {
 			erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
-- 
2.53.0



