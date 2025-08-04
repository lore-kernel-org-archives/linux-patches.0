Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A914A1FDD;
	Mon,  4 Aug 2025 00:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267600; cv=none; b=tWaZWamMLQbh4PSsbub0TSGNAk3aVho+SSPwK/zF8zaAYKulfoHnWvn07frYetHjlQkLXAXeqi6ldatT0QuRhpcD8Or8d7U2UDe9px0kKMKxTN9HZAsMn966diM471kDczMCvAkyVSR9sFAq6UYp2AoAQeMCaS7O7PeskkNNEfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267600; c=relaxed/simple;
	bh=VDG96WUR7a9/KnRv7tQwTaApcizWL4OOQ4tjRZlcC9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YFi33r7GresxBywxB8xrQMXYdLF8QptyFsUeO5jrsRE1PYml9lDHyqv0f/fFAh9urfernkWPosZg6movUOII/8Ax9t1k22LX8WYjeTb2wdACMgnT4uPxgbTD3CXeXG8pHI4UDKWrE8iBt3jJClCVX/SImpR5Yz8h080IltVOa40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtS1Do51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtS1Do51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2B4C4CEEB;
	Mon,  4 Aug 2025 00:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267600;
	bh=VDG96WUR7a9/KnRv7tQwTaApcizWL4OOQ4tjRZlcC9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtS1Do51BtdhkHgGfER1zV8t2fPAU56DgnqVMiJMnKX/xA27YC0C8+mzEAEXbC7wp
	 dXiQ1+9oeQiKvX1ifefe1bkIfeNgHMSUXEsNajdnjJ+Qcu2e5mUlSEj51gMin7AA5E
	 mpvzblCzb8AyxOxMTKn/pe6UQV+vch4MmPZI6v5H3L90H/BYw5+c+nh858x4q5ohbv
	 qRQsXCep+orRhAiiKIW9R6nuGdeAgKtjG7pRly9Tb/rRF/33ndc1jE/gzX8/XyPCrx
	 B6ZFC7kppoNmHCBL1/PmF3ieyX2mnheGs2zaIBY5+gFRwG3qVeBI8A1c7l5z9CiS5x
	 UDjhkQemPJfOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 6.12 50/69] x86/bugs: Avoid warning when overriding return thunk
Date: Sun,  3 Aug 2025 20:31:00 -0400
Message-Id: <20250804003119.3620476-50-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 9f85fdb9fc5a1bd308a10a0a7d7e34f2712ba58b ]

The purpose of the warning is to prevent an unexpected change to the return
thunk mitigation. However, there are legitimate cases where the return
thunk is intentionally set more than once. For example, ITS and SRSO both
can set the return thunk after retbleed has set it. In both the cases
retbleed is still mitigated.

Replace the warning with an info about the active return thunk.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-3-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Reasons for Backporting:

### 1. **Fixes a Real User-Visible Issue**
The code change shows that the original warning was triggering in
legitimate scenarios:
```c
- if (x86_return_thunk != __x86_return_thunk)
- pr_warn("x86/bugs: return thunk changed\n");
```
This warning would appear in kernel logs whenever multiple CPU
vulnerability mitigations interact, which is a normal and expected
behavior. The false positive warnings could:
- Cause unnecessary alarm for system administrators
- Clutter kernel logs with misleading information
- Potentially mask real issues by creating noise

### 2. **Small, Contained Change**
The commit is minimal and focused:
- Only modifies 3 lines of functional code
- Changes are confined to a single function (`set_return_thunk()`)
- Simply replaces a conditional warning with an unconditional info
  message:
```c
+       pr_info("active return thunk: %ps\n", thunk);
```

### 3. **No Risk of Regression**
The change is safe because:
- It doesn't modify any security logic or mitigation behavior
- The function still sets the return thunk exactly as before
- The new info message provides better visibility into which mitigation
  is active
- The `%ps` format specifier safely prints the function symbol name

### 4. **Addresses Security Mitigation Interactions**
The commit message explicitly states that "ITS and SRSO both can set the
return thunk after retbleed has set it" and that "retbleed is still
mitigated." This is important for stable kernels because:
- Multiple CVE mitigations (Retbleed, SRSO, ITS) need to coexist
- The warning was incorrectly flagging legitimate mitigation sequences
- Stable kernels need these mitigations to work together without false
  alarms

### 5. **Part of Critical Security Infrastructure**
The x86/bugs subsystem handles CPU vulnerability mitigations for:
- CVE-2023-20569 (SRSO)
- CVE-2024-28956 (ITS)
- Retbleed vulnerabilities
These are critical security features that need to function correctly in
stable kernels.

### 6. **Improves Operational Visibility**
The new info message (`pr_info("active return thunk: %ps\n", thunk);`)
actually improves debugging and system monitoring by:
- Showing which specific return thunk is currently active
- Providing better audit trail for security mitigation changes
- Using proper function symbol printing with `%ps`

## Conclusion:
This commit meets all the criteria for stable backporting:
- Fixes a real issue (false positive warnings)
- Minimal risk (3-line change, no logic modifications)
- Improves system behavior without introducing new features
- Addresses interaction between critical security mitigations
- Makes the kernel more reliable and less confusing for operators

The change is particularly important for stable kernels that need to
support multiple CPU vulnerability mitigations simultaneously without
generating misleading warnings.

 arch/x86/kernel/cpu/bugs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c2c7b76d953f..31b4b73e5405 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -71,10 +71,9 @@ void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
 static void __init set_return_thunk(void *thunk)
 {
-	if (x86_return_thunk != __x86_return_thunk)
-		pr_warn("x86/bugs: return thunk changed\n");
-
 	x86_return_thunk = thunk;
+
+	pr_info("active return thunk: %ps\n", thunk);
 }
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
-- 
2.39.5

