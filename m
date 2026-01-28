Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45611D5141;
	Wed, 28 Jan 2026 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615848; cv=none; b=U0p9Mk97u4Vuutq1iaNLGV51A3gVezRYFdbUOIHS9OEaSTHBKLtqJ/xn80MlcaXjtaRksExX0d4omwPaLzXlMao/nySYc6Gn+zem1MpvoO7+gbI58xgqF0d8f7s45BcTMH83EdZkWWNXWYoeK9HvNMTFzhnP2Kp/eadNPDM3fDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615848; c=relaxed/simple;
	bh=/cVoWftE+QggKx5KDIQOutNreJujt+ZF11d80CeZUWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOB1+9RoNTE/d9Kw9Hg246/Pe7UkMrY6+d9ep6B+dKI+NzHaThGLWdhY7/dl1SWKcUpdR66LA9avZkOWmGgqkhmR5TzuoyEeVy0hh4xjCtcd3PTkMPh+sf/rZKrsuFxI+RLQpyohmf1wg46MUt9fcEYKvw/JXbX3CLqUK5bckwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYHJjh3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYHJjh3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B0FC4CEF1;
	Wed, 28 Jan 2026 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615848;
	bh=/cVoWftE+QggKx5KDIQOutNreJujt+ZF11d80CeZUWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYHJjh3VrHwsxKdmzsiH7jKTHHQahs5xk56cnSZS+OCsfoccOqHRfNvNPpp7jMQ7r
	 fXxqX8EC1mSzHY2URHjJl5h2xSD6JTJb2pmYAYwI2IQRoEmhBEaQ4ZeuUc8bIUo8c3
	 VbJgGYKOmBgi/RLnDkJCKKhTfCJ1IGTvGG4lVehY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/227] drm/amd/pm: Dont clear SI SMC table when setting power limit
Date: Wed, 28 Jan 2026 16:22:55 +0100
Message-ID: <20260128145349.139432869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit d5077426e1a76d269e518e048bde2e9fc49b32ad ]

There is no reason to clear the SMC table.
We also don't need to recalculate the power limit then.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e214d626253f5b180db10dedab161b7caa41f5e9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 70499bf50ad47..08ffa79154111 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -2273,8 +2273,6 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
 		if (scaling_factor == 0)
 			return -EINVAL;
 
-		memset(smc_table, 0, sizeof(SISLANDS_SMC_STATETABLE));
-
 		ret = si_calculate_adjusted_tdp_limits(adev,
 						       false, /* ??? */
 						       adev->pm.dpm.tdp_adjustment,
@@ -2328,16 +2326,8 @@ static int si_populate_smc_tdp_limits_2(struct amdgpu_device *adev,
 
 	if (ni_pi->enable_power_containment) {
 		SISLANDS_SMC_STATETABLE *smc_table = &si_pi->smc_statetable;
-		u32 scaling_factor = si_get_smc_power_scaling_factor(adev);
 		int ret;
 
-		memset(smc_table, 0, sizeof(SISLANDS_SMC_STATETABLE));
-
-		smc_table->dpm2Params.NearTDPLimit =
-			cpu_to_be32(si_scale_power_for_smc(adev->pm.dpm.near_tdp_limit_adjusted, scaling_factor) * 1000);
-		smc_table->dpm2Params.SafePowerLimit =
-			cpu_to_be32(si_scale_power_for_smc((adev->pm.dpm.near_tdp_limit_adjusted * SISLANDS_DPM2_TDP_SAFE_LIMIT_PERCENT) / 100, scaling_factor) * 1000);
-
 		ret = amdgpu_si_copy_bytes_to_smc(adev,
 						  (si_pi->state_table_start +
 						   offsetof(SISLANDS_SMC_STATETABLE, dpm2Params) +
-- 
2.51.0



