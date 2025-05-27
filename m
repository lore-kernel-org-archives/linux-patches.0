Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972AA1DC998;
	Tue, 27 May 2025 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367744; cv=none; b=JvForkt4CNnx2KwcGaEn7tRcg5fykvLk92T+XyOxC2TlYgFN+TAUgiGGBEoVBW7oz7wKJGBpnGms1oyY76pCvCdRfQGIOZE9mGfWcjDRVCHegTAsd/Fw5KKUaDb4DQNibprqrHhVXZG/nY8peuQ8u/Ag3gt+GGBvcAXCvzEC5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367744; c=relaxed/simple;
	bh=VqfTDot4cgTnhYXnc948xdbcyQmKCPdyFNyayO8S8ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqGbUYgv/mXOahMNIGnlMEarkMt+rq49z8KrcIfO3+s3h+3qVuDiJk/jLD0X26SlpcXHdC1sHvaMtMiivcEl6bK1Mvaa6GLhEFvAD2QMhFeSy+PqepSUBqU2Dw2lDiKqNPzP/V+LseLR0jRu7+8PV5lYKpni34DdgQZrBIimb+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwfFCQdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwfFCQdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B0AC4CEE9;
	Tue, 27 May 2025 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367744;
	bh=VqfTDot4cgTnhYXnc948xdbcyQmKCPdyFNyayO8S8ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwfFCQdkqvk8UHkDT8wC/hrvYSbPCmXf8jVzhuhO74VJvgigzM55scBiOeOFScvYB
	 mGOKQTdFgzscz/5U2Em1uu0ehF7JfRn9LQYZ4Wxfwpj3MPVesJHAuiLf0MfVsJXli5
	 gQA4B1DM/Asmmml6jEfm0AIgBoJzt542HamK2ids=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Koo <anthony.koo@amd.com>,
	Martin Tsai <Martin.Tsai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 486/783] drm/amd/display: Support multiple options during psr entry.
Date: Tue, 27 May 2025 18:24:43 +0200
Message-ID: <20250527162532.919929046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tsai <Martin.Tsai@amd.com>

[ Upstream commit 3a5fa55455db6a11248a25f24570c365f9246144 ]

[WHY]
Some panels may not handle idle pattern properly during PSR entry.

[HOW]
Add a condition to allow multiple options on power down
sequence during PSR1 entry.

Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Martin Tsai <Martin.Tsai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h       | 7 +++++++
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c   | 4 ++++
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 0c2aa91f0a111..e60898c2df01a 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -1033,6 +1033,13 @@ struct psr_settings {
 	unsigned int psr_sdp_transmit_line_num_deadline;
 	uint8_t force_ffu_mode;
 	unsigned int psr_power_opt;
+
+	/**
+	 * Some panels cannot handle idle pattern during PSR entry.
+	 * To power down phy before disable stream to avoid sending
+	 * idle pattern.
+	 */
+	uint8_t power_down_phy_before_disable_stream;
 };
 
 enum replay_coasting_vtotal_type {
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 88c75c243bf8a..ff3b8244ba3d0 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -418,6 +418,10 @@ static bool dmub_psr_copy_settings(struct dmub_psr *dmub,
 	copy_settings_data->relock_delay_frame_cnt = 0;
 	if (link->dpcd_caps.sink_dev_id == DP_BRANCH_DEVICE_ID_001CF8)
 		copy_settings_data->relock_delay_frame_cnt = 2;
+
+	copy_settings_data->power_down_phy_before_disable_stream =
+		link->psr_settings.power_down_phy_before_disable_stream;
+
 	copy_settings_data->dsc_slice_height = psr_context->dsc_slice_height;
 
 	dc_wake_and_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index d0fe324cb5371..8cf89aed024b7 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -3118,6 +3118,12 @@ struct dmub_cmd_psr_copy_settings_data {
 	 * Some panels request main link off before xth vertical line
 	 */
 	uint16_t poweroff_before_vertical_line;
+	/**
+	 * Some panels cannot handle idle pattern during PSR entry.
+	 * To power down phy before disable stream to avoid sending
+	 * idle pattern.
+	 */
+	uint8_t power_down_phy_before_disable_stream;
 };
 
 /**
-- 
2.39.5



