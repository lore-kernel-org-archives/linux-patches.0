Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717CB1E32D5;
	Wed, 19 Feb 2025 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955242; cv=none; b=QHolgxsT8/qv0lCocL+CbOU01DBQrOEc7jlKAIC9a9x0YnCGksZ1u4C7/vCTi7cBR4MxJcaBgLVhFLKxFh2CIda+gFWxLH+CluWl/+FTw9jKcqe3641CGW5wwY97DU/eFjwxVLWSxQN5VA8HdMzyjArzhheAfrGU3Tj8nWxlvi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955242; c=relaxed/simple;
	bh=klcxPwE+S43xHELbra7lnB5gI+Nt2MDNCVOY9eBkOKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvA/HNvF7gL0FRsXDBm3ay+4dIhivfsad5im8FfLa728jSQ6UFwws67EU9VsiY/zKlT2uLoY7A4sV0LHjASmQrN8jhn8AasG+qSM8EeSMMsAErWjEUqTsGNZrt3CKU/GBGoC+woNCgHgL5h4CrixWPODoU8tkbHtOyaJwrDLyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoNKMy4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoNKMy4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDC2C4CEE8;
	Wed, 19 Feb 2025 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955242;
	bh=klcxPwE+S43xHELbra7lnB5gI+Nt2MDNCVOY9eBkOKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoNKMy4ARppQxPpoTblxDduLIeqVIRs+CKPTHBbPyXynsHuDDRT42DpmzHYhQCYIg
	 Mbg8pejxpvSXTz2oDQ5LTxv4UdKRbq9Kz6ZjeFMKn/a48aaS6/x23pB9HnBTqBJgaL
	 BmnURmZasGA9r9GDI7xQTM/OvqduPOw2uVb/kLEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/230] cpufreq/amd-pstate: Align offline flow of shared memory and MSR based systems
Date: Wed, 19 Feb 2025 09:28:13 +0100
Message-ID: <20250219082608.592511027@linuxfoundation.org>
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

[ Upstream commit a6960e6b1b0e2cb268f427a99040c408a8d10665 ]

Set min_perf to lowest_perf for shared memory systems, similar to the MSR
based systems.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20241023102108.5980-5-Dhananjay.Ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Stable-dep-of: 3ace20038e19 ("cpufreq/amd-pstate: Fix cpufreq_policy ref counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 161334937090c..895d108428b40 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1636,6 +1636,7 @@ static void amd_pstate_epp_offline(struct cpufreq_policy *policy)
 		wrmsrl_on_cpu(cpudata->cpu, MSR_AMD_CPPC_REQ, value);
 	} else {
 		perf_ctrls.desired_perf = 0;
+		perf_ctrls.min_perf = min_perf;
 		perf_ctrls.max_perf = min_perf;
 		cppc_set_perf(cpudata->cpu, &perf_ctrls);
 		perf_ctrls.energy_perf = AMD_CPPC_ENERGY_PERF_PREF(HWP_EPP_BALANCE_POWERSAVE);
-- 
2.39.5



