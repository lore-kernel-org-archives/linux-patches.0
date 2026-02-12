Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369D19F12A;
	Thu, 12 Feb 2026 01:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858614; cv=none; b=WCkaZ96qxDHrC2K/6NKAhnBLu/C0fkoVTPYK+jEtH3B1A68O2WIy3saSl0wY++5gphQQn0fw5HDK5LTWkotRbUi8xwYfYwLSXevRjD0hfKWahtErdcPILWI/llx1ZMfWekSlr8Cwxz2SCaXf6FhEcJR4ADaThsQSPCsKxIunndQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858614; c=relaxed/simple;
	bh=aC9VuZzl3E0a8Sb4VzMp8Q9ljH2mVfamJHx5wdxBqRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBwLHYScFMsXoLTTKFF+3oGoYeCzO+oWCU8lg06GyPEoHR0AJhMLiBTJEoRXUXDXA16ibsxwc8dPQRNKl4H6kSdovCkM23YFnvEPevFoueMLsYfD3M2zQ9nm8wfquNwXzQ+DUkIOV9ZLkrWmDsCipyKt8s0LyLQYNnF95Y1Zt7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1VPU6Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1VPU6Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F43C4CEF7;
	Thu, 12 Feb 2026 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858614;
	bh=aC9VuZzl3E0a8Sb4VzMp8Q9ljH2mVfamJHx5wdxBqRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1VPU6YdK/Aq5h96Z5iPfCMdapR0Hgiajs0rJVtFdG+8MzlJcnze5hGkNz9qLdU6x
	 2+nFtbxeTK5GccG2OL4sn00+QB7uiOfS8NzxDhgbcyhlYyCXgbIkdkrAAdngIrPyY5
	 PMgGL4IX8HmzftZdDybYvH74sc0OtWOjkNVRX7a6kbgBr0V20KzhN4xAKb5lhx1eQn
	 BYuYybw8ZKZb/VESt8+XMKg/+1hRShwWJmnlZF3qeDLVPMvX3A4mRHPt9se/LNl8X+
	 TzHKMJ3Hq77vWrVlDDCEc0iiVRcJTlXDU1vIAW77CvVsXoWkI0EQ7qZcO+qztBRmSY
	 cBm9/Fw9YxFow==
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
Subject: [PATCH AUTOSEL 6.19-6.18] perf/x86/intel: Add Airmont NP
Date: Wed, 11 Feb 2026 20:09:33 -0500
Message-ID: <20260212010955.3480391-10-sashal@kernel.org>
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

[ Upstream commit a08340fd291671c54d379d285b2325490ce90ddd ]

The Intel / MaxLinear Airmont NP (aka Lightning Mountain) supports the
same architectual and non-architecural events as Airmont.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20251124074846.9653-3-ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the commit under review only touches `core.c`, and other
files in the perf events subsystem also lack Airmont NP support (which
may be handled by other patches in the series, but this commit is
standalone).

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `perf/x86/intel: Add Airmont NP`

The commit adds the `INTEL_ATOM_AIRMONT_NP` (Lightning Mountain SoC, CPU
model 0x75) case label to the Silvermont/Airmont PMU initialization
block in `intel_pmu_init()`. The commit message states this CPU supports
the same architectural and non-architectural events as Airmont, so it
should share the same event tables.

The commit was reviewed by `Dapeng Mi <dapeng1.mi@linux.intel.com>` (an
Intel PMU engineer) and merged by Peter Zijlstra. The patch link
`20251124074846.9653-3-ms@dev.tdt.de` indicates this is patch 3 of a
series, but the change itself is self-contained.

### 2. CODE CHANGE ANALYSIS

The diff shows a **single-line addition**:

```7407:7408:arch/x86/events/intel/core.c
        case INTEL_ATOM_AIRMONT:
        case INTEL_ATOM_AIRMONT_NP:
```

This adds `case INTEL_ATOM_AIRMONT_NP:` to an existing `switch
(boot_cpu_data.x86_vfm)` case block that groups Silvermont and Airmont
CPUs together. The block configures:
- Cache event IDs (`slm_hw_cache_event_ids`)
- Cache extra regs (`slm_hw_cache_extra_regs`)
- LBR initialization (`intel_pmu_lbr_init_slm()`)
- Event constraints (`intel_slm_event_constraints`)
- PEBS constraints (`intel_slm_pebs_event_constraints`)
- Extra registers (`intel_slm_extra_regs`)
- TopDown and format attributes

**Without this patch:** On Airmont NP (Lightning Mountain) systems,
`intel_pmu_init()` falls through to the `default:` case, which only
provides generic architectural perfmon support (using the version-based
sub-switch). Users would get:
- No Silvermont-specific hardware cache event support
- No LBR (Last Branch Record) support
- Generic event constraints instead of Silvermont-tuned ones
- No PEBS (Processor Event-Based Sampling) support appropriate for the
  microarchitecture
- No TopDown or extra format attributes

This significantly degrades perf monitoring capability on real hardware.

### 3. CLASSIFICATION

This is a **device ID addition to an existing driver**, which is one of
the explicitly enumerated exceptions allowed in stable:

> "NEW DEVICE IDs (Very Common): Adding PCI IDs, USB IDs, ACPI IDs, etc.
to existing drivers. These are trivial one-line additions that enable
hardware support. Rule: The driver must already exist in stable; only
the ID is new."

The `INTEL_ATOM_AIRMONT_NP` define (model `IFM(6, 0x75)`) has existed in
`arch/x86/include/asm/intel-family.h` since kernel v5.4 (commit
`855fa1f362ca`, September 2019). This means it is available in **all
currently maintained stable trees** (5.4, 5.10, 5.15, 6.1, 6.6, 6.12).
The Silvermont/Airmont event tables and LBR code all predate v5.4 as
well.

The CPU model is already handled in multiple other subsystems:
- `arch/x86/kernel/cpu/common.c` - vulnerability whitelist
- `arch/x86/kernel/cpu/intel.c` - TSC features
- `arch/x86/kernel/tsc_msr.c` - TSC frequency
- `drivers/thermal/intel/intel_tcc.c` - thermal management

The perf events subsystem was simply missed when the CPU ID was first
added.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 (single `case` label addition)
- **Files touched:** 1 (`arch/x86/events/intel/core.c`)
- **Risk:** Extremely low - this is a fall-through case label addition
  to an existing switch block. It only affects systems with CPUID family
  6 model 0x75. No other CPU model is affected.
- **Dependencies:** None. `INTEL_ATOM_AIRMONT_NP` is already defined in
  `intel-family.h` in all stable trees. The Silvermont event tables all
  exist in stable.

### 5. USER IMPACT

The Lightning Mountain (Airmont NP) SoC is used in Intel/MaxLinear
network gateway devices. The author Martin Schiller is from TDT GmbH, a
networking equipment company, and has several commits related to
Lantiq/Intel LGM networking platforms. This is a real embedded platform
with real users who need proper perf support.

Without this patch, `perf stat`, `perf record`, and other perf tools
provide only basic generic counter support, missing the Silvermont-
specific events, PEBS, LBR, and proper event constraints.

### 6. STABILITY INDICATORS

- **Reviewed-by:** Dapeng Mi (Intel PMU engineer)
- **Merged by:** Peter Zijlstra (perf subsystem maintainer)
- **Pattern:** This is a well-established pattern - the switch statement
  in `intel_pmu_init()` has dozens of similar case additions over the
  years
- **No possible regression:** Only affects one specific CPU model

### 7. DEPENDENCY CHECK

The commit is fully self-contained. The `INTEL_ATOM_AIRMONT_NP` macro
exists in all stable trees since v5.4. The Silvermont event tables and
LBR code it hooks into have existed since well before v5.4. No other
patches from the series are required for this change to be correct and
useful.

### Conclusion

This is a textbook example of a device ID addition to an existing driver
- a single `case` label adding CPU model support to the perf PMU
initialization switch statement. The CPU model define has existed in the
kernel since v5.4. The change is trivially correct (confirmed by Intel
PMU engineer review), zero-risk (only affects one specific CPU model),
and enables proper perf monitoring on real embedded hardware. It matches
the explicit stable exception for device ID additions perfectly.

**YES**

 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bdf3f0d0fe216..d85df652334fb 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -7405,6 +7405,7 @@ __init int intel_pmu_init(void)
 	case INTEL_ATOM_SILVERMONT_D:
 	case INTEL_ATOM_SILVERMONT_MID:
 	case INTEL_ATOM_AIRMONT:
+	case INTEL_ATOM_AIRMONT_NP:
 	case INTEL_ATOM_SILVERMONT_MID2:
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
-- 
2.51.0

