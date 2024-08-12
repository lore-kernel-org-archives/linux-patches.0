Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64473183CD4;
	Mon, 12 Aug 2024 16:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480181; cv=none; b=Jlz+tLza1mkPdfEToTPyaSwvZOa3OqDlekPfW3pBwVjUjUiy4j1uAeWwiSNg1JdTUyGNUVwujybGK9zrZSY9PUO93DZ9K7G0Xu44yFQowchkSCKNjlrg2cravfJTd7TE56PX+E62B/tBsOzkFWxT4jZzDXEpIuof7FE70b3L95A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480181; c=relaxed/simple;
	bh=zqnbut42tQRkqsKvYt6gV+uFGWhdZ6q1sZ20OBp+IzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIrFWeuQle9PWFG6to8drqahmaYuSdmAyrTV9oN7BkiI2xQu+kqCmtvrC+aMrJShfQJ+q9m/mLudpXkIeWD805FU4XwsElM4TTYccRKoITRjSsh4m053cCar3+4PkAIGJar1mgqPANKkZpgBgTcl38NvpNKJNS+mI94PR16F7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMdmiPb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMdmiPb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EC8C32782;
	Mon, 12 Aug 2024 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480181;
	bh=zqnbut42tQRkqsKvYt6gV+uFGWhdZ6q1sZ20OBp+IzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMdmiPb1s0Nipuu+JZ1cUXLrNmTWBf6W4y+rFbQit0+DI18PrCDjU6cAX1RuUdwL4
	 1NqyADWT1s1taIBlCtkV7G3hhiPtyNERj09fhnGxQruSIuFIMSByOO4Yg09IKY0CZp
	 6WjcK3AOBTf2sFl/kotdqDrORUt45c9iUesBEJPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/263] drm/amd/display: Add delay to improve LTTPR UHBR interop
Date: Mon, 12 Aug 2024 18:01:29 +0200
Message-ID: <20240812160149.914489992@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 10839ee6a977ed1f7d0f4deb29f2d7e5d1f2a9dd ]

[WHY]
Avoid race condition which puts LTTPR into bad state during UHBR LT.

[HOW]
Delay 30ms between starting UHBR TPS1 PHY output and sending TPS1 via DPCD.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c      | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
index 3e6c7be7e2786..5302d2c9c7607 100644
--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_fixed_vs_pe_retimer_dp.c
@@ -165,7 +165,12 @@ static void set_hpo_fixed_vs_pe_retimer_dp_link_test_pattern(struct dc_link *lin
 		link_res->hpo_dp_link_enc->funcs->set_link_test_pattern(
 				link_res->hpo_dp_link_enc, tp_params);
 	}
+
 	link->dc->link_srv->dp_trace_source_sequence(link, DPCD_SOURCE_SEQ_AFTER_SET_SOURCE_PATTERN);
+
+	// Give retimer extra time to lock before updating DP_TRAINING_PATTERN_SET to TPS1
+	if (tp_params->dp_phy_pattern == DP_TEST_PATTERN_128b_132b_TPS1_TRAINING_MODE)
+		msleep(30);
 }
 
 static void set_hpo_fixed_vs_pe_retimer_dp_lane_settings(struct dc_link *link,
-- 
2.43.0



