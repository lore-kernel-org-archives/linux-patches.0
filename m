Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689212CD88;
	Tue, 26 Aug 2025 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212990; cv=none; b=BEo1dlwzbWZEjLaKZ1XjYLp36SQf2SgPFTbAoCgSea9TAKcnfFKiBtJRtjMNkhcz+JwJH5pIgAcprhAZ7BP4RgpCeJ4wTpZD2HVDZQFOWo5jSAZeOIGzrnXWibkntMQZtyiEBHAHyb4UHlTStS4nOTYojlQpAczpn/XwNb1Uzms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212990; c=relaxed/simple;
	bh=Z42X4WOu3uY5iIBakE4Q4BJ1TlyWiEfpSs9bon0Dcos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXi73g2b7yUoNrjcM6CntKrnNGsF9SSl44DPdD5x561sAq50jjtJk0XK378siZmC/CkNCX7BB2qs8MxG+57RqV6huoCH34sw0kCfyqa3u/K5Mu0IRX8Or0Ly036Fil/TDWpEVFV4y8gaStLKA2EXQo7TQiwo8k/va9wSiKD3V5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BLBWTDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BLBWTDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E43C4CEF1;
	Tue, 26 Aug 2025 12:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212990;
	bh=Z42X4WOu3uY5iIBakE4Q4BJ1TlyWiEfpSs9bon0Dcos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BLBWTDaAb9Pv3NWTkMFaYPSOimqoTvr5as58uxT12tObAbtWRrnT+SOz6cH5ROh/
	 6vgjwJTX+BmYIQXmkWprBiX24WiECLK0MYP99dLOc0Dhid5oJY/q+E1scUZ3Y9Pc0C
	 JIbMZBsLxWs14DkwAXITUS/zrW0/s7k+UHsvoJ6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/587] drm/amd/display: Separate set_gsl from set_gsl_source_select
Date: Tue, 26 Aug 2025 13:05:28 +0200
Message-ID: <20250826110957.495328645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 660a467a5e7366cd6642de61f1aaeaf0d253ee68 ]

[Why/How]
Separate the checks for set_gsl and set_gsl_source_select, since
source_select may not be implemented/necessary.

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a825fd6c7fa6..f3c682c7fbe6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -163,14 +163,13 @@ static void dcn20_setup_gsl_group_as_lock(
 	}
 
 	/* at this point we want to program whether it's to enable or disable */
-	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL &&
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL) {
+	if (pipe_ctx->stream_res.tg->funcs->set_gsl != NULL) {
 		pipe_ctx->stream_res.tg->funcs->set_gsl(
 			pipe_ctx->stream_res.tg,
 			&gsl);
-
-		pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
-			pipe_ctx->stream_res.tg, group_idx,	enable ? 4 : 0);
+		if (pipe_ctx->stream_res.tg->funcs->set_gsl_source_select != NULL)
+			pipe_ctx->stream_res.tg->funcs->set_gsl_source_select(
+				pipe_ctx->stream_res.tg, group_idx, enable ? 4 : 0);
 	} else
 		BREAK_TO_DEBUGGER();
 }
-- 
2.39.5



