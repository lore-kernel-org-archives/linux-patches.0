Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0242321D00E;
	Tue, 26 Aug 2025 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207372; cv=none; b=DEASzFds4+kSbfbcGl6LjX1DhgKOBf9OVOWAxjl/0l6A2d5TtqeTi/UHlap9bVMgvMvaxOLukSjAheGnDSt+lUANlkKmhwHxGFa7M9iY4eZx6cUKgCioW+Z/zrrSYgGdPGhflyq/bs0bK/Kq8D78ApOpVh/JcHkPaI4VNg2fHxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207372; c=relaxed/simple;
	bh=No7uQammdHQrXl18y69rNG4PX3NNftbYB7dw2mWtNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2iBW25Bm0fM02PRcGimcPZc9NyPM9ActZbynMsg5CIZQBLky0+qhWDANKI+SOhFo2Ghz3ftoN23Mvwn4iSvUxDf56WttUwMOtswg514mq4nZh5AXPn1qA0nSb0FeC7026K9GxlBAtgP7r6kPGCqrjw2OdsJi9h4742vMQY/eXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSyQg+zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSyQg+zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E13AC4CEF1;
	Tue, 26 Aug 2025 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207371;
	bh=No7uQammdHQrXl18y69rNG4PX3NNftbYB7dw2mWtNOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSyQg+zSPgrbYSU62ZBNsyX691nzKFgEDBHSTkht5qLFWZkm2SfTFeb3op1xMc9Pj
	 dIqUT2DQaWd3U/6FcHmU08c9m0laoggC6ScYWA4m8/trpDm7O/GQRYosVLML1PBZu1
	 /5XX0mrtTlPBDToRFb5v/Putn2AdzpajFGlMu7r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 157/457] media: iris: Fix typo in depth variable
Date: Tue, 26 Aug 2025 13:07:21 +0200
Message-ID: <20250826110941.254162892@linuxfoundation.org>
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

commit 58edc8a68de7af45a4c815636595daa530f02c13 upstream.

Correct a typo from "dpeth" to "depth".

Cc: stable@vger.kernel.org
Fixes: 3a19d7b9e08b ("media: iris: implement set properties to firmware during streamon")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
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
 drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
index a908b41e2868..802fa62c26eb 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
@@ -178,7 +178,7 @@ static int iris_hfi_gen2_set_crop_offsets(struct iris_inst *inst)
 						  sizeof(u64));
 }
 
-static int iris_hfi_gen2_set_bit_dpeth(struct iris_inst *inst)
+static int iris_hfi_gen2_set_bit_depth(struct iris_inst *inst)
 {
 	struct iris_inst_hfi_gen2 *inst_hfi_gen2 = to_iris_inst_hfi_gen2(inst);
 	u32 port = iris_hfi_gen2_get_port(V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
@@ -378,7 +378,7 @@ static int iris_hfi_gen2_session_set_config_params(struct iris_inst *inst, u32 p
 		{HFI_PROP_BITSTREAM_RESOLUTION,       iris_hfi_gen2_set_bitstream_resolution   },
 		{HFI_PROP_CROP_OFFSETS,               iris_hfi_gen2_set_crop_offsets           },
 		{HFI_PROP_CODED_FRAMES,               iris_hfi_gen2_set_coded_frames           },
-		{HFI_PROP_LUMA_CHROMA_BIT_DEPTH,      iris_hfi_gen2_set_bit_dpeth              },
+		{HFI_PROP_LUMA_CHROMA_BIT_DEPTH,      iris_hfi_gen2_set_bit_depth              },
 		{HFI_PROP_BUFFER_FW_MIN_OUTPUT_COUNT, iris_hfi_gen2_set_min_output_count       },
 		{HFI_PROP_PIC_ORDER_CNT_TYPE,         iris_hfi_gen2_set_picture_order_count    },
 		{HFI_PROP_SIGNAL_COLOR_INFO,          iris_hfi_gen2_set_colorspace             },
-- 
2.50.1



