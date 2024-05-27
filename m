Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACC17727;
	Mon, 27 May 2024 19:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838352; cv=none; b=WABU2Qt5GNjjOjwSLtjYTcaP5fnePXnlSH1X5eiZQOqRW9WDAyvPS8GEmC3HZ4gCnstU9eDYQBJ6SX3VQpvwdluiaeAe26zrstROQLiSCzfCyj8PUnjSIxlhEuPZCNYHqjoq7O2muEA9Fbko2kgYGtkJWKlYs0q17VGuCpF102Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838352; c=relaxed/simple;
	bh=ih1jF0EkennuXq/V7Cpqor1xWJTPyHEkFUspOt8KQHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMVZHX2dcQUano0/oLOjhZ2B7n5J/g1LdiTY2QjhGG7nZDoWFMQnlEun/tMibCGgJmlxPQDQ4aBeIlUADLbaOazPfXvy3tuMxuFkZRJYnj2hqAFdyDPveap1EgJoXxGxG/vbpH0lqlwbHlx+vjCH8Fm7YjJeLAp4X46T2F78Ld8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY4GwtOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY4GwtOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F597C2BBFC;
	Mon, 27 May 2024 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838351;
	bh=ih1jF0EkennuXq/V7Cpqor1xWJTPyHEkFUspOt8KQHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vY4GwtOipsr10khcChIEl/JrU/lPXnQn4FU5BwO3T6iJAa/GnDMtLzNptv8ARQ5Jo
	 Ixzw6fRkz9v2pDPjRmbBhLtM1Jwoza5bH1JHNa+Qd3Gd4auUukT2PACrJ1vuxuba0d
	 o5NjkfO4i1ePmXVlTkk6bO+KkqDBLKMKWhugoYqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
	Harry Wentland <Harry.Wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 361/493] drm/amd/display: Remove redundant condition in dcn35_calc_blocks_to_gate()
Date: Mon, 27 May 2024 20:56:03 +0200
Message-ID: <20240527185642.090778802@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit a43dbeaba81eb645a12a004c67722c632ed0d94b ]

pipe_ctx->plane_res.mpcc_inst is of a type that can only hold values
between 0 and 255, so it's always greater than or equal to 0.

Thus the condition 'pipe_ctx->plane_res.mpcc_inst >= 0' was always true
and has been removed.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn35/dcn35_hwseq.c:1023 dcn35_calc_blocks_to_gate() warn: always true condition '(pipe_ctx->plane_res.mpcc_inst >= 0) => (0-255 >= 0)'

Fixes: 6f8b7565cca4 ("drm/amd/display: Add DCN35 HWSEQ")
Cc: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 46cbb5a6c8e74..1a3c212ae63c8 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -999,8 +999,7 @@ void dcn35_calc_blocks_to_gate(struct dc *dc, struct dc_state *context,
 		if (pipe_ctx->plane_res.dpp)
 			update_state->pg_pipe_res_update[PG_DPP][pipe_ctx->plane_res.hubp->inst] = false;
 
-		if ((pipe_ctx->plane_res.dpp || pipe_ctx->stream_res.opp) &&
-			pipe_ctx->plane_res.mpcc_inst >= 0)
+		if (pipe_ctx->plane_res.dpp || pipe_ctx->stream_res.opp)
 			update_state->pg_pipe_res_update[PG_MPCC][pipe_ctx->plane_res.mpcc_inst] = false;
 
 		if (pipe_ctx->stream_res.dsc)
-- 
2.43.0



