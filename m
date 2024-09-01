Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A082186E3A;
	Sun,  1 Sep 2024 16:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209212; cv=none; b=uKYhZQKiBFxyn2N1GnBbolAeI04BqoDV2FsbPltuoTVDf+ZMowu/926TOIxElSr1NXeovChPcu6tXDndsaDs9ohlDG06LefOHc6TnLtD2KDyZZY8mrpvCOeh/0R3TON/I1UyWUy62YFNUzIO91eGnp8AJlvjMujYNmK7/QvPvo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209212; c=relaxed/simple;
	bh=rXp8FFZqksAoqzxsRluHqnpA4LbKdDDdYGpSXnz1Nj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9zfkVPbjbYn/12/8t6Are/6ZOaAaoF2X4DvWXs6yYGYMZ2BY8wTFyiOQtESZgOER3wLLA0fefQgz8BcgRkEi6qN9Xh2YumNuVNuAFf3+Xx1lmf/+27Q5I6vnz08eH14OeJpOXds/Vt2fbv7eKrgMtCBovVpXPqgK4T+tPwszOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFCG0yOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFCG0yOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48D0C4CECC;
	Sun,  1 Sep 2024 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209212;
	bh=rXp8FFZqksAoqzxsRluHqnpA4LbKdDDdYGpSXnz1Nj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFCG0yOaND/BBeBXprPP8MPG3jZSSB+H1MvRJNB0ZwU7cwOu2cFaVUFK/WJBOG+o8
	 kfVAQOtr7btP3QMePXGwp6BjW9hQeGqkyLvCcwSBR16pm0FDSfNIyOdOW1OWzHujkV
	 M7Z3EJx7PzS1OKAe2+rec5E+Zw0brCbZogMg/j4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 18/71] drm/amdgpu: align pp_power_profile_mode with kernel docs
Date: Sun,  1 Sep 2024 18:17:23 +0200
Message-ID: <20240901160802.577187576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1870,8 +1870,7 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -1948,8 +1947,7 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
-		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;


