Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984AB1DDCE;
	Tue, 16 Jul 2024 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145909; cv=none; b=EVIjpQ4Yn5t7EDWUfKI3Tnpocr8kxXk8ImWUsWPyTG3I8iI/S8a67Z7LqKLNbOoNwuRUGYVixCQOuBvZSTuG6wLTE8YY9g87Ffxxe1UVbiCdUSundElaHKg8wV7OIcMAtR47Oj3C/Fmc24GjyCNgpTWZruPAoefOVUWzWVV1OFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145909; c=relaxed/simple;
	bh=OqIsShOhej59pf+G4WDVXv9IVCfm6W+u2hVB/cWd9u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh+d4yEhoVUnHMtCoefIu9U+YAwXxrZK5/bnlaPg6Et2TY/qAoQISviJ5NcIbnON9APOCvk8QPN96g318ihO1f+KAWIgfDixbpeuSccV5HcAi+qBNbkTB6tkUSjgrQC3qtFh6Rh2/prbYu6Ymt6IK2Nknncc6lhI34tT+RB/KXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HN9FO8hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HN9FO8hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF8EC116B1;
	Tue, 16 Jul 2024 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145909;
	bh=OqIsShOhej59pf+G4WDVXv9IVCfm6W+u2hVB/cWd9u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HN9FO8huSMCWb4Im6n5tyKuUCodRGruLAJm6WWsu52RCSxfq7XiiYilLeNd8nzQaJ
	 pJnYIRFPj5NJpPbNNwCV+J0kUcRkgi45AIn5qr65hvmv6QbJYN8zEC6SVMmXz0JGZn
	 NN+AYlnNdKTBDoMEWteVriT1sKyJEsFVGAlyPUPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/121] x86/entry: Rename ignore_sysret()
Date: Tue, 16 Jul 2024 17:32:59 +0200
Message-ID: <20240716152755.828935281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nik.borisov@suse.com>

[ Upstream commit f71e1d2ff8e6a183bd4004bc97c453ba527b7dc6 ]

The SYSCALL instruction cannot really be disabled in compatibility mode.
The best that can be done is to configure the CSTAR msr to point to a
minimal handler. Currently this handler has a rather misleading name -
ignore_sysret() as it's not really doing anything with sysret.

Give it a more descriptive name.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230623111409.3047467-3-nik.borisov@suse.com
Stable-dep-of: ac8b270b61d4 ("x86/bhi: Avoid warning in #DB handler due to BHI mitigation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S        | 4 ++--
 arch/x86/include/asm/processor.h | 2 +-
 arch/x86/kernel/cpu/common.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 5d96561c0d6ad..1edb8e1b9e018 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1527,13 +1527,13 @@ SYM_CODE_END(asm_exc_nmi)
  * This handles SYSCALL from 32-bit code.  There is no way to program
  * MSRs to fully disable 32-bit SYSCALL.
  */
-SYM_CODE_START(ignore_sysret)
+SYM_CODE_START(entry_SYSCALL32_ignore)
 	UNWIND_HINT_END_OF_STACK
 	ENDBR
 	mov	$-ENOSYS, %eax
 	CLEAR_CPU_BUFFERS
 	sysretl
-SYM_CODE_END(ignore_sysret)
+SYM_CODE_END(entry_SYSCALL32_ignore)
 #endif
 
 .pushsection .text, "ax"
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6e19d0f226000..67ad64efa9263 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -399,7 +399,7 @@ static inline unsigned long cpu_kernelmode_gs_base(int cpu)
 	return (unsigned long)per_cpu(fixed_percpu_data.gs_base, cpu);
 }
 
-extern asmlinkage void ignore_sysret(void);
+extern asmlinkage void entry_SYSCALL32_ignore(void);
 
 /* Save actual FS/GS selectors and bases to current->thread */
 void current_save_fsgs(void);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 340dd6cc11af4..74d566263467e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2134,7 +2134,7 @@ void syscall_init(void)
 		    (unsigned long)(cpu_entry_stack(smp_processor_id()) + 1));
 	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)entry_SYSENTER_compat);
 #else
-	wrmsrl_cstar((unsigned long)ignore_sysret);
+	wrmsrl_cstar((unsigned long)entry_SYSCALL32_ignore);
 	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
 	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
 	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
-- 
2.43.0



