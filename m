Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF203F54DA
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 11:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374795; cv=none; b=G9UZigsZVtmNwkbhCiDGyCDDcJtmXR5Apv9+JVF6qZp7v7RU2XiZMs8QHldzFGaey8RmTvdzHUoXoAiKcYTkeMgTC/F21rJ3FSfXK7CyyBqIUXy3aUp4iOJ7VXeEz/G16o34VUXxv7qK34U/39/xxq9anSk6zjl/FYPfogdW1Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374795; c=relaxed/simple;
	bh=FwiH5tzvF8NzDoJNvr5Mzsx8cztE+hBcfG5i1dKKGC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBnR/EsgXW9uqQK4U3cg4gBLX/2y7tL1VrkJ8hJdr2L+Jqfbtjym1zYlCZoD0WkKDtzDyzgWExCRUfwl/xCtUu0AgkOZEMZ1gmPtLA51jBXc+rcayLxR0xC9NZ2CKJRr4afrqzq2LxvlTatrHiyCP4ycPjUZ3KEAu/74NeHIi2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sKIDkj0s; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sKIDkj0s"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECF1316A3;
	Tue, 28 Apr 2026 04:13:06 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 038163F62B;
	Tue, 28 Apr 2026 04:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777374792; bh=FwiH5tzvF8NzDoJNvr5Mzsx8cztE+hBcfG5i1dKKGC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sKIDkj0sB+afNrT+hkOCgYZ5gA10yI7C5kAggd3Y+qzE9IDKPtWSADfOwk+wogyo0
	 McexlYCqnIML3KvAYMAkvxHqdWPU7JQtJXGJI4Jeg/zGd4fwUXtE9miPRWzMDGYdRd
	 CW4G7OhRnpt4FzeFy1nps3a+YQwip8dkWu0KMw6c=
Date: Tue, 28 Apr 2026 12:13:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0-5.10] arm64: cputype: Add C1-Pro definitions
Message-ID: <afCWPTqKxIqGPe1r@J2N7QTR9R3>
References: <20260428104133.2858589-1-sashal@kernel.org>
 <20260428104133.2858589-51-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260428104133.2858589-51-sashal@kernel.org>

On Tue, Apr 28, 2026 at 06:41:02AM -0400, Sasha Levin wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> [ Upstream commit 2c99561016c591f4c3d5ad7d22a61b8726e79735 ]
> 
> Add cputype definitions for C1-Pro. These will be used for errata
> detection in subsequent patches.

This definition is only needed for a workaround which is only applicable
to v6.18+ (and the downstream android16-6.12 tree).

We needn't backport this patch to v5.1.0.y unless there's something that
depends upon it.

Mark.

> These values can be found in "Table A-303: MIDR_EL1 bit descriptions" in
> issue 07 of the C1-Pro TRM:
> 
>   https://documentation-service.arm.com/static/6930126730f8f55a656570af
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Reviewed-by: Will Deacon <will@kernel.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have a complete picture. Let me write up the analysis.
> 
> ## Analysis
> 
> ### PHASE 1: COMMIT MESSAGE FORENSICS
> 
> **Step 1.1: Subject Line Parsing**
> - Subsystem prefix: `arm64: cputype:`
> - Action verb: "Add"
> - Record: `[arm64/cputype] [Add] [CPU part/MIDR definitions for ARM
>   C1-Pro CPU]`
> 
> **Step 1.2: Tag Analysis**
> - `Acked-by: Mark Rutland <mark.rutland@arm.com>` — ARM kernel engineer
>   reviewer
> - `Reviewed-by: Will Deacon <will@kernel.org>` — arm64 co-maintainer
>   review
> - `Cc: Will Deacon`, `Cc: James Morse` — arm64 maintainers
> - `Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>` — arm64
>   maintainer (author and committer)
> - No `Fixes:` tag (expected for autoselect candidates)
> - No `Cc: stable@vger.kernel.org` (expected for autoselect candidates)
> - Record: Top-tier maintainer/reviewer approval chain; no bug-report
>   tags.
> 
> **Step 1.3: Commit Body Analysis**
> - States purpose: "These will be used for errata detection in subsequent
>   patches."
> - Cites ARM C1-Pro TRM (Table A-303) as the authoritative source.
> - Does NOT describe a bug, crash, or symptom.
> - Does NOT list kernel versions affected (no code actually uses these
>   values in this commit).
> - Record: Explicitly a preparatory commit adding constants; no bug
>   mechanism described in the message itself.
> 
> **Step 1.4: Hidden Bug Fix Detection**
> - The wording "will be used for errata detection in subsequent patches"
>   indicates this is preparation for a workaround series.
> - The series in question is `arm64: Work around C1-Pro erratum 4193714
>   (CVE-2026-0995)` (verified via `b4 am`).
> - Record: Not a hidden fix — genuinely a prerequisite commit.
> 
> ### PHASE 2: DIFF ANALYSIS
> 
> **Step 2.1: Inventory**
> - Files changed: `arch/arm64/include/asm/cputype.h` (+2 lines, no
>   removals)
> - Scope: single-file, header-only, pure macro additions.
> - Record: 2 lines added, 0 removed, 0 functions modified.
> 
> **Step 2.2: Code Flow Change**
> - Hunk 1: adds `#define ARM_CPU_PART_C1_PRO 0xD8B` among other ARM part
>   IDs.
> - Hunk 2: adds `#define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM,
>   ARM_CPU_PART_C1_PRO)` among other MIDR entries.
> - Before: no symbol existed; after: symbols exist but have zero callers
>   in this commit.
> - Record: Pure identifier addition; no runtime behavior change.
> 
> **Step 2.3: Bug Mechanism**
> - Category (h): Hardware workaround — device-ID-like additions. Here the
>   "device IDs" are CPU part identifiers, analogous to PCI IDs for
>   drivers.
> - Record: Preparation for a hardware quirk/workaround; no bug fixed in
>   isolation.
> 
> **Step 2.4: Fix Quality**
> - Obviously correct: yes — values taken from the authoritative ARM TRM
>   and are namespaced constants.
> - Surgical: yes — 2 lines, no unrelated changes.
> - Regression risk: essentially zero — adding unused `#define`s cannot
>   break anything.
> - Record: Trivially correct, zero regression risk.
> 
> ### PHASE 3: GIT HISTORY INVESTIGATION
> 
> **Step 3.1: Blame**
> - The `cputype.h` file has a long history with many similar `MIDR_*`
>   additions.
> - Each hunk is touched adjacent to existing definitions (last additions:
>   `ARM_CPU_PART_NEOVERSE_N3`, `MIDR_NEOVERSE_N3`).
> - Record: Following an established pattern of additions to this header.
> 
> **Step 3.2: Fixes Tag**
> - No `Fixes:` tag. Not applicable.
> 
> **Step 3.3: File History**
> - `git log -- arch/arm64/include/asm/cputype.h` recent entries include:
>   - `3bbf004c4808e arm64: cputype: Add Neoverse-V3AE definitions`
>   - `e185c8a0d8423 arm64: cputype: Add NVIDIA Olympus definitions`
>   - `f38c2c3e572ce arm64: cputype: Add Cortex-A720AE definitions`
> - Record: Same pattern repeated multiple times in recent history.
> 
> **Step 3.4: Author Context**
> - Author Catalin Marinas = arm64 maintainer.
> - Reviewer Will Deacon = arm64 co-maintainer.
> - Record: Top subsystem authority authored and reviewed this.
> 
> **Step 3.5: Dependencies**
> - Standalone compile-wise (adding `#define`s has no dependency).
> - Semantically, these symbols are consumed by the follow-up "arm64:
>   errata: Work around early CME DVMSync acknowledgement" patch (PATCH v5
>   4/4 of the same series).
> - Record: Part of a 4-patch series; compiles independently but
>   semantically part of series.
> 
> ### PHASE 4: MAILING LIST RESEARCH
> 
> **Step 4.1: Original Submission**
> - Cover letter thread found: `https://lore.kernel.org/all/20260302165801
>   .3014607-1-catalin.marinas@arm.com/` (v1, 4 patches). In v1, the
>   cputype additions were embedded inside patch 3/4 (the errata
>   workaround), not split out.
> - Latest revision identified via web search: v5 —
>   `https://yhbt.net/lore/linux-arm-kernel/adjo1Kuwu7v5dhqB@willie-the-
>   truck/T/`
> - In v5, the cputype additions were split into their own patch: "[PATCH
>   v5 3/4] arm64: cputype: Add C1-Pro definitions" — matching exactly the
>   commit under review (same tags, same two-line diff).
> - Cover letter of the series ("arm64: Work around C1-Pro erratum 4193714
>   (CVE-2026-0995)") states:
> 
> > Backports available here (no stable-6.12.y since SME is not
> supported):
> > `errata/c1-pro-erratum-4193714-stable-6.19.y`
> > `errata/c1-pro-erratum-4193714-stable-6.18.y`
> > `errata/c1-pro-erratum-4193714-android16-6.12-lts`
> 
> - Record: Stable backport branches explicitly prepared by the arm64
>   maintainer; patch v5 evolved from v1 after review.
> 
> **Step 4.2: Reviewers**
> - `b4 am` output shows Acked-by: Mark Rutland confirmed via DKIM;
>   Reviewed-by: Will Deacon (arm64 co-maintainer).
> - Record: Both arm64 maintainers plus a senior ARM engineer
>   acked/reviewed.
> 
> **Step 4.3: Bug Report**
> - CVE-2026-0995 assigned:
>   https://developer.arm.com/documentation/111823/latest/
> - Phoronix article confirms: "Linux 7.1 Lands Workaround For Arm C1-Pro
>   Erratum" (CVE-2026-0995).
> - Record: Public CVE with documented memory-corruption-class consequence
>   (pages reused while SME accesses are in-flight).
> 
> **Step 4.4: Related Patches**
> - 4-patch series; this is patch 3/4.
> - Patches 1/4 and 2/4: TLB infrastructure refactoring (prerequisites).
> - Patch 4/4: actual errata workaround that consumes `MIDR_C1_PRO`.
> - Record: Part of a 4-patch series for CVE-2026-0995; all 4 needed
>   together in stable.
> 
> **Step 4.5: Stable Discussion**
> - Stable backport branches announced in cover letter for 6.18.y and
>   6.19.y.
> - Record: Maintainer has already prepared stable backports.
> 
> ### PHASE 5: CODE SEMANTIC ANALYSIS
> 
> **Step 5.1: Key Functions**
> - No functions — only macro additions.
> - Record: Pure preprocessor additions.
> 
> **Step 5.2/5.3/5.4: Callers/Callees/Callchain**
> - No callers in the committed tree yet (`MIDR_C1_PRO` is not referenced
>   in the current repo state).
> - Intended consumer per the series: `arch/arm64/kernel/cpu_errata.c` —
>   `ERRATA_MIDR_RANGE(MIDR_C1_PRO, 0, 0, 1, 2)` in the errata entry for
>   `ARM64_WORKAROUND_4193714`.
> - Record: No existing callers; future errata table entry is the only
>   consumer.
> 
> **Step 5.5: Similar Patterns**
> - Several recent analogous commits exist:
>   - `3bbf004c4808e arm64: cputype: Add Neoverse-V3AE definitions`
>   - `e185c8a0d8423 arm64: cputype: Add NVIDIA Olympus definitions`
>   - `f38c2c3e572ce arm64: cputype: Add Cortex-A720AE definitions`
> - Record: Well-established pattern.
> 
> ### PHASE 6: CROSS-REFERENCING AND STABLE TREES
> 
> **Step 6.1: Code in Stable Trees?**
> - The `cputype.h` header exists in all active stable trees (6.1.y,
>   6.6.y, 6.12.y, 6.17.y, 6.18.y, 6.19.y).
> - C1-Pro definitions themselves don't exist in any stable tree yet.
> - Record: File exists everywhere; definitions need adding where
>   SME/errata fix is applied.
> 
> **Step 6.2: Backport Complications**
> - Pure additions; clean apply essentially everywhere (context lines
>   `ARM_CPU_PART_NEOVERSE_N3` and `MIDR_NEOVERSE_N3` are present in 6.6.y
>   onward after backports, but position may shift — trivial resolution).
> - Record: Clean/trivial apply expected.
> 
> **Step 6.3: Related Stable Fixes Already Present?**
> - No — no C1-Pro errata workaround exists in stable yet.
> - Verified precedent of same pattern being backported:
>   - `f139af04f60d5 arm64: cputype: Add Neoverse-V3AE definitions` in
>     6.17.y
>   - `6de6d315f34c5 arm64: cputype: Add Neoverse-V3AE definitions` in
>     6.12.y
>   - `d9d3e9ff1e2a5 arm64: cputype: Add Neoverse-V3AE definitions` in
>     6.6.y
> - Each backport paired with its errata workaround.
> - Record: Strong precedent — cputype definition commits are routinely
>   backported alongside their errata fixes.
> 
> ### PHASE 7: SUBSYSTEM CONTEXT
> 
> **Step 7.1: Subsystem Criticality**
> - `arch/arm64/` core CPU identification — CORE.
> - Record: Core arm64 infrastructure, but this specific header only holds
>   constants.
> 
> **Step 7.2: Subsystem Activity**
> - Highly active (many recent commits touching `cputype.h`).
> - Record: Active subsystem.
> 
> ### PHASE 8: IMPACT AND RISK ASSESSMENT
> 
> **Step 8.1: Who Is Affected**
> - In isolation: nobody — the constants are unused.
> - As part of the CVE-2026-0995 fix series: owners of ARM C1-Pro
>   (r0p0-r1p2) CPUs running SME workloads.
> - Record: Zero direct impact; indirect enabler for CVE fix on C1-Pro
>   hardware.
> 
> **Step 8.2: Trigger Conditions**
> - This commit triggers nothing by itself.
> - The erratum it prepares for: pages may be reused while SME accesses
>   are in flight → memory corruption class, unprivileged-user-triggerable
>   on affected silicon running SME apps.
> - Record: No direct trigger; CVE-class failure once the errata patch is
>   present.
> 
> **Step 8.3: Failure Mode**
> - This commit: none.
> - Series: memory corruption / UAF on page reuse → CRITICAL once the
>   series is enabled.
> - Record: Severity CRITICAL for the series; NONE for this isolated
>   patch.
> 
> **Step 8.4: Risk/Benefit**
> - Benefit: Enables CVE-2026-0995 backport (required header symbols).
>   Without it, the errata fix won't compile.
> - Risk: Extremely low — adds two unused `#define`s; cannot regress
>   anything.
> - Record: Essentially zero risk, high enabling benefit.
> 
> ### PHASE 9: FINAL SYNTHESIS
> 
> **Step 9.1: Evidence**
> - FOR: Zero regression risk; required by CVE-2026-0995 fix; maintainer
>   explicitly prepared 6.18.y/6.19.y backports; strong precedent
>   (Neoverse-V3AE, Cortex-A720AE, NVIDIA Olympus cputype commits all
>   backported to stable); reviewed by arm64 co-maintainer; acked by Mark
>   Rutland.
> - AGAINST: Does not fix a bug on its own; commit message literally says
>   "will be used for errata detection in subsequent patches" (pure prep).
> 
> **Step 9.2: Stable Rules Checklist**
> 1. Obviously correct and tested? YES (trivially — values from the ARM
>    TRM; reviewed by maintainers).
> 2. Fixes a real bug? Not standalone, but is a strict prerequisite for
>    the CVE-2026-0995 fix in the same series.
> 3. Important issue? Only as enabler; the enabled fix addresses CVE-class
>    memory corruption on C1-Pro.
> 4. Small and contained? YES (2 lines).
> 5. No new features/APIs? Adds identifier macros (no API, no user-visible
>    behavior — matches the accepted "new device ID" exception style).
> 6. Applies to stable? YES (clean apply; maintainer-prepared branches
>    exist).
> 
> **Step 9.3: Exception Category**
> - Closest analogue: "NEW DEVICE IDs" — adding PCI/USB/etc. IDs to
>   existing drivers. Here the analog is adding a CPU-part/MIDR identifier
>   so existing arm64 errata infrastructure can match the chip. The
>   precedent of backporting similar commits (Neoverse-V3AE,
>   Cortex-A720AE) confirms this treatment.
> 
> **Step 9.4: Decision**
> - The commit has zero risk, is the textbook prerequisite that
>   accompanies every errata-workaround backport in arm64, and is part of
>   a maintainer-announced stable backport for CVE-2026-0995.
> - Without it, a CVE fix cannot be backported (won't compile).
> - Strong, consistent precedent in stable for this exact pattern.
> 
> ## Verification
> - [Phase 1] Parsed tags: Acked-by Mark Rutland, Reviewed-by Will Deacon,
>   Cc Will Deacon/James Morse, Signed-off-by Catalin Marinas. No Fixes:,
>   no Cc: stable (expected).
> - [Phase 2] Diff analysis via provided diff: +2 lines, 0 removed, single
>   file `arch/arm64/include/asm/cputype.h`; confirmed by reading the file
>   header layout.
> - [Phase 3] `git log --oneline -- arch/arm64/include/asm/cputype.h`
>   showed the three sibling "Add X definitions" commits (`3bbf004c4808e`,
>   `e185c8a0d8423`, `f38c2c3e572ce`).
> - [Phase 3] `git show --stat` on each sibling confirmed the same +2-line
>   shape and same preparation-commit pattern.
> - [Phase 4] `b4 am` retrieved the v1 series cover at `lore.kernel.org/al
>   l/20260302165801.3014607-1-catalin.marinas@arm.com/` — confirmed
>   series subject "arm64: Work around C1-Pro erratum 4193714
>   (CVE-2026-0995)" and explicit stable backport branch announcements.
> - [Phase 4] WebSearch + Phoronix article corroborated CVE-2026-0995
>   assignment and that Linux 7.1 merged the workaround.
> - [Phase 4] Web-fetched v5 thread at
>   `yhbt.net/lore/.../adjo1Kuwu7v5dhqB@willie-the-truck/T/` showed the
>   exact split-out patch "[PATCH v5 3/4] arm64: cputype: Add C1-Pro
>   definitions" matching the diff and tags under review.
> - [Phase 5] `Grep` for `ARM_CPU_PART_C1_PRO`/`MIDR_C1_PRO` in the repo:
>   no existing consumers in current tree (zero callers; purely additive).
> - [Phase 6] `git log stable/linux-6.17.y --oneline --grep=Neoverse-V3AE`
>   -> `f139af04f60d5 arm64: cputype: Add Neoverse-V3AE definitions` and
>   `7ca3d45e36a74 arm64: errata: Apply workarounds for Neoverse-V3AE`
>   both present.
> - [Phase 6] `git log stable/linux-6.12.y` -> `8fdd0ad43977c` and
>   `d9d3e9ff1e2a5` (cputype + errata pair) confirming backport pattern.
> - [Phase 6] `git log stable/linux-6.6.y` -> `f3ccb49186541` and
>   `6de6d315f34c5` (cputype + errata pair).
> - [Phase 8] Cover letter text retrieved via `b4 am` states memory-reuse
>   consequence of erratum; CVE identifier confirms severity class.
> - UNVERIFIED: I could not programmatically reach lore.kernel.org
>   directly due to Anubis bot challenges; relied on `b4 am` (which
>   succeeded) plus a yhbt.net mirror for the v5 thread. This does not
>   affect the decision — the v5 thread content matches the commit under
>   review exactly.
> 
> Decision: The commit itself adds only two `#define`s, but it is a
> textbook-format prerequisite for a CVE-2026-0995 errata workaround
> series that the arm64 maintainer has explicitly prepared stable
> backports for. Identical sibling commits (Neoverse-V3AE, Cortex-A720AE)
> have been consistently backported to 6.6.y / 6.12.y / 6.17.y alongside
> their errata fixes. Risk is effectively zero, and the errata-fix
> backport cannot compile without it. This matches the stable "device-ID /
> hardware-quirk infrastructure" exception.
> 
> **YES**
> 
>  arch/arm64/include/asm/cputype.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 08860d482e600..7b518e81dd15b 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -98,6 +98,7 @@
>  #define ARM_CPU_PART_CORTEX_A725	0xD87
>  #define ARM_CPU_PART_CORTEX_A720AE	0xD89
>  #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
> +#define ARM_CPU_PART_C1_PRO		0xD8B
>  
>  #define APM_CPU_PART_XGENE		0x000
>  #define APM_CPU_VAR_POTENZA		0x00
> @@ -189,6 +190,7 @@
>  #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
>  #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
>  #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
> +#define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_PRO)
>  #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
>  #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
>  #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
> -- 
> 2.53.0
> 
