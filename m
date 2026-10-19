Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17E5616AA;
	Mon, 19 Oct 2026 13:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418127; cv=none; b=pP5F+77iS3fSts38OUtvTD9cizXAnMsWyVAS0lXMI7CmlKrNkd0MCILqHc5TPifvjP1DOd6P7ll1T6iM525uYC1nsHmdhEFfo2KkTf4X+AISQqaBfHU+N4GieDOekV83ihLGTak9RhlG4/noaCgcg0tLvMs1B0/XX4EqVHHG8xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418127; c=relaxed/simple;
	bh=RZ4LR5xduwu0elY6VhRuAfSxZS1lh3E+inpixSSxlwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnKkAHjINE4h3EL5JBiWVmZ4h4oAvS4mtwFG7vmPl36rz9II+cT2pEH8IDdeHTtC2j3QFphcVeIdbKZC2+bWIDHth9ezmg0eg6cSa7YBW3vgXDbO4NaPxyI7KMZtQmQPQ0DySBM78QI5EQGU5I1YgibUi1Tb3sAuMSNneVguI4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lV1nmfNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lV1nmfNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0910B1F000C6;
	Mon, 19 Oct 2026 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418124;
	bh=Zm0ShvoR7y74hIRpdKCarjzbD3xiWTbycsn5sH5MJDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lV1nmfNppahgvceSEk+iMQ2A4JkNNQowRtmEbAqvDH5pw3Q6AonZVYHq3xDNyo2kd
	 uATS03pFslSeSbaSX8tjbgnGCv37wm9eIWBIFYFQGYTjYqFkT7T2MRARYRMRglNLkw
	 6m4idfjBe0IrrgD8ih/aJjQhaXc79l+jTNBPdq3mLUBWwoByHq0tMMUYIMywlpr7Rh
	 8C+GxEY4lP3jES4U8UOdYCbBbTWHil4Wjx+NXs4eGawvbtnViDqzTOkftXSEmOPe5E
	 xzzod8x+yNtrdfI1iCmrUmlFBWE2brXd6GBh7sNTgyoYRIGAd3WzWVOzcdtaLzxHVD
	 oBbTa9GkHZL3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	heikki.krogerus@linux.intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] usb: typec: mux: tusb1046: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:45:20 -0400
Message-ID: <20261019135441.1420968-29-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e4eb5c96324b226220d29d025a334df28054ed3 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/20260704124714.18404-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4**. The tusb1046 driver is present, and this
is a one-line OF module-alias publication so udev can autoload the
driver. That is a real modular-build bug, not a new feature.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[usb: typec: mux: tusb1046]** **[add]** missing
`MODULE_DEVICE_TABLE()` so OF module aliases are generated.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Romain Gantois \<romain.gantois@bootlin.com\> (driver
  author / listed maintainer)
- **Acked-by:** none in the commit; mailing-list thread also has
  **Reviewed-by: Heikki Krogerus** (USB Type-C maintainer) that did not
  land in the commit text
- **Link:**
  https://patch.msgid.link/20260704124714.18404-1-pengpeng@iscas.ac.cn
- **Cc: stable@vger.kernel.org:** absent (expected)
- **Signed-off-by:** Pengpeng Hou (author); Greg Kroah-Hartman (USB
  maintainer, merged)
- Ignore any pipeline “already selected” / Sasha Levin markers (none in
  this commit object)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `tusb1046_match_table` is wired to `.of_match_table` but not
  exported with `MODULE_DEVICE_TABLE(of, ...)`.
- **Symptom:** when `CONFIG_TYPEC_MUX_TUSB1046=m`, `depmod` does not
  emit `of:N*T*Cti,tusb1046` aliases, so udev/kmod will not autoload the
  module when DT instantiates the I2C device.
- **Failure mode:** Type-C mux / orientation switch stays unbound until
  a manual `modprobe`. Built-in (`=y`) is unaffected.
- **Version info:** none in the message.
- **Root cause:** missing module alias publication; match table itself
  is correct.
- The “source-level fix / no dynamic hardware reproduction” sentence is
  in both the sent patch and the committed message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit autoload/alias bug. Same class as
device-ID publication: no new behavior, just making existing OF matching
visible to userspace module loading.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/usb/typec/mux/tusb1046.c` — **+1 / −0**
- **Function:** none; one line after `tusb1046_match_table[]`
- **Scope:** single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** OF table exists and is used for in-kernel matching if the
  module is already loaded; file2alias never sees it.
- **After:** `MODULE_DEVICE_TABLE(of, tusb1046_match_table)` creates the
  `__mod_of__tusb1046_match_table` alias consumed by
  `scripts/mod/file2alias.c`.
- **Path:** build-time module metadata only; probe/remove/mux paths
  unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** hardware matching / module autoload (device-ID
  publication), not UAF/race/leak.
- **Mechanism:** OF compatible `ti,tusb1046` was never exported in the
  module’s device table, so autoload could not work.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: this is the standard macro used by sibling Type-C
  mux drivers (`fsa4480`, `ptn36502`, `it5205`, `nb7vpq904m`, etc.).
- Minimal; no API, locking, or runtime change.
- Regression risk: negligible. Wrong table/type would be a build
  concern; here type `of` matches `struct of_device_id`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Match table introduced in **7c561b8c3e836** (“usb: typec: mux: Add
  support for the TUSB1046 crosspoint switch”), **Romain Gantois**,
  2024-10-24, first contained in **v6.13-rc1**.
- Original driver had `.of_match_table = tusb1046_match_table` and
  **no** `MODULE_DEVICE_TABLE`. Bug present from introduction.
- Candidate: **5e4eb5c96324b226220d29d025a334df28054ed3**, first
  contained in **v7.3-rc1**.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy commit is the driver intro
**7c561b8c3e836**, which **is** an ancestor of this HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (on this file): driver add → `dev_err_probe` cleanup → include-
header reshuffle → this alias fix. Standalone; not patch x/y. No
prerequisite refactor required for the one-line add.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a contributor, not the Type-C mux maintainer.
Nearby USB work is unrelated. Weight comes from **Romain Gantois**
(driver maintainer) and **Heikki Krogerus** (Type-C) reviews, plus Greg
KH merge.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. `MODULE_DEVICE_TABLE` exists in `include/linux/module.h`
in this tree. Applies standalone on any tree that has
`tusb1046_match_table`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig -c 5e4eb5c96324b:**
  https://patch.msgid.link/20260704124714.18404-1-pengpeng@iscas.ac.cn
- **b4 dig -a:** single **v1**, 2026-07-04, no later revision.
- Thread (mbox): Romain Gantois “LGTM, thanks!” + R-b (2026-07-07);
  Heikki Krogerus R-b (2026-07-13, after Greg’s 2026-07-08 commit). **No
  NAKs, no stable discussion, no risk flags.**
- WebFetch of lore.kernel.org returned **403**; thread recovered via `b4
  dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: **b4 dig -w** original To/Cc: Pengpeng Hou, Romain Gantois,
Heikki Krogerus, Greg Kroah-Hartman, linux-usb, linux-kernel. Right
maintainers were on the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/Reported-by. Justification is the missing
macro vs an existing OF table. No in-tree DTS consumer of `ti,tusb1046`
(only `Documentation/devicetree/bindings/usb/ti,tusb1046.yaml`). User
impact is boards that describe this chip in DT, including out-of-tree
DTS.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Same pattern already used in this tree:
**15a34e5d4b23c** (“usb: typec: fix module autoloading”),
**f27891abb7930** (“usb: typec: add missing MODULE_DEVICE_TABLE() to
stusb160x”).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable WebFetch 403; WebSearch
failed. No stable nomination in the recovered linux-usb thread.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body changed. Data: `tusb1046_match_table`; driver:
`tusb1046_driver` / `module_i2c_driver()`.

**Step 5.2: TRACE CALLERS**
Record: I2C core binds via `module_i2c_driver`. OF match is used once
the module is loaded. Autoload is userspace (udev) using aliases from
`modules.alias`. Reachable on DT platforms with `compatible =
"ti,tusb1046"`.

**Step 5.3: TRACE CALLEES**
Record: N/A for the added line. Macro expands to a static alias
attribute for modpost.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: DT I2C instantiation → udev/kmod looks up OF alias → `tusb1046`
module → `tusb1046_i2c_probe`. Userspace cannot trigger a crash via this
bug; the failure is **driver never loads**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other Type-C mux drivers already have `MODULE_DEVICE_TABLE(of,
...)`. This driver was the one that omitted it. Semcode MCP not
available; used `git grep`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- **Tree:** `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**.
- Driver file exists; Kconfig `TYPEC_MUX_TUSB1046` is **tristate**.
- Bug introduced **v6.13**; this 7.3 lineage includes that driver.
- **HEAD already contains 5e4eb5c96324b** (`git merge-base --is-
  ancestor` succeeded). Current file already has line 181
  `MODULE_DEVICE_TABLE(of, tusb1046_match_table)`. That is mainline
  history, not a reason to reject on technical merit.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: On **current HEAD**, `git apply --check` of the commit **fails**
because the line is already present. Against the pre-fix file (parent of
5e4eb5c96324b) the hunk is a clean one-line insert after the match
table. Any stable tree that still has the original
`tusb1046_match_table` without the macro would take it cleanly.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is already in HEAD. No alternate autoload
workaround in the driver. Sibling Type-C autoload fixes are also present
and do not replace this line.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **USB Type-C mux driver** (`drivers/usb/typec/mux/`).
**PERIPHERAL** — one I2C crosspoint switch, not mm/VFS/net core. Still
user-visible USB-C / DP altmode on boards that have the chip.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Type-C mux is actively developed (ps883x and related churn).
`tusb1046.c` itself is low-churn since v6.13.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific + config-specific:**
`CONFIG_TYPEC_MUX_TUSB1046=m` on OF/I2C systems with `ti,tusb1046`. Not
universal. No in-tree DTS users found; out-of-tree / vendor DT is the
realistic consumer.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot/enumeration of that DT node when the driver is a
module. Not a race. Unprivileged users do not exploit it; they just do
not get the mux driver.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure mode:** module does not autoload; USB-C orientation/DP
muxing does not come up until manual load. **Severity: MEDIUM**
(functional hardware enablement, not oops/corruption/deadlock). Built-in
builds: no bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for TUSB1046 modular users (device actually probes);
  moderate overall (narrow hardware, no in-tree board).
- **Risk:** very low (1 line, metadata only).
- **Ratio:** favorable — same justification as adding a device ID to an
  existing driver.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real autoload bug for a tristate driver with an OF table.
- One line, obviously correct, no runtime path change.
- Reviewed by the driver author and Type-C maintainer; merged by Greg
  KH.
- Same pattern already used in this Type-C subsystem.
- Fits the stable exception for publishing match IDs so existing
  hardware actually binds.
- Driver and match table exist in this 7.3 tree (introduced v6.13).

AGAINST:
- Not a crash, UAF, deadlock, or security issue.
- No user `Reported-by` and no in-tree DTS enabling the compatible.
- “Tested” is source-level, not hardware reproduction.
- HEAD already contains the commit (expected on 7.3-rc; not a pipeline-
  selection marker).

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403 / search failure).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard macro; maintainer
   R-b. Hardware test not claimed.
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   is broken.
3. Important issue? **PASS** as hardware enablement (autoload),
   analogous to new device IDs; not CRITICAL.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — exports an existing table.
6. Can apply to the local tree? **PASS** for this codebase (driver
   present). Re-applying on current HEAD conflicts only because the fix
   is already merged here; a tree that still lacks the line applies
   cleanly.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Device ID / module alias publication** for an existing driver
(OF `MODULE_DEVICE_TABLE`). Also build-time metadata, not a new driver.

**Step 9.4: MAKE YOUR DECISION**
This tree has the TUSB1046 driver. Missing `MODULE_DEVICE_TABLE(of,
...)` prevents automatic loading of a modular Type-C mux, so USB-C/DP
switching does not come up on DT systems until someone loads the module
by hand. The fix is one obviously correct line with essentially no
regression risk. That meets stable rules and the device-ID exception, so
it should be backported to this tree’s stable series.

===============================================================
What the commit solves for stable users
===============================================================
With `TYPEC_MUX_TUSB1046=m`, kmod never learns the `ti,tusb1046` OF
alias, so the I2C Type-C mux never autoprobes. Distro/embedded kernels
that ship this as a module then lose orientation switch and DisplayPort
muxing on that hardware. The patch only emits the alias; it does not
change probe logic.

Risk is negligible. Benefit is real for modular users of this chip. No
extra commits are required beyond the driver that this 7.3 tree already
has.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed commit **5e4eb5c96324b**: R-b Romain Gantois; Link
  patch.msgid.link; no Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff: **+1** `MODULE_DEVICE_TABLE(of, tusb1046_match_table)`
  in `drivers/usb/typec/mux/tusb1046.c`.
- [Phase 2] Confirmed sibling mux drivers already use
  `MODULE_DEVICE_TABLE(of, ...)`.
- [Phase 3] `git blame`: table from **7c561b8c3e836** (v6.13-rc1);
  original add had no `MODULE_DEVICE_TABLE`.
- [Phase 3] `git describe --contains 7c561b8c3e836` → v6.13-rc1; `git
  describe --contains 5e4eb5c96324b` → v7.3-rc1.
- [Phase 3] `git merge-base --is-ancestor 5e4eb5c96324b HEAD` → yes;
  `7c561b8c3e836` → yes.
- [Phase 3] `git show 7c561b8c3e836` confirms OF table without the
  macro.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; R-b Gantois + Krogerus;
  recipients include Type-C and USB maintainers; no NAK.
- [Phase 4] lore WebFetch 403; used mbox instead.
- [Phase 5] Kconfig `TYPEC_MUX_TUSB1046` is tristate; Makefile builds
  `tusb1046.o`; DT binding `ti,tusb1046.yaml` exists.
- [Phase 5] `git grep ti,tusb1046 arch/` → no in-tree DTS.
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-g…; kernelversion
  7.3.0-rc4.
- [Phase 6] HEAD already has the line; `git apply --check` of the patch
  on HEAD fails; parent of the commit lacks the macro.
- [Phase 7] MAINTAINERS: USB TYPEC TUSB1046 MUX DRIVER → Romain Gantois.
- [Phase 8] Failure = missing autoload, severity MEDIUM; risk very low.
- UNVERIFIED: stable@ discussion (lore/stable unreachable).

**YES**

 drivers/usb/typec/mux/tusb1046.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/mux/tusb1046.c b/drivers/usb/typec/mux/tusb1046.c
index 3c1a4551c2fbf..89b47aa56c7a9 100644
--- a/drivers/usb/typec/mux/tusb1046.c
+++ b/drivers/usb/typec/mux/tusb1046.c
@@ -179,6 +179,7 @@ static const struct of_device_id tusb1046_match_table[] = {
 	{.compatible = "ti,tusb1046"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, tusb1046_match_table);
 
 static struct i2c_driver tusb1046_driver = {
 	.driver = {
-- 
2.53.0

