Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0FD1D63CD;
	Mon,  4 Aug 2025 00:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267757; cv=none; b=XBuLspDz+K0TcTkzi1LX7Kr1zUscuAUy2JRfIFTpaxzju+Z8mDqILWXL6GM1/OzTy/HN/h6kO+m/wFl4KapJbCXTqRc5Qyx0LO8a0TTwgLKhMBD/KH0V7BbsboQNYl8+Hkx+ubVj2MItqASNn3VsC7FwLFSk0q6BLNHDK3J8P+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267757; c=relaxed/simple;
	bh=gBlYS+el3PZlQEQmuLWIx0cauNij3Fld9ZRrZzNFtqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=otBIgGU5Y2c89OIGonFE3fkyHdfX9uEe8bARZkdhBD4ztxzhzRtfGx2KorcyV2ymnRIQjCSndsabEcSIONsKU2hW/KeJMnEutQEA5TrDuP3nnlMcgoSQvpKZJlBvXWNsMZ9LvdKbq8hHilXFMORS6Vm58uiI6X5YxjcwsjzQtHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsMEJb+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsMEJb+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCCEC4CEEB;
	Mon,  4 Aug 2025 00:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267756;
	bh=gBlYS+el3PZlQEQmuLWIx0cauNij3Fld9ZRrZzNFtqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsMEJb+W5xgxPBGdAgzXeHPtFb9QBSwxeUUnlGXC8jtFh/S2XlFzo0w9bN/oCe4rT
	 P4fuW/12GNDsI5nO3WOPfU7Vvg8QrmFoy/TDXoxnF8EJCnpQnnAm7XtAA5vVstOz4q
	 0pVgNmREV/P5hWSh27Os+P7j9mxeHvi+jnNC6RlWt3OvbMX5x8grSE9pnHZte1lO+i
	 owCqAeslrzBwMZDZrih/zJdI3cxrcQvFGVL2bywHbgV527BHM9YXPKPUr27L4XacmK
	 dcJgoE1cZgwly4V9QMvlpPRlRmoJwkVFJoKnaR/uagA/cXfmYZYHKgOOUEIO4/sqqo
	 y+IIOmILf9MCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org
Subject: [PATCH AUTOSEL 6.6 42/59] x86/bugs: Avoid warning when overriding return thunk
Date: Sun,  3 Aug 2025 20:33:56 -0400
Message-Id: <20250804003413.3622950-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
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
index c4d5ac99c6af..332c6f24280d 100644
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

