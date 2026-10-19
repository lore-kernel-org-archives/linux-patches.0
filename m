Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55006297FB;
	Mon, 19 Oct 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418706; cv=none; b=u4w3zY5MXxcV3jUIh7niujdpBym9i2oqKK/jZuuW1HQZhNxhTW3rWGFJsmbzL0N9kTx07MkDWu3CKRN8WjNrUsT4JuRo78c84o3F6+tvIXl2MTYOOXc56spuvBymrwjWXUeZ5gD+W3Hz1AicZ6gd/D50kRKPcm5jWrT0PxLC3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418706; c=relaxed/simple;
	bh=P70v4lbD7rijCKKYCp/Niqinta9IwzeeU3PKR/2sqCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K2o70IR9yx2T2L1vcQ+QSwWAtVOBawfa8Toz4iUQ1zLFmfIGzhl9zxU6YpJwFF/OK0qs+UISDIduxwD+ZdilwOLqpWTYvqCkTENS4W5szRdw8XmPONJMSANQNOzZYy8kuSE31J9xf+4yxU+dvELhTqwKYFoi/hdFnt6+5oxVFUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFq9dHjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFq9dHjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8781F000C4;
	Mon, 19 Oct 2026 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418703;
	bh=KnrnkJtzxfhIMBglwJTSDpWhqf+G65Vun2GiB5efnRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFq9dHjMLVbR3oPxFTsrK1geZ/lF0d9g2uV5oTa2IMENAoGPAsMq9T/1+zl5jyNWV
	 bzHaSar+HaNqA9XBugcevM6Rw9y6+0LZkVeWX0KtQaoNuIKXZrw1Dk2sC6URoDTuWU
	 7lTcWW6NxpCp53WvVXfrRHLJSKp273hlmhsLlN23ZeJwP5OUIg0gOXDA78TROPlF0j
	 nb0mo3IHfUj6N6/RXuds2N6SbeioJ3OrCkeNQslIw21ZzItfQflT4caHXRKKFQ+zOf
	 9LnHHsIAFSy+mclpPPWpqHDUYYUSa+2WL5KcJvfaqgYHyCd5EK1OfF4cYyssiTWH5r
	 lEw2a7oe7H6/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andy Moreton <andy.moreton@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ecree.xilinx@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] sfc: add X4D PF support
Date: Mon, 19 Oct 2026 09:52:07 -0400
Message-ID: <20261019135441.1420968-436-sashal@kernel.org>
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

From: Andy Moreton <andy.moreton@amd.com>

[ Upstream commit 24fedc7a569bce181728f0dd616504bef9f1513b ]

X4D is an X4 controller instance as an IP block in an SoC.
It has the same feature set as X4.

Signed-off-by: Andy Moreton <andy.moreton@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260916125641.12238-1-alucerop@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. This commit is a four-line PCI ID
addition that maps X4D PFs onto the existing X4 nic type, which is
already in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [subsystem: sfc (Solarflare/AMD ethernet)] [action verb: add]
[intent: enable X4D PF PCI devices in the existing sfc driver]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Fixes: none (expected for a device-ID addition)
- Reported-by: none
- Tested-by: none
- Reviewed-by: Pieter Jansen van Vuuren (AMD), Alejandro Lucero (AMD),
  Simon Horman (netdev)
- Acked-by: none
- Link: https://patch.msgid.link/20260916125641.12238-1-alucerop@amd.com
- Cc: stable: none (expected; not a negative signal)
- Signed-off-by: Andy Moreton (author, AMD); Jakub Kicinski (netdev
  maintainer)
- Ignored pipeline tags: Upstream commit
  24fedc7a569bce181728f0dd616504bef9f1513b; Signed-off-by: Sasha Levin

Notable: three Reviewed-by tags including a netdev regular (Horman) and
the subsystem maintainer path via Kicinski.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- [Bug description] Not a crash/corruption bug. X4D is an X4 controller
  instantiated as an SoC IP block; without these PCI IDs the in-tree sfc
  driver will not bind to that hardware.
- [Symptom/failure mode] X4D PF devices (PCI IDs 0x8c03 and 0xac03,
  vendor Solarflare 0x1924) are unrecognized; the NIC does not come up.
- [Version information] None in the message. Author date 2026-09-16; not
  in v6.18 or v6.18.57.
- [Root cause] Missing PCI ID table entries. Feature set is stated to be
  identical to existing X4, so no new nic_type is required.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: [Not a hidden bug fix.] This is an explicit hardware-enablement
/ device-ID addition. The subject says “add … support,” but the body and
diff make clear it is only IDs, not a new driver or API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- [Files] drivers/net/ethernet/sfc/efx.c: +4 / -0
- [Functions] none modified; only the static `efx_pci_table[]`
  initializer
- [Scope] single-file surgical PCI ID addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: [hunk] Before: table lists X4 PF IDs 0x0c03 (FF/LL) and 0x2c03
(FF only) bound to `efx_x4_nic_type`, then terminator. After: two
additional IDs 0x8c03 and 0xac03 also bound to `efx_x4_nic_type`. Probe
path is unchanged; PCI matching is the only difference. Normal bind path
for new devices only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [category: hardware enablement / PCI device ID addition]
[mechanism: devices 0x1924:0x8c03 and 0x1924:0xac03 would not match
`efx_pci_table`, so `efx_pci_probe()` never runs. Mapping them to
existing `efx_x4_nic_type` reuses the X4 implementation already in this
tree.]

Step 2.4: ASSESS THE FIX QUALITY
Record: [Quality: obviously correct; same pattern as the 2024 X4 ID
entries.] [Regression risk: very low. New IDs cannot match existing X4
or older Solarflare cards. No locking, no API, no data-structure change.
MODULE_DEVICE_TABLE already points at this table.]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Adjacent X4 ID rows at v6.18.57 come from `cf06766f1525d` (“sfc:
Add X4 PF support”, Jonathan Cooper, 2024-09-10). That commit added
`efx_x4_nic_type` plus IDs 0x0c03/0x2c03. The table terminator dates to
2008. X4 support has been in-tree since well before 6.18.

Step 3.2: FOLLOW THE FIXES: TAG
Record: [No Fixes: tag.] Not applicable; this did not regress existing
code.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related: `cf06766f1525d` added X4 PF support (prerequisite; present in
  v6.18.57).
- Only X4D-related commit under `drivers/net/ethernet/sfc/` is this one;
  no follow-up X4D fixes.
- Standalone: not patch X/Y; single net-next patch.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Andy Moreton has other sfc commits in this history (EEPROM
reporting, EF10 filter_table_remove). Submitter on-list was Alejandro
Lucero (AMD). This is vendor driver work, not a random drive-by.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends on `efx_x4_nic_type`, which exists at v6.18.57 in
`drivers/net/ethernet/sfc/ef10.c` and is already used by 0x0c03/0x2c03.
Context around the table in v6.18.57 matches the patch. [Can apply
standalone: yes.]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- [Lore/msgid]
  https://patch.msgid.link/20260916125641.12238-1-alucerop@amd.com
- Direct lore.kernel.org fetch returned 403; thread recovered via `b4
  dig` and openwall mirrors.
- [Revisions] `b4 dig -a`: single revision, v1 `[PATCH net-next] sfc:
  add X4D PF support` (2026-09-16).
- [Review] Simon Horman Reviewed-by with no requested changes
  (2026-09-17).
- [Stable nomination] none in the thread.
- [NAKs] none.
- Applied by Jakub Kicinski; patchwork-bot announced netdev/net.git main
  commit `24fedc7a569b` on 2026-09-19.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients (`b4 dig -w`): netdev@vger.kernel.org, davem, kuba,
pabeni, edumazet, ecree.xilinx@gmail.com, Andy Moreton, Pieter Jansen
van Vuuren. Appropriate netdev maintainers and sfc/AMD people were on
Cc.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot report. This is vendor hardware enablement,
not a user-reported crash. Syzbot CI skipped the series as having no
functional impact on generic fuzzing (expected for an ID table).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. No other X4D patches in
`drivers/net/ethernet/sfc/`. No siena/ef100 table changes needed; X4/X4D
live in the main `efx_pci_table`.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. No evidence on the
public netdev thread that this was requested for or rejected from
stable. UNVERIFIED: whether anyone mailed stable@ about it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No functions edited. Data: `efx_pci_table[]`. Consumers:
`efx_pci_driver.id_table` and `MODULE_DEVICE_TABLE(pci, efx_pci_table)`.

Step 5.2: TRACE CALLERS
Record: `pci_register_driver(&efx_pci_driver)` from `efx_init_module()`.
Match leads to `efx_pci_probe()` → `efx_pci_probe_post_io()` →
`efx_pci_probe_main()`. Interrupt/hot path unchanged. Impact surface:
PCI enumeration of the two new IDs only.

Step 5.3: TRACE CALLEES
Record: Probe uses `efx_x4_nic_type` (already defined in ef10.c):
EF10-like ops, `efx_ef10_probe_pf`, MCDI, etc. Same as discrete X4 PFs.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace cannot trigger this except by plugging/enumerating the
NIC. Reachable on any machine with an X4D PF and CONFIG_SFC. Not a
syscall-fuzz path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same two-ID (FF/LL vs FF-only) pattern as X4 0x0c03/0x2c03.
Older SFC9120/9140/9220/9250 entries use the same table style. No other
copies of 0x8c03/0xac03 in this driver.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Local tree is **v6.18.57** (`Makefile` VERSION=6 PATCHLEVEL=18
SUBLEVEL=57). At v6.18.57, `efx_pci_table` has X4 IDs but not X4D
0x8c03/0xac03. `efx_x4_nic_type` is present. The “bug” (missing IDs)
exists here. X4 support was added in 2024 and is in v6.18.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: [Expected backport difficulty: clean apply.] v6.18.57 context is
identical to the hunk. No conflicting refactor of the ID table between
v6.18.57 and this patch.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other X4D ID or quirk in v6.18.57. Candidate overlay commit
`6fd5947dd3d9d` is ignored per pipeline rules; it is not part of
v6.18.57.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [Subsystem: drivers/net/ethernet/sfc] [Criticality: IMPORTANT
for users of Solarflare/AMD X4-family NICs; PERIPHERAL relative to core
mm/fs. Not staging.]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: sfc is actively maintained (X4 in 2024, stats/MDIO churn, AMD
authors). Mature driver; this is incremental ID adding on a stable
nic_type.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: [Affected population: driver-specific / hardware-specific.] Only
Solarflare X4D PF devices (SoC IP block). Existing X4 and older SFC
users are unaffected.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: [Trigger: PCI probe of 0x1924:0x8c03 or 0x1924:0xac03.] Common
on systems that ship that SoC NIC; never on others. Not an unprivileged
software trigger.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Failure mode: device never bound; no Ethernet for that port.]
[Severity: MEDIUM for those platforms (hardware dead in this kernel),
LOW for everyone else.] Not a crash/UAF, but it is user-visible hardware
enablement of the kind stable explicitly accepts.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- [Benefit] High for X4D SoC users on 6.18.y (NIC actually works).
  Documented same feature set as X4 already in this tree.
- [Risk] Very low: 4 lines, ID table only, no behavioral change for
  other IDs.
- [Ratio] Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Official rule in this tree: “must either fix a real bug that bothers
  people or just add a device ID.”
- User-instruction exception: new PCI IDs in an existing driver are YES.
- 4-line change; maps to existing `efx_x4_nic_type` already in 6.18.57.
- Author states X4D has the same feature set as X4.
- Reviewed by Horman and AMD; applied by Kicinski.
- Clean apply; no prerequisites missing; no follow-up X4D patches.
- No risk to existing devices.

AGAINST:
- Submitted to net-next, not as a “fix.”
- No crash/security/corruption.
- Niche SoC NIC; no public user bug report.
- UNVERIFIED: stable@ discussion (lore 403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? [PASS — identical to existing X4 ID
   rows; reviewed; merged upstream]
2. Fixes a real bug that affects users? [PASS under the device-ID
   clause; without it X4D NICs do not probe]
3. Important issue (crash, security, corruption, deadlock)? [PASS via
   device-ID exception, not via crash]
4. Small and contained? [PASS — 4 lines, one table]
5. No new features or APIs? [PASS — no new nic_type, no new sysfs/uAPI;
   IDs only]
6. Can apply to the local tree? [PASS — v6.18.57 has X4 type and
   matching table context]

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: [Exception category: NEW DEVICE IDs to an existing driver.]
Driver and X4 nic type already exist in 6.18.57.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.y tree. It is the textbook PCI ID
addition: small, obviously correct, no new APIs, and the implementation
it binds to is already present.

===============================================================
What the commit solves for stable users
===============================================================

On 6.18.y, sfc already drives X4 PFs (`0x0c03` / `0x2c03`) via
`efx_x4_nic_type`. X4D is the same controller as an SoC IP with
different PCI IDs. Without this patch those devices never match, so the
interface never appears. Adding the two IDs is the entire change.

Risk vs benefit: benefit is hardware enablement for X4D PFs; risk is
confined to those IDs. No locking, no API, no shared-path logic change.

Concerns: none material. Not a series; X4 support is already here; apply
is clean. Absence of Cc: stable is expected for this review queue.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Reviewed-by Pieter Jansen van Vuuren, Alejandro
  Lucero, Simon Horman; Link msgid
  20260916125641.12238-1-alucerop@amd.com; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Body: “X4D is an X4 controller instance as an IP block in an
  SoC. It has the same feature set as X4.”
- [Phase 2] Diff: +4 lines in `efx_pci_table[]` only; IDs 0x8c03 and
  0xac03 → `efx_x4_nic_type`
- [Phase 3] `git describe HEAD` / `make kernelversion` / Makefile:
  v6.18.57
- [Phase 3] `git merge-base --is-ancestor 6fd5947dd3d9d v6.18.57` → NOT
  in v6.18.57 (candidate overlay ignored)
- [Phase 3] `git merge-base --is-ancestor cf06766f1525d v6.18.57` → X4
  support IS in this tree
- [Phase 3] `git show v6.18.57:drivers/net/ethernet/sfc/efx.c` table has
  X4 IDs, not X4D; terminator immediately after 0x2c03
- [Phase 3] `git blame -L 900,911 v6.18.57 --
  drivers/net/ethernet/sfc/efx.c`: X4 rows from cf06766f1525d (2024)
- [Phase 3] `git grep efx_x4_nic_type v6.18.57 --
  drivers/net/ethernet/sfc/`: ef10.c:4308, efx.c X4 IDs, nic.h extern
- [Phase 3] `git log --grep=X4D -- drivers/net/ethernet/sfc/`: only this
  commit
- [Phase 4] `b4 dig -c 24fedc7a569bce181728f0dd616504bef9f1513b`: msgid
  match; v1 only
- [Phase 4] `b4 dig -a`: single series, no v2+
- [Phase 4] `b4 dig -w`: netdev maintainers + AMD + Edward Cree on Cc
- [Phase 4] Openwall: Horman Reviewed-by; patchwork applied
  24fedc7a569b; no NAK
- [Phase 4] lore.kernel.org WebFetch: 403 — used openwall/b4 instead
- [Phase 5] `efx_pci_table` used as `efx_pci_driver.id_table` and
  MODULE_DEVICE_TABLE; probe is `efx_pci_probe`
- [Phase 5] `PCI_VENDOR_ID_SOLARFLARE` is 0x1924 in v6.18.57 pci_ids.h
- [Phase 6] Context at v6.18.57 matches patch; clean apply
- [Phase 7] CONFIG_SFC present: “Solarflare SFC9100/EF100-family
  support”
- [Phase 8] Failure mode verified as non-bind of new PCI IDs, not a
  crash
- [Phase 9] Documentation/process/stable-kernel-rules.rst line 15: “or
  just add a device ID”
- UNVERIFIED: stable@ mailing list (lore 403)

This is a contained PCI ID addition to a driver and nic type that
already exist in 6.18.y, which stable policy explicitly allows.

**YES**

 drivers/net/ethernet/sfc/efx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 112e55b98ed3b..62df7b6a26fa5 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -903,6 +903,10 @@ static const struct pci_device_id efx_pci_table[] = {
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x2c03),  /* X4 PF (FF only) */
 	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0x8c03),  /* X4D PF (FF/LL) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOLARFLARE, 0xac03),  /* X4D PF (FF only) */
+	 .driver_data = (unsigned long)&efx_x4_nic_type},
 	{0}			/* end of list */
 };
 
-- 
2.53.0

