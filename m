Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353811E32D5;
	Wed, 19 Feb 2025 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955248; cv=none; b=RiLXpsFgn9dU7feNuIVWIiK3TXqJw9/Lht93IQRKwn4Rgff0wmbp3LXDUbSjjChUtE5rRHF05wHoO47UBGWGMBYstHCwlAjtck1O/IGLI2zs6+PCk1XNh0GpMDLl/MhOfxRfuGpEPQ4pvfP5sjumcykKC6heGuyhPYqbvRY1gV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955248; c=relaxed/simple;
	bh=P4OWxwxZ/jm4ls8gPzg4Q0/Ea69CrPrXmfX9y4L7w+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQyUHVrti/fqsqI0+sdpbEPo0Kt9ST3GUlLlaalPJXh73hHwW8fEleqMWDs61wR4nIB5xyh2X/ON23hx296GWGMe4dNxXqohe+TzH2U3Tc38r4EWVhdFWyWXLk0dZOsFXEmK5fm8i+GvWEPyxgNN50myUEES+Q8tDMKJkcTNt/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyM8Pm4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyM8Pm4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CB2C4CED1;
	Wed, 19 Feb 2025 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955248;
	bh=P4OWxwxZ/jm4ls8gPzg4Q0/Ea69CrPrXmfX9y4L7w+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyM8Pm4/tW0lBuuOf26jGdBsrhXD1riCZPQA9S0W+zc7d+DjaX3fN3jY2AiOsSFd4
	 acGUVLWdl6t/X4rwJ3KjpTrPZm/O6FNQSkrbxX5tlR8IiuwK0tJ6bHChrLNl4H29Iz
	 Ocw2uAmF+iDUkD3hRKg11SSnGjA5nhumffdP7BSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/230] cpufreq/amd-pstate: Remove the cppc_state check in offline/online functions
Date: Wed, 19 Feb 2025 09:28:15 +0100
Message-ID: <20250219082608.667968705@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit b78f8c87ec3e7499bb049986838636d3afbc7ece ]

Only amd_pstate_epp driver (i.e. cppc_state = ACTIVE) enters the
amd_pstate_epp_offline() and amd_pstate_epp_cpu_online() functions,
so remove the unnecessary if condition checking if cppc_state is
equal to AMD_PSTATE_ACTIVE.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241204144842.164178-5-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 19906141ef7fe..4dfe5bdcb2932 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1598,10 +1598,8 @@ static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
 
 	pr_debug("AMD CPU Core %d going online\n", cpudata->cpu);
 
-	if (cppc_state == AMD_PSTATE_ACTIVE) {
-		amd_pstate_epp_reenable(cpudata);
-		cpudata->suspended = false;
-	}
+	amd_pstate_epp_reenable(cpudata);
+	cpudata->suspended = false;
 
 	return 0;
 }
@@ -1630,8 +1628,7 @@ static int amd_pstate_epp_cpu_offline(struct cpufreq_policy *policy)
 	if (cpudata->suspended)
 		return 0;
 
-	if (cppc_state == AMD_PSTATE_ACTIVE)
-		amd_pstate_epp_offline(policy);
+	amd_pstate_epp_offline(policy);
 
 	return 0;
 }
-- 
2.39.5



