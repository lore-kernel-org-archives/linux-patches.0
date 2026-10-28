Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210672;
	b=SLdoX7FP5MYVrt/zrcal5ZdKvMnLtIaMJaqE8MWKjNyzejgocg7+65hmRrDmi/FyDf4m
	 5E5gXr3kmU9PN83XMnywGnRHwtcmpLNtQvbuWLdlMa1iz6ZMfpUcWviyq/86FyTCrMku9
	 v87vYudACqx4guCzLesVUJD6EXRcVkAzK/Nbuv/TRGZAdsMzaAtuGuOgEtL3VBBDF8ANz
	 UXP7+uUy+vqLUncezGhyZtDUbVex8x8XtzUyiR7AQgEjMUNUPiq6kgGm5iNeG70uCH9uo
	 XwkMRdYOZw1BPLPUPLLYksepmHtvqxnlRLJSwR5bGx/bSfApcQt/PNyTGf0pjq7AsGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R1XxBiNWn2wM8FriLVM7I80L6AuoqxnNlr5RZ/tpupk=;
	b=C3lDUkUaZYF+l6GBBTwScagvgh46YleClEBtIai5+xEOiZsPA46ZSfdEsMua4cdXvjOS
	 modxDESkpvWq88WzT1PdnXckyg/QrnQPiaZ9orGK2w3iVzBKClgWopD2WmyK9KeLbaHyg
	 YP5uXUXQEr0FYkuho6lfLeIoH73B2k+Mqn2FIdgHGFRvoQGUbecokHxW8y5++rO/CEhIx
	 5Kzxz93gDNmNGwc6e3ouYFR/8la3uQ9grFGg/zES29gwIpW+UfImXp3YICDwwnSX4mjkX
	 3WZf+7MUzuKxwwjB2jd5HrQrmjpXAgRK81MyLOJXkExn+tm3Fls79CyxtpsurStg4FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAqOO423;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7F4606A31C;
	Wed, 28 Oct 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAqOO423
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830401F01825;
	Wed, 28 Oct 2026 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210672;
	bh=R1XxBiNWn2wM8FriLVM7I80L6AuoqxnNlr5RZ/tpupk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAqOO423TPGO798NtH7h7ONngbEiGnMFE6yw1Qjo2M/une4LNCCh6wATg23DWX11r
	 v2kQhW+piGgFzfGgP6Rxu3oXwimKZvToI8JtecgHyHom1/ZMOZDaD04jqaCy2yEOuZ
	 YJUd+WKjN3Yc/A2JOBtPEpkUkrR5zvvMLkSXDUIk=
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
Subject: [PATCH 5.15 108/571] perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities
Date: Wed, 28 Oct 2026 17:54:15 +0100
Message-ID: <20261028170010.585246932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 589c850fe4b00..234edbea1e088 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5620,12 +5620,6 @@ __init int intel_pmu_init(void)
 
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
@@ -6306,8 +6300,10 @@ __init int intel_pmu_init(void)
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
index 4ed9641dccb04..068f35eb50035 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -593,7 +593,7 @@ union perf_capabilities {
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



