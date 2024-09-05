Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F64714A08E;
	Thu,  5 Sep 2024 09:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529651; cv=none; b=EL0H6eDGi/tPR5YZhJGZkejhWDx9wpsfhffxCnoAGhS4Y/X8Qth/GXPVOIJTk0rbr1+RzLIOFhv2mGTWFRBsNUaTdi/lILNlrbOB1Yz09Cc3De9Jj89xpgYzcXg8OrtGcoZ10OpQIr4GWB7sO1MM5OAFIjCCVXXe0xZeiSZWmRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529651; c=relaxed/simple;
	bh=3g6SSVifSrTM/TpZnnsrLZ4UVBAILyUTGj1Xm9YAJHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffd+ASywR2b6iqSDXie1vIRKrOG+HhXHoRelW1Hr3q7y2Vkw2PL1uH1tpFzmx1Py9XWNV2VkM5Tj2OWTVbuAZFlzeq1K4mze7iKY/DD8acajwR1YqibRzr6h/0F1OsNKApUxaxo+sqXw13EP9A+EXP5i7ERH06FMsTifGlM4w24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7qr6h+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7qr6h+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED35C4CEC3;
	Thu,  5 Sep 2024 09:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529651;
	bh=3g6SSVifSrTM/TpZnnsrLZ4UVBAILyUTGj1Xm9YAJHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7qr6h+epI6zV/BIgSYBPUn7Ylzb99Hzpf1oxT9PZnH5YuPlwzmldYHN4UYPMN4DK
	 IXdFsSOgXcwM/qt95nLmY9+sBoRhDzMhNpMTPKAG2JYfis0hcuFzVvA6ka9lNMmCFP
	 4NsryAUH8WMhxtl/JUPTmTwtHD97yOcWfCWHFi/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 101/184] drm/amdgpu/pm: Check input value for power profile setting on smu11, smu13 and smu14
Date: Thu,  5 Sep 2024 11:40:14 +0200
Message-ID: <20240905093736.180594335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit adb9de4dd207fb1264ea70b9eacab9f70ee4707a ]

Check the input value for CUSTOM profile mode setting on smu 11,
smu13 and smu14. Otherwise we use uninitialized value of input[]

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c       | 5 +++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         | 4 ++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 ++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c    | 5 +++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c    | 4 ++++
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c    | 5 +++++
 6 files changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 6d334a2aff67..623f6052f97e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1416,6 +1416,9 @@ static int arcturus_set_power_profile_mode(struct smu_context *smu,
 
 	if ((profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) &&
 	     (smu->smc_fw_version >= 0x360d00)) {
+		if (size != 10)
+			return -EINVAL;
+
 		ret = smu_cmn_update_table(smu,
 				       SMU_TABLE_ACTIVITY_MONITOR_COEFF,
 				       WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -1449,6 +1452,8 @@ static int arcturus_set_power_profile_mode(struct smu_context *smu,
 			activity_monitor.Mem_PD_Data_error_coeff = input[8];
 			activity_monitor.Mem_PD_Data_error_rate_coeff = input[9];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index c06e0d6e3017..01039cdd456b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2021,6 +2021,8 @@ static int navi10_set_power_profile_mode(struct smu_context *smu, long *input, u
 	}
 
 	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
+		if (size != 10)
+			return -EINVAL;
 
 		ret = smu_cmn_update_table(smu,
 				       SMU_TABLE_ACTIVITY_MONITOR_COEFF, WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -2064,6 +2066,8 @@ static int navi10_set_power_profile_mode(struct smu_context *smu, long *input, u
 			activity_monitor.Mem_PD_Data_error_coeff = input[8];
 			activity_monitor.Mem_PD_Data_error_rate_coeff = input[9];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index e426f457a017..d5a21d7836cc 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1722,6 +1722,8 @@ static int sienna_cichlid_set_power_profile_mode(struct smu_context *smu, long *
 	}
 
 	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
+		if (size != 10)
+			return -EINVAL;
 
 		ret = smu_cmn_update_table(smu,
 				       SMU_TABLE_ACTIVITY_MONITOR_COEFF, WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -1765,6 +1767,8 @@ static int sienna_cichlid_set_power_profile_mode(struct smu_context *smu, long *
 			activity_monitor->Mem_PD_Data_error_coeff = input[8];
 			activity_monitor->Mem_PD_Data_error_rate_coeff = input[9];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 1e09d5f2d82f..f7e756ca36dc 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2495,6 +2495,9 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 	}
 
 	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
+		if (size != 9)
+			return -EINVAL;
+
 		ret = smu_cmn_update_table(smu,
 					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
 					   WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -2526,6 +2529,8 @@ static int smu_v13_0_0_set_power_profile_mode(struct smu_context *smu,
 			activity_monitor->Fclk_PD_Data_error_coeff = input[7];
 			activity_monitor->Fclk_PD_Data_error_rate_coeff = input[8];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index e996a0a4d33e..4f98869e0284 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2450,6 +2450,8 @@ static int smu_v13_0_7_set_power_profile_mode(struct smu_context *smu, long *inp
 	}
 
 	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
+		if (size != 8)
+			return -EINVAL;
 
 		ret = smu_cmn_update_table(smu,
 				       SMU_TABLE_ACTIVITY_MONITOR_COEFF, WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -2478,6 +2480,8 @@ static int smu_v13_0_7_set_power_profile_mode(struct smu_context *smu, long *inp
 			activity_monitor->Fclk_MinActiveFreq = input[6];
 			activity_monitor->Fclk_BoosterFreq = input[7];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index 90703f4542ab..06b65159f7b4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1364,6 +1364,9 @@ static int smu_v14_0_2_set_power_profile_mode(struct smu_context *smu,
 	}
 
 	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
+		if (size != 9)
+			return -EINVAL;
+
 		ret = smu_cmn_update_table(smu,
 					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
 					   WORKLOAD_PPLIB_CUSTOM_BIT,
@@ -1395,6 +1398,8 @@ static int smu_v14_0_2_set_power_profile_mode(struct smu_context *smu,
 			activity_monitor->Fclk_PD_Data_error_coeff = input[7];
 			activity_monitor->Fclk_PD_Data_error_rate_coeff = input[8];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		ret = smu_cmn_update_table(smu,
-- 
2.43.0



