Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281B56FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C55C433D2;
	Tue, 10 Jan 2023 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374842;
	bh=CsGoQ2IrHByU9mhKoTOCuZGQ2LOapt9Akh6zZPISYBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zweXB+rnVmVHH4acfjsv48TNa/AVX0tOeuX4tOOmOIudxZaTHijtXNrWrS6TBQCNI
	 I7lc1X8CbKjdkVL3/goz11QT3plMw6c8oFPRnJNHr1G4A3jx7dnU6I48ktJoEnkP5P
	 dKJ4zHA7+uV25GLDvNQq6Y7PU2x67KWYkCMHpfj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/159] drm/amd/display: Uninitialized variables causing 4k60 UCLK to stay at DPM1 and not DPM0
Date: Tue, 10 Jan 2023 19:04:59 +0100
Message-Id: <20230110180023.320055502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samson Tam <samson.tam@amd.com>

[ Upstream commit f3c23bea598ab7e8e4b8c5ca66598921310f718e ]

[Why]
SwathSizePerSurfaceY[] and SwathSizePerSurfaceC[] values are uninitialized
 because we are using += instead of = operator.

[How]
Assign values in loop with = operator.

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Samson Tam <samson.tam@amd.com>
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x, 6.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index 5af601cff1a0..b53feeaf5cf1 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -6257,12 +6257,12 @@ bool dml32_CalculateDETSwathFillLatencyHiding(unsigned int NumberOfActiveSurface
 	double SwathSizePerSurfaceC[DC__NUM_DPP__MAX];
 	bool NotEnoughDETSwathFillLatencyHiding = false;
 
-	/* calculate sum of single swath size for all pipes in bytes*/
+	/* calculate sum of single swath size for all pipes in bytes */
 	for (k = 0; k < NumberOfActiveSurfaces; k++) {
-		SwathSizePerSurfaceY[k] += SwathHeightY[k] * SwathWidthY[k] * BytePerPixelInDETY[k] * NumOfDPP[k];
+		SwathSizePerSurfaceY[k] = SwathHeightY[k] * SwathWidthY[k] * BytePerPixelInDETY[k] * NumOfDPP[k];
 
 		if (SwathHeightC[k] != 0)
-			SwathSizePerSurfaceC[k] += SwathHeightC[k] * SwathWidthC[k] * BytePerPixelInDETC[k] * NumOfDPP[k];
+			SwathSizePerSurfaceC[k] = SwathHeightC[k] * SwathWidthC[k] * BytePerPixelInDETC[k] * NumOfDPP[k];
 		else
 			SwathSizePerSurfaceC[k] = 0;
 
-- 
2.35.1



