Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A525F1E9B3D;
	Thu,  3 Jul 2025 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555387; cv=none; b=tkRD1PHGZRWgjt8BGjWFRHnCn6kaWKONwEhHdnrUPQGLHP/SXO2r2T7vFJfRXoyb0oAJUmDjFTevnl0i9oiWabB9p64XreuixuTsupyAN+xyQ3n15DlkEEPxtk95zcEzQvg7oyojxFUhJMr+ilQcUQsJNYdahozQeR1KrCz7YUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555387; c=relaxed/simple;
	bh=cX6UzEiUD4oBLRkoH7DZt4nbz816TKQTKcuxiOOMA9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMgl1f+6SrG2GsWz/XPppOGHSqhjn0WQx4rAL5K/Cy2C3MRXpp1d9kZYZSh8hWtBAANvpzv8I6hq9Hfbf2aQVINSPqFsSK0FAkRf+PzfU1MuVsajvKZ6FSgVyECx/7Pvpr2Jz/XDQG6BBEs5sk5Ott83fGhfJjaspU0k9gMGdA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of8Ajnvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of8Ajnvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D16C4CEE3;
	Thu,  3 Jul 2025 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555387;
	bh=cX6UzEiUD4oBLRkoH7DZt4nbz816TKQTKcuxiOOMA9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of8AjnvsXLA2NXcL3/D117ePbZj7D5vljOWoDcn+bS3+Symhj/Ect2LOJ6ybiCp33
	 3+xB05ypmNuM/9ySqb3KfFgO/TJopi05SscN13L5KLQ3L0oXStAkrWY8qzXT1RdzO0
	 aPxksMf/8O511fhpoasiPFB1TmAka5oFbx8teiOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Zhongwei Zhang <Zhongwei.Zhang@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.15 222/263] drm/amd/display: Correct non-OLED pre_T11_delay.
Date: Thu,  3 Jul 2025 16:42:22 +0200
Message-ID: <20250703144013.282783333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongwei Zhang <Zhongwei.Zhang@amd.com>

commit 893f07452bca56ff146a6be02b3294a9ea23d18a upstream.

[Why]
Only OLED panels require non-zero pre_T11_delay defaultly.
Others should be controlled by power sequence.

[How]
For non OLED, pre_T11_delay delay in code should be zero.
Also post_T7_delay.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Zhongwei Zhang <Zhongwei.Zhang@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -952,8 +952,8 @@ void dce110_edp_backlight_control(
 	struct dc_context *ctx = link->ctx;
 	struct bp_transmitter_control cntl = { 0 };
 	uint8_t pwrseq_instance = 0;
-	unsigned int pre_T11_delay = OLED_PRE_T11_DELAY;
-	unsigned int post_T7_delay = OLED_POST_T7_DELAY;
+	unsigned int pre_T11_delay = (link->dpcd_sink_ext_caps.bits.oled ? OLED_PRE_T11_DELAY : 0);
+	unsigned int post_T7_delay = (link->dpcd_sink_ext_caps.bits.oled ? OLED_POST_T7_DELAY : 0);
 
 	if (dal_graphics_object_id_get_connector_id(link->link_enc->connector)
 		!= CONNECTOR_ID_EDP) {
@@ -1069,7 +1069,8 @@ void dce110_edp_backlight_control(
 	if (!enable) {
 		/*follow oem panel config's requirement*/
 		pre_T11_delay += link->panel_config.pps.extra_pre_t11_ms;
-		msleep(pre_T11_delay);
+		if (pre_T11_delay)
+			msleep(pre_T11_delay);
 	}
 }
 


