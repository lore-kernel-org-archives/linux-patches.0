Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1FD1AA1C3;
	Wed, 20 Nov 2024 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107553; cv=none; b=PaNXV3FaiENGQV3H9JxHEsmCZFrfyZnIqgsrwlFWYZuLIjwYgNetiwrPf5D+g8L/+1LbAi2IGXPqEsuON2TF1S3W99s5ECv9G2SwzwokRzGnt8dTjRTKH/3KvXvWXV5Ktc45uYUJTEy6BIOXemFHqzTTYjFhfxB4PMEu0J50r6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107553; c=relaxed/simple;
	bh=8/zKHBZ8mJuwovPq7IY9Obe5R3JP33TRKIp2fTgpcyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwfvUj0aw9WGid02Tfy77HGUL8ZXLw09JFncLDgiHyxq8i3uQbUfxploZnPuaew5zVCVeaWAfe8c6mfxSbBNBBDZtHIhRsktbDe/b5GYhMH8z+vyIpxtjyFllZx5Oca3YLBfgAkOyfAS5x5O+yX2j3bGTu02t9DBdwI+2AaqmEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6mSl+lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6mSl+lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECB5C4CECD;
	Wed, 20 Nov 2024 12:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107553;
	bh=8/zKHBZ8mJuwovPq7IY9Obe5R3JP33TRKIp2fTgpcyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6mSl+luwXxOeR22cLAWK4InOELXM1HICLLmPeYiakSZbQcAUK5E2QUrWdyOOW+mn
	 nRaqh1MB89EVIqqZtZtugxToSTI5R65bBcR0nWwFboS5dvgaOqVt++1Z5Ed1PuWxdv
	 rYwWzsgoMlfda+CjCZJSFeaiYfUNFDM183ZU0Sr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 094/107] drm/amdgpu: Fix video caps for H264 and HEVC encode maximum size
Date: Wed, 20 Nov 2024 13:57:09 +0100
Message-ID: <20241120125631.837852261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit d641a151fcaf0d043075b214b469a14abab25af2 upstream.

H264 supports 4096x4096 starting from Polaris.
HEVC also supports 4096x4096, with VCN 3 and newer 8192x4352
is supported.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 69e9a9e65b1ea542d07e3fdd4222b46e9f5a3a29)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c    |   12 ++++++------
 drivers/gpu/drm/amd/amdgpu/soc15.c |    4 ++--
 drivers/gpu/drm/amd/amdgpu/soc21.c |   12 ++++++------
 drivers/gpu/drm/amd/amdgpu/soc24.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c    |    8 ++++----
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -67,8 +67,8 @@ static const struct amd_ip_funcs nv_comm
 
 /* Navi */
 static const struct amdgpu_video_codec_info nv_video_codecs_encode_array[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 0)},
 };
 
 static const struct amdgpu_video_codecs nv_video_codecs_encode = {
@@ -94,8 +94,8 @@ static const struct amdgpu_video_codecs
 
 /* Sienna Cichlid */
 static const struct amdgpu_video_codec_info sc_video_codecs_encode_array[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2160, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 7680, 4352, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codecs sc_video_codecs_encode = {
@@ -136,8 +136,8 @@ static const struct amdgpu_video_codecs
 
 /* SRIOV Sienna Cichlid, not const since data is controlled by host */
 static struct amdgpu_video_codec_info sriov_sc_video_codecs_encode_array[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2160, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 7680, 4352, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
 static struct amdgpu_video_codec_info sriov_sc_video_codecs_decode_array_vcn0[] = {
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -90,8 +90,8 @@ static const struct amd_ip_funcs soc15_c
 /* Vega, Raven, Arcturus */
 static const struct amdgpu_video_codec_info vega_video_codecs_encode_array[] =
 {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 0)},
 };
 
 static const struct amdgpu_video_codecs vega_video_codecs_encode =
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -49,13 +49,13 @@ static const struct amd_ip_funcs soc21_c
 
 /* SOC21 */
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn0[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn1[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
@@ -96,14 +96,14 @@ static const struct amdgpu_video_codecs
 
 /* SRIOV SOC21, not const since data is controlled by host */
 static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_encode_array_vcn0[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static struct amdgpu_video_codec_info sriov_vcn_4_0_0_video_codecs_encode_array_vcn1[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
 static struct amdgpu_video_codecs sriov_vcn_4_0_0_video_codecs_encode_vcn0 = {
--- a/drivers/gpu/drm/amd/amdgpu/soc24.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc24.c
@@ -48,7 +48,7 @@
 static const struct amd_ip_funcs soc24_common_ip_funcs;
 
 static const struct amdgpu_video_codec_info vcn_5_0_0_video_codecs_encode_array_vcn0[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -136,15 +136,15 @@ static const struct amdgpu_video_codec_i
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC,
 		.max_width = 4096,
-		.max_height = 2304,
-		.max_pixels_per_frame = 4096 * 2304,
+		.max_height = 4096,
+		.max_pixels_per_frame = 4096 * 4096,
 		.max_level = 0,
 	},
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC,
 		.max_width = 4096,
-		.max_height = 2304,
-		.max_pixels_per_frame = 4096 * 2304,
+		.max_height = 4096,
+		.max_pixels_per_frame = 4096 * 4096,
 		.max_level = 0,
 	},
 };


