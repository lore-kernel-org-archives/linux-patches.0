Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212524;
	b=5CPEqixC7ZSgs5aOUCG5SSCam8ElEf9l0xKkUCW/tqojwsmGkXDKtoeasphKtUacUayS
	 uPKWgGuSJt/isaCHuthXk6aKbXHJ5p+WuzhJ9O7eQTE+d6eigI7y+XUFEWlEjDVnjkuvt
	 qbBxS9q3zB1n+Q6QlSxrwrB6mWpkEBI8U7oVynIwqUppbTdRqi5qGUeewA2brce4ut6Dz
	 Z41Tj0nZPiypLbJm2o1SRqM3PG4Rgm0+d8xJGeC+pFnak7jTMGUMOqowl42fSzzYG/s4l
	 3JWWSeLV/fbAYFJR6aGWbf67NMdJNenXGS/vU4CI31EuEjwPr5bN1ZqMFBtrTFGF+9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UiNTKiC7Kv7H/Knr8D6Uyltjlo146IMFZPiyhKI7Fto=;
	b=pIKQOuZXMCbTjHekxfRQ9/fE+90XGSBzl65n/eIdahbwfVAv8ZbrcpX8tBnlipFUNSXz
	 Bi9FdL1Ik+F8QsqzhzCtT3A+yrNyWV/dJOvv4jjHbGqfw9PB9Yo9ArnQ29dCBrz3RKXDP
	 ojsPRwWzUZTJLqmp8tkx+8dhIlGlGQV2kkHpeaq3LL8szGVfTMDKd5TeX34sfqytvoyMz
	 Ss04gWszXpcQPfrF+PyDrZbuFlj+Ni6kgqe6xMdw2ja2SPjQiPcTW9jkNE4OzyL1khLgT
	 RSMOi7RzHb14NiPvDy3qy1s/noF+tPqeFXRPCADmGdW7I/N5UE3F06iDAregW7R/kiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfGeKNnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F66606A31A;
	Wed, 28 Oct 2026 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfGeKNnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F51F01825;
	Wed, 28 Oct 2026 18:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212524;
	bh=UiNTKiC7Kv7H/Knr8D6Uyltjlo146IMFZPiyhKI7Fto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfGeKNnClxOK7yS7ai8NuLxZFBTOfPxcljkuIJCJQx4bkqot2w8Kgb32fSC8iYIXe
	 z7LYz4kpdXsLQEVPz+N5Iz20OXWghIHebD+zk0iazEJUEHbuhoyi8ehNNlkHW9x+06
	 jpyQhZ0sVlTrxSRHHY4Kej58BI9pA0LtNkdtpf/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0157/1887] perf/x86/intel: Update event constraints and cache_extra_regsfor ADL
Date: Wed, 28 Oct 2026 17:37:33 +0100
Message-ID: <20261028170502.806113084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 4ef863352bcde482d65722ed721c3fd3967a67d6 ]

Update perf hard-coded event constraints and cache_extra_regs[] for
Alderlake according to the latest ADL perfmon events (V1.39).

One important note is that ADL has differences on the L3/node related
OCR events although it shares same uarch with SPR server, e.g.,
ADL has different extra MSR values and no node events. So some variants
of structures and functions are introduced to reflect these
differences, like adl_glc_hw_cache_event_ids[],
adl_glc_hw_cache_extra_regs[] and intel_pmu_init_glc_hybrid(), etc.

Please note these changes would temporarily impact other platforms like
MTL/ARL-U which shares hard-coded event structures, but it would be
fixed soon in subsequent patches.

ADL perfmon events:
https://github.com/intel/perfmon/blob/main/ADL/events/alderlake_goldencove_core.json
https://github.com/intel/perfmon/blob/main/ADL/events/alderlake_gracemont_core.json

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260515061143.338553-5-dapeng1.mi@linux.intel.com

[Backport preparation for 89dc568e8c0b on Linux 6.1:
 Retain the Gracemont STORE_LATENCY counter-mask update to 0x3f.
 Drop the upstream cache/extra-register and fixed-counter changes: they
 depend on newer PMU initialization infrastructure and are not needed
 by the target's PEBS sample-classification fix.

 Prepare the target's existing-function context without adding functions.
 Rename and adapt adl_latency_data_small() as __grt_latency_data(), with
 its record fields supplied by the caller. Rename load_latency_data()
 as grt_latency_data() and reuse it for Gracemont dispatch as well as
 its existing non-Gracemont load-latency path. Preserve the original
 TLB/lock/block decoding and update the callback and prototype names.
 Guard the hybrid-only assertion for non-hybrid Gracemont systems.

 Provide the upstream INTEL_HYBRID_LDLAT/STLAT_CONSTRAINT macros so the
 unmodified target can set direction flags while retaining hybrid
 latency decoding. The target itself remains a separate backport.]

Stable-dep-of: 89dc568e8c0b ("perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c |  4 ++--
 arch/x86/events/intel/ds.c   | 34 ++++++++++++++++++----------------
 arch/x86/events/perf_event.h | 10 +++++++++-
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4615a21b9e852..6f5805ad723bf 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6195,7 +6195,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
 
 		intel_pmu_pebs_data_source_grt();
-		x86_pmu.pebs_latency_data = adl_latency_data_small;
+		x86_pmu.pebs_latency_data = grt_latency_data;
 		x86_pmu.get_event_constraints = tnt_get_event_constraints;
 		x86_pmu.limit_period = spr_limit_period;
 		td_attr = tnt_events_attrs;
@@ -6578,7 +6578,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.lbr_pt_coexist = true;
 		intel_pmu_pebs_data_source_adl();
-		x86_pmu.pebs_latency_data = adl_latency_data_small;
+		x86_pmu.pebs_latency_data = grt_latency_data;
 		x86_pmu.num_topdown_events = 8;
 		static_call_update(intel_pmu_update_topdown_event,
 				   &adl_update_topdown_event);
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 4b7faa3180e57..d1cf9876c931d 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -221,24 +221,19 @@ static inline void pebs_set_tlb_lock(u64 *val, bool tlb, bool lock)
 }
 
 /* Retrieve the latency data for e-core of ADL */
-u64 adl_latency_data_small(struct perf_event *event, u64 status)
+static u64 __grt_latency_data(struct perf_event *event, u64 status,
+			       u8 dse, bool tlb, bool lock, bool blk)
 {
-	union intel_x86_pebs_dse dse;
 	u64 val;
 
-	WARN_ON_ONCE(hybrid_pmu(event->pmu)->cpu_type == hybrid_big);
+	WARN_ON_ONCE(is_hybrid() &&
+		     hybrid_pmu(event->pmu)->cpu_type == hybrid_big);
 
-	dse.val = status;
+	val = hybrid_var(event->pmu, pebs_data_source)[dse];
 
-	val = hybrid_var(event->pmu, pebs_data_source)[dse.ld_dse];
+	pebs_set_tlb_lock(&val, tlb, lock);
 
-	/*
-	 * For the atom core on ADL,
-	 * bit 4: lock, bit 5: TLB access.
-	 */
-	pebs_set_tlb_lock(&val, dse.ld_locked, dse.ld_stlb_miss);
-
-	if (dse.ld_data_blk)
+	if (blk)
 		val |= P(BLK, DATA);
 	else
 		val |= P(BLK, NA);
@@ -246,15 +241,22 @@ u64 adl_latency_data_small(struct perf_event *event, u64 status)
 	return val;
 }
 
-static u64 load_latency_data(struct perf_event *event, u64 status)
+u64 grt_latency_data(struct perf_event *event, u64 status)
 {
 	union intel_x86_pebs_dse dse;
 	u64 val;
 
 	dse.val = status;
 
+	/* Gracemont uses bit 4 for lock and bit 5 for TLB access. */
+	if (event->hw.flags & PERF_X86_EVENT_PEBS_LAT_HYBRID)
+		return __grt_latency_data(event, status, dse.ld_dse,
+					  dse.ld_locked, dse.ld_stlb_miss,
+					  dse.ld_data_blk);
+
 	/*
-	 * use the mapping table for bit 0-3
+	 * For non-Gracemont load-latency events, use the mapping table
+	 * for bit 0-3 and retain the legacy TLB, lock and block decoding.
 	 */
 	val = hybrid_var(event->pmu, pebs_data_source)[dse.ld_dse];
 
@@ -838,7 +840,7 @@ struct event_constraint intel_glm_pebs_event_constraints[] = {
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
 	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0x3f),
 	EVENT_CONSTRAINT_END
 };
 
@@ -1511,7 +1513,7 @@ static u64 get_data_src(struct perf_event *event, u64 aux)
 	bool fst = fl & (PERF_X86_EVENT_PEBS_ST | PERF_X86_EVENT_PEBS_HSW_PREC);
 
 	if (fl & PERF_X86_EVENT_PEBS_LDLAT)
-		val = load_latency_data(event, aux);
+		val = grt_latency_data(event, aux);
 	else if (fl & PERF_X86_EVENT_PEBS_STLAT)
 		val = store_latency_data(event, aux);
 	else if (fl & PERF_X86_EVENT_PEBS_LAT_HYBRID)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 5f93316c60216..897d0abd94105 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -468,6 +468,14 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LAT_HYBRID)
 
+#define INTEL_HYBRID_LDLAT_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LAT_HYBRID|PERF_X86_EVENT_PEBS_LD_HSW)
+
+#define INTEL_HYBRID_STLAT_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LAT_HYBRID|PERF_X86_EVENT_PEBS_ST_HSW)
+
 /* Event constraint, but match on all event flags too. */
 #define INTEL_FLAGS_EVENT_CONSTRAINT(c, n) \
 	EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT|X86_ALL_EVENT_FLAGS)
@@ -1497,7 +1505,7 @@ void intel_pmu_disable_bts(void);
 
 int intel_pmu_drain_bts_buffer(void);
 
-u64 adl_latency_data_small(struct perf_event *event, u64 status);
+u64 grt_latency_data(struct perf_event *event, u64 status);
 
 extern struct event_constraint intel_core2_pebs_event_constraints[];
 
-- 
2.53.0



