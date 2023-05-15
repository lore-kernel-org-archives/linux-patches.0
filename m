Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4FAFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779E4C433EF;
	Mon, 15 May 2023 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170123;
	bh=D7f9Y9tCw+eV4lrKpXoQ6qRhWOFr7E2ILvqLevZBWm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTYk4OYduTVUtTMN47JUHrI757/P/s2mJS7Bu6wCgq9Mro+heO1Vl7TnnZVMZOlRz
	 Fd9VJfgZLK+LC5YtkKAdckID25RwDvl07XnMy2jVMbgPGL+w4O4YHKeO8+li6t59F4
	 NWEkuwbIenApR2a3tLh6PV+iHH0ObN0gFsJ9ZeqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/239] drm/amd/display: Do not clear GPINT register when releasing DMUB from reset
Date: Mon, 15 May 2023 18:24:55 +0200
Message-Id: <20230515161722.680286108@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

[ Upstream commit 99d92eaca5d915763b240aae24669f5bf3227ecf ]

[Why & How]
There's no need to clear GPINT register for DMUB
when releasing it from reset. Fix that.

Fixes: ac2e555e0a7f ("drm/amd/display: Add DMCUB source files and changes for DCN32/321")
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
index b0adbf783aae9..9c20516be066c 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
@@ -137,7 +137,6 @@ void dmub_dcn32_reset(struct dmub_srv *dmub)
 
 void dmub_dcn32_reset_release(struct dmub_srv *dmub)
 {
-	REG_WRITE(DMCUB_GPINT_DATAIN1, 0);
 	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 0);
 	REG_WRITE(DMCUB_SCRATCH15, dmub->psp_version & 0x001100FF);
 	REG_UPDATE_2(DMCUB_CNTL, DMCUB_ENABLE, 1, DMCUB_TRACEPORT_EN, 1);
-- 
2.39.2



