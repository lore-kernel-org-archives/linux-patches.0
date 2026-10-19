Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8612B603197;
	Mon, 19 Oct 2026 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418588; cv=none; b=mutmkbc8FfyCdmufC2rLdXbyKRxY5XkR7Gj6B/cC6OQwcZ0oUK49+zVBGNXLbbkcdPDKagp6qAx8W3TFBvt3kiS2XLjAE+X3SzCEgISYb5xaOcUdLSHzRZtNfdIcFnbwYuF8uDozoFcNvtZVOw/iaSfbucTV7ypA09U+Ac4gPNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418588; c=relaxed/simple;
	bh=xxlunni3DMwezGpQqKTgp+KjgidZpLvetC50maIy4ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dSsONAXJVkdhXOeTlH1f7DNoWdlmem7p/kIWlkbebkz0lMr54TliIR+LRwFkeBDdn1imqTalDbdZAM0oKSmTNVzlg6VgMIwo0RoYSyNzqYMEwUGIcS40Y+3JkCmXp8oH4RGdndVRu8lFKux6Ah45ewgJOKPVngeIo/rDf5V7TXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLp7O0v0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLp7O0v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A981F000C7;
	Mon, 19 Oct 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418585;
	bh=CQXt+PrM4dVfrDIYoHTVJU2WR3oWzAhxRf+Yr29VXJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLp7O0v04nN6DtL1KmMonOzRDZSemgDJMKRyTlttJSOiC2iiMgF8DZp+9QSGCEUGJ
	 UL4MOPM26ZLAsB/BeWS66XoYkfL2um5O/yndx98NWHRTpPjHpWi7w9NWLOVF+wa2Xo
	 H94eVXD9vfiynIj88jaNt2YGLrLUFFQy2+D+5+QikuN5KJfy5FAhRLPIEBs3qEcH3+
	 d5SZJ3N3tuSHT0e8dFNHixtrhaHCgI3dIbo2O38Cu11lQyqGD0ou83/aTXk/3g11sT
	 ISAD0k+cN2pBWLvBlhrObrRASVNsfkyZegR/wYt+HR/aCOVibFAbBLShol3KLdzPq6
	 uDUEnaP5h46SA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Mon, 19 Oct 2026 09:50:43 -0400
Message-ID: <20261019135441.1420968-352-sashal@kernel.org>
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

From: Aaron Ma <mapengyu@gmail.com>

[ Upstream commit bfff246b3a31cb45ec297ca5e2a77c1410b207ac ]

The BTP-KP20D dongle in Direct/HID mode (20dd:5159) re-enumerates every
few seconds because usbhid never submits its interrupt-IN URB: no HID
driver binds to the vendor-specific report descriptor, so the device is
never opened, and the firmware treats the idle endpoint as a lost link.

Add HID_QUIRK_ALWAYS_POLL to keep the interrupt-IN URB submitted from
probe time.

Signed-off-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a device-specific HID quirk for a gamepad dongle that constantly
re-enumerates. The local tree is **5.15.221** (`pending-5.15`);
`HID_QUIRK_ALWAYS_POLL` and the quirk table already exist here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [HID] [Add] Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
(20dd:5159)

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Aaron Ma <mapengyu@gmail.com> (author)
- Signed-off-by: Jiri Kosina <jkosina@suse.com> (HID maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
- Absence of Fixes:/Cc: stable is expected for this review pipeline and
  is not a negative signal
- Ignore any pipeline-added Sasha Levin SOB / Upstream commit markers

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: BTP-KP20D in Direct/HID mode (20dd:5159) re-enumerates every few
  seconds
- Symptom: USB disconnect/reconnect loop; the dongle is unusable
- Root cause: usbhid does not submit the interrupt-IN URB until the HID
  device is opened. Vendor-specific report descriptors do not produce a
  bound/opened input client, so the firmware treats the idle endpoint as
  a lost link
- Fix: HID_QUIRK_ALWAYS_POLL so the interrupt-IN URB is submitted from
  probe/start time
- No kernel-version range stated; this is hardware firmware behavior,
  not a regression in a specific kernel commit

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk. The
word “Add” is the normal form for quirk/ID table entries that still fix
real devices.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- drivers/hid/hid-ids.h: +3 (USB_VENDOR_ID_BEITONG 0x20dd,
  USB_DEVICE_ID_BEITONG_KP20D 0x5159)
- drivers/hid/hid-quirks.c: +1 (hid_quirks[] entry with
  HID_QUIRK_ALWAYS_POLL)
- Functions: none; data-table only
- Scope: single-purpose, two-file, 4-line surgical addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: 20dd:5159 is a generic USB HID device with no special quirk.
  usbhid_start() does not submit urbin unless a client opens the device
  (usbhid_open)
- After: hid_lookup_quirk() returns HID_QUIRK_ALWAYS_POLL.
  usbhid_start() (called from hid_hw_start() during hid-generic probe)
  calls hid_start_in() immediately and leaves HID_IN_POLLING set so
  usbhid_close() does not kill the URB
- Path: probe/start of this one VID:PID, not a global HID change

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: Hardware workaround. Category (h). Firmware requires interrupt-
IN polling to keep the USB link; the kernel only polls after open.
ALWAYS_POLL is the existing mechanism for that class of devices
(mice/keyboards/dongles that disconnect if not polled).

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct. Same pattern as many ALWAYS_POLL entries
already in this tree (8BitDo Pro 3, Edifier QR30, Cooler Master MM712,
ADATA XPG, PixArt mice, etc.). Regression risk is limited to VID 0x20dd
/ PID 0x5159: extra interrupt polling and remote-wakeup flag. That is
the intended tradeoff and is cheaper than a reconnect loop. No API,
locking, or structural change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion in hid-ids.h is between BAANTO (9ed326951806c4, 2012) and
  BELKIN (a11b3fab94d4fb, 2010)
- Insertion in hid-quirks.c is between ATEN_UC100KM and
  CHICONY_MULTI_TOUCH (d5d3e202753cc0, 2017)
- HID_QUIRK_ALWAYS_POLL is BIT(10) in include/linux/hid.h, present since
  0b750b3baa2d6 (“HID: usbhid: add always-poll quirk”, 2014-09-08)
- usbhid_start()/usbhid_open()/usbhid_close() already implement
  ALWAYS_POLL in this checkout

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not a regression in a specific commit; the
device’s firmware misbehaves on the long-standing “poll only when
opened” policy. The policy itself dates to 2014 and is in this 5.15
tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: This tree already contains many ALWAYS_POLL quirk backports,
including:
- f9ad98cff302c HID: quirks: add HID_QUIRK_ALWAYS_POLL for 8BitDo Pro 3
  (identical 4-line pattern)
- 16c2ca35257ed Edifier QR30
- 9727b5dc98c33 Cooler Master MM712 dongle
- 5c46ec760d3be ADATA XPG wireless mouse
No Beitong/BTP-KP20D/20dd:5159 history. Standalone, not patch N/M.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Aaron Ma has prior HID work in this tree (i2c-hid Raydium
resume/IRQ, hid_report_len, LG MELF0410). HID maintainer Jiri Kosina
applied the patch. Not a drive-by unknown-subsystem change.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends only on HID_QUIRK_ALWAYS_POLL, hid_quirks[],
hid_lookup_quirk(), and usbhid ALWAYS_POLL handling — all present. Can
apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Message-ID: 20260803053932.5897-1-mapengyu@gmail.com
- b4 mbox retrieved a 2-message thread (lore.kernel.org HTTP 403, so b4
  was used instead of WebFetch)
- v1 only; no v2/v3
- Recipients: Jiri Kosina, Benjamin Tissoires, linux-input, linux-kernel
- Jiri Kosina: “Applied, thanks.” (2026-08-03). No NAK, no requested
  changes, no stable discussion in-thread

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Sent to both HID maintainers (Jiri Kosina, Benjamin Tissoires).
Applied by Jiri Kosina. No extra Reviewed-by tags; maintainer apply is
the review signal.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Description is a concrete hardware
failure (re-enumerate every few seconds). No public multi-user bugzilla
thread found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone [PATCH], not part of a series. No other Beitong HID
patches in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned 403. Web search found
no stable-list discussion of this patch. That is consistent with a newly
applied mainline quirk awaiting stable evaluation.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No functions modified. Data consumed by hid_gets_squirk() /
hid_lookup_quirk().

Step 5.2: TRACE CALLERS
Record:
- hid_lookup_quirk() is called from usbhid_parse() and
  hid_device_probe()
- hid-generic matches HID_ANY_ID and hid_generic_probe() calls
  hid_hw_start()
- hid_hw_start() -> usbhid_start() -> if ALWAYS_POLL: hid_start_in()
- usbhid_open()/usbhid_close() skip starting/stopping the in-URB when
  ALWAYS_POLL is set
- Context: USB device enumeration / HID probe, not a hot syscall path
  for other devices

Step 5.3: TRACE CALLEES
Record: The new table entry does not call anything. ALWAYS_POLL path
uses usb_autopm_get_interface, hid_start_in, and sets
needs_remote_wakeup — existing usbhid code.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Plugging in 20dd:5159 -> usbhid_probe -> hid_add_device -> hid-
generic probe -> hid_hw_start -> usbhid_start. Userspace-reachable by
inserting the dongle. Without the quirk the device resets every few
seconds even if nothing opens it.

Note: the commit text says “no HID driver binds.” hid-generic still
matches HID_ANY_ID; the precise failure is that the device is never
opened, so urbin is never submitted. ALWAYS_POLL is still the correct
existing fix for that.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Dozens of HID_QUIRK_ALWAYS_POLL entries already in
drivers/hid/hid-quirks.c in this tree. Same bug class (dongle/mouse
disconnects if interrupt-IN is idle).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. usbhid still starts interrupt-IN only on open unless
ALWAYS_POLL is set. 20dd:5159 is not in hid-ids.h or hid-quirks.c. USB
vendor 0x20dd is not used as a HID ID here (only unrelated 0x20dd hits
in qla2xxx debug ids, ralink USB product 0x0471:0x20dd, GPU register
offsets). The firmware bug is independent of kernel version; 5.15 users
with this dongle hit it.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Local hid-ids.h has BAANTO then BELKIN; local hid-
quirks.c has ATEN_UC100KM then CHICONY_MULTI_TOUCH. No BEITONG symbols
to conflict with. Expected difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No Beitong fix present. Generic ALWAYS_POLL infrastructure is
present. No alternate workaround for 20dd:5159.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: HID / USB HID (drivers/hid). IMPORTANT for users of this
controller; PERIPHERAL in the sense that only one VID:PID is affected.
Not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature and actively backported here (recent HID race/overflow
fixes, plus ongoing quirk-ID additions). HID CORE maintainers: Jiri
Kosina, Benjamin Tissoires.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / device-specific. Only USB 20dd:5159 (Beitong
BTP-KP20D Direct/HID mode). No effect on other HID devices.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is plugging in the dongle in Direct/HID mode. Common for
owners of that hardware; not a rare race. Unprivileged user can trigger
it by using the device. Happens every few seconds until unplugged.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Repeated USB re-enumeration; device unusable; USB reconnect
noise. Not a kernel oops/UAF. Severity MEDIUM-HIGH for affected users
(hardware does not work), LOW blast radius.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: makes this dongle usable on 5.15; same class of quirks
  already shipped in this tree
- Risk: very low (4 lines, one VID:PID, existing quirk bit)
- Ratio: strongly favorable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real hardware failure: reconnect loop every few seconds
- Established HID_QUIRK_ALWAYS_POLL mechanism, present since 2014 in
  this tree
- Textbook stable exception: hardware quirk / device ID on an existing
  driver
- 4-line table addition, no APIs, no refactor
- Applies cleanly to 5.15.221
- HID maintainer applied it
- Identical ALWAYS_POLL ID additions (e.g. 8BitDo Pro 3) already live in
  this tree

AGAINST:
- Affects one gamepad dongle, not a core crash
- No syzbot/CVE/multi-user bugzilla trail
- Commit message slightly overstates “no HID driver binds”

UNRESOLVED:
- Could not HTTP-fetch lore.kernel.org (403); thread recovered via b4
  mbox
- Could not query lore.kernel.org/stable (403); no evidence of an
  explicit stable NAK

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — table entry using existing
   quirk; maintainer applied
2. Fixes a real bug that affects users? PASS — dongle re-enumerates and
   is unusable
3. Important issue? PASS — hardware-unusable reconnect loop (quirk
   exception; not a kernel panic)
4. Small and contained? PASS — 4 lines, two files
5. No new features or APIs? PASS — no new Kconfig, sysfs, or userspace
   ABI; quirk bit already exists
6. Can apply to the local tree? PASS — insertion context present;
   ALWAYS_POLL implemented

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk/workaround plus device ID addition to an existing
driver. Both are automatic-qualify exceptions in the stable rules given
above.

Step 9.4: MAKE YOUR DECISION
Backport. The local 5.15 tree already has the ALWAYS_POLL machinery and
routinely takes this exact class of HID quirk. The patch is the minimal,
device-scoped fix for a dongle that otherwise cannot stay on the bus.

===============================================================
What the commit solves for stable users
===============================================================

On 5.15, usbhid still submits the interrupt-IN URB only when a HID
client opens the device. The BTP-KP20D firmware treats an idle interrupt
endpoint as a lost link and resets, so Direct/HID mode never stays
enumerated. HID_QUIRK_ALWAYS_POLL already starts that URB in
usbhid_start(); this commit only names 20dd:5159 so that path runs. That
is the same fix already used here for 8BitDo, Edifier, Cooler Master,
and many PixArt mice.

Risk vs benefit: benefit is a working controller for anyone on this LTS
tree with that dongle; risk is polling one extra interrupt endpoint on
that VID:PID only.

Concerns: none material. No missing prerequisites. No backport rewrite
needed.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed subject/tags: Add ALWAYS_POLL; SOBs Aaron Ma + Jiri
  Kosina; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +3 hid-ids.h, +1 hid-quirks.c; no function bodies
- [Phase 2] Local usbhid_start() at hid-core.c:1183 already implements
  ALWAYS_POLL via hid_start_in()
- [Phase 3] git describe HEAD / make kernelversion:
  p-5.15-2-g9a29d9b0f9507, 5.15.221, branch pending-5.15
- [Phase 3] git blame include/linux/hid.h:373: HID_QUIRK_ALWAYS_POLL
  BIT(10) present
- [Phase 3] git log -S HID_QUIRK_ALWAYS_POLL -- drivers/hid/usbhid/hid-
  core.c include/linux/hid.h: introduced by 0b750b3baa2d6 (2014)
- [Phase 3] git grep USB_VENDOR_ID_BEITONG / BTP-KP20D: absent in this
  tree
- [Phase 3] git grep 0x20dd: no HID vendor collision
- [Phase 3] Precedent already in this tree: f9ad98cff302c (8BitDo
  ALWAYS_POLL, same 4-line shape)
- [Phase 4] b4 mbox 20260803053932.5897-1-mapengyu@gmail.com: 2
  messages, v1 only, Jiri “Applied, thanks.”
- [Phase 4] WebFetch lore.kernel.org: 403; used b4 instead
- [Phase 5] Call chain: hid_lookup_quirk -> hid-generic_probe ->
  hid_hw_start -> usbhid_start
- [Phase 6] Insertion points exist: hid-ids.h BAANTO then BELKIN; hid-
  quirks.c ATEN_UC100KM then CHICONY_MULTI_TOUCH
- [Phase 7] MAINTAINERS: HID CORE LAYER, Jiri Kosina / Benjamin
  Tissoires
- [Phase 8] Failure mode: USB re-enumeration loop, device-specific,
  severity MEDIUM-HIGH for that hardware
- UNVERIFIED: stable@ mailing-list archive (lore 403); no evidence this
  was rejected for stable

**YES**

 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a9db2b30be9bd..c1a7f5558ccd1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -262,6 +262,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 9d18b962e0ea6..3de594ee25c38 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -45,6 +45,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS682), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS692), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BEITONG, USB_DEVICE_ID_BEITONG_KP20D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
-- 
2.53.0

