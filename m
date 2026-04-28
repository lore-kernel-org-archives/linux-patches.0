Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27D3F6612;
	Tue, 28 Apr 2026 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372909; cv=none; b=YnegReBNoF07aacgG1MTi/xIiTaajdGsT96ulUDD4uSA79AeAZTFzizR0Uv8z97Rb56xX6zm+LId0uYYeUM8nxPYcTzsatmcFhXI4e0iKDpiijzdZ9duci9uem8bHRuxWNYAk8au6DvWdOswv38beODi42lzc/zom+l6lCXN+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372909; c=relaxed/simple;
	bh=MrijHnSukrGEA7lvsUJDFJZkv206sKWIDXoibZ3pi54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jcbtUJSLe/o7uNuc6Ulht3rLP0lqLwU6dqAnCPaL39mMzA6zeKMAtgtSSCNa5Vs3P7g0igxSNhh3QNh5ZLs7RtnrBCgEdYtSONF+JVhKZNTR8d7CTcIH5UN/DaQznbHz/XDgl456cAs9DnOd/z2o6rOlXk0AyNP0DHbt7dYvaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAC3yDVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAC3yDVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C0DC2BCB6;
	Tue, 28 Apr 2026 10:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372909;
	bh=MrijHnSukrGEA7lvsUJDFJZkv206sKWIDXoibZ3pi54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAC3yDVz57Z3meDtVxo9vPLbl/9sjM5vBy7XfSfIKzwluGou1FFgRqXf+k+q+knoZ
	 /iVDjXrsL2bera6KqRlPa1ej3rS4Qb/8f2jGGnioR2yFCLJ/CkudAlspcUavcgLiCK
	 tOnX87OGn3jXKh2WLxxKiNEZ1QHeykrAp+4FB7WG31ugkj+P7z0MJnGZS4ovLsn3AE
	 fSGmQxTiu1YY97kNhLUjeAcyh1O7tiQoDtJYpZVacG0I9gzwArbefGvMOwJQ8teJJD
	 u3kZgL977QTgGoJ/IXrPnf8OlfpLQZGOg4/Jbxh9ttNndEDHCWb9ydk0XbVany64Nd
	 g0Z0kJsVg2hig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rene Sapiens <rene.sapiens@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	michael.jamet@intel.com,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] thunderbolt: Disable CLx on Titan Ridge-based devices with old firmware
Date: Tue, 28 Apr 2026 06:40:22 -0400
Message-ID: <20260428104133.2858589-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rene Sapiens <rene.sapiens@linux.intel.com>

[ Upstream commit 59b03d12b1f6d14d936a3ebec225f8d914dc3b70 ]

Thunderbolt 3 devices based on Titan Ridge routers with NVM firmware
version < 0x65 have been observed to become unstable when CL states are
enabled. This can lead to link disconnect events and the device failing
to enumerate.

Enable CLx on Titan Ridge only when the running NVM firmware version
is >= 0x65.

Signed-off-by: Rene Sapiens <rene.sapiens@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the analysis.

---

# Analysis: thunderbolt: Disable CLx on Titan Ridge-based devices with
old firmware

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject line parsed:**
Record: [thunderbolt (subsystem)] [Disable (action verb - indicates a
bug workaround)] [CLx on Titan Ridge-based devices with old NVM
firmware]

**Step 1.2 - Tags parsed:**
Record: Two `Signed-off-by:` tags — Rene Sapiens (author) and Mika
Westerberg (subsystem maintainer). NO `Fixes:`, NO `Cc: stable`, NO
`Reported-by:`, NO `Link:`, NO `Reviewed-by:`, NO `Tested-by:`.
(Expected — that's why this commit needs review.)

**Step 1.3 - Commit body:**
Record: Bug description: "Thunderbolt 3 devices based on Titan Ridge
routers with NVM firmware version < 0x65 have been observed to become
unstable when CL states are enabled." Symptoms: "link disconnect events
and the device failing to enumerate." Failure mode: link instability,
device enumeration failure (user-visible — Thunderbolt device doesn't
work). Author's mechanism: old NVM firmware has a hardware/firmware bug
triggered when CL (low-power link) states are entered.

**Step 1.4 - Hidden bug fix detection:**
Record: Not hidden — the commit is clearly a bug-triggered hardware
workaround/quirk. "Disable" here means "disable the broken low-power
states on broken hardware/firmware combinations."

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1 - Inventory:**
Record: 1 file changed: `drivers/thunderbolt/quirks.c`, +7 / -0.
Functions modified: `quirk_clx_disable()` (3 lines added); table
`tb_quirks[]` (1 new entry, 4 lines including blank and comment). Scope:
single-file surgical fix.

**Step 2.2 - Code flow change:**
Record:
- Before: `quirk_clx_disable()` was only invoked from AMD Yellow Carp /
  Pink Sardine table entries. When invoked, it unconditionally set
  `QUIRK_NO_CLX`.
- After: A new table entry matches Intel Titan Ridge DD bridge
  (0x8086:0x15ef) and invokes `quirk_clx_disable()`. Inside, if the
  switch is Titan Ridge AND `sw->nvm->major >= 0x65`, the function
  returns early without applying `QUIRK_NO_CLX`; otherwise it applies it
  as before. AMD path behavior is preserved
  (`tb_switch_is_titan_ridge(sw)` returns false for AMD parts).

**Step 2.3 - Bug mechanism:**
Record: Category (h) Hardware workaround — a vendor-identified firmware
bug on the device causes link instability under CL states. Fix adds a
device-specific quirk table entry plus a firmware-version guard.

**Step 2.4 - Fix quality:**
Record: Small, contained, obviously correct IF `sw->nvm` is populated at
`tb_check_quirks()` time. The fix itself cannot cause regressions on AMD
devices or non-Titan-Ridge Intel devices, since the new check is guarded
by `tb_switch_is_titan_ridge(sw)`. Key concern: whether `sw->nvm` is
populated when this runs — see Phase 3.5.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame:**
Record: CLx support on Titan Ridge was introduced by `43f977bc60b1c`
("thunderbolt: Enable CL0s for Intel Titan Ridge") in v5.17-rc1 and
expanded by `b017a46d486cd` ("thunderbolt: Add CL1 support for USB4 and
Titan Ridge routers") in v6.0-rc1. So the bug window (CLx enabled with
no firmware guard on Titan Ridge DD) is v5.17+.

**Step 3.2 - Fixes: tag:**
Record: No `Fixes:` tag. Implicit target would be `43f977bc60b1c` /
`b017a46d486cd` (v5.17 / v6.0). The `QUIRK_NO_CLX` infrastructure itself
came from `7af9da8ce8f9a` ("thunderbolt: Add quirk to disable CLx") in
v6.3-rc1 and was explicitly tagged `Cc: stable@vger.kernel.org`.

**Step 3.3 - Related file history:**
Record: Recent `quirks.c` changes (`a75e0684`, `0c35ac18`, `f2bfa944`,
`ccdb0900`, `f14d177e`, `f0a57dd3`, `7af9da8c`) are all similar tiny
additions of hardware quirks/logging — the file has low churn and stable
structure.

**Step 3.4 - Author context:**
Record: Rene Sapiens (author) has recent thunderbolt work (margining,
structure cleanups). Mika Westerberg (co-Signed-off-by) is the
Thunderbolt subsystem maintainer and applied the patch directly to
`thunderbolt.git/next`. Strong authority signal.

**Step 3.5 - Dependencies (CRITICAL):**
Record: This commit is PART 2 of a 2-patch series. The prerequisite is
commit `4573add760b8d` ("thunderbolt: Read router NVM version before
applying quirks"). That prerequisite splits `tb_switch_nvm_add()` into
`tb_switch_nvm_init()` (populates `sw->nvm` / reads version) and
`tb_switch_nvm_add()` (registers nvmem), and calls
`tb_switch_nvm_init()` from `tb_switch_add()` BEFORE
`tb_check_quirks()`. Without the prerequisite, `sw->nvm` is NULL when
`tb_check_quirks()` runs, so the new guard `sw->nvm && sw->nvm->major >=
0x65` is always false, and `QUIRK_NO_CLX` is applied to ALL Titan Ridge
DD devices regardless of firmware version. The commit still fixes the
bug (pessimistically) but loses power-savings on newer firmware.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 - b4 dig:**
Record: `b4 dig -c 59b03d12b1f6d` could not find a match (lore search
returned nothing). Manual search via `yhbt.net/lore/linux-usb`
succeeded: cover letter at
`20260224070150.3320641-1-mika.westerberg@linux.intel.com`, patch 2/2 at
`20260224070150.3320641-3-...`, patch 1/2 at
`20260224070150.3320641-2-...`. Only v1 was submitted — no v2/v3.

**Step 4.2 - Reviewers:**
Record: CC list: Yehezkel Bernat, Lukas Wunner, Andreas Noever (past
Thunderbolt co-maintainers), Rene Sapiens (author). Mailing list: linux-
usb@vger.kernel.org. Mika Westerberg (current Thunderbolt maintainer)
submitted and applied. No Reviewed-by/Acked-by/Tested-by tags were added
in the mailing-list discussion before application, but the maintainer
applied it directly.

**Step 4.3 - Bug report:**
Record: No public Link: tag. Cover letter: "There is known issue on
Titan Ridge with older firmware that makes the link unstable if CL
states are enabled." Phrasing indicates this is a vendor-known hardware
issue (Intel internal knowledge), not a user-reported bug traceable via
lore.

**Step 4.4 - Related patches / series:**
Record: 2-patch series. Patch 1/2 (prerequisite) is `4573add760b8d` —
refactor making NVM version available early. Patch 2/2 is this commit.
Both applied as the series by Mika on 2026-03-02.

**Step 4.5 - Stable ML:**
Record: No prior stable@ discussion found for this fix. No explicit
stable nomination by reviewers (thread only has cover-letter "Applied"
reply).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key functions:**
Record: `quirk_clx_disable()` (modified), and the `tb_quirks[]` table
(new entry).

**Step 5.2 - Callers:**
Record: `quirk_clx_disable` is called by `tb_check_quirks()` in
`drivers/thunderbolt/quirks.c` at line 135 via the table dispatch.
`tb_check_quirks()` is called once by `tb_switch_add()` at
`drivers/thunderbolt/switch.c:3341`. `tb_switch_add()` is the mandatory
router-addition path — reachable on every Thunderbolt device
enumeration.

**Step 5.3 - Callees:**
Record: `tb_switch_is_titan_ridge(sw)` (inline predicate on
vendor/device IDs). Access to `sw->nvm->major`. `tb_sw_dbg()` for the
debug message. No locking / no allocation / no I/O — safe.

**Step 5.4 - Call chain reachability:**
Record: User plugs a Thunderbolt device → PCI enumeration →
`tb_switch_add()` → `tb_check_quirks()` → this quirk. Reachable on every
plug/unplug and on every boot for integrated routers. Universal trigger
for affected hardware.

**Step 5.5 - Similar patterns:**
Record: The same `quirk_clx_disable` is already used for AMD Yellow Carp
/ Pink Sardine (by `7af9da8ce8f9a`, which was tagged `Cc:
stable@vger.kernel.org`) — direct precedent of this exact quirk being
stable-worthy.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 - Code in stable:**
Record: `quirks.c` with `quirk_clx_disable()` exists in stable since 6.3
(7af9da8ce8f9a). Titan Ridge CLx support in tree since 5.17. All active
stable trees (6.1.y, 6.6.y, 6.12.y, 6.16.y, etc.) have both the CLx-
enablement code AND the `quirk_clx_disable` infrastructure needed to
apply this patch.

**Step 6.2 - Backport difficulty:**
Record: The `quirks.c` hunk will apply cleanly to all modern stable
trees — the file's structure is unchanged in the surrounding context.
HOWEVER, the fix depends on `sw->nvm` being populated at
`tb_check_quirks()` time, which requires the prerequisite
`4573add760b8d` to be applied as well. If only this commit is
backported, `sw->nvm` will be NULL and the firmware-version guard will
always be false, causing the quirk to apply to ALL Titan Ridge DD
devices (over-aggressive but functionally safe — bug is still fixed for
affected users).

**Step 6.3 - Related fixes already in stable:**
Record: No earlier form of this fix exists in stable. The related
`quirk_clx_disable` for AMD is in stable trees.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 - Subsystem/criticality:**
Record: `drivers/thunderbolt/` — PERIPHERAL driver. Affects users with
Thunderbolt 3 hardware based on Intel Titan Ridge DD bridge (0x15ef).
Users include many Intel-based laptops, eGPU docks, Thunderbolt 3 AICs
with older shipped firmware.

**Step 7.2 - Subsystem activity:**
Record: Thunderbolt is moderately active — regular fixes, hardware
quirks. Mature enough that a firmware-specific quirk is plausible long-
term.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected users:**
Record: Hardware-specific — owners of Thunderbolt 3 devices that use the
Intel Titan Ridge DD bridge (0x15ef) variant with NVM firmware < 0x65.
Also affected: host controllers that haven't had their NVM updated.

**Step 8.2 - Trigger conditions:**
Record: Triggered whenever CL states are entered on an affected Titan
Ridge DD device. Does not require privileges — user just needs to have
affected hardware plugged in.

**Step 8.3 - Failure mode:**
Record: "Link disconnect events and the device failing to enumerate."
Severity: HIGH — the Thunderbolt device becomes unusable. Not a
crash/security issue, but data-path failure for peripheral connectivity
(including storage/display/networking that goes over Thunderbolt).

**Step 8.4 - Risk-benefit:**
Record: Benefit = medium-high (fixes device-unusable bug for real Titan
Ridge users). Risk = very low (7-line hardware quirk, guarded by a
device-ID match, cannot affect non-matching devices; already-existing
`quirk_clx_disable` precedent is in stable). Net: favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence compiled:**

FOR:
- Fixes real hardware-exposed bug causing device enumeration failure on
  TB3 hardware.
- Hardware-quirk exception category — standard stable-worthy class.
- Extremely small (7 lines), device-ID guarded, cannot affect non-
  matching devices.
- Applied by subsystem maintainer (Mika Westerberg) directly.
- Direct precedent in stable (7af9da8ce8f9a used same
  `quirk_clx_disable` pattern, tagged `Cc: stable`).
- The bug has existed since v5.17 (CLx enabled on Titan Ridge) — broad
  stable-tree applicability.

AGAINST / Concerns:
- No `Cc: stable`, no `Fixes:`, no Reported-by — maintainer chose not to
  nominate explicitly.
- Depends on prerequisite `4573add760b8d` (refactor) to realize the
  intended firmware-version selectivity. Without it, the commit still
  fixes the bug but applies the quirk more broadly than intended (loses
  CLx power savings on new-firmware Titan Ridge DD; not a correctness
  regression).

**Step 9.2 - Stable rules checklist:**
1. Obviously correct and tested? Yes — logic is trivial; tested and
   applied to thunderbolt tree; build-tested by kernel test robot.
2. Real bug affecting users? Yes — link disconnects and enumeration
   failures on affected hardware.
3. Important issue? Yes — device-unusable issue for affected hardware
   (HIGH severity for those users).
4. Small and contained? Yes — 7 lines in one file.
5. No new features/APIs? Yes — just a quirk-table entry plus a guard.
6. Applies to stable? The quirks.c hunk itself applies cleanly; the
   intended semantics require the prerequisite to also be backported.
   Without the prerequisite the fix degrades gracefully to "always
   disable CLx on Titan Ridge DD" — still a functional fix.

**Step 9.3 - Exception category:**
Record: Hardware quirk/workaround for buggy firmware/hardware —
explicitly allowed exception for stable.

**Step 9.4 - Decision:**
YES — this is a hardware quirk for a real, device-unusable firmware bug
on Thunderbolt 3 Titan Ridge DD hardware. It is small, surgical, applied
by the subsystem maintainer, and has direct precedent (the identical
`quirk_clx_disable` mechanism was already backported to stable with `Cc:
stable` for AMD CLx-incompatible hardware). Note for the selection
pipeline: the prerequisite `4573add760b8d` should also be backported to
get the intended selective behavior; without it the fix still works but
applies more broadly than intended.

## Verification
- [Phase 1] Parsed tags from `git show 59b03d12b1f6d`: only Signed-off-
  by (Rene Sapiens, Mika Westerberg). No Fixes:, Cc: stable, Reported-
  by, Link:.
- [Phase 2] Diff analysis: confirmed 1 file
  (`drivers/thunderbolt/quirks.c`) +7/-0. Read current file — confirmed
  table entry uses `0x8086, PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE`.
- [Phase 2] Verified `tb_switch_is_titan_ridge()` definition in
  `drivers/thunderbolt/tb.h:982-993` uses `PCI_VENDOR_ID_INTEL` (0x8086)
  and matches TITAN_RIDGE 2C/4C/DD bridges — confirms AMD path
  unaffected.
- [Phase 2] Verified `PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE` =
  0x15ef in `drivers/thunderbolt/nhi.h:75`.
- [Phase 2] Verified test code (`drivers/thunderbolt/test.c:201-202`)
  uses `sw->config.vendor_id = 0x8086; sw->config.device_id = 0x15ef;`
  for Titan Ridge DD — confirms quirk-table vendor ID 0x8086 is correct.
- [Phase 3.1] `git describe --contains 43f977bc60b1c` → v5.17-rc1; `git
  describe --contains b017a46d486cd` → v6.0-rc1: confirms CLx on Titan
  Ridge has been in kernel since v5.17.
- [Phase 3.2] `git show 7af9da8ce8f9a` confirms the `quirk_clx_disable`
  / `QUIRK_NO_CLX` infrastructure came with explicit `Cc:
  stable@vger.kernel.org` — direct precedent.
- [Phase 3.3] `git log --oneline v6.1..v6.6 --
  drivers/thunderbolt/quirks.c` and `v6.6..v7.0` show low churn and
  stable structure.
- [Phase 3.5] Verified prerequisite: `git show 4573add760b8d` confirms
  `tb_switch_nvm_init()` is a NEW function split off from
  `tb_switch_nvm_add()` and a new call site was added in
  `tb_switch_add()` before `tb_check_quirks()`. Verified current `HEAD`
  (`Linux 7.0`) still has only `tb_switch_nvm_add()` (no
  `tb_switch_nvm_init()`) — confirms the dependency.
- [Phase 3.5] Read `switch.c:3297-3407` to confirm ordering:
  `tb_check_quirks()` at line 3341 runs BEFORE `tb_switch_nvm_add()` at
  line 3384, so `sw->nvm` is NULL at quirk time without the
  prerequisite.
- [Phase 4.1] `b4 dig -c 59b03d12b1f6d` → no match; fell back to
  yhbt.net/lore search which returned the series (cover + 2 patches +
  Mika's "Applied" reply + kernel-test-robot build success).
- [Phase 4.1/4.4] Fetched raw mbox of cover letter
  (`20260224070150.3320641-1-...`), patch 1/2 (`-2-`), patch 2/2
  (`-3-`), and Mika's apply-reply
  (`20260302065244.GP2275908@black.igk.intel.com`) — confirmed only v1
  was submitted, applied as-is.
- [Phase 5.2] `rg tb_check_quirks` → single caller `tb_switch_add()`;
  single definition in quirks.c.
- [Phase 6.1] Verified `quirk_clx_disable()` and `QUIRK_NO_CLX` came
  with `7af9da8ce8f9a` tagged `Cc: stable`, so the infrastructure is
  present in stable trees 6.1.y and later.
- [Phase 8.3] Failure mode taken directly from commit message: "link
  disconnect events and the device failing to enumerate."
- UNVERIFIED: Could not independently confirm the exact user-reporting
  trail for this bug (the mailing-list thread doesn't reference a
  specific user report or syzkaller); relied on maintainer and cover-
  letter wording ("known issue").
- UNVERIFIED: Could not test whether the commit applies cleanly to each
  stable branch without actually running `git cherry-pick` on each
  stable tree (only a HEAD worktree is present).

The commit is a small, targeted hardware quirk that fixes a real device-
usability bug on Thunderbolt 3 Titan Ridge DD hardware with old
firmware, applied by the subsystem maintainer, and directly analogous to
a previously-stable-tagged quirk for AMD CLx-incompatible parts.

**YES**

 drivers/thunderbolt/quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index e81de9c30eac9..9f7914ac2f48c 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -23,6 +23,9 @@ static void quirk_dp_credit_allocation(struct tb_switch *sw)
 
 static void quirk_clx_disable(struct tb_switch *sw)
 {
+	if (tb_switch_is_titan_ridge(sw) && sw->nvm && sw->nvm->major >= 0x65)
+		return;
+
 	sw->quirks |= QUIRK_NO_CLX;
 	tb_sw_dbg(sw, "disabling CL states\n");
 }
@@ -61,6 +64,10 @@ static const struct tb_quirk tb_quirks[] = {
 	/* Dell WD19TB supports self-authentication on unplug */
 	{ 0x0000, 0x0000, 0x00d4, 0xb070, quirk_force_power_link },
 	{ 0x0000, 0x0000, 0x00d4, 0xb071, quirk_force_power_link },
+
+	/* Intel Titan Ridge CLx is unstable on early firmware versions */
+	{ 0x8086, PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE, 0x0000, 0x0000,
+		  quirk_clx_disable },
 	/*
 	 * Intel Goshen Ridge NVM 27 and before report wrong number of
 	 * DP buffers.
-- 
2.53.0

