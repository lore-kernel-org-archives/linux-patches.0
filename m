Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064033;
	b=NvBCjcFQNBTchk8SI4B11Aua1Wluh2DDFkNtVfafHX2qpoCEOs2gDSTmcz+0GiNUez1i
	 k6f8yS3PfIiUmrT9WZP8hMtD6CbmawRIcoT2zZAIHbPJ7EktASfBPqzHt5Kd6IB2FBQdx
	 yyEhK1YXhZzIlk1y+sZSGUj798yT8IfXPYsFIInWKxth9ar2E0GzZbylXi1NVpFdsH8O1
	 wR6edfREzRZUODvwY7nV7kh3DnEvSQzqsJ/ip3xLE567wzPANpsyt2BjCwe4UYHgrJeF4
	 Z+yxw6EeaP+weBWoiJT2UhVqIKd5PyQTCk4VykmQDlQj70CmI0dpYWrNSHE2utXKE+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IMzCP+lnmoGfGw9xDy++AP89HP2uIy5T9WfsRukxa7k=;
	b=mVfqHiqhumX0VPfvexamcxNbdE2HuMEprrP8bU+eiPmcpwa7fmptX0SM01dTp36DpHSe
	 9i0fxgmh+7k8fMAmu/BJz5yJ2i77+3YnmK1tayARs70F9NyQop5vOuuUGHs+Bj0ekJmMq
	 x/jO/CfaPkH27PA+GPqRztVPSqJMcRiMl+QYXbFDQtXC4L8k+zLkukXUxWWt0d5KBTmuY
	 0Ud47K8cgrLLj9/2lk0qQxWuIDbnN5qNHcBYDfsg2HYEfgugL22NloSuAkxhG3PGXui3C
	 ca6DKYIS+8+K3kdROdnfMe/KeiWIILFcdAqntiMCzDtWc5DSgn/PfbRn+TYRfdUyQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjxoAu30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64353606A9CB;
	Sat,  7 Nov 2026 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjxoAu30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112651F0089F;
	Sat,  7 Nov 2026 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064033;
	bh=IMzCP+lnmoGfGw9xDy++AP89HP2uIy5T9WfsRukxa7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjxoAu30GUQGYmMGKC9rE4Ci/KjQmXT82Q0RWMzh1k93IhcXsktOK34rokfWBoBs2
	 /gj7Q86rP4tkiUA0uT09YmnOLiMOP1qtnHICjNZ84yD6qEntZ6Ar0WTNz7+rllIDzU
	 dUh67lPDG8zdervml1KpJp+fJP9dedYtQvjzVez0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0206/1257] cpufreq: CPPC: Create the FIE worker before enabling PCC callbacks
Date: Sat,  7 Nov 2026 08:41:42 -0500
Message-ID: <20261107134945.231219176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 995e7d4680706e47154adb68f0b682485ea8d873 ]

cppc_freq_invariance_init() creates the PCC worker only if an online CPU
currently has PCC counters. A shared policy can also initialize an offline
PCC member. When that CPU comes online, its callback queues work through
the missing kworker_fie and dereferences NULL. A later hot-added PCC policy
can encounter the same missing worker.

Create the worker when policy initialization encounters PCC counters,
before initializing their work and publishing any callbacks. Serialize
creation and reuse the worker until driver teardown. This covers offline
policy members and later PCC policies without creating an unused deadline
worker on direct-counter-only systems.

If worker allocation or scheduling setup fails, leave FIE unregistered for
that policy. Keep the global FIE setting unchanged so direct-counter
policies remain independent of worker setup and existing policies still
drain their initialized work during teardown. Publish kworker_fie only
after successful setup, allowing a later policy initialization to retry.

Fixes: 997c021abc6e ("cpufreq: CPPC: Update FIE arch_freq_scale in ticks for non-PCC regs")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-21-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 39 ++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 80893844353ca..5f20c4a7ba2f2 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -18,6 +18,7 @@
 #include <linux/cpufreq.h>
 #include <linux/irq_work.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <uapi/linux/sched/types.h>
@@ -49,10 +50,12 @@ struct cppc_freq_invariance {
 
 static DEFINE_PER_CPU(struct cppc_freq_invariance, cppc_freq_inv);
 static struct kthread_worker *kworker_fie;
+static DEFINE_MUTEX(cppc_fie_lock);
 
 static int cppc_perf_from_fbctrs(u64 reference_perf,
 				 struct cppc_perf_fb_ctrs *fb_ctrs_t0,
 				 struct cppc_perf_fb_ctrs *fb_ctrs_t1);
+static int cppc_fie_kworker_init(void);
 
 /**
  * __cppc_scale_freq_tick - CPPC arch_freq_scale updater for frequency invariance
@@ -161,6 +164,9 @@ static void cppc_cpufreq_cpu_fie_init(struct cpufreq_policy *policy)
 		cppc_fi->cpu = cpu;
 		cppc_fi->cpu_data = policy->driver_data;
 		if (cppc_perf_ctrs_in_pcc_cpu(cpu)) {
+			if (cppc_fie_kworker_init())
+				return;
+
 			kthread_init_work(&cppc_fi->work, cppc_scale_freq_workfn);
 			init_irq_work(&cppc_fi->irq_work, cppc_irq_work);
 			sftd = &cppc_sftd_pcc;
@@ -211,8 +217,9 @@ static void cppc_cpufreq_cpu_fie_exit(struct cpufreq_policy *policy)
 	}
 }
 
-static void cppc_fie_kworker_init(void)
+static int cppc_fie_kworker_init(void)
 {
+	struct kthread_worker *worker;
 	struct sched_attr attr = {
 		.size		= sizeof(struct sched_attr),
 		.sched_policy	= SCHED_DEADLINE,
@@ -228,23 +235,28 @@ static void cppc_fie_kworker_init(void)
 	};
 	int ret;
 
-	kworker_fie = kthread_run_worker(0, "cppc_fie");
-	if (IS_ERR(kworker_fie)) {
+	guard(mutex)(&cppc_fie_lock);
+
+	if (kworker_fie)
+		return 0;
+
+	worker = kthread_run_worker(0, "cppc_fie");
+	if (IS_ERR(worker)) {
 		pr_warn("%s: failed to create kworker_fie: %ld\n", __func__,
-			PTR_ERR(kworker_fie));
-		fie_disabled = FIE_DISABLED;
-		kworker_fie = NULL;
-		return;
+			PTR_ERR(worker));
+		return PTR_ERR(worker);
 	}
 
-	ret = sched_setattr_nocheck(kworker_fie->task, &attr);
+	ret = sched_setattr_nocheck(worker->task, &attr);
 	if (ret) {
 		pr_warn("%s: failed to set SCHED_DEADLINE: %d\n", __func__,
 			ret);
-		kthread_destroy_worker(kworker_fie);
-		fie_disabled = FIE_DISABLED;
-		kworker_fie = NULL;
+		kthread_destroy_worker(worker);
+		return ret;
 	}
+
+	kworker_fie = worker;
+	return 0;
 }
 
 static void __init cppc_freq_invariance_init(void)
@@ -259,11 +271,6 @@ static void __init cppc_freq_invariance_init(void)
 			fie_disabled = FIE_ENABLED;
 		}
 	}
-
-	if (fie_disabled || !perf_ctrs_in_pcc)
-		return;
-
-	cppc_fie_kworker_init();
 }
 
 static void cppc_freq_invariance_exit(void)
-- 
2.53.0



