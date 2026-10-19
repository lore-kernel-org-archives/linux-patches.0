Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831565D5D9C;
	Mon, 19 Oct 2026 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418507; cv=none; b=DUuUfd4uqHXYP3K/mHWKqyXxNzAtB38uZFPf0taE49mj/JHcb1oKIq/6O0WnqjfXEGfwshUirxtOLqQo4azV1LKaP2rbwIv+gTM/s0yAjFd6mqDlmZpX/xYXfgkuIjwg5enOKgx5FurSd2Ir6xzeiRcmvKyYJoJfKNr8TFpjprs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418507; c=relaxed/simple;
	bh=9mzw2mITOQXRw81kHHL08Ce4CnHAtf2EjIxCfonuETY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jr72uf6UznGON+xepysOSsPrXcxfiY7XSGYY3h8rqS5RM/McaHk8NTnXxCsSqL276knzWHSWTAND8J0XCYkB1ik6aS4meUHRJ2vbR8pQfR3nkEETV8P37I6NSkhsD545SQPyhN2W/CVUwsl0CYJRlGeSmR+UvN9ZG0dWFrLZw9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWd5iT2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWd5iT2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DDE1F000CA;
	Mon, 19 Oct 2026 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418505;
	bh=av2i/a27mFO35q2gQgrs5PYUW708u+igcVfoCp20+Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWd5iT2JmLsYfhiq+yCC8rgx8ZJrJWcIpnqGhXWv+ZT4VvsWPzcPGQXoxkATlRgtL
	 qxoosAtayMUDLHosAJpj5ZVUI1EcwnRlsSpR18hdV49HEyIhLWk9tGxo6DeTYWj0+m
	 B7JNkIZdzJ05Q8/8tcRvBre+RZGRVmqYh/LHD8Nl2vXWfbSZYEf2bBcSaGTuizx24b
	 Z7evQ+M99HefDDHe81oVS37zYN55M1w2/qIAme+SwvZ+OOebWwmoxMDFu6TVhjy6Vt
	 7nXPKwgq0KiuxHWCACqjZpeiwLc9QFfbaycqaSgouSQzbYPe6zz8owwEXgupef+FQ/
	 vlLgUwwU0FY6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Esteban Urrutia <esteuwu@proton.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	robin.clark@oss.qualcomm.com,
	joro@8bytes.org,
	iommu@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iommu/arm-smmu-qcom: Add SM8450 MDSS compatible
Date: Mon, 19 Oct 2026 09:49:47 -0400
Message-ID: <20261019135441.1420968-296-sashal@kernel.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit d149c8b2c0146a01f1be326ddb1e182b55aee638 ]

Add the compatible for the MDSS client on the Snapdragon 8 Gen 1 so it can
be properly configured by the IOMMU driver.

Otherwise, there is an unhandled context fault, because the framebuffer is
already configured in UEFI.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[iommu/arm-smmu-qcom] [Add] SM8450 MDSS compatible so the
Qualcomm SMMU driver can configure that display client`

**Step 1.2: Tags**
Record:
- `Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>`
  (Qualcomm SoC/display maintainer)
- `Signed-off-by: Esteban Urrutia <esteuwu@proton.me>` (author)
- `Signed-off-by: Will Deacon <will@kernel.org>` (IOMMU/arm-smmu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
  stable@vger.kernel.org` (absence is expected for this review)

**Step 1.3: Body**
Record:
- Bug: SM8450 MDSS is missing from `qcom_smmu_client_of_match`, so it
  does not get the identity-domain workaround.
- Symptom: unhandled ARM SMMU context fault because UEFI already
  programmed the framebuffer with physical addresses.
- Root cause: without a match, `qcom_smmu_def_domain_type()` returns 0
  and the IOMMU uses a translated DMA domain instead of identity
  mapping.
- Version info: none in the message. SM8450 display support has been in
  this tree since v6.3 (`drm/msm: mdss add support for SM8450`).

**Step 1.4: Hidden bug fix?**
Record: Not hidden. The subject says “Add”, but the body describes a
real hardware workaround (IOMMU identity domain for a bootloader-
configured display), not a new feature.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c` (+1 / −0)
- Function: static table `qcom_smmu_client_of_match[]`
- Scope: single-file, one-line compatible addition

**Step 2.2: Code flow**
Record: Before, `of_match_device(qcom_smmu_client_of_match, dev)` misses
`qcom,sm8450-mdss`, so `qcom_smmu_def_domain_type()` returns 0. After,
that compatible matches and the function returns
`IOMMU_DOMAIN_IDENTITY`. Path: IOMMU default-domain selection at MDSS
probe, not an error path.

**Step 2.3: Bug mechanism**
Record: Hardware workaround / device-ID (compatible) addition. MDSS
streams keep using the UEFI framebuffer mapping. Without identity domain
those accesses translation-fault (`arm-smmu: Unhandled context fault`).
Same pattern as SM6115, SDM670, X1E80100, QCM2290, SC8280XP.

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. Only devices with
`qcom,sm8450-mdss` change behavior. Regression risk is very low;
neighboring SoCs already use this table the same way. ACTLR table
already listed `qcom,sm8450-mdss`; the client table was the omission.

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Table introduced in `0e764a01015df` (2020, “Allow client devices to
  select direct mapping”).
- This line added by `d149c8b2c0146` (2026-07-22).
- SM8450 MDSS driver: `80056d9ac47ab` (2023-01-12, v6.3-rc1).
- SM8450 DT: `a6dd1206e45a4` (2022-12-28).
- Bug window: from v6.3 until this commit (about three years).

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. Implicit introducer is `80056d9ac47ab` adding
SM8450 MDSS without the IOMMU match. That driver and DT are in this
tree.

**Step 3.3: File history**
Record: Several sibling “Add … MDSS compatible” commits (`f7fa8520f3037`
SM6115, `12721e6600579` X1E80100, `28af105cb6504` QCM2290,
`270a1470408e4` SDM670, `617937d4d5533` Glymur). Standalone one-line
table entries; SM6115 even had `Cc: stable` and crash logs. No extra
prerequisite beyond the existing match table.

**Step 3.4: Author**
Record: Esteban Urrutia has only this IOMMU commit here. Reviewed by
Konrad Dybcio; applied by Will Deacon. Not a drive-by unreviewed change.

**Step 3.5: Dependencies**
Record: Needs `qcom_smmu_client_of_match` /
`qcom_smmu_def_domain_type()` and a `qcom,sm8450-mdss` client. All
present. No new APIs. Applies as a one-line insert next to
`qcom,sm8250-mdss`.

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- `b4 dig -c d149c8b2c0146` →
  https://patch.msgid.link/20260711-sm8450-qol-
  smmu-v2-1-41a6fba41c3e@proton.me
- v1: 8-patch “sm8450-qol” series (2026-06-22)
- v2: this patch split out alone (2026-07-11)
- Will Deacon: “Applied to iommu (arm/smmu/updates), thanks!” — no NAK
- Cover note: “This patch allows the MDSS driver to properly function on
  SM8450 based devices.”
- lore.kernel.org fetches returned 403; content confirmed via patchew
  and LKML mirror.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Will Deacon, Robin Murphy, Joerg Roedel, Rob Clark, Konrad
Dybcio; lists `iommu@`, `linux-arm-msm@`, `linux-arm-kernel@`, `phone-
devel@`. Right maintainers and lists.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Author describes the UEFI framebuffer
context-fault. Same failure as SM6115 (`f7fa8520f3037`): flood of
`Unhandled context fault` and failed DPU/GPU bind.

**Step 4.4: Series**
Record: v2 is standalone. Other v1 QoL patches (dispcc, dts, qmp) are
not required for this one-line match.

**Step 4.5: Stable list**
Record: No stable-thread hit for this subject. Precedent: SM6115
equivalent was `Cc: stable`.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: Table `qcom_smmu_client_of_match[]` only. Consumer:
`qcom_smmu_def_domain_type()`.

**Step 5.2: Callers**
Record: `qcom_smmu_def_domain_type` is `.def_domain_type` on the
Qualcomm SMMU impls. `arm_smmu_def_domain_type()` in `arm-smmu.c` calls
it; IOMMU core `iommu_get_def_domain_type()` uses that at device attach.
Probe-time, not IRQ/hot path.

**Step 5.3: Callees**
Record: `of_match_device()` only.

**Step 5.4: Reachability**
Record: Yes, on Qualcomm SM8450 with MDSS enabled (`iommus` in
`sm8450.dtsi`; `&mdss { status = "okay"; }` in `sm8450-hdk.dts`).
Userspace does not need to do anything; boot + display probe is enough.

**Step 5.5: Similar patterns**
Record: Same omission pattern for many MDSS SoCs; several already
patched. SM8450 was the gap between sm8250 and x1e80100.

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the buggy code exist here?**
Record:
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion`: `7.3.0-rc4`
- This is the 7.3-rc4 mainline checkout, not an older LTS branch.
- Match table, `qcom_smmu_def_domain_type()`, DRM `qcom,sm8450-mdss`,
  and DT node all exist.
- `git merge-base --is-ancestor d149c8b2c0146 HEAD` succeeded (commit is
  already in HEAD). That is ignored as “already selected”; it does not
  change technical merit.
- Without this line, SM8450 MDSS would still take a translated domain on
  this tree’s code.

**Step 6.2: Backport difficulty**
Record: Clean one-line apply against this file. Context around
`sm8250-mdss` / `x1e80100-mdss` is stable.

**Step 6.3: Related fixes already here?**
Record: ACTLR prefetch entry for `qcom,sm8450-mdss` is already present
(`f91879fdf70bd`). That does not set identity domain. No other fix
covers this bug.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/iommu/arm/arm-smmu/` Qualcomm implementation. IMPORTANT
for ARM64 Qualcomm devices; not core mm/VFS, but IOMMU misconfig breaks
display on those boards.

**Step 7.2**
Record: Actively maintained (recent Glymur, ACTLR, fastrpc fixes). The
match-table mechanism itself dates to 2020 and is mature.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: SM8450 (Snapdragon 8 Gen 1) boards with MDSS, e.g.
`sm8450-hdk.dts` (`status = "okay"`). Config: `CONFIG_ARM_SMMU` +
`CONFIG_ARM_SMMU_QCOM` (default y on `ARCH_QCOM`).

**Step 8.2: Trigger**
Record: Boot when UEFI left the framebuffer mapped and MDSS probes.
Common on these phones/HDKs, not a rare race. Unprivileged userspace is
not required.

**Step 8.3: Failure mode**
Record: Unhandled SMMU context faults; display init can fail (same class
as SM6115: DPU/GPU bind errors). Severity: HIGH for those devices
(broken display, fault spam). Not a universal panic.

**Step 8.4: Risk–benefit**
Record: Benefit high for SM8450 display. Risk very low (one compatible,
existing quirk table). Ratio strongly favors backport.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real bug: missing identity-domain quirk → SMMU context faults / non-
  working MDSS
- Hardware quirk / compatible addition (stable exception)
- 1 line, obviously correct
- Reviewed by Konrad Dybcio, applied by Will Deacon
- Same class as SM6115, which was `Cc: stable`
- SM8450 MDSS has been in this lineage since v6.3
- No new API, no refactor, no extra dependencies

Against:
- No `Fixes:` / `Cc: stable` (expected here, not a negative)
- Affects one SoC family, not all machines
- Originally in a “QoL” series (v2 is a standalone bugfix)

Unresolved: lore.kernel.org 403 prevented reading every v1 reply; v2
application and Konrad’s Reviewed-by are verified via patchew/LKML/`b4
dig`.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — one-line OF match;
   maintainer review/apply
2. Real user bug? **PASS** — context faults / MDSS broken on SM8450 with
   UEFI FB
3. Important (crash/security/corruption/deadlock)? **PASS** — unhandled
   SMMU faults and failed display; HIGH for that hardware
4. Small and contained? **PASS** — +1 line, one file
5. No new features/APIs? **PASS** — existing quirk table only
6. Can apply to this tree? **PASS** — table, MDSS driver, and DT are
   here

**Step 9.3: Exception**
Record: Device ID / hardware quirk on an existing driver. Automatic YES
class.

**Step 9.4: Decision**
This tree (`v7.3-rc4`) has SM8450 MDSS and the Qualcomm SMMU client
table. The patch is the standard identity-domain compatible for a
bootloader-configured display. It should be treated as stable material.

Explanation: Without `qcom,sm8450-mdss` in `qcom_smmu_client_of_match`,
MDSS is attached to a translated IOMMU domain while UEFI still owns a
physically addressed framebuffer, which produces unhandled context
faults and can prevent the display stack from coming up. Adding the
compatible selects `IOMMU_DOMAIN_IDENTITY`, matching every other
Qualcomm MDSS entry in that table. Benefit is working display on SM8450;
risk is a single OF match that cannot affect other hardware.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Konrad Dybcio; SOB Esteban Urrutia,
  Will Deacon; no Fixes/Cc stable
- [Phase 2] Diff: +1 line in `qcom_smmu_client_of_match[]`;
  `qcom_smmu_def_domain_type()` returns `IOMMU_DOMAIN_IDENTITY` on match
- [Phase 3] `git log`/`git blame`: table from `0e764a01015df` (2020);
  SM8450 DRM `80056d9ac47ab` (v6.3-rc1); this commit `d149c8b2c0146`
- [Phase 3] Sibling SM6115 commit `f7fa8520f3037` had `Cc: stable` and
  context-fault logs
- [Phase 3] `git merge-base --is-ancestor d149c8b2c0146 HEAD` → yes
  (already in this checkout)
- [Phase 4] `b4 dig -c d149c8b2c0146`: v2 at
  patch.msgid.link/20260711-sm8450-qol-smmu-v2-1-41a6fba41c3e@proton.me
- [Phase 4] `b4 dig -a`: v1 8-patch QoL series → v2 standalone SMMU
  patch
- [Phase 4] `b4 dig -w`: Will Deacon, Robin Murphy, Rob Clark, Konrad
  Dybcio, iommu@ and linux-arm-msm@
- [Phase 4] patchew: Will Deacon applied; no NAK
- [Phase 4] lore.kernel.org WebFetch: 403 — UNVERIFIED full v1 reply
  text; v2 content verified via patchew/LKML
- [Phase 5] Callers: `arm_smmu_def_domain_type` → IOMMU default domain
  at probe
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Confirmed `qcom,sm8450-mdss` in `msm_mdss.c`, `sm8450.dtsi`,
  HDK `&mdss { status = "okay"; }`
- [Phase 6] Pre-commit file still had ACTLR `sm8450-mdss` only; client
  table lacked it
- [Phase 7] `CONFIG_ARM_SMMU_QCOM` default y on `ARCH_QCOM`
- [Phase 8] Failure mode: unhandled SMMU context fault / broken MDSS on
  SM8450, severity HIGH for that platform
- [Phase 4.5] No stable-list discussion found for this specific commit

**YES**

 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index f7cb7de80cfb9..b6493e92343be 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -394,6 +394,7 @@ static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,sm6375-mdss" },
 	{ .compatible = "qcom,sm8150-mdss" },
 	{ .compatible = "qcom,sm8250-mdss" },
+	{ .compatible = "qcom,sm8450-mdss" },
 	{ .compatible = "qcom,x1e80100-mdss" },
 	{ }
 };
-- 
2.53.0

