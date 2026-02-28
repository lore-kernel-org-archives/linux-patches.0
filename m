Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310B237522C;
	Sat, 28 Feb 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301557; cv=none; b=gFpZNoF8p3sWTLb4Ku+D2vrrCy7XyHNXddeHN1QZPxaApsOP8OOm9AaiPP04AdxlYocAbq6OVZbdVAsAYeXCAs9qSj4aJmKLBtW9lUJAOUHhe1rUVj0TuUSiUNMOgBhvTd1PzPYtxdTI48Jn054OBYk1IxAC2HIrNBebXLEBEbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301557; c=relaxed/simple;
	bh=t3QFXFkAH8y+7/FFf2NnRYngsvF9FP8JSKr6hBsOYF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5JOx0jQfqt6xNr3CBWISJ1F/aJx2Uxbk/rUApkBuT4mP/pTlp4g9wywsuknY/ytjgayvrZ6O3b1+CoVDvuIPmFGccQ89xUeuNu3vl8vk227nHaQED1JzsNG5WhoXdmwcnCK4TV/JggtQAvWZ4OW1oaIsk2K8Ytga3BSEQHErvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnlv8i0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnlv8i0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0A0C19425;
	Sat, 28 Feb 2026 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301556;
	bh=t3QFXFkAH8y+7/FFf2NnRYngsvF9FP8JSKr6hBsOYF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnlv8i0DQi2D6m+XF0yXBP8lqCLwpTXY29pGucEpShyQL8t7s6bAD8kMwYfUIZf1i
	 BeHFT66ZMXgPZIRrW3lUBDPe6IR8dKoyshoS4kvZDLB+hahq0nc6Kib2Hc2PfTLX4m
	 mAsi21LlbCettp/IPuVqIXBjvatxZFiMurJIs8F0OfTAExErqeiuBMfi710lyMcQ+y
	 TojU17wyskF6ionLcukfPjiywGTmoJNJupexhv7UIev78tK9jQm43SCI+BBgtX6ZRI
	 ElCr8u6C2JgNOfVMI6vCs5d8tmc785KwIvdo/FrKxULyKrJ/ppCluznyRjYt/m8n2m
	 Fe+Y+0R9zw9Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	stable@vger.kernel.org,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 740/752] drm/amd/display: Correct logic check error for fastboot
Date: Sat, 28 Feb 2026 12:47:31 -0500
Message-ID: <20260228174750.1542406-740-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit b6a65009e7ce3f0cc72da18f186adb60717b51a0 ]

[Why]
Fix fastboot broken in driver.
This is caused by an open source backport change 7495962c.

from the comment, the intended check is to disable fastboot
for pre-DCN10. but the logic check is reversed, and causes
fastboot to be disabled on all DCN10 and after.

fastboot is for driver trying to pick up bios used hw setting
and bypass reprogramming the hw if dc_validate_boot_timing()
condition meets.

Fixes: 7495962cbceb ("drm/amd/display: Disable fastboot on DCE 6 too")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <Mario.Limonciello@amd.com>
Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 65e66bfc4161c..8f86177de48dc 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1933,8 +1933,8 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 
 	get_edp_streams(context, edp_streams, &edp_stream_num);
 
-	/* Check fastboot support, disable on DCE 6-8 because of blank screens */
-	if (edp_num && edp_stream_num && dc->ctx->dce_version < DCE_VERSION_10_0) {
+	/* Check fastboot support, disable on DCE 6-8-10 because of blank screens */
+	if (edp_num && edp_stream_num && dc->ctx->dce_version > DCE_VERSION_10_0) {
 		for (i = 0; i < edp_num; i++) {
 			edp_link = edp_links[i];
 			if (edp_link != edp_streams[0]->link)
-- 
2.51.0

