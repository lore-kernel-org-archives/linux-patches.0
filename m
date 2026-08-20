Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800E4380FD6;
	Thu, 20 Aug 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239249; cv=none; b=g0WfIy5SF19L76xzjDEAU05WXF739BolfJQ4vS+sKhTQuErckV60pZKjXb/+W7KleSsBQtom/8pUMzQrjgPrtcpK/GAQResmleJlK3tdVhSzXl9Ww1CnDZIVaUaxHZaqBbZsBakLnPFpcpWW1HRh4GgwdJBmKtUV1N7btjJWCQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239249; c=relaxed/simple;
	bh=6UgzbltIsgdsN+p+WHXQ5hVVhNVRlXEd2Z4vTjs1Nt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJXwghrJvB6E3crb8xUDEDhIDbfxKJg72Ee0MFVe7+rBQte7LHmTavKE/u9lagmYePVC7k3n+1KOrjh69vTgUHIKt9oQ+hSW+Zlle+ef3fQpaPQwmcTAKTd1n6R8oWojF3FTOI+4xGDkegSXuf4FYy7+Wd4f6M4vlN6lkDsOTXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itr3LrlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itr3LrlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EC41F000E9;
	Thu, 20 Aug 2026 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239248;
	bh=er25GdFjDQZhxOQ1flY8NAnSIyd9iDo91I36EIKwNao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itr3LrlB40bV0Uqam9G3IJQEBgPix2F8sra6urq4EgsuFXkzjWPTh0tbimv5ZSDCL
	 JcHSlcGolRRNC0X1JbcvF1eXQNiZWL6Q0+dfX/sEjo2Ub3yuC6S35Xskny7oOCPzKt
	 mSkUbKd1sBMMNKU/XPtTa+QIC1oSXdbR3qn2gRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/217] drm/amd/pm: adjust the visibility of pp_table sysfs node
Date: Thu, 20 Aug 2026 16:55:32 +0200
Message-ID: <20260820145242.686285577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 5de8ce0f3709ad93ca5a579aa45cf1b52d72bc90 ]

v1:
- make pp_table invisible on VF mode (only valid on BM)
- make pp_table invisible on Mi* chips (Not supported)
- make pp_table invisible if scpm feature is enabled.

v2:
move pp_table invisible code logic into amdgpu_dpm_get_pp_table() function.

v3:
add table buffer pointer check both on powerplay & swsmu.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: bb493058c35c ("drm/amd/pm: fix pptable use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c              |   12 +++++++++---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c               |   11 ++++++++++-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c |    5 ++++-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c        |    2 +-
 4 files changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1188,8 +1188,11 @@ int amdgpu_dpm_get_pp_table(struct amdgp
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (!pp_funcs->get_pp_table)
-		return 0;
+	if (!table)
+		return -EINVAL;
+
+	if (amdgpu_sriov_vf(adev) || !pp_funcs->get_pp_table || adev->scpm_enabled)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&adev->pm.mutex);
 	ret = pp_funcs->get_pp_table(adev->powerplay.pp_handle,
@@ -1721,7 +1724,10 @@ int amdgpu_dpm_set_pp_table(struct amdgp
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (!pp_funcs->set_pp_table)
+	if (!buf || !size)
+		return -EINVAL;
+
+	if (amdgpu_sriov_vf(adev) || !pp_funcs->set_pp_table || adev->scpm_enabled)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&adev->pm.mutex);
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2502,7 +2502,7 @@ static struct amdgpu_device_attr amdgpu_
 	AMDGPU_DEVICE_ATTR_RO(pp_num_states,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
 	AMDGPU_DEVICE_ATTR_RO(pp_cur_state,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
 	AMDGPU_DEVICE_ATTR_RW(pp_force_state,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
-	AMDGPU_DEVICE_ATTR_RW(pp_table,					ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
+	AMDGPU_DEVICE_ATTR_RW(pp_table,					ATTR_FLAG_BASIC),
 	AMDGPU_DEVICE_ATTR_RW(pp_dpm_sclk,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF,
 			      .attr_update = pp_dpm_clk_default_attr_update),
 	AMDGPU_DEVICE_ATTR_RW(pp_dpm_mclk,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF,
@@ -2639,6 +2639,15 @@ static int default_attr_update(struct am
 		if (amdgpu_dpm_get_apu_thermal_limit(adev, &limit) ==
 		    -EOPNOTSUPP)
 			*states = ATTR_STATE_UNSUPPORTED;
+	} else if (DEVICE_ATTR_IS(pp_table)) {
+		int ret;
+		char *tmp = NULL;
+
+		ret = amdgpu_dpm_get_pp_table(adev, &tmp);
+		if (ret == -EOPNOTSUPP || !tmp)
+			*states = ATTR_STATE_UNSUPPORTED;
+		else
+			*states = ATTR_STATE_SUPPORTED;
 	}
 
 	switch (gc_ver) {
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -634,9 +634,12 @@ static int pp_dpm_get_pp_table(void *han
 {
 	struct pp_hwmgr *hwmgr = handle;
 
-	if (!hwmgr || !hwmgr->pm_en || !hwmgr->soft_pp_table)
+	if (!hwmgr || !hwmgr->pm_en || !table)
 		return -EINVAL;
 
+	if (!hwmgr->soft_pp_table)
+		return -EOPNOTSUPP;
+
 	*table = (char *)hwmgr->soft_pp_table;
 	return hwmgr->soft_pp_table_size;
 }
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -620,7 +620,7 @@ static int smu_sys_get_pp_table(void *ha
 		return -EOPNOTSUPP;
 
 	if (!smu_table->power_play_table && !smu_table->hardcode_pptable)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (smu_table->hardcode_pptable)
 		*table = smu_table->hardcode_pptable;


