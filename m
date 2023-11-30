Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D365813C;
	Thu, 30 Nov 2023 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtsswBaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2715C433C8;
	Thu, 30 Nov 2023 22:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385104;
	bh=XqkrEfHSvL03T9YszMrafbMZPhJ0Eme0dXKmNb5Basg=;
	h=From:Subject:Date:To:Cc:From;
	b=DtsswBaXK8I7eINNJKSYa1lWi2RRlKT5e8rAffQrZAngLWR8XQXJSsfBp5FoA4vaY
	 XlQPP5YAwN74nN/d2h44NaEOm0eRUElV23slNXLI6PQwsgHBTmq6KEwe9jkPpdooTy
	 zz8Bxwfnrrl8fiKKcYjtgNmOskD+QZuqek0BVt9+yEY3B51XeMY9dRyAlkpNWTWpoR
	 oAKUdM0JX0+81YPWcAGIhhbwNtC4ifbU/VBf+EjPjDvCZIYtBgfu3+f111bG+5TOo+
	 w8ZuIPocnnh3TRyYI94v8K0LWiMNuX53VFv9mMRBeOWbAh9tqQzTlzPxah462mQ19R
	 r3+LjQvYesKNA==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 00/19] hexagon: Fix up instances of -Wmissing-prototypes
Date: Thu, 30 Nov 2023 15:58:13 -0700
Message-Id: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIUTaWUC/x3MQQqDMBAF0KvIrDuQaKroVYoLsb/JLJqEjIgi3
 r2hy7d5FymKQGlqLirYRSXFCvtoaA1L9GB5V1Nr2s7aznDAsfgU+SuqEj3nkra0nRnKPczTOjf
 0IwaqQS74yPHPX/N9/wCD4M05bAAAAA==
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2553; i=nathan@kernel.org;
 h=from:subject:message-id; bh=XqkrEfHSvL03T9YszMrafbMZPhJ0Eme0dXKmNb5Basg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr2i4d3ySgsj2Xi1b/HJWh123qAclNw+8/PVtTrcO
 vFtf5s7SlkYxLgYZMUUWaofqx43NJxzlvHGqUkwc1iZQIYwcHEKwESO1TD8Tz61sixT+ZuzZV3h
 iXNzFr+8vtQurKC/+sTliQu/7pWe58rI8IX72mrvS4XTzorNq7tQZBc5qXjjhvlO3/6+4y56q8Y
 wlxMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series fixes all the instances of -Wmissing-prototypes in
arch/hexagon, now that it is enabled globally in a default build. I hope
most of the patches will be uncontroversial but please let me know
otherwise. This survives ARCH=hexagon defconfig and allmodconfig with
LLVM 17.0.6.

This is based on Arnd's asm-generic-prototypes branch but it applies
cleanly to 6.7-rc3 as well, in case Andrew wants to take it (as far as
I remember, he has handled Hexagon patches for me in the past).

---
Nathan Chancellor (19):
      hexagon: uaccess: Remove clear_user_hexagon()
      hexagon: mm: Mark paging_init() as static
      hexagon: mm: Include asm/setup.h for setup_arch_memory()'s prototype
      hexagon: smp: Mark handle_ipi() and start_secondary() as static
      hexagon: vm_fault: Mark do_page_fault() as static
      hexagon: vm_fault: Include asm/vm_fault.h for prototypes
      hexagon: vm_tlb: Include asm/tlbflush.h for prototypes
      hexagon: time: Include asm/time.h for prototypes
      hexagon: time: Mark time_init_deferred() as static
      hexagon: time: Include asm/delay.h for prototypes
      hexagon: signal: Switch to SYSCALL_DEFINE0 for sys_rt_sigreturn()
      hexagon: reset: Include linux/reboot.h for prototypes
      hexagon: process: Include linux/cpu.h for arch_cpu_idle() prototype
      hexagon: process: Add internal prototype for do_work_pending()
      hexagon: vdso: Include asm/elf.h for arch_setup_additional_pages() prototype
      hexagon: vm_events: Remove unused dummy_handler()
      hexagon: irq: Add prototype for arch_do_IRQ()
      hexagon: traps: Remove sys_syscall()
      hexagon: traps: Add internal prototypes for functions only called from asm

 arch/hexagon/include/asm/irq.h  |  3 +++
 arch/hexagon/kernel/process.c   |  2 ++
 arch/hexagon/kernel/reset.c     |  1 +
 arch/hexagon/kernel/signal.c    |  2 +-
 arch/hexagon/kernel/smp.c       |  4 ++--
 arch/hexagon/kernel/time.c      |  4 +++-
 arch/hexagon/kernel/traps.c     | 11 ++++-------
 arch/hexagon/kernel/vdso.c      |  1 +
 arch/hexagon/kernel/vm_events.c |  7 -------
 arch/hexagon/mm/init.c          |  3 ++-
 arch/hexagon/mm/uaccess.c       |  8 --------
 arch/hexagon/mm/vm_fault.c      |  3 ++-
 arch/hexagon/mm/vm_tlb.c        |  1 +
 13 files changed, 22 insertions(+), 28 deletions(-)
---
base-commit: 6479f0df0b7b7e977357e524bdd2eb3aeb4fd085
change-id: 20231130-hexagon-missing-prototypes-6e05144769e7

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

