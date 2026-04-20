Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8747A3B9D94;
	Mon, 20 Apr 2026 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691461; cv=none; b=FETEip7IeD2nJY2/q3Vr4Ai3sKwcaYnpq5O2NRNVAH6VzfPR90SpnowAMT4ClG6LtZKEeH79m8r1JLjtuBPTklK3ZmK1HAdost33Nxw5mVKob69e1AVQC4OOUklkpqMtO4r+li6UxMPan04bWkhrTn3IdbGMty8VdP4F29gmFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691461; c=relaxed/simple;
	bh=ZkMni/OleKXF1DMhu59hWQ0WkaJh3z6f7m+ZJQMuGq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AByacVmKw0yAXZr3RV+/E4d26nwAQHjtJgjqg/T+tJKwLuaKuJ0AotEt3X2qftnwdQD/9mqXW6XCfCpOMmz7s0UUqZng0NbZ6YxieQ7vZKSMwIXJ0nsWdf4KLiUjSOAhuFNC7a65ztpeBUXmsmpTcj/VxXTGq21yWFjyIubeaSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxtaikVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxtaikVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E14CC2BCB9;
	Mon, 20 Apr 2026 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691461;
	bh=ZkMni/OleKXF1DMhu59hWQ0WkaJh3z6f7m+ZJQMuGq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxtaikVduMMs2mWIt9VdFKiABjJsEQu3KBgj6y7gVSXLBc9vyVCPztYdNrGbWaspr
	 B7KvxKIvDwKv5XqnmipwCKHTOAxrJY+vWsrhFnnvt5ZxRcWKSJ0gCaVYsUeyWfTl5p
	 aqCm58cit+R5eNA/GXFPGMTVQh4btqfKl5v2MrA+23VD2Ak969dzyySRLGMwAl736N
	 oo8XeNi9x2g/YZBS56aldKJfPWMhs88MpZjIfZRMtgKUm7KWdXptKrD391pkmOBIOs
	 gDBcBGPHIumNziUEgodZQ0wY0okou+iTa5VKFrKsGNWpMld4dYd4pgsRY7tDQ/CLg0
	 XXpcMp+5PwCpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peter.ujfalusi@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ASoC: ti: davinci-mcasp: Add system suspend/resume support
Date: Mon, 20 Apr 2026 09:17:16 -0400
Message-ID: <20260420132314.1023554-42-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sen Wang <sen@ti.com>

[ Upstream commit 5879521cb558871472b97c4744dbe634a4286f0e ]

The McASP driver supports runtime PM callbacks for register save/restore
during device idle, but doesn't provide system suspend/resume callbacks.
This causes audio to fail to resume after system suspend.

Since the driver already handles runtime suspend & resume, we can reuse
existing runtime PM logics.

Signed-off-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260211221001.155843-1-sen@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: ASoC: ti: davinci-mcasp
- **Action verb**: "Add" (system suspend/resume support)
- **Summary**: Adds system suspend/resume PM ops to bridge to existing
  runtime PM callbacks

Record: [ASoC: ti: davinci-mcasp] [Add] [system suspend/resume support
by reusing runtime PM]

### Step 1.2: Tags
- **Signed-off-by**: Sen Wang <sen@ti.com> (author, TI employee - the
  SoC vendor)
- **Link**: https://patch.msgid.link/20260211221001.155843-1-sen@ti.com
- **Signed-off-by**: Mark Brown <broonie@kernel.org> (ASoC subsystem
  maintainer, applied the patch)
- No Fixes: tag (expected for commits under review)
- No Reported-by: tag
- No Cc: stable

Record: Author is TI employee (hardware vendor). Applied by ASoC
maintainer Mark Brown.

### Step 1.3: Commit Body
The message states: "The McASP driver supports runtime PM callbacks for
register save/restore during device idle, but doesn't provide system
suspend/resume callbacks. **This causes audio to fail to resume after
system suspend.**"

This describes a clear user-visible failure: audio breaks after system
suspend.

Record: Bug = audio fails to resume after S2RAM/suspend. Root cause =
missing system sleep PM ops when runtime PM callbacks handle context
save/restore. No stack traces or error messages described.

### Step 1.4: Hidden Bug Fix Detection
Despite the subject saying "Add", this is actually **restoring**
functionality that was removed by commit 6175471755075d (Jan 2019). That
commit moved context save/restore from DAI-level suspend/resume to
runtime PM callbacks but failed to bridge system sleep to runtime PM.
This is a regression fix disguised as a feature addition.

Record: YES, this is a hidden bug fix - it restores system suspend
functionality that was inadvertently broken in commit 6175471755075d.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`sound/soc/ti/davinci-mcasp.c`)
- **Lines added**: 2
- **Lines removed**: 0
- **Functions modified**: None (only the `davinci_mcasp_pm_ops` struct
  is changed)
- **Scope**: Single-file, ultra-surgical, 2-line addition

### Step 2.2: Code Flow Change
**Before**: `davinci_mcasp_pm_ops` only had `SET_RUNTIME_PM_OPS()`.
System suspend/resume had no callbacks → device context lost on S2RAM.

**After**: `SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
pm_runtime_force_resume)` is added, which tells the PM core to force
runtime suspend/resume during system sleep. This triggers
`davinci_mcasp_runtime_suspend()` and `davinci_mcasp_runtime_resume()`
during S2RAM, saving and restoring all McASP registers.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** + **hardware workaround**

The McASP hardware loses its register context during system suspend.
Without system sleep callbacks, the registers are never saved, so after
resume the hardware is in an undefined state and audio playback/capture
fails.

`pm_runtime_force_suspend`/`pm_runtime_force_resume` are standard kernel
PM helpers used by 35+ other sound drivers in the exact same way.

### Step 2.4: Fix Quality
- **Obviously correct**: YES - this is the standard, well-documented
  pattern
- **Minimal/surgical**: YES - 2 lines, no unrelated changes
- **Regression risk**: Extremely low - uses standard PM infrastructure,
  used identically by dozens of drivers
- **Red flags**: None

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The `davinci_mcasp_pm_ops` struct was introduced by commit
6175471755075d (Peter Ujfalusi, 2019-01-03) titled "ASoC: ti: davinci-
mcasp: Move context save/restore to runtime_pm callbacks". This commit:
1. Removed the old DAI-level
   `davinci_mcasp_suspend()`/`davinci_mcasp_resume()` which DID handle
   system suspend
2. Added
   `davinci_mcasp_runtime_suspend()`/`davinci_mcasp_runtime_resume()`
   for runtime PM
3. Created `davinci_mcasp_pm_ops` with only `SET_RUNTIME_PM_OPS` —
   **missing the system sleep bridge**

Record: Bug introduced by 6175471755075d (Jan 2019), which first
appeared around v5.2-rc1. Present in all active stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present, but the implicit target is 6175471755075d.
Confirmed this commit exists in stable trees (verified it's tagged in
p-5.10, p-5.15 and later).

### Step 3.3: File History
20+ commits to this file since v5.15, but none touch the PM ops area.
The `davinci_mcasp_pm_ops` struct has been unchanged since
6175471755075d.

### Step 3.4: Author
Sen Wang (<sen@ti.com>) is a TI employee with recent contributions to
this driver (3 commits to davinci-mcasp, plus DT bindings). TI is the
manufacturer of the McASP hardware.

### Step 3.5: Dependencies
None. The fix adds 2 lines to an existing struct using APIs that have
been available since v4.x. No prerequisite commits needed.

---

## PHASE 4: MAILING LIST RESEARCH

b4 dig could not find the commit by message-id. Lore.kernel.org returned
anti-bot pages. However, the Link: tag in the commit message confirms it
was submitted and reviewed on the ALSA/ASoC mailing list. Mark Brown
(ASoC maintainer) applied it directly.

### Step 4.2: Reviewers
Applied by Mark Brown (broonie@kernel.org), the ASoC subsystem
maintainer. He is the authoritative reviewer for this subsystem.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
The diff doesn't modify any functions - it adds
`pm_runtime_force_suspend`/`pm_runtime_force_resume` (existing kernel
APIs) to the PM ops struct.

### Step 5.2: Callers
The PM core calls these functions during system suspend/resume based on
the `dev_pm_ops` structure. This affects every system that uses McASP
hardware and performs system suspend (S2RAM, hibernate).

### Step 5.3-5.5: Similar Patterns
Verified that 35+ sound drivers use this exact same
`SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)`
pattern. This is the standard approach for drivers that handle context
save/restore via runtime PM.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
The buggy code (`davinci_mcasp_pm_ops` with only `SET_RUNTIME_PM_OPS`)
exists in ALL active stable trees since v5.2. Confirmed commit
6175471755075d is in p-5.10 and p-5.15.

### Step 6.2: Backport Complications
The PM ops area has been completely unchanged since 2019. The patch
should apply cleanly to all stable trees (6.6.y, 6.1.y, 5.15.y, 5.10.y).

### Step 6.3: No related fixes already in stable for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
`sound/soc/ti/` - TI Audio SoC driver. Criticality: PERIPHERAL (specific
embedded hardware - TI AM335x/AM437x/AM65x/J7 platforms, including
BeagleBone). However, this is a widely-used embedded platform.

### Step 7.2: Activity
Moderately active - 10+ commits since v6.6.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users of TI DaVinci McASP audio hardware who perform system
suspend/resume. This includes BeagleBone users, TI AM335x/AM437x/AM65x
industrial platforms, and any TI-based embedded system using audio.

### Step 8.2: Trigger
System suspend/resume (S2RAM). Very common operation on laptops and many
embedded systems. Triggered by user action (closing lid, `systemctl
suspend`).

### Step 8.3: Failure Mode
Audio completely fails after resume - the hardware registers are in
undefined state. Severity: **HIGH** - functionality loss requiring
reboot to recover.

### Step 8.4: Risk-Benefit
- **BENEFIT**: HIGH - fixes audio breakage after suspend for all McASP
  users
- **RISK**: Very low - 2 lines using standard, well-tested kernel PM
  APIs used by 35+ other drivers
- **Ratio**: Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real user-visible bug (audio fails after system suspend)
- This is a regression fix: commit 6175471755075d (2019) removed system
  suspend callbacks without adding the runtime PM bridge
- Ultra-minimal: 2 lines added
- Uses standard kernel PM APIs
  (`pm_runtime_force_suspend`/`pm_runtime_force_resume`)
- Pattern used by 35+ other sound drivers
- No dependencies or prerequisites
- Applies cleanly to all stable trees
- Authored by TI employee (hardware vendor), applied by ASoC maintainer
- Bug affects all stable trees since v5.2

**AGAINST backporting:**
- Subject line says "Add" which sounds like new feature (but substance
  is a regression fix)
- No Fixes: tag (expected for candidates under review)
- No explicit Reported-by (but the TI author would be testing this
  hardware)
- The bug has existed since 2019 without being reported/fixed (low
  urgency, but real)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - standard pattern, accepted by
   maintainer
2. Fixes a real bug? **YES** - audio fails after system suspend
3. Important issue? **YES** - complete audio loss requiring reboot
4. Small and contained? **YES** - 2 lines in one file
5. No new features or APIs? **YES** - restores accidentally removed
   functionality using existing APIs
6. Can apply to stable? **YES** - clean apply expected

### Step 9.3: Exception Category
This is a suspend/resume fix, which is a common category of stable-
appropriate fixes (fixes prevent data loss / functionality loss on real
hardware).

### Step 9.4: Decision
This is a regression fix for commit 6175471755075d which accidentally
removed system suspend support in 2019. The fix is 2 lines, uses
standard, well-proven kernel PM infrastructure, has zero regression
risk, and fixes complete audio loss after system suspend for all TI
McASP users. It should be backported.

---

## Verification

- [Phase 1] Parsed tags: Author is TI employee, applied by ASoC
  maintainer Mark Brown
- [Phase 2] Diff analysis: 2 lines added to `davinci_mcasp_pm_ops`
  struct, adding `SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
  pm_runtime_force_resume)`
- [Phase 3] git blame: PM ops struct introduced by commit 6175471755075d
  (2019-01-03), which removed old system suspend callbacks without
  adding runtime PM bridge
- [Phase 3] git show 6175471755075d: confirmed it removed
  `davinci_mcasp_suspend()`/`davinci_mcasp_resume()` DAI callbacks that
  previously handled system suspend
- [Phase 3] git tag --contains 6175471755075d: confirmed present in
  p-5.10 and p-5.15 (all active stable trees)
- [Phase 3] git log v6.1..HEAD / v5.15..HEAD: PM ops area unchanged in
  stable trees, patch will apply cleanly
- [Phase 4] b4 dig: could not match by message-id; lore blocked by anti-
  bot measures
- [Phase 5] Grep for `pm_runtime_force_suspend` in sound/: found 35+
  drivers using identical pattern
- [Phase 6] Code exists unchanged in all active stable trees since v5.2
- [Phase 8] Failure mode: complete audio loss after system suspend,
  severity HIGH
- UNVERIFIED: Could not read lore.kernel.org discussion due to anti-bot
  protection. However, the maintainer's Signed-off-by confirms review
  and acceptance.

**YES**

 sound/soc/ti/davinci-mcasp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 2d260fbc9b835..14267be4a288a 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -2823,6 +2823,8 @@ static int davinci_mcasp_runtime_resume(struct device *dev)
 #endif
 
 static const struct dev_pm_ops davinci_mcasp_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(davinci_mcasp_runtime_suspend,
 			   davinci_mcasp_runtime_resume,
 			   NULL)
-- 
2.53.0

