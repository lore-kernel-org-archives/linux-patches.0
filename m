Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026C2580E4;
	Tue, 25 Mar 2025 12:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906042; cv=none; b=U3M8xHVtCUBFMzwdMmpGg3oZajen7Hc59QKKqv4xG51lWB2DnfrjtGHx0mKBZAF7dcuITXisZ82D7OtFB9ksxYixepFhw5wtCyZOM5ccfohWukeLdyjl7oTamCRvtbxNFnpKetgltzLJKePn19Y+AnYJVyIvJNbF1gy1sXzGRc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906042; c=relaxed/simple;
	bh=+VykZiQq1jTG60HTXRy47xY+SHX0M0JFgYRFy/+nl6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Add/Cdz5TEoivDYrYmkqOcBDc3CYp5SNMheNi4s3bafd1u7TZBC45UnPV1omDZieinxVZM7WJDNAsdZdi8tiVvZmF0CYJ8tv9QoSUYFGV4qGqJ58sB9wWHZQZkIcmuebXpPLHr+9EWPB0luwbcij5fbfgr6VoKDIEhPypKEJ/+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hC1V5WPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hC1V5WPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ABAC4CEE4;
	Tue, 25 Mar 2025 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906042;
	bh=+VykZiQq1jTG60HTXRy47xY+SHX0M0JFgYRFy/+nl6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC1V5WPVkRaGpF57VgRkmKbn6Z1uEAej8WSdtieUPot4eP+ACcrY4twV8HJLI5u4F
	 SPrQCHGmmbSTJxDf+O7L7Lz0GH33h0+Ys6Y42NyZkyjNjwJZa0/NkReDojqGhAbdLs
	 MSp4+hDzsayW/nLL8ePgIyZS1NbTA29t1noA9YF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.13 104/119] drm/amdgpu: Fix MPEG2, MPEG4 and VC1 video caps max size
Date: Tue, 25 Mar 2025 08:22:42 -0400
Message-ID: <20250325122151.712807209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit f0105e173103c9d30a2bb959f7399437d536c848 upstream.

1920x1088 is the maximum supported resolution.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1a0807feb97082bff2b1342dbbe55a2a9a8bdb88)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c    |   18 +++++++++---------
 drivers/gpu/drm/amd/amdgpu/soc15.c |   18 +++++++++---------
 drivers/gpu/drm/amd/amdgpu/vi.c    |   36 ++++++++++++++++++------------------
 3 files changed, 36 insertions(+), 36 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -78,10 +78,10 @@ static const struct amdgpu_video_codecs
 
 /* Navi1x */
 static const struct amdgpu_video_codec_info nv_video_codecs_decode_array[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
@@ -104,10 +104,10 @@ static const struct amdgpu_video_codecs
 };
 
 static const struct amdgpu_video_codec_info sc_video_codecs_decode_array_vcn0[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 16384, 16384, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
@@ -115,10 +115,10 @@ static const struct amdgpu_video_codec_i
 };
 
 static const struct amdgpu_video_codec_info sc_video_codecs_decode_array_vcn1[] = {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 16384, 16384, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -103,10 +103,10 @@ static const struct amdgpu_video_codecs
 /* Vega */
 static const struct amdgpu_video_codec_info vega_video_codecs_decode_array[] =
 {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 186)},
 };
 
@@ -119,10 +119,10 @@ static const struct amdgpu_video_codecs
 /* Raven */
 static const struct amdgpu_video_codec_info rv_video_codecs_decode_array[] =
 {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 4096, 4096, 0)},
@@ -137,10 +137,10 @@ static const struct amdgpu_video_codecs
 /* Renoir, Arcturus */
 static const struct amdgpu_video_codec_info rn_video_codecs_decode_array[] =
 {
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 4096, 4096, 3)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 4096, 4096, 5)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2, 1920, 1088, 3)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4, 1920, 1088, 5)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 16384, 16384, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -167,16 +167,16 @@ static const struct amdgpu_video_codec_i
 {
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 3,
 	},
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 5,
 	},
 	{
@@ -188,9 +188,9 @@ static const struct amdgpu_video_codec_i
 	},
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 4,
 	},
 };
@@ -206,16 +206,16 @@ static const struct amdgpu_video_codec_i
 {
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG2,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 3,
 	},
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 5,
 	},
 	{
@@ -227,9 +227,9 @@ static const struct amdgpu_video_codec_i
 	},
 	{
 		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
+		.max_width = 1920,
+		.max_height = 1088,
+		.max_pixels_per_frame = 1920 * 1088,
 		.max_level = 4,
 	},
 	{


