Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE14528DD9;
	Mon, 19 Oct 2026 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418585; cv=none; b=ROXDJMHKeF8Mhm8pIQTHNwulcm16JGcyz+YZ6nqsHEyiGKrqYVbjxFTw4ceIRoAN4/at7RuYmgs8SlkudfwBThJVv2LaFHbYQ6llam6FsSRXV8nuVLEVUpyODJ9/k8tjTqY1wogT9+tzSTaUZjd+Nk9vSzwDPgJE1R+pa7MxmF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418585; c=relaxed/simple;
	bh=mQITwMWKBiKAgP34t0D6onZiPL8vWkWKKsJkcSCc/Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tv//EsuAoXnl7Gkflky7ueFrsY1Ay5F7nwapHVMmj7aXyDuHhefTTXxUBtvZdqy49O68hOdmO1pi5R1dXJHLIy9P8Oa+ApraGoEKptyzDmC2OuK7wBHpipJ1eWIAouPgcm+Z85NFHuMJN3lEkYVd+4vhdmBHiVNkm0euxZ4k0vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2asbGwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2asbGwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682191F000C6;
	Mon, 19 Oct 2026 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418582;
	bh=wLdPCGvUXNvRoYDMbpd0S/lpiMhlBoSYMlhEUM3aMd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2asbGwrkyzRN3s7Ybz0IN1CdeHSfHxC21kzSqHXZphIJ0M2ZplxyFQfecGBbpDgP
	 nWiVdvykX+5lqAYYNN6/rkOqxIrbfdn5KjozwpjtP25f8OBKhZmyyt5N36H90t54WF
	 VGddnr9TjVUDgABoPO1WXg6u6eYVntfF6tjKDKS57DWvjkJ2oi0EII0KLNjRXcg55O
	 1KjNaBXIEoimdbd4Ce4w2nVyXx+scPF7DGN0LrAmRpMYATVl07+1JLHOFt0lLbRVgi
	 z310bmIjPrA3bNcreBN2dehaB0W9n3vSjnpuMMpaTKMhxRssExqT3HkoktyslaOyIL
	 s+EsrKpLhHdiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	luke@ljones.dev,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Mon, 19 Oct 2026 09:50:41 -0400
Message-ID: <20261019135441.1420968-350-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>

[ Upstream commit 6303451189a6d8f304221065c44ccd597e0acbe5 ]

The dedicated "ProArt" key on the ASUS ProArt PX13 (HN7306) emits ASUS
WMI event code 0x8b. This code is absent from the asus-nb-wmi sparse
keymap, so pressing the key only produces a "Unknown key code 0x8b"
message and does nothing in userspace.

On this model the key is exposed solely through the WMI interface and has
no HID scancode, so it can only be handled inside asus-nb-wmi. Map 0x8b
to KEY_PROG3 so the key emits a bindable event, consistent with the
existing KEY_PROG3 mapping used for the ASUS programmable/Armoury key.

Signed-off-by: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260719090843.66777-1-nizar.m.kabbani@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[platform/x86: asus-nb-wmi:] [map] dedicated ProArt WMI event
0x8b to KEY_PROG3**
Subsystem: `platform/x86` (`asus-nb-wmi`). Verb: **map** — hardware-key
enablement, not a refactor.

**Step 1.2 — Tags** (ignoring pipeline `Signed-off-by: Sasha Levin` /
`[Upstream commit …]` as instructed)

- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none in the commit; the lore `From` host is `proart-
  px13.tail9ecfc0.ts.net`, so the author submitted from the affected
  machine
- **Reviewed-by:** Denis Benato `<denis.benato@linux.dev>`; Ilpo
  Järvinen `<ilpo.jarvinen@linux.intel.com>` (platform/x86 maintainer)
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260719090843.66777-1-
  nizar.m.kabbani@gmail.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Nizar Al-Kabbani (author); Ilpo Järvinen
  (maintainer application)

Record: Maintainer + ASUS-WMI reviewer sign-off. No syzbot, no crash
report.

**Step 1.3 — Body**
Record: **Bug:** ASUS ProArt PX13 (HN7306) ProArt key emits WMI 0x8b,
which is missing from `asus_nb_wmi_keymap[]`.
**Symptom:** `pr_info("Unknown key code 0x8b")` and no EV_KEY in
userspace.
**Root cause:** key is WMI-only on this model (no HID scancode), so only
this driver can report it.
**Fix:** map 0x8b → `KEY_PROG3`, matching Armoury/programmable-key
practice.
**Version info:** none in the message.

**Step 1.4 — Hidden bug fix?**
Record: **No disguise.** This is an explicit missing-keymap fix /
hardware enablement, not cleanup dressed as a fix.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: **1 file**, `drivers/platform/x86/asus-nb-wmi.c`, **+1 / −0**.
Function/object: static table `asus_nb_wmi_keymap[]`. **Single-file
surgical table insertion.**

**Step 2.2 — Flow**
Record: **Before:** WMI notify → `sparse_keymap_report_event()` misses
0x8b → log + drop.
**After:** same path reports `KEY_PROG3` (code 202) as a bindable key.
Path: firmware WMI event on key press (normal input path, not
error/init).

**Step 2.3 — Bug mechanism**
Record: **Hardware workaround / keymap gap** (same family as device-ID /
input quirk table rows). Not UAF, leak, race, or crash. Unmapped sparse-
keymap code is ignored.

**Step 2.4 — Fix quality**
Record: **Obviously correct** for a static `key_entry`. Minimal. No API,
lock, or alloc change.
**Regression risk:** low. Theoretical: some other ASUS model could emit
WMI 0x8b for a different function. 0x8b sat in a hole between 0x8A
(2012) and 0x8C (2012) with no mapping for ~14 years, so that is
unlikely.
**Note (not a blocker):** `hid-asus.c` maps HID usage 0x8b to
`KEY_PROG1` (“ProArt Creator Hub”). This commit uses `KEY_PROG3` and
states PX13 has no HID scancode, so this model should not double-report.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Neighbor entries 0x8A / 0x8C from **a935eaecef2b20 /
24c8a4c4ba6cfe (2012)**. Driver table since **b229ece9911cc (2011)**.
The 0x8b row is **6303451189a6d** (this commit, 2026-07-19).
`KEY_PROG3` for Armoury: **f56e676a7f1ca** (`v5.19-rc7~…`).

**Step 3.2 — Fixes: tag**
Record: **N/A** — no `Fixes:`. This fills a table gap for hardware, not
a regression from a prior commit.

**Step 3.3 — File history**
Record: Recent related work: DMI quirks, display-toggle keymap
(`e521dc1687834`), ExpertBook keys (`3c75dc44ad11c`). Pattern of one-
line keymap rows is established. **Standalone**, not `N/M`.

**Step 3.4 — Author**
Record: Nizar Al-Kabbani’s only hit under `drivers/platform/x86/` here
is this commit (hardware owner, not maintainer). Weight comes from
**Denis Benato** and **Ilpo Järvinen**.

**Step 3.5 — Dependencies**
Record: **None.** Needs existing `asus_nb_wmi_keymap[]`, `KEY_PROG3`,
and `sparse_keymap_setup()`. All present. **Applies standalone.**

Commit **6303451189a6d** is an ancestor of HEAD (`git merge-base --is-
ancestor` succeeded). First contained in **v7.3-rc1**
(`v7.3-rc1~63^2~75`). **Not in v7.2.** Merged via `platform-
drivers-x86-v7.3-1`.

---

## Phase 4: Mailing list / external

**Step 4.1 — b4 dig**
Record: Lore: `https://patch.msgid.link/20260719090843.66777-1-
nizar.m.kabbani@gmail.com`
**v1 only** (single `[PATCH]`, applied as submitted).
Denis: `Reviewed-by` only, no NAK.
Ilpo: applied to `review-ilpo-next`; noted for-next routing (not a same-
cycle regression). **No Cc: stable in review.**

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Corentin Chary, Luke D. Jones, Denis Benato, Hans de Goede, Ilpo
Järvinen, `platform-driver-x86@`, `linux-kernel@`. Right maintainers.

**Step 4.3 — Bug report**
Record: No bugzilla/syzbot. Author describes the unknown-key log from
the PX13. WebFetch of lore URLs returned **403**; thread recovered via
`b4 dig -m`.

**Step 4.4 — Series**
Record: **Standalone v1.** No companion patches.

**Step 4.5 — stable@**
Record: No stable-list discussion found for this subject.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: Table `asus_nb_wmi_keymap[]` only (not a function body).

**Step 5.2 — Callers**
Record: `.keymap = asus_nb_wmi_keymap` on `asus_nb_wmi_driver`.
`asus_wmi_input_init()` → `sparse_keymap_setup(..., keymap)`.
`asus_wmi_notify()` → `sparse_keymap_report_event()`; miss → `"Unknown
key code 0x%x"`.

**Step 5.3 — Callees**
Record: `sparse_keymap_report_event` / `sparse_keymap_setup` only. No
alloc/lock/I/O in the new row.

**Step 5.4 — Reachability**
Record: Firmware WMI interrupt/notify on physical ProArt key. Userspace
sees an evdev event after the fix. Not a syscall bug. Unprivileged user
with the laptop can press the key.

**Step 5.5 — Similar patterns**
Record: Same driver: 0x86 `KEY_PROG1` (MyASUS), 0x38 /
`ASUS_WMI_KEY_ARMOURY` `KEY_PROG3`, many other `KE_KEY` rows. hid-asus
HID 0x8b → `KEY_PROG1` for PX Creator Hub (different transport).

---

## Phase 6: This checkout

**Step 6.1 — Local tree**
Record: `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**. `make
kernelversion` = **7.3.0-rc4**. Makefile `VERSION=7 PATCHLEVEL=3
SUBLEVEL=0 EXTRAVERSION=-rc4`.
Driver and keymap **exist**. Line 635 already has `{ KE_KEY, 0x8B, {
KEY_PROG3 } }`. The pre-fix gap (0x8A then 0x8C) exists in **v7.2**;
this 7.3-rc tree already includes the row because the commit landed in
**v7.3-rc1**. That is mainline history, not a “already selected for
stable” marker.

**Step 6.2 — Backport difficulty**
Record: **Clean apply** on a tree with this keymap (context around
0x8A/0x8C is the same as v7.2). One-line insert.

**Step 6.3 — Related fixes here**
Record: No alternate fix. This is the mapping. No other 0x8b WMI
handling in `asus-nb-wmi.c`.

---

## Phase 7: Subsystem

**Step 7.1**
Record: **platform/x86 laptop hotkeys**. **PERIPHERAL / vendor-driver**,
but `CONFIG_ASUS_NB_WMI` is common on ASUS x86 notebooks.

**Step 7.2**
Record: **Active** (recent DMI quirks and keymap rows through 2026).
Table format itself is mature (2011).

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: **Driver-specific / hardware-specific:** ASUS notebooks that
emit WMI 0x8b (documented: ProArt PX13 HN7306). Harmless no-op elsewhere
(code never generated).

**Step 8.2 — Trigger**
Record: Press the ProArt key. Common for owners of that model; **not** a
race. Physical access only.

**Step 8.3 — Failure mode**
Record: **Dead key + `pr_info`**. No oops, hang, corruption, or UAF.
**Severity: LOW** as a crash class; **real functional hardware miss**
for that laptop.

**Step 8.4 — Ratio**
Record: **Benefit: moderate for those users** (key becomes bindable;
only kernel path that can do it). **Risk: very low** (1 line, static
table). **Ratio: favorable**, same as device-ID / keymap rows stable
already takes.

---

## Phase 9: Synthesis

**For backporting**
- One-line keymap row; reviewed by pdx86 maintainer and ASUS-WMI
  reviewer; v1 applied unchanged
- Real user-visible miss: unknown WMI code, key does nothing; WMI-only
  on this model
- Same shape as device IDs / input quirks / historical `asus-nb-wmi`
  keymap additions (`33e21e56243eb` MyASUS, `e521dc1687834` display
  toggle, `f56e676a7f1ca` Armoury `KEY_PROG3`)
- `Documentation/process/stable-kernel-rules.rst`: hardware quirk / “oh,
  that’s not good”, and device-ID-class table additions
- No new API (`KEY_PROG3` already in uapi); no series dependency
- Surrounding driver/keymap exist in this tree; patch applies cleanly

**Against**
- Not a crash, security hole, deadlock, or data corruption
- Enablement for one model, not a regression
- Ilpo took it via for-next, not as an urgent regression
- hid-asus uses `KEY_PROG1` for HID 0x8b ProArt Creator Hub (userspace
  binding may differ across models; reviewers accepted `KEY_PROG3`)

**Unresolved**
- Lore HTML 403; mbox contents were used instead
- Cannot prove no other ASUS SKU uses WMI 0x8b for something else (long-
  standing hole makes that unlikely)
- No stable@ thread

**Stable rules checklist**
1. Obviously correct and tested? **PASS** — one table row; maintainer
   review; author on PX13
2. Real bug that affects users? **PASS** — dedicated key dead without
   the mapping
3. Important (crash/security/corruption/deadlock)? **PASS as hardware
   quirk / device-ID-class**, not as a panic
4. Small and contained? **PASS** — +1 line, one file
5. No new features/APIs? **PASS** — existing `KEY_PROG3`; no new
   syscall/sysfs
6. Can apply to this tree? **PASS** — keymap context matches; no extra
   commits needed

**Exception:** hardware keymap / input quirk table entry (device-ID
analogue).

This tree is **7.3-rc4**, which already contains the row via v7.3-rc1.
That does not change technical merit: the driver is here, the change is
a one-line hardware table fix, and it is the kind of addition stable
accepts. It is not a new driver, not an API, and not a refactor.

### What it solves for stable users
ProArt PX13 owners on a stable kernel with `asus-nb-wmi` get a working,
bindable ProArt key instead of a dmesg-only unknown code. Risk is a
single unused WMI code gaining `KEY_PROG3` globally in this driver.

### Verification
- **[Phase 1]** Parsed commit `6303451189a6d`; tags as above; no
  Fixes/stable/syzbot
- **[Phase 2]** `git show`: +1 line in `asus_nb_wmi_keymap[]`
- **[Phase 3]** blame 0x8A/0x8C = 2012; `git merge-base --is-ancestor
  6303451189a6d HEAD` = yes; `git describe --contains` =
  `v7.3-rc1~63^2~75`; not in v7.2
- **[Phase 3]** `git log --oneline --author='Nizar Al-Kabbani' --
  drivers/platform/x86/` = this commit only
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v1, lore msgid above, recipients
  listed, mbox has Denis Rb and Ilpo apply mail
- **[Phase 4]** WebFetch lore = 403; stable search = no thread for this
  patch
- **[Phase 5]** keymap used in `asus_nb_wmi_driver`; report path
  `asus_wmi_notify` @ `asus-wmi.c:4692`; unknown log @ 4694
- **[Phase 5]** hid-asus `case 0x8b` → `KEY_PROG1` (Amit Chaudhari,
  `831f70a5b93bd`)
- **[Phase 6]** `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; line
  635 already has the mapping; v7.2 file has 0x8A then 0x8C, no 0x8B
- **[Phase 7]** `CONFIG_ASUS_NB_WMI` in `drivers/platform/x86/Kconfig`
- **[Phase 8]** Failure = unknown key log + no evdev; severity LOW as
  crash, real as hardware enablement
- **UNVERIFIED:** whether any other ASUS model emits WMI 0x8b; lore HTML
  (403)

The change meets stable rules as a small, reviewed hardware
keymap/quirk, not as a crash fix.

**YES**

 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 8dad7bdb8f612..a840d16e063e0 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -622,6 +622,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x86, { KEY_PROG1 } }, /* MyASUS Key */
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0

