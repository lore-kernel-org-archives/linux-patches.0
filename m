Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57D30E0EF;
	Fri, 12 Dec 2025 06:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519956; cv=none; b=KQo7gLYX5bkBguigYUvZQ9f2ffI2DglK4U3Fg1xBGEo/I1yCC8IhZuTVdBbUT7hQyU8o7SAFhT/ZvBwTZP4dz6elRddCuSZu8ITZaLxrZukkgTNwJ0MHNm+7/qPEtU+fx+Nb846lnBnNcLNiWJqTKTg59oisJS8nhm1iHW3mkV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519956; c=relaxed/simple;
	bh=QKnyW1kaqGZM3cl5GXRxkv7auxKfqIJI2/A7d7lKwu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ygf0a8rdj77X1NkafJoaP6T+ImV8oKx/5CEdQXZClwxrx/HkKd8eV6hH0NCIpDJr1ovvK+7WYAIdip87ZH4zCwwHH/pi2of6QbrzYMqKdnAxdMPEZWkluTRg8D4H1K5Nt8JABC1GClsyedQ3KFjsdFrYJKMELCjRCX+U/KOk/R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+7pp50S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+7pp50S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4C0C116B1;
	Fri, 12 Dec 2025 06:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765519955;
	bh=QKnyW1kaqGZM3cl5GXRxkv7auxKfqIJI2/A7d7lKwu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+7pp50Salcbdb/Sn4ifc2dyoQ8FMKZ+0NRksvj1m2Q2A0pRu25kVvqEbQAZpcD24
	 UD9d8qQ8jReLsyJQSJLyhq00nAp8hCNIhM9s+1LLEyBx1dUxbjjZ/uJn25KEIUirmc
	 bGTtca7HQRzGSuLPG+e3ucG8dsg+BLpLTcW2tuvuK4FiIWKY0uGpFXGJp6/bA15p1l
	 cDq4all0cW9kR7To22p2ZZqoYB+V4NEnAIKEBg3OgmkvAL4Ik9GtKKZ7CQRPJ3t7qP
	 FqK+0UmCMWjOvo4ZxRupX3ZgrKiFYdk1PSxiJZse2fniYzHVBW1OLiAF6Bcap4t6oi
	 nJolenhQ2VjzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Li <yang.li85200@gmail.com>,
	Guo Ren <guoren@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] csky: fix csky_cmpxchg_fixup not working
Date: Fri, 12 Dec 2025 01:12:13 -0500
Message-ID: <20251212061223.305139-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212061223.305139-1-sashal@kernel.org>
References: <20251212061223.305139-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Yang Li <yang.li85200@gmail.com>

[ Upstream commit 809ef03d6d21d5fea016bbf6babeec462e37e68c ]

In the csky_cmpxchg_fixup function, it is incorrect to use the global
variable csky_cmpxchg_stw to determine the address where the exception
occurred.The global variable csky_cmpxchg_stw stores the opcode at the
time of the exception, while &csky_cmpxchg_stw shows the address where
the exception occurred.

Signed-off-by: Yang Li <yang.li85200@gmail.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of csky: fix csky_cmpxchg_fixup not working

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: "csky: fix csky_cmpxchg_fixup not working" - clearly
indicates a bug fix

**Key issue explained**: The commit message describes a fundamental
semantic error - the code was using the **value** of `csky_cmpxchg_stw`
(which contains an opcode) when it should have been using the
**address** of `csky_cmpxchg_stw` (where the instruction is located).

**Missing tags**: No "Cc: stable@vger.kernel.org" or "Fixes:" tag, but
this doesn't preclude backporting if the fix is clearly warranted.

### 2. CODE CHANGE ANALYSIS

The change is extremely surgical - only 2 lines modified:

```c
- if (instruction_pointer(regs) == csky_cmpxchg_stw)
- instruction_pointer_set(regs, csky_cmpxchg_ldw);
+       if (instruction_pointer(regs) == (unsigned
long)&csky_cmpxchg_stw)
+               instruction_pointer_set(regs, (unsigned
long)&csky_cmpxchg_ldw);
```

**Technical explanation**:
- `csky_cmpxchg_ldw` and `csky_cmpxchg_stw` are external symbols
  declared as `extern unsigned long` - they represent labels/addresses
  in the cmpxchg assembly implementation
- The **value** stored at these symbols is the opcode of the instruction
- The **address** (`&csky_cmpxchg_stw`) is where the instruction resides
  in memory
- The code compares against `instruction_pointer(regs)` which is an
  address, so it must compare against an address, not an opcode value

**Root cause**: Simple semantic error - using value instead of address

**Why the bug is severe**: This function handles TLB modification faults
during compare-and-exchange operations. When such a fault occurs at the
store instruction, the handler should redirect execution back to the
load instruction to retry the operation. With the bug, the comparison
`instruction_pointer(regs) == csky_cmpxchg_stw` would almost never match
(comparing an address to an opcode), so the fixup **never worked**.

### 3. CLASSIFICATION

- **Bug fix**: Yes, clearly fixing broken functionality
- **Security impact**: Potentially - broken cmpxchg can lead to race
  conditions
- **Data corruption risk**: Yes - atomic operations that don't work
  correctly can cause data races

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 2 lines
- **Files touched**: 1 file (arch/csky/mm/fault.c)
- **Subsystem**: CSKY architecture-specific code
- **Complexity**: Minimal - straightforward address-of fix
- **Risk**: Very low - the fix is obviously correct and architecture-
  specific

### 5. USER IMPACT

- **Affected users**: CSKY systems without LDSTEX instructions (when
  `CONFIG_CPU_HAS_LDSTEX` is not defined)
- **Severity**: High - broken compare-and-exchange atomic operations can
  cause:
  - Race conditions in concurrent code
  - Data corruption
  - Deadlocks
  - Unpredictable behavior in any code using cmpxchg

### 6. STABILITY INDICATORS

- Signed-off by maintainer Guo Ren (CSKY maintainer)
- The fix is logically obvious once understood

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The affected code has existed since CSKY was added to the kernel
- Should apply cleanly to stable trees that have CSKY support

### CONCLUSION

This commit clearly meets all stable kernel criteria:

1. **Obviously correct**: The fix is a textbook case of using
   `&variable` (address) instead of `variable` (value) when comparing
   against an instruction pointer
2. **Fixes a real bug**: The cmpxchg fixup mechanism was completely non-
   functional
3. **Important issue**: Broken atomic operations can cause data
   corruption, race conditions, and system instability
4. **Small and contained**: Only 2 lines changed in one file,
   architecture-specific
5. **No new features**: Just fixing existing functionality to actually
   work

The absence of stable tags appears to be an oversight. This is a
critical fix for CSKY platforms - without it, the entire cmpxchg fixup
path is dead code that never triggers when it should.

**YES**

 arch/csky/mm/fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index a6ca7dff42153..7ff4011089850 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -45,8 +45,8 @@ static inline void csky_cmpxchg_fixup(struct pt_regs *regs)
 	if (trap_no(regs) != VEC_TLBMODIFIED)
 		return;
 
-	if (instruction_pointer(regs) == csky_cmpxchg_stw)
-		instruction_pointer_set(regs, csky_cmpxchg_ldw);
+	if (instruction_pointer(regs) == (unsigned long)&csky_cmpxchg_stw)
+		instruction_pointer_set(regs, (unsigned long)&csky_cmpxchg_ldw);
 	return;
 }
 #endif
-- 
2.51.0

