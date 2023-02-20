Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8763BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D841C4339B;
	Mon, 20 Feb 2023 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901551;
	bh=VloG9acZa/PwwsJWfuSKaf8CoTxyQm2FyMJ/VwbdQes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyUolI2skzED3iNaPbmI/sF1gKk8K04MSDvOTSuDgb72Dx7EQAQxiwA0KtgL2Amym
	 DUNl/FOUch5x1V/9q2cHGsa0RMtUlXQETP7AwHL0S/j5/sStyuBvVR66TAJH9qAGXv
	 fBoslTeewhq9fux623fadaMR5n00SEElEjY5bH0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Miess <Daniel.Miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/118] drm/amd/display: Add missing brackets in calculation
Date: Mon, 20 Feb 2023 14:35:49 +0100
Message-Id: <20230220133601.751787572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Miess <Daniel.Miess@amd.com>

[ Upstream commit ea062fd28f922cb118bfb33229f405b81aff7781 ]

[Why]
Brackets missing in the calculation for MIN_DST_Y_NEXT_START

[How]
Add missing brackets for this calculation

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Daniel Miess <Daniel.Miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index 0d12fd079cd61..3afd3c80e6da8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -3184,7 +3184,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		} else {
 			v->MIN_DST_Y_NEXT_START[k] = v->VTotal[k] - v->VFrontPorch[k] + v->VTotal[k] - v->VActive[k] - v->VStartup[k];
 		}
-		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / (double)v->HTotal[k] / v->PixelClock[k], 1.0) / 4.0;
+		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / ((double)v->HTotal[k] / v->PixelClock[k]), 1.0) / 4.0;
 		if (((v->VUpdateOffsetPix[k] + v->VUpdateWidthPix[k] + v->VReadyOffsetPix[k]) / v->HTotal[k])
 				<= (isInterlaceTiming ?
 						dml_floor((v->VTotal[k] - v->VActive[k] - v->VFrontPorch[k] - v->VStartup[k]) / 2.0, 1.0) :
-- 
2.39.0



