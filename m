Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B94ACC84;
	Mon, 31 Aug 2026 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184046; cv=none; b=A/JmKCMvIajPLnQ9cKdpz+SU5hUn8arS1SmV0T6d1IwbcZpRNcMELp8Dotj8zQAwroTpfaUxpAbbcYXPTa+yTApab/+3sMJLdnBQaTLz1PkByJ5UgKxJj5BUs01p6QOYDJdT4ZzKGRjntSSwl6iAgTnxu5TrC43+rA+OHMz3gHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184046; c=relaxed/simple;
	bh=0qDKHy4Dw1eEbdQk9vQ1hWXocwQ+Nhx6H+pawVgeODY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftA8NbLxVteB6ZE8terjgmhZi/S+RR9ZxoxJ1W7Su2b14qfKzRL12EOo8jj3cqMhjxdoh3KCx0reH4oPKI49SGUZ8mHWAb6g1J0iTHZOcXpokrfK+597TW0B4yuUQa6g85gDl7H3tJsiwU/ob11NqP2cUXgTDatMchrZT8fpp5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WceWIDYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WceWIDYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5908A1F00ADB;
	Mon, 31 Aug 2026 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184042;
	bh=RH+H10X8z3esxQO/GSg8KbuJFyaYnpZsgvc6XfrgJ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WceWIDYNfL6goppWx47NC/A7viNPq8iy11lz+lrsHVLpcAx4LQhK1n2TF8W8GL4bY
	 hVJtGguk12FHdpuTxO4UQWeNgbeaN70mxiJCJgi6/spI7BZhdXk0zLT1wLpcHP/CB0
	 5pTGjrLQ1cUQX4VG/egb1hls2GeqTJUMOOq81QvXCHr2pKVjAnQlgublhnzgUjLiM3
	 WmHFKnsh06uVUQ9pt+gYfY3Eh0vUpnqf4/6/xkCt9cYgpbPyzyn4ihZfDVltOj3meY
	 dNUxbemrPOX/VkF9l+IcSAYZZ/jMbdegcxevYuhW/Loku/HCxiV0DUCPkNygq+M8ei
	 Ok+U3NT6mCnSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ken Lin <kenlin5@quanta.corp-partner.google.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	bleung@chromium.org,
	linux-media@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] media: platform: cros-ec: Add Kulnex and Moxoe to the match table
Date: Mon, 31 Aug 2026 09:28:05 -0400
Message-ID: <20260831133314.4125787-457-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ken Lin <kenlin5@quanta.corp-partner.google.com>

[ Upstream commit e024767f90f9f50bfcce4b20bb74237ad72450f3 ]

The Google Kulnex and Moxoe device uses the same approach as Google Brask
which enables the HDMI CEC via the cros-ec-cec driver.

Signed-off-by: Ken Lin <kenlin5@quanta.corp-partner.google.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[media: platform: cros-ec]` `[Add]` — Add Kulnex and Moxoe
Google Chromebook board names to the CEC DMI match table so HDMI CEC can
be enabled on those platforms.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Ken Lin `<kenlin5@quanta.corp-partner.google.com>`
  (author)
- **Signed-off-by:** Hans Verkuil `<hverkuil+cisco@kernel.org>`
  (media/CEC maintainer)

No syzbot, bugzilla, or user crash reports. Maintainer sign-off is a
positive quality signal.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** Google Kulnex and Moxoe Chromebooks use the same
  HDMI CEC-over-ChromeOS-EC approach as Brask, but are missing from
  `cec_dmi_match_table[]`.
- **Symptom/failure mode:** `cros-ec-cec` probe fails on these boards;
  HDMI CEC is unavailable. No crash is described.
- **Version information:** none in the commit message.
- **Root cause:** Driver uses an explicit DMI whitelist per Chromebook
  model for HDMI DRM device and connector-port mapping. New boards were
  never added.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not a hidden crash/UAF/race fix. This is explicit hardware
enablement: adding board identification entries so an existing driver
can probe on two new platforms. Functionally equivalent to adding
PCI/USB IDs or a DMI quirk entry.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/media/cec/platform/cros-ec/cros-ec-cec.c` (+4
  lines)
- **Functions modified:** none directly; only `cec_dmi_match_table[]`
  data
- **Scope:** single-file, surgical, 4-line addition

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (DMI table):** Before — Kulnex/Moxoe unmatched →
  `cros_ec_cec_find_hdmi_dev()` warns and returns `-ENODEV`. After —
  boards match like Brask/Moxie, DRM HDMI device (`0000:00:02.0`) and
  `port_b_conns` mapping are selected, probe can succeed.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** hardware identification / platform quirk (DMI-based
  board whitelist)
- **Mechanism:** Without a table entry, probe path in
  `cros_ec_cec_probe()` exits early:

```501:503:drivers/media/cec/platform/cros-ec/cros-ec-cec.c
        hdmi_dev = cros_ec_cec_find_hdmi_dev(&pdev->dev, &conns);
        if (IS_ERR(hdmi_dev))
                return PTR_ERR(hdmi_dev);
```

And the lookup function explicitly documents that hardware must be added
to the table:

```362:365:drivers/media/cec/platform/cros-ec/cros-ec-cec.c
        /* Hardware support must be added in the cec_dmi_match_table */
        dev_warn(dev, "CEC notifier not configured for this
hardware\n");

        return ERR_PTR(-ENODEV);
```

### Step 2.4: Fix Quality Assessment
**Record:** Obviously correct — copies the proven Brask/Moxie pattern
(`port_b_conns`, same PCI DRM device name). Minimal diff. Regression
risk is very low: only affects DMI matches for "Google"/"Kulnex" and
"Google"/"Moxoe".

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** The DMI table (lines 304–337) exists in this tree ending at
Moxie; Kulnex/Moxoe are absent. Git history in this checkout is heavily
rewritten/squashed (file history is unreliable), but the driver and full
match table are present since at least `ac3fd01e4c1ef` (Linux 6.18-rc7).
The "missing entry" condition is present in 6.18.43.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History for Related Changes
**Record:** The driver has accumulated many Google board entries (Fizz,
Brask, Moli, …, Moxie). This commit continues that pattern. Standalone
one-commit change; not part of a multi-patch series.

### Step 3.4: Author's Other Commits
**Record:** Ken Lin has no other commits visible in this checkout. Hans
Verkuil is the media/CEC maintainer and signed off. No related author
series found here.

### Step 3.5: Dependent/Prerequisite Commits
**Record:** No dependencies. Driver, `port_b_conns`, DMI/PCI
infrastructure, and `CONFIG_CEC_CROS_EC` all exist in this tree. Applies
standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c 4b3f9bff6067a` failed — commit hash not in local
repo. Lore search blocked (403/bot protection). **UNVERIFIED:** original
thread content, reviewer stable nominations, series revisions.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via `b4 dig -w`. Hans Verkuil SOB confirms
maintainer involvement.

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or Link tags.

### Step 4.4: Related Patches/Series
**Record:** Same pattern as prior Brask/Moxie/Kinox additions to this
table. Standalone.

### Step 4.5: Stable Mailing List History
**Record:** **UNVERIFIED** — could not search lore stable archive.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `cec_dmi_match_table[]` (data),
`cros_ec_cec_find_hdmi_dev()`, called from `cros_ec_cec_probe()`.

### Step 5.2: Trace Callers
**Record:** `cros_ec_cec_probe()` is the platform driver probe path
during boot/module load on Chromebooks with `CONFIG_CEC_CROS_EC` and
`CONFIG_CROS_EC`. Affects only matching Google hardware.

### Step 5.3: Trace Callees
**Record:** `dmi_match()`, `bus_find_device_by_name()` on PCI bus,
connector mapping via `port_b_conns`.

### Step 5.4: Call Chain / Reachability
**Record:** Boot-time platform probe on ChromeOS EC-equipped Google
devices. Not a syscall path. Userspace impact is missing `/dev/cec*` and
non-functional HDMI CEC on Kulnex/Moxoe.

### Step 5.5: Similar Patterns
**Record:** Fifteen other Google boards already use the same table
pattern; Brask and Moxie use identical `port_b_conns` mapping, matching
the commit message claim.

---

## Phase 6: Cross-Referencing Against Local Tree (6.18.43)

### Step 6.1: Does the Buggy Code Exist?
**Record:** **YES.** Local tree is `6.18.43`
(`v6.18.43-1-gc7f0dac02d232`). `drivers/media/cec/platform/cros-ec/cros-
ec-cec.c` exists (602 lines). Table ends at Moxie; Kulnex/Moxoe are
missing. Driver has been present since 6.18-rc7 in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Verified with `git apply --check`
against current tree — applies without conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `grep` finds no Kulnex or Moxoe anywhere in the tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/media/cec/` — media/CEC platform driver.
**IMPORTANT** for affected Chromebook users, **PERIPHERAL** globally
(CEC on two specific Google boards).

### Step 7.2: Subsystem Activity
**Record:** CEC subsystem is active in this tree (recent fixes for seco,
rc race, debugfs leak). The cros-ec driver itself is mature with a
growing DMI whitelist.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Google Kulnex and Moxoe Chromebooks with
`CONFIG_CEC_CROS_EC=y/m`. Config- and platform-specific; not universal.

### Step 8.2: Trigger Conditions
**Record:** Booting one of these two board models with the cros-ec-cec
driver enabled. Deterministic on every boot. Not a security-relevant or
unprivileged-triggered path.

### Step 8.3: Failure Mode Severity
**Record:** HDMI CEC non-functional; driver probe returns `-ENODEV` with
a warning. **Severity: LOW** — feature absence, not crash, corruption,
deadlock, or security issue.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Enables HDMI CEC on two new Chromebook models running
  this kernel; matches established board-enablement pattern.
- **Risk:** Very low — 4 lines, no logic change, only new DMI strings.
- **Ratio:** Moderate benefit for a tiny audience vs. very low risk.
  Does not meet strict "important bug" threshold, but fits the stable
  exception for hardware identification additions.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compile

**FOR backport:**
- Driver and infrastructure fully present in 6.18.43
- Real hardware gap on Kulnex/Moxoe — CEC broken without entries
- Tiny, obviously correct, applies cleanly
- Follows proven Brask/Moxie `port_b_conns` mapping
- Media maintainer (Hans Verkuil) signed off
- Fits stable exception for hardware identification / quirk additions
  (DMI board ID to existing driver)

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock fix
- Failure mode is missing functionality (CEC), severity LOW
- Affects only two specific new Chromebook models
- No user reports, syzbot, or explicit stable nomination
- By-design whitelist: unsupported boards get `-ENODEV`, not a code
  defect on already-supported hardware
- Mailing list review details unverified

**UNRESOLVED:**
- Whether Kulnex/Moxoe actually ship with 6.18.y kernels
- Lore discussion and any stable nominations from reviewers

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mechanical table entries;
   maintainer SOB; pattern proven on Brask/Moxie.
2. Fixes a real bug affecting users? **PASS (narrow)** — real hardware
   support gap for CEC on two boards, not a kernel logic bug.
3. Important issue (crash, security, corruption, deadlock)? **FAIL** —
   CEC absence only; LOW severity.
4. Small and contained? **PASS** — 4 lines, one file.
5. No new features or APIs? **PASS** — no API change; board ID addition
   to existing driver.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception Categories
**Record:** **Hardware identification / quirk exception** — DMI match
table entry for an existing platform driver, analogous to adding
PCI/USB/ACPI IDs. Same category as prior Brask, Moxie, Kinox entries.

### Step 9.4: Decision Rationale

This commit does not fix a critical kernel defect. It enables HDMI CEC
on two new Google Chromebook platforms by extending the existing DMI
whitelist in `cros-ec-cec`. That is standard stable material under the
hardware-identification exception: the driver already exists in 6.18.43,
the change is trivial and low-risk, and it unblocks real hardware for
users on those boards. It does not meet the strict "important bug"
criterion on its own, but stable trees routinely take such board-ID
additions when the driver is already present.

For the locally checked-out **6.18.43** tree: the driver exists, the gap
exists, and the patch applies cleanly.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body: hardware enablement for
  Kulnex/Moxoe CEC; Hans Verkuil SOB; no Fixes/Reported-
  by/Link/Cc:stable
- **[Phase 2]** Diff: +4 lines in `cec_dmi_match_table[]`; probe failure
  path confirmed in source
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232; `make
  kernelversion`: 6.18.43
- **[Phase 3]** `git show ac3fd01e4c1ef:...cros-ec-cec.c`: driver
  present since 6.18-rc7; Moxie present, Kulnex/Moxoe absent
- **[Phase 3]** `grep Kulnex|Moxoe`: no matches in tree
- **[Phase 3]** Git history in this repo is rewritten/unreliable for
  blame; table content verified directly
- **[Phase 4]** `b4 dig -c 4b3f9bff6067a`: failed (commit not in repo)
- **[Phase 4]** Lore fetch: blocked (403/bot protection) —
  **UNVERIFIED** mailing list discussion
- **[Phase 5]** Read `cros_ec_cec_probe()` and
  `cros_ec_cec_find_hdmi_dev()`: confirmed `-ENODEV` path
- **[Phase 5]** `grep cros_ec_cec_find_hdmi_dev`: only called from probe
- **[Phase 6]** File exists at `drivers/media/cec/platform/cros-ec/cros-
  ec-cec.c` (602 lines)
- **[Phase 6]** `git apply --check /tmp/kulnex.patch`: applies cleanly
- **[Phase 6]** `grep Kulnex|Moxoe`: absent from tree
- **[Phase 7]** `CONFIG_CEC_CROS_EC` in
  `drivers/media/cec/platform/Kconfig`; depends on `CROS_EC`
- **[Phase 8]** Failure mode verified: `-ENODEV` + `dev_warn`, not
  oops/panic

**YES**

 drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
index 419b9a7abcceb..4b3f9bff6067a 100644
--- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
+++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
@@ -334,6 +334,10 @@ static const struct cec_dmi_match cec_dmi_match_table[] = {
 	{ "Google", "Dirks", "0000:00:02.0", port_ab_conns },
 	/* Google Moxie */
 	{ "Google", "Moxie", "0000:00:02.0", port_b_conns },
+	/* Google Kulnex */
+	{ "Google", "Kulnex", "0000:00:02.0", port_b_conns },
+	/* Google Moxoe */
+	{ "Google", "Moxoe", "0000:00:02.0", port_b_conns },
 };
 
 static struct device *cros_ec_cec_find_hdmi_dev(struct device *dev,
-- 
2.53.0

