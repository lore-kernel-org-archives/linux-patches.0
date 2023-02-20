Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAD663BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5FEC433EF;
	Mon, 20 Feb 2023 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901556;
	bh=LIeNS+U7qNPIdfoEBkFXTuqkckUAEoi5zbDgutwik40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh3sSIWT0WJV7N19ueYFAfE89kcZCc0OmkRvRZTKjyAg1Mp1wMsLd1gOXWOHi/3Me
	 BrT1TqMlhLwbO0p2eJuxqhpGWjN++3fZUGesNuIWNT3hqe9ve2aRuOGMdYEsoPaNtl
	 fofCR46+y1b4IWlCW1BAFJqcGuAZKSa8WaSFg4JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Miess <Daniel.Miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/118] drm/amd/display: Adjust downscaling limits for dcn314
Date: Mon, 20 Feb 2023 14:35:50 +0100
Message-Id: <20230220133601.791831664@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Miess <Daniel.Miess@amd.com>

[ Upstream commit dd2db2dc4bd298f33dea50c80c3c11bee4e3b0a4 ]

[Why]
Lower max_downscale_ratio and ARGB888 downscale factor
to prevent cases where underflow may occur on dcn314

[How]
Set max_downscale_ratio to 400 and ARGB downscale factor
to 250 for dcn314

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Daniel Miess <Daniel.Miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 9066c511a0529..c80c8c8f51e97 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -871,8 +871,9 @@ static const struct dc_plane_cap plane_cap = {
 	},
 
 	// 6:1 downscaling ratio: 1000/6 = 166.666
+	// 4:1 downscaling ratio for ARGB888 to prevent underflow during P010 playback: 1000/4 = 250
 	.max_downscale_factor = {
-			.argb8888 = 167,
+			.argb8888 = 250,
 			.nv12 = 167,
 			.fp16 = 167
 	},
@@ -1755,7 +1756,7 @@ static bool dcn314_resource_construct(
 	pool->base.underlay_pipe_index = NO_UNDERLAY_PIPE;
 	pool->base.pipe_count = pool->base.res_cap->num_timing_generator;
 	pool->base.mpcc_count = pool->base.res_cap->num_timing_generator;
-	dc->caps.max_downscale_ratio = 600;
+	dc->caps.max_downscale_ratio = 400;
 	dc->caps.i2c_speed_in_khz = 100;
 	dc->caps.i2c_speed_in_khz_hdcp = 100;
 	dc->caps.max_cursor_size = 256;
-- 
2.39.0



