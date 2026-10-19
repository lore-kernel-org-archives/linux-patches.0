Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD80575080;
	Mon, 19 Oct 2026 13:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418308; cv=none; b=BWe7a6ZWXBKauts0nzkZBWHFIKQYjc3IXgUe/TH84rH36tz51cE2ONLafDMAqbLMCn93IOsexgxTI0CF1DrCep642C4q6YeMyDML1USopYrKv8p3EAdB7X5431hvacbOMrRzQfXvksZXUaOda3QXctbEHk8+FajxIt0abIf8X0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418308; c=relaxed/simple;
	bh=Nz6HJQ+nBd1R73vfaXE+9CxwjrqZEV3OSc7DiEB8xpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhFiLebtY8YaCg9V/r2+x/9EXSI7Rl2G94EamGwwoci3d1AfogcF63IntLObytX8CFyQwV8u709vKQHWrjENC/SSbXlqFO+2uUz5lou0+OoWqUa65WXA/BkX9LVkhcKITCIHOjfsXYQXsVpF9XNB+kSaWlCGkUSxUkza/O4FwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCiSpc3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCiSpc3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A291F000C6;
	Mon, 19 Oct 2026 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418305;
	bh=AA4mSu76ubMZwQ39NWRyKOU7FoyWXCVaIhfpSX8lguI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCiSpc3bk4AYcFB9h/WcJWFW567LrAkc4uMD3Y/dEeKAhIGgmU/3+fGXcpnMaLFw9
	 Q2QlO7aWUlVgNjc2DrGTlRq6Fn2CRrrdgXKIa9rW01j4nKYPypUkIh9MS6xkZiJ3OO
	 icXuieg4j6Nx1p/DSsDu52HMfsWpWusYcvz/7ndhM6WtaHDJe+9wkre9kwZi9hho+J
	 nHCC36i1yHi3L8ZgMzIcPhUxPY6f6lFzgmWJ16P0vb5XBe3ecr8Nne/X6duj37wA5r
	 lV1P9gFVHsQlPP50qTZgsiDJ2N9XRFf0x6MsZSgr9DBDjxr+ok68z7DHjLoDwQV5na
	 Vr3iAEjoCHaiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuxiang Lin <mclyxfdw@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle
Date: Mon, 19 Oct 2026 09:47:24 -0400
Message-ID: <20261019135441.1420968-153-sashal@kernel.org>
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

From: Yuxiang Lin <mclyxfdw@gmail.com>

[ Upstream commit 2884e21b18613708f050ec75330b265dd07ecc03 ]

The AULA Mini 60 HE Pro wireless keyboard dongle (USB ID
0c45:fefe) becomes unresponsive after roughly one minute of idle.
No error appears in dmesg; the only recovery is physically
replugging the dongle.

This has been reproduced across kernels 6.8, 6.14 and 7.1.3.

Testing shows HID_QUIRK_ALWAYS_POLL alone resolves the issue,
verified via usbhid.quirks=0x0c45:0xfefe:0x400.

Signed-off-by: Yuxiang Lin <mclyxfdw@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a hardware-quirk addition for a wireless keyboard dongle that
stops responding after idle. The local tree is **5.15.221**
(`pending-5.15`, `git describe`: `p-5.15-2-g9a29d9b0f9507`). Upstream
commit is `2884e21b18613` (`HID: quirks: add ALWAYS_POLL quirk for AULA
Mini 60 HE Pro Dongle`); `git merge-base --is-ancestor` confirms it is
**not** in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[HID]** **[add]** **ALWAYS_POLL quirk for AULA Mini 60 HE Pro
wireless dongle (USB 0c45:fefe)**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none (author describes own testing in the body)
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none in the commit; mailing-list Message-ID
  `20260722175602.22773-1-mclyxfdw@gmail.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Yuxiang Lin \<mclyxfdw@gmail.com\> (author); Jiri
  Kosina \<jkosina@suse.com\> (HID maintainer). Ignore any pipeline SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** AULA Mini 60 HE Pro wireless dongle `0c45:fefe` becomes
  unresponsive after ~1 minute idle.
- **Symptom:** No dmesg error; only recovery is physically replugging
  the dongle. Keyboard is dead until then.
- **Versions tested by author:** 6.8, 6.14, 7.1.3 (not 5.15
  specifically).
- **Root cause (author):** device needs continuous interrupt polling;
  `HID_QUIRK_ALWAYS_POLL` alone fixes it, verified with
  `usbhid.quirks=0x0c45:0xfefe:0x400`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware quirk for a
device that stops working. Matches the documented HID ALWAYS_POLL
pattern (devices that hang when the host stops polling the interrupt
endpoint).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/hid/hid-ids.h`: **+1** (`USB_DEVICE_ID_AULA_MINI_60_HE_PRO
  0xfefe` under existing `USB_VENDOR_ID_JESS 0x0c45`)
- `drivers/hid/hid-quirks.c`: **+2** (one `hid_quirks[]` entry:
  `HID_QUIRK_ALWAYS_POLL`)
- Total: **3 insertions**, 0 deletions, 2 files
- Functions: none modified; static ID table only
- Scope: **single-purpose surgical quirk addition**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** dongle `0c45:fefe` is a generic USB HID device. usbhid
  starts interrupt polling on open and may stop it on close / when not
  `ALWAYS_POLL`. After ~1 minute idle the firmware/hardware stops
  responding; unplug/replug required.
- **After:** `hid_gets_squirk()` / `hid_lookup_quirk()` matches this
  VID/PID and sets `HID_QUIRK_ALWAYS_POLL` (`BIT(10)` = `0x400`).
  `usbhid_start()` starts the IN URB at probe and keeps `HID_IN_POLLING`
  set across close (`usbhid_open`/`usbhid_close`/`usbhid_stop` in this
  tree).
- Path: HID probe / usbhid start-stop, **not** an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(h) Hardware workaround** — HID quirk table + device ID. Same
class as USB/HID quirks that are routinely taken into stable. Not UAF,
leak, race, etc.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one ID + one table entry using an existing, well-
  tested quirk bit.
- Author empirically confirmed `ALWAYS_POLL` alone is sufficient.
- Regression risk is **low and device-scoped**: only `0c45:fefe`. Cost
  is extra interrupt polling (power) on that dongle only.
- No API, locking, or data-structure changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `USB_VENDOR_ID_JESS 0x0c45` / `USB_DEVICE_ID_JESS_YUREX`:
  `6bc235a2e24a5` (Tomoki Sekiyama, 2010). Present in this tree at
  `drivers/hid/hid-ids.h:695-698`.
- Insertion point in `hid_quirks[]` (after INNOMEDIA, before KYE): table
  from `d5d3e202753cc0` (Benjamin Tissoires, 2017).
- `HID_QUIRK_ALWAYS_POLL` introduced in `0b750b3baa2d6` (“HID: usbhid:
  add always-poll quirk”, Johan Hovold, 2014-09-08). `git merge-base
  --is-ancestor 0b750b3baa2d6 HEAD` **succeeds**. Defined here as
  `BIT(10)` in `include/linux/hid.h:373`.
- The AULA ID itself is **new**; the bug is hardware/firmware plus long-
  standing usbhid idle/poll behavior, not a recent regression.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. N/A. Bug is device firmware vs existing usbhid
poll-on-open behavior, not a specific introducing commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This 5.15 tree already carries the same class of backports,
e.g.:
- `f9ad98cff302c` HID: quirks: add HID_QUIRK_ALWAYS_POLL for 8BitDo Pro
  3
- `16c2ca35257ed` HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30
- `5c46ec760d3be` HID: quirks: Add ADATA XPG alpha wireless mouse
  support
- `9f093e15faee6` HID: add ALWAYS_POLL quirk for Apple kb
Standalone; not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: `git log --author="Yuxiang Lin"` on `drivers/hid/` in this tree:
**empty**. One-off device owner report. Weight comes from HID maintainer
Jiri Kosina applying it, not from the author being a maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs only `HID_QUIRK_ALWAYS_POLL`, `hid_quirks[]`,
`USB_VENDOR_ID_JESS`, and usbhid ALWAYS_POLL handling — all present
since well before 5.15. **Standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 2884e21b18613` matched lore by patch-id:
  https://patch.msgid.link/20260722175602.22773-1-mclyxfdw@gmail.com
- `b4 dig -a`: **v1 only** (2026-07-23). No v2/v3.
- Thread: submit → Jiri Kosina “Applied, thanks.” (2026-08-03). No NAK,
  no requested changes, no stable discussion in-thread.
- lore.kernel.org HTTP fetch returned 403; discussion recovered via `b4
  dig -m` mbox and LKML mirrors.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `jikos@kernel.org`; Cc Benjamin Tissoires,
linux-input, linux-kernel. HID maintainers were on the original mail.
Applied by Jiri Kosina.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. The report **is** the patch: author
reproduced hang on 6.8/6.14/7.1.3 and verified the quirk via module
parameter. Single reporter; concrete hardware + recovery path.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone 1/1. Nearby mainline ALWAYS_POLL quirks (Beitong,
SIGMACHIP, SDINNOVATION) are separate devices, not prerequisites.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No evidence in the
linux-input thread of a stable NAK. UNVERIFIED: whether someone already
requested this on stable@ (does not change the technical case).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function bodies edited. New consumers of `hid_gets_squirk()`
→ `hid_lookup_quirk()`. Runtime effect is in usbhid: `usbhid_open`,
`usbhid_close`, `usbhid_start`, `usbhid_stop`.

**Step 5.2: TRACE CALLERS**
Record (this tree):
- `hid_lookup_quirk()`: `drivers/hid/hid-core.c` (device add / quirk
  refresh), `drivers/hid/usbhid/hid-core.c:992` (usbhid probe).
- ALWAYS_POLL consumers: `usbhid_open` (skip start-on-open),
  `usbhid_close` (keep polling), `usbhid_start` (start IN URB at probe),
  `usbhid_stop` (clear polling).
- Context: USB HID probe and open/close — **device enumeration /
  input**, not IRQ-unsafe new locking.

**Step 5.3: TRACE CALLEES**
Record: Table match only. ALWAYS_POLL path already calls
`usb_autopm_get_interface`, `hid_start_in`, `usb_kill_urb` in this tree.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug dongle → usbhid probe → `hid_lookup_quirk` → generic HID
input. Userspace (evdev) uses the keyboard. **Reachable from plugging
the device;** unprivileged user of that keyboard hits the hang after
idle. Not a syscall fuzzer path; real HID hardware path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Dozens of `HID_QUIRK_ALWAYS_POLL` entries already in this tree’s
`hid_quirks[]` (HP/Pixart mice, Corsair, Logitech, Lenovo, 8BitDo,
Edifier, ADATA XPG, …). Same fix, new VID/PID. No `0xfefe` HID ID
already present (grep of `drivers/hid` empty).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** usbhid ALWAYS_POLL vs poll-on-open logic is in
`drivers/hid/usbhid/hid-core.c` (e.g. 687, 750, 754, 1183, 1232). Vendor
ID `USB_VENDOR_ID_JESS 0x0c45` exists; product `0xfefe` is **not**
quirked. The hang is firmware + this poll behavior; it is not a 6.x-only
bug. Author listed 6.8+ because those are what they ran; 5.15 has the
same usbhid mechanism (ALWAYS_POLL since 2014).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record:
- `hid-ids.h`: `git apply --check` **clean**
  (`USB_DEVICE_ID_REDRAGON_ASURA` context matches).
- `hid-quirks.c`: **context mismatch** — 5.15 has extra KYE entries
  immediately after INNOMEDIA (`KYE_EASYPEN_M610X` …) vs mainline’s
  `KYE` PIXART mouse first. `git apply --check` fails on `hid-
  quirks.c:113`; 3-way reports a conflict there. Fix is insert the two
  JESS lines after the INNOMEDIA entry (alphabetically correct). **Minor
  backport, not a rework.**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No AULA / `0xfefe` HID quirk. No alternate fix for this dongle.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **HID / usbhid** (`drivers/hid/`). Criticality: **IMPORTANT**
(common input stack), impact **driver-specific / device-specific**. Not
core mm/net, but keyboards are user-visible and this tree already
backports HID quirks.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature. `hid-quirks.c` still gets device-ID/quirk backports on
5.15. This is not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / device-specific** — owners of AULA Mini 60
HE Pro wireless dongle `0c45:fefe`. No effect on other HID devices.
`CONFIG_USB_HID` (standard desktop/laptop configs).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Plug dongle, leave idle ~1 minute. Common for a wireless
keyboard. Unprivileged user of the keyboard is affected. Not a timing
race; firmware/idle-poll issue. Author reproduced on three kernel
versions.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Input device **permanently unresponsive** until physical replug;
no oops. **HIGH** for those users (keyboard dead; no software recovery).
Not panic/corruption/CVE.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** restores a wireless keyboard on 5.15 LTS without a
  module-param workaround.
- **Risk:** 3 lines, one VID/PID, existing quirk bit. Possible extra USB
  polling/power on that dongle only. Context-hunk tweak in `hid-
  quirks.c`.
- **Ratio:** high benefit for affected hardware, very low regression
  risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, reproduced hang: dongle dies after idle; only unplug recovers.
- Standard **HID hardware quirk** (`HID_QUIRK_ALWAYS_POLL`), the stable-
  rules exception for quirks/device IDs.
- 3 lines; no new APIs; no refactor.
- Infrastructure present in 5.15 since 2014; same quirk class already
  backported here.
- Empirically verified (`usbhid.quirks=…:0x400` matches `BIT(10)`).
- HID maintainer applied v1 with no objections.
- Scoped to `0c45:fefe`; no HID collision on `0xfefe` in this tree.

AGAINST:
- Author did not list 5.15 among tested versions (tested 6.8+).
  Mechanism is the same.
- `hid-quirks.c` needs a tiny context adjustment.
- Single reporter; not a crash/security bug.
- Relatively new keyboard on an old LTS — still the usual reason HID
  ID/quirk backports exist.

UNRESOLVED:
- stable@ archive search (HTTP 403). Does not change the technical
  verdict.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 3-line table add; author
   tested; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — keyboard dies until
   replug.
3. Important issue? **PASS** — device unusable after idle (quirk
   exception; not a panic, but production-relevant for that hardware).
4. Small and contained? **PASS** — 3 lines, two HID files.
5. No new features or APIs? **PASS** — existing quirk bit + ID.
6. Can apply to the local tree? **PASS** — `hid-ids.h` clean; `hid-
   quirks.c` one-hunk context fix.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / device ID on an existing driver** (HID
usbhid). Automatic YES class.

**Step 9.4: DECISION**
Backport. The bug exists on this tree’s usbhid, the quirk bit exists,
and this is the same pattern already used for 8BitDo/Edifier/ADATA on
5.15.

### What it solves for 5.15 users
Without ALWAYS_POLL, usbhid may stop interrupt polling; this Sonix-based
dongle then wedges until replugged. Adding the ID makes 5.15 keep
polling from probe, matching the module-param workaround.

### Risk vs benefit
Benefit is a working keyboard for that VID/PID. Risk is extra polling on
that device only. `hid-quirks.c` needs the JESS line inserted after the
INNOMEDIA entry because KYE rows differ from mainline.

### Concerns
None that block a YES: no missing prerequisites; not a new driver; apply
conflict is mechanical.

Verification:
- [Phase 1] Tags: author + Jiri Kosina SOB; no Fixes/stable/Reported-by.
- [Phase 1] Body: idle hang, replug recovery, tested 6.8/6.14/7.1.3,
  `usbhid.quirks=0x0c45:0xfefe:0x400`.
- [Phase 2] Diff: +1 hid-ids.h, +2 hid-quirks.c; ALWAYS_POLL table
  entry.
- [Phase 2] `HID_QUIRK_ALWAYS_POLL` is `BIT(10)` = `0x400` in
  `include/linux/hid.h:373`.
- [Phase 3] `git describe HEAD` → `p-5.15-2-g9a29d9b0f9507`; `make
  kernelversion` → 5.15.221.
- [Phase 3] ALWAYS_POLL intro `0b750b3baa2d6` (2014) is ancestor of
  HEAD.
- [Phase 3] `USB_VENDOR_ID_JESS` blame `6bc235a2e24a5` (2010); lines
  695-698 in this tree.
- [Phase 3] No AULA/0xfefe in `drivers/hid`; author has no HID commits
  here.
- [Phase 3] Similar 5.15 backports: `f9ad98cff302c`, `16c2ca35257ed`,
  `5c46ec760d3be`.
- [Phase 3] Upstream SHA `2884e21b18613708f050ec75330b265dd07ecc03`; not
  ancestor of HEAD (exit 1).
- [Phase 4] `b4 dig -c 2884e21b18613`: lore match; To jikos, Cc
  bentiss/linux-input.
- [Phase 4] `b4 dig -a`: v1 only. Mbox: Jiri “Applied, thanks.” No NAK.
- [Phase 4] lore.kernel.org WebFetch 403; used b4 mbox + LKML/openwall
  mirrors.
- [Phase 5] `hid_lookup_quirk` used from hid-core.c and usbhid/hid-
  core.c:992.
- [Phase 5] ALWAYS_POLL in usbhid open/close/start/stop in this tree.
- [Phase 6] `git apply --check`: hid-ids.h clean; hid-quirks.c fails at
  line 113 (KYE order). 3-way conflict on quirks only.
- [Phase 7] HID usbhid; quirk table still receiving 5.15 backports.
- [Phase 8] Failure: keyboard dead until replug; severity HIGH for that
  device; risk very low.
- UNVERIFIED: stable@ mailing-list archive (403). Not used as a NO
  reason.

**YES**

 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c1a7f5558ccd1..5169713539bc3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -748,6 +748,7 @@
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 #define USB_DEVICE_ID_ASUS_MD_5112	0x5112
 #define USB_DEVICE_ID_REDRAGON_ASURA	0x760b
+#define USB_DEVICE_ID_AULA_MINI_60_HE_PRO 0xfefe
 
 #define USB_VENDOR_ID_JESS2		0x0f30
 #define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 3de594ee25c38..8d2ac32c5ac12 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -113,6 +113,8 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_AULA_MINI_60_HE_PRO),
+		HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M506), HID_QUIRK_MULTI_INPUT },
-- 
2.53.0

