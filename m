Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6252B3F2118;
	Tue, 24 Mar 2026 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351192; cv=none; b=W7zvCD4yDL2SiFLKNtbki7o/l/KPUIWPDcNUgjr2jTunqsXCHZoISYhuDcS2Pk1NYThoSldvUdUTPeL2CZt5shiWF9p64d5yOMGQgv+AgeSRGMFJl2mqFrtvuOEs0fUKxKklUy53gWiC1NvGc2zt0Pe67ZXUmnniVELKvIdgFsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351192; c=relaxed/simple;
	bh=VT3AT/WWqPufi5SKMScsvaN96hTQjfYr79XjpwYmz/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RK1+v1dbZ8L38P+zmep/ukCPnq+ehkKC2SfvBsLVthAYhudp9euL7/8eCvUvSLRY+hfXAUBtRkWsQE4Eh7dwz2u4Uw7uO/Kc6rUMK8okq8PErBkAhE/IhPi76UTzR3lJYoERQCbl/vJymtYwprbJhoXK6hwMSxbJi/iYis9EkYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FylAkqkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FylAkqkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC3CC2BCB3;
	Tue, 24 Mar 2026 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351192;
	bh=VT3AT/WWqPufi5SKMScsvaN96hTQjfYr79XjpwYmz/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FylAkqkJCJtdxGIIUV2BYNtId7r5Em6I/zDBhS3t7Qx+UrzjNRIiN3IsEuuUpXacA
	 D5A/eEBnvAakguDXNJ/oblyzHLYZJ4UUplW2kDMB5om7+VeLVp6zAcPjD+NvEuNkqf
	 Agl6RB9/zpLrXdAwBe9GFIbkxJwlWBWA679Jw5vNHOeoHx97dBbX7p/bH2cgsL8uOO
	 3iJP6pbkWv+gr3IoQG5cyue6JGknS89luNjaSayTkY6+nKJqKRbWxKjOYCHyDXT/XE
	 QP8gQebNaOpRO+ayCrizikVz/SfLcRL1IjptPpPohsT107av2IitX5pzS8qfdHmXaa
	 xXJncDT0wXioQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pepper Gray <hello@peppergray.xyz>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] arm64/scs: Fix handling of advance_loc4
Date: Tue, 24 Mar 2026 07:19:23 -0400
Message-ID: <20260324111931.3257972-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pepper Gray <hello@peppergray.xyz>

[ Upstream commit d499e9627d70b1269020d59b95ed3e18bee6b8cd ]

DW_CFA_advance_loc4 is defined but no handler is implemented. Its
CFA opcode defaults to EDYNSCS_INVALID_CFA_OPCODE triggering an
error which wrongfully prevents modules from loading.

Link: https://bugs.gentoo.org/971060
Signed-off-by: Pepper Gray <hello@peppergray.xyz>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The context around the insertion point is identical in v6.6 and v6.12.
The fix adds a new `case DW_CFA_advance_loc4:` between `advance_loc2`
and `DW_CFA_def_cfa`. This should apply cleanly to both stable trees.

## PHASE 3-7 SYNTHESIS

Let me now compile all findings:

### Step 3.1: BLAME THE CHANGED LINES
The switch statement was introduced in commit `3b619e22c4601b` by Ard
Biesheuvel in v6.2-rc1. The `DW_CFA_advance_loc4` constant was defined
but never given a case handler — the bug has existed since the code was
first introduced.

### Step 3.2: FIXES TAG
No Fixes: tag present. The implicit fix target is `3b619e22c4601b`
("arm64: implement dynamic shadow call stack for Clang") from v6.2.

### Step 3.3-3.5: FILE HISTORY AND DEPENDENCIES
The file has been modified 7 times total. The fix is self-contained — it
adds a new case to an existing switch statement following the exact
pattern of `DW_CFA_advance_loc1` and `DW_CFA_advance_loc2`. No
dependencies on other patches.

### Step 5: CODE SEMANTIC ANALYSIS
- `scs_handle_fde_frame()` is called from `scs_patch()` which is called
  from:
  1. `map_kernel.c` — during early boot (vmlinux SCS patching)
  2. `module.c` — during module loading
- The amdgpu driver generates `DW_CFA_advance_loc4` opcodes (likely due
  to very large functions), triggering the bug on module load.

### Step 7: SUBSYSTEM AND CRITICALITY
- **Subsystem:** arm64/scs — Shadow Call Stack security feature
- **Criticality:** IMPORTANT — affects arm64 platforms with SCS enabled
  (hardened kernels, Android)

### Step 8: IMPACT AND RISK ASSESSMENT

**Who is affected:** arm64 users with CONFIG_SHADOW_CALL_STACK=y and
CONFIG_DYNAMIC_SCS=y loading modules with large functions (e.g.,
amdgpu).

**Trigger:** Loading any kernel module whose compiled code generates
`DW_CFA_advance_loc4` DWARF opcodes (functions spanning >64KB of
instructions).

**Failure mode in stable (6.6.y, 6.12.y):** SCS patching silently fails
— the error return is not checked, so the module loads but without
proper Shadow Call Stack protection. This is a **security degradation**
— SCS is designed to protect against Return-Oriented Programming
attacks.

**Failure mode in mainline (v6.18+):** Module loading fails entirely
(due to `6d4a0fbd34a40`). The Gentoo bug report confirms amdgpu fails to
load on ARM64 hardened kernels.

**Fix quality:**
- 8 lines added, following the exact pattern of `advance_loc1` (1 byte)
  and `advance_loc2` (2 bytes) but for 4 bytes
- Obviously correct — it reads 4 bytes and advances the location counter
- Signed off by Will Deacon (arm64 maintainer)
- Minimal, surgical, no side effects
- One minor style nit: `break` is outdented compared to the other cases,
  but functionally correct

## PHASE 9: FINAL SYNTHESIS

### Evidence FOR backporting:
1. Fixes a real bug that prevents module loading on arm64 (confirmed by
   Gentoo bug report with amdgpu)
2. In stable trees, the bug silently disables Shadow Call Stack security
   protection for affected modules
3. The buggy code has been present since v6.2 (affects 6.6.y, 6.12.y
   stable trees)
4. Fix is small (8 lines), obviously correct, follows the exact pattern
   of adjacent code
5. Signed off by Will Deacon (arm64 maintainer)
6. Link to real user bug report (Gentoo #971060) — actual users hit this
7. Self-contained — no dependencies on other patches
8. Should apply cleanly to stable (same code context exists in 6.6 and
   6.12)

### Evidence AGAINST backporting:
- None significant. The only minor concern is that in current stable
  trees the error is silently ignored (module still loads), so the
  immediate user-visible impact is lower (security degradation rather
  than module load failure). But this is still a bug worth fixing.

### Stable Rules Checklist:
1. **Obviously correct and tested?** YES — follows the pattern of
   loc1/loc2, tested by Gentoo users
2. **Fixes a real bug?** YES — prevents module loading (mainline) or
   silently breaks SCS (stable)
3. **Important issue?** YES — security feature bypass on hardened arm64
   kernels
4. **Small and contained?** YES — 8 lines in one file
5. **No new features or APIs?** YES — just adds missing case handler
6. **Can apply to stable trees?** YES — context is identical in 6.6 and
   6.12

## Verification

- [Phase 1] Parsed subject: arm64/scs subsystem, "Fix" action verb,
  missing advance_loc4 handler
- [Phase 1] Parsed tags: Link to bugs.gentoo.org/971060, Signed-off-by
  Will Deacon (arm64 maintainer)
- [Phase 2] Diff analysis: +8 lines in single file, adds
  DW_CFA_advance_loc4 case to existing switch
- [Phase 2] Pattern follows DW_CFA_advance_loc1 (1 byte) and
  DW_CFA_advance_loc2 (2 bytes) exactly
- [Phase 3] git blame: switch statement introduced in 3b619e22c4601b
  (v6.2-rc1), bug present since then
- [Phase 3] git show v6.1: file does not exist — bug only affects 6.2+
- [Phase 3] git show v6.6, v6.12: confirmed DW_CFA_advance_loc4 defined
  but no case handler in both
- [Phase 3] git show 6d4a0fbd34a40: confirmed this commit (v6.18) made
  module loading actually fail on SCS errors
- [Phase 3] v6.6/v6.12 module.c: SCS patch error return is NOT checked —
  module loads with broken SCS
- [Phase 4] WebFetch bugs.gentoo.org/971060: confirmed amdgpu module
  fails to load on ARM64 hardened kernel
- [Phase 4] WebFetch lore.kernel.org: found patch discussion, accepted
  by Will Deacon, pulled in arm64 fixes
- [Phase 5] scs_handle_fde_frame called from scs_patch, which is called
  from module.c and map_kernel.c
- [Phase 6] Confirmed context around insertion point is identical in
  v6.6 and v6.12 — clean apply expected
- [Phase 7] Subsystem: arm64/scs, IMPORTANT criticality (security
  feature for arm64)
- [Phase 8] Failure mode: security degradation (stable) or module load
  failure (mainline), severity HIGH

**YES**

 arch/arm64/kernel/pi/patch-scs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/pi/patch-scs.c b/arch/arm64/kernel/pi/patch-scs.c
index bbe7d30ed12b3..dac568e4a54f2 100644
--- a/arch/arm64/kernel/pi/patch-scs.c
+++ b/arch/arm64/kernel/pi/patch-scs.c
@@ -192,6 +192,14 @@ static int scs_handle_fde_frame(const struct eh_frame *frame,
 			size -= 2;
 			break;
 
+		case DW_CFA_advance_loc4:
+			loc += *opcode++ * code_alignment_factor;
+			loc += (*opcode++ << 8) * code_alignment_factor;
+			loc += (*opcode++ << 16) * code_alignment_factor;
+			loc += (*opcode++ << 24) * code_alignment_factor;
+			size -= 4;
+		break;
+
 		case DW_CFA_def_cfa:
 		case DW_CFA_offset_extended:
 			size = skip_xleb128(&opcode, size);
-- 
2.51.0

