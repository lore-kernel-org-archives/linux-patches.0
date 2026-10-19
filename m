Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90514D3BE9;
	Mon, 19 Oct 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418528; cv=none; b=XRsiGO0uWFiqh35MUfEZGmimZ+T5ksYNa2o58yk2DDsbxG5AN/9nRCbUjzhpuYHKzbG4PPkmvn7r2dNAE7dqn0QFEAHlUkwwm0oTiLzD9xlV4ua28C/ghxcb1cebnX7GW6wekZDxcSUWkR7qYelBgLKultKsj/cakqIhlQabikY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418528; c=relaxed/simple;
	bh=nE5FfG+pYYTPC0OyKRgz53QvfymAYOB+VQIEBp0O3+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSX4TvG974YWddgH1eJgK6fPVVY5ZhEkKYh7PHZaeDrHIqjRC2R77WAC7on5TVn2PsDlP45ar+sdJm4k4VMzHodLVM32N4aBad9sYgGj636QUrQRsWqAxGLJHAiuksgq7IwuRDGOso0nJ65+US3kMDf8QbgPg+4gzd8/ki/wuTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSxwNkGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSxwNkGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB9D1F000C7;
	Mon, 19 Oct 2026 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418525;
	bh=L+ibHOfY5KmiuXXJl1hb6K9QV4mQ1gl7KNdsBLN1Wq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSxwNkGErqfgyoW74RbA3iDIXtvw9sq3JHTYSRqIIpQtyNiBY9EotjBjNIWCHrUmG
	 OY3zp8bDJ9k0SQUl3fW49mjAakpEeDY+vPW5im3ykDITxQhg74McUSY7M8ZLEXX1tT
	 XHg7aGzixEwtFS+8w68m4xRFWCldMgWlB2M7au5c4uodrkxhelr5eROBUGkTkNLYGr
	 G+L4ElhQPHA7m4sGtRtqUNhiJXB1AMaUmSaj8seCiBKBhXUJ014XmxeggNc2FNWquM
	 KRh2EUsMjbOWwjKe3rTMr7723ODG6l144Y6T1VPBI+bhO+GlgNn0qPkzQkhxgpYjXy
	 ZXguL7qvLRZQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gustavo Evgucci <monesss315@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: btusb: Add USB ID 13d3:3625 for MediaTek MT7922
Date: Mon, 19 Oct 2026 09:50:01 -0400
Message-ID: <20261019135441.1420968-310-sashal@kernel.org>
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

From: Gustavo Evgucci <monesss315@gmail.com>

[ Upstream commit 849a3bf1489093996859ba0c3c1c0cd314d6ff96 ]

The IMC Networks MT7922 Bluetooth adapter with USB ID 13d3:3625 is not
recognized as a MediaTek device because it is missing from the btusb
device ID table. As a result, btmtk firmware loading is never triggered
and the HCI reset command times out with -ETIMEDOUT.

Add the device with BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH flags,
consistent with the neighboring 13d3:3627, 13d3:3628 and 13d3:3630
entries which use the same chip.

Tested on: MediaTek MT7922 (Wi-Fi 6E combo card, IMC Networks BT USB
interface), kernel 7.0.11-arch1-1.

/sys/kernel/debug/usb/devices:

T:  Bus=01 Lev=01 Prnt=01 Port=12 Cnt=03 Dev#=  4 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3625 Rev= 1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000
C:* #Ifs= 3 Cfg#= 1 Atr=e0 MxPwr=100mA
A:  FirstIf#= 0 IfCount= 3 Cls=e0(wlcon) Sub=01 Prot=01
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
I:  If#= 2 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS=  64 Ivl=125us
I:* If#= 2 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=8a(I) Atr=03(Int.) MxPS= 512 Ivl=125us
E:  Ad=0a(O) Atr=03(Int.) MxPS= 512 Ivl=125us

Signed-off-by: Gustavo Evgucci <monesss315@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a two-line USB ID addition for an existing MediaTek btusb path.
The local tree is **6.18.53** (`pending-6.18`); `13d3:3625` is missing
here, while neighboring MediaTek IDs and `BTUSB_MEDIATEK` setup already
exist.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: [Bluetooth / btusb] [Add] [USB ID 13d3:3625 for MediaTek MT7922]
- Subsystem: Bluetooth USB driver (`btusb`)
- Action verb: **Add** (device ID to an existing driver)
- Claimed intent: enable an IMC Networks / MediaTek MT7922 adapter that
  is already bound by generic Bluetooth USB matching but is not treated
  as MediaTek

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none as a tag; body says tested on kernel
  7.0.11-arch1-1
- **Reviewed-by:** Paul Menzel `<pmenzel@molgen.mpg.de>`
- **Acked-by:** none
- **Link:** none in the commit message
- **Cc: stable:** none (expected)
- **Signed-off-by:** Gustavo Evgucci `<monesss315@gmail.com>` (author);
  Luiz Augusto von Dentz `<luiz.von.dentz@intel.com>` (Bluetooth
  maintainer)
- Ignore: any pipeline “Upstream commit …” / Sasha Levin SOB if present

Notable: maintainer SOB plus an independent Reviewed-by. Bluetooth CI
(bluez.test.bot) ran on v1 and v2.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** USB ID `13d3:3625` is missing from the btusb ID/quirks table,
  so the adapter is not flagged `BTUSB_MEDIATEK`.
- **Symptom:** MediaTek firmware load (`btmtk`) never runs; HCI reset
  times out with `-ETIMEDOUT` (`Opcode 0x0c03 failed: -110` in user
  reports).
- **Root cause:** generic Bluetooth class match binds `btusb` with
  `driver_info == 0`; MediaTek setup is skipped.
- **Fix:** add `{ USB_DEVICE(0x13d3, 0x3625), .driver_info =
  BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH }` next to
  `13d3:3627/3628/3630`.
- **Version info:** tested on 7.0.11-arch1-1;
  `/sys/kernel/debug/usb/devices` dump included (vendor 13d3, product
  3625, Manufacturer=MediaTek Inc., class e0/01/01, Driver=btusb).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit hardware ID addition.
That is a documented stable exception: new device IDs on an existing
driver. It also fixes a real functional failure (HCI timeout, adapter
unusable).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/bluetooth/btusb.c` only
- Scope: **+2 lines** in `quirks_table[]` (single-file surgical ID add)
- Functions: none; static `usb_device_id` table only
- Classification: single-file device ID addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `13d3:3625` is absent from `quirks_table`. Probe matches
  generic `{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) }` in `btusb_table` with
  empty `driver_info`. `btusb_probe()` only consults `quirks_table` when
  `!id->driver_info` (lines 4064–4069). No MediaTek match →
  `hdev->setup` is not set to `btusb_mtk_setup`.
- **After:** `usb_match_id(intf, quirks_table)` hits the new entry.
  `id->driver_info & BTUSB_MEDIATEK` is true, so probe sets `hdev->setup
  = btusb_mtk_setup` and related MTK callbacks (lines 4244–4258).
  `BTUSB_WIDEBAND_SPEECH` sets `HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED`
  (lines 4344–4345).
- Path affected: probe/init of this USB ID only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Hardware workaround / device ID addition (category h)**
- Broken: MediaTek combo card enumerates as generic Bluetooth USB;
  firmware is never loaded; HCI reset times out.
- Fix: same flags as neighboring IMC/MediaTek entries already in this
  tree.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: two-line table entry matching established pattern.
- Minimal; no unrelated edits; no API/locking/data-structure change.
- Regression risk: **very low**, scoped to VID/PID 13d3:3625. Wrong
  flags would only affect that device; flags match 3627/3628/3630.
- Chip naming is slightly inconsistent in history (3627 subject says
  MT7925, body says MT7922); **flags are the same**, so the driver path
  is identical.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Insertion sits between `13d3:3613` (Youn Mélois, 2025-04-01,
  `bbf56029322c06`) and `13d3:3627` (Chris Lu, 2025-09-04,
  `576952cf981b7`).
- This is not a regression in old code; it is a **missing ID** for
  hardware that uses the long-standing MediaTek path.
- MT7922 USB support: `8c0401b7308cb` (“Bluetooth: Add support for
  MediaTek MT7922 device”), contained in v6.11-rc1 era. Present in this
  6.18 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The “bug” is omission of this
VID/PID, not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- This tree already has many of the same class of commits, including:
  - `576952cf981b7` 13d3/3627
  - `f63f401130e5c` 13d3/3628
  - `5bd5c716f7ec3` 13d3/3630
  - `70cd38d22d465` 13d3/3633 for MT7922
- Candidate `ddd25808d4c2` is **not** an ancestor of HEAD (`git merge-
  base --is-ancestor` exit 1).
- Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author="Gustavo Evgucci" -- drivers/bluetooth/` is
empty in this tree. Author is a first-time hardware-ID contributor, not
the subsystem maintainer. Weight comes from Luiz’s merge and Paul
Menzel’s Reviewed-by.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `quirks_table`, `BTUSB_MEDIATEK`, `BTUSB_WIDEBAND_SPEECH`, and
  `btusb_mtk_setup`. All exist here.
- `CONFIG_BT_HCIBTUSB_MTK` exists (`drivers/bluetooth/Kconfig`).
- No extra commits required.
- Can apply standalone. Parent of `ddd25808d4c2` also has `13d3:3609`,
  which this 6.18 tree lacks; that is **context only**. Insertion
  between 3613 and 3627 is valid here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c ddd25808d4c2` matched patch-id
  `ce1685f940593b167015292f6b73b7f2fc9ec8d9`
- Lore/msgid:
  https://patch.msgid.link/20260625083230.300651-1-monesss315@gmail.com
- Thread saved to `/tmp/btusb-3625.mbox` (7 messages)
- **v1** (2026-06-23): `[PATCH] Bluetooth: btusb: Add IMC Networks
  MT7922 device 0x13d3:0x3625`
- **v2** (2026-06-25): added usb/devices dump, Reviewed-by, full
  maintainer To/Cc. **Code hunk unchanged.**
- Applied to bluetooth-next as `ddd25808d4c2` by Luiz (patchwork-bot,
  2026-06-26).
- Review: Paul Menzel asked for usb/devices dump and get_maintainer.pl
  recipients; then Reviewed-by. **No NAK.**
- Bluetooth CI: v1 all PASS; v2 GitLint FAIL only for an 82-char notes
  line. Builds passed.
- No reviewer asked for `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`):
- Gustavo Evgucci (author)
- Luiz Augusto von Dentz (Bluetooth driver maintainer)
- Marcel Holtmann (Bluetooth maintainer)
- linux-bluetooth@, linux-kernel@
- Paul Menzel (reviewer)
Appropriate maintainers were on the thread; Luiz applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- User-tested on real hardware with a full usb/devices dump.
- External confirmation: DKMS workarounds for Mercusys MA80XE / IMC
  Networks `13d3:3625` (`hci0: Opcode 0x0c03 failed: -110`). That
  matches the commit’s -ETIMEDOUT description.
- Not syzbot; hardware enablement with a concrete timeout.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single-patch series (v1 → v2 documentation only). Neighboring
IDs already in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No useful stable@ thread found (lore.kernel.org/stable WebFetch
blocked by anti-bot). Absence of prior stable discussion is not a
negative signal for a device-ID add.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP: not available. Used grep/read.

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No functions modified. Data: `quirks_table[]`. Consumers:
`btusb_probe()`.

**Step 5.2: TRACE CALLERS**

Record:
- `btusb_probe()` ← USB core when `btusb` matches.
- Generic match: `btusb_table` `{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) }`
  (line 83), which matches this device’s If#0 Cls=e0 Sub=01 Prot=01.
- Then `usb_match_id(intf, quirks_table)` when `driver_info` is 0.

**Step 5.3: TRACE CALLEES**

Record: With the new flags, probe assigns `btusb_mtk_setup`,
`btusb_mtk_shutdown`, `btmtk_reset_sync`, `btmtk_set_bdaddr`,
`btusb_send_frame_mtk`, USB suspend/resume/disconnect MTK hooks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace-reachable: plug in / boot with the adapter.
Unprivileged users do not need a special syscall; udev/bluetoothd open
the HCI device. High priority for owners of this card. Not a universal
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Dozens of `USB_DEVICE(0x13d3, …) … BTUSB_MEDIATEK |
BTUSB_WIDEBAND_SPEECH` entries. Same pattern as 3627/3628/3630 already
in this file. Systematic missing-ID class, not a one-off logic bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: `git describe HEAD` → `p-6.18-1-g03b85e06ca9bf`; `make
  kernelversion` → **6.18.53**; branch `pending-6.18`.
- `13d3:3625` is **not** in `drivers/bluetooth/btusb.c` (`rg` found only
  unrelated Realtek `0x3625:0x010b`).
- `quirks_table` MediaTek block **is** here, with 3613 then 3627 (lines
  787–794).
- Neighbor commits 3627/3628/3630 **are** ancestors of HEAD.
- Candidate `ddd25808d4c2` is **not** an ancestor of HEAD.
- Driver support for MT7922 has been in this lineage since ~v6.11
  (`8c0401b7308cb`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean / minor context fuzz.** Candidate parent has extra
`13d3:3609` above 3613; 6.18 does not. Added lines themselves match. No
refactor of `quirks_table` vs probe matching.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other 13d3:3625 MediaTek entry. `d9da920233ec8` is Realtek
`3625:010b` (different vendor). Not a duplicate.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: [drivers/bluetooth/btusb.c] [IMPORTANT]
- Common USB Bluetooth driver, not core mm/fs.
- MediaTek Wi-Fi 6E combo cards are widely used (laptops, USB adapters).
  Device-specific, but the class of fix is standard for stable.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Active. Recent 6.18 history includes many VID/PID adds and btusb
bugfixes. ID table is the normal place for this change.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Users of USB Bluetooth `13d3:3625` (IMC Networks / MediaTek
MT7922, e.g. combo cards / Mercusys MA80XE). Others unchanged. Requires
`CONFIG_BT_HCIBTUSB` and typically `CONFIG_BT_HCIBTUSB_MTK`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every probe of this device (boot or plug-in). Not a race. Not
unprivileged exploit; the device simply does not work. Reproduced by the
author and by out-of-tree DKMS users.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: [Bluetooth adapter fails HCI reset / -ETIMEDOUT; no controller]
[HIGH for affected hardware, LOW globally]
- Not a panic/UAF, but the device is dead without the ID. That is the
  usual severity for missing USB IDs.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for holders of this adapter on 6.18; zero for
  everyone else.
- **Risk:** Very low (2 lines, existing flags, existing probe path).
- **Ratio:** Strongly favors backport. This is the textbook new-device-
  ID exception.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Explicit stable exception: new USB ID on an existing driver
- Real user-visible bug: HCI reset -ETIMEDOUT, adapter unusable
- 2-line, obviously correct, same flags as 3627/3628/3630 already in
  this tree
- MTK setup path (`btusb_mtk_setup`) present
- Reviewed-by Paul Menzel; merged by Luiz von Dentz; CI built
- Author tested on hardware; usb/devices dump matches
- Independent DKMS users hit the same ID/symptom
- Applies with at most minor context adjustment (missing 3609)

AGAINST:
- Not a crash/security/corruption bug (hardware enablement)
- Author is not a regular Bluetooth contributor
- Chip labeled MT7922 vs some neighbor commits saying MT7925 (flags
  still match)
- No Cc: stable (not a negative under these rules)

UNRESOLVED:
- lore.kernel.org HTTP 403 for WebFetch; thread recovered via `b4 dig
  -m`
- No stable@ discussion found (search not useful)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — 2-line ID; hardware test;
   reviewer + maintainer
2. Fixes a real bug that affects users? **PASS** — missing ID → firmware
   never loads → HCI timeout
3. Important issue? **PASS** under the device-ID exception; adapter
   otherwise unusable
4. Small and contained? **PASS** — +2 lines, one table
5. No new features or APIs? **PASS** — ID only; no new driver/API
6. Can apply to the local tree? **PASS** — insertion point 3613/3627
   exists; 3625 absent

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Device ID addition to existing driver** — automatic YES
category.

**Step 9.4: MAKE YOUR DECISION**

Backport to this 6.18 tree. The bug exists here, the MediaTek path
exists here, neighboring IDs exist here, and the change is a two-line
USB ID with the established flags.

---

**What the commit solves for this tree**

On 6.18.53, `13d3:3625` still matches only the generic Bluetooth USB
class, so `btusb_probe()` never sets `BTUSB_MEDIATEK` and never calls
`btusb_mtk_setup`. HCI reset then times out. Adding the quirks_table
entry with `BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH` is the same
enablement already used for 3627/3628/3630 in this file.

**Risk vs benefit**

Benefit is making this MediaTek/IMC adapter work; risk is confined to
that VID/PID. No locking, no API, no refactor.

**Concerns**

Parent context includes `13d3:3609`, which 6.18 does not have. Insert
between existing 3613 and 3627. No other prerequisites.

Verification:
- [Phase 1] Parsed subject/tags/body from `git show -s ddd25808d4c2` and
  the supplied message: Add USB ID; Reviewed-by Paul Menzel; SOB Luiz;
  no Fixes/Cc stable
- [Phase 2] Diff: +2 lines in `quirks_table`; confirmed `btusb_probe`
  uses that table when `!id->driver_info` (btusb.c:4064–4069); MTK setup
  at 4244–4258; WBS quirk at 4344–4345
- [Phase 2] Generic match `USB_DEVICE_INFO(0xe0, 0x01, 0x01)` at line 83
  matches the dumped interface class
- [Phase 3] `git describe HEAD` / `make kernelversion`: p-6.18-1 /
  6.18.53
- [Phase 3] `git merge-base --is-ancestor ddd25808d4c2 HEAD` → not
  ancestor; 3627/3628/3630 commits are ancestors
- [Phase 3] `rg 0x3625 drivers/bluetooth/btusb.c`: no 13d3:3625; only
  Realtek 3625:010b
- [Phase 3] blame 785–796: 3613/3627/3628/3630 present as described
- [Phase 3] MT7922 intro `8c0401b7308cb` contained around v6.11-rc1;
  present in this tree
- [Phase 3] author log empty in drivers/bluetooth/
- [Phase 4] `b4 dig -c ddd25808d4c2` → msgid 20260625083230.300651-1;
  v1+v2; applied as ddd25808d4c2
- [Phase 4] `b4 dig -a`: v1 then v2 (docs only); `b4 dig -w`: Luiz,
  Marcel, linux-bluetooth, Paul Menzel
- [Phase 4] mbox: Paul Reviewed-by; CI pass (v2 gitlint notes-line
  only); no NAK
- [Phase 4] lore WebFetch 403; used b4 mbox instead. Stable list search:
  no relevant hit
- [Phase 5] semcode unavailable; callers via grep: quirks_table →
  btusb_probe only
- [Phase 6] 3613 and 3627 present, 3625 absent — insertion point
  verified in this checkout
- [Phase 8] Failure mode: HCI -ETIMEDOUT / no controller for this USB
  ID; not a kernel oops
- UNVERIFIED: live lore.kernel.org HTML of the thread (403); chip MT7922
  vs MT7925 labeling of neighbors (flags verified identical)

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 59fff918fd2de..9257341b01399 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -788,6 +788,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3613), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3625), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3627), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3628), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

