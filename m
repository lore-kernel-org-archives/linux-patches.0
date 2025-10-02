Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9341D554;
	Thu,  2 Oct 2025 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419029; cv=none; b=sb5MZUqfajUmZbEQVVcBWIEc5uMQpe1sYL5htBYmJfuS0SsWT72d2M1vnIFStU8P6g+jDR5/aYdDKH74XHXJA0DGmt/pB5C9Ck4OThjNyOrMk+hTNcuvt85jTqwBfGjWTG4hEerfbA5qXtW4m3T72tg3lDZu0zpV8FoyUHw88d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419029; c=relaxed/simple;
	bh=nS+BtJipqvbOUU0MjmcPCD0O/fWPAbAUkRbnOo3ijCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esTYAHsygiMCwLg6BlNOEJYwqXyd8LdcJWsDHSY6DqwEdpTZdfFZwrg47Sf3EjKNWknGcRn7hzlk+8v2AtqqSKvDKGZsAy+kPRGmw1EPHJhVuOAajFP7OPGlkCvn6lCm1k63cQCYzPo63bSgO8/ag4bgO/lAbNZC7Nl3KIIw1ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OR1a+qdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OR1a+qdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF288C4CEF9;
	Thu,  2 Oct 2025 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419028;
	bh=nS+BtJipqvbOUU0MjmcPCD0O/fWPAbAUkRbnOo3ijCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OR1a+qddhRsut7YUCTqVx+2PjP+tWVxoaxoM7pkA5t6x83daB+6I04ZJOZ5mKdFb/
	 qgFeFlelJtnCC+gr+iAqGee1/QMVizXX8BBskeKhWzCIUEgxRm65JNnGZ9JoeQqbZ5
	 +Sa63+z/1VFito6px8AHZBvhgtqxaXxL6ygHbVl+r13nJGacMMbhhJH9uLDLM3S4jC
	 znwhTx3FH/AfsiKfUqFJCHU8GsSqa9/3Ssbl1Li0hKyCKwCChMxNE4X/J8uqKBbi+h
	 P5ebUuUQytLr1jCqX3fJGsT2tiDiKMSYb51ZNi7D9y9lUUEx0jnRuB74r6PBrUYMtP
	 h9NsBsBP655mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
Date: Thu,  2 Oct 2025 11:29:49 -0400
Message-ID: <20251002153025.2209281-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fuad Tabba <tabba@google.com>

[ Upstream commit f4d4ebc84995178273740f3e601e97fdefc561d2 ]

The `ID_AA64MMFR4_EL1.EIESB` field, is an unsigned enumeration, but was
incorrectly defined as a `SignedEnum` when introduced in commit
cfc680bb04c5 ("arm64: sysreg: Add layout for ID_AA64MMFR4_EL1"). This is
corrected to `UnsignedEnum`.

Conversely, the `ID_AA64DFR0_EL1.DoubleLock` field, is a signed
enumeration, but was incorrectly defined as an `UnsignedEnum`. This is
corrected to `SignedEnum`, which wasn't correctly set when annotated as
such in commit ad16d4cf0b4f ("arm64/sysreg: Initial unsigned annotations
for ID registers").

Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my determination:

## Backport Status: **YES**

## Extensive Analysis

### Overview
This commit corrects sign definitions for two ARM64 system register
fields:
1. **ID_AA64MMFR4_EL1.EIESB** (bits 7:4): Incorrectly defined as
   `SignedEnum`, should be `UnsignedEnum`
2. **ID_AA64DFR0_EL1.DoubleLock** (bits 39:36): Incorrectly defined as
   `UnsignedEnum`, should be `SignedEnum`

### Technical Deep Dive

#### How Sign Definitions Matter

The `arch/arm64/tools/gen-sysreg.awk` script processes these definitions
(lines 277-301) to generate `_SIGNED` macros:
- `SignedEnum` → `#define REG_FIELD_SIGNED true`
- `UnsignedEnum` → `#define REG_FIELD_SIGNED false`

These macros control critical behavior in
`arch/arm64/include/asm/kvm_host.h:1541-1544`:
```c
#define kvm_cmp_feat(kvm, id, fld, op, limit)
    (id##_##fld##_SIGNED ?
     kvm_cmp_feat_signed(kvm, id, fld, op, limit) :
     kvm_cmp_feat_unsigned(kvm, id, fld, op, limit))
```

The signed vs unsigned distinction affects:
- **Field extraction**: Signed fields get sign-extended via
  `sign_extend64()` (line 1529)
- **Comparison values**: Signed limits get sign-extended (line 1517)
- **Feature detection logic**: Used by `kvm_has_feat()` macro for
  capability checks

#### ARM Architecture Context

Following ARM conventions:
- **Signed enumerations**: Use `0b1111` to represent "Not Implemented"
  (interpreted as -1 in 4-bit signed)
- **Unsigned enumerations**: Count up from 0, with higher values
  indicating more capabilities

**DoubleLock** (should be signed):
- Values: `0b0000` (IMP), `0b1111` (NI)
- Pattern matches other signed fields like MTPMU, FP, AdvSIMD (all using
  0b1111=NI)
- The 0b1111=-1 pattern indicates "feature not present"

**EIESB** (should be unsigned):
- Values: `0b0000` (NI), `0b0001` (ToEL3), `0b0010` (ToELx), `0b1111`
  (ANY)
- Here 0b1111=15 means "applies to ANY exception level" (maximum
  capability)
- This is an ascending enumeration, not a "not implemented" marker

### Active Bug Impact

#### DoubleLock Bug (CRITICAL)

The incorrect definition causes **real bugs** in
`arch/arm64/kvm/hyp/nvhe/pkvm.c:109` (added December 16, 2024, commit
0401f7e76d707):

```c
if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
    val |= MDCR_EL2_TDOSA;
```

**Bug behavior** (with incorrect unsigned definition):
- When DoubleLock = `0b1111` (not implemented)
- Incorrectly interpreted as unsigned 15
- Check: `15 >= 0` (IMP) → **TRUE** (wrong!)
- Result: **Does NOT set MDCR_EL2_TDOSA trap**
- Impact: **Incorrect hypervisor behavior** - fails to trap debug
  operations that should be trapped

**Correct behavior** (after fix):
- When DoubleLock = `0b1111` (not implemented)
- Correctly interpreted as signed -1
- Check: `-1 >= 0` (IMP) → **FALSE** (correct!)
- Result: **Correctly sets MDCR_EL2_TDOSA trap**

#### EIESB Bug (LATENT)

Not actively used in feature detection yet, but the incorrect definition
would cause failures if code checks `kvm_has_feat(kvm, ID_AA64MMFR4_EL1,
EIESB, ToELx)`:
- Wrong: `-1 >= 2` → FALSE (incorrectly thinks feature unsupported)
- Right: `15 >= 2` → TRUE (correctly detects ANY exception level
  support)

### Code References

Key usage locations:
- **DoubleLock**: `arch/arm64/kvm/hyp/nvhe/pkvm.c:109` - Active bug in
  KVM trap configuration
- **DoubleLock**: `arch/arm64/kvm/config.c` - Feature configuration
- **DoubleLock**: `arch/arm64/kvm/sys_regs.c` - System register field
  preparation
- **Sign logic**: `arch/arm64/kernel/cpufeature.c:191-208` - FTR_BITS
  macros use sign field

### Commit History

- **Jan 31, 2023** (ad16d4cf0b4f): DoubleLock incorrectly marked as
  unsigned
- **Jan 22, 2024** (cfc680bb04c5): EIESB incorrectly introduced as
  signed
- **Dec 16, 2024** (0401f7e76d707): KVM code starts using DoubleLock -
  **bug becomes active**
- **Aug 29, 2025** (f4d4ebc84995): This fix corrects both sign
  definitions
- Acked by Mark Rutland (ARM maintainer)
- No reverts or follow-up fixes found

### Backport Justification

✅ **Fixes important bug**: Active DoubleLock bug causes incorrect KVM
trap configuration
✅ **Small and contained**: Only changes two type annotations in metadata
file
✅ **No architectural changes**: Pure correctness fix
✅ **Minimal regression risk**: Aligns with ARM architecture
specifications
✅ **Affects critical subsystem**: KVM hypervisor trap configuration
✅ **Clean backport**: Changes apply to stable kernel versions
✅ **Maintainer approved**: Acked-by from ARM maintainer Mark Rutland

### Affected Kernel Versions

Should backport to stable kernels containing:
1. The incorrect definitions (since 6.3+ for DoubleLock, 6.8+ for EIESB)
2. **Especially critical** for kernels with the KVM usage code (6.13+)

This commit fixes incorrect metadata that causes real runtime bugs in
ARM64 virtualization code.

 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a674..2a37d4c26d870 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1693,7 +1693,7 @@ UnsignedEnum	43:40	TraceFilt
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	39:36	DoubleLock
+SignedEnum	39:36	DoubleLock
 	0b0000	IMP
 	0b1111	NI
 EndEnum
@@ -2409,7 +2409,7 @@ UnsignedEnum	11:8	ASID2
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-SignedEnum	7:4	EIESB
+UnsignedEnum	7:4	EIESB
 	0b0000	NI
 	0b0001	ToEL3
 	0b0010	ToELx
-- 
2.51.0

