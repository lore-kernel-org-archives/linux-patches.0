Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215483;
	b=PJzCCQKaKvBGr8tbEwSGLvso6+mw6Vas9ppSlev24t+AJiRy34ltAkVK+jhArLlbwu6z
	 K+GPryj8bEv9A9tzLTFcI0LtV8OQ2zJ03eI0eoAJ6dC78f5nJMkTswx9MS9f8kSJ+Na32
	 4hTmvKDu2hrmakpAthz/nDOQBx3+XWg60omAunxNAo7axpAAe1uG0ycqhKE6ut7g+PQwb
	 Ifr9WWZL1s8EsqK6ZjGVkgHfqxGytUlkogv1gSgbw09vKobrb4B96Ko54JWG2A+qPvqZK
	 99wFV0NYuS8mJ/2awnyTubcnTjvCx8j+LMaJ6wTJTVkSYryFp50Bgp8OjepUtHRv9Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LUw+45o7cyuJx8cIariYvfA+LrUs2J/4/2aL2k693pc=;
	b=PWjwepmRvMO9tOCylYu7bMJnAqGqsSLvndO2Wz3EbHBpxN0aNh0eVuw6cjImeGq9EKTh
	 vq//nYIAMikRZX6fOyfF7ksW2H9wRbdcFaFf3m4xj4uX4KOxEEzkfUzlYrVg2mxRRnYXX
	 11NO43fjHPFN1IvNFw7qLo3xCM4a88SlA50q6rEZrEaaeVbIXbTY9aku21htlmFIXCy1f
	 D7f8Jt+NRWsBsWD7THUYNEGgtC3CMYTeArpuJKaCX7GpT1CayPupWodRI0oJQJ2bSSMiF
	 WPS8aUZfJPSEbo/S4ijjQQR+nIbH+t6JnVBQmtL/mxnwBU0vXb+8oLOZ9z0rpNq5+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCwj0CYf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A57606A31A;
	Wed, 28 Oct 2026 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCwj0CYf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD781F01825;
	Wed, 28 Oct 2026 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215482;
	bh=LUw+45o7cyuJx8cIariYvfA+LrUs2J/4/2aL2k693pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCwj0CYf9xR7GG4UGO8QBPZjrcbfKDcmwHyXseq28lsOFotaYPWDI9AFqq7OcYO/a
	 2JYWjcouU97HzKx3mQLX47q+P6GdwS9f2X9ys0BGP1LIaQlbUXsKMtFVBuQ13YTZlW
	 bWxyu07JSoXwC4qWuAGN8EcpEvZ2aVI4FbG9O+LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1224/1887] perf/x86/amd/core: Avoid enabling BRS from the SVM reload path
Date: Wed, 28 Oct 2026 17:55:20 +0100
Message-ID: <20261028170527.278609797@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 07c60dda9c059c09f83d42a3ebda2e7cc1cf3bc2 ]

Branch Sampling (BRS) and Last Branch Record (LBR) are mutually
exclusive hardware features, and users of both are tracked via
cpuc->lbr_users.

When SVM is toggled on a CPU, the host perf events are reprogrammed to
update the HostOnly filter bit (set when virtualization is enabled,
cleared when it is disabled). On PerfMonV2-capable processors, this
reprogramming is performed by calling amd_pmu_enable_all() to rewrite
the event selectors. However, amd_pmu_enable_all() also calls
amd_brs_enable_all(), which enables BRS whenever cpuc->lbr_users > 0.
Having active LBR events satisfies this gating on processors that have
LBR but not BRS. The kernel then tries to set the BRS enable bit in
DebugExtnCfg (MSR 0xc000010f). Since that bit is deprecated on such
hardware, the write results in a #GP:

  Call Trace:
   <IRQ>
   amd_pmu_enable_all+0x1d/0x90
   amd_pmu_disable_virt+0x62/0xb0
   kvm_arch_disable_virtualization_cpu+0xa/0x40 [kvm]
   hardware_disable_nolock+0x1a/0x30 [kvm]
   __flush_smp_call_function_queue+0x9b/0x410
   __sysvec_call_function+0x18/0xc0
   sysvec_call_function+0x69/0x90
   </IRQ>
   <TASK>
   asm_sysvec_call_function+0x16/0x20
  RIP: 0010:cpuidle_enter_state+0xc4/0x450
   ? cpuidle_enter_state+0xb7/0x450
   cpuidle_enter+0x29/0x40
   cpuidle_idle_call+0xf5/0x160
   do_idle+0x7b/0xe0
   cpu_startup_entry+0x26/0x30
   start_secondary+0x115/0x140
   secondary_startup_64_no_verify+0x194/0x19b
   </TASK>

Fix this by ensuring that BRS is not enabled from the event selector
reprogramming path even when cpuc->lbr_users > 0.

Fixes: bae19fdd7e9e ("perf/x86/amd/core: Fix reloading events for SVM")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/702fa204d574b03d14e3664c7d4b201db048bbfd.1783506528.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index d1f882cf418d4..4acf9adad16b8 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -719,13 +719,11 @@ static void amd_pmu_enable_event(struct perf_event *event)
 	x86_pmu_enable_event(event);
 }
 
-static void amd_pmu_enable_all(int added)
+static void __amd_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	int idx;
 
-	amd_brs_enable_all();
-
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		/* only activate events which are marked as active */
 		if (!test_bit(idx, cpuc->active_mask))
@@ -740,6 +738,12 @@ static void amd_pmu_enable_all(int added)
 	}
 }
 
+static void amd_pmu_enable_all(int added)
+{
+	amd_brs_enable_all();
+	__amd_pmu_enable_all();
+}
+
 static void amd_pmu_v2_enable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1493,7 +1497,7 @@ static inline void amd_pmu_reload_virt(void)
 		 * set global enable bits once again
 		 */
 		amd_pmu_v2_disable_all();
-		amd_pmu_enable_all(0);
+		__amd_pmu_enable_all();
 		amd_pmu_v2_enable_all(0);
 		return;
 	}
-- 
2.53.0



