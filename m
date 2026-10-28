Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214031;
	b=t8Ic3PJQEhfV+bQsdZ3mgh+IHPN7aPprHtMmOST7HPmKRplyfONbYu6E4WSTwiGLS3mk
	 190+OFTxSW9ww1JtqddXvH2EEpLFTNPh0SolJsWr6Rhoz1aYcqSwPJ8eESYF9LljVEO6l
	 Xdr2N6Vj82UZv4uSWhYxwkA3G6G7ZG2PjMASSQu/V3wSx3JTEreoaYFzDYsnU5lDH8iJQ
	 Fa3Vc/t9JwAWIrFb5CNa31DL5ECLLJBeOLqh609eO2bOAukLFM3OINIzTFIldNMS3Pb4V
	 FxT7TMFeTc4RTYO/ihbxgjU87SrbOmemU8EERHMLh9/SnXNZuKCWccVGEbR1q5Xvkxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3k7rTFYEsjIi8lc0W09Dz0FZCDUMYh30Fq1BpBkxysk=;
	b=TLwh6CUwH3cSdNImB5p8V4XREsWLzS/P4d3XJSUPanBkLUQDLDWf2qQ0Ut5pxk7TdZSO
	 flnkNzIpZtb2m1cSzBLlAiYD6j1J+pb/T18XPgoD3cxPMGSAqffB92dVifOL8/oB7hTBo
	 W2IvAZh8cit5lRTI2STc6wOPQT1QJzZYpogtYpi1/Qc79AgxYJjAPhI67Bl0k0bg8NmX2
	 UBcwoOhpugAn6IahI1WQivulCnAo6h+aCMNEXO2V6BfEfg0ZhphdfhqvsdRt5NCX6rZDU
	 azg6md3Hk3IMF6qpi3D3OddvZmPMuFmxDmrmuHRbM43jRfVG30f6dJE40RwOvCV5yDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Mk/BxsUI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4737606A333;
	Wed, 28 Oct 2026 19:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mk/BxsUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE001F031E2;
	Wed, 28 Oct 2026 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214017;
	bh=3k7rTFYEsjIi8lc0W09Dz0FZCDUMYh30Fq1BpBkxysk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mk/BxsUI0X2aAWD67Nlf5zAMv2SbR1JzGXJk08zuqRTN7jWcRWF10ORN9yL2HCL1D
	 +qkwMnf5vqqVBEtKw+LJCM9ygAl5mJ0ZxUpXL4cALh6f29hSdU1Y7oxJng8oRvrcbu
	 ExIfkVuEIeSJIx7f8tU26p/ka7RtNfDfpIkR6jNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0708/1887] sched/deadline: Fix warning in migrate_enable for boosted tasks
Date: Wed, 28 Oct 2026 17:46:44 +0100
Message-ID: <20261028170515.526913131@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 0664e2c311b9fa43b33e3e81429cd0c2d7f9c638 ]

When running the following command:

while true; do
    stress-ng --cyclic 30 --timeout 30s --minimize --quiet
done

a warning is eventually triggered:

WARNING: CPU: 43 PID: 2848 at kernel/sched/deadline.c:794
setup_new_dl_entity+0x13e/0x180
...
Call Trace:
 <TASK>
 ? show_trace_log_lvl+0x1c4/0x2df
 ? enqueue_dl_entity+0x631/0x6e0
 ? setup_new_dl_entity+0x13e/0x180
 ? __warn+0x7e/0xd0
 ? report_bug+0x11a/0x1a0
 ? handle_bug+0x3c/0x70
 ? exc_invalid_op+0x14/0x70
 ? asm_exc_invalid_op+0x16/0x20
 enqueue_dl_entity+0x631/0x6e0
 enqueue_task_dl+0x7d/0x120
 __do_set_cpus_allowed+0xe3/0x280
 __set_cpus_allowed_ptr_locked+0x140/0x1d0
 __set_cpus_allowed_ptr+0x54/0xa0
 migrate_enable+0x7e/0x150
 rt_spin_unlock+0x1c/0x90
 group_send_sig_info+0xf7/0x1a0
 ? kill_pid_info+0x1f/0x1d0
 kill_pid_info+0x78/0x1d0
 kill_proc_info+0x5b/0x110
 __x64_sys_kill+0x93/0xc0
 do_syscall_64+0x5c/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
 RIP: 0033:0x7f0dab31f92b

This warning occurs because set_cpus_allowed dequeues and enqueues tasks
with the ENQUEUE_RESTORE flag set. If the task is boosted, the warning
is triggered. A boosted task already had its parameters set by
rt_mutex_setprio, and a new call to setup_new_dl_entity is unnecessary,
hence the WARN_ON call.

Check if we are requeueing a boosted task and avoid calling
setup_new_dl_entity if that's the case.

Fixes: 295d6d5e3736 ("sched/deadline: Fix switching to -deadline")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20240724142253.27145-2-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 83204e5b780e4..972a5e728c10e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1656,6 +1656,7 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_RESTORE) &&
+		   !is_dl_boosted(dl_se) &&
 		  dl_time_before(dl_se->deadline,
 				 rq_clock(rq_of_dl_rq(dl_rq_of_se(dl_se))))) {
 		setup_new_dl_entity(dl_se);
-- 
2.53.0



