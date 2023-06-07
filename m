Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CE710FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB7C433EF;
	Wed,  7 Jun 2023 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169580;
	bh=9XuyVdHschitaFjv1IRmhakUiZ7udiWU8DqDINx/jd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU7Y/1VZNOwO6XvikFjSeTYKpmKwdWLRxd4kl7CQaysrlo9ApJAOHx9I+QKvWSDKV
	 bq5EyTrkJrbba/ESyhqGD7L5R4KFUppsCFykEYvPs1uvGaluDNDTFZjVB9PxfpFjnX
	 xLlYksL/KxO+W/ljS/2XjUc5iPc/mESig7Q2I/kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thong Thai <thong.thai@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 105/286] drm/amdgpu/nv: update VCN 3 max HEVC encoding resolution
Date: Wed,  7 Jun 2023 22:13:24 +0200
Message-ID: <20230607200926.497971357@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thong Thai <thong.thai@amd.com>

[ Upstream commit 476ac50fc30540e29191615a26aaf5f9dee91c49 ]

Update the maximum resolution reported for HEVC encoding on VCN 3
devices to reflect its 8K encoding capability.

v2: Also update the max height for H.264 encoding to match spec.
(Ruijing)

Signed-off-by: Thong Thai <thong.thai@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index ebe0e2d7dbd1b..aa7f82b3fd6a9 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -98,6 +98,16 @@ static const struct amdgpu_video_codecs nv_video_codecs_decode =
 };
 
 /* Sienna Cichlid */
+static const struct amdgpu_video_codec_info sc_video_codecs_encode_array[] = {
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2160, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 7680, 4352, 0)},
+};
+
+static const struct amdgpu_video_codecs sc_video_codecs_encode = {
+	.codec_count = ARRAY_SIZE(sc_video_codecs_encode_array),
+	.codec_array = sc_video_codecs_encode_array,
+};
+
 static const struct amdgpu_video_codec_info sc_video_codecs_decode_array_vcn0[] =
 {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
@@ -136,8 +146,8 @@ static const struct amdgpu_video_codecs sc_video_codecs_decode_vcn1 =
 /* SRIOV Sienna Cichlid, not const since data is controlled by host */
 static struct amdgpu_video_codec_info sriov_sc_video_codecs_encode_array[] =
 {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2160, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 7680, 4352, 0)},
 };
 
 static struct amdgpu_video_codec_info sriov_sc_video_codecs_decode_array_vcn0[] =
@@ -237,12 +247,12 @@ static int nv_query_video_codecs(struct amdgpu_device *adev, bool encode,
 		} else {
 			if (adev->vcn.harvest_config & AMDGPU_VCN_HARVEST_VCN0) {
 				if (encode)
-					*codecs = &nv_video_codecs_encode;
+					*codecs = &sc_video_codecs_encode;
 				else
 					*codecs = &sc_video_codecs_decode_vcn1;
 			} else {
 				if (encode)
-					*codecs = &nv_video_codecs_encode;
+					*codecs = &sc_video_codecs_encode;
 				else
 					*codecs = &sc_video_codecs_decode_vcn0;
 			}
@@ -251,14 +261,14 @@ static int nv_query_video_codecs(struct amdgpu_device *adev, bool encode,
 	case IP_VERSION(3, 0, 16):
 	case IP_VERSION(3, 0, 2):
 		if (encode)
-			*codecs = &nv_video_codecs_encode;
+			*codecs = &sc_video_codecs_encode;
 		else
 			*codecs = &sc_video_codecs_decode_vcn0;
 		return 0;
 	case IP_VERSION(3, 1, 1):
 	case IP_VERSION(3, 1, 2):
 		if (encode)
-			*codecs = &nv_video_codecs_encode;
+			*codecs = &sc_video_codecs_encode;
 		else
 			*codecs = &yc_video_codecs_decode;
 		return 0;
-- 
2.39.2



