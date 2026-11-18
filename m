Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058932;
	b=X5bh3C8JiuP/BsiRbIMsIkmxfCeHYtZRb+GbkDVcaZQAqmqXUVnGMzZM51fV4f/pN42O
	 bVTMFs9D8ZQcm487enVIa7T4LVCq8GmH4Lzg7uzYJck+yQIwBp2cQlxR5Pga36RZ/UBY1
	 e5Rf0jD5IWoNlAqjawJv6lxYzkvjH0Tqj02KHWp+CwNlyjhhY0hoN4iLS2ZfIwrRQroax
	 B2ywGc+X1IPkDlYJp1bbjJa7Rh3PMg8VYSjkBRQeaVKY6eKSZKpH4rSfn5aRdH4wG1PzU
	 vCch9QgA/1YMEY/D2XBsemhFMdMia/EBcfzzJC4bOpUPaALpdsAjOJ8kNALIuBrP9nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RW/JoTPkYtQMuVO56VW2wVdGy/fCiu4nVkNINYJsGMs=;
	b=AORqIX6WYvA869Ju+VI9aX9fV/bH15WAB+Wunvtikxhag883RY9o1R/R+132Y03pPr9j
	 CBLXcpgidnn/aH1N0eLq+HkJoiXssZd9BHfWoJHA3flQBqFzoz+OS9cWkIg8X/rkuX1V3
	 7lxBsZjzr7sPv5WvvqWaaAijwbL2uPwaCBbwV20vQ6VoHnPgJvG2ET98e9hGxpR77bzGg
	 Mx8mRrYbja0wWG4KYZFDnhefF0LBpIXZa3hbuXDR9oBwEFIBGYc/prQbZypo/SDF1EqBb
	 QQrOQ5xAl3xvusbwi4VgAZK+3d3W6rOOMwsTWyihiOprozMPzNYuIFcUzkrQlia6IAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv9Ic3qE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E210A606A325;
	Thu, 19 Nov 2026 03:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv9Ic3qE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83C41F000C7;
	Thu, 19 Nov 2026 03:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058931;
	bh=RW/JoTPkYtQMuVO56VW2wVdGy/fCiu4nVkNINYJsGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uv9Ic3qE3xZTO5Pb+jJ1raUVhlWO0Q9R5aiMJsE4NAnVUoWV8xldT2d+AvK/zCqR2
	 2frFtM0t6XqSTXr0Z61WnEVLggupSflnQYNA7PoJgZ4tTOsmQRUSR2qwezB1b88MJY
	 qPO3RMVMOrLx+ODi9JNrkIi7vXYq7sGyiBQXdjVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qais Yousef <qais.yousef@arm.com>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Tengda Wu <wutengda@huaweicloud.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0660/1848] arm64: kprobes: Fix Uexpected kernel BRK exception at EL1
Date: Wed, 18 Nov 2026 15:44:58 +0100
Message-ID: <20261118145943.397334886@linuxfoundation.org>
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

From: Qais Yousef <qais.yousef@arm.com>

commit 75bd4bff300b3c5252d4a0e7a959569c62d1dbae upstream.

I was hitting the below panic continuously when attaching kprobes to
scheduler functions

	[  159.045212] Unexpected kernel BRK exception at EL1
	[  159.053753] Internal error: BRK handler: f2000006 [#1] PREEMPT SMP
	[  159.059954] Modules linked in:
	[  159.063025] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.11.0-rc4-00008-g1e2a199f6ccd #56
	[rt-app] <notice> [1] Exiting.[  159.071166] Hardware name: ARM Juno development board (r2) (DT)
	[  159.079689] pstate: 600003c5 (nZCv DAIF -PAN -UAO -TCO BTYPE=--)

	[  159.085723] pc : 0xffff80001624501c
	[  159.089377] lr : attach_entity_load_avg+0x2ac/0x350
	[  159.094271] sp : ffff80001622b640
	[rt-app] <notice> [0] Exiting.[  159.097591] x29: ffff80001622b640 x28: 0000000000000001
	[  159.105515] x27: 0000000000000049 x26: ffff000800b79980

	[  159.110847] x25: ffff00097ef37840 x24: 0000000000000000
	[  159.116331] x23: 00000024eacec1ec x22: ffff00097ef12b90
	[  159.121663] x21: ffff00097ef37700 x20: ffff800010119170
	[rt-app] <notice> [11] Exiting.[  159.126995] x19: ffff00097ef37840 x18: 000000000000000e
	[  159.135003] x17: 0000000000000001 x16: 0000000000000019
	[  159.140335] x15: 0000000000000000 x14: 0000000000000000
	[  159.145666] x13: 0000000000000002 x12: 0000000000000002
	[  159.150996] x11: ffff80001592f9f0 x10: 0000000000000060
	[  159.156327] x9 : ffff8000100f6f9c x8 : be618290de0999a1
	[  159.161659] x7 : ffff80096a4b1000 x6 : 0000000000000000
	[  159.166990] x5 : ffff00097ef37840 x4 : 0000000000000000
	[  159.172321] x3 : ffff000800328948 x2 : 0000000000000000
	[  159.177652] x1 : 0000002507d52fec x0 : ffff00097ef12b90
	[  159.182983] Call trace:
	[  159.185433]  0xffff80001624501c
	[  159.188581]  update_load_avg+0x2d0/0x778
	[  159.192516]  enqueue_task_fair+0x134/0xe20
	[  159.196625]  enqueue_task+0x4c/0x2c8
	[  159.200211]  ttwu_do_activate+0x70/0x138
	[  159.204147]  sched_ttwu_pending+0xbc/0x160
	[  159.208253]  flush_smp_call_function_queue+0x16c/0x320
	[  159.213408]  generic_smp_call_function_single_interrupt+0x1c/0x28
	[  159.219521]  ipi_handler+0x1e8/0x3c8
	[  159.223106]  handle_percpu_devid_irq+0xd8/0x460
	[  159.227650]  generic_handle_irq+0x38/0x50
	[  159.231672]  __handle_domain_irq+0x6c/0xc8
	[  159.235781]  gic_handle_irq+0xcc/0xf0
	[  159.239452]  el1_irq+0xb4/0x180
	[  159.242600]  rcu_is_watching+0x28/0x70
	[  159.246359]  rcu_read_lock_held_common+0x44/0x88
	[  159.250991]  rcu_read_lock_any_held+0x30/0xc0
	[  159.255360]  kretprobe_dispatcher+0xc4/0xf0
	[  159.259555]  __kretprobe_trampoline_handler+0xc0/0x150
	[  159.264710]  trampoline_probe_handler+0x38/0x58
	[  159.269255]  kretprobe_trampoline+0x70/0xc4
	[  159.273450]  run_rebalance_domains+0x54/0x80
	[  159.277734]  __do_softirq+0x164/0x684
	[  159.281406]  irq_exit+0x198/0x1b8
	[  159.284731]  __handle_domain_irq+0x70/0xc8
	[  159.288840]  gic_handle_irq+0xb0/0xf0
	[  159.292510]  el1_irq+0xb4/0x180
	[  159.295658]  arch_cpu_idle+0x18/0x28
	[  159.299245]  default_idle_call+0x9c/0x3e8
	[  159.303265]  do_idle+0x25c/0x2a8
	[  159.306502]  cpu_startup_entry+0x2c/0x78
	[  159.310436]  secondary_start_kernel+0x160/0x198
	[  159.314984] Code: d42000c0 aa1e03e9 d42000c0 aa1e03e9 (d42000c0)

After a bit of head scratching and debugging it turned out that it is
due to kprobe handler being interrupted by a tick that causes us to go
into (I think another) kprobe handler.

The culprit was kprobe_breakpoint_ss_handler() returning DBG_HOOK_ERROR
which leads to the Unexpected kernel BRK exception.

Reverting commit ba090f9cafd5 ("arm64: kprobes: Remove redundant
kprobe_step_ctx") seemed to fix the problem for me.

Further analysis showed that kcb->kprobe_status is set to
KPROBE_REENTER when the error occurs. By teaching
kprobe_breakpoint_ss_handler() to handle this status I can no  longer
reproduce the problem.

Fixes: ba090f9cafd5 ("arm64: kprobes: Remove redundant kprobe_step_ctx")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20210122110909.3324607-1-qais.yousef@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/probes/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 215733a51f976..69a8e43b98212 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -375,8 +375,8 @@ kprobe_breakpoint_ss_handler(struct pt_regs *regs, unsigned int esr)
 	unsigned long addr = instruction_pointer(regs);
 	struct kprobe *cur = kprobe_running();
 
-	if (cur && (kcb->kprobe_status == KPROBE_HIT_SS)
-	    && ((unsigned long)&cur->ainsn.api.insn[1] == addr)) {
+	if (cur && (kcb->kprobe_status & (KPROBE_HIT_SS | KPROBE_REENTER)) &&
+	    ((unsigned long)&cur->ainsn.api.insn[1] == addr)) {
 		kprobes_restore_local_irqflag(kcb, regs);
 		post_kprobe_handler(cur, kcb, regs);
 
-- 
2.53.0



