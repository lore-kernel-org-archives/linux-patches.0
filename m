Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8491D9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D4EC433C8;
	Sun, 13 Aug 2023 21:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962459;
	bh=Olt41A8yjwAEtLveMGp9jIChwphHAUDSbDRn/vrLb1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxcLqzoMuxP3we7MQmxAuL1wtdhYyUyPxPnxelvVmkGcPycktLI5RKUayYBSs/3DH
	 MeOD6J9pAYT+ns4Ef9gbNC0tfkgJxnSyA4TN3jANv7GvAt7j6cNdQ4F3NP4iPsbrMZ
	 Xbd8LuPMrpYHAvBauopRSnM+bvLleIl8KWM5NCIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 037/149] drm/amd/pm: fulfill swsmu peak profiling mode shader/memory clock settings
Date: Sun, 13 Aug 2023 23:18:02 +0200
Message-ID: <20230813211719.918778033@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit 975b4b1d90ccf83da252907108f4090fb61b816e upstream

Enable peak profiling mode shader/memory clocks reporting for swsmu
framework.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/kgd_pp_interface.h |    2 ++
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c      |    8 ++++++++
 2 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -139,6 +139,8 @@ enum amd_pp_sensors {
 	AMDGPU_PP_SENSOR_MIN_FAN_RPM,
 	AMDGPU_PP_SENSOR_MAX_FAN_RPM,
 	AMDGPU_PP_SENSOR_VCN_POWER_STATE,
+	AMDGPU_PP_SENSOR_PEAK_PSTATE_SCLK,
+	AMDGPU_PP_SENSOR_PEAK_PSTATE_MCLK,
 };
 
 enum amd_pp_task {
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2520,6 +2520,14 @@ static int smu_read_sensor(void *handle,
 		*((uint32_t *)data) = pstate_table->uclk_pstate.standard * 100;
 		*size = 4;
 		break;
+	case AMDGPU_PP_SENSOR_PEAK_PSTATE_SCLK:
+		*((uint32_t *)data) = pstate_table->gfxclk_pstate.peak * 100;
+		*size = 4;
+		break;
+	case AMDGPU_PP_SENSOR_PEAK_PSTATE_MCLK:
+		*((uint32_t *)data) = pstate_table->uclk_pstate.peak * 100;
+		*size = 4;
+		break;
 	case AMDGPU_PP_SENSOR_ENABLED_SMC_FEATURES_MASK:
 		ret = smu_feature_get_enabled_mask(smu, (uint64_t *)data);
 		*size = 8;


