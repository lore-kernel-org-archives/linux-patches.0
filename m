Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18802E06E4;
	Sat, 12 Sep 2026 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216161; cv=none; b=iTsgZoszsK18xf2t+L3jP9Blag74JWvYVG0b31cue1kvGZ9jLnQP/SSxfGicQ0+E285oHJomf8MRKMnxGQnWFvYKAn77f2qUA8uiVwr1d8nf3tzMxvq1JuYBlVEbh2UZHNwmBoF2n8gnmA9meyi2JLWP/qjA6EsSGLqHpAn72NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216161; c=relaxed/simple;
	bh=lTr6WqJBUQYWoPijHATEK4nWHNPtGmlBKYb39ye6IVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg0hixd23taji8lSlNFcqIMcgeGppxLx+EXiBikNFA+QvfPwO6O85lXFGLPhQ6oLWStfX7JJxNhOFLP8tXnzsN57luT/Ng2j3MPJr59hp0bT4BGBoyo4CxPEcAwNg7ihyW3hGWBDceX3xPdZskfde+tECKD9vpSPp1Yp2BrfnGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pSPPeX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pSPPeX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004C31F000FF;
	Sat, 12 Sep 2026 12:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216159;
	bh=Qv5rgaQPmROgcz0oxzIsYeDVUIY8UYdiImR2n0cl3hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pSPPeX12xBA3EBXx6BjPhqQMPnW2a+51oYwapTFNQo3Z02x8JG8Xi6/c6fmrNdiK
	 OwcUtvlYJnKSeaF9FGG9ZwlAljsgQFruiC+vUCygVP7VrjeZj3RLmHrkRPdNEgX/v1
	 TUh+CmRfGeXMmisgmIsA9gRXoP4cjKpgVO195EMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0653/1376] cpufreq/amd-pstate: Store the boost numerator as highest perf again
Date: Sat, 12 Sep 2026 08:51:19 +0200
Message-ID: <20260912065622.097136645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 50a062a7620051c09adacd6d140ebd56881a333b ]

commit ad4caad58d91d ("cpufreq: amd-pstate: Merge
amd_pstate_highest_perf_set() into amd_get_boost_ratio_numerator()")
changed the semantics for highest perf and commit 18d9b52271213
("cpufreq/amd-pstate: Use nominal perf for limits when boost is disabled")
worked around those semantic changes.

This however is a confusing result and furthermore makes it awkward to
change frequency limits and boost due to the scaling differences. Restore
the boost numerator to highest perf again.

Suggested-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Fixes: ad4caad58d91 ("cpufreq: amd-pstate: Merge amd_pstate_highest_perf_set() into amd_get_boost_ratio_numerator()")
Link: https://lore.kernel.org/r/20241209185248.16301-2-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/amd-pstate.rst |  4 +---
 drivers/cpufreq/amd-pstate.c                | 25 ++++++++++++---------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
index 210a808b74ec2..412423c54f258 100644
--- a/Documentation/admin-guide/pm/amd-pstate.rst
+++ b/Documentation/admin-guide/pm/amd-pstate.rst
@@ -251,9 +251,7 @@ performance supported in `AMD CPPC Performance Capability <perf_cap_>`_).
 In some ASICs, the highest CPPC performance is not the one in the ``_CPC``
 table, so we need to expose it to sysfs. If boost is not active, but
 still supported, this maximum frequency will be larger than the one in
-``cpuinfo``. On systems that support preferred core, the driver will have
-different values for some cores than others and this will reflect the values
-advertised by the platform at bootup.
+``cpuinfo``.
 This attribute is read-only.
 
 ``amd_pstate_lowest_nonlinear_freq``
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index c0e073b0425ec..de687d073b7b2 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -368,15 +368,19 @@ static inline int amd_pstate_enable(bool enable)
 
 static int pstate_init_perf(struct amd_cpudata *cpudata)
 {
-	u64 cap1;
+	u64 cap1, numerator;
 
 	int ret = rdmsrl_safe_on_cpu(cpudata->cpu, MSR_AMD_CPPC_CAP1,
 				     &cap1);
 	if (ret)
 		return ret;
 
-	WRITE_ONCE(cpudata->highest_perf, AMD_CPPC_HIGHEST_PERF(cap1));
-	WRITE_ONCE(cpudata->max_limit_perf, AMD_CPPC_HIGHEST_PERF(cap1));
+	ret = amd_get_boost_ratio_numerator(cpudata->cpu, &numerator);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(cpudata->highest_perf, numerator);
+	WRITE_ONCE(cpudata->max_limit_perf, numerator);
 	WRITE_ONCE(cpudata->nominal_perf, AMD_CPPC_NOMINAL_PERF(cap1));
 	WRITE_ONCE(cpudata->lowest_nonlinear_perf, AMD_CPPC_LOWNONLIN_PERF(cap1));
 	WRITE_ONCE(cpudata->lowest_perf, AMD_CPPC_LOWEST_PERF(cap1));
@@ -388,13 +392,18 @@ static int pstate_init_perf(struct amd_cpudata *cpudata)
 static int cppc_init_perf(struct amd_cpudata *cpudata)
 {
 	struct cppc_perf_caps cppc_perf;
+	u64 numerator;
 
 	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
 	if (ret)
 		return ret;
 
-	WRITE_ONCE(cpudata->highest_perf, cppc_perf.highest_perf);
-	WRITE_ONCE(cpudata->max_limit_perf, cppc_perf.highest_perf);
+	ret = amd_get_boost_ratio_numerator(cpudata->cpu, &numerator);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(cpudata->highest_perf, numerator);
+	WRITE_ONCE(cpudata->max_limit_perf, numerator);
 	WRITE_ONCE(cpudata->nominal_perf, cppc_perf.nominal_perf);
 	WRITE_ONCE(cpudata->lowest_nonlinear_perf,
 		   cppc_perf.lowest_nonlinear_perf);
@@ -867,7 +876,6 @@ static int amd_pstate_init_freq(struct amd_cpudata *cpudata)
 {
 	int ret;
 	u32 min_freq, max_freq;
-	u64 numerator;
 	u32 nominal_perf, nominal_freq;
 	u32 lowest_nonlinear_perf, lowest_nonlinear_freq;
 	u32 boost_ratio, lowest_nonlinear_ratio;
@@ -889,10 +897,7 @@ static int amd_pstate_init_freq(struct amd_cpudata *cpudata)
 
 	nominal_perf = READ_ONCE(cpudata->nominal_perf);
 
-	ret = amd_get_boost_ratio_numerator(cpudata->cpu, &numerator);
-	if (ret)
-		return ret;
-	boost_ratio = div_u64(numerator << SCHED_CAPACITY_SHIFT, nominal_perf);
+	boost_ratio = div_u64(cpudata->highest_perf << SCHED_CAPACITY_SHIFT, nominal_perf);
 	max_freq = (nominal_freq * boost_ratio >> SCHED_CAPACITY_SHIFT) * 1000;
 
 	lowest_nonlinear_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
-- 
2.53.0



