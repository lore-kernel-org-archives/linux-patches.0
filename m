Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045591;
	b=NwiMkFKlQZ2o3Z9QU1vF+B7T2xtS4yTvNfceYeTH2LWL2+MAQnlgGIg1MCViqomB5QWp
	 9WNgwzW4OuSF45NyNWk3EqkrENkcEcXz0TvKuDTHaAAH7jDoMrUICibeJci8Xhy/V6+Z5
	 v0xCXadRea6dYT/i9ETuZEMoPgpgnnjCGNli0joENqDFL6Sc1145Jc1xkxHsEv49aMAM4
	 lY6NBt2oyqeoUSq5qY/AZG+qEMoeSq9wRP9KrFGW2U7e+2tf4vLhZbAdEFKqYYoj+zVjX
	 CJK91I/SYTqxkle8jWQZ0t9vedhCNa4Uj9NFyqwQ43QzWOsqWXZA5Odlem6NJe6+LlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PimE9OF/jzzeGBeZr3u8jIP5R8kWdYJE2AaiEqT8IGo=;
	b=mnG9Z0qMcGxn9Owp1pRc8FgyCMim5unpD1/hTgVzZo+fMvLG6CFUTXaH33NcV8fXwsON
	 UDum0I7vOUsww9oRJBXrbjcNw3qPIZVV0SYpKd9yyZA2AsHQMq2LMBs9/gQvNK9fzsflN
	 86Yy7tU31NimaDw0OytWp6Kjx6Vlcv5mpM/89umgrS/Z4MrXMM7KY3k++ZTiaVZ6c8yoG
	 Q9PYIZbwgVQwHewvq0D/Oi/FWeWYHkRY0YKWlT0aHyCntQwAtCk0PzlvWdFhK3cZUoVGU
	 tWnui75HXoniUVKORJfIi7eYCEY236vqEL+LhEkgw7H4YVnU0Uz15vbn2E/iDWBgnnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UpM+Z5qb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA46C606A325;
	Wed, 18 Nov 2026 23:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UpM+Z5qb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5551F000C4;
	Wed, 18 Nov 2026 23:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045591;
	bh=PimE9OF/jzzeGBeZr3u8jIP5R8kWdYJE2AaiEqT8IGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpM+Z5qbgOsnbzR+vPAH+ys/CIfrxlnZsDTO0qgeMYXm8S/h/rPpP+yTfIN9ez/3K
	 gZ29sPLkH0d8MSFkYVsyYjA0+0SGGt1JUAAX1iflvHBm8BO/hiu4i121CS03mqrpDV
	 cDfCAkLszu5OAM06z1ZXY8Qq/dXVJdM98nz1y1Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0977/2857] alpha: run check_mmu_context() from finish_arch_post_lock_switch()
Date: Wed, 18 Nov 2026 15:33:31 +0100
Message-ID: <20261118150236.781405015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 4eea7c6169925..7aeee0846dc9d 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -152,8 +152,8 @@ ev5_switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 		next_mm->context[cpu] = mmc;
 	}
 #ifdef CONFIG_SMP
-	else
-		cpu_data[cpu].need_new_asn = 1;
+	/* A deferred shootdown can also invalidate a newly allocated ASN. */
+	cpu_data[cpu].need_new_asn = 1;
 #endif
 
 	/* Always update the PCB ASN.  Another thread may have allocated
@@ -201,6 +201,17 @@ do {								\
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



