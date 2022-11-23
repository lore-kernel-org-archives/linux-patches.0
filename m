Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6281C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC86C433D6;
	Wed, 23 Nov 2022 09:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196528;
	bh=Mw8TLCt2WFyOkNt3qgLi05EIYzHnLchcXcQJD7OwzqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiz8BQrrD+Mtr5s5z7aV2zupCsBg/1Wc33VpoGu5BxS+l3+MWOb+BPdRN4Yu+rkXT
	 Mvibjns6OnUaKHGQZMxa4lMoHIFlA765TaOgsWxr/u0OO3il7JZyJQ99kiRf4FBKk2
	 +/qcGAaEIdJ3J/wUXqLn6Uc9rqE8c8FLYq+ZGRIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Dhere <Chaitanya.Dhere@amd.com>,
	Jasdeep Dhillon <jdhillon@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nevenko Stupar <Nevenko.Stupar@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 056/314] drm/amd/display: Investigate tool reported FCLK P-state deviations
Date: Wed, 23 Nov 2022 09:48:21 +0100
Message-Id: <20221123084628.038013005@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nevenko Stupar <Nevenko.Stupar@amd.com>

[ Upstream commit 7461016c5706eb8c477752bf69e5c9f5a38f502b ]

[Why]
Fix for some of the tool reported modes for FCLK
P-state deviations and UCLK P-state deviations that
are coming from DSC terms and/or Scaling terms
causing MinActiveFCLKChangeLatencySupported
and MaxActiveDRAMClockChangeLatencySupported
incorrectly calculated in DML for these configurations.

Reviewed-by: Chaitanya Dhere <Chaitanya.Dhere@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 6704465fe5b6..ea80874474e3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -364,7 +364,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 	for (k = 0; k < mode_lib->vba.NumberOfActiveSurfaces; ++k) {
 		v->DSCDelay[k] = dml32_DSCDelayRequirement(mode_lib->vba.DSCEnabled[k],
 				mode_lib->vba.ODMCombineEnabled[k], mode_lib->vba.DSCInputBitPerComponent[k],
-				mode_lib->vba.OutputBpp[k], mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
+				mode_lib->vba.OutputBppPerState[mode_lib->vba.VoltageLevel][k],
+				mode_lib->vba.HActive[k], mode_lib->vba.HTotal[k],
 				mode_lib->vba.NumberOfDSCSlices[k], mode_lib->vba.OutputFormat[k],
 				mode_lib->vba.Output[k], mode_lib->vba.PixelClock[k],
 				mode_lib->vba.PixelClockBackEnd[k]);
-- 
2.35.1



