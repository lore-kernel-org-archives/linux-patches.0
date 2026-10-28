Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214422;
	b=MA/dMgdaEzkkEcUGa2EMiOK3nspQqyeotCbGGqY3C1M2aH2GtufWfTZEzcQ4iR+IdU1/
	 udMKhKjB9Ia4Rb0DQX81fcljsoHiJ9EEOFjm4uiodhJXGeztb+rkmDONuQdx2NhgvwREz
	 w1e+z6+O5EDhXRY4ybFSb2PxSV+6EkQUxTL/O5WA4XQtxusQltP7wKOQoyBAfoah7Cmdq
	 zPrSk54CPVoSu8iRqWvqRaH93l4gTnEBBfY3Zj1jcf08Ry/izVFqs3eFOO2Zn2YUXIZHx
	 lo6erRBRcmQdXP+fKNm4Ym4Xm/7IA5bZBnCpxHuemOIX2jTbviQtYtMS5VhlZk+tjuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1cs+OotscWNO6XuGxMHygf0HUxw0pf66UthBUHH1SU=;
	b=AE8PVmGDw4iF13ehS/RDlPqcQMi5zg8kmyiEOBJAR5VEJZqkgyC/knobnojMZIYKeaiP
	 TRwF9RxcV0gw/7gJuhE1oK2l30b+T1eb03LJj6JrNVQDNHRTMfs+tzE7KkTaKQHJvd6at
	 m5PdWLLm3WgNcSD72lEU10FgWBNwzAqBNzzI5Gu7O2aITuxmvew2Sa9fwiJEvX0vc+Z64
	 qfgY+c+yBTWzViLCuElu/cXkTy4DBHgHOyXyjHi+LfM1aC9Nb4yh7qlo59jJdM8B2RmrE
	 TPTgqFXlvcXgx4GaHT8wR8zXjJubz2qnuv/wMw3Aa8NnHS4o7Bciw33tiwCyURlbACA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA5raul1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F522606BF97;
	Wed, 28 Oct 2026 19:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zA5raul1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837CC1F01825;
	Wed, 28 Oct 2026 19:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214422;
	bh=l1cs+OotscWNO6XuGxMHygf0HUxw0pf66UthBUHH1SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zA5raul11hmU80iLuyjNuNl/RKWOSF2sSQxCFeLMC3A/KCSPJfT4ejX+OdHIMdqcI
	 Xq+6drff2BE+fR5jABzGzTCpztOm8E8hv+u5GczzeXtkWTi2uFFHijpV+NbyNTFJQL
	 K54OaIBjexiU1n+TMAYeozg0WVqCQ4U+h2wggo1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Jane Chu <jane.chu@oracle.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0851/1887] x86/mce: use is_copy_from_user() to determine copy-from-user context
Date: Wed, 28 Oct 2026 17:49:07 +0100
Message-ID: <20261028170518.790766837@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 1a15bb8303b6b104e78028b6c68f76a0d4562134 ]

Patch series "mm/hwpoison: Fix regressions in memory failure handling",
v4.

## 1. What am I trying to do:

This patchset resolves two critical regressions related to memory failure
handling that have appeared in the upstream kernel since version 5.17, as
compared to 5.10 LTS.

    - copyin case: poison found in user page while kernel copying from user space
    - instr case: poison found while instruction fetching in user space

## 2. What is the expected outcome and why

- For copyin case:

Kernel can recover from poison found where kernel is doing get_user() or
copy_from_user() if those places get an error return and the kernel return
-EFAULT to the process instead of crashing.  More specifily, MCE handler
checks the fixup handler type to decide whether an in kernel #MC can be
recovered.  When EX_TYPE_UACCESS is found, the PC jumps to recovery code
specified in _ASM_EXTABLE_FAULT() and return a -EFAULT to user space.

- For instr case:

If a poison found while instruction fetching in user space, full recovery
is possible.  User process takes #PF, Linux allocates a new page and fills
by reading from storage.

## 3. What actually happens and why

- For copyin case: kernel panic since v5.17

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and later patches updated the
extable fixup type for copy-from-user operations, changing it from
EX_TYPE_UACCESS to EX_TYPE_EFAULT_REG.  It breaks previous EX_TYPE_UACCESS
handling when posion found in get_user() or copy_from_user().

- For instr case: user process is killed by a SIGBUS signal due to #CMCI
  and #MCE race

When an uncorrected memory error is consumed there is a race between the
CMCI from the memory controller reporting an uncorrected error with a UCNA
signature, and the core reporting and SRAR signature machine check when
the data is about to be consumed.

### Background: why *UN*corrected errors tied to *C*MCI in Intel platform [1]

Prior to Icelake memory controllers reported patrol scrub events that
detected a previously unseen uncorrected error in memory by signaling a
broadcast machine check with an SRAO (Software Recoverable Action
Optional) signature in the machine check bank.  This was overkill because
it's not an urgent problem that no core is on the verge of consuming that
bad data.  It's also found that multi SRAO UCE may cause nested MCE
interrupts and finally become an IERR.

Hence, Intel downgrades the machine check bank signature of patrol scrub
from SRAO to UCNA (Uncorrected, No Action required), and signal changed to
#CMCI.  Just to add to the confusion, Linux does take an action (in
uc_decode_notifier()) to try to offline the page despite the UC*NA*
signature name.

### Background: why #CMCI and #MCE race when poison is consuming in
    Intel platform [1]

Having decided that CMCI/UCNA is the best action for patrol scrub errors,
the memory controller uses it for reads too.  But the memory controller is
executing asynchronously from the core, and can't tell the difference
between a "real" read and a speculative read.  So it will do CMCI/UCNA if
an error is found in any read.

Thus:

1) Core is clever and thinks address A is needed soon, issues a
   speculative read.

2) Core finds it is going to use address A soon after sending the read
   request

3) The CMCI from the memory controller is in a race with MCE from the
   core that will soon try to retire the load from address A.

Quite often (because speculation has got better) the CMCI from the memory
controller is delivered before the core is committed to the instruction
reading address A, so the interrupt is taken, and Linux offlines the page
(marking it as poison).

## Why user process is killed for instr case

Commit 046545a661af ("mm/hwpoison: fix error page recovered but reported
"not recovered"") tries to fix noise message "Memory error not recovered"
and skips duplicate SIGBUSs due to the race.  But it also introduced a bug
that kill_accessing_process() return -EHWPOISON for instr case, as result,
kill_me_maybe() send a SIGBUS to user process.

# 4. The fix, in my opinion, should be:

- For copyin case:

The key point is whether the error context is in a read from user memory.
We do not care about the ex-type if we know its a MOV reading from
userspace.

is_copy_from_user() return true when both of the following two checks are
true:

    - the current instruction is copy
    - source address is user memory

If copy_user is true, we set

m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;

Then do_machine_check() will try fixup_exception() first.

- For instr case: let kill_accessing_process() return 0 to prevent a SIGBUS.

- For patch 3:

The return value of memory_failure() is quite important while discussed
instr case regression with Tony and Miaohe for patch 2, so add comment
about the return value.

This patch (of 3):

Commit 4c132d1d844a ("x86/futex: Remove .fixup usage") introduced a new
extable fixup type, EX_TYPE_EFAULT_REG, and commit 4c132d1d844a
("x86/futex: Remove .fixup usage") updated the extable fixup type for
copy-from-user operations, changing it from EX_TYPE_UACCESS to
EX_TYPE_EFAULT_REG.  The error context for copy-from-user operations no
longer functions as an in-kernel recovery context.  Consequently, the
error context for copy-from-user operations no longer functions as an
in-kernel recovery context, resulting in kernel panics with the message:
"Machine check: Data load in unrecoverable area of kernel."

To address this, it is crucial to identify if an error context involves a
read operation from user memory.  The function is_copy_from_user() can be
utilized to determine:

    - the current operation is copy
    - when reading user memory

When these conditions are met, is_copy_from_user() will return true,
confirming that it is indeed a direct copy from user memory.  This check
is essential for correctly handling the context of errors in these
operations without relying on the extable fixup types that previously
allowed for in-kernel recovery.

So, use is_copy_from_user() to determine if a context is copy user directly.

Link: https://lkml.kernel.org/r/20250312112852.82415-1-xueshuai@linux.alibaba.com
Link: https://lkml.kernel.org/r/20250312112852.82415-2-xueshuai@linux.alibaba.com
Fixes: 4c132d1d844a ("x86/futex: Remove .fixup usage")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/severity.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index 00483d1c27e4f..7793dfd300525 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -283,14 +283,12 @@ static noinstr int error_context(struct mce *m, struct pt_regs *regs)
 	copy_user  = is_copy_from_user(regs);
 	instrumentation_end();
 
-	switch (fixup_type) {
-	case EX_TYPE_UACCESS:
-	case EX_TYPE_COPY:
-		if (!copy_user)
-			return IN_KERNEL;
-		m->kflags |= MCE_IN_KERNEL_COPYIN;
-		fallthrough;
+	if (copy_user) {
+		m->kflags |= MCE_IN_KERNEL_COPYIN | MCE_IN_KERNEL_RECOV;
+		return IN_KERNEL_RECOV;
+	}
 
+	switch (fixup_type) {
 	case EX_TYPE_FAULT_MCE_SAFE:
 	case EX_TYPE_DEFAULT_MCE_SAFE:
 		m->kflags |= MCE_IN_KERNEL_RECOV;
-- 
2.53.0



