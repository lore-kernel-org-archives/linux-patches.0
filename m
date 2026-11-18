Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059063;
	b=XdXf/tETgoN0dJ7jt8D+OvuteR4l2f4babbeuBtJ8AusSDR0gkqLdWXvlbS87CoWgyYM
	 iqaGoDR34fw33/yrhiB3FJUghe3NiUa+VeW0sAs9sOWy0lLweAYwajoALWDIBRQ8AlNXj
	 Ubigv/Oa3J5fwSURAt2gkEJ3XVjsUBMePdarSuqFgb2rVFp4vBLjGcoo7lwEp8h3Lxubm
	 3e+vUkjYh+JWyvrzR6ewn4Azs60thjkM0kh2XkYM7B1ECUqL8q9LipADBZS3sIVd6qeGU
	 +JlLsovX4xh4gdtvMYCLFhRvCz7F17er8/ltH02xOBhErBb/SVBXGDyCAgPIOOejOHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZMeivDaolpCYLie8JkIXMGFrw7IdkG0XmhMWjq/vt/0=;
	b=CkQUx+UKzd9iC/xQMKeF5IaPb0o1A96z6Wn/NygLjI7VUx5nR5GouMBIWWv9XnQhK4yt
	 CW3ZXRBFMYN5YcU6mgPLF0zZJPYlYei7eCR+7v6JA5LmbGLbId+Nk2zQ6HV3UUqYh6HqT
	 3ILglJNk0Xmq6fD2RfYtrPwhdAJgJ6nJH7w7iZpq92H4H6IxNI9DZua47wORO14y8wtFD
	 EpUW+4QC8CmIblFMBIDYwdm79TiqRr4MxylSUBmxTqpLNlTjQJB2zuzWNCZJM9hgcoVbI
	 7NNjCVZBQ0tIJRWrS0DzzPgf8dxd+tN1n4Ca8ATBWtZgZVWlgM1zMu4bbV3rzAzBS5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeQdBLFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E01606A32C;
	Thu, 19 Nov 2026 03:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeQdBLFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5781F000C4;
	Thu, 19 Nov 2026 03:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059062;
	bh=ZMeivDaolpCYLie8JkIXMGFrw7IdkG0XmhMWjq/vt/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeQdBLFiSDP36Ing+m8Ke2bXHJKmLlSwEcZRTOTIFZtdacCWLhhpb3P+lWDyDjaT0
	 0WLk8mq3fQft/qbPyYUaqsiMc2GiwxlyLmb7wdWCsge7uuROGnTMr5OlNPDFfy7m/j
	 cZYpa9FGnPxXYo21r2FaH9ARRG8WnYHvrp8G7NUY=
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
Subject: [PATCH 5.10 0706/1848] ocfs2: find the xattr entry again after defragmenting a bucket
Date: Wed, 18 Nov 2026 15:45:44 +0100
Message-ID: <20261118145945.426927961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f82d37e87c860..f7c4cecd64024 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5581,13 +5581,18 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
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
@@ -5606,6 +5611,29 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
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



