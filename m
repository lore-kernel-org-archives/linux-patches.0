Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6F45B0622;
	Mon, 19 Oct 2026 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418423; cv=none; b=pVb4k8md95TQgF2JBbD/Wq5jfTH14Zb0GFL+bp9HaIXFRIhePgsD6RzL+Qi+uJAIZIHEh9kmLlFF9ly/yxcuW+CulwsG0Zfssbbdb9yWfy6SujZG95WsPs4vw6I/QoSQHwgDf90ytZ2vaSC1G64I++K4KlbAGjaplsxGevYV7qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418423; c=relaxed/simple;
	bh=+FlKxuhacd7NRpYtXfslnzo9m0fuF1eNvg4eUGav4eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qWE6ekXUoj2fX5jLa6QmrpGotRPu3dm1j+F06qsViQUy4JeU6XJpSYyPXpTwYhQmgb3QitaQWnYXLSNJgW/3zpZYjOGPnYHo0vJeRaFLSj2sbsmzWAD2QmYINhiwYrd7iG2acgc4yez2wJkGgJZM1LcvjJKzfnT6eAp6m5zVG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=df94oUW8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="df94oUW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CCF1F000CA;
	Mon, 19 Oct 2026 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418419;
	bh=pLa3Aan2ET0EDHss61T2wkoqQI56vgVGp8lag2OXteo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=df94oUW8o5xdAqDAK0WjUjhnDDBXBlzCbaR72MWKDXefNZp8xPoJCsY6lGbtQrVmh
	 JjJ+v6fy7hrs+gB7fpGjlO7BwVvgF+6ZlbOSMA9wSTuRVCKvWuneNiE9QzWvDfdysA
	 vH1f0YJqVtucH6km19sqeTVqiWFZbFz423uwWP1eqtU1DZyibW+abc6yqqHbDc31I0
	 ar95+IwZ/qApveo+lhXUFQdrxFuHsueL3ZeA/c/zObqb97goXHYFbCpkE/RwwKkqh0
	 0t0iiPk8/2es21EJK8K/G3uHrAXkTa/BzixZYGibVyjcbNq6uBZGv/vApdKNt0DrnZ
	 dgG+2rnqjOMcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	daniel.lezcano@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thermal: intel: int340x: clean up RFIM groups on DVFS failure
Date: Mon, 19 Oct 2026 09:48:47 -0400
Message-ID: <20261019135441.1420968-236-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28f34d7dafa6dfa657efd6760b7c78e98c9b2f6a ]

proc_thermal_rfim_add() can create the FIVR and DLVR sysfs groups
before creating the DVFS group.

If DVFS group creation fails while both earlier groups are enabled, the
current error handling removes only one group: the FIVR branch returns
before the DLVR cleanup branch can run.  This leaves the DLVR group
behind even though RFIM setup fails.

Use one DVFS failure path that removes all previously created RFIM
groups before returning the error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[thermal/intel/int340x] [clean up] incomplete RFIM sysfs-group
unwind when DVFS group creation fails`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>`
  (thermal maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `proc_thermal_rfim_add()` may create FIVR and DLVR sysfs groups,
  then fail creating DVFS.
- Symptom: on DVFS failure with both earlier groups enabled, the FIVR
  cleanup branch returns immediately, so the DLVR group is never
  removed.
- Failure mode: leftover sysfs group after RFIM setup reports failure
  (resource leak; probe of the Intel processor thermal PCI device
  fails).
- Root cause: two sequential `if (ret && FEATURE_*) { remove; return; }`
  blocks instead of one failure path that removes every group that was
  created.
- Version info in the message: none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Yes. The subject says “clean up”, but the body and the diff are
an error-path leak fix (missing `sysfs_remove_group` for DLVR).

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c`
  (+5 / −6)
- Function: `proc_thermal_rfim_add()`
- Scope: single-file surgical error-path change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, DVFS `sysfs_create_group()` failure did:

```c
if (ret && FIVR) { sysfs_remove_group(fivr); return ret; }
if (ret && DLVR) { sysfs_remove_group(dlvr); return ret; }
```

If both FIVR and DLVR bits are set, the first branch returns and DLVR is
never removed. After, a single `if (ret)` removes DLVR and/or FIVR
according to the feature mask, then returns.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[error path / resource leak]` Incomplete unwind.
`sysfs_create_group(&pdev->dev.kobj, &dvfs_attribute_group)` failure
leaked `dlvr_attribute_group` when FIVR+DLVR+DVFS were all enabled.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Groups are only removed if the corresponding
feature bit is set, and those bits are the same ones that caused the
groups to be created earlier in this function. No API, locking, or data-
structure changes. Regression risk is very low: `sysfs_remove_group` on
a group that this function just created.

## Phase 3: Git history

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Original FIVR-only DVFS unwind: `473be51142adba` (“Add RFIM driver”,
  2020; first in v5.11-rc1).
- Incomplete DLVR branch: `5bc6b1df65c87f` (“Add DLVR support for RFIM
  control”, 2023-04-13; first in v6.4-rc1). That commit added the second
  `if (ret && DLVR) return` after the existing FIVR early-return, which
  is the bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable beyond that. The introducing
commit is `5bc6b1df65c87f`, and `git merge-base --is-ancestor
5bc6b1df65c87f HEAD` succeeded.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `15176b818e048c` (“Fix sysfs group leak on DLVR registration failure”)
  — same class of bug for the *DLVR create* path leaking FIVR; already
  in this tree (v7.0-rc1).
- This patch is standalone, not `patch X/Y`. Same author later did a
  similar ODVP probe-unwind fix (`d83dc9ce57a74`) in a different file;
  not a prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is not the subsystem maintainer. Thermal maintainer
Rafael J. Wysocki applied the patch. Driver author Srinivas Pandruvada
was on the original To/Cc list.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. The fix only reorders existing `sysfs_remove_group()`
calls on `fivr_attribute_group` / `dlvr_attribute_group`, both present
in this tree. Can apply standalone.

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 28f34d7dafa6d` →
  https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: v1 only
- Thread (mbox): no NAKs. Rafael: “Applied as 7.3 material, thanks!”
- No reviewer `Cc: stable` suggestion

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Rafael J. Wysocki, Daniel Lezcano,
Zhang Rui, Srinivas Pandruvada, linux-pm. Applied by the thermal
maintainer. No separate Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. This is a code-inspection
leak, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Sibling leak fix is `15176b818e048c` (already
here). Author’s ODVP cleanup is a different driver file.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org HTTP 403. `b4 dig` thread has no stable-list
discussion. UNVERIFIED: whether linux-stable@ ever discussed this
subject independently.

## Phase 5: Code semantic analysis

**Step 5.1: KEY FUNCTIONS**
Record: `proc_thermal_rfim_add()` (modified). Uses `sysfs_create_group`
/ `sysfs_remove_group`.

**Step 5.2: TRACE CALLERS**
Record:
- `proc_thermal_mmio_add()` in `processor_thermal_device.c` (only
  caller)
- That is called from `proc_thermal_pci_probe()` and
  `proc_thermal_pci_legacy` probe
- Probe / device-enumeration path, not IRQ or a hot syscall path

**Step 5.3: TRACE CALLEES**
Record: `sysfs_create_group`, `sysfs_remove_group` on the PCI device
kobject.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: PCI probe → `proc_thermal_mmio_add()` →
`proc_thermal_rfim_add()`. On RFIM failure, `proc_thermal_mmio_add()`
does `goto err_rem_ptc` and **does not** call
`proc_thermal_rfim_remove()`. `proc_thermal_pci_probe()` then `return
ret` without `proc_thermal_mmio_remove()`. The leaked DLVR group
therefore stays on `pdev->dev.kobj`. Reachable whenever this Intel
thermal PCI device is probed (common on Intel laptops/SoCs with
INT340x). Trigger still requires `sysfs_create_group(dvfs)` to fail.

Verified hardware with all three bits (the only way both groups exist at
DVFS failure): Meteor Lake `MTLP_THERMAL` is `FIVR | DVFS | DLVR`
(`processor_thermal_device_pci.c`). `5bc6b1df65c87f` is what OR’d
`PROC_THERMAL_FEATURE_DLVR` onto that ID.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same incomplete-unwind pattern was already fixed for DLVR-
create-fails-after-FIVR (`15176b818e048c`). `fs/sysfs/group.c` returns
`-EEXIST` (and warns) if the named group already exists, so a leaked
DLVR group can make a later re-bind fail even after the original
transient error is gone.

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: `v7.3-rc4-27-gf0100363d8c37`, `make kernelversion` →
  7.3.0-rc4
- RFIM, DLVR, FIVR, DVFS, and MTLP FIVR+DLVR+DVFS are all present
- Bug introduced in v6.4 (`5bc6b1df65c87f`), well before this 7.3 branch
- Parent of the candidate still has the two early-return blocks

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding `proc_thermal_rfim_add()` in this tree
matches the hunk (Nova Lake DLVR switch and the earlier FIVR leak fix
are already here).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `15176b818e048c` is in this tree and fixes a *different* leak
(DLVR create vs FIVR). It does not fix DVFS-create leaking DLVR. No
other substitute for this patch.

## Phase 7: Subsystem and maintainer context

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[drivers/thermal/intel/int340x] [IMPORTANT]` — Intel laptop/SoC
processor thermal / RFIM sysfs, not core mm/fs, but used on shipping
Meteor Lake platforms. `CONFIG_INT340X_THERMAL`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (Nova Lake, Wildcat Lake, Panther Lake IDs
and DLVR tables in recent history). Maintainer applied this patch.

## Phase 8: Impact and risk

**Step 8.1: WHO IS AFFECTED**
Record: Driver-specific / config-specific: Intel INT340x processor
thermal PCI, specifically IDs with FIVR+DLVR+DVFS (Meteor Lake in this
tree).

**Step 8.2: TRIGGER CONDITIONS**
Record: Device probe, after FIVR and DLVR groups succeed, when DVFS
`sysfs_create_group()` fails (ENOMEM, duplicate name, etc.). Not
unprivileged-syscall reachable except via driver bind. Uncommon, but
deterministic when it happens. Re-probe can then hit `-EEXIST` on the
leaked DLVR group (`internal_create_group()` in `fs/sysfs/group.c`).

**Step 8.3: FAILURE MODE SEVERITY**
Record: `[sysfs group leak on PCI device after failed probe; possible
sticky re-bind failure] [MEDIUM]` — not a panic or filesystem
corruption. Stale `dlvr` attributes can remain on the PCI device kobject
after the driver has reported probe failure.

**Step 8.4: RISK-BENEFIT RATIO**
Record: Benefit medium (correct unwind on a real shipping platform’s
probe error path; avoids leftover sysfs and sticky `-EEXIST`). Risk very
low (5-line error-path-only change, no locking/API). Ratio favors taking
the fix.

## Phase 9: Final synthesis

**Step 9.1: EVIDENCE**

FOR:
- Real, deterministic incomplete unwind; DLVR group leaked when
  FIVR+DLVR+DVFS are set
- Meteor Lake actually sets all three feature bits
- Caller does not call `proc_thermal_rfim_remove()` on
  `proc_thermal_rfim_add()` failure
- Same bug class as `15176b818e048c`, which this tree already contains
- Tiny, obviously correct, no new API
- Thermal maintainer applied it; right people were CCed; no NAKs
- Bug present since v6.4; code exists in this 7.3 tree

AGAINST:
- Trigger is a failed `sysfs_create_group()` (rare)
- No user/syzbot report
- Not a crash, UAF, or data-corruption bug
- Rafael queued it as 7.3 material, not as a stable-cc’d hotfix

UNRESOLVED:
- Direct lore.kernel.org / stable-list HTTP search returned 403; thread
  content recovered via `b4 dig -m` instead

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — control flow is local and
   clear; maintainer applied v1 with no further revisions.
2. Fixes a real bug that affects users? **PASS** — leftover sysfs on the
   PCI device after failed RFIM setup on Meteor Lake.
3. Important issue? **PASS** (medium) — resource leak with a possible
   sticky re-bind failure, not a panic; still the error-path leak class
   stable regularly takes.
4. Small and contained? **PASS** — one function, +5/−6 lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file and both sysfs groups
   exist; hunk matches.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs exception). It
is a normal small leak fix.

**Step 9.4: DECISION**
This tree is 7.3.0-rc4. The buggy unwind, DLVR/FIVR/DVFS groups, and
Meteor Lake FIVR+DLVR+DVFS mask are all here. The patch is a minimal,
correct error-path leak fix with negligible regression risk. It should
be in this tree.

Verification:
- [Phase 1] Tags: author SOB, Rafael SOB, lore Link; no Fixes/Reported-
  by/Cc: stable
- [Phase 2] Diff: `proc_thermal_rfim_add()` DVFS failure path; two
  early-returns collapsed into one unwind of DLVR then FIVR
- [Phase 3] `git blame` on parent: FIVR unwind from `473be51142adba`
  (v5.11); DLVR early-return from `5bc6b1df65c87f` (v6.4-rc1)
- [Phase 3] `git merge-base --is-ancestor 5bc6b1df65c87f HEAD` → yes;
  related leak fix `15176b818e048c` also in HEAD
- [Phase 3] `git log --author='Pengpeng Hou'` on thermal: this RFIM fix
  plus a later independent ODVP unwind
- [Phase 4] `b4 dig -c 28f34d7dafa6d`:
  https://patch.msgid.link/20260615065245.84252-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: linux-pm +
  Pandruvada/Wysocki/Lezcano
- [Phase 4] mbox: Rafael “Applied as 7.3 material”; no NAK, no stable
  nomination
- [Phase 4] lore.kernel.org WebFetch: 403; stable-list search UNVERIFIED
  via HTTP
- [Phase 5] Callers: `proc_thermal_mmio_add` → PCI probe; RFIM failure
  jumps to `err_rem_ptc`, skipping `proc_thermal_rfim_remove`
- [Phase 5] MTLP ID: `FIVR | DVFS | DLVR` in
  `processor_thermal_device_pci.c`; DLVR bit added in `5bc6b1df65c87f`
- [Phase 5] `sysfs_create_group` / `internal_create_group`: `-EEXIST` if
  named group already exists
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Parent function still has the buggy two-branch return; this
  tree has the needed groups and IDs
- [Phase 8] Failure mode: leaked `dlvr` sysfs group after probe failure;
  severity MEDIUM

The fix is small, surgical, and meets the stable criteria for an error-
path resource leak on hardware this tree already supports.

**YES**

 .../intel/int340x_thermal/processor_thermal_rfim.c    | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 635bc8fded1e9..2f32b230a4b15 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -460,12 +460,11 @@ int proc_thermal_rfim_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 
 	if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DVFS) {
 		ret = sysfs_create_group(&pdev->dev.kobj, &dvfs_attribute_group);
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
-			return ret;
-		}
-		if (ret && proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR) {
-			sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+		if (ret) {
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_DLVR)
+				sysfs_remove_group(&pdev->dev.kobj, &dlvr_attribute_group);
+			if (proc_priv->mmio_feature_mask & PROC_THERMAL_FEATURE_FIVR)
+				sysfs_remove_group(&pdev->dev.kobj, &fivr_attribute_group);
 			return ret;
 		}
 	}
-- 
2.53.0

