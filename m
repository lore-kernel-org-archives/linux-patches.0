Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34281990C1;
	Thu,  5 Sep 2024 09:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529537; cv=none; b=Nia5mXb/oGN2cZOIP5ndMKC1jn78uxbSQn0YXGGqWoN9sY/IlpbMdkCDNBRckSWZ6O5gxc7GVY3DwCcyCFmTDd/s5NxY1hUV+gB5AP5Gl8++Ny4DAtPtSHpj7vU2f33mPBwVwqdTYiOBcuPHxf+ULRQSYiHVkDf0ZJczIbf01qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529537; c=relaxed/simple;
	bh=NwYKLjyFEZVZbAmuXxtBmVJoXqOVMlLoR9JVwvnjHBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkafFhjBLWl4U3NGrr5ZnlujDJF4piD4JoZwP6Y9U9gW/b1Tozgwve0ZL7qK9dt1fcgrKp1qcH6RV7UEsdwXwwOeIOfj6OhtHDfvP+VwCYAQSfNz0xTbr1KD7BbLT4wyU46POvEnECfCPtsl39ZvshUVTgsEMq5mzPlIiThKDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vxhdP5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vxhdP5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0806EC4CEC3;
	Thu,  5 Sep 2024 09:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529536;
	bh=NwYKLjyFEZVZbAmuXxtBmVJoXqOVMlLoR9JVwvnjHBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vxhdP5/ahBtPwClHwUOvIpVUkH204qjoZ2iIrOtq+xX9Tn1ThdpxLin5wxxmNjjM
	 kjN4xLhJPBWnVWx1uUZWocMG8QSt1sN599FekR2LJ2RU3s+tySwWC5ES+QTlseEqfd
	 Cr2HEKicE4jZLn+MUsT+3edDBI+cgeRij5Tq9/2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 057/184] drm/amd/display: Ensure array index tg_inst wont be -1
Date: Thu,  5 Sep 2024 11:39:30 +0200
Message-ID: <20240905093734.468343704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit 687fe329f18ab0ab0496b20ed2cb003d4879d931 ]

[WHY & HOW]
tg_inst will be a negative if timing_generator_count equals 0, which
should be checked before used.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 8ed599324693..ce5adb8bc377 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3508,7 +3508,7 @@ static bool acquire_otg_master_pipe_for_stream(
 		if (pool->dpps[pipe_idx])
 			pipe_ctx->plane_res.mpcc_inst = pool->dpps[pipe_idx]->inst;
 
-		if (pipe_idx >= pool->timing_generator_count) {
+		if (pipe_idx >= pool->timing_generator_count && pool->timing_generator_count != 0) {
 			int tg_inst = pool->timing_generator_count - 1;
 
 			pipe_ctx->stream_res.tg = pool->timing_generators[tg_inst];
-- 
2.43.0



