Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023152288CB;
	Tue,  8 Apr 2025 11:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112538; cv=none; b=lQyb9qPp5nBvYHVLpyJ1Kt44K7HzDJQptGLCA7MjjfIhTqNttrmqg7C9RmPI2TzGcKEKsl5Ry8M5yqvLFWl9pyL0Uym6z8WFqXeLxnO9YgZGLyurtb9GJtCbE5RQVPFFBF6BrgE4mCayFAacNKZ1P4jcc8ln6AV77B2TJQUqvjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112538; c=relaxed/simple;
	bh=k5kpvqZxlVGsdp0oCjvwVXRzlxpjpCDJlNxKDDJuwMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9cx+4h+6qxY38t0H0BWVEq7hzZa1hw9l296ONAfmvI+4O4ECyWVq0PZ9vkAbLrV0Z0krZHHZMkS+7p/PQJbU4DmXfsqXPZImOI5rxQrM7RihRg8ptV1G5AJlM2TXk/hCLYlUI9iS0eKGbR8Z5tJX2VQB0GqBGUecb30gLAdgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEv71WRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEv71WRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8467CC4CEE5;
	Tue,  8 Apr 2025 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112537;
	bh=k5kpvqZxlVGsdp0oCjvwVXRzlxpjpCDJlNxKDDJuwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEv71WRcAapJHZm5H4V5mv2zQsk3eVJmNPLPPAtweXkTOBCSaRrme3yhCpO4nJqSZ
	 uEBjYrbgzjadQcJhIV0WpryZRbNkf1+srgOO9FEQCiBm38z1rN9dfohmen8qAx9CBo
	 G4Cauu0DevDstnElt+rWddyYGWfs7CLBF1uR/cSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 5.15 105/279] drm/amdgpu: Fix JPEG video caps max size for navi1x and raven
Date: Tue,  8 Apr 2025 12:48:08 +0200
Message-ID: <20250408104829.180664070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -87,7 +87,7 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4906, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4906, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 8192, 8192, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
 };
 
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -123,7 +123,7 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4906, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4906, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 186)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 8192, 8192, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 4096, 4096, 0)},
 };
 


