Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2B346AFB;
	Fri,  7 Aug 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114535; cv=none; b=YoyNuSDaaOix69TD1CfgOe46phtwxqM2+EPdguBapxu+2O++pCIcY0yQ1TACDd0pHVx0MMUkOZXKlaxofk4+wu6e8vVWjiwWVHLM3WfS2ZsHSCD8nYNqv58JfoelZDIK0i+oO1vLTj3aZMmvSlBRpcCSb0J3nzbAcGikWwUUw8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114535; c=relaxed/simple;
	bh=/T5H7Jph2yg7JXC1hGsr8C9M7/q1uexNPN2gfXvNQWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjRmYnuxx4PLWPSZUvLjWW48NH3L5t8rdNVIUPqO+CTQRsNLDTdyG0W95xXzwBHNP5EZYqRKU3j/pJF+Q7uHrvIR5r8Dh8J0IYNco4304IXEyFNyj7dHjW3nz+QrZVCE9Xsrl/QEy9PAs787GDf1cf82XYhddlzKPvigmk8p5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVIRimYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVIRimYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FD1F00A3E;
	Fri,  7 Aug 2026 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114533;
	bh=g1w54/LUFY6zzxrJzc2ESi4xURkqKlVAdT5df1a8KtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVIRimYwojCE7AXddwEt6avbmL1GJQ59Uo8oi77OfBp8tuBtZO9ASEROCWRlYjs/p
	 TAcC7dKH9ytr9ugvhDYlf9k+VWjc2knp1hElY2b8lDzQbH1+xm3f4TDDzk6o3RYjFR
	 8sEKSplOf0sh1lkAzQ8MAT+35cKrrIVCqWEjsfCQ=
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
Subject: [PATCH 6.12 296/337] media: chips-media: wave5: Support CBP profile
Date: Fri,  7 Aug 2026 16:38:19 +0200
Message-ID: <20260807143424.943863586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1753,6 +1753,9 @@ int wave5_vpu_enc_init_seq(struct vpu_in
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
@@ -906,6 +906,8 @@ static int wave5_vpu_enc_s_ctrl(struct v
 		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
 			inst->enc_param.profile = H264_PROFILE_BP;
 			inst->bit_depth = 8;
+			if (ctrl->val == V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE)
+				inst->enc_param.constraint_set1_flag = 1;
 			break;
 		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
 			inst->enc_param.profile = H264_PROFILE_MP;
@@ -1168,6 +1170,7 @@ static void wave5_set_enc_openparam(stru
 			open_param->wave_param.intra_period = input.avc_idr_period;
 		}
 	} else {
+		open_param->wave_param.constraint_set1_flag = input.constraint_set1_flag;
 		open_param->wave_param.avc_idr_period = input.avc_idr_period;
 	}
 	open_param->wave_param.entropy_coding_mode = input.entropy_coding_mode;
@@ -1631,7 +1634,7 @@ static int wave5_vpu_open_enc(struct fil
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
@@ -568,6 +568,7 @@ struct enc_wave_param {
 	u32 lambda_scaling_enable: 1; /* enable lambda scaling using custom GOP */
 	u32 transform8x8_enable: 1; /* enable 8x8 intra prediction and 8x8 transform */
 	u32 mb_level_rc_enable: 1; /* enable MB-level rate control */
+	u32 constraint_set1_flag: 1; /* enable CBP */
 };
 
 struct enc_open_param {


