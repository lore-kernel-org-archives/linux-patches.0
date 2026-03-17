Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8D53EC2EA;
	Tue, 17 Mar 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765648; cv=none; b=bH3v/R9TdH3eAYG1hJxoqYzG90bsBynPf1BFHH+6cQ+vCsdy0FdjL8jBCI9hdjOHMr2wQ24H9KJCz444JAVB06Fsoxw70Xb6wbW6g7dXYExZKTpro3rUH1mYvS8S4OPLeNmQUi8JJkmdg4xR8bT6cb6kx+xU7ZQ1WTUqS5opQ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765648; c=relaxed/simple;
	bh=NaJloKUKS9objlpcuJu/JYSrygvC1vWY02q/yFRJHrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeF2frE3I39NOWnn7xsF6trsCaXe699rAikLyc1stB5y/Fybq10syMq4hA8InAr9zbcupZZzkwuPPwv8qHymmeGW4S7pnuKRMcY305JDwRocgvdvXaLkmfEdDZk+UzynBHL5obs7rfqdrMBANChKpCahPLwqnLc7izUHhaOj3Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIl/da3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIl/da3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA78AC4CEF7;
	Tue, 17 Mar 2026 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765648;
	bh=NaJloKUKS9objlpcuJu/JYSrygvC1vWY02q/yFRJHrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIl/da3nK5eXmRv1q/92BJJ2KanGxBrDC+sp0LJuWUDYG/xplQvzn7qMK20HkE7hq
	 usgEtXdXyN3xJ57Qnvm3hW1ulHX8vwhHR6gjLNPfv2x86+UoPKqdyMfPuR3VPbiKHf
	 /DVtZKklzgOLoG16EjgDOwNDEQIHfI87Iox6ZZxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/378] drm/msm/dpu: Fix LM size on a number of platforms
Date: Tue, 17 Mar 2026 17:29:44 +0100
Message-ID: <20260317163007.977114861@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit f7bf1319739291067b2bc4b22bd56336afad8f0a ]

The register space has grown with what seems to be DPU8.
Bump up the .len to match.

Fixes: e3b1f369db5a ("drm/msm/dpu: Add X1E80100 support")
Fixes: 4a352c2fc15a ("drm/msm/dpu: Introduce SC8280XP")
Fixes: efcd0107727c ("drm/msm/dpu: add support for SM8550")
Fixes: 100d7ef6995d ("drm/msm/dpu: add support for SM8450")
Fixes: 178575173472 ("drm/msm/dpu: add catalog entry for SAR2130P")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/701063/
Link: https://lore.kernel.org/r/20260127-topic-lm_size_fix-v1-1-25f88d014dfd@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h | 12 ++++++------
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h   | 12 ++++++------
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h   | 12 ++++++------
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h | 12 ++++++------
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h | 12 ++++++------
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h
index 303d33dc7783a..9f2bceca1789e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h
@@ -133,7 +133,7 @@ static const struct dpu_sspp_cfg sc8280xp_sspp[] = {
 static const struct dpu_lm_cfg sc8280xp_lm[] = {
 	{
 		.name = "lm_0", .id = LM_0,
-		.base = 0x44000, .len = 0x320,
+		.base = 0x44000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_1,
@@ -141,7 +141,7 @@ static const struct dpu_lm_cfg sc8280xp_lm[] = {
 		.dspp = DSPP_0,
 	}, {
 		.name = "lm_1", .id = LM_1,
-		.base = 0x45000, .len = 0x320,
+		.base = 0x45000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_0,
@@ -149,7 +149,7 @@ static const struct dpu_lm_cfg sc8280xp_lm[] = {
 		.dspp = DSPP_1,
 	}, {
 		.name = "lm_2", .id = LM_2,
-		.base = 0x46000, .len = 0x320,
+		.base = 0x46000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
@@ -157,7 +157,7 @@ static const struct dpu_lm_cfg sc8280xp_lm[] = {
 		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
+		.base = 0x47000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
@@ -165,14 +165,14 @@ static const struct dpu_lm_cfg sc8280xp_lm[] = {
 		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
+		.base = 0x48000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_4,
 	}, {
 		.name = "lm_5", .id = LM_5,
-		.base = 0x49000, .len = 0x320,
+		.base = 0x49000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_4,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
index b09a6af4c474a..04b22167f93d6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
@@ -134,7 +134,7 @@ static const struct dpu_sspp_cfg sm8450_sspp[] = {
 static const struct dpu_lm_cfg sm8450_lm[] = {
 	{
 		.name = "lm_0", .id = LM_0,
-		.base = 0x44000, .len = 0x320,
+		.base = 0x44000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_1,
@@ -142,7 +142,7 @@ static const struct dpu_lm_cfg sm8450_lm[] = {
 		.dspp = DSPP_0,
 	}, {
 		.name = "lm_1", .id = LM_1,
-		.base = 0x45000, .len = 0x320,
+		.base = 0x45000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_0,
@@ -150,7 +150,7 @@ static const struct dpu_lm_cfg sm8450_lm[] = {
 		.dspp = DSPP_1,
 	}, {
 		.name = "lm_2", .id = LM_2,
-		.base = 0x46000, .len = 0x320,
+		.base = 0x46000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
@@ -158,7 +158,7 @@ static const struct dpu_lm_cfg sm8450_lm[] = {
 		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
+		.base = 0x47000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
@@ -166,14 +166,14 @@ static const struct dpu_lm_cfg sm8450_lm[] = {
 		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
+		.base = 0x48000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_4,
 	}, {
 		.name = "lm_5", .id = LM_5,
-		.base = 0x49000, .len = 0x320,
+		.base = 0x49000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_4,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
index 465b6460f8754..4c7eb55d474c5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h
@@ -131,7 +131,7 @@ static const struct dpu_sspp_cfg sm8550_sspp[] = {
 static const struct dpu_lm_cfg sm8550_lm[] = {
 	{
 		.name = "lm_0", .id = LM_0,
-		.base = 0x44000, .len = 0x320,
+		.base = 0x44000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_1,
@@ -139,7 +139,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.dspp = DSPP_0,
 	}, {
 		.name = "lm_1", .id = LM_1,
-		.base = 0x45000, .len = 0x320,
+		.base = 0x45000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_0,
@@ -147,7 +147,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.dspp = DSPP_1,
 	}, {
 		.name = "lm_2", .id = LM_2,
-		.base = 0x46000, .len = 0x320,
+		.base = 0x46000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
@@ -155,7 +155,7 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
+		.base = 0x47000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
@@ -163,14 +163,14 @@ static const struct dpu_lm_cfg sm8550_lm[] = {
 		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
+		.base = 0x48000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_4,
 	}, {
 		.name = "lm_5", .id = LM_5,
-		.base = 0x49000, .len = 0x320,
+		.base = 0x49000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_4,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h
index 6caa7d40f3688..dec83ea8167d1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_1_sar2130p.h
@@ -131,7 +131,7 @@ static const struct dpu_sspp_cfg sar2130p_sspp[] = {
 static const struct dpu_lm_cfg sar2130p_lm[] = {
 	{
 		.name = "lm_0", .id = LM_0,
-		.base = 0x44000, .len = 0x320,
+		.base = 0x44000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_1,
@@ -139,7 +139,7 @@ static const struct dpu_lm_cfg sar2130p_lm[] = {
 		.dspp = DSPP_0,
 	}, {
 		.name = "lm_1", .id = LM_1,
-		.base = 0x45000, .len = 0x320,
+		.base = 0x45000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_0,
@@ -147,7 +147,7 @@ static const struct dpu_lm_cfg sar2130p_lm[] = {
 		.dspp = DSPP_1,
 	}, {
 		.name = "lm_2", .id = LM_2,
-		.base = 0x46000, .len = 0x320,
+		.base = 0x46000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
@@ -155,7 +155,7 @@ static const struct dpu_lm_cfg sar2130p_lm[] = {
 		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
+		.base = 0x47000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
@@ -163,14 +163,14 @@ static const struct dpu_lm_cfg sar2130p_lm[] = {
 		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
+		.base = 0x48000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_4,
 	}, {
 		.name = "lm_5", .id = LM_5,
-		.base = 0x49000, .len = 0x320,
+		.base = 0x49000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_4,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
index 7243eebb85f36..52ff4baa668a4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
@@ -130,7 +130,7 @@ static const struct dpu_sspp_cfg x1e80100_sspp[] = {
 static const struct dpu_lm_cfg x1e80100_lm[] = {
 	{
 		.name = "lm_0", .id = LM_0,
-		.base = 0x44000, .len = 0x320,
+		.base = 0x44000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_1,
@@ -138,7 +138,7 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.dspp = DSPP_0,
 	}, {
 		.name = "lm_1", .id = LM_1,
-		.base = 0x45000, .len = 0x320,
+		.base = 0x45000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_0,
@@ -146,7 +146,7 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.dspp = DSPP_1,
 	}, {
 		.name = "lm_2", .id = LM_2,
-		.base = 0x46000, .len = 0x320,
+		.base = 0x46000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
@@ -154,7 +154,7 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
-		.base = 0x47000, .len = 0x320,
+		.base = 0x47000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
@@ -162,14 +162,14 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
-		.base = 0x48000, .len = 0x320,
+		.base = 0x48000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_5,
 		.pingpong = PINGPONG_4,
 	}, {
 		.name = "lm_5", .id = LM_5,
-		.base = 0x49000, .len = 0x320,
+		.base = 0x49000, .len = 0x400,
 		.features = MIXER_MSM8998_MASK,
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_4,
-- 
2.51.0



