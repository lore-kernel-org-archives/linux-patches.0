Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC90418DF69;
	Tue, 10 Sep 2024 10:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964059; cv=none; b=UvexSPv9jk8fTJvVPdXpwLHziDJt/aoRBkw1ZMbO92IuR41MnMQmhJKZfViuh/+dFutPahiEZH1I2gumz2tCByEWI7y+9InXW57qmgWZxeZQdDTkOTJCi3uyLn8iu3c7L5oBkHojHdq0SASjvor/d2pV8V0gRarO/r3VrZAbcTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964059; c=relaxed/simple;
	bh=lJ4AK61XLV746YOQFbkyByyr5ETkhevkfuzvgi0zSG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wng888sihbi4H+n0LYQ62pEfo2fwT7gY2ZkqTVyA8/p/Wk2CuPMXStjK2ra1V9OGKqwKnRVTXetKs9fp3OcL74bXvzg9Ohl4+jY4qsqq66W//aMmKla6OJtav/xXRYh9NxnqcSAWXjRLxHZC6Yxbr4yMgVanrGLLwAk8dv9ndH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImfIz87V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImfIz87V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B936C4CEC3;
	Tue, 10 Sep 2024 10:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964058;
	bh=lJ4AK61XLV746YOQFbkyByyr5ETkhevkfuzvgi0zSG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImfIz87V+XsLqLV2eZM0Rb7sucN44XZS7tiDczOHw/9xkiSkFTIpENe/UUZIhIKSX
	 uw7avmDHeSUIAeSFwB9JQjSjZGN5so7CbykmcW6NnfVsrmi+MNv7Yy4uOxotVkgWGw
	 pdOmQKJdKIcKg1rfxdTtqT9jAyHuCN7f+a2Jma2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 053/269] Revert "drm/amdgpu: align pp_power_profile_mode with kernel docs"
Date: Tue, 10 Sep 2024 11:30:40 +0200
Message-ID: <20240910092610.125513754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

commit 1a8d845470941f1b6de1b392227530c097dc5e0c upstream.

This reverts commit 8f614469de248a4bc55fb07e55d5f4c340c75b11.

This breaks some manual setting of the profile mode in
certain cases.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3600
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7a199557643e993d4e7357860624b8aa5d8f4340)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1883,7 +1883,8 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -1962,7 +1963,8 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;


