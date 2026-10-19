Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE06952F98C;
	Mon, 19 Oct 2026 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418627; cv=none; b=iSdILONE9ZDdWGZsPNRXq4GeesEFVuVUhf1CDRtk/VgdT4RKrTujc3sPlYpueCQ3ut93M+VyJP6wPiDfwAkVBiNo9l4qwiIkFgHg72UjGg3XEarQH5EWqhIJ94Zo2GApIC55Hwbxngx9YvLwDzc95XJ8M0nPEwMf4xr57voc188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418627; c=relaxed/simple;
	bh=/HUmepZXYq4t+d03pMQ63ydvjgfse49Qw9AkoESUZj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOoIMMJlIuvs7IA+/o5cG2mKDroJ5cFpHldzbBTxGbHaOAq3feIGjB3AOcJ/XMzpr3pcoF6BNN9YQSmNRFbP4BeJmYzqXlPBHg2CiMc8d9gdmclLGJsfGjrXNp3tT3GpwP70JiRfS1eNVq974+ZNK4eUmGB/OFnaSwNd+w9NVLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eR82vohB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR82vohB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5691F000C9;
	Mon, 19 Oct 2026 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418624;
	bh=TY9yFAc9CnAGBHMFROU8LJaf2xVUG2G4I4/+5crIfrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR82vohBcNNefBvpqIVqn1UOhaB6nl5KTG79dWFxirBA08dQ3g/NJruHkbJkqKwqB
	 0LHiby5zprMkRJHJtYI9Rts5jQt+mESexNWpQ1B2UtwcIxjFimO6KzqnKxT4why0ro
	 8xd8nfCh5ADu+cfIIYQf28Mc9nHGAFx3gLxt6s9Ok6apiVAX7x3I5Q9F8wWfDGZEcy
	 28es7hHjbuWT+JbMqau3ApQ4P/gJ0QXymyul6kIct9n7n3qQaFqd8lu0+s3QlRcFnU
	 5dmqv9DIbzFt028schKiagu8YQT/NFLii7IbR7hVvkBeb/XWgYmILyxTjdLkk201By
	 t2rSFz8e0/mkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] HID: logitech-hidpp: Add support for G502 X Plus USB mouse
Date: Mon, 19 Oct 2026 09:51:12 -0400
Message-ID: <20261019135441.1420968-381-sashal@kernel.org>
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

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

[ Upstream commit 6f4b44abe4ccdcfdab75c9493b8c7634fee37133 ]

The wireless dongle is already supported, this adds detection for
the mouse in wired mode. Supports battery reporting.

Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **pending-5.15** (kernel **5.15.221**). This is a
two-line USB ID addition to an existing HID++ driver, which stable rules
explicitly allow.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[HID / logitech-hidpp] [Add] [USB detection for G502 X Plus
wired mouse]**

**Step 1.2: Tags**
Record:
- Signed-off-by: Stuart Hayhurst \<stuart.a.hayhurst@gmail.com\>
  (author)
- Reviewed-by: Bastien Nocera \<hadess@hadess.net\> (HID++ reviewer)
- Signed-off-by: Jiri Kosina \<jkosina@suse.com\> (HID maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Link:
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB if present

**Step 1.3: Body**
Record: [Bug/gap: G502 X Plus is detected on the Lightspeed dongle but
not when plugged in over USB.] [Symptom: no HID++ binding in wired mode,
so no kernel battery reporting.] [No version range in the message.]
[Root cause: missing `HID_USB_DEVICE(..., 0xC095)` in
`hidpp_devices[]`.]

**Step 1.4: Hidden bug fix?**
Record: Not a disguised leak/race fix. It is a **new device ID** for
existing driver code.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `drivers/hid/hid-logitech-hidpp.c` only; **+2 / -0**. Function:
`hidpp_devices[]` ID table. Scope: single-file surgical ID add.

**Step 2.2: Code flow**
Record: Before: USB `046d:c095` is not matched by logitech-hidpp and is
handled by hid-generic (mouse works; no HID++ battery). After:
`hidpp_probe()` binds with `driver_data = 0` (same as G403/G703/G903 USB
entries). Path: device enumeration / probe, not an error path.

**Step 2.3: Bug mechanism**
Record: **Hardware ID / quirk table (h).** Missing product ID; adding
`HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC095)`.

**Step 2.4: Fix quality**
Record: Obviously correct; matches neighboring Lightspeed USB mice. No
API, locking, or structure change. Regression risk is low; the 2019 G502
revert was for **different** PIDs (Hero/Proteus 0xC07D/0xC332/0xC08B),
not this Lightspeed X device.

## Phase 3: Git history

**Step 3.1: Blame**
Record: USB HID++ IDs in this tree come from `91cf9a98ae4127` (2019) and
`27fc32fd941796` (2019), plus G915 TKL `fd41646d43504` (backported
2023). Table has been stable for years.

**Step 3.2: Fixes: tag**
Record: None. This does not revert a bug-introducing commit; it adds an
ID.

**Step 3.3: Related file history**
Record: Related mainline IDs: `a343a7682acc5` (G502 Lightspeed 0xC08D,
2023) and `fce551616dfa4` (G502 X Lightspeed 0xC098, 2026). Neither is
in this tree. Not a numbered series; standalone v1. Same-author
companion `456d506b6041d` (duplicate G703 ID) is unrelated cleanup.

**Step 3.4: Author**
Record: Stuart Hayhurst is a regular HID++ ID contributor. Same
author/reviewer pair already landed G915 TKL IDs in **this** 5.15 tree
(`fd41646d43504`).

**Step 3.5: Dependencies**
Record: No new helpers. Needs existing `hidpp_devices[]` /
`HID_USB_DEVICE` / battery init. Unified Battery 0x1004
(`e037acf0b1aed`) **is** an ancestor of this tree. G502 Lightspeed
0xC08D is only nearby context, not a functional prerequisite.
Standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 6f4b44abe4ccd` → https://patch.msgid.link/20260721171
246.461232-5-stuart.a.hayhurst@gmail.com
`b4 dig -a`: **v1 only**. Thread: Bastien `Reviewed-by`; Jiri “Applied,
thanks.” No NAK, no stable concern.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Jiri Kosina, Benjamin Tissoires, Bastien Nocera, Filipe Laíns,
linux-input, linux-kernel.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Author describes wired detection + battery.
Libratbag also lists G502 X Plus wired 0xC095 (external confirmation of
the PID).

**Step 4.4: Series**
Record: Subject is `[PATCH]`, not `X/Y`. Later G502 X Lightspeed ID
(`fce551616dfa4`) is a separate author/date.

**Step 4.5: stable@**
Record: lore.kernel.org WebFetch returned 403. UNVERIFIED on stable@
archives. `Documentation/process/stable-kernel-rules.rst` line 24: “New
device IDs and quirks are also accepted.”

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `hidpp_devices[]` only. Consumed by `hidpp_driver.id_table` →
`hidpp_probe()`.

**Step 5.2: Callers**
Record: HID core match → `hidpp_probe()` → `hidpp_connect_event()` →
`hidpp_initialize_battery()`. Userspace-visible on USB plug-in.

**Step 5.3: Callees**
Record: Unchanged. Battery path already tries 0x1000, then 0x1004, then
0x1001.

**Step 5.4: Reachability**
Record: Yes, from plugging the mouse in over USB. Unprivileged physical
access; not a syscall fuzzer path.

**Step 5.5: Similar patterns**
Record: Same pattern as G403/G703/G903 USB IDs already here, and G915
TKL already backported here.

## Phase 6: This tree (5.15.221)

**Step 6.1: Does the gap exist?**
Record: Yes. `hidpp_devices[]` around `drivers/hid/hid-logitech-
hidpp.c:4354` has G403 `0xC082` then G703 `0xC087`. **No `0xC095`.**
`git merge-base --is-ancestor 6f4b44abe4ccd HEAD` → not ancestor.
Wireless still covered by `LDJ_DEVICE(HID_ANY_ID)` at line 4338.

**Step 6.2: Backport difficulty**
Record: **Minor context tweak.** Upstream hunk sits after G502
Lightspeed `0xC08D`, which is not in 5.15. Insert after G403 / before
G703. Two lines.

**Step 6.3: Related fixes already here?**
Record: No `0xC095`. G915 TKL IDs are present (same class of HID++ ID
add). Unified Battery is present.

## Phase 7: Subsystem

**Step 7.1:** Record: **HID / logitech-hidpp**. Criticality:
**IMPORTANT** (common USB HID, not core mm/net).
`CONFIG_HID_LOGITECH_HIDPP`.

**Step 7.2:** Record: Mature driver; ID table is the usual extension
point. Still receiving stable HID++ fixes on this branch.

## Phase 8: Impact / risk

**Step 8.1:** Record: **driver-specific / hardware-specific** — Logitech
G502 X Plus in **wired USB** mode.

**Step 8.2:** Record: Trigger = plug in with cable. Common for
charging/wired use. Not remotely triggerable.

**Step 8.3:** Record: Without the ID, generic HID still moves the
cursor. With the ID, HID++ battery sysfs works. Severity **MEDIUM** as a
bug, but this is the **device-ID exception**, not a crash fix.

**Step 8.4:** Record: Benefit: battery/HID++ for a shipping 2022 mouse
on 5.15 LTS. Risk: very low (2 lines, no quirks). Same shape as G915 TKL
already on this tree. Ratio: **favorable**.

## Phase 9: Synthesis

**Evidence FOR**
- Stable rules explicitly accept new device IDs (`stable-kernel-
  rules.rst`).
- Driver and battery stack (including 0x1004) exist in 5.15.221.
- +2 lines, no new API, no quirks.
- Reviewed by Bastien Nocera; applied by Jiri Kosina.
- Precedent on this tree: G915 TKL USB/BT IDs (`fd41646d43504`), same
  author, same “battery on top of hid-generic” rationale.
- 0xC095 is unused by other HID drivers here.

**Evidence AGAINST**
- Not a crash/UAF/security fix; mouse already works via hid-generic.
- 2019 G502 USB IDs were reverted for timeouts — **different PIDs**.
- Hunk context needs a tiny edit because 0xC08D is missing.

**Unresolved**
- Could not fetch lore/stable HTML (403). Thread recovered via `b4`
  mbox.
- Did not physically test a G502 X Plus on 5.15.

**Stable rules checklist**
1. Obviously correct and tested? **PASS** (trivial ID; author + HID++
   reviewer).
2. Fixes a real user-visible gap? **PASS** (wired HID++/battery).
3. Important? **PASS** under the device-ID exception (not a panic).
4. Small and contained? **PASS** (+2 lines, one table).
5. No new features/APIs? **PASS** (existing probe/battery only).
6. Applies to this tree? **PASS** with trivial context adjust.

**Exception category:** New USB device ID on an existing driver.

This belongs on 5.15.y: the hardware is real, the driver already handles
this class of Lightspeed USB mice, and the change is the same kind of ID
add this tree has already taken.

Verification:
- [Phase 1] Tags: author SOB, Bastien Reviewed-by, Jiri SOB; no Fixes/Cc
  stable
- [Phase 2] Diff: +2 lines in `hidpp_devices[]`, USB 0xC095, no quirks
- [Phase 3] Mainline SHA `6f4b44abe4ccdcfdab75c9493b8c7634fee37133`; not
  ancestor of HEAD
- [Phase 3] Unified Battery `e037acf0b1aed` **is** ancestor of HEAD
- [Phase 3] G502 Lightspeed `a343a7682acc5` is **not** in this tree
  (context only)
- [Phase 4] `b4 dig -c 6f4b44abe4ccd`: lore match; v1 only; Reviewed-by
  + Applied
- [Phase 4] WebFetch lore/stable: 403; thread read from
  `/tmp/g502xplus.mbox`
- [Phase 5] ID table → `hidpp_probe` → `hidpp_initialize_battery`
  (0x1000/1004/1001)
- [Phase 6] `git describe HEAD`: p-5.15-2-g9a29d9b0f9507; `make
  kernelversion`: 5.15.221; branch pending-5.15
- [Phase 6] No 0xC095 in `hidpp_devices[]`; `LDJ_DEVICE(HID_ANY_ID)`
  present
- [Phase 6] G915 TKL IDs already backported here (`fd41646d43504`)
- [Phase 7] `CONFIG_HID_LOGITECH_HIDPP`; Kconfig selects POWER_SUPPLY
- [Phase 8] Failure mode: missing HID++/battery in wired mode, not oops
- UNVERIFIED: stable@ archive search (HTTP 403); no hardware test on
  5.15

**YES**

 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index a2bb7d8b15b69..a931713a9cb69 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4615,6 +4615,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
 	{ /* Logitech G502 Lightspeed Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08D) },
+	{ /* Logitech G502 X Plus Wireless Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC095) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */
-- 
2.53.0

