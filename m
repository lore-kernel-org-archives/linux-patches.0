Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEDE3F44DF;
	Fri, 15 May 2026 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862513; cv=none; b=la/8EeqQ4jLWOfOTpgQ6GBpYtAGgY+3sOOwqf7hkAN94If3ORhJfjUF9Vozu6xAULAiUURPgjokqcDRAvCpaI78ETyl8MCbcYOY1+h6pe6gC/kPu3YWGWr/kpuQ2Q6JgEM6Gs27i/z67Q1E6MLpHjuITSgrT49lOlfabmJUi33k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862513; c=relaxed/simple;
	bh=csRhlZ+IlV/f0+fgxlAClFIGJw6v2mRmbYVPvMWf5Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBy2NlcLtuvt2SSScskLZu/K1AKm+GLcoGFsA6D24zwJGcOR/IDST5FShjduuDAjmg4XL70HHNehZe3u732+N+HYhNYMSxoWYjz9/ad+EQ26SpFSFVMZX3gxznR4/eaMJ9Wz+LUZhBZSazTkBcXF30e9ItB8K7p/QnLI/F6jzMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7Ygt4GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7Ygt4GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335EBC2BCB0;
	Fri, 15 May 2026 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862513;
	bh=csRhlZ+IlV/f0+fgxlAClFIGJw6v2mRmbYVPvMWf5Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7Ygt4GFB9+rqSPoWhtlhd8VRxayknSXrYhBbQyY/LpNQtvZ52CgBU+/o0iOth0Nc
	 kSCHI4+V85h/YCVpbsdnoSDhcr1mrWahTsJ5s+ZU7BeutUBc+J5c01Zj88BgwbtNTV
	 GcrjscK+5iyyJupBJYBlEF1hrwf1QxeHHYg1GreY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 076/201] media: qcom: iris: increase H265D_MAX_SLICE to fix H.265 decoding on SC7280
Date: Fri, 15 May 2026 17:48:14 +0200
Message-ID: <20260515154700.179775521@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

commit 3e0b2053751657ed2924adfe3ff25b1450231e33 upstream.

Follow the commit bfe1326573ff ("venus: Fix for H265 decoding failure.")
and increase H265D_MAX_SLICE following firmware requirements on that
platform. Otherwise decoding of the H.265 streams fails with the
"insufficient scratch_1 buffer size" from the firmware.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
[bod: Fixed commit log withthe => with the]
Fixes: e1f5d32608ec ("media: iris: Add internal buffer calculation for HEVC and VP9 decoders")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_buffer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/iris_vpu_buffer.h
+++ b/drivers/media/platform/qcom/iris/iris_vpu_buffer.h
@@ -67,7 +67,7 @@ struct iris_inst;
 #define SIZE_DOLBY_RPU_METADATA (41 * 1024)
 #define H264_CABAC_HDR_RATIO_HD_TOT	1
 #define H264_CABAC_RES_RATIO_HD_TOT	3
-#define H265D_MAX_SLICE	1200
+#define H265D_MAX_SLICE	3600
 #define SIZE_H265D_HW_PIC_T SIZE_H264D_HW_PIC_T
 #define H265_CABAC_HDR_RATIO_HD_TOT 2
 #define H265_CABAC_RES_RATIO_HD_TOT 2


