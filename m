Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F01556FE2;
	Mon, 19 Oct 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418228; cv=none; b=I6Yoh8koSkmCxUbL7Og8sIusq/E8nQ1/nTwlMsSnHA07Rfb6ITq5dejNs2opeJlqbFG/XFs7cgyrcnkDekGL07Le9vB03Y+2XHb5O4drpNpDZWeVJm8VAv7j48+4OzWZS/BpHz6zeg74E7LItH7I6Y9oOUVXv/wZDdT3X8ZncTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418228; c=relaxed/simple;
	bh=yeCb1al2BCBgFbx6wfAyiaIkI8CN1Tuwop2o9ZU78Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eP6nM0h8GOmAyvXv9OjSthPxQkOEG9eRkXBRkbkU8GCpCjDU+qGZceRKNhsulzUPntXIauytXsTHHKCleNdcfX070WRPIJWr7dLQIaNg+OKJ3aDNdxqHlNcoXqR3vz3WjSCuDRjPu2rOQuLh6JVOd4xWqEBBdUgbCmXVJLaNu1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjybZ6Cv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjybZ6Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651B01F000C4;
	Mon, 19 Oct 2026 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418225;
	bh=q0WncpZ2lwOwyYBAfu9Lpl/1a+NyHwxI7yzZHen09Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjybZ6CvNawJUeRhiHYI90tPzSGbshL8ZltmOmoHGn52OPqvqvDyAlFTX45wCjuTd
	 ZKUymQ7JfBqvNEoJjtHg/X+2NwQQwplpT7w6iLk22XCv+OaTCzpOQwEAk45iWcSgEZ
	 LJy8W/Yl3G9IhybWfik0eixwXZ3CZSdKKkPdAIWTxkzffOWHD2SydSxkN/o7xxPOZn
	 CtRfLMwF74gE2UVf9RF7Z4kwRmXr0LKv2Wktyhcv++clRkk/GKU06W5etrlMMxQ3B2
	 eJDj+tAYpFVHDwVFVUCuP6UGk8fl0TLvOY932KkFruFfku660fnrTUngJ23oxa35JE
	 P96rgMXiwWxbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Reinhard Speyerer <rspmn@arcor.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bjorn@mork.no,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: usb: qmi_wwan: add Rolling Wireless RN947R
Date: Mon, 19 Oct 2026 09:46:32 -0400
Message-ID: <20261019135441.1420968-101-sashal@kernel.org>
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

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit 7375d38364a9aa66fb31716bcefef38aecad75d8 ]

Add Rolling Wireless RN947R 0x9300 composition:

DIAG + ADB + NMEA + MODEM + RMNET + QDSS + ADPL

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  6 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=33f8 ProdID=9300 Rev= 0.00
S:  Manufacturer=Rolling Wireless
S:  Product=RN947R
S:  SerialNumber=xxxxxxxxxxx
C:* #Ifs= 7 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=86(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 8 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=21 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=70 Driver=(none)
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#=22 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=80 Driver=(none)
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Link: https://patch.msgid.link/arZzuOOvLUZtdOlv@arcor.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line USB ID addition to the existing `qmi_wwan` driver for
Rolling Wireless RN947R (`33f8:9300`). That is a standard stable
exception, and the ID table plus DTR quirk already exist in this 6.18.y
tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [net: usb: qmi_wwan] [add] [USB device ID for Rolling Wireless
RN947R]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Link: https://patch.msgid.link/arZzuOOvLUZtdOlv@arcor.de
- Signed-off-by: Reinhard Speyerer <rspmn@arcor.de> (author)
- Signed-off-by: Jakub Kicinski <kuba@kernel.org> (netdev maintainer,
  applied)
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- No Cc: stable (expected)
- Ignored pipeline SOB / Upstream commit marker

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug description: RN947R USB WWAN modem (`Vendor=33f8 ProdID=9300`) is
  not in `qmi_wwan`’s ID table, so the RMNET/QMI network function does
  not bind.
- Symptom: no `qmi_wwan` netdev for this modem; cellular data does not
  come up out of the box.
- Version information: none stated.
- Root cause: missing USB ID / interface mapping. `lsusb -t`-style dump
  shows If#=8 Cls=ff Sub=ff Prot=50 as the QMI/RMNET function.
  Composition is DIAG + ADB + NMEA + MODEM + RMNET + QDSS + ADPL.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden crash/leak fix. It is an explicit device-ID
enablement, which stable rules treat as a first-class exception.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/net/usb/qmi_wwan.c` (+1 / -0)
- Function/table: `products[]` (`static const struct usb_device_id`)
- Scope: single-file, one-line surgical ID addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `33f8:9300` is unmatched; USB core does not probe `qmi_wwan`
  for interface 8.
- After: `QMI_QUIRK_SET_DTR(0x33f8, 0x9300, 8)` matches
  vendor/product/interface 8 and sets `qmi_wwan_info_quirk_dtr`.
- Path: USB enumeration / driver probe only. No error-path or hot-path
  logic change.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware enablement / USB device ID (stable exception 1).
- Mechanism: `QMI_QUIRK_SET_DTR` expands to
  `USB_DEVICE_INTERFACE_NUMBER` plus DTR quirk `driver_info`. Interface
  8 matches the dump (`Prot=50`, QMI/RMNET). DTR quirk is the same
  pattern as Rolling RW101 (`33f8:0104`) and other Qualcomm USB WWAN
  entries.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: VID/PID/interface taken from a real device dump;
  match is interface-number-specific so DIAG/ADB/NMEA/MODEM/QDSS/ADPL
  are not claimed.
- Minimal: one table entry, no API or structure change.
- Regression risk: very low; only `33f8:9300` is affected. Wrong
  interface number would be the main risk, and the dump confirms If#=8.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion sits next to Rolling RW101: `d362046021ea12`
  (“net:usb:qmi_wwan: support Rolling modules”, Vanillan Wang,
  2024-04-16).
- That RW101 ID is in this tree’s v6.18.57 base (`git merge-base --is-
  ancestor d362046021ea1 v6.18.57` succeeded).
- This is extending an existing vendor block, not introducing a new
  driver.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. This does not revert or repair a
prior logic bug.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent `qmi_wwan` history is dominated by the same class of ID
  additions (Quectel, Telit, MeiG, Fibocom, SIMCom).
- No prerequisite refactor is required; `products[]` and
  `QMI_QUIRK_SET_DTR` are long-standing.
- Standalone: subject is not “patch X/Y”. `b4 dig -a` shows a single v1
  patch.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Reinhard Speyerer has prior `qmi_wwan` ID/work in this history (e.g.
  Fibocom FG132 `64761c980cbf7`).
- Not the listed maintainer; maintainer is Bjørn Mork (`MAINTAINERS`:
  USB QMI WWAN NETWORK DRIVER). The patch was mailed to `bjorn@mork.no`.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Depends only on `QMI_QUIRK_SET_DTR` / `USB_DEVICE_INTERFACE_NUMBER`,
  both present.
- No companion `option.c` change is in this series. Serial AT/NMEA/DIAG
  auto-bind is separate; this patch alone still enables the WWAN netdev.
  Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 7375d38364a9aa66fb31716bcefef38aecad75d8` matched
  https://patch.msgid.link/arZzuOOvLUZtdOlv@arcor.de
- `b4 dig -a`: only v1, 2026-09-25, `[PATCH net] net: usb: qmi_wwan: add
  Rolling Wireless RN947R`
- Thread (saved via `b4 dig -m`): submission, then patchwork-bot
  “applied to netdev/net.git (main) by Jakub Kicinski”. No NAK, no
  review objections, no later revision.
- No reviewer Cc: stable in the thread.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To `bjorn@mork.no`, Cc `netdev@vger.kernel.org`.
Subsystem maintainer was on To. Applied by netdev maintainer. No
explicit Reviewed-by in the committed message.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Evidence of a real device is the author’s
usb-devices dump (Manufacturer=Rolling Wireless, Product=RN947R,
33f8:9300). User population is owners of that modem.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single-patch series. No `option.c` RN947R commit in this tree
(`git log --grep=RN947R -- drivers/` only finds this qmi_wwan change).
Web search did not find a matching option serial patch.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED. `WebFetch` of lore.kernel.org/stable/?q=RN947R
returned 403. No local evidence this ID was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body edited. Data change in `products[]`, consumed
as `qmi_wwan_driver.id_table`.

Step 5.2: TRACE CALLERS
Record:
- `products` -> `qmi_wwan_driver.id_table` -> USB core match ->
  `qmi_wwan_probe()` -> `usbnet` bind path (`qmi_wwan_bind`).
- Reachable on device plug-in / boot with the modem attached. Not
  interrupt or syscall hot path for other devices.

Step 5.3: TRACE CALLEES
Record: Unchanged. Bind still uses existing `qmi_wwan_bind` / DTR
handling (`qmi_wwan_change_dtr` when `QMI_WWAN_QUIRK_DTR` or `bcdUSB >=
0x0201`). Dump has `Ver= 2.10`, so DTR would be set even with
`QMI_FIXED_INTF`; `QMI_QUIRK_SET_DTR` matches sibling Rolling entries.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-visible: plugging the modem should create a QMI WWAN
netdev and cdc-wdm control node. Trigger is ordinary USB enumeration,
not an obscure debug path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `QMI_QUIRK_SET_DTR(vend, prod, intf)` pattern is used
throughout `products[]`, including `33f8:0104` RW101. This is the
established way to add Qualcomm RMNET compositions.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `git describe HEAD` / `make kernelversion` => **6.18.57**
  (`VERSION=6 PATCHLEVEL=18 SUBLEVEL=57`).
- `drivers/net/usb/qmi_wwan.c` exists; `CONFIG_USB_NET_QMI_WWAN` exists;
  `QMI_QUIRK_SET_DTR` exists.
- `git show v6.18.57:drivers/net/usb/qmi_wwan.c` has Rolling RW101
  (`33f8:0104`) and **does not** have `33f8:9300` / RN947R. The missing-
  ID problem exists on this 6.18.y base.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. v6.18.57 context is identical around the insertion
point:
```
{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
```
No refactor between mainline hunk and this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other RN947R ID in this tree’s `option.c` or `qmi_wwan.c` on
the v6.18.57 base. No alternate fix for 33f8:9300.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drivers/net/usb/qmi_wwan] [IMPORTANT for WWAN users, peripheral
for everyone else]. Mature, non-staging driver used by laptops and
embedded LTE/5G modems.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained via ID-table additions. Maintainer Bjørn
Mork; netdev applies these routinely. Mature ID-table design.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / hardware-specific. Only Rolling Wireless
RN947R (`33f8:9300`). Other USB devices unchanged.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Plug in the modem or boot with it attached. Common for those
users. Unprivileged users do not get a new attack surface; this is bind-
table matching.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Without the ID, the RMNET function stays unbound; WWAN
networking does not work. Not a panic/UAF. Severity MEDIUM as a
functional hardware-support miss, and it still qualifies under the
device-ID exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH for RN947R users (modem network interface works); zero
  effect on others.
- Risk: VERY LOW (1 line, existing macro, existing driver,
  VID:PID:interface match).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Explicit stable exception: USB ID added to an existing driver.
- One line, obviously correct, matches a real device dump (If#=8,
  Prot=50).
- Driver, macros, and Rolling vendor support already in 6.18.57.
- Applies cleanly next to RW101.
- Mailed to qmi_wwan maintainer, applied by netdev maintainer, v1 with
  no NAK.
- Same pattern as many other qmi_wwan ID additions.

AGAINST:
- Does not fix a crash, UAF, or corruption.
- No Tested-by/Reviewed-by tags.
- `option.c` still lacks `33f8:9300`, so serial ports may need a
  separate ID or `new_id`; that does not block the netdev ID.

UNRESOLVED:
- lore.kernel.org WebFetch 403 for stable@ search.
- Whether an option serial companion exists upstream later than this
  tree.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — dump-backed ID, applied to
   netdev/net.
2. Fixes a real bug that affects users? PASS — modem otherwise has no
   QMI netdev.
3. Important issue? PASS under device-ID exception (hardware enablement
   for existing driver).
4. Small and contained? PASS — +1 line in one table.
5. No new features or APIs? PASS — no new driver, syscall, or userspace
   API; ID only.
6. Can apply to the local tree? PASS — v6.18.57 has identical context.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Device ID addition to existing driver (USB ID in `qmi_wwan`).

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.y tree. It is the standard, low-
risk USB ID pattern stable already takes for `qmi_wwan`.

What problem it solves: RN947R owners on 6.18.y get a working QMI/RMNET
interface instead of an unbound USB function.

Risk vs benefit: one matching table entry vs. a non-working WWAN modem.
Benefit dominates.

Concerns: serial `option` binding is incomplete without a separate ID;
that is independent and not a reason to drop this netdev ID.

Verification:
- [Phase 1] Parsed subject/tags/body: device-ID add; Link to
  patch.msgid.link; SOB Speyerer + Kicinski; no Fixes/syzbot.
- [Phase 2] Diff: +1 line in `products[]`; `QMI_QUIRK_SET_DTR(0x33f8,
  0x9300, 8)` matches dump If#=8.
- [Phase 2] Read `QMI_QUIRK_SET_DTR` / `qmi_wwan_info_quirk_dtr` / DTR
  logic at bind (lines 804–825, 938–958).
- [Phase 3] `git blame` around insertion: RW101 from `d362046021ea12`
  (2024); ancestor of v6.18.57.
- [Phase 3] `git log --oneline -20 -- drivers/net/usb/qmi_wwan.c`: many
  similar ID adds; this is standalone.
- [Phase 3] `git log --author='Reinhard Speyerer' -- drivers/net/usb/`:
  prior qmi_wwan ID work.
- [Phase 4] `b4 dig -c 7375d38364a9…`: lore URL found; `-a` v1 only;
  `-w` To bjorn@mork.no Cc netdev; `-m` thread is submit + applied-bot,
  no NAK.
- [Phase 4] lore WebFetch 403; used b4 mbox instead.
- [Phase 4] WebSearch: no option.c RN947R companion found.
- [Phase 5] `products` -> `qmi_wwan_driver.id_table` ->
  `qmi_wwan_probe`; `MODULE_DEVICE_TABLE(usb, products)`.
- [Phase 5] `option.c` has other 33f8 IDs, not 0x9300.
- [Phase 6] `git describe HEAD` / Makefile: 6.18.57. `git show
  v6.18.57:drivers/net/usb/qmi_wwan.c` has RW101, lacks RN947R. Apply
  context matches.
- [Phase 6] `git merge-base --is-ancestor 7375d38364a9 HEAD` is false
  (upstream SHA not this history); evaluate against local 6.18.y code,
  not that SHA.
- [Phase 7] MAINTAINERS: USB QMI WWAN NETWORK DRIVER, M: Bjørn Mork.
- [Phase 8] Failure mode: unbound RMNET on this VID:PID only; risk
  confined to that device.
- UNVERIFIED: stable@ lore discussion (HTTP 403).

**YES**

 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index aa66a30e56cdc..85d2daae805fd 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1453,6 +1453,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1312, 4)},	/* u-blox LARA-R6 01B */
 	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 	{QMI_QUIRK_SET_DTR(0x33f8, 0x0104, 4)}, /* Rolling RW101 RMNET */
+	{QMI_QUIRK_SET_DTR(0x33f8, 0x9300, 8)}, /* Rolling RN947R RMNET */
 	{QMI_FIXED_INTF(0x2dee, 0x4d22, 5)},    /* MeiG Smart SRM825L */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d63, 0)}, /* MeiG SRM813Q w/ Modem(PPP) */
 	{QMI_QUIRK_SET_DTR(0x2dee, 0x4d64, 0)}, /* MeiG SRM813Q w/ NMEA */
-- 
2.53.0

