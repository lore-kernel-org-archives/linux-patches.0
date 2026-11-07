Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063566;
	b=R+hNCyu1BNvGMDRdPhWOJXox5S0J1fJA42OtvYnkFTBzMU2FKIvk6h/pH412tFzWNtFX
	 xGuyHDlk7ufiPp8r2jytnRCSdxesAxrzMRw87i+95WttfNRGxhWbKZDmO/vbPIbSfMQk5
	 b+nwsVbHKQznnzr2SYKcAn8VfjLwRlCV3nZ4pGzIRAF44SDOm7ZgjvEs0pUp1vuNQLvnq
	 JXu/abwKN1uqolLMUGT08KnKH67yxK9LcJmaI4FNeVnoIytyzNNehLPat4yZbjNHsm2Q/
	 Faa1xKjQ7CjGqDjiBM4DE01vgvnWVQRYQvbIYqIdv8lUQqk54EfeY44o5QWxWHdSP9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G6bEg3aoKGAbq1nHT9zOB2YBFMSPMH+rRgYFRJGq86k=;
	b=W1sz7XdG0ntW9in0QUWfVOVfJUrs87R5NlXaAqqlnX3KpEyp97yqjoucnU9qprakniuq
	 yBAvtEDHXhPYOyAx2Y4cxDw/4uWE6Q8XTc7Pagmq/0lfuGKlSQ7uSfF9MyfzUveExA5DW
	 khW2SP86d0SKXYy4eRLI0BAedBbr0fyoEIvTgPFgZiM+tkwMysmpCUFy08iKWg5zhGxoN
	 uQAxRI8r0AsJ4MXkwaEQ4815YGwy8xfP5TnVS63qvroCw3tvt0miJ83a7Ct2uoGcrjwxP
	 AIF3wYFn2V/I6hkCNyIyZeDywyVtmI/7g/TvS1V/SAKFnnCzRKQbZw+kFXq4RhHhftg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXfwB9np;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFB606D818;
	Sat,  7 Nov 2026 14:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXfwB9np
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EDD1F008A3;
	Sat,  7 Nov 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063566;
	bh=G6bEg3aoKGAbq1nHT9zOB2YBFMSPMH+rRgYFRJGq86k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXfwB9npDRStOTYwT0PTRuJn2NeCR6R8KuNSzOGFCSCmdNbvLzbmvixGab0uavF+b
	 QoBadxUOlUB2ZhJOG+1DPLdK6+SP92o7GjqS2wPsgyS26hfQKXFTspXNAjW8pISfnt
	 o0lUmN0laaVDQeAi8EUG36rjfsENJ+FYhngKxBqU=
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
Subject: [PATCH 6.18 699/869] ocfs2: deal with legacy signed xattr name hash values
Date: Sat,  7 Nov 2026 08:56:21 -0500
Message-ID: <20261107134916.658803780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 523d5ac597f41..8013451927a83 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -533,9 +533,10 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
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
@@ -544,13 +545,30 @@ static u32 ocfs2_xattr_name_hash(struct inode *inode,
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
@@ -3949,11 +3967,12 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
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
@@ -3962,7 +3981,6 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
 	u64 p_blkno = 0;
 	u32 first_hash, num_clusters = 0;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
@@ -3993,6 +4011,59 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
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



