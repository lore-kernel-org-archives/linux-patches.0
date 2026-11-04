Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831557;
	b=GZPsnNRST4+YWoXvYFMo5BSj5IxL4rKA/Mb5Kwk/go7pZbCaS1e/fvffZDtCR13vEQbF
	 Ce1zl9BcY60iO5re2RritGFCufWOeSqTHtC9brCGbH5roFTV9AxLxN2Vg4WCtiH8FJOV5
	 //1WfTxemLm5Xmd5TYKX1G+DUL5KNlFhsVpduTQDKGwAzDmI+2RbFffiJOxewQUVcDyxY
	 ds7S6uFPrMgyntmmVYb31jiueDaYn/e1K8Z4EAQDb+94bC4akLkiKiDNMxIDycj0etp9U
	 WitEIfRLJwNppVqoLk/jR6+YR7a0939vtB/cEN8EX7Qm1IoteiZDCEA9Om4URPnMYTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kdx8oE38gRHJNJjO6EHpRBZF1kBO9EW5tP3WQrux+bw=;
	b=PHTIeXwMP5ARNTQTPCCQxm6s2Y5JmKqH3v3q2IINE9dzNKW5GZWailmSl4QiCAA3YU/T
	 BGTVQtBA87RGdpUPN7Jg02wQgCD5HGc/U/hL8BJcdZ0JpfUxp62ofcpl70NAs/7jypN6H
	 v4QZFYrnOvJ3Us1WRR2bWTDOup+4ow3pqzcauEamEiqEUF+u6EZ04f1TSsCMpPAiwKPJX
	 Aj+E7N/fY7z4652qJ0NeZZliCFwR9PA8/8yLjw0HnxocZqNMak7LKf0Go43//9GAlFgb9
	 dDEXKQNyKRteJPBuuo+tSYq5nWFOPJ4a4Is09tsr7XSfBJfwIQOjYa09mTn007aQKDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3v8mXCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D5C606A844;
	Wed,  4 Nov 2026 22:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3v8mXCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF84E1F00A02;
	Wed,  4 Nov 2026 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831557;
	bh=Kdx8oE38gRHJNJjO6EHpRBZF1kBO9EW5tP3WQrux+bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3v8mXCGfxfOHlIZqI7Oe62LvC9B/Fe8BBkN3kpP1Dgpizhka7qk13Ah5/dZMnffD
	 hzxRJpccH3K2EtX1oLHA53EAUJyQW88yUhk0dqGVbdFg7vD2gtMy/mTjqxT3Lgqk0B
	 MI0SpaHAn27Sr0u42N0zUaRJbLVQTqhSHytzf+pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Tao Ma <tao.ma@oracle.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 6.18 0757/1005] ocfs2: pin refcount trees before dropping the lookup lock
Date: Wed,  4 Nov 2026 16:08:10 -0500
Message-ID: <20261104211104.639672942@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 8c714a074074af7ae59233c1fa6ef9d7aa710462 upstream.

A refcount tree returned to ocfs2_lock_refcount_tree() must stay alive
until that caller releases its operation reference. However,
ocfs2_get_refcount_tree() returns the cached pointer after dropping
osb_lock, and the caller only takes its kref afterwards. The registry
reference does not protect this gap from concurrent removal.

This can happen when another node frees a refcount root and reuses its
block with a different generation while this mount retains the old
cached tree. Two local operations on different inodes sharing the new
root, such as data CoW and an external xattr update, can then look up
the same stale tree. Their inode locks are independent, and both the
REFCOUNT DLM lock and rf_sem are acquired after the first operation
reference.

The following ordering is possible, with no other operation references:

  Data CoW                         Xattr update
  --------                         ------------
  Look up the old tree under
    osb_lock, then drop osb_lock
                                   Look up the same tree and take a kref
                                   Acquire the tree locks and read the
                                     new on-disk generation
                                   Erase the old tree under osb_lock
                                   Unlock and drop the operation kref
                                   Drop the registry kref, freeing tree
  Take a kref through the
    freed tree pointer

The final kref_get() accesses freed rf_getcnt storage, and subsequent
accesses in ocfs2_lock_refcount_tree() also use the freed allocation.

Take the operation reference in ocfs2_get_refcount_tree() before
releasing osb_lock, including when an insertion loses to another lookup.
Removal must acquire the same lock, so it cannot drop the registry
reference before the lookup has pinned the tree. Keep the existing
unlock and error path puts. The two callers that already hold the
refcount tree lock keep their borrowed lookup behavior and do not
acquire an extra reference.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_lock_refcount_tree+0x94a/0x9b0
    Read of size 4 at addr ffff888117212820 by task python3/497

[Kernel and hardware identification omitted.]

    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     kasan_report+0xe0/0x110
     ? ocfs2_lock_refcount_tree+0x94a/0x9b0
     ocfs2_lock_refcount_tree+0x94a/0x9b0
     ? __pfx_ocfs2_lock_refcount_tree+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? ocfs2_refcount_cow+0x3b6/0xd90
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kmalloc_cache_noprof+0x28d/0x610
     ? ocfs2_refcount_cow+0x3b6/0xd90
     ocfs2_refcount_cow+0x410/0xd90
     ? __pfx_ocfs2_refcount_cow+0x10/0x10
     ? __pfx___might_resched+0x10/0x10
     ? down_write+0x11a/0x1f0
     ? __pfx_down_write+0x10/0x10
     ? ocfs2_inode_unlock+0x1a9/0x260
     ? __pfx_ocfs2_inode_unlock+0x10/0x10
     ? ocfs2_file_write_iter+0x1413/0x1d30
     ocfs2_file_write_iter+0x157b/0x1d30
     ? __pfx_ocfs2_file_write_iter+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? __x64_sys_pwrite64+0x1b7/0x220
     ? __pfx___might_resched+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     vfs_write+0x639/0x1010
     ? __pfx_ocfs2_file_write_iter+0x10/0x10
     ? lock_vma_under_rcu+0x154/0x4a0
     ? __pfx_vfs_write+0x10/0x10
     ? lock_release+0x121/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     __x64_sys_pwrite64+0x1b7/0x220
     ? __pfx___x64_sys_pwrite64+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

[Register dump omitted.]

     </TASK>

    Allocated by task 491:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_allocate_refcount_tree+0x49/0x1a0
     ocfs2_create_refcount_tree+0x5d7/0x1630
     ocfs2_attach_refcount_tree+0x57d/0x1100
     __ocfs2_reflink.isra.0+0x1c4/0x1940
     ocfs2_reflink+0x501/0x9b0
     ocfs2_reflink_ioctl+0x6b2/0x920
     ocfs2_ioctl+0x538/0x640
     __x64_sys_ioctl+0x163/0x1d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 498:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_lock_refcount_tree+0x672/0x9b0
     ocfs2_xattr_set+0x72c/0x2530
     ocfs2_xattr_user_set+0xaf/0xf0
     __vfs_setxattr+0x143/0x1b0
     __vfs_setxattr_noperm+0x112/0x5b0
     __vfs_setxattr_locked+0xfe/0x2b0
     vfs_setxattr+0x13c/0x370
     do_setxattr+0x128/0x170
     filename_setxattr+0x147/0x190
     path_setxattrat+0x1ac/0x260
     __x64_sys_setxattr+0xcb/0x140
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888117212800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 32 bytes inside of
     freed 1024-byte region [ffff888117212800, ffff888117212c00)

[Page and memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0037-v4-9f1a261dfbc341721689@gmail.com
Fixes: 374a263e790c ("ocfs2: Add refcount tree lock mechanism.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Tao Ma <tao.ma@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/refcounttree.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -348,8 +348,10 @@ ocfs2_allocate_refcount_tree(struct ocfs
 	return new;
 }
 
+/* Callers without the refcount tree lock must request a reference. */
 static int ocfs2_get_refcount_tree(struct ocfs2_super *osb, u64 rf_blkno,
-				   struct ocfs2_refcount_tree **ret_tree)
+				   struct ocfs2_refcount_tree **ret_tree,
+				   bool get_ref)
 {
 	int ret = 0;
 	struct ocfs2_refcount_tree *tree, *new = NULL;
@@ -406,6 +408,8 @@ static int ocfs2_get_refcount_tree(struc
 	new = NULL;
 
 out:
+	if (get_ref)
+		ocfs2_refcount_tree_get(tree);
 	*ret_tree = tree;
 
 	osb->osb_ref_tree_lru = tree;
@@ -479,14 +483,12 @@ int ocfs2_lock_refcount_tree(struct ocfs
 	struct ocfs2_refcount_block *rb;
 
 again:
-	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree);
+	ret = ocfs2_get_refcount_tree(osb, ref_blkno, &tree, true);
 	if (ret) {
 		mlog_errno(ret);
 		return ret;
 	}
 
-	ocfs2_refcount_tree_get(tree);
-
 	ret = __ocfs2_lock_refcount_tree(osb, tree, rw);
 	if (ret) {
 		mlog_errno(ret);
@@ -2323,7 +2325,8 @@ int ocfs2_decrease_refcount(struct inode
 		goto out;
 	}
 
-	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno, &tree);
+	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb), ref_blkno,
+				      &tree, false);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -2558,7 +2561,7 @@ int ocfs2_prepare_refcount_change_for_de
 	BUG_ON(!ocfs2_is_refcount_inode(inode));
 
 	ret = ocfs2_get_refcount_tree(OCFS2_SB(inode->i_sb),
-				      refcount_loc, &tree);
+				      refcount_loc, &tree, false);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;


