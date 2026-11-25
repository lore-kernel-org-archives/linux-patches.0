Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624644;
	b=TWc2ljngmxfppkBxfCbUImuLCEg+dXb5t+i0/tMgd5GvIRPGgXYDIWR/h70l/RnIYx4j
	 P9kY/fjSet3aSR40EK+o0BwNE4IhSV3Y2BOwTtRrFnYiSilDLBghjltYnOBZVSQQztos6
	 cbgzj9Zn/jPvswVf/U4zPSCj95gj9tvUZg6KeF989AFffYfdHSqt3q7Le3XHzrUZttGXu
	 YC6dAZY0DWMHczZ6UHJwaF3hUnCy93HfBIwaD0MzN6RPxxBbGCrq6mQqi/nhnY1Pd07SM
	 qZkzgzaSoh5xv6f3FRWjgnqhCcHGAbmqr4w6Bw3tJvs621e27R0Dsug/AC74Xc8J7NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyW4aClDccQgSDgTfM12JqychX855XiHr2+jcg7Wwbw=;
	b=PPlS5o3gX+64DOfvZgtZ/ZSxUNIhtbwLn3Jx3X5aW9qX9ntmNHlJ1f7xrtIN5QUz/KcU
	 FpIBs/Y3z79VgIAKlrshQTk/uzNgSk1rlVlwQc8dJRp9HP/Z+nKExNOJPRcLhgGVgvnwN
	 ayVdNzELmOZBQW9IeZ4iKamH48HAAthlbHhr8NMPEU4IX1NuGWEpGz5vHxvye05OdZBDn
	 nNk9jxcjveDU7mZR6yvcNO64qESM2Fortkh7OxrirOSic+PjWPeXB8yxQSf80UBSAZTKt
	 oZFY6kXOuT2j5Hft0/sK0LiktV8TPlcQJh6R75zASSY0ek3o0LikkM+J1NaUIAKQnrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxpV1B3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36802606A681;
	Wed, 25 Nov 2026 16:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxpV1B3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228B41F000CF;
	Wed, 25 Nov 2026 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624643;
	bh=xyW4aClDccQgSDgTfM12JqychX855XiHr2+jcg7Wwbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxpV1B3D1jv/46fbXwKNXjpXp4WhgV546247+quj1nzszlHrvyvvHkbSSt4QaCMSz
	 DU0sg2qDXFkMGH7wdfsjwBqhPVemCPpuUCjYALjszC7Bvp4gC3S2y3cvZZ74gMxwXP
	 WEhT64OKupt4OgNsya/pRLhmmjI5ztDPwuO7sHrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/816] perf/core: Merge struct pmu::pmu_disable_count into struct perf_cpu_pmu_context::pmu_disable_count
Date: Wed, 25 Nov 2026 15:30:07 +0100
Message-ID: <20261125143855.204064950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4baeb0687abf5eca3f7ab8b147c27cce82ec49ea ]

Because it makes no sense to have two per-cpu allocations per pmu.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20241104135518.518730578@infradead.org
Stable-dep-of: 3bbd85b2f67a ("perf: Fix racy update of cpc->hrtimer_interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index afb23be1c0b47..58f7d4fe72819 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -344,7 +344,6 @@ struct pmu {
 	 */
 	unsigned int			scope;
 
-	int __percpu			*pmu_disable_count;
 	struct perf_cpu_pmu_context __percpu *cpu_pmu_context;
 	atomic_t			exclusive_cnt; /* < 0: cpu; > 0: tsk */
 	int				task_ctx_nr;
@@ -1031,6 +1030,7 @@ struct perf_cpu_pmu_context {
 
 	int				active_oncpu;
 	int				exclusive;
+	int				pmu_disable_count;
 
 	raw_spinlock_t			hrtimer_lock;
 	struct hrtimer			hrtimer;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7df3a9749433..564629cef73fe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1192,21 +1192,22 @@ static int perf_mux_hrtimer_restart_ipi(void *arg)
 
 void perf_pmu_disable(struct pmu *pmu)
 {
-	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
 	if (!(*count)++)
 		pmu->pmu_disable(pmu);
 }
 
 void perf_pmu_enable(struct pmu *pmu)
 {
-	int *count = this_cpu_ptr(pmu->pmu_disable_count);
+	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
 	if (!--(*count))
 		pmu->pmu_enable(pmu);
 }
 
 static void perf_assert_pmu_disabled(struct pmu *pmu)
 {
-	WARN_ON_ONCE(*this_cpu_ptr(pmu->pmu_disable_count) == 0);
+	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
+	WARN_ON_ONCE(*count == 0);
 }
 
 static inline void perf_pmu_read(struct perf_event *event)
@@ -11880,7 +11881,6 @@ static bool idr_cmpxchg(struct idr *idr, unsigned long id, void *old, void *new)
 
 static void perf_pmu_free(struct pmu *pmu)
 {
-	free_percpu(pmu->pmu_disable_count);
 	if (pmu_bus_running && pmu->dev && pmu->dev != PMU_NULL_DEV) {
 		if (pmu->nr_addr_filters)
 			device_remove_file(pmu->dev, &dev_attr_nr_addr_filters);
@@ -11899,10 +11899,6 @@ int perf_pmu_register(struct pmu *_pmu, const char *name, int type)
 	struct pmu *pmu __free(pmu_unregister) = _pmu;
 	guard(mutex)(&pmus_lock);
 
-	pmu->pmu_disable_count = alloc_percpu(int);
-	if (!pmu->pmu_disable_count)
-		return -ENOMEM;
-
 	if (WARN_ONCE(!name, "Can not register anonymous pmu.\n"))
 		return -EINVAL;
 
-- 
2.53.0



