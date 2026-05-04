Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757E3A7F4C;
	Mon,  4 May 2026 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903990; cv=none; b=nq9YK7Q7UL4mW5cfj+vdA7Tj+azC7Uf5gBG//r+Dj83m+Sk3PLAsM44DiA6JexUHSLH+VQqwpFlBQVbNepCS9XxC3QEbU6hJLIEG/Vg8UFIGAAzET3KCIItKBY67LZ0a8LS2wjFDlZrtY5Xglc7KqCt6jJ6Ho7zbE7DhPMd347M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903990; c=relaxed/simple;
	bh=3U8JuZQBa0Kis7orVCtx+1jv5e/ustD8evqxMYS3F1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhxCrrvGKHRNTsBgJQz8uo9HnYp9MY+GRAp/v9Z7OCqFKcYBtw4Dq9eFw65MJdE8kQJcOuYQHzdKpYBpA8MahV6GcXpbxjkzG9kR1cKZ10zLkI3Xi5JSZeCjFMHn5ghp9baiXIg3PcFOGxoRB5bHoZmWqzJyQYLVwDuIlcBvT78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyZtc1KA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyZtc1KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDF3C2BCB8;
	Mon,  4 May 2026 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903989;
	bh=3U8JuZQBa0Kis7orVCtx+1jv5e/ustD8evqxMYS3F1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyZtc1KAC1LE45jeyWF18vdxlnyCh3kK8ItNiT1JeQ01TupQoQ8OXnyWEjqAD8x4w
	 nQ38N27Gixmocs82WBY/dQ5yvieQdNP+NWgHXt9XnJZoMn6z+oz5e9B/v2vCGkhjv2
	 KBhKxMa4bigyVjIImHrShBvQL2xvDqcd+1CXyiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 141/275] drm/amd: Fix set but not used warnings
Date: Mon,  4 May 2026 15:51:21 +0200
Message-ID: <20260504135148.139862189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 46791d147d3ab3262298478106ef2a52fc7192e2 upstream.

There are many set but not used warnings under drivers/gpu/drm/amd when
compiling with the latest upstream mainline GCC:

  drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c:305:18: warning: variable ‘p’ set but not used [-Wunused-but-set-variable=]
  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h:103:26: warning: variable ‘internal_reg_offset’ set but not used [-Wunused-but-set-variable=]
  ...
  drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h:164:26: warning: variable ‘internal_reg_offset’ set but not used [-Wunused-but-set-variable=]
  ...
  drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:445:13: warning: variable ‘pipe_idx’ set but not used [-Wunused-but-set-variable=]
  drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:875:21: warning: variable ‘pipe_idx’ set but not used [-Wunused-but-set-variable=]

Remove the variables actually not used or add __maybe_unused attribute for
the variables actually used to fix them, compile tested only.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c     |    4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h      |    6 ++++--
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c |    9 +++------
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -302,7 +302,6 @@ void amdgpu_gart_unbind(struct amdgpu_de
 			int pages)
 {
 	unsigned t;
-	unsigned p;
 	int i, j;
 	u64 page_base;
 	/* Starting from VEGA10, system bit must be 0 to mean invalid. */
@@ -316,8 +315,7 @@ void amdgpu_gart_unbind(struct amdgpu_de
 		return;
 
 	t = offset / AMDGPU_GPU_PAGE_SIZE;
-	p = t / AMDGPU_GPU_PAGES_IN_CPU_PAGE;
-	for (i = 0; i < pages; i++, p++) {
+	for (i = 0; i < pages; i++) {
 		page_base = adev->dummy_page_addr;
 		if (!adev->gart.ptr)
 			continue;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -100,7 +100,8 @@
 
 #define SOC15_DPG_MODE_OFFSET(ip, inst_idx, reg) 						\
 	({											\
-		uint32_t internal_reg_offset, addr;						\
+		/* To avoid a -Wunused-but-set-variable warning. */				\
+		uint32_t internal_reg_offset __maybe_unused, addr;				\
 		bool video_range, video1_range, aon_range, aon1_range;				\
 												\
 		addr = (adev->reg_offset[ip##_HWIP][inst_idx][reg##_BASE_IDX] + reg);		\
@@ -161,7 +162,8 @@
 
 #define SOC24_DPG_MODE_OFFSET(ip, inst_idx, reg)						\
 	({											\
-		uint32_t internal_reg_offset, addr;						\
+		/* To avoid a -Wunused-but-set-variable warning. */				\
+		uint32_t internal_reg_offset __maybe_unused, addr;				\
 		bool video_range, video1_range, aon_range, aon1_range;				\
 												\
 		addr = (adev->reg_offset[ip##_HWIP][inst_idx][reg##_BASE_IDX] + reg);		\
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -442,7 +442,6 @@ bool dc_dmub_srv_p_state_delegate(struct
 	int i = 0, k = 0;
 	int ramp_up_num_steps = 1; // TODO: Ramp is currently disabled. Reenable it.
 	uint8_t visual_confirm_enabled;
-	int pipe_idx = 0;
 	struct dc_stream_status *stream_status = NULL;
 
 	if (dc == NULL)
@@ -457,7 +456,7 @@ bool dc_dmub_srv_p_state_delegate(struct
 	cmd.fw_assisted_mclk_switch.config_data.visual_confirm_enabled = visual_confirm_enabled;
 
 	if (should_manage_pstate) {
-		for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
 			struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 			if (!pipe->stream)
@@ -472,7 +471,6 @@ bool dc_dmub_srv_p_state_delegate(struct
 				cmd.fw_assisted_mclk_switch.config_data.vactive_stretch_margin_us = dc->debug.fpo_vactive_margin_us;
 				break;
 			}
-			pipe_idx++;
 		}
 	}
 
@@ -872,7 +870,7 @@ void dc_dmub_setup_subvp_dmub_command(st
 		bool enable)
 {
 	uint8_t cmd_pipe_index = 0;
-	uint32_t i, pipe_idx;
+	uint32_t i;
 	uint8_t subvp_count = 0;
 	union dmub_rb_cmd cmd;
 	struct pipe_ctx *subvp_pipes[2];
@@ -899,7 +897,7 @@ void dc_dmub_setup_subvp_dmub_command(st
 
 	if (enable) {
 		// For each pipe that is a "main" SUBVP pipe, fill in pipe data for DMUB SUBVP cmd
-		for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
 			struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 			pipe_mall_type = dc_state_get_pipe_subvp_type(context, pipe);
 
@@ -922,7 +920,6 @@ void dc_dmub_setup_subvp_dmub_command(st
 				populate_subvp_cmd_vblank_pipe_info(dc, context, &cmd, pipe, cmd_pipe_index++);
 
 			}
-			pipe_idx++;
 		}
 		if (subvp_count == 2) {
 			update_subvp_prefetch_end_to_mall_start(dc, context, &cmd, subvp_pipes);


