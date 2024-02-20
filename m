Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCB514F9C8;
	Tue, 20 Feb 2024 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465016; cv=none; b=Ugg1cYbWzTHkfGX5XG1TE8fArMiymFEbRpb+Gnm0wpbBHcXO0KQO8FogAH3AqFKAlNwDZrhJGs03l4EIW3upCURt9UcCAzKGaPir34Vfusr0Tsxn4ExYylKxCvjfSnl61SGnjCcwZhz59ggYw6tWEcC3k/K+f9+wShx5BVi5y1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465016; c=relaxed/simple;
	bh=AaE0MJl6INX9d0lDOXxOo0E3Qyqjv7Tv/kOwtVpLiEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3QXhaBJcF9x9WUnHXbGj6zkfcOerTij4DbkbFbmEr9MovPw+WUOX8Desfrl9qOZIXnsM/8UPrfCeEUtjtuPoVQ/w8ybn8u3VZi6fh/bwZIV2HmdJ/4icuQzRNWu6XqGNOmy1smLk4fePOHQlfRpJ+oi3d+fg87u7Wqygi52HI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cf0yoKk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cf0yoKk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF3EC433F1;
	Tue, 20 Feb 2024 21:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465016;
	bh=AaE0MJl6INX9d0lDOXxOo0E3Qyqjv7Tv/kOwtVpLiEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cf0yoKk0bnQrjJBARIFqiDfpWBn0jyLGGLren+/FJdYJeZ4qyJUaGAKLKAr89ybGC
	 6LiJt9E2weEQDI9QiLYD/afcdpzVDF7DaFAgKFWe4SfKxWT7DESGnqr6/tPFA68SP9
	 ndGFpvRhiqIW40D6YwuMz1IhRJmEdp7HZ3txBgpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thong <thong.thai@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 209/309] drm/amdgpu/soc21: update VCN 4 max HEVC encoding resolution
Date: Tue, 20 Feb 2024 21:56:08 +0100
Message-ID: <20240220205639.720931042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thong <thong.thai@amd.com>

commit 2f542421a47e8246e9b7d2c6508fe3a6e6c63078 upstream.

Update the maximum resolution reported for HEVC encoding on VCN 4
devices to reflect its 8K encoding capability.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3159
Signed-off-by: Thong <thong.thai@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -50,13 +50,13 @@ static const struct amd_ip_funcs soc21_c
 /* SOC21 */
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn0[] = {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn1[] = {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn0 = {


