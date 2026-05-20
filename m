Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F47B3F44EA;
	Wed, 20 May 2026 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276051; cv=none; b=Uri80My7HE9lW7oI3KWGlDKdsoCOCtX3+txwPF0sHf56MgcknxqqhU0ex78ICLflEE45uTxnwokaLLlWRyfPztNCbUhjOns5MlSKemeb/G6Gw11kP0k7Eg4dg9J+9Imfym2/XTPeb7gx2VYJ/N2eGkNmVyi4k2TwsKG8lDlly0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276051; c=relaxed/simple;
	bh=vr+0ZuihRL24Qjc3VjSI1tB9O5L3mQz2Kfxc90uzM34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6HA47rN5IdkALwsKhYdwuwrNpo/YIVz2NZoGWvGpmhC49GJp1n+v5LSVfgTL9aNVkfbzwH4Tsfv0fDnqkhumRZ6Ney//Cy51Yl+rnxI2rV1fmOUEG216K0IexMvIqAAfIHpaycV5fQFNVAtT5cb89ml5iuQsmT0sf8gTRENWvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkRVim+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkRVim+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E38C1F00894;
	Wed, 20 May 2026 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276049;
	bh=8T65It1GO1SXGGayulZQ3wUSSNygOruDa19FjF8qO0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkRVim+0+OrVyWTQbhEi2+sEilqbCrnoxyGjk/uz5K6bKSEWuo0H6i5G5uol8HA6J
	 NU6olKMJvO1C8/wtkK0KHycrlKHtu9I78pTcZuAqH+4fhZjDA0TqpPSAOwezVfjh7T
	 o2UgB/swKxMXFdj8Ivs1LLNQvpqtx+nYMu85zOF1K4xI3WlsATW3GxVzW6aN3bn/S8
	 iOt31QxxVLM1dwBeOZdkR8geZBIg+4y8IpOAqXJynvxa58q03b9zNxTMrfR2axyUGi
	 uLSe646jOQojvbeaTT0EE2hpKMt5gnoZgJJuUCsIZ9pGX/qWx82pvJ1gBL+edOw1c7
	 YBa9zpb/KNL2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] powerpc/pasemi: Drop redundant res assignment
Date: Wed, 20 May 2026 07:19:17 -0400
Message-ID: <20260520111944.3424570-45-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f583bd5f64d40e083dde5bb22846c4d93e59d471 ]

Return value of pas_add_bridge() is not used, so code can be simplified
to fix W=1 clang warnings:

  arch/powerpc/platforms/pasemi/pci.c:275:6: error: variable 'res' set but not used [-Werror,-Wunused-but-set-variable]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260317130823.240279-4-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Record 1.1: Subsystem `powerpc/pasemi`; action verb `Drop`; intent is to
remove an unused local variable assignment in PA Semi PCI init.

Record 1.2: Tags found: `Signed-off-by: Krzysztof Kozlowski`, `Signed-
off-by: Madhavan Srinivasan`, `Link: https://patch.msgid.link/2026031713
0823.240279-4-krzysztof.kozlowski@oss.qualcomm.com`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
stable`.

Record 1.3: The commit explicitly describes a Clang `W=1` build warning
promoted to an error: `variable 'res' set but not used
[-Werror,-Wunused-but-set-variable]`. No runtime symptom, crash, data
corruption, or user-visible functional failure is described.

Record 1.4: This is not a hidden runtime bug fix. It is a build-warning
cleanup that can matter when building powerpc with warning-as-error
settings.

### Phase 2: Diff Analysis
Record 2.1: One file changed: `arch/powerpc/platforms/pasemi/pci.c`, `1
insertion(+), 2 deletions(-)`. Only `pas_pci_init()` is modified. Scope
is single-file surgical.

Record 2.2: Before: `pas_pci_init()` declared `int res;` and assigned
`res = pas_add_bridge(np);`, then never read `res`. After: it still
calls `pas_add_bridge(np);` but does not assign the return value. The
execution path and side effects are unchanged.

Record 2.3: Bug category: build warning/build error under specific
compiler options. Mechanism: remove unused-but-set variable. No resource
lifetime, locking, memory safety, reference counting, or logic behavior
changes.

Record 2.4: Fix quality is obviously correct by inspection: the function
call remains, only the unused local storage is removed. Regression risk
is very low because runtime behavior is unchanged.

### Phase 3: Git History Investigation
Record 3.1: `git blame` on current stable code shows the exact changed
lines are present in the checked-out stable tree. Deeper history shows
the unused `res` assignment was introduced by `250a93501d626`
(`powerpc/pasemi: Search for PCI root bus by compatible property`),
first described by `git describe` as `v4.19-rc1~110^2~83`.

Record 3.2: No `Fixes:` tag is present. Manual history identified
`250a93501d626` as the introducing commit for the exact unused
assignment pattern.

Record 3.3: Recent file history shows only the candidate commit and
unrelated treewide allocation changes in `next-20260508`; no
prerequisite pasemi PCI refactor was found.

Record 3.4: The author has other powerpc cleanup commits nearby,
including the sibling PS3 warning fix. `MAINTAINERS` identifies Madhavan
Srinivasan and Michael Ellerman as powerpc maintainers; Madhavan
committed this patch.

Record 3.5: The sibling commit `8333e4916040e` is part of the same
cleanup series but is independent. This pasemi patch applies standalone
to the current 7.0.5 checkout.

### Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c f583bd5f64d40` found the original submission by
patch-id. It found the January submission and the March resend
corresponding to the commit `Link:`. Direct WebFetch to
lore/patch.msgid.link was blocked by Anubis.

Record 4.2: `b4 dig -w` showed appropriate powerpc maintainers and
LLVM/compiler-warning stakeholders were copied: Madhavan Srinivasan,
Michael Ellerman, Nicholas Piggin, Christophe Leroy, Nathan Chancellor,
LLVM list, linuxppc-dev, and others.

Record 4.3: No bug report link or reporter tag exists. The thread
describes a compiler warning/build-cleanliness issue, not a runtime bug
report.

Record 4.4: The patch is part of a two-patch series with `powerpc/ps3:
Drop redundant result assignment`; the other patch is the same class of
cleanup and is not a dependency.

Record 4.5: The downloaded thread contains no `stable` mention. A direct
lore stable search was attempted but blocked by Anubis, so no stable-
list archive result could be independently verified.

### Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `pas_pci_init()`.

Record 5.2: Callers: `pas_pci_init()` is assigned to `.discover_phbs` in
the PA Semi machine descriptor in
`arch/powerpc/platforms/pasemi/setup.c`. `pas_add_bridge()` is static
and, in `next-20260508`, is called only from `pas_pci_init()`.

Record 5.3: Relevant callees in the affected path include
`pci_set_flags()`, `of_find_compatible_node()`, `pas_add_bridge()`, and
`of_node_put()`. `pas_add_bridge()` allocates/configures the PCI
controller and scans OF ranges/ISA bridge state.

Record 5.4: Reachability is boot-time/platform-init only for PA Semi
systems. It is not syscall-reachable and has no unprivileged runtime
trigger.

Record 5.5: Similar pattern found: sibling commit `8333e4916040e`
removes an unused assignment in PS3 platform code for the same warning
class.

### Phase 6: Stable Tree Analysis
Record 6.1: The exact unused `res = pas_add_bridge(np);` pattern exists
in verified tags `v4.19`, `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`,
`v6.17`, `v6.18`, `v6.19`, and `v7.0`. It was not present in the same
form in `v4.14` or `v4.9`.

Record 6.2: Backport difficulty is clean for the current 7.0.5 tree,
verified by `git format-patch -1 --stdout f583bd5f64d40 | git apply
--check`. Older stable trees may need minor context adjustment because
surrounding code differs in older releases.

Record 6.3: No earlier same-subject fix exists in `v7.0`; related same-
series warning fixes were found only in `next-20260508`.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is `arch/powerpc/platforms/pasemi`, a platform-
specific powerpc PCI init path. Criticality is peripheral/platform-
specific, not core kernel.

Record 7.2: Recent pasemi file history is low churn. This is mature
platform code with little recent activity.

### Phase 8: Impact And Risk
Record 8.1: Affected population: PA Semi powerpc platform builders,
especially Clang `W=1` builds with powerpc `-Werror` behavior.

Record 8.2: Trigger condition is build-time only. No runtime trigger and
no unprivileged-user trigger were verified.

Record 8.3: Failure mode is build failure under specific warning/error
settings, not crash/corruption/deadlock. Severity is medium for affected
builders, low for runtime users.

Record 8.4: Benefit is narrow but real under the stable build-fix
exception. Risk is extremely low because the generated runtime behavior
should be unchanged: the same function call remains and only an unused
local assignment is removed.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: fixes a verified compiler
warning/error class; code exists across many stable-era releases; patch
is tiny, standalone, and behavior-preserving; applies cleanly to current
stable checkout. Evidence against: no runtime bug, no default-build
failure was verified, no stable nomination, platform-specific impact.
Unresolved: direct stable lore search was blocked, and I did not run a
full Clang `W=1` build.

Record 9.2: Stable rules checklist: obviously correct: yes by
inspection; tested: no explicit `Tested-by` and no local full build;
fixes a real issue: yes as a build-warning/error issue under specific
settings; important: only under build-fix exception, not runtime-
critical; small/contained: yes, 3-line single-function change; no new
feature/API: yes; applies to stable: current 7.0.5 yes, older trees
likely simple but not all tested.

Record 9.3: Exception category: build fix. This is the only reason to
take it; it is not a runtime bug fix.

Record 9.4: Decision: backport as a low-risk build fix for Clang
`W=1`/powerpc warning-as-error builds. The benefit is narrow, but the
patch is minimal, standalone, and behavior-preserving.

## Verification
- [Phase 1] `git show --format=fuller --stat --patch f583bd5f64d40`
  verified commit message, tags, and exact diff.
- [Phase 2] Diff verified one file, one function, `1 insertion`, `2
  deletions`.
- [Phase 3] `git blame` and `git show 250a93501d626` verified the unused
  assignment pattern was introduced by `250a93501d626`, described as
  before `v4.19-rc1`.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and `b4 mbox` verified the patch
  submission, resend, recipients, and lack of candidate-specific stable
  tags in the downloaded thread.
- [Phase 5] `rg` and `git grep` verified `pas_pci_init()` call placement
  and `pas_add_bridge()` call sites.
- [Phase 6] `git grep` verified the pattern in `v4.19`, `v5.10`,
  `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.17`, `v6.18`, `v6.19`, and
  `v7.0`; `git apply --check` verified clean apply to current 7.0.5.
- [Phase 7] `MAINTAINERS` verified powerpc maintainers and subsystem
  ownership.
- [Phase 8] `arch/powerpc/Kconfig.debug` and `arch/powerpc/Kbuild`
  verified powerpc warning-as-error configuration exists.
- UNVERIFIED: I did not run a full Clang `W=1` build, and direct lore
  stable search was blocked by Anubis.

**YES**

 arch/powerpc/platforms/pasemi/pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/pci.c b/arch/powerpc/platforms/pasemi/pci.c
index 60f990a336c47..2df9552746529 100644
--- a/arch/powerpc/platforms/pasemi/pci.c
+++ b/arch/powerpc/platforms/pasemi/pci.c
@@ -272,13 +272,12 @@ void __init pas_pci_init(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
 	struct device_node *np;
-	int res;
 
 	pci_set_flags(PCI_SCAN_ALL_PCIE_DEVS);
 
 	np = of_find_compatible_node(root, NULL, "pasemi,rootbus");
 	if (np) {
-		res = pas_add_bridge(np);
+		pas_add_bridge(np);
 		of_node_put(np);
 	}
 	of_node_put(root);
-- 
2.53.0

