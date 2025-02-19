Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04591D14FF;
	Wed, 19 Feb 2025 08:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954565; cv=none; b=WcFKXCY0i0svkImyDZkgGjVV0BFiiQMDgiuvvLth5SEgQi7Bkg+9Og8YhJ8ZruRTBWFjXhi2hyGwb0AKMF+MKLNzlNC1nHjPmZnuQWTucqDqj1dedJnQ6gIlCXXDIeptBY527PV9naNjudeercZIV28hCtSfZlswnImyX9akSKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954565; c=relaxed/simple;
	bh=mR++73jrUf2L727L7WEEuWu7sYWj6B63yXVw7krEQQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz2oo4uswLGWLQeRT4WQrxoh1XmI9kf+lYIJ94RvpfU/MX6DLRFBtMCY1xSrUTFQ9StFVINBDVA1/ievgUVgIZ+sGiKX7GOwAMJLFqT9RBzb12GU2vdcCs9J7hH+pxoKl2ZgreAhSMfj3oNbKB4APq0y9qpKWKVmbQs8FmaseWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUkiNN28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUkiNN28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFE3C4CED1;
	Wed, 19 Feb 2025 08:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954564;
	bh=mR++73jrUf2L727L7WEEuWu7sYWj6B63yXVw7krEQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUkiNN28fXkd+mpOvDW0nfYfeVREBx22oBTaJypalqdJICC87zG1MKX9rhQgQ6hHL
	 GdhGN0ufHgfZM8UuYD4fz1AXpHRciuqU/fi8CEtLYFD/xKfg77aafSw/Msuj9WfHR5
	 7dCVrRBiaKRziHxr+gM91eruuSq8qPRL3kPEttm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 211/274] cpufreq/amd-pstate: Merge amd_pstate_epp_cpu_offline() and amd_pstate_epp_offline()
Date: Wed, 19 Feb 2025 09:27:45 +0100
Message-ID: <20250219082617.835111506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 53ec2101dfede8fecdd240662281a12e537c3411 ]

amd_pstate_epp_offline() is only called from within
amd_pstate_epp_cpu_offline() and doesn't make much sense to have it at all.
Hence, remove it.

Also remove the unncessary debug print in the offline path while at it.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241204144842.164178-6-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index e798420bcb5f9..03a5fd713ad59 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1630,11 +1630,14 @@ static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static void amd_pstate_epp_offline(struct cpufreq_policy *policy)
+static int amd_pstate_epp_cpu_offline(struct cpufreq_policy *policy)
 {
 	struct amd_cpudata *cpudata = policy->driver_data;
 	int min_perf;
 
+	if (cpudata->suspended)
+		return 0;
+
 	min_perf = READ_ONCE(cpudata->lowest_perf);
 
 	mutex_lock(&amd_pstate_limits_lock);
@@ -1643,18 +1646,6 @@ static void amd_pstate_epp_offline(struct cpufreq_policy *policy)
 	amd_pstate_set_epp(cpudata, AMD_CPPC_EPP_BALANCE_POWERSAVE);
 
 	mutex_unlock(&amd_pstate_limits_lock);
-}
-
-static int amd_pstate_epp_cpu_offline(struct cpufreq_policy *policy)
-{
-	struct amd_cpudata *cpudata = policy->driver_data;
-
-	pr_debug("AMD CPU Core %d going offline\n", cpudata->cpu);
-
-	if (cpudata->suspended)
-		return 0;
-
-	amd_pstate_epp_offline(policy);
 
 	return 0;
 }
-- 
2.39.5



