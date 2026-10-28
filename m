Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215134;
	b=h4eNoKYj5V5XdGg9NB+/c5YcZLRceYAa7MOAEsiaTr+DLPY3ScEvRpgVpVWhPRWvFbZw
	 +U0vu5qSXceaambv1PpKv0iSjZHpb5bPxAfv8jPgCmGJNxAbbSJ7VqwW0nlGEPlZ8Ul4n
	 yIu9n0piJTf5/e1Y8h0/CqgX9ze9Kf4xCjUNMlx/RaN4ar6AWQW+P4dYvdbyVQvv76I/I
	 HNu6dFwFYWduezCdDhNrcW4/T8E7fDVW5F8O8O5oBp2xfno6xpoWWQIFPWkCiv3bbC2b+
	 gnJ4uYQ0tOFoxYKusv52s/PVB+PMsTKOUWWG1/GkVS8N9vfVYVEFNvx2ho3rYV7P9CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GlyW8+nNRyAS/Cd59MceEXUZTUpRSmCxnj+xGdWzeUE=;
	b=wuw2lsd54aHBGMqU74/2/K6VPhaMhrRe45rW/ENv/hKr/5K9r4qIyn1ZHFf1fC/lg5cf
	 2hajDnmrZp7uNBgWaH52bnpccLv9bzwXX7dqp8KLyRCNQN7qIc7V5XKUMa6TMgNEXMxIa
	 MCPoGaDPVSPFaEHOMgOray+u8GI/2oheGYthW68vH9bmKtIbNqeTSbYHPGhAos7+Cg2UV
	 ZZds8uar6dPeyFOecTWAFe3aWHPLpptgd6npAGJ90SCV+H2VQWe8rGbM2SavaNURpFDY1
	 +dnOuKbxCGAxD/au/osLtXP0vX6denj0qNoOXeLn1zKWUKpTnHP/WT37xgVuOieb1Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSzgrrX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CF960A260E;
	Wed, 28 Oct 2026 19:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JSzgrrX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D0F1F031E0;
	Wed, 28 Oct 2026 19:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215133;
	bh=GlyW8+nNRyAS/Cd59MceEXUZTUpRSmCxnj+xGdWzeUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSzgrrX5iCLgGFnSHUyCZsu8bgAOt6iag3RaOKq9/en+SfIrQDvRYW4HLzN27FFi+
	 o3/AIalO/vhtcNQLyDLDLQziakaP0oUnUtQtHFpw3C5iGdEdnz4aaDP7x4lqskCfvh
	 Wiw5s8XaPAuu9qOAwrSxUVwMrkpWzLEke+JRgBNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1105/1887] drm/amd/display: Add interface to enable DPIA trace
Date: Wed, 28 Oct 2026 17:53:21 +0100
Message-ID: <20261028170524.551874551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stylon Wang <stylon.wang@amd.com>

[ Upstream commit 71ba6b577a353fa880b2e5c85cdd780765c51fed ]

[Why]
DPIA traces from DMUB is not enabled by default, which is
less convenient to debug DPIA related issues because we have
to resort to other debug tools to enable DPIA trace.

[How]
Exposes interfaces to update trace mask from the DMUB GPINT commands.
Also provides DC implementations to enable DPIA trace.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4ae3e16f4b3b ("drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c  | 29 +++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h  |  3 ++
 .../gpu/drm/amd/display/dmub/inc/dmub_cmd.h   | 18 ++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 35e8f22d30204..784c8144d2d0f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -1034,3 +1034,32 @@ bool dc_dmub_check_min_version(struct dmub_srv *srv)
 		return true;
 	return srv->hw_funcs.is_psrsu_supported(srv);
 }
+
+void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
+{
+	struct dc_dmub_srv *dc_dmub_srv = dc->ctx->dmub_srv;
+	struct dmub_srv *dmub;
+	enum dmub_status status;
+	static const uint32_t timeout_us = 30;
+
+	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+		DC_LOG_ERROR("%s: invalid parameters.", __func__);
+		return;
+	}
+
+	dmub = dc_dmub_srv->dmub;
+
+	status = dmub_srv_send_gpint_command(dmub, DMUB_GPINT__SET_TRACE_BUFFER_MASK_WORD1, 0x0010, timeout_us);
+	if (status != DMUB_STATUS_OK) {
+		DC_LOG_ERROR("timeout updating trace buffer mask word\n");
+		return;
+	}
+
+	status = dmub_srv_send_gpint_command(dmub, DMUB_GPINT__UPDATE_TRACE_BUFFER_MASK, 0x0000, timeout_us);
+	if (status != DMUB_STATUS_OK) {
+		DC_LOG_ERROR("timeout updating trace buffer mask word\n");
+		return;
+	}
+
+	DC_LOG_DEBUG("Enabled DPIA trace\n");
+}
\ No newline at end of file
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
index 9a248ced03b9c..452fb1c2f5a69 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
@@ -90,4 +90,7 @@ void dc_dmub_srv_log_diagnostic_data(struct dc_dmub_srv *dc_dmub_srv);
 
 void dc_send_update_cursor_info_to_dmu(struct pipe_ctx *pCtx, uint8_t pipe_idx);
 bool dc_dmub_check_min_version(struct dmub_srv *srv);
+
+void dc_dmub_srv_enable_dpia_trace(const struct dc *dc);
+
 #endif /* _DMUB_DC_SRV_H_ */
diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index d8c05bc45957b..06717e9a28e9d 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -540,6 +540,24 @@ enum dmub_gpint_command {
 	 * DESC: Notifies DMCUB detection is done so detection required can be cleared.
 	 */
 	DMUB_GPINT__NOTIFY_DETECTION_DONE = 12,
+	/**
+	 * DESC: Updates the trace buffer lower 32-bit mask.
+	 * ARGS: The new mask
+	 * RETURN: Lower 32-bit mask.
+	 */
+	DMUB_GPINT__UPDATE_TRACE_BUFFER_MASK = 101,
+	/**
+	 * DESC: Updates the trace buffer lower 32-bit mask.
+	 * ARGS: The new mask
+	 * RETURN: Lower 32-bit mask.
+	 */
+	DMUB_GPINT__SET_TRACE_BUFFER_MASK_WORD0 = 102,
+	/**
+	 * DESC: Updates the trace buffer mask bi0~bit15.
+	 * ARGS: The new mask
+	 * RETURN: Lower 32-bit mask.
+	 */
+	DMUB_GPINT__SET_TRACE_BUFFER_MASK_WORD1 = 103,
 };
 
 /**
-- 
2.53.0



