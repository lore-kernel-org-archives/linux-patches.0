Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213751;
	b=QAS8BjRLgRD0r/MvgfZxGMPDhn/UO/1D9JlMzigEZ3a3813rp3I/rz/6xaQ+IayNxFIL
	 Ehh4mS0MBMvbRwvTA8UJZhPN0iAGB6YHeU64hOZuj7HP4i4ub7hGV5V4nIOAJULG+CA3U
	 w/bSIi89eVyWS/CxlPCaOyEymrVAbjYicOFjizpeGHK18fdstnELYpUR7xlzPIRYWusU3
	 35ePclXNmzAVnK3kWmZRcP0kBJQKXj0FcEtovwSc845ayXqEi6fi1rIV00SwNqO6WhtTi
	 NfQA0xjq2iIf8p5Y9NSsMumF1EvaZs+8nrXBZwmZVfp6mmRVhPywNZcmEqArO8deSZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsPOxCeGV1dVFC4AUy/FpjUhYMklo4+e3liuIDfZlBw=;
	b=BwX2FQs1z1lOLB9G9QAqf4ShhFcsBNLgwBcAVfk/G67MkB1MJMkm4szVqub2H6g0KtUh
	 I2s9x5qA4OvT4GTD30XDeNscwGvWn9ENMcRtadxtPGwlrUXaAg1C0JyT4cGMw4jOj2BFd
	 nmuDkA8q2uN3C896X0EwCUXJjuz7g8Li55mXWxCPVyXaEpD0X3s7xsYFO4tgwWC8ojb1j
	 gB6vFz1SvOr866p49rwnIfZbeJ7iCqHhG3qPJrmzkM0XSJHNjUmivaRNPB4CnfwXh9xG9
	 e8skZoHerSTmoh5ArMq1lKMw89OaFf16mn+DVGn7qsDKoTiOfEgGb0M3wyVVsY11fAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVVH4Tzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D2C606A31C;
	Wed, 28 Oct 2026 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVVH4Tzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D911F01825;
	Wed, 28 Oct 2026 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213750;
	bh=IsPOxCeGV1dVFC4AUy/FpjUhYMklo4+e3liuIDfZlBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVVH4Tzug87zKGVE7r+E8XbyfZlaseC08AdZ31S0J7hmglXu4RncwbTtHU39KInU6
	 S0TJCasLLlY0fIWezRJFCZnWyPkUMECVL4TPsoB+YU5AocVL3uaxRodpAp22rVPqo5
	 8IxbC0nbw0BOHL1EOJcWF0l5ww6tEH1IdmPQuqbk=
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
Subject: [PATCH 6.1 0579/1887] drm/amd/display: Add NULL test for timing generator in dcn21_set_pipe()
Date: Wed, 28 Oct 2026 17:44:35 +0100
Message-ID: <20261028170512.592453743@linuxfoundation.org>
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

[ Upstream commit 66951d98d9bf45ba25acf37fe0747253fafdf298 ]

In "u32 otg_inst = pipe_ctx->stream_res.tg->inst;"
pipe_ctx->stream_res.tg could be NULL, it is relying on the caller to
ensure the tg is not NULL.

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
index 69cc192a7e719..13340ea84e7d0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c
@@ -182,17 +182,22 @@ void dcn21_set_abm_immediate_disable(struct pipe_ctx *pipe_ctx)
 void dcn21_set_pipe(struct pipe_ctx *pipe_ctx)
 {
 	struct abm *abm = pipe_ctx->stream_res.abm;
-	uint32_t otg_inst = pipe_ctx->stream_res.tg->inst;
+	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 	struct panel_cntl *panel_cntl = pipe_ctx->stream->link->panel_cntl;
 	struct dmcu *dmcu = pipe_ctx->stream->ctx->dc->res_pool->dmcu;
+	uint32_t otg_inst;
+
+	if (!abm || !tg || !panel_cntl)
+		return;
+
+	otg_inst = tg->inst;
 
 	if (dmcu) {
 		dce110_set_pipe(pipe_ctx);
 		return;
 	}
 
-	if (abm && panel_cntl)
-		dmub_abm_set_pipe(abm, otg_inst, SET_ABM_PIPE_NORMAL, panel_cntl->inst);
+	dmub_abm_set_pipe(abm, otg_inst, SET_ABM_PIPE_NORMAL, panel_cntl->inst);
 }
 
 bool dcn21_set_backlight_level(struct pipe_ctx *pipe_ctx,
-- 
2.53.0



