Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3231625DAEB;
	Tue, 25 Mar 2025 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906439; cv=none; b=ag0MtYOlhNeFrdztJ5wVr4gvAoHKE2UY3ltg2HRzyY+o1NhW5wDB5MG0VOakxloBLFXgslJDoz9FtjePrxGW+n2n0ZO0ndYnol4CnyXnZNPvxk2XYNYV1pfd+2XQfNGD2Fw76MpxRaXMk7jakQWeb8mVGjwWovXsqWlJqssBJlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906439; c=relaxed/simple;
	bh=ASZ+mydv2XT7mIsF53Btin9S49nvQAFsaqJb9VbmOuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBZz2KbZa/i3SzyZ4014EW/biZb3GUK3ZGdOrx05cxXYTT9YHElQH502NypHwGneRV50UoZadVbQFgFnM0vlsPVyX/MIlkmploBgdHxaDZgoKGTCB4gejSn36DGtrj0miuqiH4G9A2lm6PBiIIqRkitfG7f+uFUG/IqoNLXHQ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFsB4bja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFsB4bja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D592BC4CEE4;
	Tue, 25 Mar 2025 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906439;
	bh=ASZ+mydv2XT7mIsF53Btin9S49nvQAFsaqJb9VbmOuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFsB4bjaoyPdGGliPb7rW19dLk+T4ucFGfjMr9NtytfXO8VNik5YkWXS3+UrxgNTC
	 zwfoASVdcp8zXLcv+PRp5ksQpkLG1ZjgAdhmo125C6/G2lIthAfh38vozZziWTfjOp
	 mhnO9xZD3/BHT8dv6wC3TyNMSgW5QccTh6j2bWjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.12 100/116] drm/amdgpu: Fix JPEG video caps max size for navi1x and raven
Date: Tue, 25 Mar 2025 08:23:07 -0400
Message-ID: <20250325122151.761195507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit ec33964d9d88488fa954a03d476a8b811efc6e85 upstream.

8192x8192 is the maximum supported resolution.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6e0d2fde3ae8fdb5b47e10389f23ed2cb4daec5d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c    |    2 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -83,7 +83,7 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 8192, 8192, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
 };
 
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -124,7 +124,7 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 1920, 1088, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 186)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 8192, 8192, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 4096, 4096, 0)},
 };
 


