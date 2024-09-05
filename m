Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF8C156225;
	Thu,  5 Sep 2024 09:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530068; cv=none; b=V1KrBz2VfEmosvfN5KFubbPQP6VokzSm/wc3oc/WgAPHMVwDCMQTeFbcqhnYQt3+BCVwDbTjoptBjvHNJRA14GttXHm7UrhKyrMVK4UvfxuXhW2QnG1xpUihFnxPa1EMN+M61N2JRmmDovWL5PWttdGuqJ40fUuVV1e17kVERKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530068; c=relaxed/simple;
	bh=Vx5vPw8pfGsvnNPvnAG/u85r30DLXAuvnvTXt5OOOvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8NCEXxoJ9pK0g/T8zwxz5tOfTn+lByR5R5Uurq1rTlFhBTFNE5kf+nWcDv6V+j8gz+zm7XRbb6xX8e0FfDX6gXhxPYuXF26uBrjRLGc7CYgCXhR9I9RliQ80ZWzDNMyN13uJgkLCjuyDT5knNzPrDrWfcN+uz1hs28teVEvH/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLLPZqT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLLPZqT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE16DC4CEC3;
	Thu,  5 Sep 2024 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530068;
	bh=Vx5vPw8pfGsvnNPvnAG/u85r30DLXAuvnvTXt5OOOvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLLPZqT+uCgWhrxFNVR/B78ibSmJ0cVPA75UaUVKxTC4J2nxujITUuTKlKxSnehvr
	 cpZCQCnheHHWGMapGjMeKX68mUI7sJUax9u8rUkfcgnWGaWIo0hVX3U6see/EzyNTI
	 Bh7lro0jpSvaAKUVnLT3pl6q/a3geRQ1vhAzng1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/132] drm/amd/pm: fix uninitialized variable warning for smu8_hwmgr
Date: Thu,  5 Sep 2024 11:40:32 +0200
Message-ID: <20240905093724.010041363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 86df36b934640866eb249a4488abb148b985a0d9 ]

Clear warnings that using uninitialized value level when fails
to get the value from SMU.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c   | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
index eb744401e056..7e1197420873 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
@@ -584,6 +584,7 @@ static int smu8_init_uvd_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.uvd_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -591,7 +592,9 @@ static int smu8_init_uvd_limit(struct pp_hwmgr *hwmgr)
 	data->uvd_dpm.soft_min_clk = 0;
 	data->uvd_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxUvdLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxUvdLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].vclk;
@@ -611,6 +614,7 @@ static int smu8_init_vce_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.vce_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -618,7 +622,9 @@ static int smu8_init_vce_limit(struct pp_hwmgr *hwmgr)
 	data->vce_dpm.soft_min_clk = 0;
 	data->vce_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxEclkLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxEclkLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].ecclk;
@@ -638,6 +644,7 @@ static int smu8_init_acp_limit(struct pp_hwmgr *hwmgr)
 				hwmgr->dyn_state.acp_clock_voltage_dependency_table;
 	unsigned long clock = 0;
 	uint32_t level;
+	int ret;
 
 	if (NULL == table || table->count <= 0)
 		return -EINVAL;
@@ -645,7 +652,9 @@ static int smu8_init_acp_limit(struct pp_hwmgr *hwmgr)
 	data->acp_dpm.soft_min_clk = 0;
 	data->acp_dpm.hard_min_clk = 0;
 
-	smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxAclkLevel, &level);
+	ret = smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetMaxAclkLevel, &level);
+	if (ret)
+		return ret;
 
 	if (level < table->count)
 		clock = table->entries[level].acpclk;
-- 
2.43.0



