Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D38547078;
	Thu, 17 Sep 2026 18:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668581; cv=none; b=oQsnTgjdLsYC1TISu7vNJIAfluw/aS7J/fwr5THTf9+HjF6s+Dcnbz+Q+sVFicek0zKKq5EP8XVBSegXs+hB4Mn3tQ0Zkf4Z0Gt30oQP6MeVHeQO0I5T0a4fcvl3Pu7SgMlvXYqpOhU2urCgSwTyAJc9++x8fQT8lLmowMOpsSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668581; c=relaxed/simple;
	bh=utoBSBbjUPZRaZlO9dpqN0ZpGw/H3NzoP8acuoIvr4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQ/Pi4WluGuQp0ltA2Vwki/cXLCPNvtyrf2aYreyoj0eOfZl0e+w3wGMWHcpRvV/fbr8iOWCO2UeLs+sDaTEJcZdoZpQe6LbdNe0KqVaCWV3ou4E5LUZIarIUUeIR7j5fM/VVPoRcEomqEDCbKxAIHeCnlMZzhhYKRRNtt/f8FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxSQpsXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxSQpsXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D471F000FF;
	Thu, 17 Sep 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668579;
	bh=x5dPU1ncpD9h2cmEnvBJRpClAJjZVqLdpyemnz7k/VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxSQpsXBFBJjxmp2ZO9rZLv/TlxAuie3Ne2eRRz1J0fdtWQxKt97vRfo0CU1vxATI
	 /ecZ/BA2jRhMgGpLHAEZrZ3XPqAL8+w0IFE8jNv7irEUnNlkBq+EivWQlKT+08WwiF
	 mBuO6RNa1qh8hECDYV8BrmuBZ3wamO5ZxUaUFdcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <listout@listout.xyz>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0473/1102] drm/amd/display: clean-up dead code in dml2_mall_phantom
Date: Thu, 17 Sep 2026 16:06:56 +0100
Message-ID: <20260917151551.567680516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit f117eca965c797c5efb55ee40543cb37b9cb7d23 ]

pipe_idx in funtion dml2_svp_validate_static_schedulabilit, although set
is never actually used. While building with GCC 16 this gives a warning:

drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_mall_phantom.c: In function ‘set_phantom_stream_timing’:
drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_mall_phantom.c:657:25: warning: variable ‘pipe_idx’ set but not used [-Wunused-but-set-variable=]
  657 |         unsigned int i, pipe_idx;
      |                         ^~~~~~~~

Signed-off-by: Brahmajit Das <listout@listout.xyz>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
index 6b3b8803e0aee..dae7c1c41c897 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_mall_phantom.c
@@ -654,14 +654,14 @@ static void set_phantom_stream_timing(struct dml2_context *ctx, struct dc_state
 				     unsigned int svp_height,
 				     unsigned int svp_vstartup)
 {
-	unsigned int i, pipe_idx;
+	unsigned int i;
 	double line_time, fp_and_sync_width_time;
 	struct pipe_ctx *pipe;
 	uint32_t phantom_vactive, phantom_bp, pstate_width_fw_delay_lines;
 	static const double cvt_rb_vblank_max = ((double) 460 / (1000 * 1000));
 
 	// Find DML pipe index (pipe_idx) using dc_pipe_idx
-	for (i = 0, pipe_idx = 0; i < ctx->config.dcn_pipe_count; i++) {
+	for (i = 0; i < ctx->config.dcn_pipe_count; i++) {
 		pipe = &state->res_ctx.pipe_ctx[i];
 
 		if (!pipe->stream)
@@ -669,8 +669,6 @@ static void set_phantom_stream_timing(struct dml2_context *ctx, struct dc_state
 
 		if (i == dc_pipe_idx)
 			break;
-
-		pipe_idx++;
 	}
 
 	// Calculate lines required for pstate allow width and FW processing delays
-- 
2.53.0



