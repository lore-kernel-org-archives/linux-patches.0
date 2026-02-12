Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01681F936;
	Thu, 12 Feb 2026 01:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858620; cv=none; b=A6ECbEud07wjJsH381f2zfsce7lMxkmQ1wnv6dxMTaAqm7qzIMc5zwvrVcRnKLagcIKtt/VdxjU98KHsdym3B0IkRjYygy2xTzng36lCaTz+MBmq58qVkkLwV0+AKpp0CrDddA5+qLqMpO6CAHJSQI4g51U98yKp8B4g0YaLD1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858620; c=relaxed/simple;
	bh=Xyjhxetf/JuBjLMUQzU/EP8+gsZ6mzTazLRP1oGO4R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmo9R/8r/Hz210HS6Pvqh+eC2NTmVFHd0iFWTfU+4jYAHWHkSInh45hGugw/BAwVBnSrrTaMnm/ZoSk5fGAdD/RcnxaSYV/HcJA2M4HDIuvZzrrqBXLbmF6XiAOrCBu8IYh5V5vYpsilpyDGbwX0bFQvfnU76oxv4DsM4wKaJvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQihO52a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQihO52a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEAFC19423;
	Thu, 12 Feb 2026 01:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858620;
	bh=Xyjhxetf/JuBjLMUQzU/EP8+gsZ6mzTazLRP1oGO4R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQihO52aSVmxJWuTSkuXTjGFgZ8nUh+y/kouMrskVsFa/DUtkk1zzCGkP1Pcq+ME5
	 JaGf5kjLacoI6RsJ8hz5bwbXawd4b0Cuk7Hlcdh/5MlsNtMwEzv6C6bHrQByfOoXMw
	 eG6Afh9a/YUw8dZdtFY+SIid579cF8V4MLKTDLS9k9kxuZmGhoIoi5vCsjBQ/W2jo6
	 CfiJf3yHKMRki9xUXvVcRkKBzUrW0m+8aoOCgdGgECM31Na2AT6zPHOioU+gmtskuE
	 MHRLq7earyNOiPBS5ad8rgyx1L6qyFy/DfDY5gbAVS8LXeUePZAeYFttNgnHfOwQby
	 wShYrcDQSgdeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Martin Schiller <ms@dev.tdt.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] perf/x86/cstate: Add Airmont NP
Date: Wed, 11 Feb 2026 20:09:37 -0500
Message-ID: <20260212010955.3480391-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 3006911f284d769b0f66c12b39da130325ef1440 ]

From the perspective of Intel cstate residency counters, the Airmont NP
(aka Lightning Mountain) is identical to the Airmont.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251124074846.9653-4-ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Here is my analysis:

---

## Detailed Analysis of "perf/x86/cstate: Add Airmont NP"

### 1. COMMIT MESSAGE ANALYSIS

The commit adds a single CPU model ID entry for Intel Airmont NP (also
known as Lightning Mountain, CPU model 0x75) to the perf cstate
residency counter driver's match table. The author, Martin Schiller from
TDT (a networking hardware company), states that from the perspective of
cstate residency counters, Airmont NP is identical to regular Airmont.
The patch was reviewed by Dapeng Mi (Intel) and signed off by Peter
Zijlstra (Intel), the perf maintainer.

The message ID `20251124074846.9653-4-ms@dev.tdt.de` indicates this is
patch 4 of a multi-patch series, which likely adds Airmont NP support to
several Intel subsystems simultaneously.

### 2. CODE CHANGE ANALYSIS

The change is a single line addition:

```c
X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,    &slm_cstates),
```

This maps CPU model `INTEL_ATOM_AIRMONT_NP` (IFM(6, 0x75)) to the
`slm_cstates` configuration, which provides:
- **Core events**: C1 and C6 residency counters
- **Package events**: C6 residency counter (using the C7 MSR quirk)

This is the exact same cstate model used by Silvermont
(`INTEL_ATOM_SILVERMONT`), Silvermont-D (`INTEL_ATOM_SILVERMONT_D`), and
regular Airmont (`INTEL_ATOM_AIRMONT`). The Airmont NP is
architecturally an Airmont-based SoC, so sharing the same cstate
configuration is technically correct and expected.

### 3. CLASSIFICATION: NEW DEVICE ID

This falls squarely into the **"New Device ID"** exception category for
stable backports:
- The driver (`arch/x86/events/intel/cstate.c`) already exists in all
  stable trees back to v5.4
- The `slm_cstates` model structure already exists unchanged in all
  stable trees
- The `INTEL_ATOM_AIRMONT_NP` (or `INTEL_FAM6_ATOM_AIRMONT_NP`) macro
  has been defined since v5.4 (commit 855fa1f362ca from September 2019)
- Only the ID-to-model mapping is new

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 addition
- **Files touched**: 1 (`arch/x86/events/intel/cstate.c`)
- **Complexity**: Trivial - a single entry in a match table
- **Risk of regression**: Essentially zero. The new line only activates
  when running on an Airmont NP CPU (model 0x75). It cannot affect any
  other CPU or any other code path.

### 5. USER IMPACT

Without this patch, users running Linux on the Intel Lightning Mountain
SoC (used in networking/embedded equipment like DSL/fiber routers from
companies such as TDT) cannot access perf cstate residency counters.
These counters are used by power management monitoring tools like `perf`
and `turbostat` to measure CPU power states. While not a crash or data
corruption bug, this is a hardware support gap for real users on real
hardware.

The Lightning Mountain SoC vulnerability whitelist entry already exists
in `arch/x86/kernel/cpu/common.c` (since earlier kernels), and
`arch/x86/kernel/tsc_msr.c` already has Airmont NP support. The cstate
driver was simply overlooked.

### 6. BACKPORTABILITY TO STABLE TREES

The change requires trivial adaptation for different stable trees due to
macro naming:

- **v6.12+**: Uses `X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP, &slm_cstates)`
  - applies as-is
- **v6.1, v6.6**: Uses `X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_NP,
  &slm_cstates)` - trivial macro name change
- **v5.4, v5.10, v5.15**: Uses
  `X86_CSTATES_MODEL(INTEL_FAM6_ATOM_AIRMONT_NP, slm_cstates)` (v5.4) or
  `X86_MATCH_INTEL_FAM6_MODEL` variant - trivial adaptation

All prerequisites (`slm_cstates` struct, the `AIRMONT_NP` macro) exist
in every supported stable tree.

### 7. DEPENDENCY CHECK

This commit is self-contained. While it's part of a series (patch 4/N),
each patch in such a series independently adds a CPU ID to a different
driver's match table. No other commits are needed for this one to
function correctly.

### 8. STABILITY INDICATORS

- **Reviewed-by**: Dapeng Mi (Intel) - domain expert
- **Signed-off-by**: Peter Zijlstra (Intel) - perf subsystem maintainer
- The pattern is well-established: every other Atom variant (Silvermont,
  Silvermont-D, Airmont, Goldmont, Tremont, etc.) follows the exact same
  pattern in this driver

---

## Summary

This is a textbook CPU ID addition to an existing driver - the exact
type of change that stable kernel rules explicitly permit as an
exception. It's a single-line, zero-risk change that enables hardware
monitoring on real embedded/networking hardware (Intel Lightning
Mountain SoC). The driver infrastructure, cstate model, and CPU ID
definitions are all already present in every supported stable tree. The
patch was reviewed by an Intel engineer and accepted by the perf
maintainer.

**YES**

 arch/x86/events/intel/cstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index fa67fda6e45b4..c1e318bdaa397 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -599,6 +599,7 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,	&slm_cstates),
 	X86_MATCH_VFM(INTEL_ATOM_SILVERMONT_D,	&slm_cstates),
 	X86_MATCH_VFM(INTEL_ATOM_AIRMONT,	&slm_cstates),
+	X86_MATCH_VFM(INTEL_ATOM_AIRMONT_NP,	&slm_cstates),
 
 	X86_MATCH_VFM(INTEL_BROADWELL,		&snb_cstates),
 	X86_MATCH_VFM(INTEL_BROADWELL_D,	&snb_cstates),
-- 
2.51.0

