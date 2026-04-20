Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D9B3E6DDA;
	Mon, 20 Apr 2026 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691500; cv=none; b=tCrAtP6iajZnXI0vKTbnh0NY96g6ZafrhjDXMKpKNr5aJGa8rLC3mZbBRfnLP+B/KjvO1LZpf/qT+AadlQzS77KLij/t46LDRIfnzTwrlf0m8FN48ouOJYilLzPn8MjMYRHjj2DOIFqR5W9/1CkiPzIVcYLWyzAZifxVnsZFYfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691500; c=relaxed/simple;
	bh=n/wmUzdpqSBAXEipBRzmC/HsKpglFLVxG8uy0+8xxVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qemOPxMQRKB6+NduzZR4NZMbAH03oM5oYXU+BePVvM/t3OXIDCHf9G2viICvqyZGhWgHzCEZBYFx6xmZi8aCb4RK5uvpxGfsSmzlcsoNeiYKQJb6JhvK+cx8Ps2L/UAwS61J1vwPhCcG2gCkTog62hwmFGn46VdiiYcrnvsNElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YceOarx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YceOarx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE8C2BCB7;
	Mon, 20 Apr 2026 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691500;
	bh=n/wmUzdpqSBAXEipBRzmC/HsKpglFLVxG8uy0+8xxVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YceOarx5+B22dg1RGpuPRiaVgImsO1qjz5MGk7X45GSgjK4ZfsfBRmeOm3h79o72g
	 +eJ+mYSCOg3pxH4HKXk/+fFAOwRFn1uzxsN5IHcM93lrBcvIKv70iB3uiy+0koTU1+
	 6en7Vud1KulikEDUQcH8dUucsntCwJ+dXJY6dH1W33hHytIHVoe1qtcwrXcsOeXHnQ
	 qhUO8Qobyeer9RNZ9l2WmKG4TSv32UzEUVA2C79n+W0gHyCR0wZM7+4oRr2wYzf7Ea
	 RdqEmgpPyla5cjAQy33NnqOP9F09Em6J5PfjMpMyJMs0ifYJpzqo6TB12+I+yVA6kx
	 WXANQLeCzyXkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] i3c: mipi-i3c-hci-pci: Add support for Intel Nova Lake-H I3C
Date: Mon, 20 Apr 2026 09:17:40 -0400
Message-ID: <20260420132314.1023554-66-sashal@kernel.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit eaa1d092a4f304415b867b7b74ed74b8f8722b0b ]

Add I3C controller PCI IDs for Intel Nova Lake-H.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260309075045.52344-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write the analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parsing**
Record: [i3c/mipi-i3c-hci-pci] [Add] [PCI IDs for Intel Nova Lake-H I3C
controller support]

**Step 1.2: Commit message tags**
Record:
- Signed-off-by: Adrian Hunter (Intel)
- Reviewed-by: Frank Li (NXP) — i3c subsystem reviewer
- Link: patch.msgid.link (lore patch URL)
- Signed-off-by: Alexandre Belloni — the I3C maintainer committed
- No Fixes:, no Cc: stable — expected
- No syzbot / no sanitizer tags

**Step 1.3: Commit body analysis**
Record: Message literally says "Add I3C controller PCI IDs for Intel
Nova Lake-H". No bug description, no failure mode — this is pure
hardware enablement, adding 2 PCI IDs to an existing driver's
`pci_device_id` table.

**Step 1.4: Hidden bug fix detection**
Record: Not a hidden bug fix. The verb is "Add" and the action is
strictly extending the device table. No error-path, locking, refcount,
init, or safety-check changes.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file changed (`drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-
pci.c`), +3/-0 lines. Single hunk in the `mipi_i3c_hci_pci_devices[]`
table. No function body modified.

**Step 2.2: Code flow change**
Record:
- Before: The PCI ID table terminates after `Nova Lake-S` entries.
- After: Two additional entries appear before the `{ },` sentinel:
  - `0xd37c → intel_mi_1_info`
  - `0xd36f → intel_mi_2_info`
These IDs reuse existing `intel_mi_1_info`/`intel_mi_2_info` structs
(already used for Nova Lake-S), so no new code paths.

**Step 2.3: Bug mechanism**
Record: No bug mechanism — hardware workaround / device-ID-addition
category (exception (1) from the rubric).

**Step 2.4: Fix quality**
Record: Obviously correct. Pure data addition, reusing existing `info`
objects already validated by Nova Lake-S (same MI-class silicon). Cannot
introduce a regression on any platform without the matching PCI IDs.
Zero regression risk.

### PHASE 3: GIT HISTORY

**Step 3.1: Blame context**
Record: The device table lives in a file introduced in v6.14 (commit
`30bb1ce712156`). Recent siblings in the table added the same way:
- `d515503f3c8a8` Wildcat Lake-U (merged v6.18)
- `ddb37d5b130e1` Nova Lake-S (merged v6.19)

**Step 3.2: Fixes: tag**
Record: N/A — no Fixes tag (not a bug fix).

**Step 3.3: Related file history**
Record: File has steady PCI-ID additions per Intel platform generation.
Pattern is well established and each one is a standalone commit. No
prerequisite commits are needed for this entry — `intel_mi_1_info` and
`intel_mi_2_info` are both already present in mainline.

**Step 3.4: Author context**
Record: Adrian Hunter (Intel) is an established contributor to this
driver and submitted many previous platform-enablement additions
(runtime PM, system suspend, LTR, Nova Lake-S submission chain, etc.).
Maintainer Alexandre Belloni signed off.

**Step 3.5: Prerequisites**
Record: Requires `intel_mi_1_info` and `intel_mi_2_info` symbols. Both
exist since `540a55a5bafd0` ("Define Multi-Bus instances for supported
controllers"), in v7.0. Therefore the patch applies cleanly to 7.0.y.
Older stable trees (≤6.19.y) only define `intel_info` and would require
adaptation (but Nova Lake-S was already backported to 6.19.y using
`&intel_info`).

### PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1–4.5: Lore discussion**
Record: Patch committed with Frank Li's Reviewed-by. Maintainer applied
it to i3c tree. Fetching the msgid mirror (patch.msgid.link) is blocked
by anti-bot challenge, and `b4 dig` isn't required given the small,
trivial diff. No public NAKs or stable nomination in the commit message.
UNVERIFIED: detailed thread content (blocked by Anubis). The patch
subject, reviewer, and single-series character (not part of a multi-
patch series) are clear from the commit metadata.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1–5.5**
Record: No functions modified. The only consumer is the PCI core's
device-ID matching; adding a new entry can only cause the driver to bind
to a new vendor/device tuple. `intel_mi_1_info`/`intel_mi_2_info` are
static-storage structs already initialized and used by at least Nova
Lake-S entries, so impact surface is limited to systems containing
VID:DID `8086:d37c` or `8086:d36f`. On all other systems the new entries
are inert.

### PHASE 6: CROSS-REFERENCING / STABLE

**Step 6.1: Code in stable**
Record: Driver exists in 6.14+. Stable branches currently maintained:
6.17.y (EOL soon), 6.18.y, 6.19.y, 7.0.y. The PCI ID table exists in all
of them.

**Step 6.2: Backport complications**
Record:
- 7.0.y: Clean apply (multi-bus `intel_mi_1/mi_2_info` structs already
  exist in 7.0).
- 6.19.y: Needs trivial adaptation — replace the `info` references with
  `&intel_info` (as was done when Nova Lake-S was backported there;
  verified v6.19.13 has `Nova Lake-S` entries pointing at
  `&intel_info`).
- 6.18.y and older: Similar simple adaptation using `&intel_info`. Note,
  Nova Lake-S was NOT backported to 6.18.y (verified v6.18.23 has only
  Wildcat Lake-U + Panther Lake), so this change may be considered too
  new for 6.18.y at this time; the AUTOSEL/stable maintainer can decide.

**Step 6.3: Existing stable fixes**
Record: Precedent exists — Nova Lake-S (ddb37d5b130e1) was backported to
6.19.y, confirming PCI-ID additions for this driver go to stable when
the driver is present.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
Record: `drivers/i3c/master/mipi-i3c-hci/` — MIPI I3C Host Controller
for Intel LPSS. Criticality: PERIPHERAL from a user-population
standpoint, but important for specific Intel client platform users
(sensors, power-delivery ICs, etc. are often on I3C on modern Intel
laptops/desktops).

**Step 7.2: Activity**
Record: Very active (many recent fixes and platform additions). This is
a well-maintained hot area.

### PHASE 8: IMPACT/RISK

**Step 8.1: Who is affected**
Record: Users with Intel Nova Lake-H platforms. Without the patch: I3C
peripheral devices on Nova Lake-H don't bind to this driver. With the
patch: they do.

**Step 8.2: Trigger**
Record: Runs on first PCI probe when matching VID/DID are present. Only
activates on Nova Lake-H hardware.

**Step 8.3: Failure mode (without patch)**
Record: I3C controller not probed → I3C devices unavailable on that
platform. Severity: MEDIUM (functional/enablement limitation, not a
crash or data corruption). Regression risk from adding the IDs:
effectively zero.

**Step 8.4: Risk/benefit**
Record: BENEFIT = hardware enablement for a new platform. RISK = near
zero (3-line data-only patch reusing validated info structs). Classic
positive-ratio stable candidate.

### PHASE 9: SYNTHESIS

**Evidence FOR:**
- Falls squarely into the stable-rules exception category for new device
  IDs in existing drivers.
- 3 lines, pure data, zero logic change.
- Reused `info` structures already in use for Nova Lake-S — same silicon
  family.
- Precedent: sibling commit (Nova Lake-S) was backported to 6.19.y.
- Reviewed by established i3c reviewer; applied by maintainer.

**Evidence AGAINST:**
- Not a bug fix in the traditional sense; no CVE, no crash. But the
  stable rules explicitly permit device-ID additions.
- For pre-7.0 stable trees, a trivial rewrite is needed (swap to
  `&intel_info`). For 7.0.y it's a clean apply.

**Stable rules checklist:**
1. Obviously correct and tested — yes (data-only, matches Nova Lake-S
   pattern)
2. Fixes a real issue affecting users — yes, enables hardware on Nova
   Lake-H
3. Important issue — hardware enablement (exception category)
4. Small and contained — yes (3 lines, one file)
5. No new features/APIs — correct; no new API surface
6. Applies to stable — clean to 7.0.y; trivial adaptation for older

**Exception category:** YES — new PCI device IDs added to an existing,
already-in-stable driver.

### Verification

- [Phase 1] Read full commit message from user query; tags enumerated;
  no syzbot/Fixes.
- [Phase 2] `Read` of `drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-
  pci.c` at HEAD — confirmed the 3-line addition reuses
  `intel_mi_1_info` and `intel_mi_2_info` already defined in the file
  (lines 185–210).
- [Phase 3] `git log --oneline -20 --
  drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c` — verified
  platform-addition pattern (Wildcat Lake-U, Nova Lake-S precedents).
- [Phase 3] `git show ddb37d5b130e1 --stat` — verified Nova Lake-S was a
  3-line PCI-ID addition by the same author/maintainer path, `Reviewed-
  by: Frank Li`.
- [Phase 3] `git describe --contains ddb37d5b130e1` →
  `v6.19-rc1~57^2~23` — Nova Lake-S landed in v6.19.
- [Phase 3] `git describe --contains 30bb1ce712156` → `v6.14-rc1~98^2~7`
  — driver is in stable from v6.14 onward.
- [Phase 4] `WebFetch https://patch.msgid.link/20260309075045.52344-1-
  adrian.hunter@intel.com` — blocked by Anubis; thread content
  UNVERIFIED. Commit metadata (Reviewed-by, subsystem maintainer SoB) is
  sufficient signal.
- [Phase 5] Read `mipi_i3c_hci_pci_devices[]` table in full (lines
  327–341 of current file) — confirmed existing entries use the same
  `intel_mi_1_info` / `intel_mi_2_info` objects the new entries
  reference.
- [Phase 6] `git show
  v6.19.13:drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c` —
  confirmed Nova Lake-S entries are present in 6.19.y stable, using
  `&intel_info` (simpler structure).
- [Phase 6] `git show
  v6.18.23:drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c` —
  confirmed 6.18.y does NOT have Nova Lake-S; this file is more
  divergent there, so backport to 6.18.y would be an editorial call.
- [Phase 6] `git show v7.0:drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-
  pci.c` — confirmed 7.0 has
  `intel_mi_1_info`/`intel_mi_2_info`/`intel_si_2_info`, so patch
  applies cleanly to 7.0.y.
- [Phase 6] `git rev-list --count eaa1d092a4f30 ^v7.0` = 3 — the
  mainline commit is 3 commits past v7.0.
- [Phase 8] Confirmed only behavioral change is PCI binding of the new
  VID:DID tuples; no runtime impact on any other system.
- UNVERIFIED: Lore thread contents (Anubis-blocked); whether the
  submitter/maintainer explicitly requested stable inclusion. This does
  not affect the technical assessment given the clear exception
  category.

### Conclusion

This is a textbook "new PCI device IDs for an existing, already-shipping
driver" change. It matches the stable-rules exception exactly, is a
3-line data-only addition that reuses objects already validated by the
sibling Nova Lake-S entries, and has direct backport precedent (Nova
Lake-S) in 6.19.y. Risk is effectively zero; benefit is hardware
enablement for users on stable trees who deploy Nova Lake-H systems.

**YES**

 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index 30302e4d08e2a..22a5ba4ad7460 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -337,6 +337,9 @@ static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
 	/* Nova Lake-S */
 	{ PCI_VDEVICE(INTEL, 0x6e2c), (kernel_ulong_t)&intel_mi_1_info},
 	{ PCI_VDEVICE(INTEL, 0x6e2d), (kernel_ulong_t)&intel_mi_2_info},
+	/* Nova Lake-H */
+	{ PCI_VDEVICE(INTEL, 0xd37c), (kernel_ulong_t)&intel_mi_1_info},
+	{ PCI_VDEVICE(INTEL, 0xd36f), (kernel_ulong_t)&intel_mi_2_info},
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, mipi_i3c_hci_pci_devices);
-- 
2.53.0

