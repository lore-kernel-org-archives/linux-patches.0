Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5D02F9D9E;
	Tue, 30 Sep 2025 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244819; cv=none; b=Dpc+j2pmO63vPvpUX5my3hzUsgxMYxMML7CF6HBf5Fa6QAQMZk8d9kJnMxlz7Xb/8IWiZnBZMuf2/Lv8DYUo5W1P/a8SffuRhSneqHemfDWLiFlX9W2a7LeYPnWJp2FRV3ncwEQxiU9/xP/c3mDClmmaxoWFhMzv6YvaRuYAhaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244819; c=relaxed/simple;
	bh=5v9EokhHB5qgC05cQyL3EYc9RvItXzynXKrm7Qa0+1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYkIemZj+t9ZpXZqd95PScSrEHCFMHbYJ5BCa29EMWMHZzjfYhhAXSPKbw2+vsuIzVdfvKFpngovdTYaW+5eQCouhGkH59lbozCSTLJEhL0BrOoxK8ZQoc1jkMFF5rcQWN0z/fv6wUDCFXztCH632PPrQ2Xsbrl62QhUTykeu/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgbClB/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgbClB/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D923C4CEF0;
	Tue, 30 Sep 2025 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244818;
	bh=5v9EokhHB5qgC05cQyL3EYc9RvItXzynXKrm7Qa0+1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgbClB/cxy6oDEFCP9WxTEi0fAo3pVsiWKj8YM6rrp4jEiw2z4AHCGXy8Q7+PccO/
	 7RKcCpv8SpnfGhM6BY1IGU+rgV5nTqZgPBeh5q5VEmlp8AOvPQbMVu8XYr10gsWDKm
	 YOqJYSNeisO0CIyluvbznjy6s9B1U1GAQHeJeueQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 092/143] drm/amd/display: remove output_tf_change flag
Date: Tue, 30 Sep 2025 16:46:56 +0200
Message-ID: <20250930143834.895342925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 41b1f9fcba62b06195e625bb88c1031102892439 ]

Remove this flag as the driver stopped managing it individually since
commit a4056c2a6344 ("drm/amd/display: use HW hdr mult for brightness
boost"). After some back and forth it was reintroduced as a condition to
`set_output_transfer_func()` in [1]. Without direct management, this
flag only changes value when all surface update flags are set true on
UPDATE_TYPE_FULL with no output TF status meaning.

Fixes: bb622e0c0044 ("drm/amd/display: program output tf when required") [1]
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 752e6f283ec59ae007aa15a93d5a4b2eefa8cec9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                       | 1 -
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 6 ++----
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 6 ++----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 7dfbfb18593c1..f037f2d83400b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1292,7 +1292,6 @@ union surface_update_flags {
 		uint32_t in_transfer_func_change:1;
 		uint32_t input_csc_change:1;
 		uint32_t coeff_reduction_change:1;
-		uint32_t output_tf_change:1;
 		uint32_t pixel_format_change:1;
 		uint32_t plane_size_change:1;
 		uint32_t gamut_remap_change:1;
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 454e362ff096a..c0127d8b5b396 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1990,10 +1990,8 @@ static void dcn20_program_pipe(
 	 * updating on slave planes
 	 */
 	if (pipe_ctx->update_flags.bits.enable ||
-		pipe_ctx->update_flags.bits.plane_changed ||
-		pipe_ctx->stream->update_flags.bits.out_tf ||
-		(pipe_ctx->plane_state &&
-			pipe_ctx->plane_state->update_flags.bits.output_tf_change))
+	    pipe_ctx->update_flags.bits.plane_changed ||
+	    pipe_ctx->stream->update_flags.bits.out_tf)
 		hws->funcs.set_output_transfer_func(dc, pipe_ctx, pipe_ctx->stream);
 
 	/* If the pipe has been enabled or has a different opp, we
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index c4177a9a662fa..c68d01f378602 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -2289,10 +2289,8 @@ void dcn401_program_pipe(
 	 * updating on slave planes
 	 */
 	if (pipe_ctx->update_flags.bits.enable ||
-		pipe_ctx->update_flags.bits.plane_changed ||
-		pipe_ctx->stream->update_flags.bits.out_tf ||
-		(pipe_ctx->plane_state &&
-			pipe_ctx->plane_state->update_flags.bits.output_tf_change))
+	    pipe_ctx->update_flags.bits.plane_changed ||
+	    pipe_ctx->stream->update_flags.bits.out_tf)
 		hws->funcs.set_output_transfer_func(dc, pipe_ctx, pipe_ctx->stream);
 
 	/* If the pipe has been enabled or has a different opp, we
-- 
2.51.0



