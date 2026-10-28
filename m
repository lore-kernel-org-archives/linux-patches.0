Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212399;
	b=nnLbsRCIizP+2tCTNuEtdXDwAgMx8gZwu3oEAf6xhuyBAg21mAWwypLMXZ0zuQ9WQ2fA
	 QMhIfuXZY8Z63G1vK2igZbd5ixztOw5l09MOcC7eRzVePbbiKAROEhSmO1V9GRYTfawDJ
	 e/CqQTKvIvVWJ6/uB0lmCJMhajWF9B96uLfhwUGiAeVGzd1HKNsSKPlrYNvVMRfvjpfAQ
	 xKLnoX1yeYC0YYy3CWkc9n9aqlKiDo5jPKbK55Jksv7RV3kJXaryRES1RzcEUJhKtV7aA
	 nxsY5rCANzUOme9ohm8Jbj+1/cwidDkNBsMc7i+LLRJmoG82fvufMA8WaGSmnIuUMKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MxpT9NP1kFul38W5uuACtmqt8TgKUB6aWRZwViuSUM=;
	b=rqX9WQU0nJd7R79srlpXcdJQoi3SduL5b6hN9/kHoLc6jKc2FtVq6JVFMn0KBJumNZSl
	 uBbWHZe/DKhlrZq8UoRk9I3GJNcu2DNWkaJpcVemavdI5IX+KKiqc+v5inIu9FZ2hAvRm
	 UHn4D8x3TY4mep+7l2in1jFzt9PqJQ+DHNiUcMIu14Qd71Zbk7R6axLyPtQQkZE1Dy1ka
	 nVKb5pEm92TASmXrsZ0r7nNiD9Rnv9Iw+q8uLAsS7pQZSLbh3JB5qCKb2lwC2IPFq5NXt
	 Z1kUCXy7VsK6H3tOcqATtHkuuVaHS/RQU30CwtIhSaZbL8NF454cti4wMV8iAZZlsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8BimsNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE89606A324;
	Wed, 28 Oct 2026 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8BimsNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8544A1F01825;
	Wed, 28 Oct 2026 18:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212399;
	bh=1MxpT9NP1kFul38W5uuACtmqt8TgKUB6aWRZwViuSUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8BimsNU46XeUG3PORjsGDd6Q5JQ1fA0KhbCItZAYuLl5mqnrdCzwCUoIbot4do6h
	 wLvqAEjS9rtmTXr5/NQBqVHa6O7Nz0SfI6F9VeaUFmAMUL2QD0eqfScstlHAsdTvsX
	 ggOCEGk9Nr1i5kMOCueD+x6r3odPuK7RzQfBA3tY=
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
Subject: [PATCH 6.1 0139/1887] perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities
Date: Wed, 28 Oct 2026 17:37:15 +0100
Message-ID: <20261028170502.397582264@linuxfoundation.org>
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
index 4ddd967a9d3d1..4615a21b9e852 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5990,12 +5990,6 @@ __init int intel_pmu_init(void)
 
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
@@ -6734,8 +6728,10 @@ __init int intel_pmu_init(void)
 				     (u64)fixed_mask);
 
 	/* AnyThread may be deprecated on arch perfmon v5 or later */
-	if (x86_pmu.intel_cap.anythread_deprecated)
+	if (version >= 5 && edx.split.anythread_deprecated) {
 		x86_pmu.format_attrs = intel_arch_formats_attr;
+		pr_cont("AnyThread deprecated, ");
+	}
 
 	intel_pmu_check_event_constraints(x86_pmu.event_constraints,
 					  x86_pmu.num_counters,
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index b95cab9846dd7..5f93316c60216 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -606,7 +606,7 @@ union perf_capabilities {
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



