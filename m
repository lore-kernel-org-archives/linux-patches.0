Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AE15DE9B6;
	Mon, 19 Oct 2026 14:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418538; cv=none; b=VrBXJ4i//Pu9qcKfg5eWsAmxwUzm4oifQZXkM3LqI93xwaVDllO9qZoscaLlVss4rC2g1MIvkg0drb2318gOmiYyXsyF86pZipaCknAqDivoheMik7jKht0GGytM3KJCJlkyHOuIfinWo6MVaHezdFQ0MHlvvEOOcfLQZTAP/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418538; c=relaxed/simple;
	bh=wYz2ykWVtMcmbYXF98u+dcQ2DEnpsBrSBPHeuumRTNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdY131atQg1LGpBTWvEKupM/K557L1WLaKaV47jkpWhXe4sZFXPAgTx86lUiC7ie/OVsm34ycoiGvrbbxM2ife2bVwqaOaipGrTju864X6tSjI/F7wlq9VOL8eRV4vkVYyuGXM7mEpqa5Qmlypztn3sJkoWlIwEHh/5foGgNYLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGT/9LEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGT/9LEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3B01F000C6;
	Mon, 19 Oct 2026 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418536;
	bh=lnmMdiRihI7doar/6y0AnWxtq+WHN77C7jiP0sBXVD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGT/9LEiZkP3EIftAR+QPOL4gp09fbxsejQKh6y1FEU1oOrE5R8+sW8DmFql2ort3
	 7V/JufhzJPmUMmC3wkrYQaARLuN+bHJJORl7yPZrOXnIKyDFbve2rhRvBmO9hEuVCX
	 lVlKTI6EDWEbIi+YeXDleAQ0QFlJjdU7RUx9XUVBx7EKYzbGOCaDeqJW7tBkBaCIfW
	 UqEOSDgyqTTCLhuIm56MdhPnVZg0wksj0jpck/lmIk/awHeMp9DzNNj5G5+ioUvj07
	 EYMTSGcy6wC93xVMtxg9xgSygxgjQ50dYeCaWMhIl1bwH/gXoQtsODu1hhPPAKEvQ1
	 K64+DPXXGJoDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	konradybcio@kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] soc: qcom: socinfo: Add SoC ID for SDM850
Date: Mon, 19 Oct 2026 09:50:09 -0400
Message-ID: <20261019135441.1420968-318-sashal@kernel.org>
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

[ Upstream commit 743af1d6a8b4bfa62dd01b5c2d81b1c62ea597f7 ]

Recognize the SDM850 SoC.

Signed-off-by: David Heidelberg <david@ixit.cz>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
verdict below is only for this checkout: the socinfo table and
`QCOM_ID_SDM850` are present here, so the one-line SoC ID addition is a
valid hardware-ID backport.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[soc: qcom: socinfo]** **[Add]** **SoC ID table entry so
SDM850 is recognized by qcom-socinfo**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Fixes: none (expected for this review)
- Reported-by: none
- Tested-by: none
- Reviewed-by: none on this commit (patch 1 of the series has Reviewed-
  by Konrad Dybcio)
- Acked-by: Krzysztof Kozlowski \<krzysztof.kozlowski@oss.qualcomm.com\>
- Link:
  https://lore.kernel.org/r/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
- Cc: stable: none (expected)
- Signed-off-by: David Heidelberg \<david@ixit.cz\> (author); Bjorn
  Andersson \<andersson@kernel.org\> (qcom SoC maintainer). Ignored: any
  Sasha Levin SOB (none in the provided message)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug description: SDM850 (numeric SMEM id 348) is not in the socinfo
  `soc_id[]` table, so the driver cannot map it to a name.
- Symptom/failure mode: `/sys/devices/soc0/machine` is omitted (NULL
  machine name). Numeric `soc_id` still works. Not a crash.
- Version information: none in the message. Cover letter (from the lore
  mbox): “Useful for sdm850 devices in tree and also will be used by
  Comma AI comma three.”
- Root cause: missing table entry, not a logic bug.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden crash/UAF/leak fix. It is an explicit **missing
hardware ID**. That is the documented stable exception for new device
IDs on an existing driver.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/soc/qcom/socinfo.c` — **+1 / −0**
- Function: static table `soc_id[]` (not a function body)
- Scope: **single-file surgical ID addition**

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before, `socinfo_machine()` walked `soc_id[]` and returned NULL
for id 348. After, id 348 matches `QCOM_ID_SDM850` and returns
`"SDM850"`. Path: `qcom_socinfo_probe()` → `socinfo_machine()` →
`soc_device_register()`. Normal probe path only; no error-path or
locking change.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Hardware ID / device-ID table]** Missing
`qcom_board_id(SDM850)` so SMEM id 348 is unnamed. Macro expands to
`QCOM_ID_SDM850, "SDM850"` via `qcom_board_id()`.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct one-liner, same pattern as neighboring IDs
(SDM636/SDM632). Regression risk is very low: table is append-only
lookup; no lock, alloc, or API change. Compile dependency:
`QCOM_ID_SDM850` must exist in `include/dt-bindings/arm/qcom,ids.h` (it
does in this tree).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Insertion sits between SDA636 and SDM632, both from
`34ec89e68db26` (2022-10-17, “soc: qcom: socinfo: create soc_id table
from bindings”). The table format has been stable since then. SDM850 DT
has been in tree much longer (`44acee2078447` Yoga C630, 2019-09-05;
`6be4ba5467bed` sdm850.dtsi, 2021-01-15).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. This fills a gap for hardware
whose DT was added years ago, not a regression from a specific commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: This is **patch 2/2** of “Recognize Snapdragon SDM850”. Patch 1:
`dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850`
(`d529495c991a2b` in the qcom tree; also `4e926dc3d6ad3` via arm-soc).
Recent socinfo history is mostly other SoC/PMIC ID adds. Standalone on
this tree because the `#define` is already here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: David Heidelberg authored both series patches on these paths.
Not the subsystem maintainer. Maintainer path: Ack from Krzysztof
Kozlowski, merge by Bjorn Andersson.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **Depends on `QCOM_ID_SDM850` (348)** in `qcom,ids.h`. Verified
present at `include/dt-bindings/arm/qcom,ids.h:187`. `git merge-base
--is-ancestor` confirms both the socinfo commit `743af1d6a8b4b` and the
header commit are ancestors of HEAD. Can apply standalone **on this
tree**. Applying only socinfo without the define would not compile
(`QCOM_ID_SDM850` undeclared). Parent of `743af1d6a8b4b` did **not**
have the define (header landed on a different path/timing).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/msgid:
  https://patch.msgid.link/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
- Direct lore.kernel.org fetch: **403** (could not read HTML); full
  thread saved via `b4 dig -m` to `/tmp/sdm850-thread.mbox`
- Revisions: **v1** (2026-06-23) was only the dt-bindings patch, titled
  SDA 850; **v2** (2026-06-27) renamed to SDM850 (Konrad) and added this
  socinfo consumer (Krzysztof). Applied version is v2/2, the latest.
- Reviewer feedback: Ack from Krzysztof on both patches; Reviewed-by
  Konrad on patch 1; Bjorn Andersson applied both on 2026-07-05. No
  NAKs. No reviewer `Cc: stable`.
- Cover letter: in-tree SDM850 devices + Comma AI comma three.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Bjorn Andersson, Konrad Dybcio, Rob
Herring, Krzysztof Kozlowski, Conor Dooley, linux-arm-msm, devicetree,
linux-kernel. Right maintainers were on the thread.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Motivation is missing ID for already-
supported boards, not a crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Two-patch series only. No further enablement patches in the
thread. Patch 1 is the header define (already in this tree).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — lore.kernel.org/stable search and WebSearch
both failed (403 / tool error). No stable discussion in the captured
msm/devicetree thread.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table `soc_id[]` only. Consumers: `socinfo_machine()`, called
from `qcom_socinfo_probe()`.

Step 5.2: TRACE CALLERS
Record: `socinfo_machine()` is static, one caller:
`qcom_socinfo_probe()`. Platform driver `qcom-socinfo`
(`CONFIG_QCOM_SOCINFO`, default `m` if `ARCH_QCOM`). Probe at Qualcomm
SoC boot via SMEM `SMEM_HW_SW_BUILD_ID`. Not IRQ/hot-path. Userspace-
visible via soc bus sysfs.

Step 5.3: TRACE CALLEES
Record: Probe uses `qcom_smem_get()`, `soc_device_register()`, debugfs
init, `add_device_randomness()`. This patch does not change those calls.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Boot on SDM850 (Yoga C630, Samsung W737, Huawei Matebook E,
etc.) → qcom-socinfo probe → SMEM id 348 → name lookup. Reachable on
real shipped ARM64 laptops already described in this tree’s DT. Not a
syscall fuzzer path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Many sibling “Add SoC ID for …” commits in the same table. No
in-tree `soc_device_match()` on `"SDM850"` / `"SDM845"` (grep of
drivers). Impact is sysfs/userspace identification, not in-kernel quirk
matching.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `drivers/soc/qcom/socinfo.c` `soc_id[]` and
`socinfo_machine()` exist. Header define exists. SDM850 DT:
`arch/arm64/boot/dts/qcom/sdm850.dtsi` plus board files. Without this
line, id 348 stays unnamed. The gap existed from the 2022 table
conversion until this 2026 add; hardware DT is from 2019–2021.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this tree: neighbors SDA636/SDM632 match the
hunk. Same `qcom_board_id()` helper. Prerequisite `#define
QCOM_ID_SDM850 348` is present.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This exact line is already in HEAD (`git merge-base --is-
ancestor 743af1d6a8b4b HEAD` succeeded; blame line 428 is that commit).
Per instructions that is **not** used as a “already selected” veto; it
confirms the change is valid in this codebase. No alternate fix for id
348.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drivers/soc/qcom** (Qualcomm socinfo). **IMPORTANT** for
ARCH_QCOM users, not core mm/net. Identification only; does not bind a
new driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively updated (many recent SoC/PMIC ID commits). Table-add
pattern is mature and repetitive.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Platform-specific** — Qualcomm SDM850 boards (in-tree: Lenovo
Yoga C630, Samsung Galaxy Book2 / w737, Huawei Matebook E 2019). Cover
letter also cites Comma three. Only if `CONFIG_QCOM_SOCINFO` is enabled
(default on ARCH_QCOM).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot on SDM850 once socinfo probes. Not a race.
Unprivileged users only observe sysfs; they cannot trigger a crash with
this bug.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Missing `/sys/devices/soc0/machine` (attribute mode 0 when
`machine` is NULL in `soc_attribute_mode()`). Numeric soc_id still
exported. **Severity: LOW** as a crash/corruption issue; **hardware
identification** as a device-ID exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit: correct SoC name for real shipping devices already
supported by this tree. Risk: **very low** (1 line, data-only). Ratio:
favorable under the device-ID exception.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Documented stable exception: new device/SoC ID on an existing driver
- One line, same idiom as the rest of `soc_id[]`
- Real hardware: in-tree SDM850 DTs since 2019–2021
- Acked by Krzysztof Kozlowski; applied by Bjorn Andersson
- Prerequisite `QCOM_ID_SDM850` is in this 7.3-rc4 tree
- No locking/API/behavior change for other SoCs

AGAINST:
- Not a crash, UAF, deadlock, or data-corruption fix
- No Cc: stable / Fixes (expected; not a negative)
- Userspace-visible name fill-in, not driver probe

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403 / search failure)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one table entry; maintainer
   ack; merged to qcom/arm-soc
2. Fixes a real bug that affects users? **PASS** — missing ID for
   shipping SDM850 machines (Yoga C630 and others)
3. Important issue (crash, security, corruption, deadlock)? **FAIL** as
   those classes; **PASS** via device-ID exception
4. Small and contained? **PASS** — +1 line, one file
5. No new features or APIs? **PASS** — no new syscall/sysfs ABI; fills
   existing soc bus `machine` attribute
6. Can apply to the local tree? **PASS** — table and `QCOM_ID_SDM850`
   exist here

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **NEW DEVICE ID** on an existing driver (`qcom-socinfo`).
Analogous to adding a PCI/USB ID.

Step 9.4: MAKE YOUR DECISION
This is a one-line SoC ID for hardware this tree already describes. It
does not add a driver or API. Benefit is correct identification on
SDM850; risk is negligible. That matches the stable device-ID exception,
so it should be backported to this tree.

**What it solves for stable users:** SDM850 reports as an
unknown/unnamed SoC in socinfo sysfs. Users of Yoga C630-class machines
and similar need the name for inventory/userspace matching.

**Risk vs benefit:** Data-only lookup add; no runtime regression path
identified.

**Concerns:** Must keep the header define (`QCOM_ID_SDM850` / 348). That
define is already in this checkout, so this commit is self-contained
here.

Verification:
- [Phase 1] Subject/tags: Add SoC ID; Acked-by Krzysztof Kozlowski; Link
  msgid 20260627-sda850-v2-2; no Fixes/Reported-by/Cc: stable
- [Phase 1] Cover letter from mbox: in-tree sdm850 devices + Comma AI
  comma three; v2 renamed SDA850→SDM850
- [Phase 2] Diff: +1 line `{ qcom_board_id(SDM850) }` in `soc_id[]` of
  `drivers/soc/qcom/socinfo.c`
- [Phase 2] `qcom_board_id(id)` → `QCOM_ID_ ## id, __stringify(id)` at
  socinfo.c:25
- [Phase 2] `socinfo_machine()` returns NULL if no match (lines
  562–571); probe sets `qs->attr.machine` (913–914)
- [Phase 2] `soc_attribute_mode()` hides machine sysfs when machine is
  NULL (drivers/base/soc.c:54–55)
- [Phase 3] `git describe HEAD` / `make kernelversion`: v7.3-rc4-27 /
  7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor 743af1d6a8b4b HEAD`: yes; also
  in v7.3-rc1
- [Phase 3] Prerequisite header commits `d529495c991a2b` and
  `4e926dc3d6ad3` are ancestors of HEAD; `#define QCOM_ID_SDM850 348` at
  qcom,ids.h:187
- [Phase 3] Parent of socinfo commit lacked the define (would not
  compile alone against that parent)
- [Phase 3] Blame: neighbors from 34ec89e68db26 (2022); this line from
  743af1d6a8b4b
- [Phase 3] SDM850 DT: `git log --diff-filter=A` → 44acee2078447 (2019),
  6be4ba5467bed (2021)
- [Phase 4] `b4 dig -c 743af1d6a8b4b`: matched v2 2/2; `-a` showed v1
  then v2; `-w` listed qcom/dt maintainers; `-m` saved thread
- [Phase 4] mbox: Krzysztof Ack both; Konrad Reviewed-by on patch 1;
  Bjorn “Applied, thanks!”; no NAK, no Cc: stable
- [Phase 4] lore.kernel.org WebFetch 403; stable list search UNVERIFIED
- [Phase 5] Only caller of `socinfo_machine` is `qcom_socinfo_probe`; no
  in-tree `soc_device_match` on SDM850
- [Phase 6] Local files exist; insertion context matches;
  `CONFIG_QCOM_SOCINFO` in drivers/soc/qcom/Kconfig
- [Phase 8] Failure mode: missing sysfs machine name, not oops; SDM850
  boards listed under arch/arm64/boot/dts/qcom/

**YES**

 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 963772f45489d..79a0defe73227 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -359,6 +359,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(IPQ8078) },
 	{ qcom_board_id(SDM636) },
 	{ qcom_board_id(SDA636) },
+	{ qcom_board_id(SDM850) },
 	{ qcom_board_id(SDM632) },
 	{ qcom_board_id(SDA632) },
 	{ qcom_board_id(SDA450) },
-- 
2.53.0

