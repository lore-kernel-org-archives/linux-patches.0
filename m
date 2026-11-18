Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058686;
	b=oqVSxbBYPDOVkbKtt5BO5mmMPKz3nYZ424Is+vVZYVpxTI2zy00VBqNNG3Tt5cLKgPxV
	 ZMJseX8fyhRD3Vu+udh2+PumGrZ7QB0ZksmhUwMDyGSEuyATEiWfhp59mSJ3+iKIeSja8
	 vITTKjnA3hisQWcLWrRUq9obm0zqF7qNUM5hgP3Kfp6KibnuvwsMuU+lRrFneGZ/oqlZQ
	 XiOCKw9T73imd4F/H8/kQnBy/u78GaCFxU36NpA/FMsHM0pkRcSpiLSOE8zUg/x7BbV7S
	 /YnAxhl1eQnWWgaNQ7esalwYjlY2RQS9xFRXKRYLWJV8YbPYfO0jHfQOzwuMO/03JgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7M11t0jNtj8iF0NLWIZlXaub3svsCGAiAmTFSxJS+kU=;
	b=t5MarzatiruaSHgTgxd7VyDr5NGdV5RoVdh3XmOAkhr/+FkI1BAy28VvPDoCzTxPJO8C
	 VcIc6p6e6Gm79P0o3+U7LWJCAYQ6j8/CJShZ695t2S0ibBH9Jy/IMHpQjtCck23Tz9RAr
	 cVE3zlWpmZJlTR0LJi6ctL1xxfUbZ+niADYsOXPsJpi55Tkg+W2nka0ex0hNED8LetNyE
	 fEBNTifFbVn3sN/4Z0T+uoqQJDCE7o7KUmYC57XWRjUxPBnORY6NoyYY3WUZstYZqWcjn
	 yH0Hl5XFQYqgHGk7thfwMEeR880Mcf4DEvdLbf9B49Mfm26dEBeQmXMGox7xABzLItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DaHB/9V2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93443606A320;
	Thu, 19 Nov 2026 03:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaHB/9V2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7A51F000C5;
	Thu, 19 Nov 2026 03:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058686;
	bh=7M11t0jNtj8iF0NLWIZlXaub3svsCGAiAmTFSxJS+kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaHB/9V2dQ1ttmxC9Jy1N1eH5m/HVws+3Ddzi6ap7kg0/B1Sa6UcgqXeZdnOL+o6Q
	 QwyaR3oXht+6uWsg1QDEsR2vNiFvUvziqqQ8+IIrL5hbetAtOgOIo/z37Q6KXGZunk
	 5G+mCDm1XokEMkYu9EP2HPdw+zofDTiYZ5TK3zdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0533/1848] alpha: run check_mmu_context() from finish_arch_post_lock_switch()
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118145937.317051320@linuxfoundation.org>
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
index 6d7d9bc1b4b87..5dee990e6c039 100644
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



