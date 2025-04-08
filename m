Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0936F1FBCB2;
	Tue,  8 Apr 2025 11:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110311; cv=none; b=he663X23inv28AVp9cxU5pYDMLeX25f3EPyA5egiHwQIrSjpr55lbFcTd/niPcU6Nh5KH94dRkRFLZkRJD+fVZvv3Xqts5qqTNJsmnWUp2JMQYCt1Koo3hOmS3tu2CxblAL7HH0yt1SvSvO13BxzS3gxQuAOHh0D0qeN3YvQwws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110311; c=relaxed/simple;
	bh=M7CjSC9iBIOA+hdwN9SVIgNzpn5CnBdHrE6DrCQTCrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id9BfUIvi0VJ0277XaLY6y1UIgWh6+ksRf3p5Dl3rV92scZnuSDD/5IBYq9ErmjiIULnVki878eBbwvKE+7nbeOwAYpU+9kehiYsctEgiQDJa3no1LR/1gH1Ktl6LxT1YP1p/NxHJcMm4qvJqJskLCXfaLzig96aCbcM9wBltjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIv//Bua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIv//Bua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D436C4CEE5;
	Tue,  8 Apr 2025 11:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110310;
	bh=M7CjSC9iBIOA+hdwN9SVIgNzpn5CnBdHrE6DrCQTCrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIv//BuaWYJatqt/Md/uvcMLKDk0cuXTCuJMUkW5X+j9s1bxXANo5mcEmkoSwS0nX
	 SJL3SOAQe07e/CQh2JWnwiJJ8T8FZdfEMBY7JlCm/IU80fAjsFAPYMYod3VxwfJx1z
	 l3pE4KuTW5JXaj6YAa7I3F0vaEJG/HthcM/TsFnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 018/731] cpufreq/amd-pstate: Pass min/max_limit_perf as min/max_perf to amd_pstate_update
Date: Tue,  8 Apr 2025 12:38:35 +0200
Message-ID: <20250408104914.686750753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

[ Upstream commit e9869c836b2a460c48e2d69ae79d786303dbffda ]

Currently, amd_pstate_update_freq passes the hardware perf limits as
min/max_perf to amd_pstate_update, which eventually gets programmed into
the min/max_perf fields of the CPPC_REQ register.

Instead pass the effective perf limits i.e. min/max_limit_perf values to
amd_pstate_update as min/max_perf.

Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-6-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 426db24d4db2 ("cpufreq/amd-pstate: Add missing NULL ptr check in amd_pstate_update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 17595a2454e1c..3ef10aae0502f 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -615,7 +615,7 @@ static int amd_pstate_update_freq(struct cpufreq_policy *policy,
 {
 	struct cpufreq_freqs freqs;
 	struct amd_cpudata *cpudata = policy->driver_data;
-	unsigned long max_perf, min_perf, des_perf, cap_perf;
+	unsigned long des_perf, cap_perf;
 
 	if (!cpudata->max_freq)
 		return -ENODEV;
@@ -624,8 +624,6 @@ static int amd_pstate_update_freq(struct cpufreq_policy *policy,
 		amd_pstate_update_min_max_limit(policy);
 
 	cap_perf = READ_ONCE(cpudata->highest_perf);
-	min_perf = READ_ONCE(cpudata->lowest_perf);
-	max_perf = cap_perf;
 
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
@@ -642,8 +640,9 @@ static int amd_pstate_update_freq(struct cpufreq_policy *policy,
 	if (!fast_switch)
 		cpufreq_freq_transition_begin(policy, &freqs);
 
-	amd_pstate_update(cpudata, min_perf, des_perf,
-			max_perf, fast_switch, policy->governor->flags);
+	amd_pstate_update(cpudata, cpudata->min_limit_perf, des_perf,
+			  cpudata->max_limit_perf, fast_switch,
+			  policy->governor->flags);
 
 	if (!fast_switch)
 		cpufreq_freq_transition_end(policy, &freqs, false);
-- 
2.39.5



