Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A094FDA7E;
	Thu, 17 Sep 2026 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667290; cv=none; b=cGi/B1I5nM/r8sWXrFanVhmDR7KfojJ10dPhg1n98MccyqzHU7fArLJDCKokh1+ZlBs4Gh+juuv4KEHeLPQh9e9uvZcjkruG6Bu2UiZqHFiJngjOTse5BFQaOF/g/xjYlmMCyt3SkfNSvaI2YpYJu3+hw5StYS6Ipy/AVBHbq2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667290; c=relaxed/simple;
	bh=NkGERfC7rk4rfymiETsnhZaVWHU7l/KD/d9OIbNRCjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZiaDo5SbPJaWeIBSv7Ny0zdtW/oUhUSE+TUE538PJQs/q1Y0/h8wv9pMhxBjdlFfOjarp6KjyOo18XlQZ2rqkEGiWkq01nS3f6tH00quzTAOW2abtcduHJa535XXilFt8Uigq0GBZ7tPCs83RFTOqxGJnre024ttNTIdYOZi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1PELWOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1PELWOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B451F000FF;
	Thu, 17 Sep 2026 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667289;
	bh=bVpPPStHmV6uJSVOD3GEYSw1GUVVp3W2kvOA++TUv30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1PELWOL/Cw8FJipKPY0xZ9zDdIXL0ublOAVXwwIh4Hp6WfM5ZWH/Locj+9wDZbOs
	 lA6Kgb6LBGbUiinZBLzDWuTtM+TmuZfXAA7j7Ifs530ViQjQg2IpxpIa7cGI1NxpQ5
	 cd0qHhoLrPXxF4wM8jnRyXy5ObqEZaJOmr/NEcSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	James Lin <pinglei.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0042/1102] drm/amd/display: Find link encoder for flexible DIG mapping cases
Date: Thu, 17 Sep 2026 15:59:45 +0100
Message-ID: <20260917151540.501608094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 74ef54e656e7006cfc215e960b0cf2720a7a3d48 ]

[why & how]
link->link_enc can only be used to identify the link's link encoder
when the link is not permitted to use flexible link encoder
assignments.

Use the correct function for identifying link encoder and add
function pointer guards before calling them.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index dcc78244dd7c3..e7e997feebd6a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1730,20 +1730,22 @@ static void power_down_encoders(struct dc *dc)
 
 	for (i = 0; i < dc->link_count; i++) {
 		struct dc_link *link = dc->links[i];
-		struct link_encoder *link_enc = link->link_enc;
+		struct link_encoder *link_enc = link_enc_cfg_get_link_enc(link);
 		enum signal_type signal = link->connector_signal;
 
 		dc->link_srv->blank_dp_stream(link, false);
 		if (signal != SIGNAL_TYPE_EDP)
 			signal = SIGNAL_TYPE_NONE;
 
-		if (link->ep_type == DISPLAY_ENDPOINT_PHY)
+		if (link->ep_type == DISPLAY_ENDPOINT_PHY && link_enc)
 			link_enc->funcs->disable_output(link_enc, signal);
 
 		if (link->fec_state == dc_link_fec_enabled) {
-			link_enc->funcs->fec_set_enable(link_enc, false);
-			link_enc->funcs->fec_set_ready(link_enc, false);
-			link->fec_state = dc_link_fec_not_ready;
+			if (link_enc && link_enc->funcs->fec_set_enable && link_enc->funcs->fec_set_ready) {
+				link_enc->funcs->fec_set_enable(link_enc, false);
+				link_enc->funcs->fec_set_ready(link_enc, false);
+				link->fec_state = dc_link_fec_not_ready;
+			}
 		}
 
 		link->link_status.link_active = false;
-- 
2.53.0



