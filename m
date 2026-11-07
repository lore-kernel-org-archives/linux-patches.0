Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065199;
	b=49lKS15H2ATjTH2MFNFDM9NoR0UAD4RwS+tXRPVd/9f5xCiDR7IaqpNmXN9i7J8myW+r
	 6mrM8FEHBEOPy+4jOHbfR8SA6wrpFWFz8N1XKlPs6vZz2Ld7o+qmo0uQygB9kPF1czE98
	 9NW4lMfnzm0IAZ25r4kWsVkt5nFDTZxTy+kncZjKmfUtumZSQ+x9+SGQcAc567c06EDLN
	 WZ1ncLm+t4krhNW4ef54Ht83EjLF+UPx86ou9aJwaOh4lJs4R3/29TNmEWf2AqLGl8sQt
	 k3IE+gXR1ajwkmBCnPXrL012d2jler6/Yy33O0C6zlaQ0JoQF1jDA4Ze+SnlFW87i2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrTLpppY0UxOO1f+LQD+ngUR24HjmIKbMGDhrrmXx+w=;
	b=Sl/chj3A4G9LHTmLQ/fNDwVgyuCQw0eImntn7IfUvk7037/KOcvO2IxYdd1iMtRo4jed
	 BR4mWo7l+WBWKpuzzsGbe4AybQees9zGhmKBu3GhP2hHYyaNXyWcJW5VfJAP1pxMo8lv+
	 KgFOhUb9MO6whkd/dUa6+ZSG01LEE+LnV/hA93HG0ZMj4iKl3cRd8g2S4XVw7sBtMUYiz
	 xRhBbMdpEwSN0qgREYjUXqOVVDRh2P6OKM0Chcu5XIS5O0E0tdlh3yxTnXddfyctGZtTD
	 ikUajl9SwWwdbW1u0TStlsHn2aLXC09QEND62R3MipHKtENJJ88shz/9gEUyl6foCmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfeo20IM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5615606A32E;
	Sat,  7 Nov 2026 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfeo20IM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665F11F0089F;
	Sat,  7 Nov 2026 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065198;
	bh=NrTLpppY0UxOO1f+LQD+ngUR24HjmIKbMGDhrrmXx+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfeo20IMjGOBLpdFsUDm/I1cVtPNbGb4O00U0wzIH9Yjx+HtJNZn8rKqCul05k51/
	 AvlO1I5kn/uVW971BLcNC030DTNaBzcY3eVzo7NYpWbWgg3nB+/hYlOQ6p/SlQNGA1
	 9apMjLf2N5eGPDBv6CPg8DZe26bgdfxA58MaGoBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0998/1257] ocfs2: deal with legacy signed dir index name hash values
Date: Sat,  7 Nov 2026 08:54:54 -0500
Message-ID: <20261107135006.920846185@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d1b49d5ea1bf43cce2b0e249a7f7a30dde133907 ]

Patch series "ocfs2: deal with legacy signed name hash values", v2.

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") turned on
-funsigned-char globally, which changed the result of two naked 'char'
loads in ocfs2 hashing code:

	str2hashbuf()            val = msg[i] + (val << 8);
	ocfs2_xattr_name_hash()  hash = (hash << 5) ^ (hash >> 27) ^ *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends.  Both
results are written to disk, the first into the dx leaf when a directory
entry is indexed and the second into xe_name_hash when an xattr is
stored, so anything written by a pre-6.2 kernel is looked up under a
different hash and is no longer found.  readdir and listxattr still list
those names because neither of them hashes, which makes this look like
the filesystem losing entries rather than like a lookup bug.  Anderson
Ferneda reported it that way for directories with non-ASCII names [1].

Patches 1 and 3 do what ext4 did in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values"): look up with the current
unsigned hash, retry with the legacy signed one on a miss, and always
store new entries under the unsigned hash.  The retry is skipped when the
two hashes come out equal, so an ASCII name does not walk the index
twice.  Both hash functions now spell out the signedness instead of
leaving it to -funsigned-char, as commit 854f0912f813 ("ext4: make xattr
char unsignedness in hash explicit") did, so a backport to a kernel
without the flag still computes both variants correctly.

Patch 2 is a separate fix, placed before patch 3 so that every commit in
the series is correct on its own.  ocfs2_check_xattr_bucket_collision()
recomputes the hash of the name to decide whether splitting a full bucket
can make room for the entry being set.  That is right for a new entry and
wrong for one that already exists, since an update leaves xe_name_hash
alone.  Against a bucket holding legacy hashes the comparison does not
match, so the split goes ahead and cannot help: a bucket whose entries
all share one hash has no divide position.  How that ends depends on
where the unsigned hash sorts.  Below the legacy ones, the set fails with
-ENOSPC after growing the tree for nothing.  Above them, it lands in the
empty bucket the split just appended and stores a second copy of the
entry there while the original stays behind, so listxattr reports the
name twice.  Using the stored hash closes both.

Nothing retires a legacy hash at runtime.  Deleting or updating an entry
does not rewrite it, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion, so the
retry stays for as long as the legacy entries do.  Rebuilding the index
offline is what removes it for good.

This patch (of 3):

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in str2hashbuf():

	val = msg[i] + (val << 8);

A name byte >= 0x80 used to sign-extend and now zero-extends, so
ocfs2_dx_dir_name_hash() computes a different hash pair for every name
containing one.  The pair is written into the dx leaf when the entry is
created, so an index built by an older kernel no longer matches and
ocfs2_dx_dir_search() returns -ENOENT for a name that readdir still
lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
indexed under the unsigned hash.  Skip the retry when the two hashes
are equal, so that a miss on an ASCII name does not walk the index
twice.

The retry costs a second walk of the dx tree, so a negative lookup of a
name containing a byte >= 0x80 does twice the work.  That is bounded and
worth it, and directories whose dx root is still inline pay nothing
extra, since there the retry only rescans the root block that is already
loaded.  Nothing retires it at runtime: a legacy entry keeps its legacy
hash, because neither deleting nor updating an entry rewrites the dx
hash, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion.
Rebuilding the index offline is what removes the cost for good.

Also spell out the signedness in str2hashbuf() instead of leaving the
current hash to -funsigned-char, as commit 854f0912f813 ("ext4: make
xattr char unsignedness in hash explicit") did, so that both variants
stay correct if this is backported to a kernel without the flag.

Link: https://lore.kernel.org/20261009083002.2621201-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261009083002.2621201-2-joseph.qi@linux.alibaba.com
Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Anderson Ferneda <anderson.ferneda@braza.com.br>
Closes: https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dir.c | 76 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0075e1624310e..b358b58a121dc 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -221,7 +221,8 @@ static void TEA_transform(__u32 buf[4], __u32 const in[])
 	buf[1] += b1;
 }
 
-static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
+static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
+			bool legacy_signed)
 {
 	__u32	pad, val;
 	int	i;
@@ -235,7 +236,10 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
 	for (i = 0; i < len; i++) {
 		if ((i % 4) == 0)
 			val = pad;
-		val = msg[i] + (val << 8);
+		if (legacy_signed)
+			val = (signed char)msg[i] + (val << 8);
+		else
+			val = (unsigned char)msg[i] + (val << 8);
 		if ((i % 4) == 3) {
 			*buf++ = val;
 			val = pad;
@@ -248,8 +252,9 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
 		*buf++ = pad;
 }
 
-static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
-				   struct ocfs2_dx_hinfo *hinfo)
+static void __ocfs2_dx_dir_name_hash(struct inode *dir, const char *name,
+				     int len, struct ocfs2_dx_hinfo *hinfo,
+				     bool legacy_signed)
 {
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	const char	*p;
@@ -279,7 +284,7 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
 
 	p = name;
 	while (len > 0) {
-		str2hashbuf(p, len, in, 4);
+		str2hashbuf(p, len, in, 4, legacy_signed);
 		TEA_transform(buf, in);
 		len -= 16;
 		p += 16;
@@ -290,6 +295,19 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
 	hinfo->minor_hash = buf[1];
 }
 
+static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
+				   struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, false);
+}
+
+static void ocfs2_dx_dir_name_hash_signed(struct inode *dir, const char *name,
+					  int len,
+					  struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, true);
+}
+
 /*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
@@ -966,10 +984,10 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_dx_dir_search(const char *name, int namelen,
-			       struct inode *dir,
-			       struct ocfs2_dx_root_block *dx_root,
-			       struct ocfs2_dir_lookup_result *res)
+static int __ocfs2_dx_dir_search(const char *name, int namelen,
+				 struct inode *dir,
+				 struct ocfs2_dx_root_block *dx_root,
+				 struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
 	u64 phys;
@@ -982,8 +1000,6 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	struct ocfs2_extent_list *dr_el;
 	struct ocfs2_dx_entry_list *entry_list;
 
-	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
-
 	if (ocfs2_dx_root_inline(dx_root)) {
 		entry_list = &dx_root->dr_entries;
 		goto search;
@@ -1080,6 +1096,44 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	return ret;
 }
 
+static int ocfs2_dx_dir_search(const char *name, int namelen,
+			       struct inode *dir,
+			       struct ocfs2_dx_root_block *dx_root,
+			       struct ocfs2_dir_lookup_result *res)
+{
+	struct ocfs2_dx_hinfo legacy;
+	int ret;
+
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret != -ENOENT)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been indexed by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * New entries are always indexed under the unsigned hash, so only fall
+	 * back to the legacy signed one when it can actually differ: an ASCII
+	 * name hashes the same either way, and a genuine miss on one should
+	 * not have to walk the index twice.
+	 */
+	ocfs2_dx_dir_name_hash_signed(dir, name, namelen, &legacy);
+	if (legacy.major_hash == res->dl_hinfo.major_hash &&
+	    legacy.minor_hash == res->dl_hinfo.minor_hash)
+		return ret;
+
+	res->dl_hinfo = legacy;
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret)
+		return ret;
+
+	pr_warn_once("ocfs2: directory index with signed name hash\n");
+
+	return 0;
+}
+
 static int ocfs2_find_entry_dx(const char *name, int namelen,
 			       struct inode *dir,
 			       struct ocfs2_dir_lookup_result *lookup)
-- 
2.53.0



