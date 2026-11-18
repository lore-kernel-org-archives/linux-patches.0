Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040660;
	b=Sp1dw7lNHAxxzl7cymlcnKnNkn4WQYlvyp5sQpTbR9KSIqe8HtDEPLbRl+6LM5A3MGjF
	 t70dT2JJmfycOLADCcCTz6jhdHRiEXKJTs027bMwGPYmd9/IUnzJIm5ciFwBmA5XthXTL
	 hPRZWJAPdIGaKbyFx4knljf7izhy/ixaNJxvRD8LubEg8C93Rov3eVPkSuLMv8ZYLADV3
	 sHkOLj9AdZqWU64954qgd3UeFcyHkLoEmYBydXqJcwFox/yGaPr7axe6M+1PgAyejIiOT
	 DR+Nq+tFxpdOUQCV+ojceAAhYrHzXznpW08eIkICRCmrWLLgKMOq6wzpOTS2AJOkONw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYPu+6AtD5o/k7Ym1995Z3iss7SUxiQ4aEMpXTpQ9Ec=;
	b=zJDqkAbRXw3qSyynK6BjAbv5mINNJav7LLLCKf5oUGFG9Ojcw181QkiXPo7GkR3U5EQA
	 xrIfZ7gmklfXWQEF0YNukWZXEg9vov+XVuVpDpPL2Dow06vbtQgwr9G/vcGZ45AfSfpDY
	 iwB79dZNmt48HJGn7/7WavvLMqknr7KqEUGKIgwT9rdpMa3CGOl/Use2lWaCrld4bsUF1
	 5KXrMA733gJSpo8+g6TTL+ZTCqNtCf0S1Jgz5RMSk/93P2nAuf/gTYyAgL6lSM2iNYTi9
	 pctE/JU8V87FDbX3zdzhfca+bgy2AKyZqRdHknAlNYpy3ld2jccB2J6FwA7gvhw/E1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLMIpFF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C2606A325;
	Wed, 18 Nov 2026 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLMIpFF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD271F000C4;
	Wed, 18 Nov 2026 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040660;
	bh=oYPu+6AtD5o/k7Ym1995Z3iss7SUxiQ4aEMpXTpQ9Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLMIpFF1uua8gvls3RAE73s/AaMI/AL1DOao360+4vVliA0UZT0dRz7ORXDFZ7pxs
	 YMVbkTEPecPnRRHzkZQFfWeRYh0z/2fLCp2F4HtPihLdx5fdG6B7jT11UPAD3n7Nmd
	 HvwEH8m/KiKxToXbhyd7/MJ0KgxJ0aqxhEffvIH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Rui <ray.huang@amd.com>,
	Li Meng <li.meng@amd.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2499/3318] cpufreq: amd-pstate: Unify computation of {max,min,nominal,lowest_nonlinear}_freq
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150436.359403100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 5547c0ebfc2efdab6ee93a7fd4d9c411ad87013e ]

Currently the amd_get_{min, max, nominal, lowest_nonlinear}_freq()
helpers computes the values of min_freq, max_freq, nominal_freq and
lowest_nominal_freq respectively afresh from
cppc_get_perf_caps(). This is not necessary as there are fields in
cpudata to cache these values.

To simplify this, add a single helper function named
amd_pstate_init_freq() which computes all these frequencies at once, and
caches it in cpudata.

Use the cached values everywhere else in the code.

Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Li Meng <li.meng@amd.com>
Tested-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Co-developed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6d3cbc63935 ("cpufreq: amd-pstate: Restore previous mode when changing driver mode fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 126 ++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 67 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 1e4ce11910d73..130e434e8d683 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -623,74 +623,22 @@ static void amd_pstate_adjust_perf(unsigned int cpu,
 
 static int amd_get_min_freq(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_caps cppc_perf;
-
-	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
-	if (ret)
-		return ret;
-
-	/* Switch to khz */
-	return cppc_perf.lowest_freq * 1000;
+	return READ_ONCE(cpudata->min_freq);
 }
 
 static int amd_get_max_freq(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_caps cppc_perf;
-	u32 max_perf, max_freq, nominal_freq, nominal_perf;
-	u64 boost_ratio;
-
-	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
-	if (ret)
-		return ret;
-
-	nominal_freq = cppc_perf.nominal_freq;
-	nominal_perf = READ_ONCE(cpudata->nominal_perf);
-	max_perf = READ_ONCE(cpudata->highest_perf);
-
-	boost_ratio = div_u64(max_perf << SCHED_CAPACITY_SHIFT,
-			      nominal_perf);
-
-	max_freq = nominal_freq * boost_ratio >> SCHED_CAPACITY_SHIFT;
-
-	/* Switch to khz */
-	return max_freq * 1000;
+	return READ_ONCE(cpudata->max_freq);
 }
 
 static int amd_get_nominal_freq(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_caps cppc_perf;
-
-	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
-	if (ret)
-		return ret;
-
-	/* Switch to khz */
-	return cppc_perf.nominal_freq * 1000;
+	return READ_ONCE(cpudata->nominal_freq);
 }
 
 static int amd_get_lowest_nonlinear_freq(struct amd_cpudata *cpudata)
 {
-	struct cppc_perf_caps cppc_perf;
-	u32 lowest_nonlinear_freq, lowest_nonlinear_perf,
-	    nominal_freq, nominal_perf;
-	u64 lowest_nonlinear_ratio;
-
-	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
-	if (ret)
-		return ret;
-
-	nominal_freq = cppc_perf.nominal_freq;
-	nominal_perf = READ_ONCE(cpudata->nominal_perf);
-
-	lowest_nonlinear_perf = cppc_perf.lowest_nonlinear_perf;
-
-	lowest_nonlinear_ratio = div_u64(lowest_nonlinear_perf << SCHED_CAPACITY_SHIFT,
-					 nominal_perf);
-
-	lowest_nonlinear_freq = nominal_freq * lowest_nonlinear_ratio >> SCHED_CAPACITY_SHIFT;
-
-	/* Switch to khz */
-	return lowest_nonlinear_freq * 1000;
+	return READ_ONCE(cpudata->lowest_nonlinear_freq);
 }
 
 static int amd_pstate_set_boost(struct cpufreq_policy *policy, int state)
@@ -845,6 +793,53 @@ static void amd_pstate_update_limits(unsigned int cpu)
 	mutex_unlock(&amd_pstate_driver_lock);
 }
 
+/**
+ * amd_pstate_init_freq: Initialize the max_freq, min_freq,
+ *                       nominal_freq and lowest_nonlinear_freq for
+ *                       the @cpudata object.
+ *
+ *  Requires: highest_perf, lowest_perf, nominal_perf and
+ *            lowest_nonlinear_perf members of @cpudata to be
+ *            initialized.
+ *
+ *  Returns 0 on success, non-zero value on failure.
+ */
+static int amd_pstate_init_freq(struct amd_cpudata *cpudata)
+{
+	int ret;
+	u32 min_freq;
+	u32 highest_perf, max_freq;
+	u32 nominal_perf, nominal_freq;
+	u32 lowest_nonlinear_perf, lowest_nonlinear_freq;
+	u32 boost_ratio, lowest_nonlinear_ratio;
+	struct cppc_perf_caps cppc_perf;
+
+
+	ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
+	if (ret)
+		return ret;
+
+	min_freq = cppc_perf.lowest_freq * 1000;
+	nominal_freq = cppc_perf.nominal_freq;
+	nominal_perf = READ_ONCE(cpudata->nominal_perf);
+
+	highest_perf = READ_ONCE(cpudata->highest_perf);
+	boost_ratio = div_u64(highest_perf << SCHED_CAPACITY_SHIFT, nominal_perf);
+	max_freq = (nominal_freq * boost_ratio >> SCHED_CAPACITY_SHIFT) * 1000;
+
+	lowest_nonlinear_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
+	lowest_nonlinear_ratio = div_u64(lowest_nonlinear_perf << SCHED_CAPACITY_SHIFT,
+					 nominal_perf);
+	lowest_nonlinear_freq = (nominal_freq * lowest_nonlinear_ratio >> SCHED_CAPACITY_SHIFT) * 1000;
+
+	WRITE_ONCE(cpudata->min_freq, min_freq);
+	WRITE_ONCE(cpudata->lowest_nonlinear_freq, lowest_nonlinear_freq);
+	WRITE_ONCE(cpudata->nominal_freq, nominal_freq);
+	WRITE_ONCE(cpudata->max_freq, max_freq);
+
+	return 0;
+}
+
 static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
@@ -872,6 +867,10 @@ static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 	if (ret)
 		goto free_cpudata1;
 
+	ret = amd_pstate_init_freq(cpudata);
+	if (ret)
+		goto free_cpudata1;
+
 	min_freq = amd_get_min_freq(cpudata);
 	max_freq = amd_get_max_freq(cpudata);
 	nominal_freq = amd_get_nominal_freq(cpudata);
@@ -913,13 +912,8 @@ static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 		goto free_cpudata2;
 	}
 
-	/* Initial processor data capability frequencies */
-	cpudata->max_freq = max_freq;
-	cpudata->min_freq = min_freq;
 	cpudata->max_limit_freq = max_freq;
 	cpudata->min_limit_freq = min_freq;
-	cpudata->nominal_freq = nominal_freq;
-	cpudata->lowest_nonlinear_freq = lowest_nonlinear_freq;
 
 	policy->driver_data = cpudata;
 
@@ -1357,6 +1351,10 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	if (ret)
 		goto free_cpudata1;
 
+	ret = amd_pstate_init_freq(cpudata);
+	if (ret)
+		goto free_cpudata1;
+
 	min_freq = amd_get_min_freq(cpudata);
 	max_freq = amd_get_max_freq(cpudata);
 	nominal_freq = amd_get_nominal_freq(cpudata);
@@ -1373,12 +1371,6 @@ static int amd_pstate_epp_cpu_init(struct cpufreq_policy *policy)
 	/* It will be updated by governor */
 	policy->cur = policy->cpuinfo.min_freq;
 
-	/* Initial processor data capability frequencies */
-	cpudata->max_freq = max_freq;
-	cpudata->min_freq = min_freq;
-	cpudata->nominal_freq = nominal_freq;
-	cpudata->lowest_nonlinear_freq = lowest_nonlinear_freq;
-
 	policy->driver_data = cpudata;
 
 	cpudata->epp_cached = amd_pstate_get_epp(cpudata, 0);
-- 
2.53.0



