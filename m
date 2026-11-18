Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057894;
	b=5ikmmQEInj481c3PXvfGftn7dPoxMtM1RGT3FccA1GDOv0x8ji+3WvqVkOiikhae5JN1
	 JXgiZ7TMEiL0+if3uHYd/io6vywnN8j8dy9M1ll2etr3ynXBvmtJ2G7aQNwou8RwvPf0h
	 e3HoWw12ifu/RQ+vYW9k7jFKFJUox3T3vyyeF1u9ABsJJzCo2UCF6V1GS+JFzeeX6B6b0
	 nQMzq9HuoC8B3WDQ5K/J43Du+QQQE2PNfIUPFA1EOI21HpOD7dPCY4TXFv/9DqZx7Q6eZ
	 pvPpSd8uzHERJGWroL45Joe8ItJ2cjQOEwtdFqeSiRZ59/VXMFOJV0KaUhGq2WCtT4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9s7yt476S2wVqMnx/PDZ1TRQMFviXV6jKZFckzEhaAI=;
	b=UYqAqi8CgCK0j3LI1lg6RdK2JaSwSpFoceE0OYVLkZxyuAbGe+f1dP2Xi6v+3U6kmL9+
	 4Hs7GIXuHo3SG3+4WhukQ4Hj1feOrTh9VE517MLmQmXc133h6mV7U6hOw2sFQJOtxQuK5
	 GCWYPoTzqCrPT73oBn9G4zRe/CQ7JhxBYFNezCXBVxxW1YfVPbn7SaUS8vW0uLADBHO97
	 cKt/QENMBW9sVGxn5DUKrVkaFHGYuzQMQeRQcK8kMkVEkNRPslt37crWiZdvkddhqevx7
	 ExqeeDmDDw1dSbpreo5iOT2r4bCc2SKTLzbP//WzELgEuk9iQwm4DWf68jGIn1UmKSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFyEzBlR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E6C606A31C;
	Thu, 19 Nov 2026 03:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WFyEzBlR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394CA1F000C4;
	Thu, 19 Nov 2026 03:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057894;
	bh=9s7yt476S2wVqMnx/PDZ1TRQMFviXV6jKZFckzEhaAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFyEzBlRoCGQya13OXM6UxmkZcU2B8Qzx3ToJOVUvwLjniScZC+4LKU9G9OHv5wMm
	 10ndNPC878LBzCcRH9XhEp7Fc9wMbrMOxYKZLtzbTY6nkrSyzQb8LUs1LhkH7hcS8T
	 8gdUU4XG4ykN6rI2WuGk/YRtFTXWu5F7Hy7Dukck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Chao Yu <chao@kernel.org>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 5.10 0265/1848] ocfs2: cancel quota sync work before freeing quota info
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118145923.391785395@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 1dd1f005026d52642b994d63baa16b0b31f3b14f upstream.

OCFS2 quota info owns dqi_sync_work and must outlive both its timer and
qsync_work_fn().  ocfs2_local_free_info() frees that owner without
cancelling the work, relying on the quota suspend/disable wrappers.

Loading quotas on a read-only to read-write remount can successfully queue
the work in ocfs2_global_read_info() and then fail while attaching a dquot
to an existing inode in add_dquot_ref().  The quota core unwinds that
failure directly through dquot_disable(), bypassing the OCFS2 wrapper:

  Remount task (s_umount write)        Timer/workqueue
  ocfs2_global_read_info()
    schedules dqi_sync_work
  add_dquot_ref() returns an error
  dquot_disable()
    ocfs2_local_free_info()
      frees oinfo
                                     delayed-work timer expires
                                     qsync_work_fn() reads oinfo

The timer core can then write to the freed embedded timer, or
qsync_work_fn() can read oinfo->dqi_gqinode before its s_umount trylock.
The outer ocfs2_disable_quotas() cleanup skips the failed type because
dquot_disable() has already cleared its loaded state.

Cancel dqi_sync_work synchronously at the start of
ocfs2_local_free_info(), before dropping the global inode or freeing any
owner state. The work is initialized whenever read_file_info() succeeds.
dquot_disable() holds s_umount for write, so the callback skips its quota
scan via down_read_trylock() and can finish without waiting for teardown.
The synchronous cancel also handles its self-rearm.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in __run_timers+0x9e9/0xa10
    Write of size 8 at addr ffff888111b0aad0 by task swapper/3/0

    Call Trace:
     <IRQ>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? __run_timers+0x9e9/0xa10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? __run_timers+0x9e9/0xa10
     kasan_report+0xe0/0x110
     ? __run_timers+0x9e9/0xa10
     __run_timers+0x9e9/0xa10
     ? __pfx___run_timers+0x10/0x10
     ? __lock_acquire+0x5a3/0x2140
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     timer_expire_remote+0xfa/0x160
     ? __pfx_timer_expire_remote+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     tmigr_handle_remote_up+0x4ba/0x9d0
     ? __pfx_tmigr_handle_remote_up+0x10/0x10
     ? tmigr_handle_remote+0x21a/0x340
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? __pfx_tmigr_handle_remote_up+0x10/0x10
     __walk_groups_from+0x5a/0x160
     tmigr_handle_remote+0x24f/0x340
     ? __pfx_tmigr_handle_remote+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     run_timer_softirq+0x222/0x270
     ? __pfx_run_timer_softirq+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xb8/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     handle_softirqs+0x1fa/0x8d0
     ? __pfx_handle_softirqs+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? _raw_spin_unlock+0x23/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __hrtimer_rearm_deferred+0x1fb/0x5d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     </IRQ>
     <TASK>
     asm_sysvec_apic_timer_interrupt+0x1a/0x20
     ? ct_kernel_exit.constprop.0+0xc5/0xf0
     ? do_idle+0x3ae/0x650
     default_idle+0x9/0x10
     default_idle_call+0x6c/0xb0
     do_idle+0x3ae/0x650
     ? cpuhp_online_idle+0x9c/0xb0
     ? __pfx_do_idle+0x10/0x10
     ? __entry_text_end+0x1020f6/0x1020f9
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     cpu_startup_entry+0x54/0x60
     start_secondary+0x223/0x2d0
     ? __pfx_start_secondary+0x10/0x10
     common_startup_64+0x13e/0x158
     </TASK>

    Allocated by task 523:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_local_read_info+0x181/0x1580
     dquot_load_quota_sb+0x69e/0x11c0
     dquot_load_quota_inode+0x227/0x3e0
     ocfs2_enable_quotas+0x27c/0x520
     ocfs2_reconfigure+0x964/0xd00
     reconfigure_super+0x3ca/0xa70
     path_mount+0x141e/0x1e80
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 523:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_local_free_info+0x47b/0x800
     dquot_disable+0x5d9/0x17a0
     dquot_load_quota_sb+0xd3c/0x11c0
     dquot_load_quota_inode+0x227/0x3e0
     ocfs2_enable_quotas+0x27c/0x520
     ocfs2_reconfigure+0x964/0xd00
     reconfigure_super+0x3ca/0xa70
     path_mount+0x141e/0x1e80
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888111b0a800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 720 bytes inside of
     freed 1024-byte region [ffff888111b0a800, ffff888111b0ac00)

Host details, register and page dumps omitted.

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0052-v3-b4904bd6c85daf033adf@gmail.com
Fixes: 1a6152d36dee ("quota: propagate error from __dquot_initialize")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -813,6 +813,9 @@ static int ocfs2_local_free_info(struct
 	int mark_clean = 1, len;
 	int status = 0;
 
+	/* Quota-core error paths can bypass ocfs2_disable_quotas(). */
+	cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
 	ocfs2_lock_res_free(&oinfo->dqi_gqlock);


