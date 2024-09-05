Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F7A197A92;
	Thu,  5 Sep 2024 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529876; cv=none; b=AzDKM52BJUuY0AmzQYG2osN21M8mF/SPOJgsDi6n6KTkE1JJ8Za9huXYN1o1NO/sH1J56XyZmbNYjwt6Mq+LIeyV1/fZ8o7ua7L6yrMDR5sh4pUMhWVo9VOmpCWC8fdqRrWh9aQiEr3peewHYoScmuRaqalnZ66NPafSA6crkDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529876; c=relaxed/simple;
	bh=bhrwMcy3kuvrLPsaIf3IEwoRh8BPQ7Q9DqQDYrZkPME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C76cpA24wBxBNmUtAqvI/IMlrhdSYQoDadBgwQwLY+LMpF+mHk02ZJrOJfsQVroOHu2ifxI8O+CmUtAEVNSumAUhHW3LIhWhBWxqJPRj2CiPNGtJQ/79fW1+3QXSd1//2N25jexeEfeZLWT+wE/0QDFF67HUv6vX/7W31iXLra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj9bg5Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj9bg5Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A8C4CEC3;
	Thu,  5 Sep 2024 09:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529876;
	bh=bhrwMcy3kuvrLPsaIf3IEwoRh8BPQ7Q9DqQDYrZkPME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj9bg5ZwODCRAOeksonDbQ+jmQMxjMRK9ccb8N1Gj+ZMpAaCxMfbQI3OAqTW0TixU
	 g24CL5yqqAKdIKITiJ23iMTBih3x1ZcsRNcvf87k6J10f9gHRMno52wVyWAR2/2OI2
	 Wbe+RATM3vLVje8BwzlMKpZT1kQW4vl8+zMayeFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duncan Ma <duncan.ma@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 170/184] drm/amd/display: Remove register from DCN35 DMCUB diagnostic collection
Date: Thu,  5 Sep 2024 11:41:23 +0200
Message-ID: <20240905093738.975677015@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 466423c6dd8af23ebb3a69d43434d01aed0db356 ]

[Why]
These registers should not be read from driver and triggering the
security violation when DMCUB work times out and diagnostics are
collected blocks Z8 entry.

[How]
Remove the register read from DCN35.

Reviewed-by: Duncan Ma <duncan.ma@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
index 70e63aeb8f89..a330827f900c 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
@@ -459,7 +459,7 @@ uint32_t dmub_dcn35_get_current_time(struct dmub_srv *dmub)
 void dmub_dcn35_get_diagnostic_data(struct dmub_srv *dmub, struct dmub_diagnostic_data *diag_data)
 {
 	uint32_t is_dmub_enabled, is_soft_reset, is_sec_reset;
-	uint32_t is_traceport_enabled, is_cw0_enabled, is_cw6_enabled;
+	uint32_t is_traceport_enabled, is_cw6_enabled;
 
 	if (!dmub || !diag_data)
 		return;
@@ -510,9 +510,6 @@ void dmub_dcn35_get_diagnostic_data(struct dmub_srv *dmub, struct dmub_diagnosti
 	REG_GET(DMCUB_CNTL, DMCUB_TRACEPORT_EN, &is_traceport_enabled);
 	diag_data->is_traceport_en  = is_traceport_enabled;
 
-	REG_GET(DMCUB_REGION3_CW0_TOP_ADDRESS, DMCUB_REGION3_CW0_ENABLE, &is_cw0_enabled);
-	diag_data->is_cw0_enabled = is_cw0_enabled;
-
 	REG_GET(DMCUB_REGION3_CW6_TOP_ADDRESS, DMCUB_REGION3_CW6_ENABLE, &is_cw6_enabled);
 	diag_data->is_cw6_enabled = is_cw6_enabled;
 
-- 
2.43.0



