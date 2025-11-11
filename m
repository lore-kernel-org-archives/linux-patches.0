Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26D2561A7;
	Tue, 11 Nov 2025 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825115; cv=none; b=iZbtoP57vxpDRaau+hcFxdK5Wlyp0/M8NOZcVRlp2iN4+tCaCpfrl9u8hE+zkc/JxOIgkubdw4MZV4i5LHtUR0YHheMp7Q1tkFS2Svf7gNIS0rB6i7xpGpwuCQgGlx51xWXl+tvtCRGljWcpfbmWMwvx86Vts5H4jdcktHz+P0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825115; c=relaxed/simple;
	bh=W8bUrp0udGOktZTWjWQkx+br7F0ETLlopQDVQWFBzDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgGgnZHMz9LTvu8LzS8OeiOhOgu7iOOkTCjKWXE7j0GCRB8IWamFS7Xo/CU+DnKLgbKqOOqSHAyA91NHL+hI57ZkSgIBvoK/4oLb5vvWQ7cdMgYVPePL8YSekt8eZd03dyMgQnMbk+WAS+7IbJiCs4XrZrfCCVKA6ZSFFq+gHPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o64cVQ2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o64cVQ2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04890C2BC87;
	Tue, 11 Nov 2025 01:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825115;
	bh=W8bUrp0udGOktZTWjWQkx+br7F0ETLlopQDVQWFBzDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o64cVQ2SBJnd8EZtDmzGtf/2+KmTm6NxUwj4PAUV1TXDIyV7lSuZdzwET6wuyyUly
	 m0TackR0g8OS4l6f4H5KGUSDrRHu9/zIntaPunB8sEeC0vmGl8fofVWDMb4fYLhde8
	 Y1L7FEunVSSvHm4zIdhtiw7WLIV2YWow7MGEzIkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Chen <robin.chen@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Allen Li <wei-guang.li@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 624/849] drm/amd/display: Add fast sync field in ultra sleep more for DMUB
Date: Tue, 11 Nov 2025 09:43:14 +0900
Message-ID: <20251111004551.516257253@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



