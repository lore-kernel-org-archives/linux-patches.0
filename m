Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1485A357D;
	Mon, 19 Oct 2026 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418380; cv=none; b=lwJ9EudzmswszsHK0P1BwyLlGHoLHyGwvAGAA/oDfiiWMeDoIGOItxTltxLVlAsCEstNXjqB7V3ytnJ2hQDjrizvMu6SLTlQvfLkZtbdoZcOo3gnFp1Xm948cTM/gIvo94COGsZE5kSYRYaBCYE7QNojefPMghxRyNtICKqjY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418380; c=relaxed/simple;
	bh=AFavnNKiE/dT91FsRoj+3tVmR6btbub310B8fkTNg5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALjrabjXUPg8uxres/gjLiEOxkRzgloSzK7nw7f4UbdiqOsKrBz26irX3oEVhh5dlbfJ+WJezADlgSndjbABjIXU2+pddybDcW2PPOBMQKsZRfKtuX+3H23SaVIwPfAXvgKLn56mAwja2SfacEepEKYdyyaBui+ORmmloKeAA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxkSZGg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxkSZGg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85271F000C8;
	Mon, 19 Oct 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418378;
	bh=H8JoCC7gt7zCEQqk2PYvewP91xC+JRFcbOfWCI7/0xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxkSZGg4aFXpMSC4NSqPbytnUE2siPcxnGqkWtpEXPqpoGv4MhFSEvw7hrmWVmkZT
	 unqg0tArBSqV5p1ypi465v1gim9fYhacIS4h+StdEnt/0AJzMTkNZLIiLMo/cUT2q9
	 sMFoMSRAvezRz7POsVuE/DhFNk+3uxZjvcIYbvrYq8aogv64F0E5sRZ35CbcgzcAkr
	 AEQu3Iqn7diodfeQeFxGC9uTr5n4sf57bONg+RvCT5gjM/ff01PTI1gcGjJaSQ/Bbr
	 JeUW16+YUVwR8S+fjhLgSHAwxkH0+owbuTDB90wP9cGGADrqj3tGgEcnDWEdJJGspj
	 ejZnHSDKn07SQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850
Date: Mon, 19 Oct 2026 09:48:17 -0400
Message-ID: <20261019135441.1420968-206-sashal@kernel.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit d529495c991a2b7d07c01622e8b3cb5ec066acee ]

Add SoC ID for Qualcomm Snapdragon SDM850.

Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-1-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
commit adds one Qualcomm SoC ID constant. That is a device-ID / DT-
binding addition for hardware that is already in this tree, and it
matches the stable exception for new IDs.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem prefix: `dt-bindings: arm: qcom,ids:`
- Action verb: **Add**
- Claimed intent: add the numeric SoC ID for Snapdragon SDM850

Record: [dt-bindings/arm/qcom,ids] [add] [define QCOM_ID_SDM850 = 348]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Fixes: none (expected)
- Reported-by: none
- Tested-by: none
- Reviewed-by: Konrad Dybcio `<konrad.dybcio@oss.qualcomm.com>`
  (Qualcomm SoC maintainer)
- Acked-by: Krzysztof Kozlowski `<krzysztof.kozlowski@oss.qualcomm.com>`
  (DT maintainer)
- Link:
  `https://lore.kernel.org/r/20260627-sda850-v2-1-44bf46ade42e@ixit.cz`
- Cc: stable: none (expected)
- Signed-off-by: David Heidelberg (author); Bjorn Andersson
  (Qualcomm/SoC maintainer, applied it)

Record: Device-ID addition reviewed by the Qualcomm and DT maintainers;
no syzbot/bugzilla report; Message-ID shows this is **v2 1/2**.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Body is one sentence: “Add SoC ID for Qualcomm Snapdragon SDM850.” No
stack trace, no crash, no version range.

The cover letter (from b4, not the commit body) states the series is
“Useful for sdm850 devices in tree and also will be used by Comma AI
comma three.”

Record: [Bug: missing SoC ID 348 in the Qualcomm ID table] [Symptom:
socinfo cannot name SDM850] [No version info in the commit] [Root cause:
ID 348 was never added when qcom,ids.h was created]

**Step 1.4: DETECT HIDDEN BUG FIXES**
This is not a hidden crash/UAF/leak fix. It is an explicit ID addition.
That is the documented stable exception for device IDs, not a disguised
memory-safety patch.

Record: [Not a hidden memory/locking bug] [It is a device-ID / DT-
binding addition]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `include/dt-bindings/arm/qcom,ids.h`
- +1 / −0
- No C function changed; one preprocessor define inserted in numeric
  order between `QCOM_ID_SDA636` (346) and `QCOM_ID_SDM632` (349)
- Scope: single-file, one-line addition

Record: [1 file, +1 line] [no functions] [surgical ID add]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: the header jumped from 346 to 349; firmware SoC ID 348 had no
`QCOM_ID_*` name.
After: `#define QCOM_ID_SDM850 348` so `qcom_board_id(SDM850)` in
socinfo can compile and match.

Record: [header lacked ID 348 → ID 348 named SDM850]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category **(h) Hardware / device ID**.
Without the define, `socinfo_machine()` cannot map SMEM id 348 to
`"SDM850"`. Probe still succeeds; `qs->attr.machine` stays NULL and
`/sys/devices/soc0/machine` is hidden (`soc_attribute_mode` returns 0
when machine is NULL). Numeric `soc_id` sysfs (`"348"`) still works. No
driver in this tree switches on `QCOM_ID_SDM850` except the socinfo
table (companion commit).

Record: [device ID] [missing SoC identity mapping; not a crash]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: one define, numeric order preserved, value 348 does
not collide with neighbors. No API, no locking, no alloc. Regression
risk is negligible. Companion patch 2/2 (`soc: qcom: socinfo: Add SoC ID
for SDM850`) is the consumer; this patch alone is an unused define but
is required for 2/2 to build.

Record: [minimal and correct] [near-zero regression risk]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Surrounding IDs come from `a79a4b3097bc2` (Krzysztof Kozlowski,
2022-08-30; merged 2022-10-17): “dt-bindings: arm: qcom: document
qcom,msm-id and qcom,board-id”. SDM850 was omitted then. In-tree SDM850
DTS exists since `44acee2078447` (2019-09-05, Lenovo Yoga C630).

Record: [gap introduced with qcom,ids.h in 2022] [SDM850 boards present
since 2019]

**Step 3.2: FOLLOW THE FIXES: TAG**
No Fixes: tag.

Record: [N/A — no Fixes: tag]

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
This is **v2 1/2** of “Recognize Snapdragon SDM850”:
- 1/2: `d529495c991a2` this define
- 2/2: `743af1d6a8b4b` socinfo table entry `{ qcom_board_id(SDM850) }`

v1 was named SDA850; v2 renamed to SDM850 (Konrad) and added the socinfo
consumer (Krzysztof).

Record: [two-patch series; this is the ID, 2/2 is the table] [standalone
apply is clean; useful with 2/2]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
David Heidelberg is a board/DT contributor, not the subsystem
maintainer. Applied by Bjorn Andersson. Konrad reviewed; Krzysztof
acked.

Record: [author is a contributor; Qualcomm/DT maintainers reviewed and
applied]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Needs `include/dt-bindings/arm/qcom,ids.h` (present since 2022 in this
tree) and, for a user-visible effect, the socinfo consumer. No new
helper, struct, or API.

Record: [depends on existing qcom,ids.h] [can apply standalone] [pairs
with socinfo 2/2]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c d529495c991a2` matched:
- v1: SDA 850 (2026-06-23)
- v2: `[PATCH v2 0/2] Recognize Snapdragon SDM850` (2026-06-27)
- URL:
  https://patch.msgid.link/20260627-sda850-v2-1-44bf46ade42e@ixit.cz

Thread (saved via `b4 dig -m`): no NAKs, no stable discussion. Krzysztof
Acked-by; Konrad Reviewed-by; Bjorn applied both patches.

lore.kernel.org HTTP fetches returned 403; b4/mbox is the verified
source.

Record: [v1→v2 naming + consumer] [no NAK] [no Cc: stable in review]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` original To/Cc: Bjorn Andersson, Konrad Dybcio, Rob Herring,
Krzysztof Kozlowski, Conor Dooley, linux-arm-msm, devicetree, linux-
kernel.

Record: [right maintainers and lists]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No Reported-by / bugzilla / syzbot. Motivation is identification of in-
tree SDM850 machines and Comma 3.

Record: [no crash report; hardware-identification request]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Series is 2/2. 2/2 is the one-line socinfo entry that uses this define.

Record: [companion 743af1d6a8b4b] [both one-liners]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable search returned 403. No evidence in the patch
thread that stable was discussed.

Record: [UNVERIFIED: no stable-list thread retrieved due to 403]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
No function edited. Consumer is `socinfo_machine()` via
`qcom_board_id(SDM850)` → `QCOM_ID_SDM850`.

Record: [define only; consumer socinfo_machine()]

**Step 5.2: TRACE CALLERS**
`socinfo_machine()` is called from `qcom_socinfo_probe()` when reading
SMEM `SMEM_HW_SW_BUILD_ID`. That runs on Qualcomm platforms with
socinfo. `QCOM_ID_SDM850` is not used in `qcom-cpufreq-nvmem.c` or clk
drivers.

Record: [socinfo probe on SDM850; naming only]

**Step 5.3: TRACE CALLEES**
`socinfo_machine()` walks `soc_id[]` and returns the name or NULL. Probe
does not fail on NULL machine.

Record: [lookup table; NULL = unnamed SoC]

**Step 5.4: FOLLOW THE CALL CHAIN**
Boot on SDM850 (Yoga C630, Galaxy Book S / w737, MateBook E 2019, Comma
3) → qcom_socinfo_probe → socinfo_machine(348). Reachable on those
machines, not from a generic syscall on unrelated hardware.

Record: [reachable on SDM850 boots] [not a core/universal path]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
The same file is a long list of `QCOM_ID_*` defines; socinfo.c has
matching `qcom_board_id(*)` rows. This follows that pattern.

Record: [standard qcom SoC-ID add]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `include/dt-bindings/arm/qcom,ids.h` exists. Surrounding IDs 346
and 349 match the hunk. SDM850 DTS and socinfo exist. The define is
already present at line 187 (`git merge-base --is-ancestor d529495c991a2
HEAD` is true). That is because this checkout **is 7.3-rc4**, which is
the series that merged the ID; it is not used as “already selected for
stable.”

Record: [qcom,ids.h and socinfo present] [gap existed from 2022 until
this 7.3 change]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Hunk context matches this tree. One-line insert. Clean apply.

Record: [clean apply]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No earlier equivalent SDM850 ID. Companion socinfo commit is also in
this 7.3 tree.

Record: [no prior substitute fix]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Qualcomm DT bindings + socinfo. Platform-specific identification, not
mm/VFS/net core.

Record: [drivers/soc/qcom + dt-bindings] [PERIPHERAL / platform-
specific, but in-tree laptops/boards]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
`qcom,ids.h` still receives regular new-ID commits (SM7750, IPQ9650,
SA8797P, …). Mature table, ongoing ID adds.

Record: [active, table-driven ID file]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Users of SDM850 (Lenovo Yoga C630, Samsung w737, Huawei MateBook E 2019,
Comma 3). CONFIG_QCOM_SOCINFO.

Record: [platform-specific Qualcomm SDM850]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Every boot on SDM850 when socinfo probes. Not unprivileged-exploit;
firmware reports id 348.

Record: [every SDM850 boot] [not a security trigger]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Without the ID (and 2/2): SoC not named; sysfs `machine` hidden;
hardware still boots via existing DTS. Not oops/deadlock/corruption.

Record: [wrong/missing SoC name] [LOW functional severity; still a real
ID gap]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: SDM850 identified in socinfo/sysfs, same class as adding a
device ID to an existing driver.
Risk: one `#define`, no runtime logic.

Record: [moderate benefit for those boards] [very low risk] [favorable]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Official `Documentation/process/stable-kernel-rules.rst`: “It must
  either fix a real bug that bothers people **or just add a device
  ID**.”
- User-facing exception: new IDs on an existing driver/table, and DT
  binding for existing hardware.
- 1 line, obviously correct, reviewed by Konrad Dybcio and Krzysztof
  Kozlowski, applied by Bjorn Andersson.
- In-tree SDM850 machines since 2019; this fills the 2022 ID-table gap.
- This tree has `qcom,ids.h`, socinfo, and SDM850 DTS; the hunk matches.

AGAINST:
- Not a crash/UAF/corruption fix.
- Patch 1/2; user-visible naming needs 2/2.
- No user crash report.

UNRESOLVED:
- Could not read lore.kernel.org/stable (HTTP 403). Unlikely to change
  the ID-exception reading.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one define, maintainer
   review/ack/apply.
2. Fixes a real bug that affects users? **PASS** under the written “or
   just add a device ID” clause (identification of in-tree SDM850).
3. Important issue (crash, security, corruption, deadlock)? **PASS** as
   the device-ID exception, not as a crash fix.
4. Small and contained? **PASS** — +1 line, one header.
5. No new features or APIs? **PASS** — no new uAPI; existing ID table.
6. Can apply to the local tree? **PASS** — file and context exist in
   7.3-rc4.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Yes: **new device ID** on the existing Qualcomm ID/socinfo tables, and a
**DT binding addition** for hardware already described in this tree.

**Step 9.4: MAKE YOUR DECISION**
Backport. It is the documented device-ID exception, not a refactor or
new driver. Pairing with `743af1d6a8b4b` is the complete recognition,
but this patch is the ID itself and is appropriate for this tree.

What it solves for this tree: SDM850 (id 348) was missing from
`qcom,ids.h`, so socinfo could not name boards that have been in the
kernel since 2019. That is exactly the “add a device ID” case in stable-
kernel-rules, with essentially no regression risk.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Konrad Dybcio, Acked-by Krzysztof
  Kozlowski, Link to v2 1/2; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 `#define QCOM_ID_SDM850 348` in `include/dt-
  bindings/arm/qcom,ids.h`
- [Phase 3] git blame: neighbors from a79a4b3097bc2 (2022); this line
  from d529495c991a2
- [Phase 3] No Fixes: tag
- [Phase 3] Companion 743af1d6a8b4b adds socinfo `{
  qcom_board_id(SDM850) }`
- [Phase 3] git merge-base --is-ancestor d529495c991a2 HEAD: yes (7.3
  origin, not used as “already selected”)
- [Phase 4] b4 dig -c d529495c991a2:
  https://patch.msgid.link/20260627-sda850-v2-1-44bf46ade42e@ixit.cz
- [Phase 4] b4 dig -a: v1 SDA850 → v2 SDM850 + socinfo consumer
- [Phase 4] b4 dig -w: Bjorn, Konrad, Rob, Krzysztof, Conor, linux-arm-
  msm, devicetree
- [Phase 4] mbox: Acked-by Krzysztof, Reviewed-by Konrad, Applied-by
  Bjorn; cover letter names in-tree SDM850 and Comma 3
- [Phase 4] lore.kernel.org WebFetch/curl: 403
- [Phase 5] grep: only socinfo.c uses QCOM_ID_SDM850 among C files;
  cpufreq/clk do not
- [Phase 5] socinfo_machine() returns NULL for unknown ids; probe still
  succeeds; machine sysfs hidden if NULL
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4
- [Phase 6] ids.h context matches; SDM850 DTS present (sdm850.dtsi
  includes sdm845.dtsi; no qcom,msm-id in those files)
- [Phase 7] subsystem qcom dt-bindings/socinfo
- [Phase 8] failure mode: unnamed SoC in sysfs, not oops
- [Phase 9] Documentation/process/stable-kernel-rules.rst line 15: “or
  just add a device ID”
- UNVERIFIED: stable@ mailing-list archive (HTTP 403)

**YES**

 include/dt-bindings/arm/qcom,ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/arm/qcom,ids.h b/include/dt-bindings/arm/qcom,ids.h
index cb8ce53146f0c..b7ff78cbaa8db 100644
--- a/include/dt-bindings/arm/qcom,ids.h
+++ b/include/dt-bindings/arm/qcom,ids.h
@@ -184,6 +184,7 @@
 #define QCOM_ID_IPQ8078			344
 #define QCOM_ID_SDM636			345
 #define QCOM_ID_SDA636			346
+#define QCOM_ID_SDM850			348
 #define QCOM_ID_SDM632			349
 #define QCOM_ID_SDA632			350
 #define QCOM_ID_SDA450			351
-- 
2.53.0

