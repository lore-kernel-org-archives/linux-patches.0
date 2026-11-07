Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062877;
	b=kSDQNVSaOB7XuqvWOWBha9aiHkA728oBww6Zi5HCGHRYt9kw31uvT+PTkQhuJIw/lHL4
	 IL+qdrjxUatLSMCkgUD7FW8UO/aSxCjaOIfkqtjtYlysKBj0Ov71Ax2+NJ3sT4PIKcWRw
	 G6aJ9k6PK8MAHXNce07HQUPxc/o9wzXCReulJkw1yq8qHrL/DL3hluGZajHdgWvqVCOVJ
	 fu4437oQOm1qppCUKAIzFvPmIeIe6CJVuZ6F+GLMrfHIYDcQjwpl+Rr0kTxQmmPQcspR4
	 Vwbp85jpVOoH4GEqXJgnETXLond//c0/pASyKBoR6Z5CL8ASvdEZH5B0Bs9LB373G3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vAJLn9l1IDK95Swaw3OyqQRAMHaFjMpF01y5dH2ocwE=;
	b=QZ7QDvbGvSP+3JaeBHhPYMicyibYyTejsVJVD3nOF3EIWmrPQ1SSyCT3nUs1R/AZiqHg
	 dXf2/TWKQGeTeKT7NGERF4MHPqzPq9TKr4QLs5eZEUEHJgG1+VoIco2H2tK/KVgGzMGvv
	 qkr9MAcXzI5IX7phSawtEn/FDOAuUV0p5r4O4ddciMOAqYQnPrPJ1v8GITUCEN8p5b9X4
	 SQ2itkqg1PlVBJBQxKuTZsW4btSw75QXB0RsFsw84l5XV3Tnn11nQDJvm+J0XZ39bquk2
	 +PJ/1IdzaAmlR+Vtq5B9i0Ia5I9HCDpih51Qf+gNOUF5mHzarKc7j+Q70MBfTUlyEwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3RuPrtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2994606A32F;
	Sat,  7 Nov 2026 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3RuPrtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A691F0089F;
	Sat,  7 Nov 2026 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062876;
	bh=vAJLn9l1IDK95Swaw3OyqQRAMHaFjMpF01y5dH2ocwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3RuPrtSmX2ds71uwp5Cdo5r23Bd4yKk3WpT2K4jSmWdz/KNrPvAtw/K3iELPxWSY
	 g+P7GIQhssjrtm0zNczVOjnOPwnkauaqh8cbDl991Sfn4U1FGMSyFdrzYNpcBedBb8
	 xgX1uqh/qn38MzZQ26jDPbTtoL0nV0kl0RC3oGzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Haiyang <luo.haiyang@zte.com.cn>,
	Run Zhang <zhang.run@zte.com.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/869] cpufreq: conservative: Restrict deferred downscaling to low load
Date: Sat,  7 Nov 2026 08:47:21 -0500
Message-ID: <20261107134857.682006044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengming Hu <hu.shengming@zte.com.cn>

[ Upstream commit 0fa55c5539173bceaeb400c69b1974aaa0cdb8dc ]

For a shared cpufreq policy, dbs_update() derives the load used for the
frequency decision from the maximum load among its CPUs, but it may
also record deferred idle periods accumulated by an idle CPU in the
policy.

Consequently, a single update can contain both a high decision load
from one CPU and multiple deferred idle periods from another CPU. The
conservative governor applies the deferred down steps before evaluating
the decision load. If that load subsequently triggers an up step, the
deferred down steps can outweigh the single up step and produce a net
frequency reduction.

This was observed on a policy shared by CPUs 2 and 3. A CPU-bound
SCHED_EXT task kept CPU 2 fully utilized while CPU 3 remained idle.
On this system, SCHED_EXT generated update-util callbacks less
frequently than CFS, resulting in sparse DBS updates such as:

 load=100 idle_periods=7 interval=59 ms
 load=100 idle_periods=4 interval=39 ms
 load=100 idle_periods=2 interval=19 ms
 load=100 idle_periods=7 interval=59 ms

With the default 5% frequency step and a 2.6 GHz policy maximum, seven
deferred periods reduce the requested frequency by seven 130 MHz steps
before the high decision load adds only one step. Repeated updates
therefore keep the policy near 530 MHz even though CPU 2 is fully
utilized.

There are two load values relevant to this behavior:

  * sample_load is calculated from the busy and elapsed time of the
    current sample.

  * decision_load is returned by dbs_update() for the governor's
    frequency decision. After a long idle interval, it may reuse
    prev_load to improve the response to a waking task and can therefore
    differ from sample_load.

The problem is that idle_periods is derived from accumulated idle time
and is applied independently of whether the current sample load is in
the conservative governor's downscaling region. A high sample load and
multiple deferred idle periods can therefore coexist, particularly
when updates are sparse.

As suggested by Zhongqiu Han, calculate the sample load separately from
the decision load. If no time has elapsed, use prev_load for the sample
load as the existing load calculation does, since no load can be
calculated for that interval.

Record the maximum sample load for the policy and apply deferred down
steps only when it is below down_threshold. This makes deferred
downscaling follow the same threshold that the conservative governor
normally uses to determine whether the policy load is low enough to
reduce the frequency.

The existing code applies deferred down steps whenever idle_periods is
valid, regardless of the sample load. When the decision load is in the
hold region, the locally adjusted frequency is not submitted unless
another frequency-update branch is taken. Thus, when the sample and
decision loads are the same and both are in the hold region, this
change does not alter the requested frequency.

The difference becomes visible when the decision load causes a
frequency update. In particular, if it exceeds up_threshold, the
governor applies a single up step after the deferred down steps and
submits the resulting request. Multiple deferred down steps can then
outweigh that up step and cause a frequency reduction even when the
sample load is above down_threshold.

With this change, deferred down steps are skipped whenever the maximum
sample load is at or above down_threshold, keeping deferred downscaling
consistent with the conservative governor's threshold semantics. The
requested frequency may therefore be higher than with the existing
behavior when deferred idle periods are present and the decision load
causes a frequency update. This is intentional, because the lower
request previously resulted from applying deferred downscaling while
the sampled policy load was outside the governor's downscaling region.
Accelerated deferred downscaling remains available when the policy
sample load is below down_threshold, including after a workload has
completed and the policy has become idle.

Fixes: 00bfe05889e9 ("cpufreq: conservative: Decrease frequency faster for deferred updates")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Luo Haiyang <luo.haiyang@zte.com.cn>
Reviewed-by: Run Zhang <zhang.run@zte.com.cn>
Suggested-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Link: https://patch.msgid.link/20260916140926740-DCokXh6dAgtqDn1EWdCh@zte.com.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_conservative.c |  8 ++++---
 drivers/cpufreq/cpufreq_governor.c     | 29 +++++++++++++++++++-------
 drivers/cpufreq/cpufreq_governor.h     |  2 ++
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 60bab2b71b1b9..4ee6990ab2ba9 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -85,10 +85,12 @@ static unsigned int cs_dbs_update(struct cpufreq_policy *policy)
 	freq_step = get_freq_step(cs_tuners, policy);
 
 	/*
-	 * Decrease requested_freq one freq_step for each idle period that
-	 * we didn't update the frequency.
+	 * Apply deferred down steps only when the policy sample load is
+	 * below down_threshold. Otherwise, multiple deferred down steps may
+	 * cause a net frequency decrease outside the downscaling region.
 	 */
-	if (policy_dbs->idle_periods < UINT_MAX) {
+	if (policy_dbs->max_sample_load < cs_tuners->down_threshold &&
+	    policy_dbs->idle_periods < UINT_MAX) {
 		unsigned int freq_steps = policy_dbs->idle_periods * freq_step;
 
 		if (requested_freq > policy->min + freq_steps)
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 00a26fa6292c5..a10cf44600ffa 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -116,7 +116,8 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 	struct policy_dbs_info *policy_dbs = policy->governor_data;
 	struct dbs_data *dbs_data = policy_dbs->dbs_data;
 	unsigned int ignore_nice = dbs_data->ignore_nice_load;
-	unsigned int max_load = 0, idle_periods = UINT_MAX;
+	unsigned int max_load = 0, max_sample_load = 0;
+	unsigned int idle_periods = UINT_MAX;
 	unsigned int sampling_rate, io_busy, j;
 
 	/*
@@ -138,7 +139,7 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 		struct cpu_dbs_info *j_cdbs = &per_cpu(cpu_dbs, j);
 		u64 update_time, cur_idle_time;
 		unsigned int idle_time, time_elapsed;
-		unsigned int load;
+		unsigned int load, sample_load;
 
 		cur_idle_time = get_cpu_idle_time(j, &update_time, io_busy);
 
@@ -171,6 +172,20 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 			j_cdbs->prev_cpu_nice = cur_nice;
 		}
 
+		/*
+		 * Compute the sample load separately from the prev_load value
+		 * that may be reused after a long idle interval. The conservative
+		 * governor uses it to decide whether to apply deferred down steps.
+		 * If no time has elapsed, retain the existing behavior and use
+		 * prev_load.
+		 */
+		if (unlikely(!time_elapsed))
+			sample_load = j_cdbs->prev_load;
+		else if (time_elapsed > idle_time)
+			sample_load = 100 * (time_elapsed - idle_time) / time_elapsed;
+		else
+			sample_load = 0;
+
 		if (unlikely(!time_elapsed)) {
 			/*
 			 * That can only happen when this function is called
@@ -205,11 +220,7 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 			load = j_cdbs->prev_load;
 			j_cdbs->prev_load = 0;
 		} else {
-			if (time_elapsed > idle_time)
-				load = 100 * (time_elapsed - idle_time) / time_elapsed;
-			else
-				load = 0;
-
+			load = sample_load;
 			j_cdbs->prev_load = load;
 		}
 
@@ -222,9 +233,13 @@ unsigned int dbs_update(struct cpufreq_policy *policy)
 
 		if (load > max_load)
 			max_load = load;
+
+		if (sample_load > max_sample_load)
+			max_sample_load = sample_load;
 	}
 
 	policy_dbs->idle_periods = idle_periods;
+	policy_dbs->max_sample_load = max_sample_load;
 
 	return max_load;
 }
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 1462d59277bd1..ceb33336b2b30 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -94,6 +94,8 @@ struct policy_dbs_info {
 	/* Multiplier for increasing sample delay temporarily. */
 	unsigned int rate_mult;
 	unsigned int idle_periods;	/* For conservative */
+	/* Maximum load from the current policy sample. */
+	unsigned int max_sample_load;
 	/* Status indicators */
 	bool is_shared;		/* This object is used by multiple CPUs */
 	bool work_in_progress;	/* Work is being queued up or in progress */
-- 
2.53.0



