Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C2F1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D947CC433C8;
	Fri, 21 Jul 2023 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965735;
	bh=zC1vTmVhfQpcCAsjVQcbENH+0gqeer3DyWKWUYwnyYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NcWhRLj1XR1CnmSx/sKFVNSXz50IsNx3h43SCcKltHAT+fB23+yrv83RycA0duiE
	 5Y8BAGrN4rcQQKlJZ14xSZEbBh/smudYaQQb79vnEBGAaQM4/22+zyx5sasL9jREr6
	 gefuIFltaquJBYE1HRj9dq8no+4xQZ2TvIsb2Uhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Chalmers <Wesley.Chalmers@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/532] drm/amd/display: Add logging for display MALL refresh setting
Date: Fri, 21 Jul 2023 17:59:59 +0200
Message-ID: <20230721160619.731045774@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit cd8f067a46d34dee3188da184912ae3d64d98444 ]

[WHY]
Add log entry for when display refresh from MALL
settings are sent to SMU.

Fixes: 1664641ea946 ("drm/amd/display: Add logger for SMU msg")
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr_smu_msg.c   | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr_smu_msg.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr_smu_msg.c
index 8ecc708bcd9ec..766759420eebb 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr_smu_msg.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr_smu_msg.c
@@ -302,6 +302,9 @@ void dcn30_smu_set_display_refresh_from_mall(struct clk_mgr_internal *clk_mgr, b
 	/* bits 8:7 for cache timer scale, bits 6:1 for cache timer delay, bit 0 = 1 for enable, = 0 for disable */
 	uint32_t param = (cache_timer_scale << 7) | (cache_timer_delay << 1) | (enable ? 1 : 0);
 
+	smu_print("SMU Set display refresh from mall: enable = %d, cache_timer_delay = %d, cache_timer_scale = %d\n",
+		enable, cache_timer_delay, cache_timer_scale);
+
 	dcn30_smu_send_msg_with_param(clk_mgr,
 			DALSMC_MSG_SetDisplayRefreshFromMall, param, NULL);
 }
-- 
2.39.2



