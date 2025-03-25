Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D69625C6E0;
	Tue, 25 Mar 2025 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906433; cv=none; b=Axw6OZFbWl33KvF1xBjOJhmG1W2C/RXsYTEygh0BXc44/Y1hPi8g9MPNLpXtUCPWViXahlWHe6afqBm6Nj3GBnS+iVimOGVH/f86bh0fSG3NxMa4YO8vUfyvDgTtjI+rqY/hdMn8tJZB//X2wHvDmiHfiSN3CooeazUX0H76B48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906433; c=relaxed/simple;
	bh=WhUpxx9oG+qwoHzHQC6T6vL20g6U62M1GZueuHwO4uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/60RxIBfsYbcnXG6sMeDm2XTiBI/vuprgwuqxTmL6s7U02QT6gDftsf0vNEGGT6AS3bPGt+UVMFmP/qC2KMBSCxoQPqSNRMinfEvMPOVxeceil44kwx+/4D19THKTxgY8hnwRb/gdBxJnljRUrt5vPOj3wKDuP9CfSJQt3Zmcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi8YxlvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi8YxlvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE63C4CEE4;
	Tue, 25 Mar 2025 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906433;
	bh=WhUpxx9oG+qwoHzHQC6T6vL20g6U62M1GZueuHwO4uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi8YxlvBmcH1dpp3d2fM3sORrIUZdy51S26D5cznEOr3YRHpvk6Hs+DC016gVfjG9
	 jcwC3VkmAlv8nLzcBmLZECBSo1LS0ZJu/z8khoL9oSAPCWjWr6kz77g8nVjAUOXrXl
	 +YqbzaAOoPv42aPYNDAOzJXdf3jsWJNiZ9FOjpkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.12 098/116] drm/amdgpu: Remove JPEG from vega and carrizo video caps
Date: Tue, 25 Mar 2025 08:23:05 -0400
Message-ID: <20250325122151.713744250@linuxfoundation.org>
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

commit 7fc0765208502e53297ce72c49ca43729f9d6ff3 upstream.

JPEG is only supported for VCN1+.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0a6e7b06bdbead2e43d56a2274b7e0c9c86d536e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    1 -
 drivers/gpu/drm/amd/amdgpu/vi.c    |    7 -------
 2 files changed, 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -108,7 +108,6 @@ static const struct amdgpu_video_codec_i
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 4096, 52)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VC1, 4096, 4096, 4)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 4096, 186)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
 };
 
 static const struct amdgpu_video_codecs vega_video_codecs_decode =
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -239,13 +239,6 @@ static const struct amdgpu_video_codec_i
 		.max_pixels_per_frame = 4096 * 4096,
 		.max_level = 186,
 	},
-	{
-		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG,
-		.max_width = 4096,
-		.max_height = 4096,
-		.max_pixels_per_frame = 4096 * 4096,
-		.max_level = 0,
-	},
 };
 
 static const struct amdgpu_video_codecs cz_video_codecs_decode =


