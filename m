Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA16738910E;
	Tue, 10 Mar 2026 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141977; cv=none; b=ZzsrXI8tnEtL3macJplJDjD0w0w3RFNLShocexiFUf6/0FpvoW1qBPiyNN9JYjqhLT5seUrWOXtXvvPcjhyPmuFHwi2PMO9AUcX7MVc9ONPp2SB9SS+63dOXZ/AwImXOOSq6z97XTcdL87ksLl4SPb6tWlk5tZnGR3c9pstbk2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141977; c=relaxed/simple;
	bh=j4cX3fEoxG97NLQBME40wFHwGrUu4HBn1TDsbf/1Mx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjQ3HcnluWDWc2KMtR1W1doTgkiVmtgYsKL5nO0cEniLay3sjw01D+dpsU+9r7i5UgAzR55je9b2PF6p3vn7dAutsRc7VRufOsuM1nJ4g2Mfvqm1c58uEaCk94i0vE7kLQ/lgxQzdFpl3lY2Sler4smc7iD41ORPshe8tB7+8ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJAXaer8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJAXaer8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2D0C2BC86;
	Tue, 10 Mar 2026 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141977;
	bh=j4cX3fEoxG97NLQBME40wFHwGrUu4HBn1TDsbf/1Mx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJAXaer8pJMAaZfj2jtdO/4SJ9usm4V4vOG4TBajx2TE7nkJovwk+imwkoBaVqlKc
	 ByK0qGPC4uK9oV+yC4jfKDEdagnxIQt/WtDr2cAX8IGYnS/pbdQoGxHZgFqsrRCn3w
	 uO8O4cCw0ZsdrlN0njkxXsq6fpPzPI8dXvviS/U6ScHJfFZbIcoptvAoFf3DR0h7Tw
	 eRZc5Z6BOrSHXpF6nWRz6sFDD+QZuHV0ktsVxjjgi13gNX2BPhIvPGqZnnse8d6nzl
	 dyEJuIv9zmltmoVTM47slT3f1kJDfOYW3FqdEmErNP7262og3mkAmscCRwwU8No40W
	 ZGrA3SU2OW3BA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/314] media: iris: Add missing platform data entries for SM8750
Date: Tue, 10 Mar 2026 07:16:01 -0400
Message-ID: <3adaa720ef626f0f46d43a2a8d28e18d12fd48f4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

[ Upstream commit bbef55f414100853d5bcea56a41f8b171bac8fcb ]

Two platform-data fields for SM8750 were missed:

  - get_vpu_buffer_size = iris_vpu33_buf_size
    Without this, the driver fails to allocate the required internal
    buffers, leading to basic decode/encode failures during session
    bring-up.

  - max_core_mbps = ((7680 * 4320) / 256) * 60
    Without this capability exposed, capability checks are incomplete and
    v4l2-compliance for encoder fails.

Fixes: a5925a2ce077 ("media: iris: add VPU33 specific encoding buffer calculation")
Fixes: a6882431a138 ("media: iris: Add support for ENUM_FRAMESIZES/FRAMEINTERVALS for encoder")
Cc: stable@vger.kernel.org
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_platform_gen2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_platform_gen2.c b/drivers/media/platform/qcom/iris/iris_platform_gen2.c
index 36d69cc73986b..85beb80476de8 100644
--- a/drivers/media/platform/qcom/iris/iris_platform_gen2.c
+++ b/drivers/media/platform/qcom/iris/iris_platform_gen2.c
@@ -916,6 +916,7 @@ struct iris_platform_data sm8750_data = {
 	.get_instance = iris_hfi_gen2_get_instance,
 	.init_hfi_command_ops = iris_hfi_gen2_command_ops_init,
 	.init_hfi_response_ops = iris_hfi_gen2_response_ops_init,
+	.get_vpu_buffer_size = iris_vpu33_buf_size,
 	.vpu_ops = &iris_vpu35_ops,
 	.set_preset_registers = iris_set_sm8550_preset_registers,
 	.icc_tbl = sm8550_icc_table,
@@ -946,6 +947,7 @@ struct iris_platform_data sm8750_data = {
 	.num_vpp_pipe = 4,
 	.max_session_count = 16,
 	.max_core_mbpf = NUM_MBS_8K * 2,
+	.max_core_mbps = ((7680 * 4320) / 256) * 60,
 	.dec_input_config_params_default =
 		sm8550_vdec_input_config_params_default,
 	.dec_input_config_params_default_size =
-- 
2.51.0

