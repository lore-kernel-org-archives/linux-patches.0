Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D3227599;
	Tue, 26 Aug 2025 11:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207377; cv=none; b=TlewSOXYhVWPTMQ/xP+WO4Q8OeFg66cFvjwHGCo1yTiZx482fZrsoJEpFLgElhMyFI3JobQRl71dlaCps6Ml7urIiAcGFCgNJojvs4DrOd6aDJDMByS9/ujgSMlQLdHkJKb6a0tGWVtLhKM/jwrRRDJXuW6fyrqCJ9Qi36QYsM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207377; c=relaxed/simple;
	bh=vP0+LYKOc3j9V8+rFgHIPJ/NaRz4ylOhMr3x2eWxTt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAymwwHPbNO8P1CdXi97NnXcsXpDr3oU2vk3NY7xytQW4XOXKFRr1a97/YsOa2i3GNs5zeSB6rs4MYtQZhNbufuJ5OyRAM+dOLcNqxGk1569hgU7VHvISoZLOn8WIqrSTphYfbaE3dqzFG6VTh3khoWQRcdY7DBEoe6vNnIdtsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKz5UidR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKz5UidR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCAC4CEF1;
	Tue, 26 Aug 2025 11:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207377;
	bh=vP0+LYKOc3j9V8+rFgHIPJ/NaRz4ylOhMr3x2eWxTt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKz5UidReMsd6USswc3ADKyV9yukXRHG2GV5Qc/8zpbYsFwK4HvpZrwW5pCY7Nseh
	 OLwAsEyYdon8Mf9uALMgD2NDbLCAGXwlZtO6JWKUuzhB6So/hqRZf66+v8gb3VgV0o
	 /heC976cBYtxX5jUN5KEQd6zVdfcHbPoOaP1sxYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 159/457] media: iris: Remove deprecated property setting to firmware
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110941.303433360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit a693b4a3e7a95c010bedef4c8b3122bd8b0961b7 upstream.

HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER is deprecated and no longer
supported on current firmware, remove setting the same to firmware.

Cc: stable@vger.kernel.org
Fixes: 79865252acb6 ("media: iris: enable video driver probe of SM8250 SoC")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_ctrls.c            |    4 ----
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c |    8 --------
 drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h |    1 -
 drivers/media/platform/qcom/iris/iris_platform_common.h  |    2 +-
 drivers/media/platform/qcom/iris/iris_platform_sm8250.c  |    9 ---------
 5 files changed, 1 insertion(+), 23 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_ctrls.c
+++ b/drivers/media/platform/qcom/iris/iris_ctrls.c
@@ -17,8 +17,6 @@ static inline bool iris_valid_cap_id(enu
 static enum platform_inst_fw_cap_type iris_get_cap_id(u32 id)
 {
 	switch (id) {
-	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
-		return DEBLOCK;
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 		return PROFILE;
 	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
@@ -34,8 +32,6 @@ static u32 iris_get_v4l2_id(enum platfor
 		return 0;
 
 	switch (cap_id) {
-	case DEBLOCK:
-		return V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER;
 	case PROFILE:
 		return V4L2_CID_MPEG_VIDEO_H264_PROFILE;
 	case LEVEL:
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -490,14 +490,6 @@ iris_hfi_gen1_packet_session_set_propert
 		packet->shdr.hdr.size += sizeof(u32) + sizeof(*wm);
 		break;
 	}
-	case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER: {
-		struct hfi_enable *en = prop_data;
-		u32 *in = pdata;
-
-		en->enable = *in;
-		packet->shdr.hdr.size += sizeof(u32) + sizeof(*en);
-		break;
-	}
 	default:
 		return -EINVAL;
 	}
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h
@@ -65,7 +65,6 @@
 
 #define HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS		0x202001
 
-#define HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER	0x1200001
 #define HFI_PROPERTY_PARAM_VDEC_DPB_COUNTS		0x120300e
 #define HFI_PROPERTY_CONFIG_VDEC_ENTROPY		0x1204004
 
--- a/drivers/media/platform/qcom/iris/iris_platform_common.h
+++ b/drivers/media/platform/qcom/iris/iris_platform_common.h
@@ -89,7 +89,7 @@ enum platform_inst_fw_cap_type {
 	CODED_FRAMES,
 	BIT_DEPTH,
 	RAP_FRAME,
-	DEBLOCK,
+	TIER,
 	INST_FW_CAP_MAX,
 };
 
--- a/drivers/media/platform/qcom/iris/iris_platform_sm8250.c
+++ b/drivers/media/platform/qcom/iris/iris_platform_sm8250.c
@@ -30,15 +30,6 @@ static struct platform_inst_fw_cap inst_
 		.hfi_id = HFI_PROPERTY_PARAM_WORK_MODE,
 		.set = iris_set_stage,
 	},
-	{
-		.cap_id = DEBLOCK,
-		.min = 0,
-		.max = 1,
-		.step_or_mask = 1,
-		.value = 0,
-		.hfi_id = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER,
-		.set = iris_set_u32,
-	},
 };
 
 static struct platform_inst_caps platform_inst_cap_sm8250 = {


