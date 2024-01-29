Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F5E15B308;
	Mon, 29 Jan 2024 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548288; cv=none; b=twlhPIEz4fQXhAOQ982Yl8DCHc7RIoXJWyIIWwXa5wU+FoRM3IQqjpfGu/LLvHlJYTZtMdb5L/PPPHGtYkCnpU15sQLmxbkaaSy4F71GS5m/Sf5uoeszA3aQXyW+DNt0TwktS/56qE1fz/lNrUHxPac5xCHmI0FVJf1Uem6i12Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548288; c=relaxed/simple;
	bh=QOrr65D15KklHojKNZ6Zm7tcK6/7Uo4RRUlGzcpccD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFuhadgYk+5wJ/iISzzFJW2To50ZrAiS4StteU4aiy1EBa55OuerugSJ3Ljz69gNvTif4zmm9pgUdKQzDkTo4GPFZBGic3umMQtkpOFJA4rMJ4G+JagmT7nwFv0akyM/aduxXYr37aDtgFgv2afONz/po9IOo5APf5hCVzK8MII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTDHyp3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTDHyp3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BFEC433F1;
	Mon, 29 Jan 2024 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548288;
	bh=QOrr65D15KklHojKNZ6Zm7tcK6/7Uo4RRUlGzcpccD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTDHyp3tG3DQmHAC0SwBTRvXGoPJnM1e8pjw6Jnza91bTLhkVoemriPf5u/rtJOFq
	 Am7V2zbTChDpDmpYbhdtO1NqMICkLxp6c5KcRhkjt8x4BqG0gczximZR90rR6ogOS7
	 cTjn2KYJECat2yYFP2ZTg7RroXZ2a8787e4Jj0iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 299/346] drm/amd/display: Clear OPTC mem select on disable
Date: Mon, 29 Jan 2024 09:05:30 -0800
Message-ID: <20240129170025.213232069@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit 3ba2a0bfd8cf94eb225e1c60dff16e5c35bde1da ]

[Why]
Not clearing the memory select bits prior to OPTC disable can cause DSC
corruption issues when attempting to reuse a memory instance for another
OPTC that enables ODM.

[How]
Clear the memory select bits prior to disabling an OPTC.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
index 1788eb29474b..823493543325 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -173,6 +173,9 @@ static bool optc32_disable_crtc(struct timing_generator *optc)
 			OPTC_SEG3_SRC_SEL, 0xf,
 			OPTC_NUM_OF_INPUT_SEGMENT, 0);
 
+	REG_UPDATE(OPTC_MEMORY_CONFIG,
+			OPTC_MEM_SEL, 0);
+
 	/* disable otg request until end of the first line
 	 * in the vertical blank region
 	 */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
index 3d6c1b2c2b4d..5b1547508850 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_optc.c
@@ -145,6 +145,9 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 			OPTC_SEG3_SRC_SEL, 0xf,
 			OPTC_NUM_OF_INPUT_SEGMENT, 0);
 
+	REG_UPDATE(OPTC_MEMORY_CONFIG,
+			OPTC_MEM_SEL, 0);
+
 	/* disable otg request until end of the first line
 	 * in the vertical blank region
 	 */
-- 
2.43.0



