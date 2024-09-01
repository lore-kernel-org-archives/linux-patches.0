Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7FE183CD8;
	Sun,  1 Sep 2024 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208292; cv=none; b=Fen9qvEkNcx7l1TXVOgZYoepTzgQZwMqAYvJfmGkZSM2H2wCAqe/JoFXXcx1xPPdIYfJ1YGYsJNStxW+PxLjdM7C5/fUZVdx4ph0U46kCHaS2pPqZ2KWCA9CnjTID4Xe0ntCgkWrBYRP98PVzqBbuh/Tm23KQ7YHkGV4hkpMDiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208292; c=relaxed/simple;
	bh=lxL/nFllaRhuknF3aoCb+/jyhdTVHdEOee67VxAYjJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuSRdcfnIWkFExeKtmtm/h8n28YzQKnj7t0fazvqzs15PbgXzl+UJ/Y+ZcCbj4G2maaKavfh+i+xi4RsNL+seh7GgTlUUiOQUwllaFmBj4Gnyy6otkOSzEkvY97KmSg3y4QmdYkZDoPQqWQubF14WRb+4C3mR9sXVisGNT33yh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei6yKQBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei6yKQBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED062C4CEC3;
	Sun,  1 Sep 2024 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208292;
	bh=lxL/nFllaRhuknF3aoCb+/jyhdTVHdEOee67VxAYjJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei6yKQBqtWET/7F45gE4ATVsjI7kOiGjjJjtugiu9vqebe4Y5lVDG/+Ypoz47aG94
	 K5CRf6ge5C+4/qesUHqoSlLG3xa4ygkc+fztbEwANtRYvh/h3DNUpKYn1Ax6m3AIpG
	 MF29XZlNsS1GtYtoKyVJhcGsDh3L14EJal5IguN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 038/149] drm/amdgpu: align pp_power_profile_mode with kernel docs
Date: Sun,  1 Sep 2024 18:15:49 +0200
Message-ID: <20240901160818.895317594@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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
@@ -2256,8 +2256,7 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -2334,8 +2333,7 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;


