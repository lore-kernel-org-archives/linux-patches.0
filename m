Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213951;
	b=bDm0Kp/Ty//jprJ7bRXxYk+i24zzi4fEdLfwABbkTBztWWyGjvOLkUIV86HokRXJJGcr
	 QDhu8DArgjkvAqL7CqpopsI1nVFr7hpjld6dtlkt/ffvMcN5g5jp+tEc00F/nQ4KRDvaK
	 KTrysxEzHcQe3apsYDAPZw92ucAYCyvtQnDemwxouRuw6zfJZxi2K4YuoSs5M7GedJFj6
	 Eb75toECxDZLvZd5urEFSM+5nWChtebjg9r64TeV8iPcairguNSxKmN3dbF6UHaY27Ew5
	 kvMd6H9tTFYA4qsLE+2EWZfpi3q0nalgoI8hY9t9gqa8b5T3j3fK3T/4/d4Yd2FnsNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1xfLKSxD/r9VzOYKNtkLe/Nsgwqxc5AwoXTRf3tgmhM=;
	b=oFgTcomlvxStzr0BpeWWlLZrEV3Ktzijtk3tdDTT+Gprj8ELiUF8zEC5vY7jZ3XsQ3VZ
	 co9OiZWJ5Diru8q2hv5oOa2fB9oaGufJP7LDLQj2BQurxXJiEuxiEU7p9HCjloC1e0RIE
	 CD6dWwLf868thAg8eP47qvcUwchSVkn2Ckhyqpz+NHkIQD+XbI2cQqr0LpbdodIR342eD
	 hNig5HCoZUHCHvwOOwN2yrHvgam7nUQyXqNtmDPfNQ8OnimDzrhTw1M4++EVs8v+GX+Y1
	 ylZuhiZDhqoAfrzS0VXPmaDKLGG4tpo7SCg360YcQ+0WQR3GbKRmOPNvUNAL+d7iPsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arFeGgZt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D28606A31E;
	Wed, 28 Oct 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=arFeGgZt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0851F01825;
	Wed, 28 Oct 2026 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213951;
	bh=1xfLKSxD/r9VzOYKNtkLe/Nsgwqxc5AwoXTRf3tgmhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arFeGgZttSIIRCGbR1NqMl2st5pEXsrldHOAT6oNxFmftonpAQ9WwFLP4AtXCwFNk
	 WRAQlcmqtqFkCnnYbHQCo+36ZIJdV3JcnrmYxY45W46C89amX5GHxg8uTuagJp8JK9
	 jRTLDj8vBMEHX+mGBSUmyUZtV6E6F5V/13U8U5nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0670/1887] drm/amd/display: Check null pointers before multiple uses
Date: Wed, 28 Oct 2026 17:46:06 +0100
Message-ID: <20261028170514.659086674@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit fdd5ecbbff751c3b9061d8ebb08e5c96119915b4 ]

[WHAT & HOW]
Poniters, such as stream_enc and dc->bw_vbios, are null checked previously
in the same function, so Coverity warns "implies that stream_enc and
dc->bw_vbios might be null". They are used multiple times in the
subsequent code and need to be checked.

This fixes 10 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c        | 5 ++++-
 drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c | 5 ++++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c      | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c   | 3 +++
 drivers/gpu/drm/amd/display/dc/link/link_hwss_dio.c     | 5 ++++-
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 717e36172a718..f87c6174b7040 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -6187,8 +6187,11 @@ bool dc_link_dp_set_test_pattern(
 			break;
 		}
 
+		if (!pipe_ctx->stream)
+			return false;
+
 		if (pipe_ctx->stream_res.tg->funcs->lock_doublebuffer_enable) {
-			if (pipe_ctx->stream && should_use_dmub_lock(pipe_ctx->stream->link)) {
+			if (should_use_dmub_lock(pipe_ctx->stream->link)) {
 				union dmub_hw_lock_flags hw_locks = { 0 };
 				struct dmub_hw_lock_inst_flags inst_flags = { 0 };
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
index 19d7cfa53211b..1f1f66d857698 100644
--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -1065,7 +1065,10 @@ static void bw_calcs_data_update_from_pplib(struct dc *dc)
 	struct dm_pp_clock_levels clks = {0};
 	int memory_type_multiplier = MEMORY_TYPE_MULTIPLIER_CZ;
 
-	if (dc->bw_vbios && dc->bw_vbios->memory_type == bw_def_hbm)
+	if (!dc->bw_vbios)
+		return;
+
+	if (dc->bw_vbios->memory_type == bw_def_hbm)
 		memory_type_multiplier = MEMORY_TYPE_HBM;
 
 	/*do system clock  TODO PPLIB: after PPLIB implement,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index d0422e1c14fab..a554867ee1a93 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2139,6 +2139,9 @@ bool dcn20_wait_for_blank_complete(
 {
 	int counter;
 
+	if (!opp)
+		return false;
+
 	for (counter = 0; counter < 1000; counter++) {
 		if (opp->funcs->dpg_is_blanked(opp))
 			break;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 591c3166a4687..9f5425e6474fb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1664,6 +1664,9 @@ static void dcn32_enable_phantom_plane(struct dc *dc,
 		else
 			phantom_plane = dc_create_plane_state(dc);
 
+		if (!phantom_plane)
+			break;
+
 		memcpy(&phantom_plane->address, &curr_pipe->plane_state->address, sizeof(phantom_plane->address));
 		memcpy(&phantom_plane->scaling_quality, &curr_pipe->plane_state->scaling_quality,
 				sizeof(phantom_plane->scaling_quality));
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_hwss_dio.c b/drivers/gpu/drm/amd/display/dc/link/link_hwss_dio.c
index 4227adbc646a8..5ba7749ca52bb 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_hwss_dio.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_hwss_dio.c
@@ -56,7 +56,10 @@ void reset_dio_stream_encoder(struct pipe_ctx *pipe_ctx)
 	struct link_encoder *link_enc = link_enc_cfg_get_link_enc(pipe_ctx->stream->link);
 	struct stream_encoder *stream_enc = pipe_ctx->stream_res.stream_enc;
 
-	if (stream_enc && stream_enc->funcs->disable_fifo)
+	if (!stream_enc)
+		return;
+
+	if (stream_enc->funcs->disable_fifo)
 		stream_enc->funcs->disable_fifo(stream_enc);
 
 	link_enc->funcs->connect_dig_be_to_fe(
-- 
2.53.0



