Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213773;
	b=4P9v67ZOumxnXTHqxOpKd/XHfgpld+KZnicXSS80X1WW7ZwKU9OfiQYay2Zzs5/9ksAR
	 B0S5bfsPzVhHHAbebu0YyeXgEAJ4jaGcKBFljH3sFtFVz8RTKTnI0x6E2WsiLZh8ATvAJ
	 5hXWZsU+LwR5x7AhrzGGzMQWJuWRjHgA80nzWu1P2TDMdSZS8y2A1aiDC0lLsBrefIX3g
	 ufAjIyJNXbndnAZlMEpPgo1zY5mn4mQsXrapnjoUj1n/z7ZpN6jpYXwwHXi1nMIZOUzOu
	 WiqUmCobg/IXn3CdLcbSS+35GVBLDTibiIXHcykEuv7/GdVwNSsGX+aoT5dZHY8pe9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=51g+3I2HTKORk1mFF1gb75CkfimuaoL7jrcc4LBi0WM=;
	b=eYm4KB6rkFPUGvhaSR9TKL+m7RJsE+0zNreLBMoTjjedZEAgj9JKzs78wA7eXkh4qPuZ
	 uB7r4kVOMhjNQfBESaGqI0C9GDJ+8FW0RhkQ7nrFEVsjf++12L+iBQHO4r8yujcJE5BpW
	 +7ISTS58dF2DGwff6NgccpPpgQIKjZIBmBFvz+as0tY7Q8Ew/ef1xL+oJBzlzbfXKQL76
	 daV+qKmZyCWbp4Jf3Jt66Rnv47FbpcxjlEd+1Esvf41GFDftgyiHYvHT3yJaUSe99pI1s
	 /BOsb65G0U9DdmjtG3AyPfK8wbUMwfIGBxhpgzxbjpAyy7cjpWpC/rseaapEhGcCWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqOMHF8v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343F606A31A;
	Wed, 28 Oct 2026 18:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqOMHF8v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9841F1F01825;
	Wed, 28 Oct 2026 18:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213773;
	bh=51g+3I2HTKORk1mFF1gb75CkfimuaoL7jrcc4LBi0WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqOMHF8v6ovKTPSw0XOaLq/2UKYKxNGYz1HxfC5QtrTViaOA7lYcKS7vqoSZRcX3O
	 dlNly+nJV4WmcTKJCREfnvl4gejXLlcKw6cBL9tY46Be40m4k4Gn64JwlUAd1wm5O0
	 dGb2+KBwJzaOjU4RqZyHIxFrOp6MBYoB6s7sJRA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <yongqiang.sun@amd.com>,
	Anthony Koo <Anthony.Koo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0580/1887] drm/amd/display: Fix panel_cntl could be null in dcn21_set_backlight_level()
Date: Wed, 28 Oct 2026 17:44:36 +0100
Message-ID: <20261028170512.616489617@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e96fddb32931d007db12b1fce9b5e8e4c080401b ]

'panel_cntl' structure used to control the display panel could be null,
dereferencing it could lead to a null pointer access.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn21/dcn21_hwseq.c:269 dcn21_set_backlight_level() error: we previously assumed 'panel_cntl' could be null (see line 250)

Fixes: 474ac4a875ca ("drm/amd/display: Implement some asic specific abm call backs.")
Cc: Yongqiang Sun <yongqiang.sun@amd.com>
Cc: Anthony Koo <Anthony.Koo@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
index 13340ea84e7d0..5910cde0408d0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
@@ -207,16 +207,21 @@ bool dcn21_set_backlight_level(struct pipe_ctx *pipe_ctx,
 	union dmub_rb_cmd cmd;
 	struct dc_context *dc = pipe_ctx->stream->ctx;
 	struct abm *abm = pipe_ctx->stream_res.abm;
-	uint32_t otg_inst = pipe_ctx->stream_res.tg->inst;
+	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 	struct panel_cntl *panel_cntl = pipe_ctx->stream->link->panel_cntl;
+	uint32_t otg_inst;
+
+	if (!abm || !tg || !panel_cntl)
+		return false;
+
+	otg_inst = tg->inst;
 
 	if (dc->dc->res_pool->dmcu) {
 		dce110_set_backlight_level(pipe_ctx, backlight_pwm_u16_16, frame_ramp);
 		return true;
 	}
 
-	if (abm && panel_cntl)
-		dmub_abm_set_pipe(abm, otg_inst, SET_ABM_PIPE_NORMAL, panel_cntl->inst);
+	dmub_abm_set_pipe(abm, otg_inst, SET_ABM_PIPE_NORMAL, panel_cntl->inst);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abm_set_backlight.header.type = DMUB_CMD__ABM;
-- 
2.53.0



