Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B6B661;
	Mon,  6 Oct 2025 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774719; cv=none; b=ogefgl+wQGwhFP57m1aAkN2cRo9R9lNaCGSJN0DqcV/CvDoUIO7FEQ4Lm95s7oYf47BqnT+V7rK9bSVy0tD78nMVbhaoEF2SV8dfo7g9A7jJdC6q2LdoFUcemXIFF+gw/2zZq9YvQVnf6NM6Rxs20qOCSYNzW4tnL8vQZZAotGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774719; c=relaxed/simple;
	bh=R1mnFJVtirenhdP0X3we1THI4lBu0uptnlr13foqCDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=clqfpMeJ1PAX58fM4DbQIet8ErRrul+0rNVFX+lPFHCRpHiI9kMwFevewjNoeRgssruRtXCfLoTPynCn/BD4sF95Gn/JSmOJ0A29yu7O4JRrdS1IKOIbOLxfQuLRyNH8PSJOqj1R3QjaLIMPDOF3qik4sxLLM9bBEmwwgZ1sVTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNaEequq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNaEequq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE2AC4CEF5;
	Mon,  6 Oct 2025 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774718;
	bh=R1mnFJVtirenhdP0X3we1THI4lBu0uptnlr13foqCDM=;
	h=From:To:Cc:Subject:Date:From;
	b=ZNaEequq2D2ioKzjjSX7bUj37yiPmvXpvCGGcdC3D12R+4l73kYNQ6EhLAJ/QVe7V
	 xAY2WEvF8XoHAc+oq8yVOZ67gBrNzilojtJtv4vvTXu2gyqkxc06rYrEwLUC1esE7m
	 D4F1yYnY8F+f8bU5A+4xsQsw5Zk2S2C/H0gsFYqXrlZerB3zVRBw9XjgtwDI5P0PrI
	 aT05szO8qhQvlBZw0xC9Dmj2JFN1aRcw8IpO9AnPHAiSHtzPzjCL4dUiP/LWr8kqJr
	 NmjDJX9sHYSnFGAok6TX6nmVwYPwue+dNw80WmRaF0wj0/S5gqmM2OaV8zfyldN5PE
	 WXDjEIQ+al6EQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nathan Chancellor <nathan@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] x86/build: Remove cc-option from stack alignment flags
Date: Mon,  6 Oct 2025 14:17:33 -0400
Message-ID: <20251006181835.1919496-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit d87208128a3330c0eab18301ab39bdb419647730 ]

'-mpreferred-stack-boundary' (the GCC option) and '-mstack-alignment'
(the clang option) have been supported in their respective compilers for
some time, so it is unnecessary to check for support for them via
cc-option. '-mpreferred-stack-boundary=3' had a restriction on
'-mno-sse' until GCC 7.1 but that is irrelevant for most of the kernel,
which includes '-mno-sse'.

Move to simple Kconfig checks to avoid querying the compiler for the
flags that it supports.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250814-x86-min-ver-cleanups-v1-2-ff7f19457523@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis of this commit, here is my
determination:

## Backport Status: NO

### Extensive Analysis

**Commit Context:**
- Upstream commit: d87208128a3330c0eab18301ab39bdb419647730 (August 14,
  2025)
- Author: Nathan Chancellor
- Part of patch series: "x86-min-ver-cleanups-v1"
- Already backported to 6.17 stable as 8be33f616f1c4 via AUTOSEL
  (Automatic Stable Election)
- Target tree: linux-autosel-6.17 (kernel 6.17)

**What the Commit Does:**
The commit removes runtime compiler capability checks (`cc-option`) for
stack alignment flags and replaces them with build-time Kconfig checks:
- For GCC: Uses `CONFIG_CC_IS_GCC` to unconditionally set `-mpreferred-
  stack-boundary=2/3`
- For Clang: Uses `CONFIG_CC_IS_CLANG` to unconditionally set `-mstack-
  alignment=4/8`

**Code Changes Analysis:**
```makefile
# OLD: Runtime check if compiler supports the flags
-ifneq ($(call cc-option, -mpreferred-stack-boundary=4),)
+ifdef CONFIG_CC_IS_GCC
       cc_stack_align4 := -mpreferred-stack-boundary=2
       cc_stack_align8 := -mpreferred-stack-boundary=3
-else ifneq ($(call cc-option, -mstack-alignment=16),)
+endif
+ifdef CONFIG_CC_IS_CLANG
       cc_stack_align4 := -mstack-alignment=4
       cc_stack_align8 := -mstack-alignment=8
 endif
```

**Dependency Analysis:**
- Requires minimum GCC 8.1 for x86 (introduced in v6.15 via commit
  a3e8fe814ad1)
- Requires minimum Clang 15.0.0 for x86 (commit 7861640aac52b)
- Both requirements are satisfied in 6.17 stable tree (verified via
  scripts/min-tool-version.sh)
- GCC 7.1+ supports `-mpreferred-stack-boundary=3` with `-msse` (per GCC
  commit 34fac449e121)

**Evaluation Against Stable Kernel Rules:**

According to Documentation/process/stable-kernel-rules.rst, stable
patches must:

1. ✅ **Already exist in mainline**: YES -
   d87208128a3330c0eab18301ab39bdb419647730
2. ✅ **Obviously correct and tested**: YES - simple Makefile change, no
   issues found
3. ✅ **Not bigger than 100 lines**: YES - only 5 lines changed (3
   insertions, 2 deletions)
4. ✅ **Follow submitting-patches.rst rules**: YES
5. ❌ **Fix a real bug or add device ID**: **NO - This is the critical
   failure**

The rules explicitly state (lines 15-31 of stable-kernel-rules.rst):
> "It must either fix a real bug that bothers people or just add a
device ID."

This commit:
- Does **NOT** fix a bug (no oops, hang, data corruption, security
  issue, build error, etc.)
- Is a **cleanup/optimization** to improve build performance
- Provides **no user-visible bug fix**
- Falls under "trivial fixes without benefit for users" category (rule
  line 30-31)
- The original author did **NOT** tag it with `Cc:
  stable@vger.kernel.org`

**Search for Issues/Regressions:**
- Searched Linux kernel mailing lists: No issues found
- Searched for reverts: None found
- Searched for build failures: None reported
- Part of systematic cleanup series with no reported problems

**Risk Assessment:**
- **Technical risk**: Very low - simple change, dependencies satisfied
- **Regression risk**: Very low - no functionality change, just build
  system optimization
- **Policy compliance**: **Does not meet stable kernel criteria**

### Conclusion

While this commit is technically safe and provides a marginal build-time
performance improvement by eliminating unnecessary runtime compiler
checks, **it does not meet the fundamental requirement for stable kernel
backporting**: it does not fix a bug that affects users.

The commit is purely a cleanup that removes obsolete code after compiler
minimum version requirements were raised. Such cleanups belong in
mainline development, not stable trees, which should focus exclusively
on fixing bugs that impact users.

The fact that it was auto-selected by AUTOSEL does not override the
documented stable kernel rules. This commit should be **rejected** from
stable backporting or **reverted** if already applied.

 arch/x86/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1913d342969ba..7cfc1b31f17e1 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -37,10 +37,11 @@ export RETPOLINE_VDSO_CFLAGS
 
 # For gcc stack alignment is specified with -mpreferred-stack-boundary,
 # clang has the option -mstack-alignment for that purpose.
-ifneq ($(call cc-option, -mpreferred-stack-boundary=4),)
+ifdef CONFIG_CC_IS_GCC
       cc_stack_align4 := -mpreferred-stack-boundary=2
       cc_stack_align8 := -mpreferred-stack-boundary=3
-else ifneq ($(call cc-option, -mstack-alignment=16),)
+endif
+ifdef CONFIG_CC_IS_CLANG
       cc_stack_align4 := -mstack-alignment=4
       cc_stack_align8 := -mstack-alignment=8
 endif
-- 
2.51.0

