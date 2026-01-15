Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7EB3B530C;
	Thu, 15 Jan 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496372; cv=none; b=M15C6ibz+XfWkZ18Q0EEEdoJJmPlS5yCRKi+7pOFMqjGt7gU0oFyTGxZchg+7NB8MDNqCdjOkaJYUzJgGBcHQl3VBvr6TUHwzNpHnlx8Yq6bdc+wP7/ulKK5N4NPW6m3IFvcPxZ50NeLuQtaOyFwb36TDuzvdlwl86gDjDYCtZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496372; c=relaxed/simple;
	bh=bIsRjZKxwN0cx96xj5wL2NRYJzoZTkYOzOX5Sisau7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPOFG2nm+TAC0u/QQ44/fztflv9NcVjrfy1DPf6hsUNrBJ0Yrqj6QwU+OJ9n1Sj2l5ZeRWDczX6QcoEO58rRj5Xcka7S9tAMU97mLuvIUbzT2UZB0AF7LCX+vFekgzBv65jcFwPAZFxwy3HB8yRwTTWkTArXFJvCJtkeO//v5qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVRoPmET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVRoPmET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B6FC116D0;
	Thu, 15 Jan 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496372;
	bh=bIsRjZKxwN0cx96xj5wL2NRYJzoZTkYOzOX5Sisau7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVRoPmETBFejyUWN4CIji2ZajBsstEQhbVf4ezJOGkCZLA8kSyewAKITwJrt3VrZu
	 varOEd5TuFz9KbhSg6W87T+7g1x2/pzhFH8ETYMlb6EYR9OP6Sjq4vwt9v6Q8T0/1I
	 CHDXl0fsB90ucqMt4E+uwUpfiIUJgf3xqZuk7RMQ=
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
Subject: [PATCH 6.18 171/181] drm/amd/display: Fix DP no audio issue
Date: Thu, 15 Jan 2026 17:48:28 +0100
Message-ID: <20260115164208.486441383@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b94fec8347400..39be5a58f837a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1098,13 +1098,13 @@ void dce110_enable_audio_stream(struct pipe_ctx *pipe_ctx)
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



