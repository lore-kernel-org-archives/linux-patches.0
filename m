Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AD22E8E10;
	Tue, 17 Jun 2025 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177790; cv=none; b=a6v3fh7cRPv4yNOQiVBzmLXcE1B5IdZbXlZdJ/nCI/G8h3fggSVBSAXsKFiJ+GRpjjr5SGhQzuamNXZjR1vdNr9pb28SZixfHZptxIK3PxYGVLFw7Vj9klk2p8BOJA+NZdikeC6PkhcWWNEngbUL9qM+K5+5vlYN39DQ0xGsR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177790; c=relaxed/simple;
	bh=/9BuMgKBqxWpShBcH/ig3JUtS5dLq8kulDG3HxaG4cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/HqdNb7aD0FsE2PnoFTSIKnr22g4360i3nHSGy2BfU7AXN7bRlvETxL3ROmBhDvsuqMpRAxRYMfC5FtiN+b0NC7eaCrIVmfX+aD6lR8IxpeZpM18fvuyz48SnPbCMInMmVKpNGElyCjPFDV8cvCil7gHN0/DWaE8RYY688Nufg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDdfVp4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDdfVp4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9DCC4CEE7;
	Tue, 17 Jun 2025 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177790;
	bh=/9BuMgKBqxWpShBcH/ig3JUtS5dLq8kulDG3HxaG4cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDdfVp4B18faq5FGc+49+G/mHXNitZoNITJYhKzfHXZ+Anywn85vOQyK5R+sE5eOU
	 Ax2yqL+C5+1Y1hFjD8NZE5/XRx0vX+xFGsApU1CJEVJerwxAs5qnI2ADOtv3y7eTpj
	 LUSBwlo0emmb2SWeGUV/vsq3dT6BqCUpJSozar8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/512] drm/amd/pm: add inst to dpm_set_vcn_enable
Date: Tue, 17 Jun 2025 17:26:03 +0200
Message-ID: <20250617152435.674429732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boyuan Zhang <boyuan.zhang@amd.com>

[ Upstream commit 8b7f3529cd7bca239404d7279056e566639ac055 ]

Add an instance parameter to the existing function dpm_set_vcn_enable()
for future implementation. Re-write all pptable functions accordingly.

v2: Remove duplicated dpm_set_vcn_enable() functions in v1. Instead,
adding instance parameter to existing functions.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ee7360fc27d6 ("drm/amdgpu: read back register after written for VCN v4.0.5")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c               | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h           | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h            | 3 ++-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h            | 3 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c       | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c        | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c         | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c          | 3 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c    | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c    | 4 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c          | 3 ++-
 13 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 3fd8da5dc761e..59c083a16962d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -255,7 +255,7 @@ static int smu_dpm_set_vcn_enable(struct smu_context *smu,
 	if (atomic_read(&power_gate->vcn_gated) ^ enable)
 		return 0;
 
-	ret = smu->ppt_funcs->dpm_set_vcn_enable(smu, enable);
+	ret = smu->ppt_funcs->dpm_set_vcn_enable(smu, enable, 0xff);
 	if (!ret)
 		atomic_set(&power_gate->vcn_gated, !enable);
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 2b8a18ce25d94..4e92295ac1b2d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -744,7 +744,7 @@ struct pptable_funcs {
 	 * @dpm_set_vcn_enable: Enable/disable VCN engine dynamic power
 	 *                      management.
 	 */
-	int (*dpm_set_vcn_enable)(struct smu_context *smu, bool enable);
+	int (*dpm_set_vcn_enable)(struct smu_context *smu, bool enable, int inst);
 
 	/**
 	 * @dpm_set_jpeg_enable: Enable/disable JPEG engine dynamic power
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index 30178dde6d49f..6d46728e7627e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -255,7 +255,8 @@ int smu_v13_0_wait_for_event(struct smu_context *smu, enum smu_event_type event,
 			     uint64_t event_arg);
 
 int smu_v13_0_set_vcn_enable(struct smu_context *smu,
-			     bool enable);
+			      bool enable,
+			      int inst);
 
 int smu_v13_0_set_jpeg_enable(struct smu_context *smu,
 			      bool enable);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
index 3c1b4aa4a68d7..d2289592accc0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
@@ -210,7 +210,8 @@ int smu_v14_0_wait_for_event(struct smu_context *smu, enum smu_event_type event,
 			     uint64_t event_arg);
 
 int smu_v14_0_set_vcn_enable(struct smu_context *smu,
-			     bool enable);
+			      bool enable,
+			      int inst);
 
 int smu_v14_0_set_jpeg_enable(struct smu_context *smu,
 			      bool enable);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index d4b954b22441c..4251c64d00dbe 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2031,7 +2031,9 @@ static bool arcturus_is_dpm_running(struct smu_context *smu)
 	return !!(feature_enabled & SMC_DPM_FEATURE);
 }
 
-static int arcturus_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int arcturus_dpm_set_vcn_enable(struct smu_context *smu,
+					bool enable,
+					int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 27c1892b2c749..48b0eb6dd4ff4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1135,7 +1135,9 @@ static int navi10_set_default_dpm_table(struct smu_context *smu)
 	return 0;
 }
 
-static int navi10_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int navi10_dpm_set_vcn_enable(struct smu_context *smu,
+				      bool enable,
+				      int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 1af90990d05c8..063bb60ff70f0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1152,7 +1152,9 @@ static int sienna_cichlid_set_default_dpm_table(struct smu_context *smu)
 	return 0;
 }
 
-static int sienna_cichlid_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int sienna_cichlid_dpm_set_vcn_enable(struct smu_context *smu,
+					      bool enable,
+					      int inst)
 {
 	struct amdgpu_device *adev = smu->adev;
 	int i, ret = 0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index 9bca748ac2e94..6a7c5f60b3ada 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -461,7 +461,9 @@ static int vangogh_init_smc_tables(struct smu_context *smu)
 	return smu_v11_0_init_smc_tables(smu);
 }
 
-static int vangogh_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int vangogh_dpm_set_vcn_enable(struct smu_context *smu,
+				       bool enable,
+				       int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index 1a8a42b176e52..a21be0971bb3f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -645,7 +645,9 @@ static enum amd_pm_state_type renoir_get_current_power_state(struct smu_context
 	return pm_type;
 }
 
-static int renoir_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int renoir_dpm_set_vcn_enable(struct smu_context *smu,
+				      bool enable,
+				      int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 4f78c84da780c..52da68bbaaf03 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2088,7 +2088,8 @@ int smu_v13_0_get_current_pcie_link_speed(struct smu_context *smu)
 }
 
 int smu_v13_0_set_vcn_enable(struct smu_context *smu,
-			     bool enable)
+			      bool enable,
+			      int inst)
 {
 	struct amdgpu_device *adev = smu->adev;
 	int i, ret = 0;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
index 9c2c43bfed0bb..3204917f91bf6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c
@@ -193,7 +193,9 @@ static int smu_v13_0_5_system_features_control(struct smu_context *smu, bool en)
 	return ret;
 }
 
-static int smu_v13_0_5_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int smu_v13_0_5_dpm_set_vcn_enable(struct smu_context *smu,
+					   bool enable,
+					   int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index 260c339f89c5d..0890951351f97 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -220,7 +220,9 @@ static int yellow_carp_system_features_control(struct smu_context *smu, bool en)
 	return ret;
 }
 
-static int yellow_carp_dpm_set_vcn_enable(struct smu_context *smu, bool enable)
+static int yellow_carp_dpm_set_vcn_enable(struct smu_context *smu,
+					   bool enable,
+					   int inst)
 {
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
index e5f619c979d80..73bd75c34a76e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -1492,7 +1492,8 @@ int smu_v14_0_set_single_dpm_table(struct smu_context *smu,
 }
 
 int smu_v14_0_set_vcn_enable(struct smu_context *smu,
-			     bool enable)
+			      bool enable,
+			      int inst)
 {
 	struct amdgpu_device *adev = smu->adev;
 	int i, ret = 0;
-- 
2.39.5



