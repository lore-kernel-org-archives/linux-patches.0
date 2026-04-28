Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378813FBED4;
	Tue, 28 Apr 2026 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372928; cv=none; b=RBVWrUhppIm7TaLJjS0B+Avgn4GExJLzibLHvXsSzo+V+JzjSKRax/JyMNbB9hcmVuHEw3PuQFsOR39yknSpBg3QOqfHajldNrmVCvFzS9aOBgw/Vw1gnus0XYdjUj418ThEm8xcKssBj0pKDPhLu39WTdfUJ/HCxIjoWWDVUZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372928; c=relaxed/simple;
	bh=32abhNWO89cs2JwkXa0XH5ZqG1v/L7wT581ifHEbNSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjrsCNBHqsLvd8HSbjng4/z6JSnBRbdI/EBEZhfK7bWSbJsHAty47obEPLiV0rtNBliSlCK1OreoA2D1zQgKphbjBeDFbbWAThcdEAypUp8KTPWMM3Z2+H/2KlW50A40taM1TDtplJSSVqHEeitbxJKGwDuAm9UCK0hJWcR0ahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNEOdlEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNEOdlEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E26C2BCB5;
	Tue, 28 Apr 2026 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372928;
	bh=32abhNWO89cs2JwkXa0XH5ZqG1v/L7wT581ifHEbNSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNEOdlEVV/wPN8bR5EDj70Aue0OASPmqHvdUgczIC5vNRxxkLsoMwatdqGnVni72S
	 BMps/zP9GzQMd2Ux57sTlW7hsuvJ1Huw+vhutOwvz4iK7rmGmwII68WUjipr0Tk5Ke
	 uXuVgkeQ9eztfK2c5nCMB+oHh7wvnAg31YaPa2Ckqej/o93PBWRAfpC9THUbv00+Z4
	 Hr7u3u0sogQflfmDd9hgfyGrKO1225cE9Fd42H2L84pHZM/uLrrtLZsCEVQ8xfCPaD
	 yw96a5xdd54Jiscghmdg6jfCbWW/H2uOORqmdddokXi2TK9G1Dun7jHDFsTzeSigF8
	 FHbql6Q6j2l8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Elad Nachman <enachman@marvell.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	sebastian.hesselbarth@gmail.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] dt-bindings: arm64: add Marvell 7k COMe boards
Date: Tue, 28 Apr 2026 06:40:35 -0400
Message-ID: <20260428104133.2858589-24-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elad Nachman <enachman@marvell.com>

[ Upstream commit 283822a64d6bd9aca55b5e2718bc63e9815b443d ]

Add dt bindings for:
Armada 7020 COM Express CPU module
Falcon DB-98CX85x0 COM Express type 7 Carrier board
Falcon DB-98CX85x0 COM Express type 7 Carrier board
with an Armada 7020 COM Express CPU module

Signed-off-by: Elad Nachman <enachman@marvell.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I have enough information to complete the
analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: Subsystem `dt-bindings: arm64`, action verb `add`, summary: "Add
DT binding descriptions for the Marvell Falcon DB-98CX85x0 COM Express
carrier board and Armada 7020 CPU module."

**Step 1.2: Tags**
Record: `Signed-off-by: Elad Nachman` (author), `Acked-by: Rob Herring
(Arm) <robh@kernel.org>` (DT maintainer), `Signed-off-by: Gregory
CLEMENT <gregory.clement@bootlin.com>` (mvebu maintainer). No `Fixes:`,
no `Cc: stable`, no `Reported-by:`, no `Link:`.

**Step 1.3: Commit Body**
Record: The commit body lists the three binding descriptions added but
provides no bug description or symptom. However, the subject does not
use "fix" and reads as a feature addition. Body does not discuss impact.

**Step 1.4: Hidden Bug Fix Detection**
Record: Based on subject alone, looks like pure feature addition.
However, based on mailing list discussion (see Phase 4), this is a fix
for a binding/DTS mismatch where the DTS files reference compatibles not
documented in the bindings.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file changed
(`Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml`), +11
lines, -0 lines. Single surgical YAML addition.

**Step 2.2: Code Flow**
Record: Before: Binding file did not describe the
`marvell,armada7020-cpu-module`, `marvell,db-falcon-carrier`, or
`marvell,armada7020-falcon-carrier` compatibles. After: New `oneOf`
entry documents this 6-level compatible stack. No runtime code affected.

**Step 2.3: Bug Mechanism**
Record: This falls in category (h) Hardware workarounds/documentation
additions - DT binding additions for board compatibles. The "bug" is
that the DTS files already in the tree (b3370479a5f7e) reference
compatibles that are undocumented, causing `make CHECK_DTBS=y` to
produce schema validation warnings.

**Step 2.4: Fix Quality**
Record: Obviously correct - YAML schema change only. Zero runtime risk.
Minimal and surgical. Cannot introduce regression as DT schema is not
used at runtime.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: The existing "Armada 7020 SoC" entry that precedes the added
block was present from file creation. New entry inserted after it.

**Step 3.2: Fixes Tag**
Record: No `Fixes:` tag. However, the related DTS commit `b3370479a5f7e`
("arm64: dts: a7k: add COM Express boards", Jan 22 2026) is the commit
that introduced the DTS files referencing the new compatibles, and is
already present in HEAD.

**Step 3.3: File History**
Record: Recent related file history: `4c9bc78fa22d6` (missing 7040/8040
compatibles), `242aa69df6ed8` (8KPlus schema move), `099e1d034f009`
(solidrun cn9132), `5f5eb24090bec` (solidrun cn9130), `c604a4d1833c1`
(earlier Marvell COM Express boards). Part of a typical incremental
binding maintenance flow.

**Step 3.4: Author**
Record: Author Elad Nachman from Marvell has been contributing
Armada/CN913x and ac5 patches. Gregory Clement (mvebu subsystem
maintainer) handled the commit. Rob Herring (top-level DT maintainer)
Acked it.

**Step 3.5: Dependencies**
Record: Standalone binding addition, no code dependencies. However,
contextually linked to DTS commit `b3370479a5f7e` (already in
HEAD/v7.0).

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Lore Discussion**
Record: Found via `b4 dig`: https://lore.kernel.org/all/20260122165923.2
316510-2-enachman@marvell.com/ — Patch 1/3 of series "arm64: dts: a7k:
add COM Express boards". Crucial reviewer feedback found:

- Rob Herring (Mar 6, 2026): *"It seems the .dts files are in 7.0 and
  the binding is only in next. The binding needs to go into 7.0 too.
  Please pay attention to the warnings."*
- Gregory Clement (Mar 13, 2026): *"Sorry for this. I have now applied
  the binding, and it will be included in my next fixes PR."*

This is an **explicit stable nomination from the DT maintainer** for
7.0.y.

**Step 4.2: Reviewers**
Record: Rob Herring (DT maintainer) Acked it, Gregory Clement (mvebu
maintainer) applied and explicitly targeted 7.0 fixes. Proper subsystem
review occurred.

**Step 4.3: Bug Report**
Record: Rob's dt-schema bot flagged "new warnings" on the series.
Warnings are DT validation errors produced by the DTS files without
matching bindings.

**Step 4.4: Series**
Record: Part of a 3-patch series. Patch 2 (DTS) already merged to 7.0.
Patch 3 (MAINTAINERS) has its own destiny. This patch 1 (bindings) is
the reviewer-requested sync.

**Step 4.5: Stable Mailing List**
Record: Not discussed on stable list; this is being handled as a 7.0
fixes path.

## PHASE 5: CODE SEMANTIC ANALYSIS

Not applicable — no code functions involved, only DT YAML schema. DT
binding files have no runtime callers; they are consumed only by `dt-
schema` validation tools (`make dt_binding_check`, `make CHECK_DTBS=y`).

Record: Zero runtime call paths, zero runtime consumers. Binding file
affects only build-time validation.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
Record: Verified with `git merge-base --is-ancestor b3370479a5f7e HEAD`
-> IN HEAD. The DTS files (`db-falcon-carrier-a7k.dts`, `db-falcon-
carrier.dtsi`, `armada-7020-comexpress.dtsi`) are present in
stable/linux-7.0.y via mvebu-dt64-6.20-1 merge. The mismatched bindings
cause the validation gap in 7.0.y. Not in older stable trees (6.6.y,
6.1.y etc.), so they aren't affected.

**Step 6.2: Backport Complications**
Record: Binding file in HEAD matches the pre-patch state from mainline.
Patch should apply cleanly to 7.0.y. Verified file context still has the
"Armada 7040 SoC" entry right after the "Armada 7020 SoC" entry -
insertion point unchanged.

**Step 6.3: Related Fixes in Stable**
Record: No related binding fixes already in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
Record: Subsystem = `Documentation/devicetree/bindings/arm/marvell/`, DT
binding documentation. Criticality: PERIPHERAL (affects only DT schema
validators, not any runtime path).

**Step 7.2: Activity Level**
Record: Moderately active file, typical maintenance pace.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
Record: Developers/testers running `make dt_binding_check` or `make
CHECK_DTBS=y` on the arm64 marvell DTS tree. No end users affected (DT
schema files are not compiled into the kernel or used at runtime).

**Step 8.2: Trigger Conditions**
Record: The "bug" (validation warning) triggers only when someone runs
DT schema validation against the shipped DTS files. Not runtime
reachable.

**Step 8.3: Failure Mode Severity**
Record: LOW - generates `CHECK_DTBS` warnings/failures for validator
users; no crashes, no data corruption, no security impact, no runtime
behavior change.

**Step 8.4: Risk vs Benefit**
Record:
- Benefit: LOW severity, fixes validation inconsistency explicitly
  requested by the DT maintainer; keeps 7.0.y internally consistent.
- Risk: Near-zero. 11-line YAML file touching schema metadata only;
  cannot affect compile or runtime.
- Ratio: LOW/near-zero = favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backport:
- DT maintainer (Rob Herring) explicitly stated: "The binding needs to
  go into 7.0 too."
- Companion DTS commit `b3370479a5f7e` is already in stable/linux-7.0.y
  (verified)
- Fixes DT schema validation warnings against the already-shipped DTS
- Zero runtime risk (YAML metadata only)
- Acked-by DT maintainer, applied to mvebu/fixes (7.0 fixes) by mvebu
  maintainer
- Small (11 lines), contained, obviously correct
- Falls under the "Documentation" and "DT updates for existing hardware
  (in tree)" exception categories

AGAINST backport:
- Subject reads as feature addition ("add Marvell 7k COMe boards")
- No `Fixes:` tag, no `Cc: stable` tag
- Technically describes new boards not previously documented
- Doesn't fix any runtime behavior

Unresolved: None — the mailing list discussion resolves the intent.

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES (YAML schema addition, acked by DT
   maintainer)
2. Fixes a real bug affecting users? BORDERLINE - fixes validator bug
   for shipped DTS
3. Important issue? LOW severity (validation warnings, not runtime)
4. Small and contained? YES (11 lines, one file)
5. No new features? YES (no runtime features, binding matches DTS
   already in tree)
6. Can apply to stable? YES (applies cleanly to 7.0.y)

**Step 9.3: Exception Categories**
Applicable exceptions:
- "DEVICE TREE (DT) UPDATES: DT binding additions for existing hardware,
  DT fixes for incorrect hardware descriptions, enabling already-
  supported hardware on new boards - Usually safe because they only
  affect specific ARM/embedded platforms."
- "DOCUMENTATION and COMMENT FIXES: Fixing incorrect documentation,
  updating obsolete comments - Zero risk of runtime regression"

The DTS files for this hardware are already present in 7.0; adding the
matching bindings is a documentation sync.

**Step 9.4: Decision**
For 7.0.y specifically, the DTS files exist in the tree, the DT
maintainer explicitly asked for this to land in 7.0, and the risk is
zero. This matches the exception for DT updates / documentation fixes.

## Verification

- [Phase 1] Parsed tags: `Acked-by: Rob Herring`, `Signed-off-by:
  Gregory CLEMENT`, no `Fixes:`/`Cc: stable`.
- [Phase 2] Diff analysis: +11 lines of YAML added to
  `armada-7k-8k.yaml`, single file, new `oneOf` entry for the Falcon
  carrier + Armada 7020 CPU module compatible stack.
- [Phase 3] `git log --oneline -- <file>`: file churn is typical
  incremental binding maintenance.
- [Phase 3] `git log -1 --format="%H %ci %s" edb7efa767da8` -> March 13,
  2026; `b3370479a5f7e` -> January 23, 2026 (DTS, earlier).
- [Phase 3] `git merge-base --is-ancestor b3370479a5f7e HEAD` -> **IN
  HEAD** (DTS already in 7.0.y).
- [Phase 3] `git merge-base --is-ancestor edb7efa767da8 HEAD` -> **NOT
  IN HEAD** (binding not yet in 7.0.y).
- [Phase 3] `git tag --contains b3370479a5f7e` -> `v7.0` confirms DTS is
  in the 7.0 release.
- [Phase 4] `b4 dig -c edb7efa767da8` -> found thread at
  lore.kernel.org/all/20260122165923.2316510-2-enachman@marvell.com/.
- [Phase 4] `b4 dig -c edb7efa767da8 -w` -> recipients include robh+dt,
  krzysztof.kozlowski+dt, conor+dt, andrew@lunn.ch,
  gregory.clement@bootlin.com (all relevant DT/maintainer parties).
- [Phase 4] `b4 dig -c edb7efa767da8 -m /tmp/thread.mbox` -> saved full
  thread; confirmed Rob Herring's explicit "The binding needs to go into
  7.0 too" and Gregory Clement's response "I have now applied the
  binding, and it will be included in my next fixes PR."
- [Phase 4] Rob's dt-bot reported DTB warnings on the series
  (`arch/arm64/boot/dts/marvell/db-falcon-carrier-a7k.dtb: ...phy-
  mode:0: '10gbase-kr' is not one of [...]`), a separate phy-mode issue,
  but confirms validation is run.
- [Phase 5] Not applicable (YAML schema file has no runtime callers).
- [Phase 6] Verified DTS files (`db-falcon-carrier-a7k.dts`, `db-falcon-
  carrier.dtsi`, `armada-7020-comexpress.dtsi`) exist in HEAD via `git
  show b3370479a5f7e:...` - confirmed they use the compatibles added in
  this binding commit.
- [Phase 7] File path: `Documentation/devicetree/bindings/arm/marvell/`
  - DT binding docs for Marvell Armada platforms.
- [Phase 8] Severity determined by examining what consumes DT binding
  YAMLs (dt-schema validators only); verified no runtime code path uses
  these YAML files.

The mailing list evidence is unambiguous: the DT maintainer explicitly
flagged that the DTS files landed in v7.0 but the matching bindings did
not, and requested they go into 7.0 to fix the CHECK_DTBS validation
warnings. The mvebu maintainer applied it to the fixes branch
accordingly. The change is 11 lines of YAML with zero runtime risk,
acked by the DT maintainer, matching already-shipped DTS files in the
7.0 tree.

**YES**

 .../devicetree/bindings/arm/marvell/armada-7k-8k.yaml | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml b/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
index 4bc7454a5d3ac..7e77310da626f 100644
--- a/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
+++ b/Documentation/devicetree/bindings/arm/marvell/armada-7k-8k.yaml
@@ -21,6 +21,17 @@ properties:
           - const: marvell,armada-ap806-dual
           - const: marvell,armada-ap806
 
+      - description:
+          Falcon (DB-98CX85x0) Development board COM Express Carrier plus
+          Armada 7020 SoC COM Express CPU module
+        items:
+          - const: marvell,armada7020-falcon-carrier
+          - const: marvell,db-falcon-carrier
+          - const: marvell,armada7020-cpu-module
+          - const: marvell,armada7020
+          - const: marvell,armada-ap806-dual
+          - const: marvell,armada-ap806
+
       - description: Armada 7040 SoC
         items:
           - enum:
-- 
2.53.0

