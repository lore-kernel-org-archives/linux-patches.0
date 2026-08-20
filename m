Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3C410D30;
	Thu, 20 Aug 2026 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247172; cv=none; b=F8JJAgoAPVr9Ms2QGRiQgsA0Da8ShhvMnsKDiETI7ZdV45TiuvTzhtQMju3P9I0OaI2tIzDsHp/JNoS4KRfdTwSz8w7afI73aUr8o2UdklMao3M6clx7X4kUTHQIIJLYMPtz5RXd4yD3AVx3wP9bLQLBv0J3D+NjXtnXPREECw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247172; c=relaxed/simple;
	bh=715FwTWd5c7CVmt94W2h8t3IvM+2Dmyh0hCkNPF6WW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZkFTIy23GFeX24pPpDZvstPz/EmUoRztg9KNDHs+/mobKA28XiyWo5k9Cv4VzwuZkfdj2nU5Vqf4TWiwghGRtjnjCRatiafwfpSogarcFLvVbY6e7zMUb7y2+T6jvVWsOz6FjU9fA7e9UdcuFnEAuDvqvQSi/SjBO/rzI4iyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dp0YIV7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dp0YIV7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA36A1F000E9;
	Thu, 20 Aug 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247171;
	bh=Jcenv7UPKyYkN+XCIXPYeQNu2JyatO8xob6/7GJ9brQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dp0YIV7mUhchR0tKrCUwXAHmSmgKIk9WG818FmseEBgLI1yZVLkpIXmQlNCOVDXSn
	 +dUbpaYu2ZHXLMJepHP7Ikc2g6ODkWeLtKYdTAC3PfkU+dmRT69qUcvVubrWtiq0wM
	 1VvRMTAoQk9W5/xGClaatcn+zS9zACrDUEUiT9rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/220] drm/amd/pm: adjust the visibility of pp_table sysfs node
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145228.675807787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1064,8 +1064,11 @@ int amdgpu_dpm_get_pp_table(struct amdgp
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
@@ -1575,7 +1578,10 @@ int amdgpu_dpm_set_pp_table(struct amdgp
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
@@ -2402,7 +2402,7 @@ static struct amdgpu_device_attr amdgpu_
 	AMDGPU_DEVICE_ATTR_RO(pp_num_states,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
 	AMDGPU_DEVICE_ATTR_RO(pp_cur_state,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
 	AMDGPU_DEVICE_ATTR_RW(pp_force_state,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
-	AMDGPU_DEVICE_ATTR_RW(pp_table,					ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF),
+	AMDGPU_DEVICE_ATTR_RW(pp_table,					ATTR_FLAG_BASIC),
 	AMDGPU_DEVICE_ATTR_RW(pp_dpm_sclk,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF,
 			      .attr_update = pp_dpm_clk_default_attr_update),
 	AMDGPU_DEVICE_ATTR_RW(pp_dpm_mclk,				ATTR_FLAG_BASIC|ATTR_FLAG_ONEVF,
@@ -2529,6 +2529,15 @@ static int default_attr_update(struct am
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
@@ -650,9 +650,12 @@ static int pp_dpm_get_pp_table(void *han
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
@@ -580,7 +580,7 @@ static int smu_sys_get_pp_table(void *ha
 		return -EOPNOTSUPP;
 
 	if (!smu_table->power_play_table && !smu_table->hardcode_pptable)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (smu_table->hardcode_pptable)
 		*table = smu_table->hardcode_pptable;


