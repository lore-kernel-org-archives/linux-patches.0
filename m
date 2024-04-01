Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD891383BA;
	Mon,  1 Apr 2024 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987282; cv=none; b=aIFgOH7lRgnG9TIYba3P0rAgXi5WUevIKxOJ1Ga+VkId+WSYBuldDGxBM54xkeyOct1miBXujuQdvJmKNEjY/CGZp68hyMAukl2E2fXSCVw8CzFMKyMlaSdfM8/5zZMSIfjlOIbu08P1SPmbhohV6V52Gx8KpY4xGnf094/dXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987282; c=relaxed/simple;
	bh=uQZGwpWzddVksrWGpRn+UuqKuWVJobdir5eM/zRpGpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnWg7vSJ6dcGwRvxuwYTvupGbZK0Fx9VxmyKHIWVpowg/i2wZ4ovdAIo8xIeJEfRC1oAdafM0tFIzJswMpeqQ63TcgW9UkxgpaLtrT2wwuppbnu6BP/Vj231fawDSirYAJZeNDSnTpAPs/7n5iZO4CljUgndQd00TCSjxaXjMGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw0Q4NnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw0Q4NnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8BBC433C7;
	Mon,  1 Apr 2024 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987281;
	bh=uQZGwpWzddVksrWGpRn+UuqKuWVJobdir5eM/zRpGpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iw0Q4NnHH589V+BoOlLQWJssxaAEHf/vQOM4iq6sm2J3TZZEDcZwrol1Fk4cOBu0H
	 ELA0DbfJYO4FACrgZZS0sKgGbK2OYbTQO8opKZXMnurmwWsY/TJMbCfkB2wuJ/77C2
	 q1X4Orlqx7uIR0AjS7XjkUUQnD4zW3CdB+5qfBVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 240/399] drm/amd/display: Remove pixle rate limit for subvp
Date: Mon,  1 Apr 2024 17:43:26 +0200
Message-ID: <20240401152556.341054638@linuxfoundation.org>
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

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 340383c734f8a4e1663d26356b35fd8050851168 ]

Subvp bugs related to 8K60 have been fixed, so remove the limit that
blocks 8K60 timings from enabling SubVP.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: cf8c498694a4 ("drm/amd/display: Revert Remove pixle rate limit for subvp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index a0a65e0991041..b49e1dc9d8ba5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -623,7 +623,6 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 * - Not TMZ surface
 		 */
 		if (pipe->plane_state && !pipe->top_pipe && !dcn32_is_center_timing(pipe) &&
-				!(pipe->stream->timing.pix_clk_100hz / 10000 > DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ) &&
 				(!dcn32_is_psr_capable(pipe) || (context->stream_count == 1 && dc->caps.dmub_caps.subvp_psr)) &&
 				dc_state_get_pipe_subvp_type(context, pipe) == SUBVP_NONE &&
 				(refresh_rate < 120 || dcn32_allow_subvp_high_refresh_rate(dc, context, pipe)) &&
-- 
2.43.0



