Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034571;
	b=IPU4xuHh4143Wc5re8dU2Zf0lOtckOJZzEkApy+fwa0M/AT2ujf5MupQNavG9dA9ymQ7
	 teJa8tsKubQ7xQnc1Tn9+Rfce+ILzDim3LmUuDT4drTtjw6bUOSFOluDFSCjuCwcsGve/
	 p1okivEcNQTYGPAf7Lae8LqNWWaNjzqdrtSKXAu7UWzq5LgXRiOW7QNL3lmmBx85sEv0N
	 ZubgROuyX2NnLkoF+bS7ZDIH3yJGfOdgEHfKbFM77I7rhWwVo9z+Tsa9LTgXAKEOWSmAF
	 QoB5YvaGCAgYqxhOkvpqmQIJrMxqHcFwjExp+O7SZDFFf8gTba2W7wvoS9pfut6w9vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=U5dyUiwyCqSETAEuBkFcXH1Q5YxYKYVyrsLprJ18uSY=;
	b=hiqbcbgeyQAbm2XqkDEYJAByq2flU1igX3pAr5++9JMI2WXrAJ6PtjmgQCfjZcnuSU2R
	 4tpocpqEJXrjEDwRWuXIiK+qbTo1pUQlRePE/kpqmtfOehCFyksz6L5tpkAZYfISMjR3s
	 Ex4Lz90FucCb1T21ueyEsXsHJv7xFssfdvn3HBiWenJXmnzO0K45X/OcDgV60DYmRGw7I
	 xITygHU3Alu19ZnaKuCFwtuYHKdVwjVpG+FMEaJ/hIgz1VtbR2mHGsEvpep/qfGo99Hrg
	 HQQQjLLxlBCouBbQ3hocAyBIB1sh9/c5jSHfRjYpNu5FvamQZOVtprwz2ngsqOBEHfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5I8Svnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E36606A31C;
	Wed, 18 Nov 2026 20:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5I8Svnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5678A1F000C4;
	Wed, 18 Nov 2026 20:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034570;
	bh=U5dyUiwyCqSETAEuBkFcXH1Q5YxYKYVyrsLprJ18uSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5I8Svnn8YbbUCjEkl5uAfrEJNtMghaa4DRIyMMbhM9LxHB1Lme7iGIq6pZkL5Aqe
	 lUalBKvgxn+NHHLXaENMj9AgyhLGA384L18lLiGC5YhP5nXU+BjYYAOIUnP2RR2LWr
	 frMdOvNqbjLApi82AsgsUx66YgU2cM12/IY2T+bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0416/3318] platform/x86: ISST: Use PP level enable mask
Date: Wed, 18 Nov 2026 15:17:18 +0100
Message-ID: <20261118150329.012643580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 9b9026943b19d06ebf520b1f4786621947cf43c8 ]

Add check for enabled levels only when reading MMIO. Some levels can be
disabled by BIOS. If the level is not enabled, return an error.

Reset the enable and allowed level masks if there is a failure to add a
perf level.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-6-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adapted the level-0 BF/TF support reads in isst_if_get_perf_level() to be guarded by level_en_mask, since this tree lacks upstream's per-level loop, and adjusted context in sst_add_perf_profiles(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/speed_select_if/isst_tpmi_core.c    | 30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 01dfb41a52b80..5321f68dbafbc 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -318,8 +318,11 @@ static int sst_add_perf_profiles(struct auxiliary_device *auxdev,
 	pd_info->perf_levels = devm_kcalloc(&auxdev->dev, levels,
 					    sizeof(struct perf_level),
 					    GFP_KERNEL);
-	if (!pd_info->perf_levels)
+	if (!pd_info->perf_levels) {
+		pd_info->pp_header.allowed_level_mask = 0;
+		pd_info->pp_header.level_en_mask = 0;
 		return 0;
+	}
 
 	pd_info->ratio_unit = pd_info->pp_header.ratio_unit;
 	pd_info->avx_levels = SST_MAX_AVX_LEVELS;
@@ -757,12 +760,16 @@ static int isst_if_get_perf_level(void __user *argp)
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));
 
-	_read_bf_level_info("bf_support", perf_level.sst_bf_support, 0, 0,
-			    SST_BF_FEATURE_SUPPORTED_START, SST_BF_FEATURE_SUPPORTED_WIDTH,
-			    SST_MUL_FACTOR_NONE);
-	_read_tf_level_info("tf_support", perf_level.sst_tf_support, 0, 0,
-			    SST_TF_FEATURE_SUPPORTED_START, SST_TF_FEATURE_SUPPORTED_WIDTH,
-			    SST_MUL_FACTOR_NONE);
+	perf_level.sst_bf_support = 0;
+	perf_level.sst_tf_support = 0;
+	if (power_domain_info->pp_header.level_en_mask & BIT(0)) {
+		_read_bf_level_info("bf_support", perf_level.sst_bf_support, 0, 0,
+				    SST_BF_FEATURE_SUPPORTED_START, SST_BF_FEATURE_SUPPORTED_WIDTH,
+				    SST_MUL_FACTOR_NONE);
+		_read_tf_level_info("tf_support", perf_level.sst_tf_support, 0, 0,
+				    SST_TF_FEATURE_SUPPORTED_START, SST_TF_FEATURE_SUPPORTED_WIDTH,
+				    SST_MUL_FACTOR_NONE);
+	}
 
 	if (copy_to_user(argp, &perf_level, sizeof(perf_level)))
 		return -EFAULT;
@@ -1113,6 +1120,9 @@ static int isst_if_get_base_freq_info(void __user *argp)
 	if (base_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(base_freq.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("p1_high", base_freq.high_base_freq_mhz, base_freq.level,
 			    SST_BF_INFO_0_OFFSET, SST_BF_P1_HIGH_START, SST_BF_P1_HIGH_WIDTH,
 			    SST_MUL_FACTOR_FREQ)
@@ -1152,6 +1162,9 @@ static int isst_if_get_base_freq_mask(void __user *argp)
 	if (cpumask.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(cpumask.level)))
+		return -EINVAL;
+
 	_read_bf_level_info("BF-cpumask", mask, cpumask.level, SST_BF_INFO_1_OFFSET,
 			    P1_HI_CORE_MASK_START, P1_HI_CORE_MASK_WIDTH,
 			    SST_MUL_FACTOR_NONE)
@@ -1231,6 +1244,9 @@ static int isst_if_get_turbo_freq_info(void __user *argp)
 	if (turbo_freq.level > power_domain_info->max_level)
 		return -EINVAL;
 
+	if (!(power_domain_info->pp_header.level_en_mask & BIT(turbo_freq.level)))
+		return -EINVAL;
+
 	turbo_freq.max_buckets = TRL_MAX_BUCKETS;
 	turbo_freq.max_trl_levels = TRL_MAX_LEVELS;
 	turbo_freq.max_clip_freqs = SST_TF_MAX_LP_CLIP_RATIOS;
-- 
2.53.0



