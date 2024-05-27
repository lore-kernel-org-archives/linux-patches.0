Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E3B17E90E;
	Mon, 27 May 2024 19:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837033; cv=none; b=FLtPq+N9OB7kvBbEjn45Kb2stG+2TsWpjcpNCd72m1Rpd041e9sg8kONCw286hpYwxtV3RtOr9dNyLxe6EuOn208DjIKZvtl+zYmsSUgz13r/a06u4PdCvO+Gov+XJo6/UNarSdVs0L85p3rh6N3uu/6+tXYegCPVVknmThplpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837033; c=relaxed/simple;
	bh=nmm9roPr9nAHfmBNea/JF2SoSNbz+dAJ0YDI3QMyMuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrJEzq5kJs1Hb+MDAZ+2OOhO5pKJiJeptbP4Q9dE9az+vHB5N9XemK4Ccy91NjMaPuQaT5zWCePI669F2duSkTOh9urB05xSRctxaVnMAQM59VMq42R2RFK1jB4UQU5L/DQBLlsg/yCIqySDDR1dPzR0d0IGec8CK1UyIViF0/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWOtuFM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWOtuFM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90768C32782;
	Mon, 27 May 2024 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837032;
	bh=nmm9roPr9nAHfmBNea/JF2SoSNbz+dAJ0YDI3QMyMuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWOtuFM5r43x+oPM/fPz3InX/udmpDUnLTdNgrPt/OpjsGcgyGeIUBDZSXDs9o95w
	 9yjrwsigP2cjKemickDBetXTB4b3fTKhK+eM5T2tDSLKvR493V3fzp6l7YKGDHsht5
	 SF+kT68xksFwUhl23FVljjJ2/6SFw5aS2vN/Mbao=
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
Subject: [PATCH 6.9 285/427] drm/amd/display: Remove redundant condition in dcn35_calc_blocks_to_gate()
Date: Mon, 27 May 2024 20:55:32 +0200
Message-ID: <20240527185629.105269212@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9067ca78f8511..a14f99f4f14a5 100644
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



