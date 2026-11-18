Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052075;
	b=cn0zTGYG8gLYN3LG3SkssG//+DZdmBtSJRP1E7eiXu3M2F7vw0qzPZA0Hqgx97abDElY
	 vFXJCgn6o+rYDqlzhetGlzy3GQzD6vOurnPVqoPMV1cofzyNi0k5o9WWd7Svd1n9aamrw
	 SCDu47LI3Fxqr3doyMBZpEkIpOYOESBFNNWJ83ow4Jq3NIMNtLodfU9xpfnYchWbwbURv
	 6U2c1kSVTtvbuF4jYSN/FzSnYi/xXzVF1ti5evOiXA1uZ/difexpkGEmQsH/tEoej0w0P
	 0vlA0tyuTibcbuGDZd45jNBJlvbf4IQBG+b/zOesuavtcUgMRczDVsKTkUX23+ZxfiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsuurhDOPqi3OOl8/FrMbiqYafkxF9wxkF/3gWlpKrs=;
	b=o4aUyPdn0CxIx/a3/pqCZOa4HUFawuQ1gwxgFu0a/boOk7gCtX/pW8zbjBdGBxWKCixB
	 BtLkPs00ZEBAHwCYct+BJH0jbTWaJ1zWZYX8J0QAvThIr9ELsydUx8awRomxmZvP56Rxu
	 lMCZUL9hVb8fCIxeiaY9lhgMQnXMGAKEv7FmvboyKdREZBsg11/bxvWrgt/kZcMZo/uao
	 HZiZsFXq0wSleGYrfJ11sr0HnBqFK417SS2eb1OjKdL06UikVrvocWAILuglX3yxWnYWw
	 SC/2hKjCZEl3hJeFTbscYGF6GOoaObZ/PzQvQSs64o7JQQxikDyt6QLZAvMD157s9tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDP0vTr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8138A606A325;
	Thu, 19 Nov 2026 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDP0vTr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC861F000C4;
	Thu, 19 Nov 2026 01:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052075;
	bh=UsuurhDOPqi3OOl8/FrMbiqYafkxF9wxkF/3gWlpKrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDP0vTr8gVZRZa+dp2v3K3KIa/V8Aw868GnAQ5bxgi8UalHpYEISQaMlVc0pDj9h/
	 cotjySZsQS9wgWerHPoc6XOGgi3Qoztu7Wo98dh4+zHWxfS9HJ4EC6ja33kI0ponoX
	 xgxAOr+52W11r4In9BnWYQycKyyHN8TGMggbNBbo=
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
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0435/2214] ocfs2: snapshot dentry names in file and setattr traces
Date: Wed, 18 Nov 2026 15:35:11 +0100
Message-ID: <20261118150028.414017918@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 8cd3ff30659775a6831c66687a69d2b83d163591 ]

Patch series "ocfs2: stabilize dentry names in file and setattr traces",
v4.

Snapshot names at all six users of ocfs2__file_ops and at the separate
setattr event. Patch 1 handles the five ordinary file-operation callers
and setattr. Patch 2 handles release separately to preserve its locked
open-count sample and take the snapshot outside that critical section.

The release explanation distinguishes its existing RCU lifetime coverage
from name/length consistency. It does not claim that the ordinary
callers' external-name UAF interleaving crosses the held inode spinlock.
The release source change is unchanged from v3.

Patch 1 also removes the read callback's redundant NULL-inode check.
The two patches apply independently and leave trace formats unchanged.

This patch (of 2):

The open, fsync, read, write and splice-read trace calls pass the live
dentry name and length to the shared ocfs2__file_ops event class.
ocfs2_setattr() passes the same unprotected arguments to its own event.
Both events size and copy a __string field separately. A reference to
the dentry does not pin the external storage backing an individual name.

With an event enabled, a caller can be preempted after loading the name
pointer. A long-to-short rename can then replace the name and reclaim its
old external allocation before the trace callback sizes or copies it,
provided no other snapshot retains that allocation.

The setattr inode lock does not exclude every rename: a same-directory
rename of a source directory need not take that directory's inode lock.
It can therefore change the dentry name while setattr records its event.
Inline names and separately loaded lengths can also change during trace
record sizing and copying.

Take a dentry name snapshot around each of these six trace calls and
pass both the string and length from the snapshot. Check event enablement
before taking a snapshot. Keep the event classes and formats unchanged.

Also remove the redundant NULL-inode check in the read callback.
file_inode() returns the open file's inode, which is already used by the
trace call above the check.

The historical report below is from the read path.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
    Read of size 1 at addr ffff88810a5b2b18 by task python3/496

    [CPU and host details omitted.]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? strlen+0x85/0xa0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? strlen+0x85/0xa0
     kasan_report+0xe0/0x110
     ? strlen+0x85/0xa0
     strlen+0x85/0xa0
     trace_event_raw_event_ocfs2__file_ops+0xf0/0x480
     ? __pfx_trace_event_raw_event_ocfs2__file_ops+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ocfs2_file_read_iter+0x6cd/0xb30
     ? __pfx_ocfs2_file_read_iter+0x10/0x10
     ? selinux_file_permission+0x11d/0x540
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     vfs_read+0x7d2/0xc20
     ? __pfx_vfs_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_do_sys_openat2+0x10/0x10
     ksys_read+0x111/0x200
     ? __pfx_ksys_read+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [User register dump omitted.]
     </TASK>

    Allocated by task 489:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2de/0x780
     __d_alloc+0x5fc/0x8c0
     d_alloc_parallel+0x106/0x11d0
     lookup_open+0x3ff/0x13e0
     path_openat+0x95e/0x2020
     do_file_open+0x21e/0x470
     do_sys_openat2+0xf4/0x1b0
     __x64_sys_openat+0x136/0x1e0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x6be/0x1ed0
     handle_softirqs+0x1fa/0x8d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810a5b2b00
     which belongs to the cache kmalloc-rcl-192 of size 192
    The buggy address is located 24 bytes inside of
     freed 192-byte region [ffff88810a5b2b00, ffff88810a5b2bc0)

    [Page and shadow-memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-0@gmail.com
Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0088-v7-6324344256f0c3b1c3d8-1@gmail.com
Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: omitted the ocfs2_file_splice_read() changes because the callback is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 84 +++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e35d735e551d0..cb8a40a73adeb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -84,10 +84,17 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
 	int mode = file->f_flags;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	trace_ocfs2_file_open(inode, file, file->f_path.dentry,
-			      (unsigned long long)oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name, mode);
+	if (trace_ocfs2_file_open_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_open(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      mode);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (file->f_mode & FMODE_WRITE) {
 		status = dquot_initialize(inode);
@@ -173,11 +180,17 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 	tid_t commit_tid;
 	bool needs_barrier = false;
 
-	trace_ocfs2_sync_file(inode, file, file->f_path.dentry,
-			      oi->ip_blkno,
-			      file->f_path.dentry->d_name.len,
-			      file->f_path.dentry->d_name.name,
-			      (unsigned long long)datasync);
+	if (trace_ocfs2_sync_file_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_sync_file(inode, file, dentry,
+				      oi->ip_blkno,
+				      name.name.len, name.name.name,
+				      (unsigned long long)datasync);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
@@ -1129,15 +1142,19 @@ int ocfs2_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	int had_lock;
 	struct ocfs2_lock_holder oh;
 
-	trace_ocfs2_setattr(inode, dentry,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid,
-				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
-				attr->ia_valid & ATTR_UID ?
+	if (trace_ocfs2_setattr_enabled()) {
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_setattr(inode, dentry, OCFS2_I(inode)->ip_blkno,
+				    name.name.len, name.name.name, attr->ia_valid,
+				    attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				    attr->ia_valid & ATTR_UID ?
 					from_kuid(&init_user_ns, attr->ia_uid) : 0,
-				attr->ia_valid & ATTR_GID ?
+				    attr->ia_valid & ATTR_GID ?
 					from_kgid(&init_user_ns, attr->ia_gid) : 0);
+		release_dentry_name_snapshot(&name);
+	}
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
@@ -2383,11 +2400,17 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
-		(unsigned long long)OCFS2_I(inode)->ip_blkno,
-		file->f_path.dentry->d_name.len,
-		file->f_path.dentry->d_name.name,
-		(unsigned int)from->nr_segs);	/* GRRRRR */
+	if (trace_ocfs2_file_write_iter_enabled()) {
+		struct dentry *dentry = file->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_write_iter(inode, file, dentry,
+					    OCFS2_I(inode)->ip_blkno,
+					    name.name.len, name.name.name,
+					    (unsigned int)from->nr_segs);
+		release_dentry_name_snapshot(&name);
+	}
 
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
@@ -2533,17 +2556,16 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name,
-			to->nr_segs);	/* GRRRRR */
-
+	if (trace_ocfs2_file_read_iter_enabled()) {
+		struct dentry *dentry = filp->f_path.dentry;
+		struct name_snapshot name;
 
-	if (!inode) {
-		ret = -EINVAL;
-		mlog_errno(ret);
-		goto bail;
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_read_iter(inode, filp, dentry,
+					   OCFS2_I(inode)->ip_blkno,
+					   name.name.len, name.name.name,
+					   to->nr_segs);
+		release_dentry_name_snapshot(&name);
 	}
 
 	if (!direct_io && nowait)
-- 
2.53.0



