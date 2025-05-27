Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D151A3159;
	Tue, 27 May 2025 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367537; cv=none; b=PoZw3FUEFkZwAVaOWoBP6oGvPnyp/JpsmHvG8An6QcrkNmnmB42EP7pLP5PUDXVX1J0/yiJuwKXNhagzZ8WcoVADk7eJ76uCTyEBcos9EFg8d/FtLQIzMb3bL2FUhilQHa2YJKs+EM10zach4aeW/cGtjfyrhCoZCuyuh9n8zsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367537; c=relaxed/simple;
	bh=oiHTkNHiJJzo/4+BkbvWHvfYVt50GRFwg1f0ZJDn58M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huZ2mFBX++9vieMoN4ERKF7/ylikZOT2j4DnLk/zAYRUPi5WHwATQm+LzA9G7pAzybMNhBlCE6YJ2RQnnymkT7kVJiQHVyEHPKQBoa7xRRycQauhU/ZD60+q3tKxor+LGmQYoyqE2wVzwiH+MJ78UM1riWTuPfg/EQ/YSxI5zzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IupKLW7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IupKLW7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FDCC4CEE9;
	Tue, 27 May 2025 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367536;
	bh=oiHTkNHiJJzo/4+BkbvWHvfYVt50GRFwg1f0ZJDn58M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IupKLW7bUAZhU+IAH50Qvf/nx/SPjKPh38rnG9IB2Ewkk0xldqc7UsZfa7WuA5Nty
	 AnROdX8funbAcKB992bk3Q9eiUvMXFtg1icUUrNdLGpTetmZBBCuvjuGIT8Mf6FzDY
	 tQojKp5dohXt5np+uM4i3p12doK4u+Z0EXnP0b0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krunoslav Kovac <krunoslav.kovac@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Roman Li <roman.li@amd.com>,
	Robert Mader <robert.mader@collabora.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 412/783] drm/amd/display: Fix BT2020 YCbCr limited/full range input
Date: Tue, 27 May 2025 18:23:29 +0200
Message-ID: <20250527162529.879195954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 07bc2dcbcf403d47d6f305ef7f0d3d489491c5fb ]

[Why]
BT2020 YCbCr input is not handled properly when full range
quantization is used and limited range is not supported at all.

[How]
- Add enums for BT2020 YCbCr limited/full range
- Add limited range CSC matrix

Reviewed-by: Krunoslav Kovac <krunoslav.kovac@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Robert Mader <robert.mader@collabora.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 6 +++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/basics/dc_common.c           | 3 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c       | 5 +++--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c           | 4 ++--
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h                | 4 +++-
 drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c     | 3 ++-
 .../gpu/drm/amd/display/dc/dio/dcn10/dcn10_stream_encoder.c | 3 ++-
 .../amd/display/dc/dio/dcn401/dcn401_dio_stream_encoder.c   | 3 ++-
 .../amd/display/dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c  | 3 ++-
 drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h                 | 6 +++++-
 .../gpu/drm/amd/display/modules/info_packet/info_packet.c   | 4 ++--
 12 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ee79a54de6d19..6c2d79d84feec 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5650,9 +5650,9 @@ fill_plane_color_attributes(const struct drm_plane_state *plane_state,
 
 	case DRM_COLOR_YCBCR_BT2020:
 		if (full_range)
-			*color_space = COLOR_SPACE_2020_YCBCR;
+			*color_space = COLOR_SPACE_2020_YCBCR_FULL;
 		else
-			return -EINVAL;
+			*color_space = COLOR_SPACE_2020_YCBCR_LIMITED;
 		break;
 
 	default:
@@ -6148,7 +6148,7 @@ get_output_color_space(const struct dc_crtc_timing *dc_crtc_timing,
 		if (dc_crtc_timing->pixel_encoding == PIXEL_ENCODING_RGB)
 			color_space = COLOR_SPACE_2020_RGB_FULLRANGE;
 		else
-			color_space = COLOR_SPACE_2020_YCBCR;
+			color_space = COLOR_SPACE_2020_YCBCR_LIMITED;
 		break;
 	case DRM_MODE_COLORIMETRY_DEFAULT: // ITU601
 	default:
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 049046c604626..c7d13e743e6c8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1169,7 +1169,7 @@ static int amdgpu_current_colorspace_show(struct seq_file *m, void *data)
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
 		seq_puts(m, "BT2020_RGB");
 		break;
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
 		seq_puts(m, "BT2020_YCC");
 		break;
 	default:
diff --git a/drivers/gpu/drm/amd/display/dc/basics/dc_common.c b/drivers/gpu/drm/amd/display/dc/basics/dc_common.c
index b2fc4f8e64825..a51c2701da247 100644
--- a/drivers/gpu/drm/amd/display/dc/basics/dc_common.c
+++ b/drivers/gpu/drm/amd/display/dc/basics/dc_common.c
@@ -40,7 +40,8 @@ bool is_rgb_cspace(enum dc_color_space output_color_space)
 	case COLOR_SPACE_YCBCR709:
 	case COLOR_SPACE_YCBCR601_LIMITED:
 	case COLOR_SPACE_YCBCR709_LIMITED:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
+	case COLOR_SPACE_2020_YCBCR_FULL:
 		return false;
 	default:
 		/* Add a case to switch */
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index 1406ee4bff801..4f54e75a8f95b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -176,7 +176,7 @@ static bool is_ycbcr2020_type(
 {
 	bool ret = false;
 
-	if (color_space == COLOR_SPACE_2020_YCBCR)
+	if (color_space == COLOR_SPACE_2020_YCBCR_LIMITED || color_space == COLOR_SPACE_2020_YCBCR_FULL)
 		ret = true;
 	return ret;
 }
@@ -247,7 +247,8 @@ void color_space_to_black_color(
 	case COLOR_SPACE_YCBCR709_BLACK:
 	case COLOR_SPACE_YCBCR601_LIMITED:
 	case COLOR_SPACE_YCBCR709_LIMITED:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
+	case COLOR_SPACE_2020_YCBCR_FULL:
 		*black_color = black_color_format[BLACK_COLOR_FORMAT_YUV_CV];
 		break;
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 298668e9729c7..3367030da3414 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -4247,7 +4247,7 @@ static void set_avi_info_frame(
 		break;
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
 		hdmi_info.bits.EC0_EC2 = COLORIMETRYEX_BT2020RGBYCBCR;
 		hdmi_info.bits.C0_C1   = COLORIMETRY_EXTENDED;
 		break;
@@ -4261,7 +4261,7 @@ static void set_avi_info_frame(
 		break;
 	}
 
-	if (pixel_encoding && color_space == COLOR_SPACE_2020_YCBCR &&
+	if (pixel_encoding && color_space == COLOR_SPACE_2020_YCBCR_LIMITED &&
 			stream->out_transfer_func.tf == TRANSFER_FUNCTION_GAMMA22) {
 		hdmi_info.bits.EC0_EC2 = 0;
 		hdmi_info.bits.C0_C1 = COLORIMETRY_ITU709;
diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index 37e381fc7f02a..d562ddeca5126 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -653,7 +653,8 @@ enum dc_color_space {
 	COLOR_SPACE_YCBCR709_LIMITED,
 	COLOR_SPACE_2020_RGB_FULLRANGE,
 	COLOR_SPACE_2020_RGB_LIMITEDRANGE,
-	COLOR_SPACE_2020_YCBCR,
+	COLOR_SPACE_2020_YCBCR_LIMITED,
+	COLOR_SPACE_2020_YCBCR_FULL,
 	COLOR_SPACE_ADOBERGB,
 	COLOR_SPACE_DCIP3,
 	COLOR_SPACE_DISPLAYNATIVE,
@@ -661,6 +662,7 @@ enum dc_color_space {
 	COLOR_SPACE_APPCTRL,
 	COLOR_SPACE_CUSTOMPOINTS,
 	COLOR_SPACE_YCBCR709_BLACK,
+	COLOR_SPACE_2020_YCBCR = COLOR_SPACE_2020_YCBCR_LIMITED,
 };
 
 enum dc_dither_option {
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
index d199e4ed2e59e..1130d7619b263 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_stream_encoder.c
@@ -418,7 +418,7 @@ static void dce110_stream_encoder_dp_set_stream_attribute(
 			dynamic_range_rgb = 1; /*limited range*/
 			break;
 		case COLOR_SPACE_2020_RGB_FULLRANGE:
-		case COLOR_SPACE_2020_YCBCR:
+		case COLOR_SPACE_2020_YCBCR_LIMITED:
 		case COLOR_SPACE_XR_RGB:
 		case COLOR_SPACE_MSREF_SCRGB:
 		case COLOR_SPACE_ADOBERGB:
@@ -430,6 +430,7 @@ static void dce110_stream_encoder_dp_set_stream_attribute(
 		case COLOR_SPACE_APPCTRL:
 		case COLOR_SPACE_CUSTOMPOINTS:
 		case COLOR_SPACE_UNKNOWN:
+		default:
 			/* do nothing */
 			break;
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_stream_encoder.c
index d01a8b8f95954..22e66b375a7fe 100644
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_stream_encoder.c
@@ -391,7 +391,7 @@ void enc1_stream_encoder_dp_set_stream_attribute(
 		break;
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
 	case COLOR_SPACE_XR_RGB:
 	case COLOR_SPACE_MSREF_SCRGB:
 	case COLOR_SPACE_ADOBERGB:
@@ -404,6 +404,7 @@ void enc1_stream_encoder_dp_set_stream_attribute(
 	case COLOR_SPACE_CUSTOMPOINTS:
 	case COLOR_SPACE_UNKNOWN:
 	case COLOR_SPACE_YCBCR709_BLACK:
+	default:
 		/* do nothing */
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dio/dcn401/dcn401_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dio/dcn401/dcn401_dio_stream_encoder.c
index 098c2a01a8509..9e5072627ec7b 100644
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn401/dcn401_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn401/dcn401_dio_stream_encoder.c
@@ -632,7 +632,7 @@ void enc401_stream_encoder_dp_set_stream_attribute(
 		break;
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
 	case COLOR_SPACE_XR_RGB:
 	case COLOR_SPACE_MSREF_SCRGB:
 	case COLOR_SPACE_ADOBERGB:
@@ -645,6 +645,7 @@ void enc401_stream_encoder_dp_set_stream_attribute(
 	case COLOR_SPACE_CUSTOMPOINTS:
 	case COLOR_SPACE_UNKNOWN:
 	case COLOR_SPACE_YCBCR709_BLACK:
+	default:
 		/* do nothing */
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c
index 678db949cfe3c..759b453385c46 100644
--- a/drivers/gpu/drm/amd/display/dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c
@@ -323,7 +323,7 @@ static void dcn31_hpo_dp_stream_enc_set_stream_attribute(
 		break;
 	case COLOR_SPACE_2020_RGB_LIMITEDRANGE:
 	case COLOR_SPACE_2020_RGB_FULLRANGE:
-	case COLOR_SPACE_2020_YCBCR:
+	case COLOR_SPACE_2020_YCBCR_LIMITED:
 	case COLOR_SPACE_XR_RGB:
 	case COLOR_SPACE_MSREF_SCRGB:
 	case COLOR_SPACE_ADOBERGB:
@@ -336,6 +336,7 @@ static void dcn31_hpo_dp_stream_enc_set_stream_attribute(
 	case COLOR_SPACE_CUSTOMPOINTS:
 	case COLOR_SPACE_UNKNOWN:
 	case COLOR_SPACE_YCBCR709_BLACK:
+	default:
 		/* do nothing */
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h
index 0150f2581ee4c..0c5675d1c5936 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h
@@ -119,10 +119,14 @@ static const struct dpp_input_csc_matrix __maybe_unused dpp_input_csc_matrix[] =
 		{ 0x39a6, 0x2568, 0,      0xe0d6,
 		  0xeedd, 0x2568, 0xf925, 0x9a8,
 		  0,      0x2568, 0x43ee, 0xdbb2 } },
-	{ COLOR_SPACE_2020_YCBCR,
+	{ COLOR_SPACE_2020_YCBCR_FULL,
 		{ 0x2F30, 0x2000, 0,      0xE869,
 		  0xEDB7, 0x2000, 0xFABC, 0xBC6,
 		  0,      0x2000, 0x3C34, 0xE1E6 } },
+	{ COLOR_SPACE_2020_YCBCR_LIMITED,
+		{ 0x35B9, 0x2543, 0,      0xE2B2,
+		  0xEB2F, 0x2543, 0xFA01, 0x0B1F,
+		  0,      0x2543, 0x4489, 0xDB42 } },
 	{ COLOR_SPACE_2020_RGB_LIMITEDRANGE,
 		{ 0x35E0, 0x255F, 0,      0xE2B3,
 		  0xEB20, 0x255F, 0xF9FD, 0xB1E,
diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index a344e2e49b0ea..b3d55cac35694 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -383,10 +383,10 @@ void mod_build_vsc_infopacket(const struct dc_stream_state *stream,
 				colorimetryFormat = ColorimetryYCC_DP_ITU709;
 			else if (cs == COLOR_SPACE_ADOBERGB)
 				colorimetryFormat = ColorimetryYCC_DP_AdobeYCC;
-			else if (cs == COLOR_SPACE_2020_YCBCR)
+			else if (cs == COLOR_SPACE_2020_YCBCR_LIMITED)
 				colorimetryFormat = ColorimetryYCC_DP_ITU2020YCbCr;
 
-			if (cs == COLOR_SPACE_2020_YCBCR && tf == TRANSFER_FUNC_GAMMA_22)
+			if (cs == COLOR_SPACE_2020_YCBCR_LIMITED && tf == TRANSFER_FUNC_GAMMA_22)
 				colorimetryFormat = ColorimetryYCC_DP_ITU709;
 			break;
 
-- 
2.39.5



