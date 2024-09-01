Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79D183CB5;
	Sun,  1 Sep 2024 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207941; cv=none; b=BR6w1vXbaelWC6jQgZA1IGU2YqvNACUuSLxRhVF53yb9KRoXp2TGEwh/C/zvd6/+6o1osDk8AcC8r0U+d06odP/BQfyvjxZDAh9/39XoscXzFENxCmK/PEPMojvV7FIzMPehzSirbJVlhrgjDupVaCiquKLb3JtASyEiUMZVX/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207941; c=relaxed/simple;
	bh=g8837ZwzQzIrx8Srmx6LFAhgoVOQJtmrhgiX+Id/6Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdhO3wySoeA2h2LuUqVjY24FXu2/w8NajGw/cypfv0XUiyCFyei0gT377dJJ5wlfE8wfHTLim1qG+u1YNZWX/yPiP1Vr2zxzBl71GNaW/Hlz7tNZ2PijJ+tnGeZY8GZV2GpQJev/x/TEkwmNKPc1V7caZuWxB+tBtktMVVoY6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypVC5JKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypVC5JKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8981EC4CEC3;
	Sun,  1 Sep 2024 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207941;
	bh=g8837ZwzQzIrx8Srmx6LFAhgoVOQJtmrhgiX+Id/6Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypVC5JKsUa48GkgkT1/mXSMcjbHNSLsVZHzTx9OExOFnwVvRpYJShmjmAFT2Uway8
	 8SmkvFaPzeCQDmLz0D/bjbjk/FRvhl86dZULFLXCCZ6a+0m7y3osgGiCjAwCMajQrn
	 65VY1EPoWHvOHw/lhWFQJPLZpwfy9IYLiidxz6R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 24/93] drm/amdgpu: align pp_power_profile_mode with kernel docs
Date: Sun,  1 Sep 2024 18:16:11 +0200
Message-ID: <20240901160808.268839079@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8f614469de248a4bc55fb07e55d5f4c340c75b11 upstream.

The kernel doc says you need to select manual mode to
adjust this, but the code only allows you to adjust it when
manual mode is not selected.  Remove the manual mode check.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bbb05f8a9cd87f5046d05a0c596fddfb714ee457)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1882,8 +1882,7 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -1960,8 +1959,7 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;


