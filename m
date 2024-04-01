Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F74778B;
	Mon,  1 Apr 2024 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987285; cv=none; b=dFmvCgY8U+hJOkk4njf7XtXgykNV2Dp1qcIOZvznHuxiVZh9CXGXIIhFUMdOVD7KGlHf4r4GE59P77vk4Bg+sGbbRme2jz5qHznlt8jgxjpbOk7DCA//KGJdkrSxPDUUJreTxzgcAS0EzwQFDh/ThzYzb99jmiJ6zgmpgoeeYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987285; c=relaxed/simple;
	bh=P8hFsgEfW1g6//9HhvP5FPw4QQ2QmactZU4+fQLyzEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRWujvnHg5gmlUGhnh8NWCSq0mM+n2kVenBArj0TsC/AohafYe2fnWzrIL98ekl2kb2rtjVgi+UuY/43yxK4tbtU62mS66G/ApdD26PqEf5E0aXfJEg9XPg5jFYaANz7pnqaG1XuVTM7WAtnKUA19DxM+3HXiXVIp7UbVaCkcbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRHqUk64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRHqUk64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88396C433C7;
	Mon,  1 Apr 2024 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987285;
	bh=P8hFsgEfW1g6//9HhvP5FPw4QQ2QmactZU4+fQLyzEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRHqUk64jxuaipUnUsgx8ZKUP2UI1EqM0EgMp1ihIBnXsoFZ/XnXG2uv14TT0pL/M
	 FV25+f/TpPg4ynrz3hlphPPzwgVV8D4myYggPBJJy48Gpd3tGZEyfPGLEGvHT21iCv
	 NJgwVflneMDLKJJOwFOU97fNzS+zmWxib6mI2iLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 241/399] drm/amd/display: Revert Remove pixle rate limit for subvp
Date: Mon,  1 Apr 2024 17:43:27 +0200
Message-ID: <20240401152556.369951674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit cf8c498694a443e28dc1222f3ab94677114a4724 ]

This reverts commit 340383c734f8 ("drm/amd/display: Remove pixle rate
limit for subvp")

[why]
The original commit causes a regression when subvp is applied
on ODM required 8k60hz timing. The display shows black screen
on boot. The issue can be recovered with hotplug. It also causes
MPO to fail. We will temprarily revert this commit and investigate
the root cause further.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Reviewed-by: Martin Leung <martin.leung@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index b49e1dc9d8ba5..a0a65e0991041 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -623,6 +623,7 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 * - Not TMZ surface
 		 */
 		if (pipe->plane_state && !pipe->top_pipe && !dcn32_is_center_timing(pipe) &&
+				!(pipe->stream->timing.pix_clk_100hz / 10000 > DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ) &&
 				(!dcn32_is_psr_capable(pipe) || (context->stream_count == 1 && dc->caps.dmub_caps.subvp_psr)) &&
 				dc_state_get_pipe_subvp_type(context, pipe) == SUBVP_NONE &&
 				(refresh_rate < 120 || dcn32_allow_subvp_high_refresh_rate(dc, context, pipe)) &&
-- 
2.43.0



