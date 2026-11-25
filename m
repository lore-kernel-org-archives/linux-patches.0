Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624647;
	b=xDMA3pW1zPOOXHiHharE49/xeH5W3J/ob10Eba4AhHumvMy6bcTn6AssxqOgemHEDv6S
	 E40j36qLq+BJxJqzL5FT7hGY3cwJZm+LVwZXa+DnkH5xB8y3hZQc0UmDFa6FtBex7/b5n
	 cIUvE7G/WiomwcKpQ1flPtNkdex7BFGpQKowspeRi2vZKXXfsJWAQQx7eQE7tdnAmbPuY
	 3DbUbc8piD7ebsjT+5QdG4l689tUp4iVmrUlc1LL/1zI1DbkvafRqMdxvR3EGV4X+EPhI
	 KWPcJ2DRrz3eUKXl9KGfMYCEnIKKi8KVz6NJ3xf4gnTwCsd3nqfpdKeyaob5QlvkBgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2W/Wdf8tvOye0L4FZJ6SeQHBKNfLsEa2QtP0NRjMqMc=;
	b=2Ztz3D7QrHMZAYyamkrkywzoqBAd3gXPqcf2NIXm6OapXEmvjOMLDNnxHwcNlEhlUJPU
	 KNdwyJbbJl8QJfNwGU1mWfuTsnGd5qY96UxmlAD65Nbk4vm5Gs1g27RJ05h9l8Vv5fmFW
	 I4vuZtFCVa1qHMrUh90mQ56C+SEL19LfwnWNTCkbWN1Wbqt2uK9xgQj++Qlk0dfGRla0k
	 cIIhwf61RsIpJRPX8A5oVsgSbgDSh8DY0oj1MH4iOO1Q4lsYnX7l1Dn0th1vV3H8LxTgh
	 x2Q76qSRkG9DaA4iSt4Trl7b0r1FIHThn8niPV+9nXcjX1ftnmZqRclAy+d06iRn5Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BxsqP2dS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61737606A333;
	Wed, 25 Nov 2026 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BxsqP2dS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E11F000C0;
	Wed, 25 Nov 2026 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624647;
	bh=2W/Wdf8tvOye0L4FZJ6SeQHBKNfLsEa2QtP0NRjMqMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxsqP2dSpdA8k+zYD++IoGRiZdiJP6ENaAnObfBvfnCkHKT7ZtG9LwZbZSTwp3qQ6
	 LYHDK32x1AhTVqaqOihJf8rfHXh5gIQJN3TpM+maNpMWOd3gpIqIN5RXdj6Dcr3qOB
	 KbOoPFmkSp8F0oSgbedyXlzdGAo6OikhZ6s0Xv0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/816] perf/core: Add this_cpc() helper
Date: Wed, 25 Nov 2026 15:30:08 +0100
Message-ID: <20261125143855.226261264@linuxfoundation.org>
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

[ Upstream commit b2996f56556e389a13377158904c218da6fffa91 ]

As a preparation for adding yet another indirection.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20241104135518.650051565@infradead.org
Stable-dep-of: 3bbd85b2f67a ("perf: Fix racy update of cpc->hrtimer_interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 564629cef73fe..ba6603bd03428 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1190,23 +1190,28 @@ static int perf_mux_hrtimer_restart_ipi(void *arg)
 	return perf_mux_hrtimer_restart(arg);
 }
 
+static __always_inline struct perf_cpu_pmu_context *this_cpc(struct pmu *pmu)
+{
+	return this_cpu_ptr(pmu->cpu_pmu_context);
+}
+
 void perf_pmu_disable(struct pmu *pmu)
 {
-	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
+	int *count = &this_cpc(pmu)->pmu_disable_count;
 	if (!(*count)++)
 		pmu->pmu_disable(pmu);
 }
 
 void perf_pmu_enable(struct pmu *pmu)
 {
-	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
+	int *count = &this_cpc(pmu)->pmu_disable_count;
 	if (!--(*count))
 		pmu->pmu_enable(pmu);
 }
 
 static void perf_assert_pmu_disabled(struct pmu *pmu)
 {
-	int *count = &this_cpu_ptr(pmu->cpu_pmu_context)->pmu_disable_count;
+	int *count = &this_cpc(pmu)->pmu_disable_count;
 	WARN_ON_ONCE(*count == 0);
 }
 
@@ -2322,7 +2327,7 @@ static void
 event_sched_out(struct perf_event *event, struct perf_event_context *ctx)
 {
 	struct perf_event_pmu_context *epc = event->pmu_ctx;
-	struct perf_cpu_pmu_context *cpc = this_cpu_ptr(epc->pmu->cpu_pmu_context);
+	struct perf_cpu_pmu_context *cpc = this_cpc(epc->pmu);
 	enum perf_event_state state = PERF_EVENT_STATE_INACTIVE;
 
 	// XXX cpc serialization, probably per-cpu IRQ disabled
@@ -2467,9 +2472,8 @@ __perf_remove_from_context(struct perf_event *event,
 		pmu_ctx->rotate_necessary = 0;
 
 		if (ctx->task && ctx->is_active) {
-			struct perf_cpu_pmu_context *cpc;
+			struct perf_cpu_pmu_context *cpc = this_cpc(pmu_ctx->pmu);
 
-			cpc = this_cpu_ptr(pmu_ctx->pmu->cpu_pmu_context);
 			WARN_ON_ONCE(cpc->task_epc && cpc->task_epc != pmu_ctx);
 			cpc->task_epc = NULL;
 		}
@@ -2622,7 +2626,7 @@ static int
 event_sched_in(struct perf_event *event, struct perf_event_context *ctx)
 {
 	struct perf_event_pmu_context *epc = event->pmu_ctx;
-	struct perf_cpu_pmu_context *cpc = this_cpu_ptr(epc->pmu->cpu_pmu_context);
+	struct perf_cpu_pmu_context *cpc = this_cpc(epc->pmu);
 	int ret = 0;
 
 	WARN_ON_ONCE(event->ctx != ctx);
@@ -2729,7 +2733,7 @@ group_sched_in(struct perf_event *group_event, struct perf_event_context *ctx)
 static int group_can_go_on(struct perf_event *event, int can_add_hw)
 {
 	struct perf_event_pmu_context *epc = event->pmu_ctx;
-	struct perf_cpu_pmu_context *cpc = this_cpu_ptr(epc->pmu->cpu_pmu_context);
+	struct perf_cpu_pmu_context *cpc = this_cpc(epc->pmu);
 
 	/*
 	 * Groups consisting entirely of software events can always go on.
@@ -3352,9 +3356,8 @@ static void __pmu_ctx_sched_out(struct perf_event_pmu_context *pmu_ctx,
 	struct pmu *pmu = pmu_ctx->pmu;
 
 	if (ctx->task && !(ctx->is_active & EVENT_ALL)) {
-		struct perf_cpu_pmu_context *cpc;
+		struct perf_cpu_pmu_context *cpc = this_cpc(pmu);
 
-		cpc = this_cpu_ptr(pmu->cpu_pmu_context);
 		WARN_ON_ONCE(cpc->task_epc && cpc->task_epc != pmu_ctx);
 		cpc->task_epc = NULL;
 	}
@@ -3602,7 +3605,7 @@ static void perf_ctx_sched_task_cb(struct perf_event_context *ctx,
 	struct perf_cpu_pmu_context *cpc;
 
 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
-		cpc = this_cpu_ptr(pmu_ctx->pmu->cpu_pmu_context);
+		cpc = this_cpc(pmu_ctx->pmu);
 
 		if (cpc->task_epc != pmu_ctx)
 			continue;
@@ -3714,7 +3717,7 @@ static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 
 void perf_sched_cb_dec(struct pmu *pmu)
 {
-	struct perf_cpu_pmu_context *cpc = this_cpu_ptr(pmu->cpu_pmu_context);
+	struct perf_cpu_pmu_context *cpc = this_cpc(pmu);
 
 	this_cpu_dec(perf_sched_cb_usages);
 	barrier();
@@ -3726,7 +3729,7 @@ void perf_sched_cb_dec(struct pmu *pmu)
 
 void perf_sched_cb_inc(struct pmu *pmu)
 {
-	struct perf_cpu_pmu_context *cpc = this_cpu_ptr(pmu->cpu_pmu_context);
+	struct perf_cpu_pmu_context *cpc = this_cpc(pmu);
 
 	if (!cpc->sched_cb_usage++)
 		list_add(&cpc->sched_cb_entry, this_cpu_ptr(&sched_cb_list));
@@ -3853,7 +3856,7 @@ static void __link_epc(struct perf_event_pmu_context *pmu_ctx)
 	if (!pmu_ctx->ctx->task)
 		return;
 
-	cpc = this_cpu_ptr(pmu_ctx->pmu->cpu_pmu_context);
+	cpc = this_cpc(pmu_ctx->pmu);
 	WARN_ON_ONCE(cpc->task_epc && cpc->task_epc != pmu_ctx);
 	cpc->task_epc = pmu_ctx;
 }
@@ -3982,10 +3985,9 @@ static int merge_sched_in(struct perf_event *event, void *data)
 			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
 		} else {
-			struct perf_cpu_pmu_context *cpc;
+			struct perf_cpu_pmu_context *cpc = this_cpc(event->pmu_ctx->pmu);
 
 			event->pmu_ctx->rotate_necessary = 1;
-			cpc = this_cpu_ptr(event->pmu_ctx->pmu->cpu_pmu_context);
 			perf_mux_hrtimer_restart(cpc);
 			group_update_userpage(event);
 		}
-- 
2.53.0



