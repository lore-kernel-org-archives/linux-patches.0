Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175DF402BA3;
	Mon, 20 Apr 2026 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691626; cv=none; b=T2KiZhda+POh6wpaXJZfdb2bj/MGbVQse9by3uJsWY7DsdarriwEYAP8HHaD5jDHy1gCSv8eFO/JBY4FecZsQETvnwU0/e+KFmvYQgZA0CzPqGzSj++I6ZBBjLYQm8vr4mNTQx//GwEOv34r/cXOmaTjwXf4y8qfO7s3ZZRX8Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691626; c=relaxed/simple;
	bh=xyq8tdZQxla3QOWMCrFM2dP1pwFBccph/GPCkj5ObDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEuyWd3jdDYtC5Syb2duqDhNVzBTl8AgA4fAUiM9fPhap8LxhOEDLTM7TsF/WSl3w06JG8TtqBi6RiwKIXCGF/z5v4AZ+CKMGKpVACMcSmJCqqh87pxP/z9kMrkQsvTdPO7lifSeWrIHCWCCEfok/0dc2Dba3UTJEEhq8ds3xIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EgVRsRlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgVRsRlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8177C2BCB7;
	Mon, 20 Apr 2026 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691626;
	bh=xyq8tdZQxla3QOWMCrFM2dP1pwFBccph/GPCkj5ObDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgVRsRlriIEH/iA5sLx/fpKhm19Hjb2vk4+H9pGLWJyi1GxoRrtjVsGS3Jd+YYJ31
	 MzNEU+VUqy58ruKv+lMXdzHn6XmGE+kngmddAzU8n8L1mJ95stYvKzZXW8VNssv7Ej
	 1+aLHedaCExr34KiwHXvmIgti6s3PRY7O5A07P3JoBkVyv50UKGYKCYwMymTDTPi8K
	 3kujgvrx0Xk+MKNRCvckOse2OO0xnQRP2z+zJ0gXlpLx4HhDQnOy3upWMdaNAQjdCs
	 BvAux0bCkaT4XeK/AiV0XAsRe2UKRwbWaym/SmReUkcU+nMLg5jwLpsZwFr7Ll4/4X
	 Yu0z1f4x+DYcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Devang Vyas <devangnayanbhai.vyas@amd.com>,
	Ramesh Garidapuri <ramesh.garidapuri@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] EDAC/amd64: Add support for family 19h, models 40h-4fh
Date: Mon, 20 Apr 2026 09:18:53 -0400
Message-ID: <20260420132314.1023554-139-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Devang Vyas <devangnayanbhai.vyas@amd.com>

[ Upstream commit fbe230a9a79b62be3c6ac55b24d53ce5dd9202d5 ]

Add support for Ryzen 6000 Zen3-based CPUs in the V3000 AMD Embedded SoC
platform which uses ECC memory and would need RAS handling of hardware errors.

Co-developed-by: Ramesh Garidapuri <ramesh.garidapuri@amd.com>
Signed-off-by: Ramesh Garidapuri <ramesh.garidapuri@amd.com>
Signed-off-by: Devang Vyas <devangnayanbhai.vyas@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://patch.msgid.link/20260317183453.3556588-1-devangnayanbhai.vyas@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the key information. Here's the complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `EDAC/amd64`
- Action verb: "Add support for" - this is adding **new hardware
  support**, not fixing a bug
- Summary: Adds model 40h-4fh support for family 19h (Ryzen 6000 Zen3,
  V3000 AMD Embedded SoC)
- Record: [EDAC/amd64] [Add support] [New CPU model ID range for
  existing driver]

**Step 1.2: Tags**
- Co-developed-by: Ramesh Garidapuri (AMD employee)
- Signed-off-by: Ramesh Garidapuri, Devang Vyas, Borislav Petkov (AMD,
  EDAC maintainer)
- Reviewed-by: Yazen Ghannam (AMD, regular EDAC contributor)
- Link: patch.msgid.link URL
- No Fixes: tag, no Reported-by:, no Cc: stable
- Record: Reviewed by key EDAC/AMD developers, signed off by subsystem
  maintainer (Borislav Petkov)

**Step 1.3: Commit Body**
- Claims to add support for Ryzen 6000 Zen3-based CPUs in V3000 AMD
  Embedded SoC platform
- These CPUs use ECC memory and need RAS (Reliability, Availability,
  Serviceability) handling
- No bug description, no crash, no error report
- Record: This is a hardware enablement commit, not a bug fix

**Step 1.4: Hidden Bug Fix Detection**
- This is not a disguised bug fix. It's straightforwardly adding a new
  CPU model range to an existing switch statement.
- Record: Not a hidden bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/edac/amd64_edac.c`)
- Lines added: 3 lines (`case 0x40 ... 0x4f:`, `pvt->max_mcs = 4;`,
  `break;`)
- Lines removed: 0
- Function modified: `per_family_init()`
- Record: Extremely small, single-file, 3-line addition inside existing
  switch block

**Step 2.2: Code Flow Change**
- Before: Family 19h models 40h-4fh would fall through the inner switch
  without matching, using defaults (`max_mcs = 2`, no special flags)
- After: Family 19h models 40h-4fh set `max_mcs = 4`
- The default `max_mcs = 2` is set at line 3771 before the switch;
  without this case, the V3000 SoC would get a wrong max_mcs value

**Step 2.3: Bug Mechanism**
- Category: Hardware ID / model addition to existing driver
- Without this patch, the EDAC driver will still load for these CPUs
  (family 19h is already matched at the outer switch), but it will use
  `max_mcs = 2` instead of the correct `max_mcs = 4`
- This means 2 of the 4 memory controllers would not be monitored for
  ECC errors
- Record: This is a device model addition to an existing driver, setting
  the correct number of memory controllers

**Step 2.4: Fix Quality**
- The fix is trivially correct - identical pattern to other model ranges
  in the same switch
- Extremely minimal - 3 lines, no risk of regression
- The pattern mirrors `case 0x70 ... 0x7f` which also sets `max_mcs = 4`
- Record: Obviously correct, zero regression risk

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- Family 19h case block added in commit `2eb61c91c3e273` (Yazen Ghannam,
  2020-01-10) - present since ~v5.6
- Various model ranges were added over time (models 10-1f, 30-3f, 60-7f,
  90-9f, a0-af)
- Record: Family 19h support has been in the tree since v5.6; model
  additions are routine

**Step 3.2: No Fixes: tag** - expected for hardware enablement

**Step 3.3: File History**
- Recent commits show routine EDAC changes (format cleanup, macro
  removal, etc.)
- Similar prior commits: "Add support for family 19h, models 50h-5fh"
  (commit `0b8bf9cb142da`), "Add support for ECC on family 19h model
  60h-7Fh" (commit `6c79e42169fe1`)
- This is a standalone commit, not part of a series
- Record: Standalone, follows established pattern of model additions

**Step 3.4: Author**
- Devang Vyas appears to be an AMD engineer. The commit was reviewed by
  Yazen Ghannam (AMD EDAC regular) and signed off by Borislav Petkov
  (EDAC maintainer).

**Step 3.5: Dependencies**
- No dependencies. The family 19h framework already exists. This just
  adds a new case.

## PHASE 4: MAILING LIST

**Step 4.1-4.5:**
- Lore is behind Anubis protection; could not fetch discussion
- b4 dig could not find this specific commit (likely too new for cached
  index)
- No indication of stable nomination in the commit tags
- Record: Could not verify mailing list discussion due to lore
  protection

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:**
- `per_family_init()` is called from the module's probe path at line
  4016
- Called once per detected AMD CPU node during EDAC initialization
- The function sets up per-family and per-model parameters for the EDAC
  memory controller
- Without correct `max_mcs`, the driver will only see 2 of 4 memory
  controllers, meaning ECC errors on controllers 3 and 4 would not be
  detected/reported

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:**
- Family 19h support exists since v5.6, so the outer `case 0x19:` exists
  in all active stable trees (6.1.y, 6.6.y, etc.)
- The patch would apply cleanly to any stable tree that has the family
  19h switch block
- Record: Code exists in all active stable trees

**Step 6.2:**
- The file has had some refactoring (e.g., `e9abd990aefd7` for
  `ctl_name` generation), so minor conflicts are possible in older
  stable trees, but the specific hunk (adding a case between 0x3f and
  0x60) should apply cleanly.

**Step 6.3:** No related fixes already in stable for this model range.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:**
- Subsystem: EDAC (Error Detection and Correction) - memory error
  handling
- Criticality: IMPORTANT - affects users of specific AMD embedded
  hardware (V3000 platform with Ryzen 6000)
- Record: [EDAC/AMD driver] [IMPORTANT for V3000 users]

**Step 7.2:** Active subsystem with regular model additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected?**
- Users of AMD V3000 embedded SoC platform (Ryzen 6000 Zen3, family 19h
  models 40h-4fh)
- This is an embedded platform - likely used in industrial/commercial
  applications where ECC matters
- Record: Platform-specific - V3000 embedded users only

**Step 8.2: Trigger conditions**
- The driver loads on any AMD system with family 19h. Without this
  patch, models 40h-4fh get incorrect `max_mcs` (2 instead of 4), so
  half the memory controllers go unmonitored.
- Record: Triggered automatically on boot for affected hardware

**Step 8.3: Failure severity**
- Without this: EDAC doesn't properly monitor all memory controllers.
  ECC errors on 2 of 4 controllers would go undetected/unreported.
- This is NOT a crash - the system still works, but RAS monitoring is
  incomplete.
- Severity: MEDIUM - missing error reporting rather than
  crash/corruption
- Record: [Incomplete ECC monitoring] [MEDIUM severity]

**Step 8.4: Risk-Benefit**
- BENEFIT: Enables proper ECC monitoring on V3000 platform (important
  for embedded/industrial users relying on stable kernels)
- RISK: Extremely low - 3-line addition to existing pattern in a switch
  statement, zero chance of regression for any other hardware
- Record: [Medium benefit for niche audience] [Very low risk]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Trivially small change (3 lines), obviously correct
- Follows well-established pattern (identical to other model additions)
- Falls into the "device ID / model addition to existing driver"
  exception category
- Enables hardware monitoring for real embedded platform users
- Zero regression risk - only affects models 40h-4fh within family 19h
- Reviewed by subsystem experts (Yazen Ghannam) and merged by maintainer
  (Borislav Petkov)

AGAINST backporting:
- This is new hardware enablement, not a bug fix
- No crash, no data corruption, no security issue
- The system still functions without it - just incomplete ECC monitoring
- Niche audience (AMD V3000 embedded platform)
- No Fixes: tag (expected, but also reflects that there's no bug being
  fixed)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES - trivial 3-line pattern addition
2. Fixes a real bug? BORDERLINE - it's hardware enablement; without it,
   max_mcs defaults to 2 instead of 4, which means incomplete monitoring
3. Important issue? NO - no crash, security, or corruption. Missing ECC
   monitoring is concerning for embedded users but not critical
4. Small and contained? YES - 3 lines, single file
5. No new features or APIs? This IS arguably a new feature (new hardware
   support)
6. Can apply to stable? YES - should apply cleanly

**Step 9.3: Exception Categories**
- This falls under "New Device IDs" exception: adding a CPU model range
  to an existing driver. The driver already exists; only the model-
  specific configuration is new. This is analogous to adding a PCI/USB
  device ID.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Borislav Petkov (maintainer),
  Reviewed-by Yazen Ghannam
- [Phase 2] Diff analysis: 3 lines added, new `case 0x40 ... 0x4f` in
  per_family_init() switch, sets max_mcs=4
- [Phase 2] Verified default max_mcs=2 at line 3771, so without this
  patch models 40h-4fh get wrong value
- [Phase 3] git blame: family 19h support since commit 2eb61c91c3e273
  (v5.6 era, 2020-01-10)
- [Phase 3] git log: confirmed similar prior model additions (50h-5fh,
  60h-7fh)
- [Phase 4] b4 dig: could not find this specific commit; lore blocked by
  Anubis
- [Phase 5] per_family_init() called at line 4016 during driver probe
- [Phase 6] Family 19h case exists in all active stable trees (v5.6+)
- [Phase 8] Failure mode: incomplete ECC monitoring (2/4 controllers),
  severity MEDIUM
- UNVERIFIED: Mailing list discussion content (lore blocked)

## Decision

This commit adds a new CPU model range (40h-4fh) to an existing EDAC
driver. While it's technically a "new hardware support" addition, it
fits squarely into the **device ID / model addition exception** for
stable trees. The change is:
- 3 lines, trivially correct, zero regression risk
- Follows an identical pattern to dozens of prior model additions in
  this switch
- Enables ECC error detection for a real embedded platform (V3000)
- Users of stable kernels on this platform would have incomplete memory
  error monitoring without it

However, this is ultimately **new hardware enablement** rather than a
bug fix. The system doesn't crash, corrupt data, or have a security
issue without it. The V3000 platform is a relatively niche embedded SoC.
While device ID additions are generally acceptable for stable, the
stable kernel rules primarily target fixes for real bugs. This is
enabling hardware that was never supported before - not fixing broken
support for already-supported hardware.

The balance tips toward YES given the device ID exception, the trivial
size, and zero risk, but this is a borderline case. Given the extremely
low risk and that it enables proper RAS functionality for embedded users
who rely on stable kernels, this merits inclusion.

**YES**

 drivers/edac/amd64_edac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8908ab881c855..c6aa69dbd9fb1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3863,6 +3863,9 @@ static int per_family_init(struct amd64_pvt *pvt)
 				pvt->max_mcs		= 8;
 			}
 			break;
+		case 0x40 ... 0x4f:
+			pvt->max_mcs			= 4;
+			break;
 		case 0x60 ... 0x6f:
 			pvt->flags.zn_regs_v2		= 1;
 			break;
-- 
2.53.0

