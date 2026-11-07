Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064983;
	b=YR8mYOVB00zZwuMip1XXFaHxdc8qPR1ucfUkEB7DR8hgahPVZ4IsTs8LvEXPs1htQ2TD
	 2X2QGQxQgSB4ljaGrO8ptPewTe6pOHizZc0pEpA4IhCm8/hM9CfbbEHXIwP2tgA1JW7fg
	 Sa9xMZNV44b1PowmY83CwHNNe9RwJhMLzv6Yx4JMojYeRi8jV1eQ001RR9FOb1SEc/TdO
	 9i6vBAYHxMFQHrtYpbt1YWNkBab2nZPX8U6YAiUjKqeJbDj0zgTfOD8YqMo+eqmePv/0a
	 +0GCBkTvDSlC1piO8SESpGxrgRaLH9123ZqB02ozMH5rRXXfUVaC65RAzuKF4BRHLbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cvL13YGsaNIO/58OqQ6VM/aH3aw1295BojnFV331P8k=;
	b=Gxhlqs0UCtFucKcE9m2L1pS8CvU3CxMufpyLHjE2FXQZ4bsSnK5CaRnoKis8og1fctog
	 XnJvWIvSwlQDPPLgltnVpVzhmSBw4G8oWmdXExWZPvKVwfd9tfUOz0+OXOw8troJkt7+K
	 N8vmM5QqAKz103hc2MrWDZEQyb3vm/AHdpq1c12GODcZItnWcwFcM+UKCc8/qN1b/3I6A
	 ecBQwe/opS9BnHeF1L45k33zemHbDVpXjL+cakNUdYt3GFZ5Pkx35l7uotidv00xP6Ikx
	 8o/7dyPNTsGqvS6Dng5Sftd2ZOGKl5F5A+KNv3kLD4nOOLDlYRvVxpEP6mo8yTQ23sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AF0E08Gp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAD606A336;
	Sat,  7 Nov 2026 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AF0E08Gp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BDE1F0089F;
	Sat,  7 Nov 2026 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064983;
	bh=cvL13YGsaNIO/58OqQ6VM/aH3aw1295BojnFV331P8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AF0E08Gpd2k7EEVzoyc4jhQg68IFH4Sy97tbAKQgyOn1ZTRDYm0ZZ+GY0OZlqm8tB
	 ezDZWUtOUWLY6A/F8wE1SlHTpZnF0R9GXNWrA6bBI74/IgiBP2SL+LTHnTGGavEvjD
	 B6abagNglGq3F3uKzb2/am/z/ee+UoGUHZcyKHEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0859/1257] alpha: run check_mmu_context() from finish_arch_post_lock_switch()
Date: Sat,  7 Nov 2026 08:52:35 -0500
Message-ID: <20261107135003.055400435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



