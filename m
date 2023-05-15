Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F888FBF8
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C40C433EF;
	Mon, 15 May 2023 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170793;
	bh=HJ10oH3H6Jngs5vVCXUuEiXw9n3xRVNoR5J9av7pjgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WObCCsz4Z5kTDDbYS1z/jxT7I+GKc9wTU/w6QKyeIvNt8PdYX8xOlEdN/uRmT+278
	 KQrrVLErYUBVm3Y+1YT88onVuwlYkOQcOwdsE1y06FUuh2WHcWy1pbbRHT/ss0g0hy
	 jw1muC4oDvbLnDMjd0renHx6RFY1Rk4JwSRfFyck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Brian Chang <Brian.Chang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/239] drm/amd/display: Update Z8 watermarks for DCN314
Date: Mon, 15 May 2023 18:27:52 +0200
Message-Id: <20230515161727.998172284@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

[ Upstream commit fa24e116f1ce3dcc55474f0b6ab0cac4e3ee34e1 ]

[Why & How]
Update from HW, need to lower watermarks for enter/enter+exit latency.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8f586cc16c1f ("drm/amd/display: Change default Z8 watermark values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
index 34b6c763a4554..9214ce23c3bd3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -148,8 +148,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_14_soc = {
 	.num_states = 5,
 	.sr_exit_time_us = 16.5,
 	.sr_enter_plus_exit_time_us = 18.5,
-	.sr_exit_z8_time_us = 442.0,
-	.sr_enter_plus_exit_z8_time_us = 560.0,
+	.sr_exit_z8_time_us = 280.0,
+	.sr_enter_plus_exit_z8_time_us = 350.0,
 	.writeback_latency_us = 12.0,
 	.dram_channel_width_bytes = 4,
 	.round_trip_ping_latency_dcfclk_cycles = 106,
-- 
2.39.2



