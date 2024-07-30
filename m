Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824D718C912;
	Tue, 30 Jul 2024 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356307; cv=none; b=bhH5HMkF5l85QfPc3lzW4Wh9LbuLLqUhk7DVZlNzF1zlFEAQ4uwEeghqfs/fkLtloSfyaRcQ5g/cCB/6jnauF+awywQbMn8YDGYe6fbiJUv1gXcvyKXaCsfJKeBYMufeudnFZuXUFdxL0vb/9gX99Pk4NfIoSLz2zjPDSdsVf08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356307; c=relaxed/simple;
	bh=v9RaenV3Ign2pj5RDixLrmocTgJlNJZrBWoxNPu+xuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWD1xz1ahOCSA6IfvlIX1hBzzY3OzxpNqTFJCQyYTvvsfKAGoKJXfjbsJXuSTvC0g6MRtT1l0sAFDpWG59tPrx05HV1Vd5Cmr50L7cbK+spwUthfBOMdUBQlMo6uW4ou9gzKklNmd04jyp6gokHqp3Gid6CK6XGiDhSTeTAi+pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHnzYpeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHnzYpeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C3BC32782;
	Tue, 30 Jul 2024 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356307;
	bh=v9RaenV3Ign2pj5RDixLrmocTgJlNJZrBWoxNPu+xuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHnzYpeWx8oHxkETm81lqA9cHBLprgDvdev38ADZ3vLm9W2fOH2CIrjqF1bWJTzgK
	 Pdt1AU7kJJAGIvBpgJctuFx1JAPS6BQ7RFfPVhK9CtYINxkHAKPI9a8ZbUthd3EJ8x
	 orlCS+z0TSj/uf3H1P747Tc7McQIispwfstOwyhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 138/809] cpufreq/amd-pstate-ut: Convert nominal_freq to khz during comparisons
Date: Tue, 30 Jul 2024 17:40:14 +0200
Message-ID: <20240730151730.062197274@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit f21ab5ed4e8758b06230900f44b9dcbcfdc0c3ae ]

cpudata->nominal_freq being in MHz whereas other frequencies being in
KHz breaks the amd-pstate-ut frequency sanity check. This fixes it.

Fixes: e4731baaf294 ("cpufreq: amd-pstate: Fix the inconsistency in max frequency units")
Reported-by: David Arcari <darcari@redhat.com>
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20240702081413.5688-2-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate-ut.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index fc275d41d51e9..66b73c308ce67 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -202,6 +202,7 @@ static void amd_pstate_ut_check_freq(u32 index)
 	int cpu = 0;
 	struct cpufreq_policy *policy = NULL;
 	struct amd_cpudata *cpudata = NULL;
+	u32 nominal_freq_khz;
 
 	for_each_possible_cpu(cpu) {
 		policy = cpufreq_cpu_get(cpu);
@@ -209,13 +210,14 @@ static void amd_pstate_ut_check_freq(u32 index)
 			break;
 		cpudata = policy->driver_data;
 
-		if (!((cpudata->max_freq >= cpudata->nominal_freq) &&
-			(cpudata->nominal_freq > cpudata->lowest_nonlinear_freq) &&
+		nominal_freq_khz = cpudata->nominal_freq*1000;
+		if (!((cpudata->max_freq >= nominal_freq_khz) &&
+			(nominal_freq_khz > cpudata->lowest_nonlinear_freq) &&
 			(cpudata->lowest_nonlinear_freq > cpudata->min_freq) &&
 			(cpudata->min_freq > 0))) {
 			amd_pstate_ut_cases[index].result = AMD_PSTATE_UT_RESULT_FAIL;
 			pr_err("%s cpu%d max=%d >= nominal=%d > lowest_nonlinear=%d > min=%d > 0, the formula is incorrect!\n",
-				__func__, cpu, cpudata->max_freq, cpudata->nominal_freq,
+				__func__, cpu, cpudata->max_freq, nominal_freq_khz,
 				cpudata->lowest_nonlinear_freq, cpudata->min_freq);
 			goto skip_test;
 		}
@@ -229,13 +231,13 @@ static void amd_pstate_ut_check_freq(u32 index)
 
 		if (cpudata->boost_supported) {
 			if ((policy->max == cpudata->max_freq) ||
-					(policy->max == cpudata->nominal_freq))
+					(policy->max == nominal_freq_khz))
 				amd_pstate_ut_cases[index].result = AMD_PSTATE_UT_RESULT_PASS;
 			else {
 				amd_pstate_ut_cases[index].result = AMD_PSTATE_UT_RESULT_FAIL;
 				pr_err("%s cpu%d policy_max=%d should be equal cpu_max=%d or cpu_nominal=%d !\n",
 					__func__, cpu, policy->max, cpudata->max_freq,
-					cpudata->nominal_freq);
+					nominal_freq_khz);
 				goto skip_test;
 			}
 		} else {
-- 
2.43.0



