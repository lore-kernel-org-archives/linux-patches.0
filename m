Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629CE1FBCB5;
	Tue, 26 Aug 2025 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215045; cv=none; b=SpZxQbyntavzesQjx/G7Fh4kdkO4XrY+M6VFVn9F5QsLCUWyrX5HVK8mvVHg2c/5xft9Ja5D1GvhD3662A12WieuofcJAZBPnYWH2T93prf1Q7JkP8LU3tP5Kw3fPJJjMLGoPH6X/QU6MB0MWefttsGTfZ5+w0koHFmAwfiMg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215045; c=relaxed/simple;
	bh=y9F26Ww+p9yh/T2/HgmkT9+UzNBM2zokm7r1f3M7u5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/gb5BZyvTiBP1byJKTpo6LavDhLj6vLuIOa9B6b2J4zaZnPrv9sYlO6kUod1yY/51xxBvlUqeU/W3fIsYxeMS1k2F7gbBQYWNqpO+0Xs4JBy6td0MuvXl3D3qNyBuaqVurv1t3QCfcQeI4WFyS/BoB6PsXfcD/3CgdY47N69BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0Ilw6z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0Ilw6z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0100C4CEF1;
	Tue, 26 Aug 2025 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215045;
	bh=y9F26Ww+p9yh/T2/HgmkT9+UzNBM2zokm7r1f3M7u5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0Ilw6z1+FyFCM7PX2nmVsuT82UoM68FxzdpGfWCLs+32P0819wQACKtGvVzhYHYU
	 Ybkwz3wZlLW8NBL/15tbrxlqRGHEIs/WPZMEAAALJ9NTfwjJZbsix93pC1VIOz25kA
	 dvgkqKbblHHpH67uiVMVDhpN/ebTzq+89R9FvCos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/482] media: venus: Introduce accessors for remapped hfi_buffer_reqs members
Date: Tue, 26 Aug 2025 13:10:20 +0200
Message-ID: <20250826110939.902081070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit bbfc89e6f67ccb1ddefc3e8a284248bcfea58544 ]

Currently we have macros to access these, but they don't provide a
way to override the remapped fields. Replace the macros with actual
get/set pairs to fix that.

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 06d6770ff0d8 ("media: venus: Fix OOB read due to missing payload bound check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/helpers.c    |    2 
 drivers/media/platform/qcom/venus/hfi_helper.h |   61 +++++++++++++++++++++----
 drivers/media/platform/qcom/venus/hfi_msgs.c   |    2 
 drivers/media/platform/qcom/venus/vdec.c       |    8 +--
 drivers/media/platform/qcom/venus/vdec_ctrls.c |    2 
 drivers/media/platform/qcom/venus/venc.c       |    4 -
 drivers/media/platform/qcom/venus/venc_ctrls.c |    2 
 7 files changed, 63 insertions(+), 18 deletions(-)

--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -189,7 +189,7 @@ int venus_helper_alloc_dpb_bufs(struct v
 	if (ret)
 		return ret;
 
-	count = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+	count = hfi_bufreq_get_count_min(&bufreq, ver);
 
 	for (i = 0; i < count; i++) {
 		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
--- a/drivers/media/platform/qcom/venus/hfi_helper.h
+++ b/drivers/media/platform/qcom/venus/hfi_helper.h
@@ -1150,14 +1150,6 @@ struct hfi_buffer_display_hold_count_act
 	u32 hold_count;
 };
 
-/* HFI 4XX reorder the fields, use these macros */
-#define HFI_BUFREQ_HOLD_COUNT(bufreq, ver)	\
-	((ver) == HFI_VERSION_4XX ? 0 : (bufreq)->hold_count)
-#define HFI_BUFREQ_COUNT_MIN(bufreq, ver)	\
-	((ver) == HFI_VERSION_4XX ? (bufreq)->hold_count : (bufreq)->count_min)
-#define HFI_BUFREQ_COUNT_MIN_HOST(bufreq, ver)	\
-	((ver) == HFI_VERSION_4XX ? (bufreq)->count_min : 0)
-
 struct hfi_buffer_requirements {
 	u32 type;
 	u32 size;
@@ -1169,6 +1161,59 @@ struct hfi_buffer_requirements {
 	u32 alignment;
 };
 
+/* On HFI 4XX, some of the struct members have been swapped. */
+static inline u32 hfi_bufreq_get_hold_count(struct hfi_buffer_requirements *req,
+					    u32 ver)
+{
+	if (ver == HFI_VERSION_4XX)
+		return 0;
+
+	return req->hold_count;
+};
+
+static inline u32 hfi_bufreq_get_count_min(struct hfi_buffer_requirements *req,
+					   u32 ver)
+{
+	if (ver == HFI_VERSION_4XX)
+		return req->hold_count;
+
+	return req->count_min;
+};
+
+static inline u32 hfi_bufreq_get_count_min_host(struct hfi_buffer_requirements *req,
+						u32 ver)
+{
+	if (ver == HFI_VERSION_4XX)
+		return req->count_min;
+
+	return 0;
+};
+
+static inline void hfi_bufreq_set_hold_count(struct hfi_buffer_requirements *req,
+					     u32 ver, u32 val)
+{
+	if (ver == HFI_VERSION_4XX)
+		return;
+
+	req->hold_count = val;
+};
+
+static inline void hfi_bufreq_set_count_min(struct hfi_buffer_requirements *req,
+					    u32 ver, u32 val)
+{
+	if (ver == HFI_VERSION_4XX)
+		req->hold_count = val;
+
+	req->count_min = val;
+};
+
+static inline void hfi_bufreq_set_count_min_host(struct hfi_buffer_requirements *req,
+						 u32 ver, u32 val)
+{
+	if (ver == HFI_VERSION_4XX)
+		req->count_min = val;
+};
+
 struct hfi_data_payload {
 	u32 size;
 	u8 data[1];
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -99,7 +99,7 @@ static void event_seq_changed(struct ven
 		case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS:
 			data_ptr += sizeof(u32);
 			bufreq = (struct hfi_buffer_requirements *)data_ptr;
-			event.buf_count = HFI_BUFREQ_COUNT_MIN(bufreq, ver);
+			event.buf_count = hfi_bufreq_get_count_min(bufreq, ver);
 			data_ptr += sizeof(*bufreq);
 			break;
 		case HFI_INDEX_EXTRADATA_INPUT_CROP:
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -864,13 +864,13 @@ static int vdec_num_buffers(struct venus
 	if (ret)
 		return ret;
 
-	*in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+	*in_num = hfi_bufreq_get_count_min(&bufreq, ver);
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
 	if (ret)
 		return ret;
 
-	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+	*out_num = hfi_bufreq_get_count_min(&bufreq, ver);
 
 	return 0;
 }
@@ -984,14 +984,14 @@ static int vdec_verify_conf(struct venus
 		return ret;
 
 	if (inst->num_output_bufs < bufreq.count_actual ||
-	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_output_bufs < hfi_bufreq_get_count_min(&bufreq, ver))
 		return -EINVAL;
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
 	if (ret)
 		return ret;
 
-	if (inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	if (inst->num_input_bufs < hfi_bufreq_get_count_min(&bufreq, ver))
 		return -EINVAL;
 
 	return 0;
--- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
+++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
@@ -79,7 +79,7 @@ static int vdec_op_g_volatile_ctrl(struc
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
 		ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
 		if (!ret)
-			ctrl->val = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+			ctrl->val = hfi_bufreq_get_count_min(&bufreq, ver);
 		break;
 	default:
 		return -EINVAL;
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1176,7 +1176,7 @@ static int venc_verify_conf(struct venus
 		return ret;
 
 	if (inst->num_output_bufs < bufreq.count_actual ||
-	    inst->num_output_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_output_bufs < hfi_bufreq_get_count_min(&bufreq, ver))
 		return -EINVAL;
 
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
@@ -1184,7 +1184,7 @@ static int venc_verify_conf(struct venus
 		return ret;
 
 	if (inst->num_input_bufs < bufreq.count_actual ||
-	    inst->num_input_bufs < HFI_BUFREQ_COUNT_MIN(&bufreq, ver))
+	    inst->num_input_bufs < hfi_bufreq_get_count_min(&bufreq, ver))
 		return -EINVAL;
 
 	return 0;
--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -358,7 +358,7 @@ static int venc_op_g_volatile_ctrl(struc
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
 		ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
 		if (!ret)
-			ctrl->val = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+			ctrl->val = hfi_bufreq_get_count_min(&bufreq, ver);
 		break;
 	default:
 		return -EINVAL;


