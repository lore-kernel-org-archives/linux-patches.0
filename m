Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C756592214;
	Mon, 31 Aug 2026 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184262; cv=none; b=pms/sfi7O6Ocaab08TGUYqeEyZ+ut0dA0Q76o/ByTlVMt5buPjaZT304hoqEycE9oVE86GBX47UfDpGMETjHd3UMUeUxhnKKYmFJhu+DqB5Q6ONAg5ag+dIC68gMIGIQvx4iJR2vankfryXtN3KJIN5CmKNsgIGXf9W0Ie2IeR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184262; c=relaxed/simple;
	bh=oQ711CS7bu5fPtfZe9FQvoMnU2ysPqtcJaYehIlZW18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qd6ZxVpLw9y0GbBYJvw8PH2k/BGkJl6x+npTlOe8gJgCySHm0clukxlaplmmA2Tf1AdF5g2MKbWkZiy0wvlJALTogczwxxAWvrI+hHsyjPrbVMBNqaPcf47n+F4lNNp0GIwqbQ6ZMKCAEwcaaNhU5ZBv319MhUF6Cf4SeeyOZGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeAOi8zI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeAOi8zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1B81F00A3F;
	Mon, 31 Aug 2026 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184260;
	bh=Xrd25d3lSl0keEIk+M1xGehTLksJ1UefujdL9tdsESM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeAOi8zIR8PMmmlM8j5GEsrEtFPSrho/N0VZD0UtBwGSD8OkKojVwJOPlMuU2+78T
	 Njz9fHwzgFZbywQUtnJD1f7pPqOjWHAgNXDoRPUeZRy19mZZJlY4cX4gIGEMwzQpEM
	 xDU7F6Ioi3hAu9GX2dJv6WrVNHlRkJnDxQajJ/Zd4FuZ6U3PFZgJEZwDKMEqbgQcd6
	 HX/CIZswZeid8msqD/SYv60SjOYBZdJCMAjZBzqwyMDFwqjMPoDM9r0oCGOoXYvnHa
	 3ujyXyXMi/67XH3F1xdAJ8cpCyOH3Enp4AyduBfAlpg0VJ7paPyCvG7LQnkcji0Z7u
	 +4CGjMlIrMQWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Guillermo Servera Negre <guillem@gservera.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)
Date: Mon, 31 Aug 2026 09:30:15 -0400
Message-ID: <20260831133314.4125787-587-sashal@kernel.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 575e6a72bd68008b6795345113d3e94f3dccbf5d ]

Add the specific USB device ID which adapter tested fully functional on
Fedora 44 with kernel 7.0.8-200.fc44.x86_64 and linux-firmware
20260410-1.fc44.

Reported-by: Guillermo Servera Negre <guillem@gservera.com>
Tested-by: Guillermo Servera Negre <guillem@gservera.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260525011728.6836-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: rtw89: 8851bu] [add] Mercusys MA60XNB USB device ID
(2c4e:0128)`

### Step 1.2: Tags
**Record:**
- **Reported-by:** Guillermo Servera Negre \<guillem@gservera.com\> —
  user-reported hardware enablement
- **Tested-by:** Guillermo Servera Negre \<guillem@gservera.com\> —
  verified on Fedora 44 / kernel 7.0.8
- **Signed-off-by:** Ping-Ke Shih \<pkshih@realtek.com\> — rtw89
  maintainer
- **Link:**
  https://patch.msgid.link/20260525011728.6836-1-pkshih@realtek.com
- No Fixes:, Cc: stable, Reviewed-by, or Acked-by tags
- Notable: real user report + maintainer-authored + tested on target
  hardware

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Mercusys MA60XNB (USB 2c4e:0128) is not bound by
  `rtw89_8851bu`; WiFi does not work on kernels without this ID.
- **Symptom:** Adapter not recognized by the rtw89 WiFi driver; no
  wireless connectivity.
- **Root cause:** Missing `usb_device_id` table entry; USB core cannot
  match the device to `rtw89_8851bu`.
- **Version info:** Tested on Fedora 44 with kernel 7.0.8 and linux-
  firmware 20260410.

### Step 1.4: Hidden Bug Fix?
**Record:** Not a crash/corruption fix. This is explicit **hardware
enablement** via a new USB ID — a well-established stable exception
category.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/realtek/rtw89/rtw8851bu.c` (+3 lines)
- **Function/area:** `rtw_8851bu_id_table[]` USB ID table
- **Scope:** Single-file, surgical device-ID addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** USB device 2c4e:0128 not in `rtw_8851bu_id_table`;
  `rtw89_8851bu` does not probe it.
- **After:** Device matches table entry → `rtw89_usb_probe()` runs →
  RTL8851BU WiFi comes up.
- **Path:** USB enumeration / driver binding (normal probe path).

### Step 2.3: Bug Mechanism
**Record:** **Hardware workarounds / device ID addition.** Same chip
family and driver as existing entries (D-Link AX9U, TP-Link Archer
TX10UB Nano, etc.). Without the ID, the existing driver never attaches.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: identical pattern to adjacent entries.
- Minimal: 3 lines, no logic changes.
- Regression risk: very low — only affects matching of this specific
  VID:PID.
- No API, structure, or behavior changes beyond enabling one device.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `rtw8851bu.c` added in `52cf443237856` (2025-07-04): "wifi: rtw89: Add
  rtw8851bu.c"
- D-Link AX9U ID added in `2ffc73cdb8247` (2025-09-02): same RTL8851BU
  pattern
- Candidate commit `575e6a72bd680` is **not** in this tree (`git merge-
  base --is-ancestor` exit 1)

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:**
- `79f9e221dddec` already in **this** tree: "Bluetooth: btusb: Add USB
  ID 2c4e:0128 for Mercusys MA60XNB" — describes it as an **RTL8851BU-
  based Wi-Fi + Bluetooth adapter**
- `2ffc73cdb8247` in this tree: D-Link AX9U (also RTL8851BU) ID addition
  — precedent for stable backport of rtw8851bu IDs
- Standalone single-patch series (v1 only per `b4 dig -a`)

### Step 3.4: Author Context
**Record:** Ping-Ke Shih is rtw89 maintainer; regular contributor with
multiple commits in this tree.

### Step 3.5: Dependencies
**Record:** No prerequisites. Driver, probe path (`rtw89_usb_probe`),
and chip support (`rtw8851b`) all exist in 6.18.44. Backport is a
straight table entry; mainline has extra `rtw8851b_usb_info` structure
not present here, but the ID lines apply independently after the D-Link
entry.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Patch Discussion
**Record:**
- `b4 dig -c 575e6a72bd680`:
  https://patch.msgid.link/20260525011728.6836-1-pkshih@realtec.com
- Single v1 submission (2026-05-25)
- WebFetch of lore URL blocked (Anubis bot protection) — could not read
  thread replies

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: To/Cc — Ping-Ke Shih, linux-
wireless@vger.kernel.org, guillem@gservera.com

### Step 4.3: Bug Report
**Record:** User report via Guillermo Servera Negre; hardware tested
working with ID present. No syzbot/security report.

### Step 4.4: Related Patches
**Record:** Companion btusb ID `79f9e221dddec` already backported to
this tree; WiFi side is the missing half for MA60XNB users.

### Step 4.5: Stable List
**Record:** Not searched separately; btusb half already landed in 6.18.y
via stable backport.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rtw_8851bu_id_table[]` (modified); `rtw89_usb_probe` /
`rtw89_usb_disconnect` (unchanged, referenced by driver struct)

### Step 5.2: Callers
**Record:** USB core matches `id_table` during enumeration → calls
`rtw89_usb_probe`. Standard hotplug path for USB WiFi dongles.

### Step 5.3: Callees
**Record:** Probe delegates to existing rtw89 USB infrastructure in
`usb.c`; no new code paths.

### Step 5.4: Reachability
**Record:** Triggered when user plugs in Mercusys MA60XNB. Common, user-
visible path.

### Step 5.5: Similar Patterns
**Record:** Same file already has D-Link, TP-Link, Edimax IDs; btusb
already has 2c4e:0128; rtw88 has other Mercusys 2c4e IDs.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → v6.18.44). `rtw8851bu.c` exists with 4 device IDs; **2c4e:0128
is absent**. Driver present since July 2025.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — insert 3 lines after D-Link block (line
21), before TP-Link block. Mainline base differs structurally but
insertion point and syntax match this tree.

### Step 6.3: Related Fixes Already Present?
**Record:** btusb ID for same device **already in tree**
(`79f9e221dddec`). WiFi ID is **not** present. No duplicate fix.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/net/wireless/realtek/rtw89` — **IMPORTANT** (common
USB WiFi hardware, user-visible).

### Step 7.2: Activity
**Record:** Actively maintained; frequent stable backports including
other USB ID additions (`2ffc73cdb8247`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Mercusys MA60XNB on 6.18.y without this ID — WiFi
non-functional despite driver being built.

### Step 8.2: Trigger Conditions
**Record:** Plug in MA60XNB USB adapter. Common, unprivileged user
action. Certainty: 100% without ID.

### Step 8.3: Failure Mode Severity
**Record:** WiFi driver never binds — **hardware does not work**
(functional failure, not kernel crash). Severity for affected users:
**HIGH** (device unusable for intended purpose). Not a security/crash
issue.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables WiFi on a commercially sold RTL8851BU adapter;
  completes pairing with already-backported btusb ID.
- **Risk:** Negligible — 3-line ID table entry, zero logic change.
- **Ratio:** Strongly favorable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Standard stable exception: new USB ID on existing driver
- Real user report + Tested-by on target hardware
- Maintainer-authored (Ping-Ke Shih)
- Driver and probe infrastructure exist in 6.18.44
- btusb ID for same device already in this stable tree — WiFi half is
  missing
- Precedent: D-Link AX9U RTL8851BU ID already in stable
  (`2ffc73cdb8247`)
- 3 lines, obviously correct

**AGAINST backport:**
- Not a crash/security/data-corruption fix (lower urgency than UAF
  fixes)
- Lore thread content unverified (fetch blocked)

**UNRESOLVED:**
- Full mailing-list review thread not readable (Anubis)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — same pattern as existing
   entries; Tested-by present
2. Fixes real bug affecting users? **PASS** — device unusable for WiFi
   without ID
3. Important issue? **PASS** — hardware enablement for real users
   (functional failure)
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS** — device ID exception only
6. Can apply to local tree? **PASS** — driver exists; clean insertion

### Step 9.3: Exception Category
**Record:** **NEW DEVICE ID** — textbook stable material.

### Step 9.4: Decision Rationale
For Linux **6.18.44**, the `rtw89_8851bu` driver is present but lacks
the Mercusys MA60XNB ID. The Bluetooth interface of the same adapter is
already supported via a stable backport (`79f9e221dddec`). Adding the
WiFi ID is a minimal, tested, maintainer-approved enablement fix with
negligible regression risk and clear user benefit.

---

## Verification

- [Phase 1] Parsed commit `575e6a72bd680`: subject, Reported-by, Tested-
  by, Link tags
- [Phase 2] Diff: +3 lines to `rtw_8851bu_id_table[]` in `rtw8851bu.c`
- [Phase 3] `git describe HEAD`: v6.18.44 / kernel 6.18.44
- [Phase 3] `git merge-base --is-ancestor 575e6a72bd680 HEAD`: exit 1 —
  commit not in tree
- [Phase 3] `git log --oneline --
  drivers/net/wireless/realtek/rtw89/rtw8851bu.c`: 2 commits (driver add
  + D-Link ID)
- [Phase 3] `git blame` lines 16–28: table from `52cf443237856`, D-Link
  from `2ffc73cdb8247`
- [Phase 3] `git show 79f9e221dddec`: btusb Mercusys ID already in
  stable, notes RTL8851BU combo adapter
- [Phase 4] `b4 dig -c 575e6a72bd680`: lore URL found
- [Phase 4] `b4 dig -a`: single v1 patch
- [Phase 4] `b4 dig -w`: linux-wireless CC'd
- [Phase 4] WebFetch lore URL: **blocked** (Anubis) — thread content
  unverified
- [Phase 5] `grep rtw89_usb_probe`: probe in `usb.c`, used by
  `rtw8851bu.c`
- [Phase 6] Read `rtw8851bu.c`: no 2c4e:0128 entry; driver fully present
- [Phase 6] `grep 2c4e.*0128`: present in `btusb.c`, absent from
  `rtw8851bu.c`
- [Phase 7] Kconfig/Makefile: `CONFIG_RTW89_8851BU` builds
  `rtw89_8851bu` module
- [Phase 8] Failure mode: WiFi non-functional without ID; bt half
  already works in tree

**YES**The background history search finished. It found only the
Bluetooth half of the Mercusys MA60XNB support already in this tree
(`79f9e221dddec` in `btusb.c`); the rtw89 WiFi ID commit
(`575e6a72bd680`) is not present on 6.18.44.

That matches the earlier analysis: backporting the 3-line WiFi ID
addition is appropriate for this stable tree.

 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 04e1ab13b7535..10fcfade6151e 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -19,6 +19,9 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
 	/* D-Link AX9U rev. A1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x332a, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
+	/* Mercusys MA60XNB */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2C4E, 0x0128, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
 	/* TP-Link Archer TX10UB Nano */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010b, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
-- 
2.53.0

