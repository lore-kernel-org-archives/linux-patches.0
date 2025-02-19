Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE331CCEF0;
	Wed, 19 Feb 2025 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954561; cv=none; b=VG/IJ7idjTVKu7AMaAvM4C2VA3ugq2Fpfzi+mXMTrKIOf7QSuDcYzj1OugUWCg8WZca7dZEZoYoh/LbZhY4qayFnLc+b3/1YaUW0cQmUo13XZfoQC9+zJyFXcDSHrRJd+G9Nvf083chC76D2JY74+o9A2RCFdNMhSdd/YUMBpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954561; c=relaxed/simple;
	bh=CThpesF6pEnoPQqODfiGSfqidFJH7ZxB04FbYdkJqz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9iZKU8d6D5/0LcDwLbtmOCDgXS2sQ084fI4WsGf5rTX4DjgoAS8jLFLlTBRNaRkAmKGsXuIFdMy4i4leZPoMWgNAxx0XPdytmoRnhb4z5G3BA/ZgFp0ci4IYBr9z3BxEvq4CalxOiXDVQyKLLNPLlpa/37l9ea24IJBCSnuwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9+2Zcc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9+2Zcc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09E0C4CED1;
	Wed, 19 Feb 2025 08:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954561;
	bh=CThpesF6pEnoPQqODfiGSfqidFJH7ZxB04FbYdkJqz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9+2Zcc8D2OzJuHJ1ld/qXHQ0qlGhknGeJ7YhXsrdTfSbbARkoULICYxOXuTXV0DF
	 4RpcyjS3xAxYIN4dM/BtlF0yY2TlrdoPIi2JTGHBcT0gt4m27axVdJ2adsbO/+fOz9
	 flFcVZZv2YMWIKqachFNWF5n4qJdMbOcyBxRlHp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 210/274] cpufreq/amd-pstate: Remove the cppc_state check in offline/online functions
Date: Wed, 19 Feb 2025 09:27:44 +0100
Message-ID: <20250219082617.796422818@linuxfoundation.org>
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
index 72c613cba7086..e798420bcb5f9 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1624,10 +1624,8 @@ static int amd_pstate_epp_cpu_online(struct cpufreq_policy *policy)
 
 	pr_debug("AMD CPU Core %d going online\n", cpudata->cpu);
 
-	if (cppc_state == AMD_PSTATE_ACTIVE) {
-		amd_pstate_epp_reenable(cpudata);
-		cpudata->suspended = false;
-	}
+	amd_pstate_epp_reenable(cpudata);
+	cpudata->suspended = false;
 
 	return 0;
 }
@@ -1656,8 +1654,7 @@ static int amd_pstate_epp_cpu_offline(struct cpufreq_policy *policy)
 	if (cpudata->suspended)
 		return 0;
 
-	if (cppc_state == AMD_PSTATE_ACTIVE)
-		amd_pstate_epp_offline(policy);
+	amd_pstate_epp_offline(policy);
 
 	return 0;
 }
-- 
2.39.5



