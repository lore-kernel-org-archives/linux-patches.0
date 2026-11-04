Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829467;
	b=qrioh3TM1T226s8+rYU6DT5chhRXlU1sJg+C6OXVEfUPwGZL9/PsvRkr7FrRNuFlbM1m
	 bY3j8MfaF3jpVcsOmfrys1ME24jjjEsnj3sYwEzcF+mvsf1uN7BjILZ1rtZ9SjOew3hMJ
	 CGNP7OsjwKstQL1KMw1FYU9vEqqba6nOs2bU5Pcl9kpy9vZI2R8w/lY3lMbR+RoO7pGzp
	 Q3QOCedUe2wr/pSbn+wZl3a5oKI2qAKjA4uEs14TiuDAbNlJ+UsnE+VkCdJJh8LJEsKz1
	 Zdr+L/5Is8UoS1sQofdjI8K7V+7jfrvKB9VEhHDJF7WUPZiXN9giLSUeZ+UCPTei5DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7l9UbRRCFuJIz0HfX3Ckc+CWUo+lJB2xiUtRjZQEyo=;
	b=XK05w4xLNYsT4NwKiWnziWAxcsVouZLSWtL4k0j8U3uEakafvYsEAi7+AP9fDeRM4sOL
	 N+SepRf6YJ7lHFNVNQfwNzfRCiUny0Jl3p0y4B8ZFHYFT1RGmdoAA34p9EY7IS0MZNpFK
	 DrU9Mpzkut6FqePphIbDFl4oo2pD5RVZKYqU9MEQ8Gu6+NCdQ76WsL2+KpCgk2SgVyPsg
	 E8G8L0D8SPNurhkRsjvjMfaY4kYmxAKM2NVQ0avubR/DFDSUafAZAvla+9CatIR4hwVI1
	 lIg87GD3jBewj0HzSdZfmUv4hzfx+fl/lPuBzC5od3T8SFlspCGriALu/U/Z94+0Gtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRHOkrlD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02E606AB0B;
	Wed,  4 Nov 2026 21:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRHOkrlD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD091F000C1;
	Wed,  4 Nov 2026 21:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829467;
	bh=b7l9UbRRCFuJIz0HfX3Ckc+CWUo+lJB2xiUtRjZQEyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRHOkrlDyDIqz5SP9MF5bFNedewgQXqgbYwMbxwGPPIV+4DHgVH7lPKMcVgnxcvpc
	 PI6w0N0wFG+szlzbZBxDQvCK18tL0OHCj+PBkvGuNMsxr/pEQNBlSv7NjSiq+9W2gM
	 6PG2RubjDU7feCnur4L1FTDRXsnMwHz4EsWFB2gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97e301b4b82ae803d21b@syzkaller.appspotmail.com,
	George Anthony Vernon <contact@gvernon.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	David Maximiliano Hermitte <davemadmaxxx@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0144/1005] hfs: validate catalog CNIDs before instantiating inodes
Date: Wed,  4 Nov 2026 15:57:57 -0500
Message-ID: <20261104211047.739677656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: David Maximiliano Hermitte <davemadmaxxx@gmail.com>

[ Upstream commit 53c3c138d672765c26884c55728307a65c634328 ]

hfs_cat_find_brec() first resolves a catalog thread record by CNID and
then looks up the corresponding catalog record by parent/name. On a
corrupted filesystem image, the second lookup may find a record whose
CNID does not match the CNID that was requested.

Validate the record found by the second lookup before returning it.
Read the already-found record with hfs_bnode_read(), require the exact
fixed size for file and directory records, reject other record types,
and verify that the stored CNID matches the requested CNID.

Also validate reserved CNIDs in hfs_read_inode() before populating the
inode, propagate hfs_read_inode() failures from the resource-fork lookup
path, and reject bad resource-fork and root inodes.

Keep hfs_write_inode() unchanged, so corrupted catalog records are
rejected before reaching its existing reserved-CNID BUG() path.

Reported-by: syzbot+97e301b4b82ae803d21b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97e301b4b82ae803d21b
Cc: George Anthony Vernon <contact@gvernon.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Maximiliano Hermitte <davemadmaxxx@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260708215636.73815-1-davemadmaxxx@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/catalog.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 fs/hfs/hfs_fs.h  | 19 +++++++++++++++++++
 fs/hfs/inode.c   | 13 ++++++++++++-
 fs/hfs/super.c   |  5 +++++
 4 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index ccdbbffaaf7c1..f3fd84cffed5f 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -182,6 +182,40 @@ int hfs_cat_keycmp(const btree_key *key1, const btree_key *key2)
 			  key2->cat.CName.name, key2->cat.CName.len);
 }
 
+static int hfs_cat_validate_found_cnid(struct hfs_find_data *fd, u32 cnid)
+{
+	hfs_cat_rec rec;
+	u32 found_cnid;
+	int rec_len;
+
+	rec_len = fd->entrylength;
+	if (rec_len <= 0 || (size_t)rec_len > sizeof(rec))
+		return -EIO;
+
+	memset(&rec, 0, sizeof(rec));
+	hfs_bnode_read(fd->bnode, &rec, fd->entryoffset, rec_len);
+
+	switch (rec.type) {
+	case HFS_CDR_FIL:
+		if ((size_t)rec_len != sizeof(struct hfs_cat_file))
+			return -EIO;
+		found_cnid = be32_to_cpu(rec.file.FlNum);
+		break;
+	case HFS_CDR_DIR:
+		if ((size_t)rec_len != sizeof(struct hfs_cat_dir))
+			return -EIO;
+		found_cnid = be32_to_cpu(rec.dir.DirID);
+		break;
+	default:
+		return -EIO;
+	}
+
+	if (found_cnid != cnid)
+		return -EIO;
+
+	return 0;
+}
+
 /* Try to get a catalog entry for given catalog id */
 // move to read_super???
 int hfs_cat_find_brec(struct super_block *sb, u32 cnid,
@@ -208,7 +242,12 @@ int hfs_cat_find_brec(struct super_block *sb, u32 cnid,
 		return -EIO;
 	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
-	return hfs_brec_find(fd);
+
+	res = hfs_brec_find(fd);
+	if (res)
+		return res;
+
+	return hfs_cat_validate_found_cnid(fd, cnid);
 }
 
 static inline
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 86b5ae62247be..724b28bb8c6c4 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -156,6 +156,25 @@ extern int hfs_cat_move(u32 cnid, struct inode *src_dir,
 extern void hfs_cat_build_key(struct super_block *sb, btree_key *key,
 			      u32 parent, const struct qstr *name);
 
+/*
+ * Validate the CNID of a catalog record.
+ */
+static inline bool hfs_is_valid_cnid(u32 cnid, u8 type)
+{
+	if (likely(cnid >= HFS_FIRSTUSER_CNID))
+		return true;
+
+	switch (cnid) {
+	case HFS_ROOT_CNID:
+		return type == HFS_CDR_DIR;
+	case HFS_EXT_CNID:
+	case HFS_CAT_CNID:
+		return type == HFS_CDR_FIL;
+	default:
+		return false;
+	}
+}
+
 /* dir.c */
 extern const struct file_operations hfs_dir_operations;
 extern const struct inode_operations hfs_dir_inode_operations;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index f1796e4b07e83..e815e9a8ac6f2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -365,6 +365,9 @@ static int hfs_read_inode(struct inode *inode, void *data)
 	rec = idata->rec;
 	switch (rec->type) {
 	case HFS_CDR_FIL:
+		if (!hfs_is_valid_cnid(be32_to_cpu(rec->file.FlNum), rec->type))
+			return -EIO;
+
 		if (!HFS_IS_RSRC(inode)) {
 			hfs_inode_read_fork(inode, rec->file.ExtRec, rec->file.LgLen,
 					    rec->file.PyLen, be16_to_cpu(rec->file.ClpSize));
@@ -386,6 +389,9 @@ static int hfs_read_inode(struct inode *inode, void *data)
 		inode->i_mapping->a_ops = &hfs_aops;
 		break;
 	case HFS_CDR_DIR:
+		if (!hfs_is_valid_cnid(be32_to_cpu(rec->dir.DirID), rec->type))
+			return -EIO;
+
 		inode->i_ino = be32_to_cpu(rec->dir.DirID);
 		inode->i_size = be16_to_cpu(rec->dir.Val) + 2;
 		HFS_I(inode)->fs_blocks = 0;
@@ -565,13 +571,18 @@ static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
 	if (!res) {
 		struct hfs_iget_data idata = { NULL, &rec };
-		hfs_read_inode(inode, &idata);
+		res = hfs_read_inode(inode, &idata);
 	}
 	hfs_find_exit(&fd);
 	if (res) {
 		iput(inode);
 		return ERR_PTR(res);
 	}
+
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		return ERR_PTR(-EIO);
+	}
 	HFS_I(inode)->rsrc_inode = dir;
 	HFS_I(dir)->rsrc_inode = inode;
 	igrab(dir);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 97546d6b41f47..933aa04480899 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -372,6 +372,11 @@ static int hfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root_inode)
 		goto bail_no_root;
 
+	if (is_bad_inode(root_inode)) {
+		iput(root_inode);
+		goto bail_no_root;
+	}
+
 	set_default_d_op(sb, &hfs_dentry_operations);
 	res = -ENOMEM;
 	sb->s_root = d_make_root(root_inode);
-- 
2.53.0



