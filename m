Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1233993;
	Thu, 15 Jan 2026 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497012; cv=none; b=BEXmkmmPuhTqIy+dYSFqEmpfU6v1o2y8cQaS4Qw7R5p7VwHANNoqMc5vXxtGStZiI0jadOT4nCmgnhaiv1NTMp8UcaydnWeLHf8FzGZAM3574W9R1aj7R4Sc5l6GVn05siu4lYNHOOCPTVfr6K8yUNRGM3Z2sgf/FCYNnBhdEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497012; c=relaxed/simple;
	bh=F2Jm2qZm70peYvr5umZSdqfvjX944/1StPFrovCWzOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2ohK7JvaNlR8Ag86HOd+Bbwc/iamCw9jiUi5qfxcqGI5+ezQ3cT3ysJFYoPvjUMKY4I/Lsl/A/tBijIE59ekrs+fpPkoRecjoyMVVTfY7Z+VAqgHMKpQMce/TmzSD9jU1wf5CC9GvbhSfK/iRKI3RvfVvz9V/rFdMZpxsj6ghM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpMNSzYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpMNSzYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA252C116D0;
	Thu, 15 Jan 2026 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497012;
	bh=F2Jm2qZm70peYvr5umZSdqfvjX944/1StPFrovCWzOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpMNSzYDrtgLvJnLFiOV9+fiiOtBFY7iQ1Go0hXJPBTOxlPrFe/SulTK0Z1shkTSX
	 h8/xzxF2YN95TnbSCOlkhaQMx15wkLcTPLzESgzo6N5QA8Byc9kmTMvD8RVhwitDUV
	 All8Dyq9enHtPBt+cWEI7xwuqVykec+6VvR5oFa0=
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
Subject: [PATCH 6.6 81/88] drm/amd/display: Fix DP no audio issue
Date: Thu, 15 Jan 2026 17:49:04 +0100
Message-ID: <20260115164149.248438626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 .../gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c   | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index d389eeb264a79..0172fede51b5b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1097,13 +1097,13 @@ void dce110_enable_audio_stream(struct pipe_ctx *pipe_ctx)
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



