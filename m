Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021869;
	b=XX5/fIORf7c39kTw1lu+E70UId1acQ+Py9usZMIkI2vlyAnPiGlLy9CDZ6IXZVUJTLbd
	 bzFW75PweuQeTvDboA9AKxNMrjgZiyl5O86pBVfI1xlYbipCDiRySTuh/+kWdkRy1c4bl
	 zCuRtCHrRde+/eOyGps7qeE5KDE/Ru/G/V7iBpHxuRymzz+/OKp4Ya3GV5wZFdHCKKHtQ
	 hqYFBDuP6Gqt12CuTgejIxQyHI6EPNnssb+/i8v6lAi4JBsLkRCVKz/xih2DxKyC+QqB/
	 DakXlwFnXgkVK1Br4jGSc7+q3d/S6ayVGs4iiKV+vy4ARQ2t9Vp6KA8AWZWjHBRiVLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7I7qK+nagcsoI/QzbDbclQB+wHg2KRva/O9cyN3guM=;
	b=OXuk0KJ/Fnb5W59AbpWOSe/veUVgwyDb9+lA6uq3HLBP2ynlExmfekruzWgIAY2f6dDf
	 +JXfJxm2Y8QfrU44kHakCyFYXPtMBLcs9NeWbmuj5/nW8Gq13TY0YLU5IeH0e3j3BVzDD
	 rdv79kXCarL1HUWQMIqsn5dk46ux38bS07lXFmjC1YUbCvacZv5wvf/0trf5OAn0OWehh
	 /Nt/3ra9faEQI6O7QSo8/W8HbpOtnIHtYQhcmGE9fyuqvjIvsliS90w5MVFoau0kocv6S
	 SUg2NwCON4nJjEKO+osEpRZQkSfp/zLYQBGT8cETY4Vb0quIg35MbtKC5T4csI24L4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiIyDh6V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C259E606A320;
	Wed, 18 Nov 2026 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiIyDh6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238981F000C4;
	Wed, 18 Nov 2026 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021869;
	bh=b7I7qK+nagcsoI/QzbDbclQB+wHg2KRva/O9cyN3guM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiIyDh6VdMCGvvygYo0BezhupC/pukEZ7OQGDm1i7SaNoDIiJg9QEFkvToihhFx5g
	 glUqpC8CoeAgm+BbU1vhiu/mN0QEFKk4K/LqPcQpQbgAIeeS5OxIEv1ga+5VH4BRki
	 r3u1YpA5PR466spoYJXsNUXdSYPc6uAZBBSAUUmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2461/2651] fs: rename vfs_get_super() to get_tree_super() and export it
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150413.645609838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Giuseppe Scrivano <giuseppe@scrivano.org>

[ Upstream commit 64571ba6581695e936cd701e345efdbe43e05920 ]

Rename and export it so filesystems that need a custom superblock
matching policy can reuse it directly instead of open-coding sget_fc()
+ fill_super().  No functional change.

This is a preparatory fix for the next patch.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Link: https://patch.msgid.link/20261002163225.1258203-2-giuseppe@scrivano.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 209108a54561 ("erofs: drop unnecessary .read_folio() checks for file-backed mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c                 | 19 +++++++++++++++----
 include/linux/fs_context.h |  4 ++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index cbcf5faeb78d7..c5a0658f7aaf3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1334,7 +1334,17 @@ static int test_single_super(struct super_block *s, struct fs_context *fc)
 	return 1;
 }
 
-static int vfs_get_super(struct fs_context *fc,
+/**
+ * get_tree_super - Get a superblock, optionally sharing an existing one
+ * @fc: The filesystem context holding the parameters
+ * @test: Comparison function to find a matching existing superblock, or NULL
+ * @fill_super: Helper to initialise a new superblock
+ *
+ * If @test is non-NULL and matches an existing superblock, that superblock is
+ * reused; otherwise a new anonymous superblock is created and initialised with
+ * @fill_super.  Passing NULL for @test always creates a new superblock.
+ */
+int get_tree_super(struct fs_context *fc,
 		int (*test)(struct super_block *, struct fs_context *),
 		int (*fill_super)(struct super_block *sb,
 				  struct fs_context *fc))
@@ -1361,12 +1371,13 @@ static int vfs_get_super(struct fs_context *fc,
 	deactivate_locked_super(sb);
 	return err;
 }
+EXPORT_SYMBOL_GPL(get_tree_super);
 
 int get_tree_nodev(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, NULL, fill_super);
+	return get_tree_super(fc, NULL, fill_super);
 }
 EXPORT_SYMBOL(get_tree_nodev);
 
@@ -1374,7 +1385,7 @@ int get_tree_single(struct fs_context *fc,
 		  int (*fill_super)(struct super_block *sb,
 				    struct fs_context *fc))
 {
-	return vfs_get_super(fc, test_single_super, fill_super);
+	return get_tree_super(fc, test_single_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_single);
 
@@ -1384,7 +1395,7 @@ int get_tree_keyed(struct fs_context *fc,
 		void *key)
 {
 	fc->s_fs_info = key;
-	return vfs_get_super(fc, test_keyed_super, fill_super);
+	return get_tree_super(fc, test_keyed_super, fill_super);
 }
 EXPORT_SYMBOL(get_tree_keyed);
 
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 0d6c8a6d7be21..d1727dffecc5e 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -150,6 +150,10 @@ extern int vfs_parse_fs_param_source(struct fs_context *fc,
 				     struct fs_parameter *param);
 extern void fc_drop_locked(struct fs_context *fc);
 
+int get_tree_super(struct fs_context *fc,
+		   int (*test)(struct super_block *, struct fs_context *),
+		   int (*fill_super)(struct super_block *sb,
+				     struct fs_context *fc));
 extern int get_tree_nodev(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
-- 
2.53.0



