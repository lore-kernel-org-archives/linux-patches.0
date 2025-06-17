Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C862DE1E1;
	Tue, 17 Jun 2025 12:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750162915; cv=none; b=LLbFe90Sva4/702kTYWYaT2hyd3lNl4DkZunch+KbSIcGzdxZJ3kwo7njA9zdDmWkzMjzWgFqylyTyDeNPKoivJjg8OGBoiTHRl8e+1pPFqTXhzElcUTuRdAauxkNqx9jjCHmuyj9SGHBo2FcHtvdQhgttbSmeqTLa9MH7Lm9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750162915; c=relaxed/simple;
	bh=LfNxyhUN2JsWTRujKmyyweoPVwm/To5NK4yIewPAdQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwGyk/I2TFnK1TPgh/D16QNYeEdswIstPl4uZfx9QrpvpofJl52uSGrD2uwBHdkYNbyki3/+qGkqzbDKimI1JBe7SRgh34t7psI2nVSYeyYFdtWppnqQdz3LwPbGBj6/Jx4OtbA5JjdwFoLgYPN5M2s/Mork7tV90Hg9VnNb+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2uHXI4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2uHXI4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2870EC4CEE3;
	Tue, 17 Jun 2025 12:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750162914;
	bh=LfNxyhUN2JsWTRujKmyyweoPVwm/To5NK4yIewPAdQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2uHXI4oohVCy5dYpRkCsuVJ3Fnk78oT9fSNbuA+e5sVbkB6qFxnD4Uxq21BiX8vl
	 0eZO4jyM55lexvfqfg3VkI0UGGOvdhAYyORtQoUvBII7yQPMZIBWfjzXxrDSLBfoCd
	 yKPpF7rO+czEi1rlT4Z93mIlNrEciT+XN7Jlx+DS79jpDyXlJNBqtU5cfNMIy22Wnz
	 zvIRrb6NLMEQ72NfM4XLt7VuxxYej/bNTfRsLDrjveBgB0tWvD6fhUErYp1s/rp5N9
	 2SolMiwAGtS+2mAimdPdF2qQdKpBjKJBSl7VZ2/mYU30oa65LxYQ0Yr//XGUGu09ze
	 lEfWTzp7qsluA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.walmsley@sifive.com,
	aou@eecs.berkeley.edu,
	conor.dooley@microchip.com,
	alexghiti@rivosinc.com,
	jesse@rivosinc.com,
	nylon.chen@sifive.com,
	zhangchunyan@iscas.ac.cn,
	evan@rivosinc.com,
	linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 6.15 03/15] riscv: misaligned: declare misaligned_access_speed under CONFIG_RISCV_MISALIGNED
Date: Tue, 17 Jun 2025 08:21:33 -0400
Message-Id: <20250617122147.1968355-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617122147.1968355-1-sashal@kernel.org>
References: <20250617122147.1968355-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.2
Content-Transfer-Encoding: 8bit

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 1317045a7d6f397904d105f6d40dc9787876a34b ]

While misaligned_access_speed was defined in a file compile with
CONFIG_RISCV_MISALIGNED, its definition was under
CONFIG_RISCV_SCALAR_MISALIGNED. This resulted in compilation problems
when using it in a file compiled with CONFIG_RISCV_MISALIGNED.

Move the declaration under CONFIG_RISCV_MISALIGNED so that it can be
used unconditionnally when compiled with that config and remove the check
for that variable in traps_misaligned.c.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250523101932.1594077-9-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees.

## Analysis

This commit fixes a **compilation configuration dependency issue** in
the RISC-V architecture's misaligned access handling code. Here's my
detailed analysis:

### The Problem Fixed
The commit addresses a compilation issue where:

1. **Variable Declaration Mismatch**: The `misaligned_access_speed` per-
   CPU variable was defined in `unaligned_access_speed.c` under
   `CONFIG_RISCV_MISALIGNED`, but its declaration in `cpufeature.h` was
   under `CONFIG_RISCV_SCALAR_MISALIGNED`.

2. **Configuration Hierarchy**: From the Kconfig analysis:
   - `CONFIG_RISCV_MISALIGNED` is a broader umbrella config
   - `CONFIG_RISCV_SCALAR_MISALIGNED` selects `CONFIG_RISCV_MISALIGNED`
   - Both `traps_misaligned.c` and `unaligned_access_speed.c` are
     compiled under `CONFIG_RISCV_MISALIGNED`

3. **Compilation Failure**: When `CONFIG_RISCV_MISALIGNED` is enabled
   but `CONFIG_RISCV_SCALAR_MISALIGNED` is not, code in
   `traps_misaligned.c` tries to use `misaligned_access_speed` (line
   372: `*this_cpu_ptr(&misaligned_access_speed) =
   RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;`) but the variable isn't
   declared in the header.

### The Fix
The commit makes two key changes:

1. **In `cpufeature.h`**: Moves the `DECLARE_PER_CPU(long,
   misaligned_access_speed);` declaration from
   `CONFIG_RISCV_SCALAR_MISALIGNED` to `CONFIG_RISCV_MISALIGNED` (lines
   82-84 in the new version)

2. **In `traps_misaligned.c`**: Removes the conditional `#ifdef
   CONFIG_RISCV_PROBE_UNALIGNED_ACCESS` guard around the assignment to
   `misaligned_access_speed` (line 372), making it unconditional when
   compiled under `CONFIG_RISCV_MISALIGNED`

### Why This Should Be Backported

1. **Fixes Compilation Errors**: This is a clear build fix for valid
   kernel configurations, preventing compilation failures that would
   break the kernel build.

2. **Small and Contained**: The changes are minimal - just moving a
   declaration to the correct config section and removing an unnecessary
   guard.

3. **No Functional Changes**: This doesn't change runtime behavior, only
   fixes the build system configuration dependencies.

4. **Low Risk**: The fix aligns the declaration with where the variable
   is actually used, making the code more consistent and correct.

5. **Matches Stable Criteria**: Similar to **Similar Commit #4** which
   was marked as backport candidate (YES), this fixes compilation issues
   in configuration management without introducing new features or
   architectural changes.

6. **Critical Subsystem**: Unaligned access handling is important for
   RISC-V platforms, and build failures in this area prevent kernel
   compilation for affected configurations.

This is exactly the type of build fix that stable trees should include -
it resolves compilation errors without changing functionality or
introducing regression risks.

 arch/riscv/include/asm/cpufeature.h  | 5 ++++-
 arch/riscv/kernel/traps_misaligned.c | 2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index f56b409361fbe..7201da46694f7 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -71,7 +71,6 @@ bool __init check_unaligned_access_emulated_all_cpus(void);
 void check_unaligned_access_emulated(struct work_struct *work __always_unused);
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
-DECLARE_PER_CPU(long, misaligned_access_speed);
 #else
 static inline bool unaligned_ctl_available(void)
 {
@@ -79,6 +78,10 @@ static inline bool unaligned_ctl_available(void)
 }
 #endif
 
+#if defined(CONFIG_RISCV_MISALIGNED)
+DECLARE_PER_CPU(long, misaligned_access_speed);
+#endif
+
 bool __init check_vector_unaligned_access_emulated_all_cpus(void);
 #if defined(CONFIG_RISCV_VECTOR_MISALIGNED)
 void check_vector_unaligned_access_emulated(struct work_struct *work __always_unused);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 77c788660223b..fe0ab912014ba 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -368,9 +368,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
-#endif
 
 	if (!unaligned_enabled)
 		return -1;
-- 
2.39.5

