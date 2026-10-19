Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DEA64237F;
	Mon, 19 Oct 2026 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418786; cv=none; b=KomAY3HpKd7jRhJjEVUkGZga1r2VdEuhdDLy4vviTNHBjlVJFu+wYabdR29ZBNwtNaniPd3aM7QPnY/Wyu7p3Kj01uwa3y2eGwUN0Bph5ZYqzhz3nRdUDBcUDq+wNFSCVo657kTvdlO7y+/iQW0T3XzFhwo/7D4/Gn/TwoCbAh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418786; c=relaxed/simple;
	bh=pygUcnzaksX9aU8kJ88BWTM71IAxaDaqLTBnSiwPHag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgfvqb/G2Qts4mIM8M9hKlI4LjG2anjPbVxgkL2UkxSYiRaLwvjFrXEWDCOdkGwGF3FAiNNTw/7AKdQvfD44kBfUdvd7E5mcBbKI4xBorBdhdG/Xdr8pASD5KK/Vt0mxkHGNeJhVUiVWWWAesDBa16KqdRY2OEbEqrEh/RYX9pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCKdYXhA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCKdYXhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F451F000C7;
	Mon, 19 Oct 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418783;
	bh=+zdzCHQBF84phwrViAwt8IDjEeqG5XBif9izD52XHEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCKdYXhA1LpdN9IF42ifafMvinE+7DyUltDx/1WXXgVGeTGKT8rfaIkbPSqr1b7PK
	 DYvYCpR8BqLrfqnkCaAyrW0hjpDQIrEFYEJbQIyjEZjVfa1eqfxSK46qOuOtGYHt7m
	 2MiAiUwbb2LNyuPyb7wrmWHwA5cdYnObsJ0OecgSZS+65VIzapfhPEoVTGLxkvej1Q
	 tDscrCIhuhA/c+mfsMvTclL39zSiW21DGLlu2VwoWejpy0+MLvdd8a4Px4CZ+9R3Ys
	 hEoOX9mLKj9FeRLmvf6onvPU7uYsc6vmtff+P5IMdOcIyMc7+3v2mzmydSKuM0GexG
	 ZFAdn3Y2OF4uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Muralidhara M K <muralidhara.mk@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	naveenkrishna.chatradhi@amd.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86/amd/hsmp: Validate _DSD mailbox sub-package element count
Date: Mon, 19 Oct 2026 09:53:04 -0400
Message-ID: <20261019135441.1420968-493-sashal@kernel.org>
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

From: Muralidhara M K <muralidhara.mk@amd.com>

[ Upstream commit 0d7a2664494534d6152be9bd9bf1cb1d089c67d3 ]

hsmp_read_acpi_dsd() dereferenced elements[0] and elements[1] of each
mailbox sub-package before confirming the package actually held two
elements, allowing an out-of-bounds read on a malformed _DSD.

Verify package.count >= 2 first, then fetch the string and integer
objects.

Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260625123337.886435-3-muralidhara.mk@amd.com
Link: https://patch.msgid.link/20260629155634.1807598-3-muralidhara.mk@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[platform/x86/amd/hsmp] [Validate] [check _DSD
mailbox sub-package count before indexing elements[0]/[1]]`

**Step 1.2:** Record: tags present:
- `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (platform-drivers-x86 maintainer)
- `Link: https://patch.msgid.link/20260625123337.886435-3-
  muralidhara.mk@amd.com` (v2 7-patch series)
- `Link: https://patch.msgid.link/20260629155634.1807598-3-
  muralidhara.mk@amd.com` (v2 4-patch series, applied version)
- `Signed-off-by: Muralidhara M K <muralidhara.mk@amd.com>` (author)
- `Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (maintainer apply)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected)
- No syzbot, no Tested-by, no CVE

**Step 1.3:** Record: `[Bug: hsmp_read_acpi_dsd() indexed mailbox sub-
package elements[0] and elements[1] before checking package.count]
[Symptom: out-of-bounds read on malformed ACPI _DSD] [Versions: none
stated] [Root cause: missing count check before pointer fetch]`

Cover letter for the 4-patch series: “This series hardens the AMD HSMP
ACPI driver against malformed firmware.” Patches 1–2 are ACPI input
validation; this is patch 2.

**Step 1.4:** Record: `[Not disguised. Explicit OOB-read fix. “Validate”
here is a real bounds check, not style cleanup.]`

## Phase 2: Diff analysis

**Step 2.1:** Record: `[drivers/platform/x86/amd/hsmp/acpi.c: +9/-3]
[function: hsmp_read_acpi_dsd] [single-file surgical fix]`

**Step 2.2:** Record: Before: after `msgobj =
&mailbox_package->package.elements[j]`, the code immediately did `msgstr
= &msgobj->package.elements[0]` and `msgint =
&msgobj->package.elements[1]`, then checked `msgobj->type`,
`msgstr->type`, and `msgint->type`. After: check `msgobj->type !=
ACPI_TYPE_PACKAGE || msgobj->package.count < 2` first (`||` short-
circuits, so `.package.count` is not read on a non-package), then take
the two element pointers, then check string/integer types. Probe error
path: malformed firmware now returns `-EINVAL` instead of reading off
the end of the ACPI object array.

**Step 2.3:** Record: `[Bug category: buffer overflow / out-of-bounds
AND type-confused union access] [Mechanism: ACPI package elements array
is sized to package.count; count 0 or 1 makes elements[0]/elements[1]
OOB. Type was also checked after the dereference, so a non-PACKAGE
object was read as a package.]`

**Step 2.4:** Record: `[Obviously correct: reorder of existing checks
plus one count test. No unrelated edits. Regression risk very low: well-
formed _DSD (count >= 2, string+integer) is unchanged; only malformed
firmware takes the new -EINVAL path.]`

## Phase 3: Git history

**Step 3.1:** Record: `[Buggy dereference introduced in ba8dcff0e9c4f
("platform/x86/amd/hsmp: Add support for ACPI based probing",
2024-01-06). First in v6.9. Moved unchanged to acpi.c in 969f915473d8c
(v6.13). Present for ~2 years before this fix.]`

**Step 3.2:** Record: `[No Fixes: tag. Original buggy commit
ba8dcff0e9c4f is an ancestor of this HEAD.]`

**Step 3.3:** Record: `[Sibling series (self-contained, this patch does
not need the others):`
- `4c7d1b4cd75a7 Validate ACPI UID before parsing socket index (1/4)`
- `0d7a266449453 this commit (2/4)`
- `b558cbed39af2 Pass struct device explicitly (3/4, pure refactor)`
- `e5e511f5d9e05 Gate the data plane on a fully initialized socket
  (4/4)`
`] [Standalone: yes. No shared types or helpers.]`

**Step 3.4:** Record: `[Author Muralidhara M K is an AMD HSMP
contributor (many HSMP commits). Subsystem maintainers: Naveen Krishna
Chatradhi (MAINTAINERS), applied/reviewed by Ilpo Järvinen (pdx86).]`

**Step 3.5:** Record: `[No functional prerequisites. Later HEAD commit
b558cbed39af2 changed the prototype to hsmp_read_acpi_dsd(struct device
*dev, struct hsmp_socket *sock); that is a follow-up, not a dependency
of this bounds check.]`

## Phase 4: Mailing list

**Step 4.1:** Record: `[b4 dig: https://patch.msgid.link/20260629155634.
1807598-3-muralidhara.mk@amd.com] [Revisions: combined UID+_DSD patch as
2/7 on 2026-06-25; split to 2/4 on 2026-06-29 after Ilpo asked for a
split; applied version is that 2/4] [Ilpo: “totally independent changes
so they should be split”; then Reviewed-by. No NAK, no stable
nomination, no concern about the OOB logic itself.]`

**Step 4.2:** Record: `[To: Ilpo Järvinen; Cc: platform-
driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org. Right
maintainer and list.]`

**Step 4.3:** Record: `[No bugzilla/syzbot report. Bug was found by
review of the ACPI parser, not a user crash. Cover letter: “based on the
review discussion at [1]”.]`

**Step 4.4:** Record: `[Part of a 4-patch hardening series. This hunk is
independent. Patch 3 is explicitly “pure refactor”; patch 4 is a
different race. Do not need 3/4 or 4/4 for this OOB fix.]`

**Step 4.5:** Record: `[lore.kernel.org/stable search returned HTTP 403.
UNVERIFIED: no confirmed stable-list discussion.]`

## Phase 5: Code semantics

**Step 5.1:** Record: `[hsmp_read_acpi_dsd]`

**Step 5.2:** Record: `[Callers: hsmp_parse_acpi_table() → init_acpi() →
hsmp_acpi_probe(). Probe of the AMD HSMP ACPI platform device
(CONFIG_AMD_HSMP_ACPI). Not interrupt context, not a syscall. One call
site.]`

**Step 5.3:** Record: `[acpi_evaluate_object_typed("_DSD"),
is_acpi_hsmp_uuid(), strncmp on MSG_*_STR, ACPI_FREE. No locks, no
allocation beyond the ACPI buffer already obtained.]`

**Step 5.4:** Record: `[Reachable at driver bind when firmware exposes
the HSMP ACPI object (EPYC / MI300A). Unprivileged userspace cannot
inject a malformed _DSD on a normal system; the trigger is firmware.
Broken/tampered ACPI tables can hit it at probe.]`

**Step 5.5:** Record: `[Outer _DSD package already checks
dsd->package.count != 2 before elements[0]/[1]. Only the inner mailbox
sub-packages lacked a count check. No other copy of this inner loop.]`

## Phase 6: This tree (v7.3-rc4)

**Step 6.1:** Record: `[Local tree: v7.3-rc4-27-gf0100363d8c37,
kernelversion 7.3.0-rc4. File and function exist. Bug introduced in
v6.9, long before 7.3. Current working tree already contains the count
check (this commit is an ancestor of HEAD). Evaluating the pre-fix
logic: the OOB was in this lineage.]`

**Step 6.2:** Record: `[On this checkout the change is already present;
a re-apply of the raw diff would not match because (a) the check is
already there and (b) b558cbed39af2 later changed the function
signature. That is history of this development tree, not a missing
prerequisite. The fix itself is a 12-line reorder in one function.]`

**Step 6.3:** Record: `[No alternate fix for this OOB. git log
--grep='mailbox sub-package' on this path only finds this commit.]`

## Phase 7: Subsystem context

**Step 7.1:** Record: `[platform/x86 AMD HSMP ACPI driver] [PERIPHERAL /
IMPORTANT-for-EPYC-servers: Host System Management Port mailbox on AMD
EPYC and MI300A, CONFIG_AMD_HSMP_ACPI]`

**Step 7.2:** Record: `[Active in 2026: concurrency/lifecycle series
plus metric-table work. Parser bug itself dates to the original ACPI
probe support (v6.9), so it is old code, not a last-month feature.]`

## Phase 8: Impact and risk

**Step 8.1:** Record: `[Affected users: systems with
CONFIG_AMD_HSMP_ACPI and an HSMP ACPI device (AMD EPYC / MI300A
servers). Not universal.]`

**Step 8.2:** Record: `[Trigger: probe-time parse of ACPI _DSD mailbox
sub-packages with count < 2 or non-PACKAGE type. Common on correct AMD
BIOS: no. Possible with broken BIOS, firmware fuzzing, or ACPI table
tampering. Unprivileged users cannot trigger it via a syscall.]`

**Step 8.3:** Record: `[Failure mode: out-of-bounds read of union
acpi_object (KASAN OOB / possible oops during probe). Severity: HIGH if
firmware is malformed; LOW on well-formed production BIOS. Probe failure
is preferable to an OOB.]`

**Step 8.4:** Record: `[Benefit: closes a real memory-safety hole in a
production server driver, cheaply. Risk: very low (error path only, same
success path). Ratio: favorable.]`

## Phase 9: Synthesis

**For backporting:** Real OOB (and type-confused union access) in
`hsmp_read_acpi_dsd()`. Small (+9/-3), obviously correct, maintainer-
reviewed. Driver and buggy pattern exist in this tree’s history since
v6.9. No series dependency. Matches stable rules for memory-safety
fixes.

**Against:** No user/syzbot report; firmware-only trigger; driver is not
core kernel. Cover letter calls it “hardening.” This 7.3-rc4 checkout
already contains the commit.

**Unresolved:** Stable mailing list search was HTTP 403.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — reorder + count check; Ilpo
   Reviewed-by; W=1/checkpatch claimed on the series.
2. Real bug affecting users? **PASS** — OOB on malformed _DSD;
   EPYC/MI300A with bad firmware would oops or KASAN-fail at probe.
3. Important (crash/security/corruption/deadlock)? **PASS** — OOB read
   is a crash/memory-safety issue. Not a wild userspace exploit, but
   still an important class.
4. Small and contained? **PASS** — one function, 12 lines.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — the file/function exist here; the
   change is the right fix for this parser. (HEAD already has the
   equivalent code.)

**Exception category:** none (not a device ID/quirk/DT/build/doc patch).
It is a normal memory-safety bugfix.

This tree is 7.3.0-rc4. The HSMP ACPI `_DSD` parser is present. The bug
is a genuine out-of-bounds read of ACPI package elements, not a
refactor. The success path is unchanged. That is stable-quality on
technical merit.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Ilpo; two msgid Links; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +9/-3 in `hsmp_read_acpi_dsd()`; count check before
  `elements[0]/[1]`
- [Phase 3] `git blame` on parent: lines from 969f915473d8c; semantic
  intro `ba8dcff0e9c4f` (in v6.9, ancestor of HEAD)
- [Phase 3] No Fixes: tag; `git merge-base --is-ancestor ba8dcff0e9c4f
  HEAD` yes
- [Phase 3] Series 1/4–4/4 identified; this patch does not need 3/4 or
  4/4
- [Phase 4] `b4 dig -c 0d7a266449453`: lore URL above; `-a` showed
  7-patch then 4-patch split; `-w` To Ilpo + pdx86
- [Phase 4] Ilpo 2026-06-26: split request + Reviewed-by; no NAK on the
  OOB fix
- [Phase 4] lore.kernel.org WebFetch 403; stable list UNVERIFIED
- [Phase 5] Call chain: `hsmp_acpi_probe` → `init_acpi` →
  `hsmp_parse_acpi_table` → `hsmp_read_acpi_dsd`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; file present; `git merge-base --is-
  ancestor 0d7a266449453 HEAD` yes
- [Phase 8] Failure mode: OOB ACPI object read at probe; HIGH if
  firmware malformed
- UNVERIFIED: whether stable@ discussed this (lore 403)

**YES**

 drivers/platform/x86/amd/hsmp/acpi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/hsmp/acpi.c b/drivers/platform/x86/amd/hsmp/acpi.c
index 674be31654776..8f297d52ab5e3 100644
--- a/drivers/platform/x86/amd/hsmp/acpi.c
+++ b/drivers/platform/x86/amd/hsmp/acpi.c
@@ -152,12 +152,18 @@ static int hsmp_read_acpi_dsd(struct hsmp_socket *sock)
 		union acpi_object *msgobj, *msgstr, *msgint;
 
 		msgobj	= &mailbox_package->package.elements[j];
-		msgstr	= &msgobj->package.elements[0];
-		msgint	= &msgobj->package.elements[1];
 
 		/* package should have 1 string and 1 integer object */
 		if (msgobj->type != ACPI_TYPE_PACKAGE ||
-		    msgstr->type != ACPI_TYPE_STRING ||
+		    msgobj->package.count < 2) {
+			ret = -EINVAL;
+			goto free_buf;
+		}
+
+		msgstr	= &msgobj->package.elements[0];
+		msgint	= &msgobj->package.elements[1];
+
+		if (msgstr->type != ACPI_TYPE_STRING ||
 		    msgint->type != ACPI_TYPE_INTEGER) {
 			ret = -EINVAL;
 			goto free_buf;
-- 
2.53.0

