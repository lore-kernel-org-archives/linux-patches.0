Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502A7197532;
	Thu,  6 Jun 2024 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683662; cv=none; b=lu0lrmQYhjPgqoAAdmPYaa/oL2pHcjkWM5eZsxRTBl/ilDuI5tZrpkbDw49O03pdXJLpK0IO7dLu42BX/BQGoT4cW1sfsZqU3rJ2s/6Rnl6eVj7necjhNCIeCqNl+zlch/BZc6y/XG9k2ip2TiKsbSZN/zAhmdLN9olwrZ9cZZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683662; c=relaxed/simple;
	bh=uZ0MqcViAHAL0bcaofzBWTGvjpP7nVPAlXm8pH6rhgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIXtYJEmkCBl8d1QCWQcxccfnh7KYWooimn/jsBBlqKqmQHytVuF9I29KH+HNn4DlSk+efWBVg5316N4qMi6T/1WlUv1O7S0jbRcZ1znijPd/k291lscuZclva5OrsNZn9dUtWD0wr2QtwhmbUYYwa8gNRmVugPkP+7xo29SCqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MlITFWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MlITFWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30540C2BD10;
	Thu,  6 Jun 2024 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683662;
	bh=uZ0MqcViAHAL0bcaofzBWTGvjpP7nVPAlXm8pH6rhgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MlITFWQz2M+aWU1YU3MPR9kTKpziZpsN41kNxzD16ZfQqgePZU30CiPRyb+1jP/t
	 2T3VPlYKHuH6H6/YVkZGXIdumR0wtlJbbZOmEi3eJJkcOTD5Z6ElXKxbYvvKo+OApy
	 E5df24lxzUiEhlYuNY+T2Ex9le1jxT4Z+8atjOkU=
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
Subject: [PATCH 6.6 544/744] drm/amd/display: Remove pixle rate limit for subvp
Date: Thu,  6 Jun 2024 16:03:36 +0200
Message-ID: <20240606131749.899280113@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf3b400c8619b..426902578ca46 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -697,7 +697,6 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 * - Not TMZ surface
 		 */
 		if (pipe->plane_state && !pipe->top_pipe && !dcn32_is_center_timing(pipe) &&
-				!(pipe->stream->timing.pix_clk_100hz / 10000 > DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ) &&
 				(!dcn32_is_psr_capable(pipe) || (context->stream_count == 1 && dc->caps.dmub_caps.subvp_psr)) &&
 				pipe->stream->mall_stream_config.type == SUBVP_NONE &&
 				(refresh_rate < 120 || dcn32_allow_subvp_high_refresh_rate(dc, context, pipe)) &&
-- 
2.43.0



