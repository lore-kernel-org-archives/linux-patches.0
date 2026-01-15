Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2778C3C008A;
	Thu, 15 Jan 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496757; cv=none; b=XpCXjF/LtwPfMbzHXfU+hSWz0/wM+x5rkBm51X1JSEY+eXB+xo/1K8GHywdjoJ70XCMZw+fOtaTE2hCOWIBqhX8+bfFPz3OssUDMvG1IaosrOT+4EC1iQi3PyrT5mn3eJ1AozojjhAhKvEC+QEfLsEa98etJDqtJnYtwAxPAp7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496757; c=relaxed/simple;
	bh=xlsFkmIequumzM1aVcg93vZgYtnpM53vwiGpOFsif3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeNJl+7yqvbYZkN78da8ylgIcyzmGfAxItN/YuMZCU7l+v4xu9DnfKtqIL+unkPxEcdEW2PnCBrCm2FrzlvadnOrN0PQwyp17zfrI1cO7Pb1WAL/gDluUOjOtaUzlU7OJBU0cd60dxvSYBbuPbEaC4wIoZIbfXJ/o/5dga3SmYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSndsRaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSndsRaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749B6C116D0;
	Thu, 15 Jan 2026 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496756;
	bh=xlsFkmIequumzM1aVcg93vZgYtnpM53vwiGpOFsif3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSndsRaBTqajQbSCp3CVQrVbDJRZG/7ko5l1VNpSrreLB335PDf6rhJYAFdPbnhqY
	 OhoeKp+vTU472t89D4+Ab1TR+yBIl6z4oEBMSPgAiYW4hb+IzMvbO6/oxpnJDISurt
	 I0dE8Rq/6/1/1YumFyYqDsXhFdFyyDZhQPXxbCsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swapnil Patel <swapnil.patel@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/119] drm/amd/display: Fix DP no audio issue
Date: Thu, 15 Jan 2026 17:48:42 +0100
Message-ID: <20260115164155.814085598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 3886b198bd6e49c801fe9552fcfbfc387a49fbbc ]

[why]
need to enable APG_CLOCK_ENABLE enable first
also need to wake up az from D3 before access az block

Reviewed-by: Swapnil Patel <swapnil.patel@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bf5e396957acafd46003318965500914d5f4edfa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 13e7c253ad697..31c7dfff27cbb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1096,13 +1096,13 @@ void dce110_enable_audio_stream(struct pipe_ctx *pipe_ctx)
 			if (dc->current_state->res_ctx.pipe_ctx[i].stream_res.audio != NULL)
 				num_audio++;
 		}
+		if (num_audio >= 1 && clk_mgr->funcs->enable_pme_wa) {
+			/*wake AZ from D3 first before access az endpoint*/
+			clk_mgr->funcs->enable_pme_wa(clk_mgr);
+		}
 
 		pipe_ctx->stream_res.audio->funcs->az_enable(pipe_ctx->stream_res.audio);
 
-		if (num_audio >= 1 && clk_mgr->funcs->enable_pme_wa)
-			/*this is the first audio. apply the PME w/a in order to wake AZ from D3*/
-			clk_mgr->funcs->enable_pme_wa(clk_mgr);
-
 		link_hwss->enable_audio_packet(pipe_ctx);
 
 		if (pipe_ctx->stream_res.audio)
-- 
2.51.0



