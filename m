Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67035FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF04C433EF;
	Mon, 15 May 2023 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171467;
	bh=rwOIpgeC1gaS6k5s/wqoVPT/+kvtxf1fW1x6YozRxJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JvPZ6E4FXJZF9EU/bqF4mVHBjsixIaztoGefYdxJvxKwemrF5O5ta5aZAKEb+GeG
	 uaTQI/v2N3iBUshKXlEO4x9gG71y56KTurh/b4W32ZZgqAGuKBgo41vY3QkNwKEaOe
	 qy9azFKz8aYV0+0S+l5wjlmJvILRf8GrrZ77VDJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <Charlene.Liu@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 219/242] drm/amd/display: Update Z8 SR exit/enter latencies
Date: Mon, 15 May 2023 18:29:05 +0200
Message-Id: <20230515161728.493656236@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 9b0f51e8449f6f76170fda6a8dd9c417a43ce270 ]

[Why]
Request from HW team to update the latencies to the new measured values.

[How]
Update the values in the bounding box.

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8f586cc16c1f ("drm/amd/display: Change default Z8 watermark values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
index 6a1cf6adea77d..0c91d8a3de4c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -149,8 +149,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_14_soc = {
 	.num_states = 5,
 	.sr_exit_time_us = 16.5,
 	.sr_enter_plus_exit_time_us = 18.5,
-	.sr_exit_z8_time_us = 280.0,
-	.sr_enter_plus_exit_z8_time_us = 350.0,
+	.sr_exit_z8_time_us = 210.0,
+	.sr_enter_plus_exit_z8_time_us = 310.0,
 	.writeback_latency_us = 12.0,
 	.dram_channel_width_bytes = 4,
 	.round_trip_ping_latency_dcfclk_cycles = 106,
-- 
2.39.2



