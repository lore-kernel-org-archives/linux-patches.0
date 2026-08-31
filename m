Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7760159B661;
	Mon, 31 Aug 2026 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184310; cv=none; b=Df4U76uY5jeRUZH90h6dwJLFoX1uV1fL8sHjR7GmS4unHlAxyd0J54m84zrz6+Rr/QL1RnnlWVn0515HFA5wxyC1OyY8z95ib0xDZDsQXrg/QlUtSTgZQhzm7ptqJV1jUDRtrbKcz/u+AnkZH9JOWkJKr8kvtN99p1rsDsbKOYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184310; c=relaxed/simple;
	bh=0Lqvx76bAMS2OOgnmLJAHv86p3EVTdj6Q6+h8uCaaSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rkka351rl4TdlSuy7RQ4zjjha7Jm4+Sf87pyVxYJVDff+kQcJhKjUoDeDkP+wqZKdiverebhEjbNAfvegh4DwVvlGWCfOVa1fVnlcgJMQho4LZYD0klj/ZXT19/DYh2iJsT0cBD+6bEtt05LY+mxq2i5Qxx7IkIPZQfX2SP8YTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JO9FwyMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JO9FwyMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99D11F00A3F;
	Mon, 31 Aug 2026 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184307;
	bh=iKSMiXpkxJLEdJewUwowyjhE1Sbdpid/o/O6lPwwdgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JO9FwyMqAHIGtw/o988Ugqpbx7RwW/8Ba8srRFb1MNwxp/eOnvioQO9kdimOg+Iu3
	 XnIJ15RgxKeI4TM5KIHu0uXtFF98XVkYgu6AInct49pd7oSSkFh1npb11pEZZWdg4R
	 v8cEuNB3+TNZf1Vq0pwOuZwBGAgNlAF/3kj21mxk9DVv5sbQFHtfpeBnAYfm14zkmy
	 fdF5Zfk20Gjuh3AIOp8D7lRKURZe1ahlkuiNiHvAfZJZxAQAZQl3J/UQiWOdyyVQ/J
	 zUV2MsHhVAizVWXAWZfs14CQJr3dTNz36pXY9A+w0U7STxcqwDDC1WxXJpd0N3NmOA
	 Zw2+mYpFPw9JA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Volckaert <janvolck@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bjorn@mork.no,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: usb: qmi_wwan: add MeiG SRM813Q
Date: Mon, 31 Aug 2026 09:30:42 -0400
Message-ID: <20260831133314.4125787-614-sashal@kernel.org>
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

From: Jan Volckaert <janvolck@gmail.com>

[ Upstream commit 9758c11fc6c138a79a28a5659feeaa3abde7aa6a ]

Add support for the Qualcomm Technology Snapdragon X35-based MeiG SRM813Q
module.

The module can be put in different modes via AT commands
to enable/disable GPS functionality:

MODEM - PPP mode(2dee:4d63): AT+SER=1,1

If#= 0: RMNET
If#= 1: DIAG/ADB
If#= 2: MODEM
If#= 3: AT

P:  Vendor=2dee ProdID=4d63 Rev=05.15
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=1bd51f0e
C:  #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

NMEA mode(2dee:4d64): AT+SER=51,1

If#= 0: RMNET
If#= 1: DIAG/ADB
If#= 2: NMEA
If#= 3: AT

P:  Vendor=2dee ProdID=4d64 Rev=05.15
S:  Manufacturer=MEIG
S:  Product=LTE-A Module
S:  SerialNumber=1bd51f0e
C:  #Ifs= 4 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
I:  If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms

Signed-off-by: Jan Volckaert <janvolck@gmail.com>
Link: https://patch.msgid.link/20260517153237.55995-2-janvolck@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: usb: qmi_wwan]` `[add]` — Add USB device ID table
entries for the MeiG SRM813Q LTE modem (Snapdragon X35-based) to the
existing `qmi_wwan` driver.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260517153237.55995-2-janvolck@gmail.com`
  (patch 2/2 in series)
- **Cc: stable@vger.kernel.org** — not present on this commit (the
  companion `option.c` patch in this tree does have it)
- **Signed-off-by:** Jan Volckaert `<janvolck@gmail.com>` (author),
  Jakub Kicinski `<kuba@kernel.org>` (netdev maintainer)
- **Notable:** Maintainer sign-off from Jakub Kicinski; detailed
  `lsusb`-style descriptors for two USB product IDs (`2dee:4d63`,
  `2dee:4d64`); patch 2 of 2 (companion is `USB: serial: option: add
  MeiG SRM813Q`)

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug description:** Not a kernel crash/corruption bug. The MeiG
  SRM813Q modem exposes its RMNET/QMI data interface on USB interface #0
  (`Prot=50`, driver `qmi_wwan`), but without table entries the kernel
  will not bind `qmi_wwan` to this device.
- **Symptom:** Users with this modem get no `wwan0`/RMNET network
  interface; cellular data does not work. Serial/DIAG/AT ports are
  handled separately by the `option` driver.
- **Root cause:** Missing `usb_device_id` entries in `qmi_wwan.c` for
  vendor `0x2dee`, products `0x4d63` (Modem/PPP mode) and `0x4d64` (NMEA
  mode).
- **Version info:** None stated; hardware is new (Snapdragon X35, USB
  3.20).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not a hidden bug fix. This is explicit **hardware
enablement** — a new device ID addition to an existing driver. No error-
path, locking, refcount, or memory-safety changes.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/net/usb/qmi_wwan.c` — +2 lines
- **Functions modified:** `products[]` USB device ID table only (static
  data, no function body changes)
- **Scope:** Single-file, surgical device ID addition

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (products[] table):** Before → device not matched by
  `qmi_wwan`; QMI interface #0 left unbound. After → `qmi_wwan` binds to
  interface #0 for `2dee:4d63` and `2dee:4d64`, using
  `QMI_QUIRK_SET_DTR` (same pattern as Quectel, SIMCom, u-blox entries
  on interface 0).
- **Execution path:** USB device enumeration / driver probe at plug-in
  time.

### Step 2.3: Bug Mechanism
**Record:** Category **h) Hardware workarounds / device ID addition**.
Without entries, `qmi_wwan` never probes the RMNET interface. The
`QMI_QUIRK_SET_DTR` flag ensures proper DTR/power management during bind
(consistent with other Qualcomm-based modems lacking auto-DTR).

### Step 2.4: Fix Quality
**Record:** Obviously correct — interface #0 confirmed by commit message
`lsusb` output (`Driver=qmi_wwan` on `If#= 0`). Minimal change.
Regression risk very low: only affects devices with these specific
VID/PID pairs that currently have no `qmi_wwan` binding at all.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Insertion point is immediately after
`{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)}` (MeiG SRM825L), introduced by
commit `1ca645a2f74a4` (Aug 2024). The SRM813Q entries are new; no pre-
existing buggy code to blame.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Recent `qmi_wwan.c` changes in this tree are predominantly
similar device-ID additions (Telit, Quectel, Fibocom, MeiG SRM825L). The
companion `option.c` patch (`38ba1a464c0d1`, upstream `7d2b37d3e42d`) is
**already present** in this tree. The `qmi_wwan` half is **not yet** in
this tree — creating a half-enabled state for SRM813Q users.

### Step 3.4: Author Context
**Record:** Jan Volckaert submitted the companion `option.c` patch
(already merged here with `Cc: stable@vger.kernel.org`). Jakub Kicinski
(netdev maintainer) signed off on the `qmi_wwan` patch per commit
message.

### Step 3.5: Dependencies
**Record:** Part of a 2-patch series with `USB: serial: option: add MeiG
SRM813Q`. The `option` half is already in v6.18.44. This `qmi_wwan`
patch is standalone (applies independently) but functionally completes
modem support. No structural/API prerequisites beyond existing
`QMI_QUIRK_SET_DTR` macro and `qmi_wwan` driver.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Link points to `20260517153237.55995-2-janvolck@gmail.com`
(patch 2/2). `b4 dig -c` could not match this commit (not yet in local
git). `WebFetch` and `curl` to lore.kernel.org returned 403/bot
protection — discussion content **unverified**. Patch series structure
(2/2) confirmed from message ID.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 (commit not in tree). Jakub Kicinski
Signed-off-by confirms netdev maintainer acceptance.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or user crash report.
Hardware enablement driven by author testing with physical device
(`lsusb` descriptors provided).

### Step 4.4: Related Patches
**Record:** Patch 1/2 (`option.c`, commit `38ba1a464c0d1`) already in
v6.18.44 with `Cc: stable@vger.kernel.org`. This patch 2/2 completes
RMNET data path support.

### Step 4.5: Stable List History
**Record:** UNVERIFIED (lore access blocked). Companion `option.c` patch
explicitly nominated for stable in this tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** Only `products[]` static table modified. Probe/bind handled
by existing `qmi_wwan_probe()` → `qmi_wwan_bind()`.

### Step 5.2: Callers
**Record:** USB core calls `qmi_wwan` probe during device enumeration
when VID/PID/interface match `products[]`. Standard hot-plug path for
USB modems.

### Step 5.3: Callees
**Record:** On bind with `QMI_QUIRK_SET_DTR`, existing code calls
`qmi_wwan_manage_power()` and `qmi_wwan_change_dtr()` — well-established
path for Qualcomm modems.

### Step 5.4: Reachability
**Record:** Triggered by plugging in MeiG SRM813Q USB modem. Common user
operation for cellular connectivity. Not syscall-triggered, but standard
device hotplug.

### Step 5.5: Similar Patterns
**Record:** Dozens of identical-pattern entries in `products[]` (e.g.,
`QMI_QUIRK_SET_DTR(0x2c7c, ...)`, `QMI_FIXED_INTF(0x2dee, 0x4d22, 5)`
for sibling MeiG SRM825L). Telit/Quectel additions in this tree
routinely carry `Cc: stable@vger.kernel.org`.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Exists?
**Record:** Yes — the **absence** of entries is the issue.
`drivers/net/usb/qmi_wwan.c` line 1454 has SRM825L (`0x2dee:0x4d22`) but
**not** SRM813Q (`0x4d63`, `0x4d64`). Meanwhile
`drivers/usb/serial/option.c` already has all six SRM813Q entries (lines
2472–2476). Half-enabled state confirmed.

### Step 6.2: Backport Complications
**Record:** Clean apply — `git apply --check` succeeded with zero
conflicts against current `qmi_wwan.c`.

### Step 6.3: Related Fixes Already Present?
**Record:** `option.c` SRM813Q support present (`38ba1a464c0d1`). No
`qmi_wwan` SRM813Q fix present. No duplicate.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/usb/` — IMPORTANT. USB WWAN/cellular modems
used in laptops, routers, IoT, embedded. Not core-kernel, but critical
for affected hardware users.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — frequent device ID additions and bug
fixes in `drivers/net/usb/` on this branch.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of MeiG SRM813Q (Snapdragon X35) USB LTE modules.
Config-dependent: `CONFIG_USB_NET_QMI_WWAN`. Currently broken for
cellular data on v6.18.44 despite partial `option` driver support.

### Step 8.2: Trigger Conditions
**Record:** Plug in MeiG SRM813Q modem. Deterministic, every time. No
privilege required beyond normal USB device access.

### Step 8.3: Failure Mode Severity
**Record:** No kernel crash/oops. **Functional failure** — no
RMNET/`wwan` network interface, no cellular data connectivity. Severity:
**MEDIUM** for affected users (device unusable for its primary purpose),
**LOW** globally (single modem model).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables cellular data on SRM813Q; completes support
  started by already-merged `option.c` patch. Standard stable device-ID
  backport.
- **Risk:** Very low — 2 lines, only matches specific VID/PID, no
  behavior change for any other device.
- **Ratio:** High benefit for affected users, negligible risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Explicit stable exception: new USB device IDs to existing driver
- 2-line, surgical, applies cleanly to v6.18.44
- Companion `option.c` patch already in tree with `Cc: stable`
- Without this, SRM813Q users lack `qmi_wwan`/RMNET — modem data path
  non-functional
- Maintainer (Jakub Kicinski) signed off
- Identical pattern to other stable-nominated `qmi_wwan` device
  additions in this tree

**AGAINST backport:**
- Not a crash/security/corruption fix
- Affects only one modem model (limited user population)
- No explicit `Cc: stable` on this specific commit message
- Mailing list discussion unverified

**UNRESOLVED:**
- Full lore review thread content
- Whether author tested RMNET connectivity end-to-end (descriptors
  strongly support correctness)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — descriptors match table
   entries; maintainer SOB; established macro pattern
2. Fixes real bug affecting users? **PASS** — hardware non-functional
   for data without it; completes half-merged series
3. Important issue? **PASS (MEDIUM)** — no crash, but primary device
   function broken for affected users
4. Small and contained? **PASS** — 2 lines, one file
5. No new features/APIs? **PASS** — device ID table only (stable
   exception category)
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception Category
**Record:** **NEW DEVICE IDs** — adding USB VID/PID entries to the
existing `qmi_wwan` driver. Textbook stable backport material.

### Step 9.4: Decision Rationale

For **v6.18.44**, this commit should be backported. It is a minimal
device ID addition that enables RMNET/cellular data on the MeiG SRM813Q
modem. The `qmi_wwan` driver and all required infrastructure already
exist in this tree. The companion `option.c` patch is already merged
here (with stable nomination), leaving users in a broken partial-support
state until this `qmi_wwan` half is also applied. This matches the
stable exception for new device IDs and follows the same pattern as
other `qmi_wwan` modem additions routinely backported to stable.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 1]** Confirmed patch 2/2 series structure from message ID
  `55995-2`
- **[Phase 2]** Diff analysis: +2 lines in `products[]`,
  `QMI_QUIRK_SET_DTR(0x2dee, 0x4d63/0x4d64, 0)`
- **[Phase 3]** `git describe HEAD` → `v6.18.44` (VERSION 6, PATCHLEVEL
  18, SUBLEVEL 44)
- **[Phase 3]** `git blame -L 1454,1454` → SRM825L added by
  `1ca645a2f74a4` (Aug 2024)
- **[Phase 3]** `git log --oneline -20 -- drivers/net/usb/qmi_wwan.c` →
  recent device-ID additions confirmed
- **[Phase 3]** `git show 38ba1a464c0d1` → companion `option.c` patch
  present with `Cc: stable@vger.kernel.org`
- **[Phase 3]** `git cat-file -t 7d2b37d3e42d` → upstream option commit
  exists in tree
- **[Phase 3]** `grep 0x4d63/0x4d64` in `qmi_wwan.c` → no matches (not
  yet present)
- **[Phase 4]** `b4 dig -c 1ca645a2f74a4` → found SRM825L lore link
  (wrong commit, expected)
- **[Phase 4]** `WebFetch`/`curl` lore.kernel.org → 403/bot blocked;
  thread content UNVERIFIED
- **[Phase 5]** Read `QMI_QUIRK_SET_DTR` macro and DTR quirk logic at
  lines 821–825, 938–958
- **[Phase 5]** `grep QMI_QUIRK_SET_DTR` → many similar entries confirm
  pattern
- **[Phase 6]** `grep SRM813Q/0x4d63` in `option.c` → 6 entries present
  (lines 2472–2476)
- **[Phase 6]** `grep SRM813Q/0x4d63` in `qmi_wwan.c` → only SRM825L
  (`0x4d22`), not SRM813Q
- **[Phase 6]** `git apply --check` on provided diff → applies cleanly
- **[Phase 7]** `git log --oneline -20 -- drivers/net/usb/` → active
  subsystem
- **[Phase 8]** Confirmed failure mode: no `qmi_wwan` bind → no cellular
  data (not a crash)
- **[Phase 9]** `git show e81a7f65288c7` → similar Telit addition has
  `Cc: stable@vger.kernel.org`

**YES**

 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 05acac10cd2ba..94cdb61dca83d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1452,6 +1452,8 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
 	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
+	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d63, 0)}, /* MeiG SRM813Q w/ Modem(PPP) */
+	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d64, 0)}, /* MeiG SRM813Q w/ NMEA */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.53.0

