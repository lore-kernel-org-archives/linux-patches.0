Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214675;
	b=cfv6OmptTXyh2I2V0a42Mx3Y6DDFI8wJHjowUPGQVuQx2FZNh2Jsu8eGgKLfA39A8cpL
	 BTNduofnodpJjBqe9j7nZbmtVvGM4LkoM7TYVkcxqLkHkcbxlwQh4SEalfoiMFtEKyUfP
	 Hzfd+8sBjspIh5lwSzW8Dm4e7C4wwRlE5EZtU1kSXh2ONrvsK5sGXffdqx3E+vfgk3koR
	 KpJfwPdbe8Fc/3ACfEzR/RLFPirheTRHtZrXJ/83xEXg/shNyOt1UxtUeoa9RlGgCBcmj
	 vzw0Hd3jliLaLKE3s32ewN+TqaNCmOeNuQG3YGCe4zJ+lMUTifZJvtjA+73t1Q/IYdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CQO1yiSBERtprT2AoEl1Tc231kogIQyWcbq9uThkHSM=;
	b=EZR6/n0HS5whY43iDUItCRXAg7MHRIsbI/J/pbME6nt7DkGN1S6rG4wgrjx+AS0TAAgp
	 MoKsin19v/sGxFwG+rYw4+6isjftN043rB0dBTV/wkZqbijWg+ztKCehuRcviRkbBXfuq
	 287JjEZgohxFHyrtUi06T1HzgLMzpLlLzBvQIyC8Ijm8V7cyQJO+3R5Jwpog4XHj8w1JP
	 bKpppBWZfmot+gF9CTFI1yAg7m3/AKjYY6Qvi6O7uFrOOBYMhFheTgbVc6bU193wV1kKp
	 RtvNK+jxh9n6IJJ1UjaGzIvPRAuKgr49JAJ58eai6eHqZJguU7ORwYgx5VEKI/ck+0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tv+Id9Je;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DE9606B7CF;
	Wed, 28 Oct 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tv+Id9Je
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D981F01825;
	Wed, 28 Oct 2026 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214674;
	bh=CQO1yiSBERtprT2AoEl1Tc231kogIQyWcbq9uThkHSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tv+Id9JeFU+k5oSWDS0RZj5z6hElbz+DIh1C2MrsjpllLyTYAAkg8LMGD19YWAdxa
	 hW6ZskFvUkKfE2QJd/y0IdOEg92vAn5scJ5nH05sxvipuATGfv52w5DOx6RMxaz9XZ
	 RgpPi3qc5tDR8yVM4rcEsOGTOBmsL70lB0d8FT2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0940/1887] blktrace: fix __this_cpu_read/write in preemptible context
Date: Wed, 28 Oct 2026 17:50:36 +0100
Message-ID: <20261028170520.803092159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit da46b5dfef48658d03347cda21532bcdbb521e67 ]

tracing_record_cmdline() internally uses __this_cpu_read() and
__this_cpu_write() on the per-CPU variable trace_cmdline_save, and
trace_save_cmdline() explicitly asserts preemption is disabled via
lockdep_assert_preemption_disabled(). These operations are only safe
when preemption is off, as they were designed to be called from the
scheduler context (probe_wakeup_sched_switch() / probe_wakeup()).

__blk_add_trace() was calling tracing_record_cmdline(current) early in
the blk_tracer path, before ring buffer reservation, from process
context where preemption is fully enabled. This triggers the following
using blktests/blktrace/002:

blktrace/002 (blktrace ftrace corruption with sysfs trace)   [failed]
    runtime  0.367s  ...  0.437s
    something found in dmesg:
    [   81.211018] run blktests blktrace/002 at 2026-02-25 22:24:33
    [   81.239580] null_blk: disk nullb1 created
    [   81.357294] BUG: using __this_cpu_read() in preemptible [00000000] code: dd/2516
    [   81.362842] caller is tracing_record_cmdline+0x10/0x40
    [   81.362872] CPU: 16 UID: 0 PID: 2516 Comm: dd Tainted: G                 N  7.0.0-rc1lblk+ #84 PREEMPT(full)
    [   81.362877] Tainted: [N]=TEST
    [   81.362878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
    [   81.362881] Call Trace:
    [   81.362884]  <TASK>
    [   81.362886]  dump_stack_lvl+0x8d/0xb0
    ...
    (See '/mnt/sda/blktests/results/nodev/blktrace/002.dmesg' for the entire message)

[   81.211018] run blktests blktrace/002 at 2026-02-25 22:24:33
[   81.239580] null_blk: disk nullb1 created
[   81.357294] BUG: using __this_cpu_read() in preemptible [00000000] code: dd/2516
[   81.362842] caller is tracing_record_cmdline+0x10/0x40
[   81.362872] CPU: 16 UID: 0 PID: 2516 Comm: dd Tainted: G                 N  7.0.0-rc1lblk+ #84 PREEMPT(full)
[   81.362877] Tainted: [N]=TEST
[   81.362878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   81.362881] Call Trace:
[   81.362884]  <TASK>
[   81.362886]  dump_stack_lvl+0x8d/0xb0
[   81.362895]  check_preemption_disabled+0xce/0xe0
[   81.362902]  tracing_record_cmdline+0x10/0x40
[   81.362923]  __blk_add_trace+0x307/0x5d0
[   81.362934]  ? lock_acquire+0xe0/0x300
[   81.362940]  ? iov_iter_extract_pages+0x101/0xa30
[   81.362959]  blk_add_trace_bio+0x106/0x1e0
[   81.362968]  submit_bio_noacct_nocheck+0x24b/0x3a0
[   81.362979]  ? lockdep_init_map_type+0x58/0x260
[   81.362988]  submit_bio_wait+0x56/0x90
[   81.363009]  __blkdev_direct_IO_simple+0x16c/0x250
[   81.363026]  ? __pfx_submit_bio_wait_endio+0x10/0x10
[   81.363038]  ? rcu_read_lock_any_held+0x73/0xa0
[   81.363051]  blkdev_read_iter+0xc1/0x140
[   81.363059]  vfs_read+0x20b/0x330
[   81.363083]  ksys_read+0x67/0xe0
[   81.363090]  do_syscall_64+0xbf/0xf00
[   81.363102]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   81.363106] RIP: 0033:0x7f281906029d
[   81.363111] Code: 31 c0 e9 c6 fe ff ff 50 48 8d 3d 66 63 0a 00 e8 59 ff 01 00 66 0f 1f 84 00 00 00 00 00 80 3d 41 33 0e 00 00 74 17 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 5b c3 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec
[   81.363113] RSP: 002b:00007ffca127dd48 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[   81.363120] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f281906029d
[   81.363122] RDX: 0000000000001000 RSI: 0000559f8bfae000 RDI: 0000000000000000
[   81.363123] RBP: 0000000000001000 R08: 0000002863a10a81 R09: 00007f281915f000
[   81.363124] R10: 00007f2818f77b60 R11: 0000000000000246 R12: 0000559f8bfae000
[   81.363126] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000a
[   81.363142]  </TASK>

The same BUG fires from blk_add_trace_plug(), blk_add_trace_unplug(),
and blk_add_trace_rq() paths as well.

The purpose of tracing_record_cmdline() is to cache the task->comm for
a given PID so that the trace can later resolve it. It is only
meaningful when a trace event is actually being recorded. Ring buffer
reservation via ring_buffer_lock_reserve() disables preemption, and
preemption remains disabled until the event is committed :-

__blk_add_trace()
       	__trace_buffer_lock_reserve()
       		__trace_buffer_lock_reserve()
       			ring_buffer_lock_reserve()
       				preempt_disable_notrace();  <---

With this fix blktests for blktrace pass:

  blktests (master) # ./check blktrace
  blktrace/001 (blktrace zone management command tracing)      [passed]
      runtime  3.650s  ...  3.647s
  blktrace/002 (blktrace ftrace corruption with sysfs trace)   [passed]
      runtime  0.411s  ...  0.384s

Fixes: 7ffbd48d5cab ("tracing: Cache comms only after an event occurred")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a5b35bcfb0602..5f76d59489fbe 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -251,8 +251,6 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	cpu = raw_smp_processor_id();
 
 	if (blk_tracer) {
-		tracing_record_cmdline(current);
-
 		buffer = blk_tr->array_buffer.buffer;
 		trace_ctx = tracing_gen_ctx_flags(0);
 		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
@@ -260,6 +258,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 						  trace_ctx);
 		if (!event)
 			return;
+		tracing_record_cmdline(current);
 		t = ring_buffer_event_data(event);
 		goto record_it;
 	}
-- 
2.53.0



