Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10AE218AAB;
	Mon, 18 Aug 2025 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522267; cv=none; b=nuV8S1JjZyeXgjh5GmVIwyncS20DEViQqGePHsAl0Q7ltT0jKwnCPj7hWbV/S2s0lf0/bSMwi/pXtXKbGdm6O33w5MUkD/88z4uSf2CFE4TfwbkQQ9S/Rl1xYwGt/mvceAkN38UCcOZp5EYUduTk5Ov2e81JAPHCDKjzIDM6hok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522267; c=relaxed/simple;
	bh=fKAjy5YlPLC/80BxTAIjibigXh7h6ej+Xrvj1m10Vgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHnJ4zDwzkZN1cKC3yj5Q35ud4xNbRrZMTcRNLPaq6AtV9G1VvZXmuws6iGRhIn4NUPxX8+NZXNlsS50lpnqqnN+1FepmTVJoLm9sEaoSf81Pm8iMNKWgvtnARORWRd3L94u7rVjehCcf+/zosAmMHLEgjAUThC9oYmRoFXF5C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+QJntGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+QJntGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB4BC113D0;
	Mon, 18 Aug 2025 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522266;
	bh=fKAjy5YlPLC/80BxTAIjibigXh7h6ej+Xrvj1m10Vgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+QJntGMN0MPuZKFVsuMKUtoLPV0G/deNE0XZ4zfZlGzeWLz6Zpn6DqnJ9Wqv5eOe
	 9Qj1PDj+0QemAp1vfsTHzat9p1E+49lOQlr4TnC0U+P0NmaFJpRu8YE8gPAZbCJRsy
	 769bpHcob7jUqhz7aHp68AazzU8ZWH4bTjir+J4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/444] drm/amd/display: Update DMCUB loading sequence for DCN3.5
Date: Mon, 18 Aug 2025 14:44:52 +0200
Message-ID: <20250818124458.807381249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit d42b2331e158fa6bcdc89e4c8c470dc5da20be1f ]

[Why]
New sequence from HW for reset and firmware reloading has been
provided that aims to stabilize the reload sequence in the case the
firmware is hung or has outstanding requests.

[How]
Update the sequence to remove the DMUIF reset and the redundant
writes in the release.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dmub/src/dmub_dcn35.c    | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
index 4581eb479451..01e83c6ce701 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
@@ -92,19 +92,15 @@ void dmub_dcn35_reset(struct dmub_srv *dmub)
 	uint32_t in_reset, is_enabled, scratch, i, pwait_mode;
 
 	REG_GET(DMCUB_CNTL2, DMCUB_SOFT_RESET, &in_reset);
+	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_enabled);
 
-	if (in_reset == 0) {
+	if (in_reset == 0 && is_enabled != 0) {
 		cmd.bits.status = 1;
 		cmd.bits.command_code = DMUB_GPINT__STOP_FW;
 		cmd.bits.param = 0;
 
 		dmub->hw_funcs.set_gpint(dmub, cmd);
 
-		/**
-		 * Timeout covers both the ACK and the wait
-		 * for remaining work to finish.
-		 */
-
 		for (i = 0; i < timeout; ++i) {
 			if (dmub->hw_funcs.is_gpint_acked(dmub, cmd))
 				break;
@@ -130,11 +126,9 @@ void dmub_dcn35_reset(struct dmub_srv *dmub)
 		/* Force reset in case we timed out, DMCUB is likely hung. */
 	}
 
-	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_enabled);
-
 	if (is_enabled) {
 		REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-		REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
+		udelay(1);
 		REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
 	}
 
@@ -160,11 +154,7 @@ void dmub_dcn35_reset_release(struct dmub_srv *dmub)
 		     LONO_SOCCLK_GATE_DISABLE, 1,
 		     LONO_DMCUBCLK_GATE_DISABLE, 1);
 
-	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
-	udelay(1);
 	REG_UPDATE_2(DMCUB_CNTL, DMCUB_ENABLE, 1, DMCUB_TRACEPORT_EN, 1);
-	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-	udelay(1);
 	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 0);
 	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 0);
 }
-- 
2.39.5



