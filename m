Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062565;
	b=e4TzxQuAp5WyXD5fkQb0BeeUD1yd4y0pOYxD5XXAebJZt8jSj6BWwP59GjbAVzg4zsKW
	 X/ZEENBbe4EUl3QuBzTBhp3q8pnNnoUdcznzxofL3MPcDha4F4tDnk9U4pDnp+nA7+yQx
	 yR3t6/onbLcn2XmHRk7X6ePVVlZV0SkSHo0VAzIxUJ6/q0OADG+Wj/Gml5Z1W3SzZt/oZ
	 OVhiHnIuttp3T+6/zVsZo1kR8bN5uGYNsuItUDgbIbOyqaeO69K5afjLgBv8BhI79mJNQ
	 bEsEER9kT1mCL+NrkDmhOFKeTe6oYcTVxkGP8CsZwWZqNSCHS9o4XFqIQ17eRsozpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INaoWl4eTChVSk4TP49vxgOcaZ3h5fyllubX5DNHrGQ=;
	b=4IZkySPDGsdDIseKCK1tIna8fAMnQ0z4Rz9IrAYWGWo80WP7DU8kiAsuAEs5hyvdT0yY
	 cnLYt7kvt/FPcaPd6sj1nTlQ4znozBvFi8fyxFGDJPJt3aEnwQ51pwvoDjTOjEUse7xtD
	 8Rxd/78RC/KtDlB6Y5/xAuxvm9NFX/rubcMKF3fJAMuLyLWJr6vuQL1QCG82/PHYlEp5G
	 H7CnTQYej7e0T30pm5r4L0giT3GPNa0ckVM0D/sO4V7Imyz0Z3xiHQrs0lMRWJ0GeZRo0
	 3l0j7M2FiiumgPNp8s31PufeBNhG9A/xEjaG6orMZKxqHlbRXZYTUDmHsSnVdefhPTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpvN1Q2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF02606A333;
	Sat,  7 Nov 2026 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpvN1Q2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25131F0089F;
	Sat,  7 Nov 2026 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062564;
	bh=INaoWl4eTChVSk4TP49vxgOcaZ3h5fyllubX5DNHrGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpvN1Q2p8oXX5EAKVFfoespxcXXsQVRzQCH+rK0ZRIbtTtbrEs+AnpRiOWkkBeJ/a
	 uGlLBjt5bYCFl5mzuoUPjpPKT0h02X3IZZazIL9r+Zs8emWuQSO+IIfUw16oex3D5J
	 v1BfkdiipEExJEsb8ISk2Fmui45sNOjw/CFngqPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1400/1536] ocfs2: deal with legacy signed xattr name hash values
Date: Sat,  7 Nov 2026 08:56:56 -0500
Message-ID: <20261107135037.144082679@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 824d26d11448b4d4f19677bce27c7fe5e962f4c6 ]

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in ocfs2_xattr_name_hash():

	hash = (hash << OCFS2_HASH_SHIFT) ^
	       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
	       *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends, so the
hash no longer matches the xe_name_hash an older kernel stored.  An
indexed xattr tree is searched by that hash alone, and both the bucket
binary search and the entry scan within it stop as soon as the wanted
hash falls below an entry's, so the entry is never reached: getxattr,
setxattr and removexattr return -ENODATA for a name that listxattr
still lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
stored under the unsigned hash.  Skip the retry when the two hashes are
equal, so that a miss on an ASCII name does not walk the tree twice.

A miss is not empty handed: ocfs2_xattr_bucket_find() leaves xs->bucket
holding the bucket a new entry would go into.  So after a double miss
drop it and search once more with the unsigned hash, otherwise a new
entry would be placed by its legacy hash and stored under its unsigned
one, breaking the ordering the search relies on.

Only indexed trees are affected; inline xattrs and non-indexed xattr
blocks compare names with memcmp and never look at the hash.

Also spell out the signedness instead of leaving the current hash to
-funsigned-char, as commit 854f0912f813 ("ext4: make xattr char
unsignedness in hash explicit") did, so that both variants stay correct
if this is backported to a kernel without the flag.

Link: https://lore.kernel.org/20261009083002.2621201-4-joseph.qi@linux.alibaba.com
Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 93 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8689a1ba0e43a..de4a7070d4ac5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -557,9 +557,10 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
 	return handler ? xattr_prefix(handler) : NULL;
 }
 
-static u32 ocfs2_xattr_name_hash(struct inode *inode,
-				 const char *name,
-				 int name_len)
+static u32 __ocfs2_xattr_name_hash(struct inode *inode,
+				   const char *name,
+				   int name_len,
+				   bool legacy_signed)
 {
 	/* Get hash value of uuid from super block */
 	u32 hash = OCFS2_SB(inode->i_sb)->uuid_hash;
@@ -568,13 +569,30 @@ static u32 ocfs2_xattr_name_hash(struct inode *inode,
 	/* hash extended attribute name */
 	for (i = 0; i < name_len; i++) {
 		hash = (hash << OCFS2_HASH_SHIFT) ^
-		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
-		       *name++;
+		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT));
+		if (legacy_signed)
+			hash ^= (signed char)name[i];
+		else
+			hash ^= (unsigned char)name[i];
 	}
 
 	return hash;
 }
 
+static u32 ocfs2_xattr_name_hash(struct inode *inode,
+				 const char *name,
+				 int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, false);
+}
+
+static u32 ocfs2_xattr_name_hash_signed(struct inode *inode,
+					const char *name,
+					int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, true);
+}
+
 static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 {
 	return namevalue_size(name_len, value_len) +
@@ -4164,11 +4182,12 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_xattr_index_block_find(struct inode *inode,
-					struct buffer_head *root_bh,
-					int name_index,
-					const char *name,
-					struct ocfs2_xattr_search *xs)
+static int __ocfs2_xattr_index_block_find(struct inode *inode,
+					  struct buffer_head *root_bh,
+					  int name_index,
+					  const char *name,
+					  u32 name_hash,
+					  struct ocfs2_xattr_search *xs)
 {
 	int ret;
 	struct ocfs2_xattr_block *xb =
@@ -4177,7 +4196,6 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
 	u64 p_blkno = 0;
 	u32 first_hash, num_clusters = 0;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
@@ -4208,6 +4226,59 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_xattr_index_block_find(struct inode *inode,
+					struct buffer_head *root_bh,
+					int name_index,
+					const char *name,
+					struct ocfs2_xattr_search *xs)
+{
+	u32 name_hash, legacy_hash;
+	int name_len = strlen(name);
+	int ret;
+
+	name_hash = ocfs2_xattr_name_hash(inode, name, name_len);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     name_hash, xs);
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been stored by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * Skip the retry when the two hashes are equal, so that a name made
+	 * only of ASCII does not have to walk the tree twice.
+	 */
+	legacy_hash = ocfs2_xattr_name_hash_signed(inode, name, name_len);
+	if (legacy_hash == name_hash)
+		return ret;
+
+	/*
+	 * A miss still leaves xs->bucket holding the bucket a new entry would
+	 * be inserted into, so drop it before searching again.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     legacy_hash, xs);
+	if (!ret) {
+		pr_warn_once("ocfs2: xattr tree with signed name hash\n");
+		return ret;
+	}
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Not under either hash.  Restore the unsigned placement, since that
+	 * is where a new entry is stored: leaving the bucket where the legacy
+	 * hash put it would break the ordering the search relies on.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	return __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					      name_hash, xs);
+}
+
 static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 				       u64 blkno,
 				       u32 clusters,
-- 
2.53.0



