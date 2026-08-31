Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFC449B20D;
	Mon, 31 Aug 2026 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183578; cv=none; b=gvzIeUoHh1OlvdiYhS26QXq4zMzp95W207Fl6EN2F02ZkENM5NtV/ruumtcUNR8EAMYNkm/qoqj8nswRU+T8UVgf+RkZmAjDSXbO6ao8DE9ljqYwfK6xQ7X2NRWZzaDEwoS5Fmc0Y3QlNMoramIYhp/TW5SE/EOrWw4WdHNuGLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183578; c=relaxed/simple;
	bh=+x+WQGieINmiuhSwbwuIopqWzBCVkCm65GxhgE+kCZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDJLleEEmDhfRuazhikkO2350lqC+tzKjM5A/hvWGCpxim4krYiP6jLKtqJavoR/XWqvDL2vOjjdEdsVWrWCK4Qnjmrn7vfkNbZVVLTfzERNqzGIi1FOs/Uig9SAKZ2wNlicaCCwb0/XAgJVkctNWY9YSTXNlcYNy3QcY6Bqo88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aws54kfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aws54kfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228371F00A3D;
	Mon, 31 Aug 2026 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183576;
	bh=Kv1rJF0WAF0FzD6fLDXCRJ7knt7swoLytU43o0uKw3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aws54kfo9NU1A8lUG+FbHzDNnUF/+ONsnQFO8AJvHWlRWKweXOF5mKQIKXW9njbay
	 N0pXV1o69rLEr36MKtfHMQHOPUgu/FfcUQvKwayypfr9/I5nCv1YHMXLCtL+pshV2I
	 yCgomWRoWXFKJUiVdorYn9SPkSFJLLCRWkFBPnSwHoC9JBvq/kgNIWvkvJv9IgZ16N
	 4cQHUjQRxyWSKx/zZz+g6Ek/iXr4oHsszunk5gL3gDyEC+FCoToDOqXysxOJtH+0yB
	 i4HupPYK4jabeLdif+7iVOl8k21NkDn9fxJl+0xhAJlGDUyDDd2HorMiAxp8I36h8y
	 JI052iFqJK3Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: rc: mceusb: Add support for 04eb:e033
Date: Mon, 31 Aug 2026 09:23:26 -0400
Message-ID: <20260831133314.4125787-178-sashal@kernel.org>
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

From: Riccardo Boninsegna <rboninsegna2@gmail.com>

[ Upstream commit 0692c2602e4cd410aa045f8991bd1c142b2e56f9 ]

This is a Sonix SN8P2202XG microcontroller with firmware compatible with
the already supported Northstar 04eb:e004, implementing an MCE IR receiver
(PCB seems to be tracked for a transmitter too but missing related parts).

Found in a Skintek SK-CR-IN+IR ( http://www.skintek.it/SK-CR-IN+IR.php )
internal 3.5 inch USB card reader and MCE receiver combo
(implemented by, and wired as, separate USB devices)
PCB marking: AU6475 966816 STIR REV:A02 MCE

Signed-off-by: Riccardo Boninsegna <rboninsegna2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[media: rc: mceusb]` `[Add]` `USB device ID 04eb:e033 to
the existing mceusb IR transceiver driver`

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none (hardware product page in body only:
  http://www.skintek.it/SK-CR-IN+IR.php)
- **Cc: stable@vger.kernel.org:** none (expected; not a negative signal)
- **Signed-off-by:** Riccardo Boninsegna `<rboninsegna2@gmail.com>`
  (author)
- **Signed-off-by:** Sean Young `<sean@mess.org>` (media/rc maintainer
  co-signer — quality signal)

**Notable patterns:** Maintainer Signed-off-by; no syzbot/sanitizer
reports; hardware-specific enablement patch.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug described:** USB device `04eb:e033` (Sonix SN8P2202XG,
  Northstar-variant MCE IR receiver) is not recognized by `mceusb`
  because its product ID is missing from `mceusb_dev_table[]`.
- **Symptom:** IR receiver on Skintek SK-CR-IN+IR internal card reader
  does not bind to `mceusb`; remote control input unavailable.
- **Version info:** none stated.
- **Root cause (author):** Firmware-compatible variant of already-
  supported `04eb:e004`; only the USB product ID differs.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not a crash/leak/race fix. This is explicit **hardware
enablement** via a missing USB ID — a recognized stable exception
category, not a disguised memory-safety fix.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/media/rc/mceusb.c` only (+2 lines net in the ID
  table)
- **Functions modified:** none (only `mceusb_dev_table[]` static data)
- **Scope:** single-file, surgical USB ID table addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** USB probe matches `04eb:e004` only for Northstar vendor;
  `04eb:e033` does not match → no `mceusb` bind.
- **After:** `04eb:e033` matches the same way as `04eb:e004` →
  `mceusb_dev_probe()` runs on plug-in.
- **Path affected:** USB hotplug / enumeration normal path for this
  device class.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** hardware workarounds / device ID addition
- **Mechanism:** Missing `USB_DEVICE(VENDOR_NORTHSTAR, 0xe033)` entry
  prevents driver binding. No `.driver_info` is set, so
  `id->driver_info` defaults to `0` (`MCE_GEN2`) — identical to the
  existing `0xe004` entry.

### Step 2.4: Fix Quality Assessment
**Record:**
- **Obviously correct:** yes — mirrors the adjacent `0xe004` entry;
  author documents firmware compatibility.
- **Minimal:** 2 lines.
- **Regression risk:** very low — only adds a new match; does not change
  probe logic, locking, or APIs.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** In this checkout (`6.18.43`), `VENDOR_NORTHSTAR` / `0xe004`
are at lines 160 and 399. The `0xe033` entry is **not** present. The
Northstar `0xe004` entry exists in `stable/linux-6.18.y`. This tree’s
history is heavily squashed (many `mceusb.c` lines blame to unrelated
commits), so the original introduction commit of `0xe004` could not be
reliably dated here.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History for Related Changes
**Record:** Recent `drivers/media/rc/` stable commits include real bug
fixes (`e250b672d40a9` race fix, probe error-handling fixes), but no
prior `0xe033` addition. On `origin/master`, `0xe033` is already
present; on current HEAD it is not.

### Step 3.4: Author's Other Commits
**Record:** No commits from Riccardo Boninsegna found in this tree’s
history. Sean Young is the media/rc maintainer (Signed-off-by).

### Step 3.5: Dependent/Prerequisite Commits
**Record:** **No dependencies.** Requires only existing
`VENDOR_NORTHSTAR` define and `mceusb` driver — both present in
`6.18.y`. Standalone 2-line backport.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig` could not be run — individual commit SHA not
available in this mirror (history squashed into merge commits).
`lore.kernel.org` returned **403 Forbidden**. `git.kernel.org` grep
confirmed subject `mceusb: Add support for 04eb:e033` exists on
mainline. Patchwork search returned only generic page scaffolding, no
detailed review thread retrieved.

### Step 4.2: Reviewers
**Record:** UNVERIFIED for mailing-list CC list. Sean Young (maintainer)
Signed-off-by in commit message.

### Step 4.3: Bug Report
**Record:** No formal bug report or syzbot link. Hardware identification
from author on Skintek SK-CR-IN+IR product.

### Step 4.4: Related Patches/Series
**Record:** Standalone 1-commit change; not part of a multi-patch
series.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — lore stable list inaccessible (403).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** No functions modified. Affected data: `mceusb_dev_table[]`.
Probe path: `mceusb_dev_probe()`.

### Step 5.2: Trace Callers
**Record:** `mceusb_dev_probe()` is registered as `.probe` in
`mceusb_dev_driver` and invoked by the USB core during device
enumeration when `usb_device_id` matches. Trigger: user plugs in the IR
receiver.

### Step 5.3: Trace Callees
**Record:** On successful match, probe allocates `mceusb_dev`, sets up
URBs, registers with `rc-core` — standard existing driver path unchanged
by this patch.

### Step 5.4: Call Chain / Reachability
**Record:** USB hotplug → `usb_driver.probe` → `mceusb_dev_probe()`.
Reachable by any user plugging in the device. Without the ID, the chain
never starts for `04eb:e033`.

### Step 5.5: Similar Patterns
**Record:** `0xe004` at line 399 uses the same pattern (no
`.driver_info`). Many other entries in `mceusb_dev_table[]` follow this
model.

---

## Phase 6: Cross-Referencing Against Local Tree

**Local tree:** `v6.18.43` (`VERSION=6`, `PATCHLEVEL=18`,
`SUBLEVEL=43`), detached from `stable/linux-6.18.y`.

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** `drivers/media/rc/mceusb.c` exists with
`VENDOR_NORTHSTAR` (`0x04eb`) and `0xe004`, but **without** `0xe033`.
The omission is present in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` on the provided diff
succeeded with no conflicts. Insertion point is immediately after the
existing Northstar `0xe004` entry.

### Step 6.3: Related Fixes Already Present?
**Record:** No existing `0xe033` entry or equivalent fix found in HEAD
or `stable/linux-6.18.y` grep.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/media/rc/` — **PERIPHERAL** (USB IR remote
receiver). Not core kernel path, but affects real users with this
hardware.

### Step 7.2: Subsystem Activity
**Record:** `drivers/media/rc/` on `stable/linux-6.18.y` has recent
maintenance (race fixes, probe error handling), indicating active stable
care for this subsystem.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of the Skintek SK-CR-IN+IR (and any other product
using `04eb:e033` with MCE-compatible firmware). Config-dependent:
`CONFIG_IR_MCEUSB` (or module `mceusb`).

### Step 8.2: Trigger Conditions
**Record:** Plug in the `04eb:e033` USB IR device. Common for intended
hardware use. Unprivileged user can trigger by plugging in USB device.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: device does not bind to `mceusb` → IR remote
control non-functional. **Severity: LOW** (functional/hardware
enablement, not crash/corruption/security).

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Enables a real, tested hardware variant; identical
  treatment to already-supported sibling ID.
- **Risk:** Very low — 2-line ID table addition, no logic change.
- **Ratio:** Strong benefit for affected users, negligible risk —
  classic stable device-ID backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compile

**FOR backport:**
- Explicit stable exception: **new USB device ID** to existing driver
- Driver and sibling ID (`04eb:e004`) already in `6.18.y`
- Author documents firmware compatibility with supported device
- Maintainer Signed-off-by (Sean Young)
- 2-line, obviously correct, applies cleanly
- Already in mainline (`origin/master` has `0xe033`)
- No dependencies or API changes

**AGAINST backport:**
- Niche hardware (limited user base)
- Not a crash/security/corruption fix under strict reading of criterion
  #3
- No formal regression report or syzbot evidence
- Mailing-list review not fully verified (lore 403)

**UNRESOLVED:**
- Individual mainline commit SHA and full lore review thread
- Whether stable maintainers already discussed/nominated this specific
  ID

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** **PASS** — mirrors existing
   `0xe004`; maintainer SOB; mainline inclusion.
2. **Fixes a real bug affecting users?** **PASS** — hardware does not
   work without driver binding.
3. **Important issue?** **PASS** (via device-ID exception) — functional
   hardware enablement for affected users; not crash-level, but
   explicitly covered by stable device-ID policy.
4. **Small and contained?** **PASS** — 2 lines, one file.
5. **No new features or APIs?** **PASS** — ID table only.
6. **Can apply to local tree?** **PASS** — verified with `git apply
   --check`.

### Step 9.3: Exception Category
**Record:** **NEW DEVICE IDs** — USB product ID addition to existing
`mceusb` driver. Driver exists; only the ID is new.

### Step 9.4: Decision Rationale
For **Linux 6.18.y** specifically: the `mceusb` driver is present, the
compatible sibling ID `04eb:e004` is already supported, and the missing
`04eb:e033` entry prevents a firmware-compatible variant from working.
This is a textbook, low-risk stable backport under the device-ID
exception.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-by/Link
  tags; Sean Young SOB confirmed.
- **[Phase 2]** Diff: +2 lines in `mceusb_dev_table[]`; no
  `.driver_info` → default `MCE_GEN2` (same as `0xe004`).
- **[Phase 3]** `git describe HEAD`: `v6.18.43`; `git blame`/`grep`:
  `0xe004` present, `0xe033` absent on HEAD.
- **[Phase 3]** `git grep "0xe033" origin/master --
  drivers/media/rc/mceusb.c`: present on mainline.
- **[Phase 3]** `git diff HEAD origin/master --
  drivers/media/rc/mceusb.c`: e033 addition is isolated 2-line hunk.
- **[Phase 3]** No prerequisite commits identified.
- **[Phase 4]** `b4 dig`: **UNVERIFIED** — commit SHA unavailable in
  squashed mirror.
- **[Phase 4]** lore.kernel.org: **403 Forbidden**.
- **[Phase 4]** git.kernel.org grep: subject `mceusb: Add support for
  04eb:e033` confirmed on mainline.
- **[Phase 4]** Patchwork: no detailed review thread retrieved.
- **[Phase 5]** `mceusb_dev_probe()` at line 1651; `.probe` in
  `mceusb_dev_driver` at line 1877.
- **[Phase 5]** Default model `MCE_GEN2` confirmed in `mceusb_model[]`
  at index 0.
- **[Phase 6]** `make kernelversion` equivalent: 6.18.43; tree is
  `stable/linux-6.18.y`.
- **[Phase 6]** `git apply --check` on provided diff: **succeeds**.
- **[Phase 6]** `CONFIG_IR_MCEUSB` exists in `drivers/media/rc/Kconfig`.
- **[Phase 8]** Failure mode: no driver bind → IR non-functional;
  severity LOW; risk VERY LOW.

**YES**The background kernel.org lookups finished:

- **Git grep** confirmed mainline has a commit titled `mceusb: Add
  support for 04eb:e033`.
- **Commit hash lookup** did not return a usable SHA for that patch
  (only unrelated HEAD patch metadata), so `b4 dig` and lore review stay
  unverified.

That does not change the earlier conclusion for **6.18.y**: this is a
small USB device-ID addition to an existing driver, it applies cleanly
next to the already-supported `04eb:e004` entry, and it should be
backported.

**YES**

 drivers/media/rc/mceusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a4c94fdf767ca..bee5cd15796fb 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -397,6 +397,8 @@ static const struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_COMPRO, 0x3082) },
 	/* Northstar Systems, Inc. eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
+	/* Northstar Systems, Inc. eHome Infrared Transceiver - variant */
+	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe033) },
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000),
 	  .driver_info = TIVO_KIT },
-- 
2.53.0

