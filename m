Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16536364BA;
	Fri, 24 Nov 2023 18:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQox8rn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DBBC433C8;
	Fri, 24 Nov 2023 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851635;
	bh=DwnSDeNo/tEZ1Ahy4qqcVVYHJMvDcbctywwiQMrRg70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQox8rn1uw8HwO4Oml1HdE9EYlHs6qP9V+XY6UN2N2PC+H50wk/5pitfMgJ1nlJZi
	 KWm24tNDttkwh4ggL3WYIInquTrwm8kTJemXEoXfbG750wO4BwsNNxbgu2uasPQ/pU
	 ABw7UHl7dPnR9wN/F4SomJqUPB1PRCA3uDMXw0qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/372] drm/amd: Update `update_pcie_parameters` functions to use uint8_t arguments
Date: Fri, 24 Nov 2023 17:47:02 +0000
Message-ID: <20231124172011.662929566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7752ccf85b929a22e658ec145283e8f31232f4bb ]

The matching values for `pcie_gen_cap` and `pcie_width_cap` when
fetched from powerplay tables are 1 byte, so narrow the arguments
to match to ensure min() and max() comparisons without casts.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c               | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h           | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h            | 4 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         | 4 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 8 ++++----
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c          | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index a664a0a284784..47ff3694ffa57 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1221,7 +1221,7 @@ static int smu_smc_hw_setup(struct smu_context *smu)
 {
 	struct smu_feature *feature = &smu->smu_feature;
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t pcie_gen = 0, pcie_width = 0;
+	uint8_t pcie_gen = 0, pcie_width = 0;
 	uint64_t features_supported;
 	int ret = 0;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 1ab77a6cdb653..4174cb295dd0b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -844,7 +844,7 @@ struct pptable_funcs {
 	 * &pcie_gen_cap: Maximum allowed PCIe generation.
 	 * &pcie_width_cap: Maximum allowed PCIe width.
 	 */
-	int (*update_pcie_parameters)(struct smu_context *smu, uint32_t pcie_gen_cap, uint32_t pcie_width_cap);
+	int (*update_pcie_parameters)(struct smu_context *smu, uint8_t pcie_gen_cap, uint8_t pcie_width_cap);
 
 	/**
 	 * @i2c_init: Initialize i2c.
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index d6479a8088554..636b9579b96b0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -298,8 +298,8 @@ int smu_v13_0_get_pptable_from_firmware(struct smu_context *smu,
 					uint32_t pptable_id);
 
 int smu_v13_0_update_pcie_parameters(struct smu_context *smu,
-				     uint32_t pcie_gen_cap,
-				     uint32_t pcie_width_cap);
+				     uint8_t pcie_gen_cap,
+				     uint8_t pcie_width_cap);
 
 #endif
 #endif
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index ca278280865fa..ed2112efc6c68 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2368,8 +2368,8 @@ static int navi10_get_power_limit(struct smu_context *smu,
 }
 
 static int navi10_update_pcie_parameters(struct smu_context *smu,
-				     uint32_t pcie_gen_cap,
-				     uint32_t pcie_width_cap)
+					 uint8_t pcie_gen_cap,
+					 uint8_t pcie_width_cap)
 {
 	struct smu_11_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index fbc4d706748b7..cfd41d56e9701 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2084,14 +2084,14 @@ static int sienna_cichlid_display_disable_memory_clock_switch(struct smu_context
 #define MAX(a, b)	((a) > (b) ? (a) : (b))
 
 static int sienna_cichlid_update_pcie_parameters(struct smu_context *smu,
-					 uint32_t pcie_gen_cap,
-					 uint32_t pcie_width_cap)
+						 uint8_t pcie_gen_cap,
+						 uint8_t pcie_width_cap)
 {
 	struct smu_11_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	struct smu_11_0_pcie_table *pcie_table = &dpm_context->dpm_tables.pcie_table;
 	uint8_t *table_member1, *table_member2;
-	uint32_t min_gen_speed, max_gen_speed;
-	uint32_t min_lane_width, max_lane_width;
+	uint8_t min_gen_speed, max_gen_speed;
+	uint8_t min_lane_width, max_lane_width;
 	uint32_t smu_pcie_arg;
 	int ret, i;
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 3104d49379090..1b0fb93539ec4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2486,8 +2486,8 @@ int smu_v13_0_mode1_reset(struct smu_context *smu)
 }
 
 int smu_v13_0_update_pcie_parameters(struct smu_context *smu,
-				     uint32_t pcie_gen_cap,
-				     uint32_t pcie_width_cap)
+				     uint8_t pcie_gen_cap,
+				     uint8_t pcie_width_cap)
 {
 	struct smu_13_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	struct smu_13_0_pcie_table *pcie_table =
-- 
2.42.0



