Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B253016F8;
	Wed, 17 Sep 2025 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113218; cv=none; b=CFrCmzmMJraz3pzCEIAOWdz8mSM5oEpx5rqqs6wrUJHfeamZ4urEELSij4AhHDcJ9BjLhMDw+SjqdJHIdQTu1+CX2eZWwBayGzT1Hh+Aw0NmvQD4uPnqOsdNL6b5l0RjdLuuye9ewt6qI3l5BYLcxAMZdq9B9Y6nnXiy4YhCl2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113218; c=relaxed/simple;
	bh=S75SXKgGLBJxD2rl4Gbk7MVv4yaXL3zexg4u48rIUtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnaVNTUUz4NwjgBAKuh54GvfQTk/MvOIX5vhhpQ4zebbcsDf+9sn/sQlfS+raBh3P1RsNfn62rgh2zUjQCeUNGlwjjXIMzL0UKkYbynyXslnPMKL2qcpgG1XN4k6CNWwnNJVCvt6gk+mUeYecXu7vJCKT9ey3fKqxkHdY3Ow3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/bA1yd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/bA1yd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7397DC4CEF0;
	Wed, 17 Sep 2025 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113217;
	bh=S75SXKgGLBJxD2rl4Gbk7MVv4yaXL3zexg4u48rIUtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/bA1yd44o6vArl/COPIansvNWsb/Yl1Zbs2PK/2xO+mgf/CxqPRHONsQsqxxRKEB
	 cJZt/SzLDxbiX4FLgiTxD1DK2TGbSbu2urSOoAeB8s2YJIqoEZLSkmopAELqVBoRaU
	 26pcGzMBAIvl0oI8rZ18sVDBkA9p6pa7lh3i1kas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/140] drm/amdgpu: Add back JPEG to video caps for carrizo and newer
Date: Wed, 17 Sep 2025 14:33:11 +0200
Message-ID: <20250917123344.781425696@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

[ Upstream commit 2036be31741b00f030530381643a8b35a5a42b5c ]

JPEG is not supported on Vega only.

Fixes: 0a6e7b06bdbe ("drm/amdgpu: Remove JPEG from vega and carrizo video caps")
Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0f4dfe86fe922c37bcec99dce80a15b4d5d4726d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 48ab93e715c82..6e4f9c6108f60 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -239,6 +239,13 @@ static const struct amdgpu_video_codec_info cz_video_codecs_decode_array[] =
 		.max_pixels_per_frame = 4096 * 4096,
 		.max_level = 186,
 	},
+	{
+		.codec_type = AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG,
+		.max_width = 4096,
+		.max_height = 4096,
+		.max_pixels_per_frame = 4096 * 4096,
+		.max_level = 0,
+	},
 };
 
 static const struct amdgpu_video_codecs cz_video_codecs_decode =
-- 
2.51.0



