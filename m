Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EE83019BA;
	Fri,  7 Aug 2026 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115697; cv=none; b=CKgR4/ieim1nZVWq/JTxjyTvziJ3mZKZ4Qx13fkJ0lQ95UG033JTxqg+mB8ZU3YspBHSLof6YCMHpEOmXVS+5sH/dafewag21ixQQm+ktiaFvT+b0dnSRIN/d04ov5145OiMdeNHb/+7gD7AgpywllTbuHhbToU6wfaHc9xvVQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115697; c=relaxed/simple;
	bh=3rEeOJm7QrmgiN2SMrqbDrA+SIYOeWE9YVpGzLPJuSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5PyBn+OdgdughUcMiE7HANSQMzZdvleem18FzA2sHEH5VxISdpNryo1+soxwDdXStAUhDv79PpAGxxezKwqymn5N3GUZ9ox/UrzhGARpKgvMUTkaEyIRIrl97qMJEaM+iUKwt3jPsT6F5EVWuPkq5F4nQ9ve0gc0RO1kiiu62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZI5xOtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZI5xOtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574F51F000E9;
	Fri,  7 Aug 2026 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115695;
	bh=ta7K3jS5UGqsNOMjxfUHdicibsark1jTQJyo4xqOU8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZI5xOtAJcnTG97M3uHU8CIpoM5QIMI8MPS3LEbmKnUPzHQWyozyT34N5Wwrwo/zl
	 1fcB52Lk6H0SBPZH9veH1ckJMqXMurzPzBwFaFbDXe3muEAMVXHCPqHUkRIRaEE3Io
	 eFQsxMel56wvNeHeXG6Ed+hiL0WyGpvmprKWPO/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/396] media: chips-media: wave5: Support CBP profile
Date: Fri,  7 Aug 2026 16:38:46 +0200
Message-ID: <20260807143432.175541118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

[ Upstream commit f8505f9d6b223a26854003bfdba1a0772457886d ]

Constrained Baseline Profile (CBP) and Baseline Profile (BP) have been
treated as the same.
Introduce the ability to differentiate between the two.

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Tested-by: Brandon Brnich <b-brnich@ti.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-hw.c      |    3 +++
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c |    5 ++++-
 drivers/media/platform/chips-media/wave5/wave5-vpuapi.h  |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-hw.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-hw.c
@@ -1762,6 +1762,9 @@ int wave5_vpu_enc_init_seq(struct vpu_in
 			(p_param->skip_intra_trans << 25) |
 			(p_param->strong_intra_smooth_enable << 27) |
 			(p_param->en_still_picture << 30);
+	else if (inst->std == W_AVC_ENC)
+		reg_val |= (p_param->constraint_set1_flag << 29);
+
 	vpu_write_reg(inst->dev, W5_CMD_ENC_SEQ_SPS_PARAM, reg_val);
 
 	reg_val = (p_param->lossless_enable) |
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -915,6 +915,8 @@ static int wave5_vpu_enc_s_ctrl(struct v
 		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
 			inst->enc_param.profile = H264_PROFILE_BP;
 			inst->bit_depth = 8;
+			if (ctrl->val == V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE)
+				inst->enc_param.constraint_set1_flag = 1;
 			break;
 		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
 			inst->enc_param.profile = H264_PROFILE_MP;
@@ -1190,6 +1192,7 @@ static int wave5_set_enc_openparam(struc
 			open_param->wave_param.intra_period = input.avc_idr_period;
 		}
 	} else {
+		open_param->wave_param.constraint_set1_flag = input.constraint_set1_flag;
 		open_param->wave_param.avc_idr_period = input.avc_idr_period;
 	}
 	open_param->wave_param.entropy_coding_mode = input.entropy_coding_mode;
@@ -1662,7 +1665,7 @@ static int wave5_vpu_open_enc(struct fil
 			  -6, 6, 1, 0);
 	v4l2_ctrl_new_std(v4l2_ctrl_hdl, &wave5_vpu_enc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM,
-			  0, 1, 1, 1);
+			  0, 1, 1, 0);
 	v4l2_ctrl_new_std(v4l2_ctrl_hdl, &wave5_vpu_enc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION,
 			  0, 1, 1, 0);
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.h
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.h
@@ -570,6 +570,7 @@ struct enc_wave_param {
 	u32 transform8x8_enable: 1; /* enable 8x8 intra prediction and 8x8 transform */
 	u32 mb_level_rc_enable: 1; /* enable MB-level rate control */
 	u32 forced_idr_header_enable: 1; /* enable header encoding before IDR frame */
+	u32 constraint_set1_flag: 1; /* enable CBP */
 };
 
 struct enc_open_param {


