Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A01C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A114C433D6;
	Wed, 23 Nov 2022 09:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195347;
	bh=f4dtExZz7IbpZ2d03WEirG3ykgL92dQUBS8IIbgta+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqSCZJOaPovG+qieQWAkOmK1TMOPJW9VQW6EV/k84OIG01Na8JuAy8DF0SwJJYcG4
	 N9PzSRXCfE9oa05673RckoVRdILyHk62Bz/n/AinaU9Y9v3fJnb2tFXd/x5SIA5+wL
	 oNRaZ2sTwjPrxJDS/quf+iGSsomR3sqOSkH/tKJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/149] drm/amd/pm: support power source switch on Sienna Cichlid
Date: Wed, 23 Nov 2022 09:50:11 +0100
Message-Id: <20221123084559.028326540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

[ Upstream commit 18a4b3de5fc1c63c80e3be0673886431a56e4307 ]

Enable power source switch on Sienna Cichlid.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0c85c067c9d9 ("drm/amdgpu: disable BACO on special BEIGE_GOBY card")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 49d7fa1d0842..834ac633281c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -301,6 +301,9 @@ static int sienna_cichlid_check_powerplay_table(struct smu_context *smu)
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
 
+	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_HARDWAREDC)
+		smu->dc_controlled_by_gpio = true;
+
 	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO ||
 	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO)
 		smu_baco->platform_support = true;
@@ -2806,6 +2809,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.get_dpm_ultimate_freq = sienna_cichlid_get_dpm_ultimate_freq,
 	.set_soft_freq_limited_range = smu_v11_0_set_soft_freq_limited_range,
 	.run_btc = sienna_cichlid_run_btc,
+	.set_power_source = smu_v11_0_set_power_source,
 	.get_pp_feature_mask = smu_cmn_get_pp_feature_mask,
 	.set_pp_feature_mask = smu_cmn_set_pp_feature_mask,
 	.get_gpu_metrics = sienna_cichlid_get_gpu_metrics,
-- 
2.35.1



