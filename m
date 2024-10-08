Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C101DED6A;
	Tue,  8 Oct 2024 12:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390167; cv=none; b=hHVmIEyH8+Zf1Ip8j+OAIqTFBrGOgmQgzr9syZ7XoiVWi5c/VWpiJLWOTDgd91RYVawOPbCR29CXYVZ+N9WjIbETbBEuRPb/BayrkOkp+pf0hOmszWExbj7UNXvL/XemLJvuk68PjtK8RYvg4eLsozmoYhBleoDJti/Gg9+aqsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390167; c=relaxed/simple;
	bh=N59SpeQNlDpo8C41FrMrbdXm60iYAcRb866B77Gcjy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCHj/Rcbkp5zAD6LyWIy8MJz+GR+gITAfGzA66R8vWGzOlsCOzkU5cefs01Y2Aagr8q0sNcKgbyE5PPtvN3g9fOna3eLmlQkTPECpG8HPhnLbw12U9FB6PgFqPuDYlc+d5uilVDm4Hcj0nUyjgR1nqjy0hzyDFJIOt0hpQw4Yuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhOXd8r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhOXd8r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1C3C4CEC7;
	Tue,  8 Oct 2024 12:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390167;
	bh=N59SpeQNlDpo8C41FrMrbdXm60iYAcRb866B77Gcjy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhOXd8r/X6n5J9jyL+QynImPpvhD240dZQajusGETBNTCg7G+XbYriWCZ0pTjOTGc
	 WLIaeNvF+rgW0xL5/ZjlsMmFtL3RtIz71QTzkIG0B3yz02qMVfXOp4JyquPsTPOHKr
	 TRGcRAtDEr7EX2dk09vr/lw8b5nT6cR3aoATfhh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 210/482] drm/amd/display: Check null-initialized variables
Date: Tue,  8 Oct 2024 14:04:33 +0200
Message-ID: <20241008115656.574347403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 367cd9ceba1933b63bc1d87d967baf6d9fd241d2 ]

[WHAT & HOW]
drr_timing and subvp_pipe are initialized to null and they are not
always assigned new values. It is necessary to check for null before
dereferencing.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index ebcf5ece209a4..bf8c89fe95a7e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -871,8 +871,9 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context)
 	 * for VBLANK: (VACTIVE region of the SubVP pipe can fit the MALL prefetch, VBLANK frame time,
 	 * and the max of (VBLANK blanking time, MALL region)).
 	 */
-	if (stretched_drr_us < (1 / (double)drr_timing->min_refresh_in_uhz) * 1000000 * 1000000 &&
-			subvp_active_us - prefetch_us - stretched_drr_us - max_vblank_mallregion > 0)
+	if (drr_timing &&
+	    stretched_drr_us < (1 / (double)drr_timing->min_refresh_in_uhz) * 1000000 * 1000000 &&
+	    subvp_active_us - prefetch_us - stretched_drr_us - max_vblank_mallregion > 0)
 		schedulable = true;
 
 	return schedulable;
@@ -937,7 +938,7 @@ static bool subvp_vblank_schedulable(struct dc *dc, struct dc_state *context)
 		if (!subvp_pipe && pipe_mall_type == SUBVP_MAIN)
 			subvp_pipe = pipe;
 	}
-	if (found) {
+	if (found && subvp_pipe) {
 		phantom_stream = dc_state_get_paired_subvp_stream(context, subvp_pipe->stream);
 		main_timing = &subvp_pipe->stream->timing;
 		phantom_timing = &phantom_stream->timing;
-- 
2.43.0



