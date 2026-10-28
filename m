Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208409;
	b=z/RVKdL0kBvpwuFRk3qT1Tb0f6bqqPBuLjGr2sPha35oGck5oJcOr1k3iQ9yNwOWAcMi
	 5OawTHZ7CgnvE1pfEjOLBV6r1tdu+Wkmx15DgJqFvmSiK2cI0By3IQOgFrncl0vNHk0xq
	 SxUyggpTiUeYDpyhUu+riJkIGmV447dfgf5BUnbDZOJX2m5ZDmHrPJpB7c35bNnnjc940
	 HvbMU7X1nP6QCOkpHT1OWaCCQtB+Mr67RjbnvtkH/AR25rhisiJzAsPEZkARIJXHJdot+
	 Y7FLLcE5sZgfzaEm0AaKKGXJhYagYa/4yHKSvJYjdv3AGdmX/T8FEf2dd96tV/Z8s8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXneieDAPWgkrQrnlmfq3C/EKrNXhxhUOedmtLRlKs4=;
	b=JstFQLqQKpTrsxklQCLiokIUgoYnZWY2+AMIsm6ZFJdihoku0oTgMqaOZUA1OoXYZTeF
	 TYcsZoPSXshpFNV6luC1IM5OOBOX6mdumqJZQOPTJ9oi+U6a4N/8roQVp0vRc8c+Pj2+g
	 r+TeWMA/QvPSluuC6SsRhrw2XEwU+JWPguLmirIbjhB0BPYOivneRb7gpmzOBmQRwNZl5
	 Rz1pt+3lopDZmv0M7UvjJ2LOiK+7S4ZDgvQ+DeEJzR/r437KjLzSUBsz4xD4531DeVDnT
	 JWwpiGuwnYdfUm3zzku6ZmxJw4gunZunqj7F/v4A+o9Enb2KydkU+T87LFkeJE5ulSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5+Wex5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E67606A31A;
	Wed, 28 Oct 2026 17:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N5+Wex5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EE51F01825;
	Wed, 28 Oct 2026 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208408;
	bh=sXneieDAPWgkrQrnlmfq3C/EKrNXhxhUOedmtLRlKs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5+Wex5nLdwoJYjGy7eUPY7PwfXdsZnnKWJu/bbAYcNuwP2yl/eEAdkqkXZm4OBm0
	 UVs0q8WPtZ4hLRONAP7Mu+cpiAnjFHnqUdRs3fmSa7IPODcSSctbPPO59L022Aqpkv
	 ea1XJT0U/clevk0tur/TcvrsKRIEuZmiOfEPzIqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zide Chen <zide.chen@intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/516] perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities
Date: Wed, 28 Oct 2026 17:54:22 +0100
Message-ID: <20261028170006.124339090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 8767b4d73018bd3143f4c55b672064fad292f11b ]

AnyThread mode deprecation is enumerated by CPUID.0AH:EDX[15] instead of
PERF_CAPABILITIES MSR. It's not a good practice to define a bit to
represent "anythread deprecation" in perf_capabilities. It leads to the
anythread_deprecated bit could be overwritten by the real value of
PERF_CAPABILITIES MSR, just like the below code in update_pmu_cap() does.

if (!intel_pmu_broken_perf_cap()) {
	/* Perf Metric (Bit 15) and PEBS via PT (Bit 16) are hybrid enumeration */
	rdmsrq(MSR_IA32_PERF_CAPABILITIES, hybrid(pmu, intel_cap).capabilities);
}

It leads to the anythread_deprecated bit is cleared to 0 and the "any"
attribute is incorrectly shown in the /sys/devices/cpu/format/ folder on
these support Perfmon v6 platforms, like Clearwater Forest.

$ grep . /sys/devices/cpu/format/*
/sys/devices/cpu/format/acr_mask:config2:0-63
/sys/devices/cpu/format/any:config:21
/sys/devices/cpu/format/cmask:config:24-31

So remove the anythread_deprecated bit from perf_capabilities structure
and directly depends on CPUID.0AH:EDX[15] to judge if anythread is
deprecated.

Fixes: cadbaa039b99 ("perf/x86/intel: Make anythread filter support conditional")
Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616044654.3468742-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 10 +++-------
 arch/x86/events/perf_event.h |  2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 73d1cebddee70..14e2119f9d4b4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5022,12 +5022,6 @@ __init int intel_pmu_init(void)
 
 	x86_add_quirk(intel_arch_events_quirk); /* Install first, so it runs last */
 
-	if (version >= 5) {
-		x86_pmu.intel_cap.anythread_deprecated = edx.split.anythread_deprecated;
-		if (x86_pmu.intel_cap.anythread_deprecated)
-			pr_cont(" AnyThread deprecated, ");
-	}
-
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -5554,8 +5548,10 @@ __init int intel_pmu_init(void)
 		((1LL << x86_pmu.num_counters_fixed)-1) << INTEL_PMC_IDX_FIXED;
 
 	/* AnyThread may be deprecated on arch perfmon v5 or later */
-	if (x86_pmu.intel_cap.anythread_deprecated)
+	if (version >= 5 && edx.split.anythread_deprecated) {
 		x86_pmu.format_attrs = intel_arch_formats_attr;
+		pr_cont("AnyThread deprecated, ");
+	}
 
 	if (x86_pmu.event_constraints) {
 		/*
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index bcc40b7850cb0..c63e7df31f8bc 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -587,7 +587,7 @@ union perf_capabilities {
 		u64     pebs_baseline:1;
 		u64	perf_metrics:1;
 		u64	pebs_output_pt_available:1;
-		u64	anythread_deprecated:1;
+		u64	__reserved:1;
 	};
 	u64	capabilities;
 };
-- 
2.53.0



