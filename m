Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831522;
	b=1SZ+Rv8zqaZhWPB4JD4MOes7C5OCSaHNOaiikakPaec24xXus5rsd7UkMFpTMA3CXSi2
	 vRoWZmlcxwGBcHxO2ylUxi92P+fIomErWn1idP9ta3h+5dLnkBNnr0aiNATayjdkMflH7
	 NGBsC8LOFsxcTm7sDhLdEweuMKNVL6+NlhDHMGZkTJCqRHc/C3jfJcrEe4kAhlyLPJPGd
	 +2u6w7cuS4iZ83Vk7VsOOdXMxHbYZTFz1N9pA/uhncfBkfg4pwlCOXS60/dEcBQx78okO
	 1NcCR/GvPUH8qpwklkM1gVIyHfB/ZE+LrfEyvEmxnC5ZB9Vrr9R4k3OXGmi9xIoMJfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bw5Gqb3O6f8o9cFnK1c9xiYeDoGc4SSOxwiwAMP7naY=;
	b=VJUmQhYrfCBXXX1FIu/F1QQZ9YWN+Uuo/xT/dsf91f79so4BLVystsBt7EW8yP9EIpqW
	 qGnguq/PlWcuwcQgz8iC7ygczm5IKsJuTqdkxzYhTUU8lC7Ea5tlio0yvjr0bWVmkq/gF
	 TKU8xS7hKrOgzTk2b0FXWrYdHh0cSfISl5i39AeyvRJmTJTZJodv/9UuIW8x4lymd1x8c
	 VZlul/JYNkLzznigp1seoJdolZbRFgcrjmNoAAq0ANqNSs44FtkcXzvvlX2Y3Jeb8Plbn
	 qiSsBfNCuKXOYommerMcuo6aPQwyyDr4hwsk8eXa859lqSnAqKh8Fidxeohq09TcyfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dovp4sUk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152D606D83D;
	Wed,  4 Nov 2026 22:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dovp4sUk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB43A1F0093A;
	Wed,  4 Nov 2026 22:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831522;
	bh=bw5Gqb3O6f8o9cFnK1c9xiYeDoGc4SSOxwiwAMP7naY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dovp4sUkG+fGHeaIz/ibJ53z2QtDoYZdEKHPIL8WAd29OplbkxZrPQ/7HdYAkmKxW
	 GuTyz7pDmKGxOR1ShrQ2T1yQBboE3JIEqee86SP7BqXviQnKa24b9jA8A1ZQ8L+dXq
	 zdc+/bU+63VYNn8h318DXmzJWrhCJhT69SbVSJrY=
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
	Kees Cook <kees@kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 6.18 0753/1005] ocfs2/dlm: hold a lock reference across grant AST enqueue
Date: Wed,  4 Nov 2026 16:08:06 -0500
Message-ID: <20261104211104.540836757@linuxfoundation.org>
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

commit 71743471204e21113295c786e5cfa570294234a4 upstream.

A newly granted remote lock must remain alive until its grant AST is
queued.  dlmlock_master() publishes the lock on res->granted with its base
and queue references, then drops res->spinlock before calling
dlm_queue_ast().  The resource's reserved AST count does not retain the
lock itself.

This can fail when a peer dies with an immediately grantable CREATE
buffered on its socket.  O2NET's node-down callback flushes receive work
before DLM cleanup, but the flush only waits for work queued on entry.  A
data-ready callback that already selected the socket container can queue
new receive work after the flush advances its work color.  Socket shutdown
does not discard bytes already queued for TCP receive.

The late receive work and DLM node-down cleanup can interleave as
follows (the lock reference operations shown are before this fix):

  Socket data-ready        Node-down thread         Receive worker
  -----------------        ----------------         --------------
  o2net_data_ready()
    select sc under
    callback read lock
                           o2net_disconnect_node()
                             queue shutdown
                             begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                             shutdown socket
                             flush returns
                                                    read buffered CREATE
                                                    dlmlock_master()
                                                      lock res->spinlock
                                                      add lock to granted
                                                      unlock res->spinlock
                           DLM node-down cleanup
                             lock res->spinlock
                             dlm_free_dead_locks()
                               unlink lock
                               put queue/base refs
                               free lock
                             unlock res->spinlock
                                                    dlm_queue_ast()
                                                      __dlm_queue_ast()
                                                      read lock->lockres
                                                      (use-after-free)

DLM cleanup holds res->spinlock while dlm_free_dead_locks() drops the
queue and base references.  The CREATE handler no longer holds that
spinlock when __dlm_queue_ast() reads the lock, before taking its AST list
reference.

Take a temporary lock reference under res->spinlock when a grant AST will
be queued, and drop it after dlm_queue_ast().  This keeps the lock alive
across cleanup until the AST path has taken its own reference, without
reversing the existing AST/resource lock order.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in __dlm_queue_ast+0x8a4/0xc00
    Read of size 8 at addr ffff88810ead5940 by task kworker/u16:3/52

    CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: o2net o2net_rx_until_empty
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? __dlm_queue_ast+0x8a4/0xc00
     kasan_report+0xe0/0x110
     ? __dlm_queue_ast+0x8a4/0xc00
     __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_raw_spin_lock+0x130/0x270
     ? __pfx___dlm_queue_ast+0x10/0x10
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x45/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     dlm_queue_ast+0x46/0x70
     dlmlock_master+0x51f/0xf50
     ? __pfx_dlmlock_master+0x10/0x10
     ? dlm_create_lock_handler+0x2b2/0x870
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     dlm_create_lock_handler+0x35b/0x870
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     o2net_rx_until_empty+0x1dae/0x32c0
     ? reacquire_held_locks+0xdd/0x200
     ? __pfx_o2net_rx_until_empty+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 52:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_noprof+0x20b/0x5c0
     dlm_new_lock+0x39/0x5f0
     dlm_create_lock_handler+0x16e/0x870
     o2net_rx_until_empty+0x1dae/0x32c0
     process_one_work+0x9a8/0x1b40
     worker_thread+0x65c/0xe40
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 603:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     dlm_lock_release+0x1df/0x2f0
     dlm_lock_put+0x51/0x80
     __dlm_hb_node_down+0x15be/0x2710
     dlm_hb_node_down_cb+0x6c/0xa0
     o2hb_run_event_list+0x34a/0x500
     o2hb_do_disk_heartbeat+0x1a07/0x2950
     o2hb_thread+0x1ed/0xdc0
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810ead5900
     which belongs to the cache o2dlm_lock of size 184
    The buggy address is located 64 bytes inside of
     freed 184-byte region [ffff88810ead5900, ffff88810ead59b8)

    [Page and shadow memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0043-v5-1ad07df761ff49638789@gmail.com
Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmlock.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -138,6 +138,8 @@ static enum dlm_status dlmlock_master(st
 					  res->lockname.len)) {
 			kick_thread = 1;
 			call_ast = 1;
+			/* Keep the lock alive through AST enqueue. */
+			dlm_lock_get(lock);
 		} else {
 			mlog(0, "%s: returning DLM_NORMAL to "
 			     "node %u for reco lock\n", dlm->name,
@@ -166,10 +168,12 @@ static enum dlm_status dlmlock_master(st
 	wake_up(&res->wq);
 
 	/* either queue the ast or release it */
-	if (call_ast)
+	if (call_ast) {
 		dlm_queue_ast(dlm, lock);
-	else
+		dlm_lock_put(lock);
+	} else {
 		dlm_lockres_release_ast(dlm, res);
+	}
 
 	dlm_lockres_calc_usage(dlm, res);
 	if (kick_thread)


