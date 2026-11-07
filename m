Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062433;
	b=h5ins392yjIC4BMyjzClLGD62Mqkyy7mf4lqmQ//xa80eZV6xMAAlXCq50QJihkpempj
	 zaoe1kvTQ06ccdW7zQgl7HkgyXZDW7mM5V/QxA5rz+ditYfrGF4dpg8ATCdhluCRn6qvq
	 AOOY87Xz0uEGBdcDWkCQQ1T9rDGkLixcm5BE/FE+bcBYFJtGvWNYFST3mwJq9PqDmwK2b
	 M+vaYzRjVxiP+8+mH8uJaR+iyvxN/c8eAkhZJrkAUGWo07tFBx/lwiUgQlDr/35EWXytu
	 uhRMtmO0/x0FpKsVPTqT5RRe0z1BVy0XSoA4R0d5NMD33XCYvrOmgGJzU6rTL1uqdtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yd7GYqznL7EL1v+NWdDdh8F9hhNtM0X7r6nB6Eu/pyg=;
	b=P13yidQbr1pJSkvWAxQDt2E845pvtnDXXxLTosnUnpUMXGwwF2O+eHQw+hf4XPz0QEMI
	 D1uQJZy/L7zMzMVSrjNdB55BaZOIhsTpB54KO6wJBuJfk9s8iN2xOzmcsEm7uukjYRUq4
	 qZ98JSLaNKj0BHoO8svT7YsnIi1Sum4LqBuzfa1GqLXX9bzVhUvQD4kRM00Z3BAnsBsJq
	 EnlWXiLwfT/fi8C3uvYX9ThfRehvy/uu+fcN8gBciLLaUDZZYypn/m6LrOKUus/MwxUTZ
	 Wp2rrIplPwaSoHaEHXmtwCo9zPrwe2Y+vv1nABLMaoSxu4rot3XBdJCENmA0rC68abQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyUF7UBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D2D606EE8D;
	Sat,  7 Nov 2026 14:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyUF7UBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DACF1F0089F;
	Sat,  7 Nov 2026 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062432;
	bh=Yd7GYqznL7EL1v+NWdDdh8F9hhNtM0X7r6nB6Eu/pyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyUF7UBlYrAu+BcaEM3bSPkmhBiiOA9s1pOU5D2C4kD4pGTu4HOSVUd9b93f9QapY
	 f1yccY1wUrlMShhrQXntv7bzb+OH1C+hPKQdTMjjNpyNNecY1U26uxBO3kqV9rs54i
	 /zyCaSfNKOppo6p1Zj8wv2Iwb04rbpLnjW4LLZnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1344/1536] alpha: run check_mmu_context() from finish_arch_post_lock_switch()
Date: Sat,  7 Nov 2026 08:56:00 -0500
Message-ID: <20261107135035.572884770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 020d2e70b7538b66eee3c3480d2b8921fb182f0c ]

check_mmu_context() clears asn_lock and acts on need_new_asn, but it
runs only as the tail of switch_to(), after alpha_switch_to() returns.

A newly forked user task never gets there: its first context switch
resumes at ret_from_fork and reaches schedule_tail() without returning
to the code following alpha_switch_to().

asn_lock is left set on that CPU, so the new user task can run with
interrupts enabled while shootdown IPIs keep taking the deferred path.
The handshake meant to complete those invalidations never runs.

New kernel threads also reach schedule_tail(), but context_switch()
does not call switch_mm() for a task without an mm. They therefore do
not set asn_lock in the first place and are not affected by this bug.

Move check_mmu_context() to finish_arch_post_lock_switch(), which is
called by finish_task_switch() for both existing and newly created tasks.
Drop the now redundant call from switch_to().

The hook runs after finish_lock_switch() releases the rq lock and enables
interrupts. An IPI arriving before asn_lock is cleared retires the slot
through flush_tlb_other(); an IPI arriving afterwards can flush directly,
since PAL_swpctx has already installed the incoming context.

Set need_new_asn whether ev5_switch_mm() reuses or allocates an ASN. An
IPI in that interval can zero either slot. Without this, the allocated
case can return to user space with a live ASN but a zero context slot,
which a later context-based shootdown shortcut could mistake for an
inactive CPU. check_mmu_context() reloads only when the slot is zero.

Call the hook unconditionally. Alpha selects ARCH_NO_PREEMPT, and neither
kthread_use_mm() nor sched_force_init_mm() sleeps between the direct
switch and this hook. RCU_STRICT_GRACE_PERIOD can enable PREEMPT_COUNT,
but cannot make those callers migrate there. Testing preemptible() would
only leave asn_lock set in that configuration.

This requires the preceding direct-switch fix, "alpha: load the MMU
context when switch_mm() switches the current task". It installs the
borrowed context before kthread_use_mm() reaches this hook, so clearing
asn_lock cannot expose a targeted invalidate against the wrong context.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-3-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/mmu_context.h | 15 +++++++++++++--
 arch/alpha/include/asm/switch_to.h   |  1 -
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/include/asm/mmu_context.h b/arch/alpha/include/asm/mmu_context.h
index d366f89fee585..f41d7c73fdd64 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -162,8 +162,8 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 		next_mm->context[cpu] = mmc;
 	}
 #ifdef CONFIG_SMP
-	else
-		cpu_data[cpu].need_new_asn = 1;
+	/* A deferred shootdown can also invalidate a newly allocated ASN. */
+	cpu_data[cpu].need_new_asn = 1;
 #endif
 
 	/* Always update the PCB ASN.  Another thread may have allocated
@@ -192,6 +192,17 @@ do {								\
 #define check_mmu_context()  do { } while(0)
 #endif
 
+/*
+ * Also called from kthread_use_mm() with preemption enabled. Alpha has
+ * no kernel preemption, so the task is still on the CPU that ran
+ * switch_mm().
+ */
+#define finish_arch_post_lock_switch finish_arch_post_lock_switch
+static inline void finish_arch_post_lock_switch(void)
+{
+	check_mmu_context();
+}
+
 __EXTERN_INLINE void
 ev5_activate_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm)
 {
diff --git a/arch/alpha/include/asm/switch_to.h b/arch/alpha/include/asm/switch_to.h
index 762b7f975310c..35c4b2c9d9923 100644
--- a/arch/alpha/include/asm/switch_to.h
+++ b/arch/alpha/include/asm/switch_to.h
@@ -9,7 +9,6 @@ extern struct task_struct *alpha_switch_to(unsigned long, struct task_struct *);
 #define switch_to(P,N,L)						 \
   do {									 \
     (L) = alpha_switch_to(virt_to_phys(&task_thread_info(N)->pcb), (P)); \
-    check_mmu_context();						 \
   } while (0)
 
 #endif /* __ALPHA_SWITCH_TO_H */
-- 
2.53.0



