Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4DC34C14E;
	Fri, 31 Oct 2025 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919538; cv=none; b=pzUF9CL6gDHh3O14gZuSoh2BkWbwIVcoNS6KufDt8GB9cUxEnVQgfbO+6jpwfFxH3bMFdJuaAanN7L5/c/iRIW7wU1rl9KP+/QMUOdAAGie6BZMTazBHtD9mexQ5HxL+vdP90XJadLPFGaMgnwzSR/cHgZlXr8X9n5fYALG77B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919538; c=relaxed/simple;
	bh=FSkar9HvkoGAATjN3cqwv4WaPIT6SXC7mIpnz+3jG60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYm6Ouy6uHlImn6pP41sCScxFFaeodMz9CNXbZTbmRRYErKnsP3739lO/Ym+5rf9FE3EpdUwGq7R7gB4NnWot7ejA8lbjYi+DuLfeMa+H8LbPO/WzWI01SxHETtAbpI5FX8HegtZqc3mpNPnzH6MUKiZO0O9TDvRa3Cqwt7qTVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcMh2Hzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcMh2Hzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E49C4CEE7;
	Fri, 31 Oct 2025 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919538;
	bh=FSkar9HvkoGAATjN3cqwv4WaPIT6SXC7mIpnz+3jG60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcMh2HzbUBL52pTndWK9ScZHjMKec8Rs8/5Lv/nsFKoP2hT4RpHLfvRrw0ZXEhZOJ
	 sAWaT3o1jYMbTCzv71PyykCbJ+mNcBMgyeXFqOKhOUJx67CG3zoFitq5IhZgeMqyYJ
	 7IihbqmJQ1X591k9jINtKXuG6cpp5U7WGiMX95ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 12/35] perf/x86/intel: Add ICL_FIXED_0_ADAPTIVE bit into INTEL_FIXED_BITS_MASK
Date: Fri, 31 Oct 2025 15:01:20 +0100
Message-ID: <20251031140043.851182044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 2676dbf9f4fb7f6739d1207c0f1deaf63124642a ]

ICL_FIXED_0_ADAPTIVE is missed to be added into INTEL_FIXED_BITS_MASK,
add it.

With help of this new INTEL_FIXED_BITS_MASK, intel_pmu_enable_fixed() can
be optimized. The old fixed counter control bits can be unconditionally
cleared with INTEL_FIXED_BITS_MASK and then set new control bits base on
new configuration.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
Link: https://lore.kernel.org/r/20250820023032.17128-7-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c      | 10 +++-------
 arch/x86/include/asm/perf_event.h |  6 +++++-
 arch/x86/kvm/pmu.h                |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 15da60cf69f20..046d12281fd94 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2845,8 +2845,8 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 mask, bits = 0;
 	int idx = hwc->idx;
+	u64 bits = 0;
 
 	if (is_topdown_idx(idx)) {
 		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
@@ -2885,14 +2885,10 @@ static void intel_pmu_enable_fixed(struct perf_event *event)
 
 	idx -= INTEL_PMC_IDX_FIXED;
 	bits = intel_fixed_bits_by_idx(idx, bits);
-	mask = intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
-
-	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip) {
+	if (x86_pmu.intel_cap.pebs_baseline && event->attr.precise_ip)
 		bits |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-		mask |= intel_fixed_bits_by_idx(idx, ICL_FIXED_0_ADAPTIVE);
-	}
 
-	cpuc->fixed_ctrl_val &= ~mask;
+	cpuc->fixed_ctrl_val &= ~intel_fixed_bits_by_idx(idx, INTEL_FIXED_BITS_MASK);
 	cpuc->fixed_ctrl_val |= bits;
 }
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 70d1d94aca7e6..ee943bd1595af 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -35,7 +35,6 @@
 #define ARCH_PERFMON_EVENTSEL_EQ			(1ULL << 36)
 #define ARCH_PERFMON_EVENTSEL_UMASK2			(0xFFULL << 40)
 
-#define INTEL_FIXED_BITS_MASK				0xFULL
 #define INTEL_FIXED_BITS_STRIDE			4
 #define INTEL_FIXED_0_KERNEL				(1ULL << 0)
 #define INTEL_FIXED_0_USER				(1ULL << 1)
@@ -48,6 +47,11 @@
 #define ICL_EVENTSEL_ADAPTIVE				(1ULL << 34)
 #define ICL_FIXED_0_ADAPTIVE				(1ULL << 32)
 
+#define INTEL_FIXED_BITS_MASK					\
+	(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER |		\
+	 INTEL_FIXED_0_ANYTHREAD | INTEL_FIXED_0_ENABLE_PMI |	\
+	 ICL_FIXED_0_ADAPTIVE)
+
 #define intel_fixed_bits_by_idx(_idx, _bits)			\
 	((_bits) << ((_idx) * INTEL_FIXED_BITS_STRIDE))
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index ad89d0bd60058..103604c4b33b5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -13,7 +13,7 @@
 #define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
-/* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
+/* retrieve a fixed counter bits out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) \
 	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
-- 
2.51.0



