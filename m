Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046472;
	b=VkrRt5CgzsjET0ac+11J7OJSEFo/zlyZzUyY9RdJ4k2uwSlw41uefq3yj6RtYIdhkeyw
	 ybTCloh/DDtb7EQPy6ku3Blh08xpRtgz0mNqOBKPg85E9qXeZSSn+FDS5gh9TJ88nxinS
	 i8cWS30yrv+qjYGIAvQJ4mbw7haoUmIBD2O3a+01kbeemYVRQDlzTP3NIqFfdM+Sq1R+i
	 AyveNb+LRFX5xWn9in/6pp+IlnEMRj/pINhRbzVCh34HQ3OlaUhu7NlGuHyodJG0mBqvf
	 9tk60cHUfNJOiv4rWnHTGYG+ZGH/1L/VUG8Td6D0VVELWmPbkPv9YAM3ZzXCqULBfww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wtRDOWXG6u9/COOPVtK76Puq/+EeCj0h+wGdTy3Y2EU=;
	b=iq3zwE8MIft4B/Q8cTNKNptqQvOlG9ay8rvi3rPHxVTZUAAXcbZ0/5VrkG4fQ+2zr4g7
	 DxGYk/Y8TM/erWFT+2B/ppxLz0xf94KFvj24eSD3ikqdYdboCqFkcy+BzZv9TyXda7LRe
	 vzdB47UtiZxLqPZ1EDg0RQuwiVJap6CqacBbYKV7XIKy7gvlp4byU3A9bN+lcV8kYg9Wt
	 zQpJYbCV/zp7sE89AnCpkIadR7IgBl3Tre9O1Kpoif8wOxVsYo4SRG5DS1AeghbfmJlNK
	 MEIfLr9V82Vztu1iAs3jupCbMXwKvPLT9uWv/8bANokGzFPS/rDhhq4sfOZQ1DLu2Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16vmq0cr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1D0606A320;
	Thu, 19 Nov 2026 00:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16vmq0cr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985051F000C5;
	Thu, 19 Nov 2026 00:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046472;
	bh=wtRDOWXG6u9/COOPVtK76Puq/+EeCj0h+wGdTy3Y2EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16vmq0crdZDgYSEOJp9XiU1Kr7XlB9mEojpfsKOuYEuPGvtWmpJMFc1js7G/msIbf
	 M78lNewKLwFzbyCIiNXe4tdc+mBjyjivJbIlGwg356MdIkCwSY1jKo6UVCcn32Q25L
	 j45xRX7fhFYDEGtC6UfVxK4Rjmx4rsuoWLBC+9GQ=
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
Subject: [PATCH 6.1 1253/2857] ocfs2: find the xattr entry again after defragmenting a bucket
Date: Wed, 18 Nov 2026 15:38:07 +0100
Message-ID: <20261118150246.660385058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 9a40c050f58344615a0604701b5d299519833163 ]

ocfs2_xattr_set_entry_bucket() hands loc.xl_entry to ocfs2_xa_set() twice:
once for the bucket as it stands, and, if that reports -ENOSPC, once more
after ocfs2_defrag_xattr_bucket() has packed the name/value pairs down.

Defragmenting ends by sorting the entry array on xe_name_hash.  Buckets
are kept sorted, so the sort only permutes entries that share a hash, but
lib/sort.c is an unstable heapsort and it does permute them.  loc.xl_entry
is an address inside xh_entries[], so afterwards it denotes whichever
entry landed in that slot rather than the one the search found.

The second ocfs2_xa_set() then works on the wrong entry.  Nothing on that
path compares the entry's name with xi->xi_name, so what happens depends
on how the two entries compare in size: ocfs2_xa_reuse_entry() trips its
BUG_ON() when the padded name sizes differ, and otherwise the new value is
written into the neighbouring attribute's value slot while the attribute
being set is left untouched.  setxattr() reports success either way.

Remember the entry's hash before defragmenting and look the entry up
again afterwards, the way ocfs2_xattr_bucket_find() does.  An entry that
cannot be found again means the bucket no longer holds what the search
found, so fail with -EFSCORRUPTED rather than writing through the stale
pointer.

Link: https://lore.kernel.org/20261024151012.1059683-3-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc6afdb669f18..dc7f4a42619ff 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5579,13 +5579,18 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 					struct ocfs2_xattr_search *xs,
 					struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret;
+	int ret, found = 0;
+	u16 xe_index;
+	u32 name_hash;
 	struct ocfs2_xa_loc loc;
 
 	trace_ocfs2_xattr_set_entry_bucket(xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
+	/* Defragmenting below may move this entry, so remember its hash. */
+	name_hash = loc.xl_entry ? le32_to_cpu(loc.xl_entry->xe_name_hash) : 0;
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
@@ -5604,6 +5609,29 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * ocfs2_defrag_xattr_bucket() sorts the entries by name hash and
+	 * lib/sort.c is not stable, so entries sharing a hash may have traded
+	 * slots.  Look the entry up again before writing through it.
+	 */
+	if (loc.xl_entry) {
+		ret = ocfs2_find_xe_in_bucket(inode, xs->bucket,
+					      xi->xi_name_index, xi->xi_name,
+					      name_hash, &xe_index, &found);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		if (!found) {
+			mlog(ML_ERROR, "xattr entry not found in bucket %llu after defrag\n",
+			     (unsigned long long)bucket_blkno(xs->bucket));
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		loc.xl_entry = &bucket_xh(xs->bucket)->xh_entries[xe_index];
+		xs->here = loc.xl_entry;
+	}
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
-- 
2.53.0



