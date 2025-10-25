Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22692305943;
	Sat, 25 Oct 2025 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408873; cv=none; b=pxaJ5w24YoB4QyeO0Fne7X8VKdFGevhKcHIhXZJ9A+zZQIBt3t1Lnk5EUo4IEKSDEX74QmjDSonBzK+8OKa/xL/DPE5ZpBNumzrobismyjBRyz8ELqwOvdTqMZeume7VVcnoDil4P0KbVjSg0U23+w7Xx61FXuq93nlstZOqJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408873; c=relaxed/simple;
	bh=enacJO0jwDh3V7XzT+HusnndcHG7lN4NU3rcqJVB410=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1EV2YvvcTU0bjhtMseYwVozjebLSIL/uarbYO+s8zOXjYCVn4e9vBH49zTDd5DGAJdPal959xy+/o3DzIC+oV0NC49oVGjLsMXoyZu61Z3/mEPwwcpp8OjJrFkaGWxgV4txwWE4Z6MV/LyJLQf47dM6GO1oczvHonEjXz1ew88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4DV5nI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4DV5nI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31DDC4CEFF;
	Sat, 25 Oct 2025 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408872;
	bh=enacJO0jwDh3V7XzT+HusnndcHG7lN4NU3rcqJVB410=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4DV5nI9DJ7xDuXf2WVcBfo0NxmA2YW5crSw5T1KzFgZ6dndk5wgB1x6OGovq6+kb
	 j67E5ep+rRdkVLgSD4AtyWTa5iFaLPAbqp7w3FYa8wslpdtRESHtMANeoa/M1YTtNp
	 VMYlHBseo7MfA9CMYCWnypfWP5WiDAezy+aq7TjPi3Lj09re+QAkdphj2DqKL76MjY
	 Tfq1DbB7M5hFTc3R+2wMqtKZlNc6vTBDQklP6wPh3raRpnAYuYi+1SerzgMwuX8eIJ
	 6dkgaOvqYM3bZeFcQEuN7botDEvFfNq3CThp3jq/iwCWzmtigJvznjWcEbTg38AQYa
	 aWZWcPrLe4dhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Allen Li <wei-guang.li@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	charlene.liu@amd.com,
	Dillon.Varone@amd.com,
	Ovidiu.Bunea@amd.com,
	gabe.teeger@amd.com,
	Duncan.Ma@amd.com,
	alexandre.f.demers@gmail.com,
	Syed.Hassan@amd.com,
	wayne.lin@amd.com,
	chiahsuan.chung@amd.com,
	Austin.Zheng@amd.com,
	aurabindo.pillai@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Add fast sync field in ultra sleep more for DMUB
Date: Sat, 25 Oct 2025 11:55:40 -0400
Message-ID: <20251025160905.3857885-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allen Li <wei-guang.li@amd.com>

[ Upstream commit b65cf4baeb24bdb5fee747679ee88f1ade5c1d6c ]

[Why&How]
We need to inform DMUB whether fast sync in ultra sleep mode is supported,
so that it can disable desync error detection when the it is not enabled.
This helps prevent unexpected desync errors when transitioning out of
ultra sleep mode.

Add fast sync in ultra sleep mode field in replay copy setting command.

Reviewed-by: Robin Chen <robin.chen@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Allen Li <wei-guang.li@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `amdgpu_dm_link_setup_replay()` already derives whether a panel can
  keep “fast resync” while in ultra-sleep
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c:136`), but
  until this change that information never left the driver. The DMUB
  firmware therefore had to assume the feature was always present, so on
  panels that cannot fast-resync it keeps desync error detection enabled
  and triggers the “unexpected desync errors” described in the commit
  message whenever the link wakes up.
- The patch finally propagates that capability bit into the replay copy-
  settings command
  (`drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c:173`) and defines
  an explicit field for it in the DMUB command payload
  (`drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h:4148`). This lets
  updated firmware disable desync detection when fast resync is
  unavailable, eliminating the spurious error storms users are seeing on
  affected eDP panels.
- The fix is tightly scoped, reuses a byte that used to be padding, and
  leaves the overall command size unchanged, so older firmware that
  ignores the extra byte continues to work while newer firmware
  benefits. There are no functional side effects beyond the bug fix, and
  every prerequisite (the capability flag and replay infrastructure) has
  been in stable releases for some time.

Given the real user impact, the minimal, self-contained change, and its
compatibility with existing firmware, this is a solid candidate for
stable backporting.

 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c | 1 +
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h  | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
index fcd3d86ad5173..727ce832b5bb8 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
@@ -168,6 +168,7 @@ static bool dmub_replay_copy_settings(struct dmub_replay *dmub,
 	copy_settings_data->max_deviation_line			= link->dpcd_caps.pr_info.max_deviation_line;
 	copy_settings_data->smu_optimizations_en		= link->replay_settings.replay_smu_opt_enable;
 	copy_settings_data->replay_timing_sync_supported = link->replay_settings.config.replay_timing_sync_supported;
+	copy_settings_data->replay_support_fast_resync_in_ultra_sleep_mode = link->replay_settings.config.replay_support_fast_resync_in_ultra_sleep_mode;
 
 	copy_settings_data->debug.bitfields.enable_ips_visual_confirm = dc->dc->debug.enable_ips_visual_confirm;
 
diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index 6fa25b0375858..5c9deb41ac7e6 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -4104,10 +4104,14 @@ struct dmub_cmd_replay_copy_settings_data {
 	 * @hpo_link_enc_inst: HPO link encoder instance
 	 */
 	uint8_t hpo_link_enc_inst;
+	/**
+	 * Determines if fast sync in ultra sleep mode is enabled/disabled.
+	 */
+	uint8_t replay_support_fast_resync_in_ultra_sleep_mode;
 	/**
 	 * @pad: Align structure to 4 byte boundary.
 	 */
-	uint8_t pad[2];
+	uint8_t pad[1];
 };
 
 /**
-- 
2.51.0

