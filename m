Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015174;
	b=XNiQ7Kuhmi3o3bd0vX4MU5g6pvitfsEnwBj5/Y5yx9+l+g2yyf4HZ4RUz7djzP/RsLgj
	 NI1cyJVwN6V0nB9v4vIHf75OfnC9OfPoiYUBkswQf8zcELcAtofd4txxAleteY/anYNlE
	 w5yinKk5t0zh7ERVUMqrVjHm3Q3+m6umgfZ3qpG8JPOV197Au5kNrwzMQXGnGVHtR7Tue
	 YG9S5+OEFQCX9wfXjR2cxoTmyhTcqYdrDigPpyyeRfGJXTCH82s9GHgOJZixVff4SiurD
	 ts3/vl7RZC9Mr1D+Vx/vnKmuNTroqdaMHI2PZoXwOB0rhcaqfZ3tlEkqhmhZxCiyKOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a0xoVGFR3pLD4M+1MWFhUi1AmUZ5OHFRrWeDdIi+2GI=;
	b=17VM/dKdWDKbIbb+7J+iDum8/qQrnak8gSQsa9CFVePw7LRNGugdv390N+x7PlSiqo1k
	 MYubmoSFCsgpe2P9tALfpae1Y9aW+SIISK3KvkhStY0n/LlvsgwgXfd62UJPuZGw/1bAB
	 ysur97hO6Ye5ZuB3yVrVsSu7lgpZUbfuAzy+yYIwyK1vN1pMY7EpcxpVIkSElUyUiiyfQ
	 8EiOwVecDKE2/mBE2SlyyUDiSIHFWN1CbmjBRt6bZYOpBOw70hFCfMGtyKZAScPQ/sd5E
	 9z1t7PRGMPzgWBgUh/huCoHjE3EFHpvwmzbhqsqQZOwXLgXSPJWtjrz+vuZTOCOYndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNWr69m6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A21606A32A;
	Wed, 18 Nov 2026 15:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KNWr69m6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC871F000C6;
	Wed, 18 Nov 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015173;
	bh=a0xoVGFR3pLD4M+1MWFhUi1AmUZ5OHFRrWeDdIi+2GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNWr69m6pukRj2/71iyZRX2r1tvoU6Ho8aRGH0XEsEGJl1M46jK+HMa+FRtKIQDPJ
	 COVXP4ouwWze+pvArdGxYCjrmpXMC78pi27ku5XtX9OV+cCZmJWrkp975Z9S3h1rX3
	 3PKTGfGRMn/Ys8c/ubGUtZn47qJDUQCEBFTtJTwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0080/2651] drm/amd/pm: Remove unused functions in smu_v15_0
Date: Wed, 18 Nov 2026 15:22:00 +0100
Message-ID: <20261118150250.801602933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit f65ae77aac72caed6d99c7d73f16b71cebbc6753 ]

smu_v15_0_load_microcode() and smu_v15_0_set_single_dpm_table() are not
called anywhere; the latter is a carry-over from a previous version. The
static helpers smu_v15_0_get_dpm_freq_by_index(),
smu_v15_0_get_dpm_level_count() and smu_v15_0_get_fine_grained_status()
were only called from smu_v15_0_set_single_dpm_table(), so remove those
as well. Remove all functions along with their declarations from the
header.

Fixes: c7fc0f372374 ("drm/amd: Enable SMU 15_0_0 support")
Fixes: f7bee962d92a ("drm/amd/pm: Update dpm table structs for smu_v15_0")
Reported-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h  |   6 -
 .../gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c    | 166 ------------------
 2 files changed, 172 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h
index ec96dc7754859..0c97bee2c4bbc 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h
@@ -113,8 +113,6 @@ int smu_v15_0_init_microcode(struct smu_context *smu);
 
 void smu_v15_0_fini_microcode(struct smu_context *smu);
 
-int smu_v15_0_load_microcode(struct smu_context *smu);
-
 int smu_v15_0_init_smc_tables(struct smu_context *smu);
 
 int smu_v15_0_fini_smc_tables(struct smu_context *smu);
@@ -183,10 +181,6 @@ int smu_v15_0_set_performance_level(struct smu_context *smu,
 int smu_v15_0_set_power_source(struct smu_context *smu,
 			       enum smu_power_src_type power_src);
 
-int smu_v15_0_set_single_dpm_table(struct smu_context *smu,
-				   enum smu_clk_type clk_type,
-				   struct smu_dpm_table *single_dpm_table);
-
 int smu_v15_0_gfx_ulv_control(struct smu_context *smu,
 			      bool enablement);
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c
index 4c0236196de4f..2269703869f9e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c
@@ -106,44 +106,6 @@ void smu_v15_0_fini_microcode(struct smu_context *smu)
 	adev->pm.fw_version = 0;
 }
 
-int smu_v15_0_load_microcode(struct smu_context *smu)
-{
-	struct amdgpu_device *adev = smu->adev;
-	const uint32_t *src;
-	const struct smc_firmware_header_v1_0 *hdr;
-	uint32_t addr_start = MP1_SRAM;
-	uint32_t i;
-	uint32_t smc_fw_size;
-	uint32_t mp1_fw_flags;
-
-	hdr = (const struct smc_firmware_header_v1_0 *) adev->pm.fw->data;
-	src = (const uint32_t *)(adev->pm.fw->data +
-				 le32_to_cpu(hdr->header.ucode_array_offset_bytes));
-	smc_fw_size = hdr->header.ucode_size_bytes;
-
-	for (i = 1; i < smc_fw_size/4 - 1; i++) {
-		WREG32_PCIE(addr_start, src[i]);
-		addr_start += 4;
-	}
-
-
-	for (i = 0; i < adev->usec_timeout; i++) {
-		if (smu->is_apu)
-			mp1_fw_flags = RREG32_PCIE(MP1_Public |
-						   (smnMP1_FIRMWARE_FLAGS & 0xffffffff));
-
-		if ((mp1_fw_flags & MP1_CRU1_MP1_FIRMWARE_FLAGS__INTERRUPTS_ENABLED_MASK) >>
-		    MP1_CRU1_MP1_FIRMWARE_FLAGS__INTERRUPTS_ENABLED__SHIFT)
-			break;
-		udelay(1);
-	}
-
-	if (i == adev->usec_timeout)
-		return -ETIME;
-
-	return 0;
-}
-
 int smu_v15_0_init_pptable_microcode(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1161,134 +1123,6 @@ int smu_v15_0_set_power_source(struct smu_context *smu,
 					       NULL);
 }
 
-static int smu_v15_0_get_dpm_freq_by_index(struct smu_context *smu,
-					   enum smu_clk_type clk_type,
-					   uint16_t level,
-					   uint32_t *value)
-{
-	int ret = 0, clk_id = 0;
-	uint32_t param;
-
-	if (!value)
-		return -EINVAL;
-
-	if (!smu_cmn_clk_dpm_is_enabled(smu, clk_type))
-		return 0;
-
-	clk_id = smu_cmn_to_asic_specific_index(smu,
-						CMN2ASIC_MAPPING_CLK,
-						clk_type);
-	if (clk_id < 0)
-		return clk_id;
-
-	param = (uint32_t)(((clk_id & 0xffff) << 16) | (level & 0xffff));
-
-	ret = smu_cmn_send_smc_msg_with_param(smu,
-					      SMU_MSG_GetDpmFreqByIndex,
-					      param,
-					      value);
-	if (ret)
-		return ret;
-
-	*value = *value & 0x7fffffff;
-
-	return ret;
-}
-
-static int smu_v15_0_get_dpm_level_count(struct smu_context *smu,
-					 enum smu_clk_type clk_type,
-					 uint32_t *value)
-{
-	int ret;
-
-	ret = smu_v15_0_get_dpm_freq_by_index(smu, clk_type, 0xff, value);
-
-	return ret;
-}
-
-static int smu_v15_0_get_fine_grained_status(struct smu_context *smu,
-					     enum smu_clk_type clk_type,
-					     bool *is_fine_grained_dpm)
-{
-	int ret = 0, clk_id = 0;
-	uint32_t param;
-	uint32_t value;
-
-	if (!is_fine_grained_dpm)
-		return -EINVAL;
-
-	if (!smu_cmn_clk_dpm_is_enabled(smu, clk_type))
-		return 0;
-
-	clk_id = smu_cmn_to_asic_specific_index(smu,
-						CMN2ASIC_MAPPING_CLK,
-						clk_type);
-	if (clk_id < 0)
-		return clk_id;
-
-	param = (uint32_t)(((clk_id & 0xffff) << 16) | 0xff);
-
-	ret = smu_cmn_send_smc_msg_with_param(smu,
-					      SMU_MSG_GetDpmFreqByIndex,
-					      param,
-					      &value);
-	if (ret)
-		return ret;
-
-	/*
-	 * BIT31:  1 - Fine grained DPM, 0 - Dicrete DPM
-	 * now, we un-support it
-	 */
-	*is_fine_grained_dpm = value & 0x80000000;
-
-	return 0;
-}
-
-int smu_v15_0_set_single_dpm_table(struct smu_context *smu,
-				   enum smu_clk_type clk_type,
-				   struct smu_dpm_table *single_dpm_table)
-{
-	int ret = 0;
-	uint32_t clk;
-	bool is_fine_grained;
-	int i;
-
-	ret = smu_v15_0_get_dpm_level_count(smu,
-					    clk_type,
-					    &single_dpm_table->count);
-	if (ret) {
-		dev_err(smu->adev->dev, "[%s] failed to get dpm levels!\n", __func__);
-		return ret;
-	}
-
-	ret = smu_v15_0_get_fine_grained_status(smu,
-						clk_type,
-						&is_fine_grained);
-	if (ret) {
-		dev_err(smu->adev->dev, "[%s] failed to get fine grained status!\n", __func__);
-		return ret;
-	}
-
-	if (is_fine_grained)
-		single_dpm_table->flags |= SMU_DPM_TABLE_FINE_GRAINED;
-
-	for (i = 0; i < single_dpm_table->count; i++) {
-		ret = smu_v15_0_get_dpm_freq_by_index(smu,
-						      clk_type,
-						      i,
-						      &clk);
-		if (ret) {
-			dev_err(smu->adev->dev, "[%s] failed to get dpm freq by index!\n", __func__);
-			return ret;
-		}
-
-		single_dpm_table->dpm_levels[i].value = clk;
-		single_dpm_table->dpm_levels[i].enabled = true;
-	}
-
-	return 0;
-}
-
 int smu_v15_0_set_vcn_enable(struct smu_context *smu,
 			      bool enable,
 			      int inst)
-- 
2.53.0



