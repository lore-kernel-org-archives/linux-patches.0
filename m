Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6099556C637;
	Wed,  9 Sep 2026 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962778; cv=none; b=ifElxSx1Rw30ST4Q1PnrNgLFRbe+Mqr9cfGu790MxgtpuaOI4xTl7by6Xw0T7I2upUAILOeCho4p3UuM1GLWxd34IcujYWvBFiGvEpXc8FNDkJ29dHFNcxLX7GzT98F192KhjNAduvr6yJEYfRka9Iz4912pKISJq7yXjWPETxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962778; c=relaxed/simple;
	bh=ud45T70d+vYUuHXQKCuaqFSvUZyxDGdEaBTjuT1b65Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fhniefwy16NYHfYYyiA4VSQGodfN/chsJtTGYgA67cztPn5ud903WRqLTh+CIiX0m9YT5SXTLnHKXb76/lMuNf39fK3z6ACvQzhRA6TMdnKqYUCcBNbVH77EMrFif31KzlUPkqPwspBZcdal8NyB1gIxgiNFY7PTiRaMu6PMuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kr6xpaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kr6xpaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB84F1F00A3A;
	Wed,  9 Sep 2026 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962777;
	bh=OK4qB7vq3QKf8mNQrbVVnZUOPinS0Ac0KPqNpyT+qL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kr6xpaaXyCNlqjFqPZ+bsYzV8dW2p2GGrXFrU/UeHoiMHIiTS3AfiOYxVeDRsvJ4
	 KKQTPixKwsoOK9w90vyU2h91SDyBXjcMHBOGhiItQH11YMSjJDaW+q7yW5xdYSnoL2
	 JRocAwH2R5cVpbPgKl/VTujARiRGH18K8xGqDxjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Wangao Wang <wangao.wang@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.2 408/556] media: qcom: iris: fix missing hfi_id in gen1 GOP_SIZE cap
Date: Wed,  9 Sep 2026 15:41:28 +0200
Message-ID: <20260909134244.978199421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wangao Wang <wangao.wang@oss.qualcomm.com>

commit 5eebacbc9a38e1019854ea5f86e367a4d5116387 upstream.

Add hfi_id to gen1 encoder GOP_SIZE cap and replace the set function,
remove the redundant INTRA_PERIOD cap.

Fixes: d22037f3fd33 ("media: iris: Set platform capabilities to firmware for encoder video device")

Reviewed-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Wangao Wang <wangao.wang@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_ctrls.c           |    2 +-
 drivers/media/platform/qcom/iris/iris_hfi_gen1.c        |   16 ++++------------
 drivers/media/platform/qcom/iris/iris_platform_common.h |    1 -
 3 files changed, 5 insertions(+), 14 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_ctrls.c
+++ b/drivers/media/platform/qcom/iris/iris_ctrls.c
@@ -1293,7 +1293,7 @@ int iris_set_use_and_mark_ltr(struct iri
 int iris_set_intra_period(struct iris_inst *inst, enum platform_inst_fw_cap_type cap_id)
 {
 	const struct iris_hfi_session_ops *hfi_ops = inst->hfi_session_ops;
-	u32 gop_size = inst->fw_caps[GOP_SIZE].value;
+	u32 gop_size = inst->fw_caps[cap_id].value;
 	u32 b_frame = inst->fw_caps[B_FRAME].value;
 	u32 hfi_id = inst->fw_caps[cap_id].hfi_id;
 	struct hfi_intra_period intra_period;
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1.c
@@ -171,7 +171,9 @@ static const struct platform_inst_fw_cap
 		.max = (1 << 16) - 1,
 		.step_or_mask = 1,
 		.value = 30,
-		.set = iris_set_u32
+		.hfi_id = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD,
+		.flags = CAP_FLAG_OUTPUT_PORT,
+		.set = iris_set_intra_period,
 	},
 	{
 		.cap_id = ENTROPY_MODE,
@@ -240,7 +242,7 @@ static const struct platform_inst_fw_cap
 		.step_or_mask = 1,
 		.value = 0,
 		.hfi_id = HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH,
-		.flags = CAP_FLAG_OUTPUT_PORT,
+		.flags = CAP_FLAG_OUTPUT_PORT | CAP_FLAG_DYNAMIC_ALLOWED,
 		.set = iris_set_ir_period_gen1,
 	},
 	{
@@ -282,16 +284,6 @@ static const struct platform_inst_fw_cap
 		.flags = CAP_FLAG_OUTPUT_PORT,
 	},
 	{
-		.cap_id = INTRA_PERIOD,
-		.min = 0,
-		.max = 1,
-		.step_or_mask = 1,
-		.value = 0,
-		.hfi_id = HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD,
-		.flags = CAP_FLAG_OUTPUT_PORT,
-		.set = iris_set_intra_period,
-	},
-	{
 		.cap_id = LAYER_ENABLE,
 		.min = 0,
 		.max = 1,
--- a/drivers/media/platform/qcom/iris/iris_platform_common.h
+++ b/drivers/media/platform/qcom/iris/iris_platform_common.h
@@ -165,7 +165,6 @@ enum platform_inst_fw_cap_type {
 	USE_LTR,
 	MARK_LTR,
 	B_FRAME,
-	INTRA_PERIOD,
 	LAYER_ENABLE,
 	LAYER_TYPE_H264,
 	LAYER_TYPE_HEVC,


