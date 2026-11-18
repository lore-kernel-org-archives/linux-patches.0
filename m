Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054599;
	b=w1NtPM9ohYVBTMc9ko888pq/uMvBfuD0/ievntwGqv2KmH6bH6DHvbCrJOXSqsV/gQM5
	 yoKDSAMOFvPYXfPg3Hp03OMvDJvd4YuhG2DyBpdB7QpXqnkpXHyUHMPzo/EkR5ci5wfpS
	 WRsobCUgvKn3gteAQKYmcZd0bTGNKxS4rRvsbAyhDXPKaUSdre10z/GGfx/RFbJLPiwZc
	 ZbhPYUeQJFB+SxYg4TAY3BW6N75gUIB6ImtvfO84KvIGZQimkP04uFs/H1/87fHtPaW2M
	 9G50GWXHWkA2FAUAvcsdojOY4sj7J1soNq1JSu28DHJ8ch5jizs5+orksa4bCvHFM1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LC68rKlLFToQmYtj+ndiiP4ZCagP6HX8elfB75D+YDE=;
	b=MBNc4lmlVodd92zRRlwm/WmO6YDcSJnGNXvQxMyCUV5H2fZYZp83i8j02DgsRZtFgRZL
	 pZGzLNcFLpRqLNMkOZr05EQTAc9ky5ntudQk/m4TjeWS+WhSxHk3wAAHae10gMV6F6jla
	 oU0YBUh1apmfyzDF8kNeukoqepoBSmKBY2PRz4AX8tpxnKxYjfVXZ37JxOhR4E2+3mpzz
	 VCZxRHb6oH/yTCydL3Xvi9dOn8APLKOkNpQwzrsTOmLAY/yv/sKI72KA5ekQTGKp7nPbR
	 z5dEbPxacUDou+cvoix/3W0MYVv4O7tbZyCW9ls3KFQR8x5qQlceyGPn4V+DDQK6WOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fU0wm1L1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD3B606A31C;
	Thu, 19 Nov 2026 02:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fU0wm1L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30AC1F000C4;
	Thu, 19 Nov 2026 02:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054599;
	bh=LC68rKlLFToQmYtj+ndiiP4ZCagP6HX8elfB75D+YDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fU0wm1L1fJhQES4P8L1jzhaEdENn39UaZDQscXkQ5NoIcB7XM+lfRCcMb6FGp2QOV
	 e8k2u5xAKbflQHNHO5uXZh+OK4wwuyht57+8DQY5Nytj3TZkF5DBp3j88n0gct8nIy
	 7ULMT9DfhWHPa6qdC+orfCeWF/fEwdLZWNzkeYU4=
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
Subject: [PATCH 5.15 1292/2214] ocfs2: read the xattr entry hash before defragmenting the bucket
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118150103.236623938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit f48151da595e74efdc23d83d8d6d142207b8c731 ]

Patch series "ocfs2: fix stale xattr entry pointers and empty header
reads", v1.

Five defects in the ocfs2 extended attribute code, plus one robustness
measure that belongs with them, all on the paths that move entries
between a block, a bucket and an index tree.  They fall into two groups.

Stale entry pointers (patches 1 to 3)

ocfs2_xa_set() writes through a pointer into xh_entries[] that two of
its callers invalidate first.  Defragmenting a bucket ends in a sort()
on xe_name_hash, and lib/sort.c is an unstable heapsort, so entries that
share a hash can trade slots.  Copying a block into a bucket changes the
order outright, since a block holds its entries in insertion order while
a bucket holds them by hash, yet ocfs2_xattr_update_xattr_search()
relocates the search by the index the entry had in the block.  Neither
path compares the entry's name with the one being set, so setxattr() can
replace a neighbouring attribute's value and still report success, or
trip ocfs2_xa_reuse_entry()'s BUG_ON.  Patch 1 takes the hash before the
sort; patches 2 and 3 look the entry up again afterwards.

Reads of an empty entry array (patches 4 to 6)

A block and a bucket may both hold no entries: ocfs2_xa_remove_entry()
keeps the last slot when it removes the only one, so an empty bucket
still carries the hash it is keyed by.  Three sites index xh_entries[]
without checking xh_count and so read xh_entries[-1], which lands on the
header and comes back as xh_count | xh_free_start << 16.  Nothing
faults, but the value is acted on: the collision check reports no
collision for an empty bucket, the divide commits a sentinel hash that
hides part of the key space from ocfs2_xattr_bucket_find(), and the
block to bucket copy claims storage the bucket does not hold.  Patches 4
to 6 guard each site and keep the one read of xh_entries[0] that
ocfs2_xa_remove_entry() documents as intentional.

This patch (of 6):

ocfs2_xattr_set_entry_index_block() takes the hash a bucket split has to
work with out of xs->here, but only after ocfs2_xattr_set_entry_bucket()
has tried and failed to fit the entry.  That call defragments the bucket
when it runs out of room, and ocfs2_defrag_xattr_bucket() finishes by
sorting the entry array by name hash.  lib/sort.c is not stable, so two
entries sharing a hash may trade slots and xs->here is left naming an
entry other than the one the search found.

The hash value itself survives the permutation -- the array is already
sorted, so a slot can only exchange with an equal-hash neighbour -- but
there is no reason to depend on that.  Pick the hash up before the set,
where xs->here is unambiguously the entry the search landed on.

No functional change intended.

Link: https://lore.kernel.org/20261024151012.1059683-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261024151012.1059683-2-joseph.qi@linux.alibaba.com
Fixes: e39baff18b85 ("ocfs2: use the stored hash when checking xattr bucket collision")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 49b1b4e072ce3..ede497d00f2d7 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5719,6 +5719,22 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
 
+	/*
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
+	 *
+	 * Read it before the set below.  Filling the bucket may defragment it,
+	 * and ocfs2_defrag_xattr_bucket() re-sorts the entry array, so
+	 * afterwards xs->here only denotes whichever entry the sort left in
+	 * that slot.
+	 */
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
 	ret = ocfs2_xattr_set_entry_bucket(inode, xi, xs, ctxt);
 	if (!ret)
 		goto out;
@@ -5734,17 +5750,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
-	 *
-	 * An existing entry keeps the hash it was stored under, and that is
-	 * the hash a split has to work with.  A new entry is stored under the
-	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	if (xs->not_found)
-		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
-						  xi->xi_name_len);
-	else
-		name_hash = le32_to_cpu(xs->here->xe_name_hash);
-
 	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
-- 
2.53.0



