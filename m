Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036799;
	b=LrXiE12XIQo5IiQHcGK8zfuF6oHZAWNlZ96x+tWMlW0R+taUoMRoa8BF5Bb4LCXclxGh
	 FfE5AVKpyBOfl2DwCe73VFBDx8qog9aZVryQ2X7ryO/0RlRD2XiB6Z9Yt8Kn3J8GLYSJ8
	 VSvOXRs7ip26cTuekp9wBDQfu0ybxcjxmUusbIgpla2N5Wf7aX+WDE/FGAklye7X2uk+R
	 TJgUEbzrB52yhSN4AQt9Oyu+gtoP115yzbNR9mBiR3Q75Qrx0HnamKAlIOZtsjqI5/jjr
	 0P7EOHsoURn2mQdiEINmeoZBgvoMhNO6Ta0tK/0RlZTgXc21YHAAPdP6yK7rfYFPQxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uyL5oJGpMtG0CSH6fJVeMEJe7qU5l9H5c8ibcOSeXZM=;
	b=b/Sy0TmRJarEwjtDz8X1yvKbZDA7+F7jmWEuv1Emtv/gb3vktZclVVctAAEv40Pizi9b
	 a8LGHTM5FKVuwjK3497866aC2v0pVwURBaRbpK13HfrEieZ/6GYuukW6qeb75/pvF2Ycx
	 MmzflkBCkudMxev/nnP5iGHHmlV/fcVeCOfHp6IP0ZV6rDcjgtNcI9k4yyEn38lBvwLJI
	 7s/wt+iPb0LfjKo1c4PJw78E433Cfz7Wq2L5PD9zg+A8V3OnVP/SZYZbMi4YX/okrNuSo
	 5T9ism5joJ2ayhykOVQZtRa0T58mBBtwqJ6rUWhHsSV9f2XWYOQSD9zoUrE1j+dQQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5AxosSy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5AF606A31C;
	Wed, 18 Nov 2026 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5AxosSy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDDA1F000C4;
	Wed, 18 Nov 2026 21:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036799;
	bh=uyL5oJGpMtG0CSH6fJVeMEJe7qU5l9H5c8ibcOSeXZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5AxosSy3edLo8RimPsSc0f3j9F4sFagC6DVs/Be0YaY9jldUmyvKHkDgHVtUFTpt
	 L3yMZ5vFsU20CU9trLqdreSfhI+b/QMwINi25Cc8fg0Bdd+7CjPXeQtjLRYectHlQf
	 b8ejQ0oonOvYl//WJCpOmQOLHvLDI7FJC5I75tlA=
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
Subject: [PATCH 6.6 1187/3318] ocfs2: use the stored hash when checking xattr bucket collision
Date: Wed, 18 Nov 2026 15:30:09 +0100
Message-ID: <20261118150355.765869450@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit e39baff18b85cf8956aee138d7944b6581e8ba36 ]

ocfs2_check_xattr_bucket_collision() decides whether splitting a full
bucket can make room for the entry being set by recomputing the hash of
the name:

	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));

	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
		return 0;

For a new entry that is the hash it will be stored under, so comparing it
is correct.  An existing entry keeps the hash it already has: an update
never rewrites xe_name_hash, since ocfs2_xa_add_entry() is the only
writer of that field for a real entry and ocfs2_xa_prepare_entry() calls
it only when loc->xl_entry is NULL.

An entry stored by a kernel that sign-extended the name bytes when
hashing can still be updated, because ocfs2_xattr_find_entry() searches
a non-indexed xattr block by memcmp on the name and never looks at
xe_name_hash.  Growing it past the space left in the block converts the
block into a tree, ocfs2_cp_xattr_block_to_bucket() fills the bucket in
stored hash order, and the update runs out of room in the bucket too.
The collision check then compares the unsigned hash against the legacy
hashes in the bucket and reports no collision.

ocfs2_xattr_set_entry_index_block() goes on to allocate a bucket that
ocfs2_divide_xattr_bucket() cannot fill: a bucket whose entries all share
one hash has no divide position, so all it does is append an empty bucket
with a sentinel hash one above the last entry's.

The re-search that follows depends on where the unsigned hash sorts.
Below the legacy ones, it comes back to the full bucket and the set fails
with -ENOSPC, having grown the tree for nothing.  Above them, it lands on
the new empty bucket, which ocfs2_xattr_bucket_find() handles explicitly
and ocfs2_find_xe_in_bucket() scans zero times, so the set stores a second
copy of the entry under the unsigned hash and returns success.  The
original stays in the full bucket, listxattr reports the name twice and
getxattr returns the new copy.

Pass the hash the entry is stored under instead: the stored one for an
existing entry, the unsigned one for a new entry.  A tree whose entries
are all stored under the unsigned hash sees no change, since there the
two are the same value.

Link: https://lore.kernel.org/20261009083002.2621201-3-joseph.qi@linux.alibaba.com
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
 fs/ocfs2/xattr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 00ef185748f19..c7f7e08259629 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5755,16 +5755,14 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 
 /*
  * check whether the xattr bucket is filled up with the same hash value.
- * If we want to insert the xattr with the same hash, return -ENOSPC.
- * If we want to insert a xattr with different hash value, go ahead
- * and ocfs2_divide_xattr_bucket will handle this.
+ * If the entry being set carries that same hash, return -ENOSPC, since
+ * ocfs2_divide_xattr_bucket() has no divide position to work with.
+ * Otherwise go ahead and ocfs2_divide_xattr_bucket() will handle this.
  */
-static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
-					      struct ocfs2_xattr_bucket *bucket,
-					      const char *name)
+static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
+					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
@@ -5833,6 +5831,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_search *xs,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
+	u32 name_hash;
 	int ret;
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
@@ -5852,10 +5851,18 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
+	 *
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	ret = ocfs2_check_xattr_bucket_collision(inode,
-						 xs->bucket,
-						 xi->xi_name);
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
+	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
2.53.0



