Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67EE79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A593C433C1;
	Wed, 30 Nov 2022 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833840;
	bh=fu/22SpK8eBQdnDJjS02mQ2q5/4CJH7fZD/cEpfoti0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czmuXR4buc0fbSlazbtgW7iQnsGlnMQsmEqLTlxWbIooWSidvp5x2qWPFHMAp/zw5
	 lhD3KYlA6IrS4MRCWhDmfTC7k732LIkCD3Xu4bVhl16CHHaix7AvI7n/nI8kKwEEy4
	 XKG+70cYpOG0I+7aOLVSkOMzGf8CLITy7FkwbpoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Leung <Martin.Leung@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 034/289] drm/amd/display: Zeromem mypipe heap struct before using it
Date: Wed, 30 Nov 2022 19:20:19 +0100
Message-Id: <20221130180544.906143336@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit ab4b35008db9b7ae747679250e5c26d7c3a90cea ]

[Why&How]
Bug was caused when moving variable from stack to heap because it was reusable
and garbage was left over, so we need to zero mem.

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index bea380407151..042f9a62c4c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -3197,6 +3197,7 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							mode_lib->vba.FCLKChangeLatency, mode_lib->vba.UrgLatency[i],
 							mode_lib->vba.SREnterPlusExitTime);
 
+					memset(&v->dummy_vars.dml32_ModeSupportAndSystemConfigurationFull, 0, sizeof(DmlPipe));
 					v->dummy_vars.dml32_ModeSupportAndSystemConfigurationFull.myPipe.Dppclk = mode_lib->vba.RequiredDPPCLK[i][j][k];
 					v->dummy_vars.dml32_ModeSupportAndSystemConfigurationFull.myPipe.Dispclk = mode_lib->vba.RequiredDISPCLK[i][j];
 					v->dummy_vars.dml32_ModeSupportAndSystemConfigurationFull.myPipe.PixelClock = mode_lib->vba.PixelClock[k];
-- 
2.35.1



