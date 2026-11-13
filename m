Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585630;
	b=5TsQjCE5ipCreNKbtTPAyUpj4h60Pc09gI3MVV6LcKgH1gzCrkvGiwAaT8g43+MxPiYO
	 OrLhah3TJTsYEt7DxKbO6aw6otvRKDO59AVkgYx+i23Eq7Jn96rzsCdwic427Ie9kclYn
	 f7FBfp7tdsMPK43A8S6QlRM5Bxy3sbDLkznS4TsfqYCbXOS3yIP8spp2XaPmfeqdkqaZP
	 nWsLxe9mRAYD+pSWZuiCk7GuKGoUo+UFwRic2JGH36nLVnp2mEaKU1yJAFhLa4+s2R+NV
	 0kpd1KuOAZY1eRK3jrKVFm6jp3xetvN+SFE4wiRJggcjfcYNZHE5lq4XExScHitj1rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPE1IWQOLu3drdwq2E3JisUXvLRwAEvqXPJW2GWqcyk=;
	b=C2nJ3K7r3JxuIXthImhDqoWPEymCcUGOgiZaN/cnc2MwstdktupV3hCS4i2vPMSuw0Ns
	 wdqnLpN1D0eudPKtebSPe1MerdTHv0c7OBU0SoIJjyWmyhNRrt7tPLUpJBKBJgJQYBhMH
	 1XXzfGa0zeBbX/ZVNcd23cV4accdZHy+tHX4hNxvJfYslwdQKSxcuwhO5cRIt+ZfAEMn3
	 vhl9PnH0jrAaZwL5PnI3DHxIGQT6ExvOGikOcEeuGXUTS7iwnchY7zBN/FE4lOxdwRVNZ
	 js4syuvUi9AslJAAY0KjSN18neSycPOuJamVvg4gW79wr1iGWbZCdvy+j5zHpKHjdAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7dr+Zc+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D17606A894;
	Fri, 13 Nov 2026 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7dr+Zc+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57361F000C4;
	Fri, 13 Nov 2026 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585629;
	bh=jPE1IWQOLu3drdwq2E3JisUXvLRwAEvqXPJW2GWqcyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7dr+Zc+IIFWEnfRhlUtq8P/mY8u3JFmtPP7sk5Xza7yXkqTECbX474L6MrMULcLJ
	 QLuoYWtSRiu8qlmv7mm99ApsrJW48g/PGj9mQuUh0H8qWFwvCezi/GaKcYANi7eTNd
	 07mPh8m9XXSMI7gFEIPoPfM+ouDTfVOH7neEhfTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 250/507] ocfs2: do not read the entry array of an empty xattr bucket
Date: Fri, 13 Nov 2026 10:49:14 -0500
Message-ID: <20261113153803.039605390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

[ Upstream commit e8de099f2958c84aa23186c5481e69f7ffd39355 ]

ocfs2_check_xattr_bucket_collision() decides whether splitting a bucket
can make room by comparing the hash being inserted against the first and
the last entry.  xh_count comes off disk and is never checked, and a
bucket is allowed to hold no entries: ocfs2_xa_remove_entry() keeps the
last slot when it removes the only one, so that an empty bucket still
carries the hash it is keyed by.  xh_count then reads back as 0 while
xh_entries[0] is still meaningful, and the second comparison indexes
xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header.  An entry is 16 bytes and xe_name_hash is its first
field, so the value read is xh_count | xh_free_start << 16.  It stays
inside the block, but the answer is arbitrary, and for an empty bucket
it says there is no collision, so a new bucket gets added on the
strength of it.

An empty bucket holds no entries to collide with.  Return before reading
the array.

One way to reach the test with an empty bucket is a set that removes the
bucket's only entry during cleanup and then fails for space again, since
it is that second -ENOSPC which calls this.  Growing a value past
OCFS2_XATTR_INLINE_SIZE is the easy route: the cluster allocation fails,
the "!orig_clusters" arm of ocfs2_xa_cleanup_value_truncate() removes
the entry, and although the "growing" caller does set ctxt->set_abort,
only ocfs2_xattr_block_set() and __ocfs2_xattr_set_handle() look at it,
so ocfs2_xattr_set_entry_index_block() goes straight on to the collision
check.

This sits on commit a9ea8b397864 ("ocfs2: use the stored hash when
checking xattr bucket collision"), which gave the collision check its two
argument form and is marked for 6.2 and later.  The read fixed here is
present in the three argument version too, but a tree without that
commit needs the hunk adapted by hand.

Link: https://lore.kernel.org/20261024151012.1059683-5-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc0e2aea14a38..00f628e22d661 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5882,11 +5882,20 @@ static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
 					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 count = le16_to_cpu(xh->xh_count);
+
+	/*
+	 * An empty bucket keeps the hash of the entry that was removed in
+	 * xh_entries[0] so that it can still be found, but it holds no
+	 * entries to collide with.
+	 */
+	if (!count)
+		return 0;
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
 
-	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
+	if (xh->xh_entries[count - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
 		mlog(ML_ERROR, "Too much hash collision in xattr bucket %llu, "
 		     "hash = %u\n",
-- 
2.53.0



