Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5873CF04C;
	Mon, 20 Apr 2026 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691757; cv=none; b=XUU53gNK7lClGDeOknjXIs6TyDQEjIh/R7rgVyY0+mUuZ7Sb/qdkV0DrZwwYt1HxoTiHPCuUFHhgubtoyKHwLEhnZTQflL44xqK4VebOmwjucWemSwViwlf+GAPegT3AqXSLOgeJ/UKksGd6+bWSdDGX0ZES2t3Z31ygaKBqTR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691757; c=relaxed/simple;
	bh=D18Cc9bFYdsUDjJ2iA1Kqm9LlIHVtcmPLlo+/TRBsTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sC+x+XoYZlruOAZdb0yYWYuNIejv+bfNiKE94H6Rc6S5czCzqjlFTKXlE8plMk3oCbPLIpBt+OyIUhlcuIGbky6OE33PVZo3D5ZPgvAhjMOh5N8v16aa7Qt0DQzFOW0ZxeWuPa+5QXtkNodC7kO1k/3ug5QwsYJOIxI/e8NUOiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DlbWDuZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlbWDuZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C68C2BCB7;
	Mon, 20 Apr 2026 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691756;
	bh=D18Cc9bFYdsUDjJ2iA1Kqm9LlIHVtcmPLlo+/TRBsTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlbWDuZkQNmZQ/sbeKedcbklpcDnSJG4y6V5wISVAMw5KU6Z6u9yVORJt9dgmu+hg
	 pVLVt757d0CdiETG1o1j7bgUr5HxoMExFGWZqersD5gk7O9exvFwWbMghiLq/L4M3v
	 wo8aDGhQc2vxrSq/y/4zvZBP2EDlv2j8a2g+i3Yg7kRf6oNxamN30LPs3RMF3r2E/+
	 Ab0RSpvkhdAkc7rzD8CUKUNwOer+0Shi293HMRSVnCT/Kb/EGHFVS5fSNCAC8eIoVw
	 +VoYqjicWVYTGwYAwSwmj367JJpbPxONFBbJpCt04oDgnOgSsZ+f3sk7roPMWle5ho
	 zC244Qvsdk7oQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL
Date: Mon, 20 Apr 2026 09:19:29 -0400
Message-ID: <20260420132314.1023554-175-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

[ Upstream commit 61135967fa76d37883d90ccccc5a1cb73e90b94d ]

pKVM guests practically rely on CONFIG_DMA_RESTRICTED_POOL=y in order
to establish shared memory regions with the host for virtio buffers.

Make CONFIG_ARM_PKVM_GUEST depend on CONFIG_DMA_RESTRICTED_POOL to avoid
the inevitable segmentation faults experience if you have the former but
not the latter.

Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://patch.msgid.link/20260330144841.26181-39-will@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, let me now write up the comprehensive assessment.

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject Parse:**
- Record: [drivers/virt: pkvm] [Add] Adds Kconfig dependency on
  DMA_RESTRICTED_POOL to prevent misconfiguration.

**Step 1.2 - Tags:**
- Record: `Reported-by: Marc Zyngier <maz@kernel.org>` (subsystem
  maintainer hit this); `Signed-off-by: Will Deacon`; `Link:` to lore;
  `Signed-off-by: Marc Zyngier` as maintainer. No Fixes: tag, no Cc:
  stable tag.

**Step 1.3 - Body:**
- Record: Bug description is that pKVM guests use
  `CONFIG_DMA_RESTRICTED_POOL=y` to establish shared memory regions with
  host for virtio buffers. Without it, users experience "inevitable
  segmentation faults". Symptom = segfaults. No version info given.

**Step 1.4 - Hidden Bug Fix?:**
- Record: Yes, this is a clear build-time protection against a real
  runtime failure. The verb "Add" masks what is effectively a fix to
  prevent crashes from broken configurations.

## Phase 2: Diff Analysis

**Step 2.1 - Inventory:**
- Record: 1 file (`drivers/virt/coco/pkvm-guest/Kconfig`), 1 line
  changed (`depends on ARM64` -> `depends on ARM64 &&
  DMA_RESTRICTED_POOL`). Scope: minimal / surgical.

**Step 2.2 - Code Flow:**
- Record: Before: ARM_PKVM_GUEST can be built with only ARM64. After:
  requires DMA_RESTRICTED_POOL too. Compile-time constraint only; no
  runtime code changes.

**Step 2.3 - Bug Mechanism:**
- Record: Category (h) Hardware workaround / build-time config fix
  (Kconfig dependency). Before fix, user could build a pKVM guest kernel
  lacking `DMA_RESTRICTED_POOL`; virtio buffer sharing via mem_encrypt
  ops (SHARE/UNSHARE) would then fail at runtime → segfaults described
  by Marc Zyngier.

**Step 2.4 - Fix Quality:**
- Record: Trivially correct. One-line Kconfig dependency. Zero
  regression risk: it can only prevent a misconfiguration; existing
  correct configs (with both enabled) are unaffected.

## Phase 3: Git History Investigation

**Step 3.1 - Blame:**
- Record: File touched only twice: original commit `a06c3fad49a50`
  (drivers/virt: pkvm: Add initial support..., Aug 2024, v6.12) and this
  fix. Driver has been stable for ~18 months.

**Step 3.2 - Fixes: Tag:**
- Record: None present. Bug is a design omission from `a06c3fad49a50`
  (v6.12), not a regression.

**Step 3.3 - File History:**
- Record: Only 4 commits touch pkvm-guest/ in total. Kconfig file only
  has 2 commits. Not part of a multi-patch prerequisite chain — this is
  patch 38/38 of a v5 series but the Kconfig change is self-contained.

**Step 3.4 - Author Context:**
- Record: Will Deacon is a core arm64 / kernel maintainer. Reported by
  Marc Zyngier (KVM/arm64 maintainer). Both are top-level subsystem
  authorities for this code.

**Step 3.5 - Dependencies:**
- Record: The Kconfig change is entirely self-contained. It does not
  require any other patch from the 38-patch series to apply or function.

## Phase 4: Mailing List / External Research

**Step 4.1 - Original Submission:**
- Record: `b4 dig -c 61135967fa76d` found the thread at
  `https://patch.msgid.link/20260330144841.26181-39-will@kernel.org`.
  Part of v5 series "KVM: arm64: Add support for protected guest memory
  with pKVM" (38 patches).

**Step 4.2 - Reviewers:**
- Record: Patch applied with `Signed-off-by: Marc Zyngier` as the
  KVM/arm64 maintainer taking it through his tree. Maintainer was the
  Reporter — strong trust signal.

**Step 4.3 - Bug Report:**
- Record: Marc Zyngier hit this directly while testing; no external
  syzbot/bugzilla URL.

**Step 4.4 - Series Context:**
- Record: Series revisions v1→v5. Committed version matches v5/final.
  The Kconfig patch (38/38) is a standalone cleanup tail of the series;
  not dependent on other patches.

**Step 4.5 - Stable Discussion:**
- Record: Not explicitly nominated for stable in the thread (confirmed
  no `Cc: stable` anywhere in mbox thread for this patch).

## Phase 5: Code Semantic Analysis

**Step 5.1 - Key Functions:**
- Record: No function-level changes. Kconfig-only diff.

**Step 5.2 - Callers:**
- Record: `CONFIG_ARM_PKVM_GUEST` controls build of
  `drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c` which registers
  `pkvm_crypt_ops` via `arm64_mem_crypt_ops_register()` (mem_encrypt
  SHARE/UNSHARE). These operations are invoked when DMA bounce-buffer
  infrastructure from `DMA_RESTRICTED_POOL` performs shared-memory setup
  for virtio.

**Step 5.3 - Callees:**
- Record: `pkvm_init_hyp_services()` hooks
  `arm64_mem_crypt_ops_register()` and
  `arm64_ioremap_prot_hook_register()`. Without `DMA_RESTRICTED_POOL`,
  SWIOTLB restricted pool isn't available so buffers for virtio never
  get properly set up as shared → faults.

**Step 5.4 - Reachability:**
- Record: Any pKVM-protected guest doing virtio I/O is affected —
  entirely userspace-reachable (network, block, console virtio devices).

**Step 5.5 - Similar Patterns:**
- Record: Similar explicit `depends on` patterns exist for many "coco"
  guest drivers (TDX, SEV) which have their own DMA infrastructure
  requirements.

## Phase 6: Cross-referencing and Stable Tree Analysis

**Step 6.1 - Does buggy code exist in stable?:**
- Record: `ARM_PKVM_GUEST` driver and its Kconfig entry exist in every
  stable tree from v6.12 onwards (confirmed `git tag --contains
  a06c3fad49a50` returns v6.12+). The broken config scenario exists in
  6.12.y, 6.13+ rolling and 7.0.y.

**Step 6.2 - Backport Complications:**
- Record: The stable tree (`stable/linux-7.0.y`, HEAD) currently has
  `depends on ARM64` only (confirmed by reading the file). Patch will
  apply with no modifications. Same applies to 6.12.y–6.x.y.

**Step 6.3 - Related fixes in stable:**
- Record: No earlier or alternate fix; this is the first and only fix
  for this dependency issue.

## Phase 7: Subsystem Context

**Step 7.1 - Criticality:**
- Record: drivers/virt/coco (confidential computing) = PERIPHERAL
  driver-specific, but failure mode is crash.

**Step 7.2 - Activity:**
- Record: Low activity (only 4 commits total in pkvm-guest/). The driver
  is relatively new (v6.12+) but stable in terms of scope.

## Phase 8: Impact / Risk Assessment

**Step 8.1 - Affected:**
- Record: arm64 users building a kernel with `ARM_PKVM_GUEST=y` and
  running as a pKVM protected guest, lacking `DMA_RESTRICTED_POOL=y`.
  arm64 defconfig already sets it since 6.3, so defconfig users are not
  impacted; the victims are custom-kernel builders (research, vendor
  builds, embedded).

**Step 8.2 - Trigger:**
- Record: Trigger = any virtio I/O in a pKVM guest with the broken
  config. Happens early at boot for most virtio-equipped guests.

**Step 8.3 - Severity:**
- Record: Failure mode = segmentation faults (crashes). Severity = HIGH
  (system unusable / crash). Upstream maintainer (Marc Zyngier) was
  personally affected.

**Step 8.4 - Risk vs Benefit:**
- Record: BENEFIT: prevents crashes for misconfigured pKVM guest builds,
  and documents the implicit dependency. RISK: near-zero — it's a one-
  line Kconfig constraint that can only REFUSE previously broken
  configs; existing working builds (including defconfig) are not
  affected.

## Phase 9: Synthesis

**Step 9.1 - Evidence:**
- FOR: One-line Kconfig dependency; reported by subsystem maintainer;
  signed off by maintainer; prevents segfaults; obviously correct;
  applies cleanly; no runtime changes; falls into the documented "Build
  fixes / Kconfig dependency fixes" stable exception category.
- AGAINST: Not tagged for stable; part of a large new-feature series
  (though the patch itself is standalone); niche effect (only
  misconfigured builds); defconfig users already unaffected.

**Step 9.2 - Rules Checklist:**
1. Obviously correct: YES (trivial Kconfig edit).
2. Fixes a real bug: YES (crashes reported).
3. Important (crashes): YES (segfaults = HIGH severity).
4. Small / contained: YES (1 line).
5. No new features: YES (purely a constraint).
6. Applies cleanly: YES.

**Step 9.3 - Exception Category:**
- Record: Fits "Build fixes / Kconfig dependency fixes" documented
  exception.

**Step 9.4 - Decision:**
- YES: it's a safe, obvious, Kconfig-only crash-prevention fix that
  applies cleanly to v6.12+ stable trees.

## Verification

- [Phase 1] Parsed commit: `Reported-by: Marc Zyngier`, `Link:` to lore,
  no `Cc: stable`, no `Fixes:`.
- [Phase 2] Diff confirmed via `git show 61135967fa76d` — single line
  `depends on ARM64` → `depends on ARM64 && DMA_RESTRICTED_POOL`.
- [Phase 3] `git log --oneline -- drivers/virt/coco/pkvm-guest/Kconfig`:
  only 2 commits (origin + this fix).
- [Phase 3] `git show a06c3fad49a50` + `git tag --contains
  a06c3fad49a50`: original driver introduced in v6.12.
- [Phase 4] `b4 dig -c 61135967fa76d`: matched to v5 38/38 at
  `https://patch.msgid.link/20260330144841.26181-39-will@kernel.org`.
- [Phase 4] `b4 dig -a`: patch evolved v1→v5; applied version matches
  latest.
- [Phase 4] Inspected mbox thread `/tmp/pkvm-dma-restricted.mbx` for
  `Cc: stable`/`Fixes:` referencing this patch: none found for 38/38.
- [Phase 5] Read `drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c` to
  confirm mem_encrypt SHARE/UNSHARE ops registration explains why
  DMA_RESTRICTED_POOL is needed for virtio.
- [Phase 6] `git show HEAD:drivers/virt/coco/pkvm-guest/Kconfig` on
  `stable/linux-7.0.y` shows `depends on ARM64` only — patch applies
  cleanly.
- [Phase 6] `git log --oneline -- drivers/virt/coco/pkvm-guest/` in the
  current checkout confirms only 4 total commits, no conflicting
  refactors.
- [Phase 7] `git log -S"CONFIG_DMA_RESTRICTED_POOL" --
  arch/arm64/configs/defconfig`: commit `09ea26f1bf31c` added it to
  defconfig in Jan 2023 (predates the driver).
- [Phase 8] Failure mode "segmentation faults" taken directly from
  commit message authored by Will Deacon and reporter Marc Zyngier;
  severity classification is mine based on described symptom.
- UNVERIFIED: I did not reproduce the segfault; I rely on the
  maintainer's description. I did not enumerate every downstream stable
  tree policy on Kconfig-only fixes — but this change is self-contained
  and independent.

**YES**

 drivers/virt/coco/pkvm-guest/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/pkvm-guest/Kconfig b/drivers/virt/coco/pkvm-guest/Kconfig
index d2f344f1f98f7..928b8e1668ccc 100644
--- a/drivers/virt/coco/pkvm-guest/Kconfig
+++ b/drivers/virt/coco/pkvm-guest/Kconfig
@@ -1,6 +1,6 @@
 config ARM_PKVM_GUEST
 	bool "Arm pKVM protected guest driver"
-	depends on ARM64
+	depends on ARM64 && DMA_RESTRICTED_POOL
 	help
 	  Protected guests running under the pKVM hypervisor on arm64
 	  are isolated from the host and must issue hypercalls to enable
-- 
2.53.0

