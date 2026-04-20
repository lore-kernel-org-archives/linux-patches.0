Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566A3CFF7F;
	Mon, 20 Apr 2026 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691804; cv=none; b=jNJRHc8U6F+FAGGpVVbqj/qKEyE5i7NxuENiZx14Tt5NjdMJZqhzUvt2DWbYEbnmvIym01x5w4x+9eu5BY9LUnbTfqSXyIkH3tfqpSTiBCXDnnrgaqiC1nRpus3z9N2QGBcLuIykdWyFCU7iv9kmk8C4eVShWEuL8F0VR5m2LSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691804; c=relaxed/simple;
	bh=ghaPincQOs244mgYCMn6MyfnRCF8amLEIfKgGJ2w/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcxXA0hSexUyDtO0LEd183sKsizyjLH8UjaDYZIK1kTlU3GRjMS1ZYc5Q7FG53fdw4mAEQ540bOUYbW0wyn7gruaVOsAYs1BaIx/Y7xnB/vl8Y2NJtwh6H9dm+EEecSs2Fd2PK9Ob1FcmccQKfngITNgFk5Cwtzxtirmn1rpqro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nizKC1yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nizKC1yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B1C2BCC4;
	Mon, 20 Apr 2026 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691804;
	bh=ghaPincQOs244mgYCMn6MyfnRCF8amLEIfKgGJ2w/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nizKC1yLntWxIsPXSubVLO5RN6OTSC0hI35+7T4Jq4LeXVldxyTsLlBaqI4Wd9s/6
	 mXCZR88qqAix65gXdGsFh0A0NKM/RMt7u25lclO55mudiJFcFKF1B+VDkblFLNx6iS
	 66Qw8qLFh8QPPr1LY/GeyTEOW70T57SYjTkJVd4XKjGdGfmf9af2mB0YAD0TPy569d
	 WUdB5zVe/hLW+hLOT+f8VusDFyq0o631bnh5GBnpslttcLBlo5qCV0LYh2nJlBBwus
	 2smwyUgNZm+qhD2RzM+9Wvrxiz5xz0F2pr+k+9dIMiRCd48hr04MdbwxAdvFlJfpII
	 jc95dkD18N97g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= <nfraprado@collabora.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] HID: quirks: Set ALWAYS_POLL for LOGITECH_BOLT_RECEIVER
Date: Mon, 20 Apr 2026 09:19:57 -0400
Message-ID: <20260420132314.1023554-203-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit d4229fc0cb50c52b385538d072c5fc8827b287a9 ]

The Logitech Bolt receiver once connected to a wireless device will
generate data on interface 2. If this data isn't polled, when the USB
port it is connected to gets suspended (and if that happens within 5
minutes of the last input from the wireless device), it will trigger a
remote wakeup 3 seconds later, which will result in a spurious system
wakeup if the port was suspended as part of system sleep.

Set the ALWAYS_POLL quirk for this device to ensure interface 2 is
always polled and this spurious wakeup never happens.

With this change in place the system can be suspended with the receiver
plugged in and the system can be woken up when an input is sent from the
wireless device.

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line Parse**
- Subsystem prefix: `HID: quirks:`
- Action verb: "Set" (adds a quirk entry - this is effectively fixing
  broken hardware behavior)
- Record: HID subsystem; adding `HID_QUIRK_ALWAYS_POLL` for the Logitech
  Bolt Receiver.

**Step 1.2: All Tags**
- `Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>`
  (author)
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID subsystem
  maintainer)
- No Fixes:, no Cc: stable, no Reported-by:, no Link: (expected — that's
  why it needs review)
- Record: Applied by HID maintainer directly; concise author-maintainer
  chain.

**Step 1.3: Body Analysis**
- Bug mechanism: Once a wireless device connects to the Bolt receiver,
  interface 2 generates data. If not polled and the USB port is
  suspended within 5 min of last wireless input, the device triggers a
  remote wakeup 3 seconds later, causing a spurious system wakeup when
  suspended as part of system sleep.
- Symptom: **System spontaneously wakes from suspend** when Bolt
  receiver is attached.
- Author confirms testing: "With this change in place the system can be
  suspended with the receiver plugged in and the system can be woken up
  when an input is sent from the wireless device."
- Record: Real, observed, user-visible issue (spurious wake-from-
  suspend); root cause clearly identified (device emits data on
  interface 2 that triggers remote wakeup).

**Step 1.4: Hidden Bug Fix Detection**
- "Set ALWAYS_POLL" — this is a hardware workaround/quirk. Functionally,
  it is a **bug fix** for buggy hardware behavior that breaks system
  suspend for affected users.
- Record: This is a classic hardware quirk bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `drivers/hid/hid-quirks.c` only, +1/-0 lines.
- Functions: none — adds a single table entry to `hid_quirks[]`.
- Classification: trivial, single-file, surgical quirk table entry.

**Step 2.2: Code Flow**
- Before: device matched only by default HID logic → `usbhid_open()` and
  related code treated it like any normal device (autosuspend-enabled,
  sets `needs_remote_wakeup = 1`).
- After: the quirk flag makes `usbhid/hid-core.c` paths at lines 689,
  752, 756, 1185, 1234 bypass autosuspend/remote wakeup logic —
  `needs_remote_wakeup` stays 0 and interface 2 is always polled.
- Record: exactly the change documented in commit message.

**Step 2.3: Bug Mechanism**
- Category: (h) Hardware workaround / quirk table entry for buggy device
  behavior.
- Mechanism: `HID_QUIRK_ALWAYS_POLL` is an established mechanism used by
  many Logitech, Lenovo, Microsoft, Chicony mice/dongles for exactly
  this kind of problem (preventing spurious wakeups / keeping endpoint
  pollable). The Bolt receiver exhibits the same pattern.

**Step 2.4: Fix Quality**
- Obviously correct: trivial one-line addition to an existing quirk
  table.
- Minimal and surgical: yes.
- Regression risk: essentially zero — the quirk only affects devices
  matching vendor=0x046d, product=0xc548. All other devices are
  untouched.
- Risk introduced by the fix itself: slight extra USB traffic for Bolt
  receiver users (acknowledged by author). This is well within
  acceptable for the quirk behavior that's applied to many devices
  already.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER` define added in commit
  `526748b925185` ("HID: multitouch: Add quirk for Logitech Bolt
  receiver w/ Casa touchpad") — first shipped in **v6.12**.
- Record: buggy hardware behavior exists since device was first
  supported; device ID is present in stable 6.12.y and later.

**Step 3.2: Fixes Tag**
- No Fixes: tag (device behavior is a hardware issue, not a regression
  from a specific commit). Not applicable.

**Step 3.3: File History**
- `drivers/hid/hid-quirks.c` receives quirk additions routinely (VRS
  steering wheel, Cooler Master MM712, Apple keyboards,
  Lenovo/Edifier/etc.). This is the normal pattern.
- Record: no prerequisite patches; standalone one-line addition.

**Step 3.4: Author**
- Author is a Collabora Mediatek/Genio/thermal/kernel developer (regular
  upstream contributor). Applied by HID maintainer Jiri Kosina directly.
- Record: normal maintainer acceptance path.

**Step 3.5: Dependencies**
- Uses `USB_VENDOR_ID_LOGITECH` (long-existing) and
  `USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER` (added in v6.12). No other
  dependencies.
- Record: applies cleanly to any stable tree ≥ 6.12. Older trees (6.6,
  6.1, 5.15, 5.10, 5.4) do not have the device ID define; backport would
  need the `hid-ids.h` define too — likely not worth doing given the
  device ID was added in 6.12.

## PHASE 4: MAILING LIST

**Step 4.1: Original thread**
- `b4 dig -c d4229fc0cb50c` → https://lore.kernel.org/all/20260407-logi-
  bolt-hid-quirk-always-poll-v1-1-4dae0fda344e@collabora.com/
- Single revision (v1). Applied as submitted.

**Step 4.2: Reviewers**
- Thread saved to mbox. Jiri Kosina (HID maintainer, `jikos@kernel.org`)
  replied: "In the meantime, I am applying this one. Thanks,"
- Author proposed possible future improvement (a "poll-before-suspend
  only" quirk) but Jiri didn't object to the current approach.
- Recipients: Jiri Kosina, Benjamin Tissoires, linux-
  input@vger.kernel.org, linux-kernel@vger.kernel.org,
  kernel@collabora.com.
- Record: patch reviewed and applied by the subsystem maintainer with no
  objections; no stable nomination request was made but also no concerns
  raised.

**Step 4.3: Bug Report**
- No Link: tag, but commit message and author's reply indicate this is a
  directly-observed reproducible issue.

**Step 4.4: Series context**
- `b4 dig -a`: only v1 exists. Standalone single patch.

**Step 4.5: Stable discussion**
- None found in thread.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
- None. Adds one table entry to `hid_quirks[]` consumed by
  `usbhid_exists_squirk()` / `hid_lookup_quirk()`.

**Step 5.2: Callers of quirk**
- `drivers/hid/usbhid/hid-core.c`: lines 689, 752, 756, 1185, 1234 all
  check `HID_QUIRK_ALWAYS_POLL` and branch accordingly in `usbhid_open`,
  `usbhid_close`, `usbhid_start`, `usbhid_stop` (standard HID USB device
  lifecycle).
- Record: well-established, widely-used quirk path.

**Step 5.3: Callees**
- N/A — this is a data table entry.

**Step 5.4: Reachability**
- Reached for any system with the Bolt receiver plugged in during device
  enumeration — every affected user.

**Step 5.5: Similar patterns**
- Many similar quirk additions in same file (Apple keyboard
  c55092187d9ad, Dell KM5221W 62cc9c3cb3ec1, VRS R295 1141ed52348d3,
  Cooler Master MM712 0be4253bf878d, Lenovo PixArt mice, etc.). This is
  a recurring, well-accepted pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code exists in stable?**
- The device ID `USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER = 0xc548` is in
  stable 6.12.y and later (added by commit 526748b925185 before v6.12).
- The `hid_quirks[]` table exists in all stable trees.
- Record: backport applicable to 6.12.y, 6.13.y, 6.14.y, 6.15.y (current
  active trees that carry the define). Not applicable to older LTS
  (6.6.y, 6.1.y, 5.15.y, 5.10.y) unless the device ID define is
  backported along.

**Step 6.2: Backport complications**
- Mainline hunk context includes neighboring entries added later (8BitDo
  Pro 3, Edifier QR30). Fuzz/minor context adjustment likely sufficient;
  any stable tree with the `LOGITECH_BOLT_RECEIVER` define will accept
  this addition trivially — the surrounding entries have been stable for
  years.
- Record: clean apply with possibly trivial fuzz on older-than-mainline
  stable.

**Step 6.3: Related fixes in stable?**
- None found.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/hid/` — device drivers (HID, USB input).
- Criticality: IMPORTANT — keyboards, mice, and wireless receivers are
  common desktop/laptop hardware. Suspend/resume breakage affects user-
  visible laptop power management.

**Step 7.2: Activity**
- Very active file; routine quirk additions merged frequently.

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected users**
- Owners of Logitech Bolt receivers (a fairly popular wireless receiver
  used with Logitech MX-family peripherals and modern wireless
  keyboards/mice) who suspend their systems.

**Step 8.2: Trigger**
- Occurs every system suspend within 5 minutes of wireless input
  activity. Very easy to trigger on any laptop using this receiver.

**Step 8.3: Severity**
- Failure mode: **spurious wake-from-suspend** → battery drain, system
  not actually suspending, potential data/security exposure on machines
  users thought were asleep. Severity: **MEDIUM-HIGH** (not a crash, but
  a serious user-visible regression of the suspend feature; affects
  laptop battery life and sleep reliability).

**Step 8.4: Risk-benefit**
- Benefit: clear, reproducible user-facing fix for laptop suspend/resume
  with a common wireless receiver.
- Risk: one-line table entry for a specific (vendor,product) tuple;
  cannot affect other devices. Extra URB polling for the one device —
  the same trade-off accepted for dozens of similar quirks. Very low
  risk.
- Record: benefit >> risk.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: one-line surgical quirk; applied by HID maintainer; established
  pattern (dozens of similar entries); fixes real user-visible suspend
  misbehavior; author tested both suspend and wakeup paths.
- AGAINST: none material. Adds a tiny bit of USB traffic for the one
  device (acknowledged).
- Unresolved: backport to pre-6.12 trees would additionally need the
  `hid-ids.h` define from commit 526748b925185 — but active stable trees
  (6.12.y+) already contain it.

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? **YES** — matches existing pattern, maintainer-
   applied.
2. Fixes real bug affecting users? **YES** — spurious wake from suspend.
3. Important issue? **YES** — suspend/resume reliability on common
   hardware.
4. Small and contained? **YES** — 1 line, 1 file.
5. No new features/APIs? **YES** — quirk entry only.
6. Applies to stable? **YES** — for trees containing the device ID
   define (v6.12+).

**Step 9.3: Exception Category**
- Fits the explicit "QUIRKS and WORKAROUNDS" exception and "NEW DEVICE
  IDs / device-specific quirks to existing drivers" exception in stable
  rules.

**Step 9.4: Decision**
- This is a textbook stable candidate: a minimal, targeted hardware
  quirk that fixes a reproducible suspend issue for a common piece of
  hardware, applied by the subsystem maintainer, matching dozens of
  prior similar backported quirks.

## Verification

- [Phase 1] Parsed commit message: confirmed no
  Fixes/Cc:stable/Link/Reported-by; two Signed-off-bys (author + HID
  maintainer Jiri Kosina).
- [Phase 2] Diff inspection: verified the change is exactly `+1` line in
  `drivers/hid/hid-quirks.c` adding a `HID_QUIRK_ALWAYS_POLL` entry for
  `USB_VENDOR_ID_LOGITECH`/`USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER`.
- [Phase 2] Confirmed quirk semantics via `drivers/hid/usbhid/hid-
  core.c` lines 689, 752, 756, 1185, 1234 — flag bypasses
  autosuspend/remote-wakeup paths.
- [Phase 2] Verified `HID_QUIRK_ALWAYS_POLL = BIT(10)` in
  `include/linux/hid.h:406`.
- [Phase 3] `git log` on `drivers/hid/hid-quirks.c` + `rg
  USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER` → identified define introduced
  in commit `526748b925185`.
- [Phase 3] `git tag --contains 526748b925185` → device ID first shipped
  in v6.12.
- [Phase 3] `git log --oneline --grep="ALWAYS_POLL"` → verified many
  similar one-line quirk additions historically.
- [Phase 4] `b4 dig -c d4229fc0cb50c` → found original thread at
  lore.kernel.org/all/20260407-logi-bolt-hid-quirk-always-
  poll-v1-1-4dae0fda344e@collabora.com/.
- [Phase 4] `b4 dig -a` → single v1, applied as-is.
- [Phase 4] `b4 dig -m /tmp/bolt-thread.mbx` → read full thread: Jiri
  Kosina (HID maintainer) applied the patch; author confirmed testing;
  no NAKs.
- [Phase 5] Confirmed `hid_quirks[]` entries are consumed by the
  standard USB HID core paths — impact scope is exactly the one matched
  device.
- [Phase 6] Device ID present in mainline and 6.12.y+ stable branches.
- [Phase 7] `drivers/hid/` is IMPORTANT subsystem — affects HID input on
  desktops/laptops.
- [Phase 8] Failure mode: spurious system wake from suspend, confirmed
  by commit message text.
- UNVERIFIED: I did not check every LTS stable tree file-by-file for
  divergent context around the insertion point, but given this is a
  sorted alphabetical table and the neighboring Logitech entries
  (`LOGITECH_C007`, `LOGITECH_C077`, `LOGITECH_KEYBOARD_G710_PLUS`) have
  been present for many years, a clean backport is essentially
  guaranteed for 6.12+ trees.

Single-line hardware quirk entry that fixes a real, reproducible
suspend/wakeup bug affecting owners of the Logitech Bolt receiver.
Matches the "quirks and workarounds" stable exception exactly, is
maintainer-applied, carries negligible regression risk, and applies
cleanly to stable trees that carry the device ID (v6.12+).

**YES**

 drivers/hid/hid-quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 02f7db5c10564..eb811b1fb80f9 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -134,6 +134,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6093), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C007), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_C077), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KEYBOARD_G710_PLUS), HID_QUIRK_NOGET },
-- 
2.53.0

